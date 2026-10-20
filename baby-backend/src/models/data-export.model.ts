import { ExportJob } from './export-job.model';
import type { JournalEntry } from './journal-entry.model';
import type { MoodCheckin } from './mood-checkin.model';
import type { Appreciation } from './appreciation.model';
import type { Request } from './request.model';
import type { Asset } from './asset.model';

export class DataExport extends ExportJob {
  isReady(now: Date): boolean {
    return (
      this.status === 'COMPLETED' &&
      this.storageKey !== null &&
      this.expiresAt !== null &&
      this.expiresAt > now
    );
  }
}

/** Explicit aggregate projection: contains no identity/session credentials. */
export class DataExportSnapshot {
  constructor(
    readonly data: Record<string, unknown>,
    readonly journal: JournalEntry[],
    readonly moods: MoodCheckin[],
    readonly appreciations: Appreciation[],
    readonly requests: Request[],
    readonly assets: Asset[],
  ) {}
}
