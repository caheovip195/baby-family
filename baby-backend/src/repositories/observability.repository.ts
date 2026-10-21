import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import type { IObservabilityRepository } from '../interfaces/repositories/observability-repository.interface';
import { ObservabilitySnapshot } from '../models/observability-snapshot.model';

@Injectable()
export class ObservabilityRepository implements IObservabilityRepository {
  constructor(private readonly prisma: PrismaService) {}

  async getSnapshot(since: Date): Promise<ObservabilitySnapshot> {
    const [failedJobs, timedOutAttempts, jobBacklog, outboxBacklog] =
      await this.prisma.$transaction([
        this.prisma.jobRun.count({
          where: {
            deletedAt: null,
            status: 'FAILED',
            finishedAt: { gte: since },
          },
        }),
        this.prisma.jobAttempt.count({
          where: {
            deletedAt: null,
            status: 'TIMED_OUT',
            finishedAt: { gte: since },
            jobRun: { deletedAt: null },
          },
        }),
        this.prisma.jobRun.count({
          where: {
            deletedAt: null,
            status: { in: ['PENDING', 'RETRY_WAIT'] },
          },
        }),
        this.prisma.outboxEvent.count({
          where: { deletedAt: null, publishedAt: null },
        }),
      ]);
    return new ObservabilitySnapshot(
      failedJobs,
      timedOutAttempts,
      jobBacklog,
      outboxBacklog,
    );
  }
}
