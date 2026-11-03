export const ERROR_REPORTER = Symbol('ERROR_REPORTER');
export interface ErrorReport {
  requestId?: string;
  route: string;
  status: number;
}
/** Background job that failed permanently: policy name, our own error code and attempt only. */
export interface JobErrorReport {
  job: string;
  code: string;
  attempt: number;
}
/** Receives metadata only: never pass exceptions, headers, bodies, payloads or user identifiers. */
export interface IErrorReporter {
  report(event: ErrorReport): void;
  reportJob(event: JobErrorReport): void;
}
