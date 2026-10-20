import { IsIn, IsString, MaxLength, MinLength } from 'class-validator';
export class RequestAccountDeletionDto {
  @IsIn(['NONE', 'DELETE_FAMILY', 'PARTNER_CONTINUES'])
  familyChoice!: 'NONE' | 'DELETE_FAMILY' | 'PARTNER_CONTINUES';

  @IsIn(['KEEP_ANONYMIZED', 'DELETE'])
  sharedContentChoice!: 'KEEP_ANONYMIZED' | 'DELETE';

  @IsString()
  @MinLength(1)
  @MaxLength(8192)
  reauthToken!: string;
}
export class CancelAccountDeletionDto {
  @IsString()
  @MinLength(1)
  @MaxLength(8192)
  reauthToken!: string;
}
