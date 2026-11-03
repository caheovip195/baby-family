import { Injectable } from '@nestjs/common';
import type { Server } from 'socket.io';

/**
 * Tham chiếu Socket.IO server của process API (gateway gán khi khởi tạo).
 * Với Redis adapter, `server.to(room).emit()` tới mọi instance; process không
 * có gateway (worker) để null và không phát realtime.
 */
@Injectable()
export class RealtimeServerHolder {
  server: Server | null = null;
}
