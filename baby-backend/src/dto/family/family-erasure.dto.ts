import { IsOptional, IsString, MaxLength, MinLength } from 'class-validator';
export class ConfirmFamilyErasureDto {
  @IsString() @MinLength(1) @MaxLength(8192) reauthToken!: string;
}
export class RequestFamilyErasureDto extends ConfirmFamilyErasureDto {
  @IsOptional() @IsString() @MaxLength(80) reason?: string;
}
