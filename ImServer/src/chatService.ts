import { supabase } from './supabase';
import { AuthedUser } from './auth';
import { ConversationRow, MessageRow, UserRole } from './types';

export interface ConversationWithParty extends ConversationRow {
  other_party?: {
    id: number;
    type: 'companion' | 'institution';
    name: string;
    avatar_url?: string | null;
  };
}

const errorWrap = <T>(result: { data: T | null; error: any }) => {
  if (result.error) {
    throw new Error(result.error.message ?? '数据库操作失败');
  }
  return result.data;
};

const ensureParticipant = (conversation: ConversationRow, user: AuthedUser) => {
  const { role, id } = user;
  if (role === 'user' && conversation.user_id !== id) {
    throw new Error('无权访问该会话');
  }
  if (role === 'companion' && conversation.companion_id !== id) {
    throw new Error('无权访问该会话');
  }
  if (role === 'institution' && conversation.institution_id !== id) {
    throw new Error('无权访问该会话');
  }
};

export const fetchConversation = async (conversationId: number): Promise<ConversationRow> => {
  const data = errorWrap(
    await supabase.from('conversations').select('*').eq('id', conversationId).single<ConversationRow>()
  );
  if (!data) {
    throw new Error('会话不存在');
  }
  return data;
};

export const resolveReceiver = (
  conversation: ConversationRow,
  sender: AuthedUser
): { receiverId: number; receiverType: UserRole } => {
  if (sender.role === 'user') {
    if (conversation.companion_id) return { receiverId: conversation.companion_id, receiverType: 'companion' };
    if (conversation.institution_id) return { receiverId: conversation.institution_id, receiverType: 'institution' };
  }
  return { receiverId: conversation.user_id, receiverType: 'user' };
};

export const listConversations = async (
  user: AuthedUser,
  page: number,
  pageSize: number
): Promise<{ list: ConversationWithParty[]; total: number }> => {
  const from = (page - 1) * pageSize;
  const to = from + pageSize - 1;
  let query = supabase.from('conversations').select('*', { count: 'exact' }).eq('status', 'active');

  if (user.role === 'user') {
    query = query.eq('user_id', user.id);
  } else if (user.role === 'companion') {
    query = query.eq('companion_id', user.id);
  } else if (user.role === 'institution') {
    query = query.eq('institution_id', user.id);
  }

  const result = await query.order('updated_at', { ascending: false }).range(from, to);
  const convs = errorWrap(result) ?? [];
  const total = result.count ?? convs.length;

  const companionIds = convs.filter(c => c.companion_id).map(c => c.companion_id!) as number[];
  const institutionIds = convs.filter(c => c.institution_id).map(c => c.institution_id!) as number[];

  const companions =
    companionIds.length > 0
      ? errorWrap(
          await supabase.from('companions').select('id,name,avatar_url').in('id', companionIds).returns<
            { id: number; name: string; avatar_url: string | null }[]
          >()
        ) ?? []
      : [];
  const institutions =
    institutionIds.length > 0
      ? errorWrap(
          await supabase.from('institutions').select('id,name,logo_url').in('id', institutionIds).returns<
            { id: number; name: string; logo_url: string | null }[]
          >()
        ) ?? []
      : [];

  const list: ConversationWithParty[] = convs.map(conv => {
    const data: ConversationWithParty = { ...conv };
    if (conv.companion_id) {
      const found = companions.find(c => c.id === conv.companion_id);
      if (found) {
        data.other_party = { id: found.id, type: 'companion', name: found.name, avatar_url: found.avatar_url };
      }
    } else if (conv.institution_id) {
      const found = institutions.find(i => i.id === conv.institution_id);
      if (found) {
        data.other_party = { id: found.id, type: 'institution', name: found.name, avatar_url: found.logo_url };
      }
    }
    return data;
  });

  return { list, total };
};

export const createConversation = async (
  user: AuthedUser,
  payload: { companionId?: number; institutionId?: number; title?: string }
): Promise<ConversationRow> => {
  if (!payload.companionId && !payload.institutionId) {
    throw new Error('必须指定陪诊师或机构');
  }

  const existing = errorWrap(
    await supabase
      .from('conversations')
      .select('*')
      .eq('user_id', user.id)
      .eq('status', 'active')
      .eq('companion_id', payload.companionId ?? null)
      .eq('institution_id', payload.institutionId ?? null)
      .maybeSingle<ConversationRow>()
  );
  if (existing) return existing;

  const inserted = errorWrap(
    await supabase
      .from('conversations')
      .insert({
        user_id: user.id,
        companion_id: payload.companionId ?? null,
        institution_id: payload.institutionId ?? null,
        title: payload.title ?? '会话',
        status: 'active',
      })
      .select('*')
      .single<ConversationRow>()
  );
  if (!inserted) {
    throw new Error('创建会话失败');
  }
  return inserted;
};

export const appendMessage = async (
  conversation: ConversationRow,
  sender: AuthedUser,
  content: string,
  contentType = 'text'
): Promise<MessageRow> => {
  ensureParticipant(conversation, sender);
  const { receiverId, receiverType } = resolveReceiver(conversation, sender);
  const unreadCount = receiverType === 'user' ? (conversation.unread_count ?? 0) + 1 : conversation.unread_count ?? 0;
  const now = new Date().toISOString();

  const message = errorWrap(
    await supabase
      .from('messages')
      .insert({
        conversation_id: conversation.id,
        sender_id: sender.id,
        sender_type: sender.role,
        receiver_id: receiverId,
        receiver_type: receiverType,
        content_type: contentType,
        content,
        is_read: receiverType !== 'user', // 非用户接收端不计未读
      })
      .select('*')
      .single<MessageRow>()
  );

  if (!message) {
    throw new Error('保存消息失败');
  }

  errorWrap(
    await supabase
      .from('conversations')
      .update({
        last_message: contentType === 'text' ? content : `[${contentType}]`,
        unread_count: unreadCount,
        updated_at: now,
      })
      .eq('id', conversation.id)
  );

  return message;
};

export const loadHistory = async (conversationId: number, before?: string, limit = 50): Promise<MessageRow[]> => {
  let query = supabase
    .from('messages')
    .select('*')
    .eq('conversation_id', conversationId)
    .eq('is_deleted', false)
    .order('created_at', { ascending: false })
    .limit(limit);

  if (before) {
    query = query.lt('created_at', before);
  }

  const rows = errorWrap(await query.returns<MessageRow[]>()) ?? [];
  return rows.sort((a, b) => new Date(a.created_at).getTime() - new Date(b.created_at).getTime());
};

export const markRead = async (conversationId: number, reader: AuthedUser, messageIds?: number[]) => {
  let query = supabase
    .from('messages')
    .update({ is_read: true })
    .eq('conversation_id', conversationId)
    .eq('receiver_id', reader.id)
    .eq('receiver_type', reader.role)
    .eq('is_read', false);
  if (messageIds && messageIds.length > 0) {
    query = query.in('id', messageIds);
  }
  await query;

  if (reader.role === 'user') {
    await supabase.from('conversations').update({ unread_count: 0 }).eq('id', conversationId);
  }
};

export const countUnread = async (user: AuthedUser): Promise<number> => {
  if (user.role !== 'user') return 0;
  const { list } = await listConversations(user, 1, 200); // 简化：最多 200 条统计
  return list.reduce((acc, conv) => acc + (conv.unread_count ?? 0), 0);
};
