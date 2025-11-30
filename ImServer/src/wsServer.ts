import { WebSocketServer, WebSocket } from 'ws';
import http from 'http';
import { AuthedUser, verifyToken } from './auth';
import { appendMessage, fetchConversation, loadHistory, markRead, resolveReceiver } from './chatService';
import { config } from './config';
import { WsInbound, WsOutbound } from './types';

type SessionMap = Map<number, Set<WebSocket>>;

export const createWsServer = (server: http.Server) => {
  const sessions: SessionMap = new Map();
  const wss = new WebSocketServer({ server, path: config.wsPath });

  const push = (socket: WebSocket, payload: WsOutbound) => {
    if (socket.readyState === WebSocket.OPEN) {
      socket.send(JSON.stringify(payload));
    }
  };

  const broadcast = (userId: number, payload: WsOutbound) => {
    const clients = sessions.get(userId);
    console.log(`[WS] broadcast to userId=${userId}, online clients=${clients?.size ?? 0}, all sessions:`, Array.from(sessions.keys()));
    if (!clients || clients.size === 0) {
      console.log(`[WS] 用户 ${userId} 当前不在线，无法推送实时消息`);
      return;
    }
    clients?.forEach(client => {
      if (client.readyState === WebSocket.OPEN) {
        console.log(`[WS] 推送消息给用户 ${userId}`);
        client.send(JSON.stringify(payload));
      }
    });
  };

  wss.on('connection', ws => {
    let user: AuthedUser | null = null;

    ws.on('message', async raw => {
      let msg: WsInbound;
      try {
        msg = JSON.parse(raw.toString()) as WsInbound;
      } catch {
        return push(ws, { type: 'error', message: '消息格式错误' });
      }

      if (msg.type !== 'auth' && !user) {
        return push(ws, { type: 'error', message: '请先认证' });
      }

      try {
        if (msg.type === 'auth') {
          user = verifyToken(msg.token);
          let set = sessions.get(user.id);
          if (!set) {
            set = new Set();
            sessions.set(user.id, set);
          }
          set.add(ws);
          console.log(`[WS] 用户 ${user.id} 认证成功，当前在线用户:`, Array.from(sessions.keys()));
          return push(ws, { type: 'auth_ok', userId: user.id, role: user.role });
        }

        if (msg.type === 'send') {
          console.log(`[WS] 用户 ${user!.id} 发送消息到会话 ${msg.data.convId}`);
          const conv = await fetchConversation(msg.data.convId);
          console.log(`[WS] 会话信息: user1_id=${conv.user1_id}, user2_id=${conv.user2_id}`);
          const message = await appendMessage(conv, user!, msg.data.content, msg.data.contentType ?? 'text');
          console.log(`[WS] 消息已保存: id=${message.id}, sender=${message.sender_id}, receiver=${message.receiver_id}`);
          push(ws, { type: 'ack', tempId: msg.data.tempId, message });

          const { receiverId } = resolveReceiver(conv, user!);
          console.log(`[WS] 准备广播给接收者: receiverId=${receiverId}`);
          broadcast(receiverId, { type: 'message', data: message });
          if (receiverId !== user!.id) {
            // also push to other logged-in sessions of sender
            broadcast(user!.id, { type: 'message', data: message });
          }
          return;
        }

        if (msg.type === 'history') {
          const history = await loadHistory(msg.convId, msg.before, msg.limit ?? 50);
          return push(ws, { type: 'history', convId: msg.convId, data: history });
        }

        if (msg.type === 'read') {
          await markRead(msg.convId, user!, msg.messageIds);
          const conv = await fetchConversation(msg.convId);
          const { receiverId } = resolveReceiver(conv, user!);
          broadcast(receiverId, { type: 'read', convId: msg.convId, reader: user!.id, messageIds: msg.messageIds });
          return;
        }
      } catch (e: any) {
        return push(ws, { type: 'error', message: e.message ?? '操作失败' });
      }
    });

    ws.on('close', () => {
      if (user) {
        const set = sessions.get(user.id);
        set?.delete(ws);
        if (set && set.size === 0) {
          sessions.delete(user.id);
        }
      }
    });
  });

  // keep-alive
  setInterval(() => {
    wss.clients.forEach(client => {
      if (client.readyState === WebSocket.OPEN) {
        client.ping();
      }
    });
  }, 30000);

  return wss;
};
