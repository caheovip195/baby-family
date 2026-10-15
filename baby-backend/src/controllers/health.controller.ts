import {
  Controller,
  Get,
  Inject,
  ServiceUnavailableException,
} from '@nestjs/common';
import {
  ApiOkResponse,
  ApiServiceUnavailableResponse,
  ApiTags,
} from '@nestjs/swagger';
import { SkipThrottle } from '@nestjs/throttler';
import { PrismaService } from '../database/prisma.service';
import type { DependencyStatus } from '../common/health/dependency-status';
import { CACHE_REPOSITORY } from '../interfaces/repositories/cache-repository.interface';
import type { ICacheRepository } from '../interfaces/repositories/cache-repository.interface';
import { OBJECT_STORAGE_SERVICE } from '../interfaces/services/object-storage-service.interface';
import type { IObjectStorageService } from '../interfaces/services/object-storage-service.interface';

@ApiTags('Health')
@SkipThrottle()
@Controller('health')
export class HealthController {
  constructor(
    private readonly prisma: PrismaService,
    @Inject(CACHE_REPOSITORY) private readonly cache: ICacheRepository,
    @Inject(OBJECT_STORAGE_SERVICE)
    private readonly storage: IObjectStorageService,
  ) {}
  @Get('live')
  @ApiOkResponse({ description: 'Process is alive.' })
  live() {
    return { status: 'ok' };
  }
  @Get('ready')
  @ApiOkResponse({
    description:
      'Database is reachable; configured cache/object storage are reachable (`disabled` when not configured).',
  })
  @ApiServiceUnavailableResponse({
    description: 'A required or configured dependency is unreachable.',
  })
  async ready() {
    const [database, cache, objectStorage] = await Promise.all([
      this.checkDatabase(),
      this.cache.checkHealth(),
      this.storage.checkHealth(),
    ]);
    const statuses = { database, cache, objectStorage };
    const down = Object.entries(statuses)
      .filter(([, status]) => status === 'down')
      .map(([name]) => name);
    if (down.length > 0) {
      throw new ServiceUnavailableException(
        `Unavailable dependencies: ${down.join(', ')}.`,
      );
    }
    return { status: 'ok', ...statuses };
  }
  private async checkDatabase(): Promise<DependencyStatus> {
    try {
      await this.prisma.$queryRaw`SELECT 1`;
      return 'up';
    } catch {
      return 'down';
    }
  }
}
