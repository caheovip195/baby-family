import type { ObservabilitySnapshot } from '../../models/observability-snapshot.model';

export const OBSERVABILITY_REPOSITORY = Symbol('OBSERVABILITY_REPOSITORY');

export interface IObservabilityRepository {
  getSnapshot(since: Date): Promise<ObservabilitySnapshot>;
}
