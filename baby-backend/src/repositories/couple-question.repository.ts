import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import { Prisma } from '../generated/prisma/client';
import type { ConnectionAnswer as AnswerRow } from '../generated/prisma/client';
import type { ICoupleQuestionRepository } from '../interfaces/repositories/couple-question-repository.interface';
import type { CoupleCheckinScope } from '../models/couple-checkin-view.model';
import { ConnectionAnswer } from '../models/connection-answer.model';
import { CoupleWeekCounts } from '../models/couple-week.model';

function model(row: AnswerRow): ConnectionAnswer {
  return new ConnectionAnswer({
    ...row,
    answerEnc: new Uint8Array(row.answerEnc),
    sharedAnswerEnc: row.sharedAnswerEnc
      ? new Uint8Array(row.sharedAnswerEnc)
      : null,
  });
}

/**
 * Câu hỏi kết nối + US-14 (BF-20261027-002). Câu trả lời lưu ở bảng có sẵn
 * `us.connection_answers` (khoá couple space + ngày + người, BF-20261028-009).
 */
@Injectable()
export class CoupleQuestionRepository implements ICoupleQuestionRepository {
  constructor(private readonly prisma: PrismaService) {}

  async answers(
    scope: CoupleCheckinScope,
    localDate: Date,
  ): Promise<ConnectionAnswer[]> {
    const rows = await this.prisma.connectionAnswer.findMany({
      where: {
        familyId: scope.familyId,
        coupleSpaceId: scope.coupleSpaceId,
        localDate,
        deletedAt: null,
      },
    });
    return rows.map(model);
  }

  async saveAnswer(
    scope: CoupleCheckinScope,
    localDate: Date,
    questionCode: string,
    answerEnc: Uint8Array,
  ): Promise<ConnectionAnswer> {
    const data = {
      promptCode: questionCode,
      answerEnc: new Uint8Array(answerEnc),
      deletedAt: null,
    };
    const save = () =>
      this.prisma.connectionAnswer.upsert({
        where: {
          coupleSpaceId_localDate_userId: {
            coupleSpaceId: scope.coupleSpaceId,
            localDate,
            userId: scope.userId,
          },
        },
        update: data,
        create: {
          ...data,
          familyId: scope.familyId,
          coupleSpaceId: scope.coupleSpaceId,
          userId: scope.userId,
          localDate,
        },
      });
    try {
      return model(await save());
    } catch (error) {
      // Hai lần gửi cùng lúc: lần sau gặp khoá chính của lần trước → sửa bản đó.
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === 'P2002'
      )
        return model(await save());
      throw error;
    }
  }

  async week(
    scope: CoupleCheckinScope,
    from: Date,
    to: Date,
    togetherLimit: number,
  ): Promise<CoupleWeekCounts> {
    const pair = {
      familyId: scope.familyId,
      coupleSpaceId: scope.coupleSpaceId,
      deletedAt: null,
    };
    const range = { gte: from, lt: to };
    const together: Prisma.MissionCompletionWhereInput = {
      familyId: scope.familyId,
      undoneAt: null,
      deletedAt: null,
      completedAt: range,
      missionsMissionCompletionsMissionIdTomissions: {
        deletedAt: null,
        OR: [{ ownerKind: 'TOGETHER' }, { targetScope: 'COUPLE' }],
      },
    };
    const [checkins, requestsHelped, thanks, togetherCount, items] =
      await this.prisma.$transaction([
        this.prisma.moodCheckin.count({
          where: { ...pair, createdAt: range },
        }),
        // Được hỗ trợ: việc nhờ (TASK) đã xong, nhu cầu (NEED) đã được đáp lại.
        this.prisma.request.count({
          where: {
            ...pair,
            OR: [
              { status: 'DONE', doneAt: range },
              { status: 'ACKNOWLEDGED', respondedAt: range },
            ],
          },
        }),
        this.prisma.appreciation.count({
          where: { ...pair, createdAt: range },
        }),
        this.prisma.missionCompletion.count({ where: together }),
        this.prisma.missionCompletion.findMany({
          where: together,
          orderBy: [{ completedAt: 'desc' }, { id: 'desc' }],
          take: togetherLimit,
          select: {
            completedAt: true,
            missionsMissionCompletionsMissionIdTomissions: {
              select: { title: true },
            },
          },
        }),
      ]);
    return new CoupleWeekCounts(
      checkins,
      requestsHelped,
      thanks,
      togetherCount,
      items.map((item) => ({
        title: item.missionsMissionCompletionsMissionIdTomissions.title,
        completedAt: item.completedAt,
      })),
    );
  }
}
