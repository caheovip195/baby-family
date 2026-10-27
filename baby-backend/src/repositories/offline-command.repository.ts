import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import { Prisma } from '../generated/prisma/client';
import type {
  IOfflineCommandRepository,
  OfflineCommandClaim,
} from '../interfaces/repositories/offline-command-repository.interface';
import { OfflineCommandRecord } from '../models/offline-command-record.model';

@Injectable()
export class OfflineCommandRepository implements IOfflineCommandRepository {
  constructor(private readonly prisma: PrismaService) {}
  async claim(input: OfflineCommandClaim) {
    const where = {
      scopeKey_operation_idempotencyKey: {
        scopeKey: input.scopeKey,
        operation: input.operation,
        idempotencyKey: input.key,
      },
    };
    try {
      const row = await this.prisma.idempotencyRecord.create({
        data: {
          actorUserId: input.actorUserId,
          familyId: input.familyId,
          scopeKey: input.scopeKey,
          operation: input.operation,
          idempotencyKey: input.key,
          requestHash: new Uint8Array(input.requestHash),
          status: 'PENDING',
        },
      });
      return {
        acquired: true,
        record: new OfflineCommandRecord(
          row.id,
          row.requestHash,
          row.status,
          null,
        ),
      };
    } catch (error) {
      if (
        !(error instanceof Prisma.PrismaClientKnownRequestError) ||
        error.code !== 'P2002'
      )
        throw error;
      const row = await this.prisma.idempotencyRecord.findUniqueOrThrow({
        where,
      });
      const snapshot = row.responseReference as { encrypted?: string } | null;
      return {
        acquired: false,
        record: new OfflineCommandRecord(
          row.id,
          row.requestHash,
          row.status,
          snapshot?.encrypted ?? null,
        ),
      };
    }
  }
  async complete(id: string, response: string) {
    await this.prisma.idempotencyRecord.update({
      where: { id },
      data: {
        status: 'SUCCEEDED',
        responseReference: { encrypted: response },
      },
    });
  }
  async reject(id: string) {
    // Keep the claim: a thrown exception may follow a committed side effect.
    await this.prisma.idempotencyRecord.update({
      where: { id },
      data: { status: 'FAILED' },
    });
  }
}
