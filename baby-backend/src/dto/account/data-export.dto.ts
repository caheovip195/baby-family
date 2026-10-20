import { IsIn, IsOptional, IsUUID } from 'class-validator';

export class CreateDataExportDto {
  @IsOptional()
  @IsIn(['PERSONAL', 'FAMILY'])
  scope?: 'PERSONAL' | 'FAMILY';

  @IsOptional()
  @IsUUID()
  familyId?: string;
}

export interface DataExportResponseDto {
  id: string;
  scope: string;
  status: string;
  createdAt: string;
  completedAt: string | null;
  expiresAt: string | null;
  errorCode: string | null;
  download: { url: string; expiresAt: string } | null;
}
