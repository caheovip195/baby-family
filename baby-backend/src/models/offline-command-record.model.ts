export class OfflineCommandRecord {
  constructor(
    readonly id: string,
    readonly requestHash: Uint8Array,
    readonly status: string,
    readonly response: string | null,
  ) {}
}
