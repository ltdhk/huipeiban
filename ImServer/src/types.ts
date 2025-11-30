export type UserRole = 'user' | 'patient' | 'companion' | 'institution' | 'admin';

export interface JwtClaims {
  sub?: string;
  user_type?: UserRole;
  [key: string]: unknown;
}

/**
 * 会话行数据结构
 *
 * 简化设计：只记录两个用户ID，不区分角色类型
 */
export interface ConversationRow {
  id: number;
  user1_id: number;  // 参与者1
  user2_id: number;  // 参与者2
  last_message: string | null;
  last_message_at: string | null;
  user1_unread: number;  // 用户1的未读数
  user2_unread: number;  // 用户2的未读数
  status: 'active' | 'archived';
  created_at: string;
  updated_at: string;
}

/**
 * 带对方用户信息的会话
 */
export interface ConversationWithParty extends ConversationRow {
  unread_count: number;  // 当前用户的未读数
  other_user_id: number;  // 对方用户ID
  other_party?: {
    id: number;
    nickname: string;
    avatar_url?: string | null;
    user_type?: string;
  };
}

/**
 * 消息行数据结构
 *
 * 简化设计：sender_id 和 receiver_id 都统一使用 users 表的 ID
 */
export interface MessageRow {
  id: number;
  conversation_id: number;
  sender_id: number;    // 发送者用户ID
  receiver_id: number;  // 接收者用户ID
  content_type: string;
  content: string;
  is_read: boolean;
  is_deleted: boolean;
  created_at: string;
}

export interface WsSendPayload {
  tempId?: string;
  convId: number;
  content: string;
  contentType?: string;
}

export type WsInbound =
  | { type: 'auth'; token: string }
  | { type: 'send'; data: WsSendPayload }
  | { type: 'history'; convId: number; limit?: number; before?: string }
  | { type: 'read'; convId: number; messageIds?: number[] };

export type WsOutbound =
  | { type: 'auth_ok'; userId: number; role: UserRole }
  | { type: 'error'; message: string }
  | { type: 'message'; data: MessageRow }
  | { type: 'ack'; tempId?: string; message: MessageRow }
  | { type: 'history'; convId: number; data: MessageRow[] }
  | { type: 'read'; convId: number; reader: number; messageIds?: number[] };
