import express from 'express';
import cors from 'cors';
import { z } from 'zod';
import { AuthedUser, verifyToken } from './auth';
import {
  appendMessage,
  countUnread,
  createConversation,
  fetchConversation,
  listConversations,
  loadHistory,
} from './chatService';
import { ConversationRow } from './types';
import { supabase } from './supabase';

interface AuthedRequest extends express.Request {
  user?: AuthedUser;
}

const success = (res: express.Response, data: any, message = 'ok', status = 200) =>
  res.status(status).json({ success: true, data, message, timestamp: new Date().toISOString() });

const error = (res: express.Response, status: number, code: string, message: string, details?: any) =>
  res.status(status).json({ success: false, error: { code, message, details }, timestamp: new Date().toISOString() });

export const createHttpServer = () => {
  const app = express();
  app.use(cors());
  app.use(express.json());

  // auth middleware
  app.use((req: AuthedRequest, res, next) => {
    if (req.path === '/health') return next();
    try {
      const token = req.headers.authorization || req.headers['Authorization' as any];
      req.user = verifyToken(typeof token === 'string' ? token : undefined);
      next();
    } catch (e: any) {
      return error(res, 401, 'UNAUTHORIZED', e.message ?? '未授权');
    }
  });

  app.get('/health', (_req, res) => res.send('ok'));

  app.get('/api/v1/user/messages/conversations', async (req: AuthedRequest, res) => {
    try {
      const page = Number(req.query.page ?? 1);
      const pageSize = Math.min(Number(req.query.page_size ?? 20), 100);
      const { list, total } = await listConversations(req.user!, page, pageSize);
      return success(res, { list, total, page, page_size: pageSize, total_pages: Math.ceil(total / pageSize) }, '获取会话列表成功');
    } catch (e: any) {
      return error(res, 500, 'INTERNAL_ERROR', e.message ?? '获取会话失败');
    }
  });

  app.post('/api/v1/user/messages/conversations', async (req: AuthedRequest, res) => {
    const schema = z.object({
      companion_id: z.number().optional(),
      institution_id: z.number().optional(),
      title: z.string().optional(),
    });
    const parsed = schema.safeParse(req.body);
    if (!parsed.success) {
      return error(res, 400, 'BAD_REQUEST', '参数错误', parsed.error.flatten());
    }
    try {
      const conv = await createConversation(req.user!, {
        companionId: parsed.data.companion_id,
        institutionId: parsed.data.institution_id,
        title: parsed.data.title,
      });
      return success(res, conv, '创建成功');
    } catch (e: any) {
      return error(res, 500, 'INTERNAL_ERROR', e.message ?? '创建失败');
    }
  });

  app.get('/api/v1/user/messages/conversations/:id', async (req: AuthedRequest, res) => {
    try {
      const conversationId = Number(req.params.id);
      const conversation = await fetchConversation(conversationId);
      ensureOwn(conversation, req.user!);
      const history = await loadHistory(conversationId, undefined, Math.min(Number(req.query.page_size ?? 50), 100));
      return success(res, { list: history, total: history.length, page: 1, page_size: history.length, total_pages: 1 }, '获取消息成功');
    } catch (e: any) {
      return error(res, 500, 'INTERNAL_ERROR', e.message ?? '获取消息失败');
    }
  });

  app.post('/api/v1/user/messages/conversations/:id/messages', async (req: AuthedRequest, res) => {
    const schema = z.object({
      content: z.string().min(1),
      content_type: z.string().optional(),
    });
    const parsed = schema.safeParse(req.body);
    if (!parsed.success) return error(res, 400, 'BAD_REQUEST', '参数错误', parsed.error.flatten());
    try {
      const conversationId = Number(req.params.id);
      const conversation = await fetchConversation(conversationId);
      ensureOwn(conversation, req.user!);
      const msg = await appendMessage(conversation, req.user!, parsed.data.content, parsed.data.content_type ?? 'text');
      return success(res, msg, '发送成功');
    } catch (e: any) {
      return error(res, 500, 'INTERNAL_ERROR', e.message ?? '发送失败');
    }
  });

  app.delete('/api/v1/user/messages/conversations/:id', async (req: AuthedRequest, res) => {
    try {
      const conversationId = Number(req.params.id);
      ensureOwn(await fetchConversation(conversationId), req.user!);
      await supabase.from('conversations').update({ status: 'archived' }).eq('id', conversationId);
      return success(res, null, '删除成功');
    } catch (e: any) {
      return error(res, 500, 'INTERNAL_ERROR', e.message ?? '删除失败');
    }
  });

  app.get('/api/v1/user/messages/unread-count', async (req: AuthedRequest, res) => {
    try {
      const count = await countUnread(req.user!);
      return success(res, { count }, '获取成功');
    } catch (e: any) {
      return error(res, 500, 'INTERNAL_ERROR', e.message ?? '获取失败');
    }
  });

  return app;
};

const ensureOwn = (conversation: ConversationRow, user: AuthedUser) => {
  if (user.role === 'user' && conversation.user_id !== user.id) throw new Error('无权访问');
  if (user.role === 'companion' && conversation.companion_id !== user.id) throw new Error('无权访问');
  if (user.role === 'institution' && conversation.institution_id !== user.id) throw new Error('无权访问');
};
