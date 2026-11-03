import { Inject, Injectable } from '@nestjs/common';
import { REALTIME_REPOSITORY } from '../interfaces/repositories/realtime-repository.interface';
import type { IRealtimeRepository } from '../interfaces/repositories/realtime-repository.interface';
import type { IRealtimeService } from '../interfaces/services/realtime-service.interface';

/** Presence: người đang kết nối không nhận push chat (BF-20261101-001). */
@Injectable()
export class RealtimeService implements IRealtimeService {
  constructor(
    @Inject(REALTIME_REPOSITORY) private readonly realtime: IRealtimeRepository,
  ) {}

  connected(userId: string, socketId: string): Promise<void> {
    return this.realtime.markOnline(userId, socketId);
  }

  disconnected(userId: string, socketId: string): Promise<void> {
    return this.realtime.markOffline(userId, socketId);
  }

  heartbeat(
    entries: ReadonlyArray<{ userId: string; socketId: string }>,
  ): Promise<void> {
    return this.realtime.refresh(entries);
  }
}
