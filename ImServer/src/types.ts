export type UserRole = 'user' | 'companion' | 'institution' | 'admin';

export interface JwtClaims {
  sub?: string;
  user_type?: UserRole;
  [key: string]: unknown;
}

export interface ConversationRow {
  id: number;
  user_id: number;
  companion_id: number | null;
  institution_id: number | null;
  title: string | null;
  last_message: string | null;
  unread_count: number;
  status: 'active' | 'archived';
  created_at: string;
  updated_at: string;
}

export interface MessageRow {
  id: number;
  conversation_id: number;
  sender_id: number;
  sender_type: UserRole | 'system';
  receiver_id: number;
  receiver_type: UserRole;
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
