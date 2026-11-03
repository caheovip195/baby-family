import { Inject, Injectable } from '@nestjs/common';
import { BRIDGE_REPOSITORY } from '../interfaces/repositories/bridge-repository.interface';
import type { IBridgeRepository } from '../interfaces/repositories/bridge-repository.interface';
import type { IBridgeMaintenanceService } from '../interfaces/services/bridge-maintenance-service.interface';

/**
 * Job định kỳ của Cầu nối (BF-20261028-009): xoá nội dung đúng hạn kể cả khi
 * không ai mở app. Đọc/thao tác phiên vẫn dọn dẹp theo couple space.
 */
@Injectable()
export class BridgeMaintenanceService implements IBridgeMaintenanceService {
  constructor(
    @Inject(BRIDGE_REPOSITORY)
    private readonly repository: IBridgeRepository,
  ) {}

  async housekeep(now: Date): Promise<Record<string, number>> {
    return this.repository.housekeep(null, now);
  }
}
