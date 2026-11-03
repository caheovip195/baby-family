import { Inject } from '@nestjs/common';
import type { OnModuleDestroy } from '@nestjs/common';
import {
  WebSocketGateway,
  type OnGatewayConnection,
  type OnGatewayDisconnect,
  type OnGatewayInit,
} from '@nestjs/websockets';
import { decodeJwt } from 'jose';
import type { Server, Socket } from 'socket.io';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { RealtimeServerHolder } from '../common/realtime/realtime-server.holder';
import { CHAT_POLICY } from '../config/chat-policy';
import { REALTIME_SERVICE } from '../interfaces/services/realtime-service.interface';
import type { IRealtimeService } from '../interfaces/services/realtime-service.interface';
import { AUTHENTICATION_SERVICE } from '../interfaces/services/authentication-service.interface';
import type { IAuthenticationService } from '../interfaces/services/authentication-service.interface';
import { CHAT_SERVICE } from '../interfaces/services/chat-service.interface';
import type { IChatService } from '../interfaces/services/chat-service.interface';

interface SocketState {
  principal: AuthPrincipal;
  timer?: NodeJS.Timeout;
}

const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
const uuid = (value: unknown): string | null =>
  typeof value === 'string' && UUID.test(value) ? value.toLowerCase() : null;
const tokenOf = (value: unknown): string | null =>
  typeof value === 'string' &&
  value.length <= 8192 &&
  /^[A-Za-z0-9_.-]+$/.test(value)
    ? value
    : null;

/**
 * Realtime gateway (§12, BF-20261101-001): Socket.IO, xác thực bằng access
 * token ES256 khi handshake (`auth.token`), làm mới bằng `auth.refresh`. Mỗi
 * socket vào room `user:{id}`; server chỉ phát tín hiệu nhỏ, client lấy nội
 * dung qua REST. Sự kiện client được gắn trực tiếp trên socket (không qua
 * guard/interceptor HTTP); mọi quyền kiểm tra ở service.
 */
@WebSocketGateway({ transports: ['websocket'], cors: { origin: true } })
export class RealtimeGateway
  implements
    OnGatewayInit<Server>,
    OnGatewayConnection<Socket>,
    OnGatewayDisconnect<Socket>,
    OnModuleDestroy
{
  private readonly sockets = new Map<string, SocketState>();
  private heartbeat: NodeJS.Timeout | null = null;

  constructor(
    @Inject(AUTHENTICATION_SERVICE)
    private readonly authentication: IAuthenticationService,
    @Inject(CHAT_SERVICE) private readonly chat: IChatService,
    @Inject(REALTIME_SERVICE) private readonly realtime: IRealtimeService,
    private readonly holder: RealtimeServerHolder,
  ) {}

  afterInit(server: Server): void {
    this.holder.server = server;
    this.heartbeat = setInterval(() => {
      void this.realtime.heartbeat(
        [...this.sockets].map(([socketId, state]) => ({
          socketId,
          userId: state.principal.userId,
        })),
      );
    }, CHAT_POLICY.presenceHeartbeatMs);
    this.heartbeat.unref();
  }

  onModuleDestroy(): void {
    if (this.heartbeat) clearInterval(this.heartbeat);
    for (const state of this.sockets.values()) clearTimeout(state.timer);
    this.holder.server = null;
  }

  async handleConnection(socket: Socket): Promise<void> {
    const auth = socket.handshake.auth as Record<string, unknown> | undefined;
    const token = tokenOf(auth?.token);
    const principal = token ? await this.verify(token) : null;
    if (!token || !principal) {
      socket.emit('auth.error', { code: 'UNAUTHORIZED' });
      socket.disconnect(true);
      return;
    }
    const state: SocketState = { principal };
    this.sockets.set(socket.id, state);
    this.expireAt(socket, state, token);
    await socket.join(CHAT_POLICY.userRoom(principal.userId));
    await this.realtime.connected(principal.userId, socket.id);
    socket.on('chat.typing', (payload: unknown) => {
      const body = payload as Record<string, unknown> | null;
      const familyId = uuid(body?.familyId);
      const conversationId = uuid(body?.conversationId);
      if (familyId && conversationId)
        void this.chat
          .typing(state.principal, familyId, conversationId)
          .catch(() => undefined);
    });
    socket.on('auth.refresh', (payload: unknown, ack?: unknown) => {
      void this.refresh(socket, state, payload).then((ok) => {
        if (typeof ack === 'function') (ack as (r: object) => void)({ ok });
      });
    });
    socket.emit('ready', { userId: principal.userId });
  }

  async handleDisconnect(socket: Socket): Promise<void> {
    const state = this.sockets.get(socket.id);
    if (!state) return;
    clearTimeout(state.timer);
    this.sockets.delete(socket.id);
    await this.realtime.disconnected(state.principal.userId, socket.id);
  }

  private async verify(token: string): Promise<AuthPrincipal | null> {
    try {
      return await this.authentication.verifyAccessToken(token);
    } catch {
      return null;
    }
  }

  private async refresh(
    socket: Socket,
    state: SocketState,
    payload: unknown,
  ): Promise<boolean> {
    const token = tokenOf((payload as Record<string, unknown> | null)?.token);
    const principal = token ? await this.verify(token) : null;
    // Một socket không bao giờ đổi sang user khác.
    if (!token || principal?.userId !== state.principal.userId) return false;
    state.principal = principal;
    this.expireAt(socket, state, token);
    return true;
  }

  /** Token hết hạn mà không làm mới → báo client rồi ngắt. */
  private expireAt(socket: Socket, state: SocketState, token: string): void {
    clearTimeout(state.timer);
    const exp = decodeJwt(token).exp ?? 0;
    state.timer = setTimeout(
      () => {
        socket.emit('auth.expired', {});
        socket.disconnect(true);
      },
      Math.max(0, exp * 1000 - Date.now()),
    );
    state.timer.unref();
  }
}
