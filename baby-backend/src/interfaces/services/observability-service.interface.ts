export const OBSERVABILITY_SERVICE = Symbol('OBSERVABILITY_SERVICE');

export interface IObservabilityService {
  /** route must be the registered router template, never the request URL. */
  recordRequest(route: string, status: number, durationMs: number): void;
  renderMetrics(authorization?: string): Promise<string>;
}
