/**
 * Job failure that must not be retried (invalid data, unsupported media, policy
 * violation). Codes and summaries are persisted: never include payloads or PII.
 */
export class PermanentJobError extends Error {
  constructor(
    readonly code: string,
    message: string,
  ) {
    super(message);
    this.name = new.target.name;
  }
}

/** The run is leased by another live worker; retry later without consuming the run. */
export class JobBusyError extends Error {
  constructor() {
    super('Job run is being executed by another worker.');
    this.name = new.target.name;
  }
}
