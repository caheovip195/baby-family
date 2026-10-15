/** Ownership of one attempt of a job run; every write must match the fencing token. */
export class JobLease {
  constructor(
    readonly runId: string,
    readonly attemptNumber: number,
    readonly fencingToken: bigint,
    readonly maxAttempts: number,
    readonly workerId: string,
  ) {}

  isLastAttempt(): boolean {
    return this.attemptNumber >= this.maxAttempts;
  }
}
