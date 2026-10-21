import { IsUUID } from 'class-validator';

export class SetDefaultFamilyDto {
  @IsUUID()
  familyId!: string;
}

export interface MeFamilyResponse {
  familyId: string;
  name: string;
  role: 'PARENT' | 'CIRCLE';
  status: { family: string; membership: string };
  coverUrl: string | null;
  isDefault: boolean;
}
