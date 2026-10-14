import { Injectable } from '@nestjs/common';
import { Prisma } from '../generated/prisma/client';
import { PrismaService } from '../database/prisma.service';
import { ConflictError } from '../common/errors/domain.error';
import type {
  CreateNextPregnancyInput,
  IPregnancyCommandRepository,
} from '../interfaces/repositories/pregnancy-command-repository.interface';
import { Pregnancy } from '../models/pregnancy.model';

@Injectable()
export class PregnancyCommandRepository implements IPregnancyCommandRepository {
  constructor(private readonly prisma: PrismaService) {}

  createNext(
    familyId: string,
    input: CreateNextPregnancyInput,
  ): Promise<Pregnancy> {
    return this.prisma.$transaction(
      async (transaction) => {
        const families = await transaction.$queryRaw<
          { id: string }[]
        >(Prisma.sql`
        SELECT id FROM app.families
        WHERE id = ${familyId}::uuid AND deleted_at IS NULL AND status = 'ACTIVE'
        FOR UPDATE
      `);
        if (!families.length)
          throw new ConflictError('Family is no longer active.');
        // Include removed pregnancies because (family_id, seq_no) is never reused.
        const result = await transaction.pregnancy.aggregate({
          where: { familyId },
          _max: { seqNo: true },
        });
        const seqNo = (result._max.seqNo ?? 0) + 1;
        if (seqNo > 32767)
          throw new ConflictError('Pregnancy sequence limit reached.');
        const row = await transaction.pregnancy.create({
          data: {
            familyId,
            seqNo,
            nickname: input.nickname,
            dueDate: input.dueDate,
            expectedCount: input.expectedCount,
            createdBy: input.createdBy,
          },
        });
        return new Pregnancy({
          id: row.id,
          familyId: row.familyId,
          seqNo: row.seqNo,
          nickname: row.nickname,
          dueDate: row.dueDate,
          expectedCount: row.expectedCount,
          status: row.status,
          coverAssetId: row.coverAssetId,
          showSizeContent: row.showSizeContent,
          carrierUserId: row.carrierUserId,
          bumpPhotoCadence: row.bumpPhotoCadence,
          createdBy: row.createdBy,
          createdAt: row.createdAt,
          updatedAt: row.updatedAt,
          completedAt: row.completedAt,
          version: row.version,
          deletedAt: row.deletedAt,
        });
      },
      {
        isolationLevel: Prisma.TransactionIsolationLevel.ReadCommitted,
        timeout: 10000,
      },
    );
  }
}
