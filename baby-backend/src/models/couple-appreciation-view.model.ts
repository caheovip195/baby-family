import type { Appreciation } from './appreciation.model';

export class CoupleAppreciationScope {
  constructor(
    public readonly familyId: string,
    public readonly coupleSpaceId: string,
    public readonly userId: string,
    public readonly partnerUserId: string,
  ) {}
}

export class CoupleAppreciationView {
  constructor(public readonly appreciation: Appreciation) {}

  isVisibleTo(userId: string): boolean {
    if (this.appreciation.deletedAt) return false;
    if (this.appreciation.fromUserId === userId) {
      return !this.appreciation.deletedByFromAt;
    }
    if (this.appreciation.toUserId === userId) {
      return !this.appreciation.deletedByToAt;
    }
    return false;
  }
}
