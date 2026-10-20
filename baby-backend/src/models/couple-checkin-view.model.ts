import type { MoodCheckin } from './mood-checkin.model';
/** Resolved only from active server-owned pair membership. */
export class CoupleCheckinScope {
  constructor(
    public readonly familyId: string,
    public readonly coupleSpaceId: string,
    public readonly userId: string,
    public readonly partnerUserId: string,
  ) {}
}
export class CoupleCheckinView {
  constructor(public readonly checkin: MoodCheckin) {}
  isCurrent(now: Date): boolean {
    return !this.checkin.deletedAt && this.checkin.expiresAt > now;
  }
}
