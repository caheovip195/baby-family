import type { JournalEntry } from './journal-entry.model';

export class CoupleJournalScope {
  constructor(
    public readonly familyId: string,
    public readonly userId: string,
    public readonly coupleSpaceId: string,
    public readonly partnerUserId: string,
  ) {}
}

export class CoupleJournalEntryView {
  constructor(
    public readonly entry: JournalEntry,
    public readonly assetIds: string[] = [],
  ) {}

  isOwner(userId: string): boolean {
    return this.entry.userId === userId && !this.entry.deletedAt;
  }
}
