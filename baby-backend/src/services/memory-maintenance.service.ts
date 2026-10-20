import { Inject, Injectable } from '@nestjs/common';
import { MEMORY_POLICY } from '../config/memory-policy';
import { MEMORY_CONTENT_REPOSITORY } from '../interfaces/repositories/memory-content-repository.interface';
import type { IMemoryContentRepository } from '../interfaces/repositories/memory-content-repository.interface';
import type { IMemoryMaintenanceService } from '../interfaces/services/memory-maintenance-service.interface';

@Injectable()
export class MemoryMaintenanceService implements IMemoryMaintenanceService {
  constructor(
    @Inject(MEMORY_CONTENT_REPOSITORY)
    private readonly repository: IMemoryContentRepository,
  ) {}

  async purgeExpiredTrash(
    now: Date,
    familyId?: string,
  ): Promise<Record<string, number>> {
    let purged = 0;
    // One batch per run; the next run continues with the remaining backlog.
    for (const memory of await this.repository.findExpiredTrash(
      now,
      MEMORY_POLICY.purgeBatchSize,
      familyId,
    ))
      if (await this.repository.purge(memory.familyId, memory.id, null))
        purged++;
    return { purged };
  }
}
