import { DomainError } from '../errors/domain.error';
import type {
  IOfflineCommandService,
  OfflineCommand,
} from '../../interfaces/services/offline-command-service.interface';
/** Missing registration fails closed for keyed commands; legacy clients keep working. */
export function offlineCommand<T>(
  service: IOfflineCommandService | undefined,
  key: string | undefined,
  command: OfflineCommand,
  work: () => Promise<T>,
  authorize?: () => Promise<unknown>,
): Promise<T> {
  if (!key) return work();
  if (!service)
    throw new DomainError(
      'Offline command service is not registered.',
      'SERVICE_UNAVAILABLE',
      503,
    );
  return service.execute(command, key, work, authorize);
}
