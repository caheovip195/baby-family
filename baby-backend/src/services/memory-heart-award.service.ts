import { Inject, Injectable } from '@nestjs/common';
import { HEARTS_POLICY } from '../config/hearts-policy';
import { MEMORY_HEARTS_POLICY } from '../config/memory-hearts-policy';
import { MEMORY_HEART_AWARD_REPOSITORY } from '../interfaces/repositories/memory-heart-award-repository.interface';
import type { IMemoryHeartAwardRepository } from '../interfaces/repositories/memory-heart-award-repository.interface';
import type { IMemoryHeartAwardService } from '../interfaces/services/memory-heart-award-service.interface';
import type { JobContext } from '../interfaces/services/job-runner-service.interface';
@Injectable()
export class MemoryHeartAwardService implements IMemoryHeartAwardService {
  constructor(
    @Inject(MEMORY_HEART_AWARD_REPOSITORY)
    private readonly repository: IMemoryHeartAwardRepository,
  ) {}
  award(eventId: string, context: JobContext) {
    return this.repository.award(eventId, context, {
      ...MEMORY_HEARTS_POLICY,
      dailyCap: HEARTS_POLICY.dailyHeartCap,
    });
  }
}
