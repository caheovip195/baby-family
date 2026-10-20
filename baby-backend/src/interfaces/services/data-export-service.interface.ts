import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  CreateDataExportDto,
  DataExportResponseDto,
} from '../../dto/account/data-export.dto';
import type { DataExport } from '../../models/data-export.model';
import type { JobContext } from './job-runner-service.interface';

export const DATA_EXPORT_SERVICE = Symbol('DATA_EXPORT_SERVICE');
export interface IDataExportService {
  create(
    actor: AuthPrincipal,
    input: CreateDataExportDto,
  ): Promise<DataExportResponseDto>;
  find(actor: AuthPrincipal, id: string): Promise<DataExportResponseDto>;
  pending(limit?: number): Promise<DataExport[]>;
  execute(id: string, context: JobContext): Promise<Record<string, number>>;
  purgeExpired(context: JobContext): Promise<Record<string, number>>;
}
