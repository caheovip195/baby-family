import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import type {
  IMissionMomentRepository,
  MissionCompletionLink,
} from '../interfaces/repositories/mission-moment-repository.interface';

@Injectable()
export class MissionMomentRepository implements IMissionMomentRepository {
  constructor(private readonly prisma: PrismaService) {}

  async activeCompletion(
    missionId: string,
  ): Promise<MissionCompletionLink | null> {
    const row = await this.prisma.missionCompletion.findFirst({
      where: { missionId, deletedAt: null, undoneAt: null },
      select: { id: true, completedAt: true, memoryId: true },
    });
    return row;
  }

  async linkMemory(completionId: string, memoryId: string): Promise<boolean> {
    const result = await this.prisma.missionCompletion.updateMany({
      where: { id: completionId, memoryId: null, deletedAt: null },
      data: { memoryId },
    });
    return result.count === 1;
  }
}
