import { supabase } from './supabase';
import { AuthedUser } from './auth';
import { ConversationRow, ConversationWithParty, MessageRow } from './types';

/**
 * 用户信息结构
 */
interface UserInfo {
  id: number;
  nickname: string;
  avatar_url: string | null;
  user_type: string | null;
}

const errorWrap = <T>(result: { data: T | null; error: any }) => {
  if (result.error) {
    throw new Error(result.error.message ?? '数据库操作失败');
  }
  return result.data;
};

/**
 * 获取对方用户ID
 */
const getOtherUserId = (conversation: ConversationRow, currentUserId: number): number => {
  return conversation.user1_id === currentUserId ? conversation.user2_id : conversation.user1_id;
};

/**
 * 获取当前用户的未读数
 */
const getUnreadCount = (conversation: ConversationRow, currentUserId: number): number => {
  if (conversation.user1_id === currentUserId) {
    return conversation.user1_unread ?? 0;
  }
  return conversation.user2_unread ?? 0;
};

/**
 * 检查用户是否是会话参与者
 */
const isParticipant = (conversation: ConversationRow, userId: number): boolean => {
  return conversation.user1_id === userId || conversation.user2_id === userId;
};

/**
 * 确保用户是会话参与者
 */
const ensureParticipant = (conversation: ConversationRow, user: AuthedUser) => {
  if (!isParticipant(conversation, user.id)) {
    throw new Error('无权访问该会话');
  }
};

/**
 * 获取用户信息
 */
const getUserInfo = async (userId: number): Promise<UserInfo | null> => {
  const result = await supabase
    .from('users')
    .select('id, nickname, avatar_url, user_type')
    .eq('id', userId)
    .maybeSingle<UserInfo>();
  return result.data;
};

/**
 * 批量获取用户信息
 */
const getUserInfoBatch = async (userIds: number[]): Promise<Map<number, UserInfo>> => {
  if (userIds.length === 0) return new Map();

  const result = await supabase
    .from('users')
    .select('id, nickname, avatar_url, user_type')
    .in('id', userIds)
    .returns<UserInfo[]>();

  const users = errorWrap(result) ?? [];
  const map = new Map<number, UserInfo>();
  users.forEach(u => map.set(u.id, u));
  return map;
};

export const fetchConversation = async (conversationId: number): Promise<ConversationRow> => {
  const result = await supabase.from('conversations').select('*').eq('id', conversationId).maybeSingle<ConversationRow>();
  if (result.error) {
    throw new Error(result.error.message ?? '数据库操作失败');
  }
  if (!result.data) {
    throw new Error('会话不存在');
  }
  return result.data;
};

/**
 * 获取会话列表
 */
export const listConversations = async (
  user: AuthedUser,
  page: number,
  pageSize: number
): Promise<{ list: ConversationWithParty[]; total: number }> => {
  const from = (page - 1) * pageSize;
  const to = from + pageSize - 1;

  // 查询用户参与的所有会话（作为 user1 或 user2）
  const result = await supabase
    .from('conversations')
    .select('*', { count: 'exact' })
    .eq('status', 'active')
    .or(`user1_id.eq.${user.id},user2_id.eq.${user.id}`)
    .order('updated_at', { ascending: false })
    .range(from, to);

  const convs = errorWrap(result) ?? [];
  const total = result.count ?? convs.length;

  // 获取所有对方用户的ID
  const otherUserIds = convs.map(c => getOtherUserId(c, user.id));
  const userInfoMap = await getUserInfoBatch(otherUserIds);

  // 构建返回数据
  const list: ConversationWithParty[] = convs.map(conv => {
    const otherUserId = getOtherUserId(conv, user.id);
    const otherUser = userInfoMap.get(otherUserId);

    return {
      ...conv,
      unread_count: getUnreadCount(conv, user.id),
      other_user_id: otherUserId,
      other_party: otherUser ? {
        id: otherUser.id,
        nickname: otherUser.nickname,
        avatar_url: otherUser.avatar_url,
        user_type: otherUser.user_type ?? undefined,
      } : undefined,
    };
  });

  return { list, total };
};

/**
 * 创建会话
 */
export const createConversation = async (
  user: AuthedUser,
  payload: { targetUserId: number }
): Promise<ConversationWithParty> => {
  const { targetUserId } = payload;

  // 不能与自己创建会话
  if (targetUserId === user.id) {
    throw new Error('不能与自己创建会话');
  }

  // 验证目标用户存在
  const targetUser = await getUserInfo(targetUserId);
  if (!targetUser) {
    throw new Error('目标用户不存在');
  }

  // 查找是否已存在会话（双向查找）
  const existing = errorWrap(
    await supabase
      .from('conversations')
      .select('*')
      .eq('status', 'active')
      .or(`and(user1_id.eq.${user.id},user2_id.eq.${targetUserId}),and(user1_id.eq.${targetUserId},user2_id.eq.${user.id})`)
      .maybeSingle<ConversationRow>()
  );

  if (existing) {
    return {
      ...existing,
      unread_count: getUnreadCount(existing, user.id),
      other_user_id: targetUserId,
      other_party: {
        id: targetUser.id,
        nickname: targetUser.nickname,
        avatar_url: targetUser.avatar_url,
        user_type: targetUser.user_type ?? undefined,
      },
    };
  }

  // 创建新会话
  const now = new Date().toISOString();
  const inserted = errorWrap(
    await supabase
      .from('conversations')
      .insert({
        user1_id: user.id,
        user2_id: targetUserId,
        status: 'active',
        user1_unread: 0,
        user2_unread: 0,
        created_at: now,
        updated_at: now,
      })
      .select('*')
      .single<ConversationRow>()
  );

  if (!inserted) {
    throw new Error('创建会话失败');
  }

  return {
    ...inserted,
    unread_count: 0,
    other_user_id: targetUserId,
    other_party: {
      id: targetUser.id,
      nickname: targetUser.nickname,
      avatar_url: targetUser.avatar_url,
      user_type: targetUser.user_type ?? undefined,
    },
  };
};

/**
 * 发送消息
 */
export const appendMessage = async (
  conversation: ConversationRow,
  sender: AuthedUser,
  content: string,
  contentType = 'text'
): Promise<MessageRow> => {
  ensureParticipant(conversation, sender);

  const receiverId = getOtherUserId(conversation, sender.id);
  const now = new Date().toISOString();

  console.log(`[DB] 保存消息: conv=${conversation.id}, sender=${sender.id}, receiver=${receiverId}, content=${content.substring(0, 20)}`);

  // 创建消息
  const insertResult = await supabase
    .from('messages')
    .insert({
      conversation_id: conversation.id,
      sender_id: sender.id,
      receiver_id: receiverId,
      content_type: contentType,
      content,
      is_read: false,
      created_at: now,
    })
    .select('*')
    .single<MessageRow>();

  if (insertResult.error) {
    console.error(`[DB] 保存消息失败:`, insertResult.error);
    throw new Error(`保存消息失败: ${insertResult.error.message}`);
  }

  const message = insertResult.data;
  if (!message) {
    throw new Error('保存消息失败: 未返回数据');
  }

  console.log(`[DB] 消息已保存: id=${message.id}, created_at=${message.created_at}`);

  // 更新会话信息和接收者的未读数
  const updateData: any = {
    last_message: contentType === 'text' ? content : `[${contentType}]`,
    last_message_at: now,
    updated_at: now,
  };

  // 增加接收者的未读数
  if (conversation.user1_id === receiverId) {
    updateData.user1_unread = (conversation.user1_unread ?? 0) + 1;
  } else {
    updateData.user2_unread = (conversation.user2_unread ?? 0) + 1;
  }

  errorWrap(
    await supabase
      .from('conversations')
      .update(updateData)
      .eq('id', conversation.id)
  );

  return message;
};

/**
 * 加载聊天历史
 */
export const loadHistory = async (conversationId: number, before?: string, limit = 50): Promise<MessageRow[]> => {
  console.log(`[DB] 加载会话 ${conversationId} 的历史消息, before=${before}, limit=${limit}`);

  // 先查询不带 is_deleted 过滤，看看有多少数据
  const debugResult = await supabase
    .from('messages')
    .select('id, conversation_id, is_deleted, created_at')
    .eq('conversation_id', conversationId);
  console.log(`[DB] 调试 - 会话 ${conversationId} 的所有消息:`, debugResult.data, debugResult.error);

  let query = supabase
    .from('messages')
    .select('*')
    .eq('conversation_id', conversationId)
    .or('is_deleted.eq.false,is_deleted.is.null')  // 兼容 is_deleted 为 null 的情况
    .order('created_at', { ascending: false })
    .limit(limit);

  if (before) {
    query = query.lt('created_at', before);
  }

  const result = await query.returns<MessageRow[]>();
  if (result.error) {
    console.error(`[DB] 查询消息失败:`, result.error);
    throw new Error(result.error.message);
  }

  const rows = result.data ?? [];
  console.log(`[DB] 查询到 ${rows.length} 条消息`);
  return rows.sort((a, b) => new Date(a.created_at).getTime() - new Date(b.created_at).getTime());
};

/**
 * 标记消息为已读
 */
export const markRead = async (conversationId: number, reader: AuthedUser, messageIds?: number[]) => {
  // 标记消息为已读
  let query = supabase
    .from('messages')
    .update({ is_read: true })
    .eq('conversation_id', conversationId)
    .eq('receiver_id', reader.id)
    .eq('is_read', false);

  if (messageIds && messageIds.length > 0) {
    query = query.in('id', messageIds);
  }
  await query;

  // 清除当前用户的未读数
  const conversation = await fetchConversation(conversationId);
  if (conversation.user1_id === reader.id) {
    await supabase.from('conversations').update({ user1_unread: 0 }).eq('id', conversationId);
  } else if (conversation.user2_id === reader.id) {
    await supabase.from('conversations').update({ user2_unread: 0 }).eq('id', conversationId);
  }
};

/**
 * 统计未读消息数
 */
export const countUnread = async (user: AuthedUser): Promise<number> => {
  // 统计作为 user1 的未读数
  const result1 = await supabase
    .from('conversations')
    .select('user1_unread')
    .eq('user1_id', user.id)
    .eq('status', 'active');

  const convs1 = errorWrap(result1) ?? [];
  const unread1 = convs1.reduce((acc, c) => acc + (c.user1_unread ?? 0), 0);

  // 统计作为 user2 的未读数
  const result2 = await supabase
    .from('conversations')
    .select('user2_unread')
    .eq('user2_id', user.id)
    .eq('status', 'active');

  const convs2 = errorWrap(result2) ?? [];
  const unread2 = convs2.reduce((acc, c) => acc + (c.user2_unread ?? 0), 0);

  return unread1 + unread2;
};

/**
 * 解析接收者信息
 * 用于 WebSocket 广播时确定接收者
 */
export const resolveReceiver = (conversation: ConversationRow, sender: AuthedUser) => {
  const receiverId = getOtherUserId(conversation, sender.id);
  return { receiverId };
};

// 导出辅助函数供其他模块使用
export { isParticipant, getOtherUserId, ensureParticipant };
