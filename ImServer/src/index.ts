import http from 'http';
import { config } from './config';
import { createHttpServer } from './httpServer';
import { createWsServer } from './wsServer';

const app = createHttpServer();
const server = http.createServer(app);

createWsServer(server);

server.listen(config.port, () => {
  console.log(`[IM] HTTP/WebSocket server started on :${config.port} (ws path: ${config.wsPath})`);
});

process.on('unhandledRejection', err => {
  console.error('[IM] Unhandled rejection', err);
});

process.on('uncaughtException', err => {
  console.error('[IM] Uncaught exception', err);
});
