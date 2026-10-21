/** Aggregate operational counts only: no identifiers or payloads leave persistence. */
export class ObservabilitySnapshot {
  constructor(
    public readonly failedJobs: number,
    public readonly timedOutAttempts: number,
    public readonly jobBacklog: number,
    public readonly outboxBacklog: number,
  ) {}
}
