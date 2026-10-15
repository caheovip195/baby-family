import { writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import { Injectable, Logger } from '@nestjs/common';
import type { OnApplicationBootstrap, OnModuleDestroy } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import { ValkeyConnection } from '../database/valkey.connection';

export const WORKER_HEARTBEAT_FILE = path.join(
  tmpdir(),
  'baby-worker-heartbeat',
);
const INTERVAL_MS = 15_000;

/**
 * Liveness/readiness for the worker container: the file is refreshed only after a
 * real database query and a Valkey round trip succeed (docs/jobs.md §6).
 */
@Injectable()
export class WorkerHeartbeat
  implements OnApplicationBootstrap, OnModuleDestroy
{
  private readonly logger = new Logger(WorkerHeartbeat.name);
  private timer: NodeJS.Timeout | null = null;

  constructor(
    private readonly prisma: PrismaService,
    private readonly valkey: ValkeyConnection,
  ) {}

  async onApplicationBootstrap(): Promise<void> {
    await this.beat();
    this.timer = setInterval(() => void this.beat(), INTERVAL_MS);
  }

  onModuleDestroy(): void {
    if (this.timer) clearInterval(this.timer);
  }

  private async beat(): Promise<void> {
    try {
      await this.prisma.$queryRaw`SELECT 1`;
      if ((await this.valkey.client?.ping()) !== 'PONG')
        throw new Error('Valkey unavailable');
      await writeFile(WORKER_HEARTBEAT_FILE, new Date().toISOString());
    } catch (error) {
      this.logger.warn(
        `Worker dependencies unavailable: ${error instanceof Error ? error.message : 'unknown'}`,
      );
    }
  }
}
