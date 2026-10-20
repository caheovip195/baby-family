import type {
  ReportReasonCode,
  ReportTargetType,
} from '../../config/safety-policy';

export const SAFETY_REPOSITORY = Symbol('SAFETY_REPOSITORY');

export type FamilyRoleOf = 'PARENT' | 'CIRCLE' | null;

export interface ReportRecord {
  id: string;
  status: string;
  createdAt: Date;
}

export interface CreateReportCommand {
  reporterUserId: string;
  familyId: string;
  targetType: ReportTargetType;
  targetId: string;
  targetOwnerId: string | null;
  reason: ReportReasonCode;
  detail: string | null;
  severity: number;
  slaDueAt: Date;
  hideForReporter: boolean;
}

export interface BlockedUserRecord {
  userId: string;
  displayName: string;
  blockedAt: Date;
}

export interface ISafetyRepository {
  /** Active Parent / active Circle member of the family, else null. */
  roleOf(familyId: string, userId: string): Promise<FamilyRoleOf>;
  /** Author of an active comment in the family, null when missing. */
  commentContext(
    familyId: string,
    commentId: string,
  ): Promise<{ memoryId: string; authorUserId: string } | null>;
  /**
   * Idempotent per (reporter, target): an open report is returned as is; the
   * "hide for me" choice is applied in the same transaction.
   */
  createReport(command: CreateReportCommand): Promise<ReportRecord>;
  block(
    familyId: string,
    blockerUserId: string,
    blockedUserId: string,
  ): Promise<void>;
  unblock(
    familyId: string,
    blockerUserId: string,
    blockedUserId: string,
  ): Promise<void>;
  listBlocks(
    familyId: string,
    blockerUserId: string,
  ): Promise<BlockedUserRecord[]>;
}
