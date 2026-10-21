export const ERROR_REPORTER = Symbol('ERROR_REPORTER');
export interface ErrorReport {
  requestId?: string;
  route: string;
  status: number;
}
/** Receives metadata only: never pass exceptions, headers, bodies or user identifiers. */
export interface IErrorReporter {
  report(event: ErrorReport): void;
}
