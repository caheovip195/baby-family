import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsBoolean,
  IsIn,
  IsString,
  Matches,
  MaxLength,
  MinLength,
  ValidateIf,
  ValidateNested,
} from 'class-validator';

const optional = () =>
  ValidateIf((_object, value: unknown) => value !== undefined);

export class CreateFamilyParentDto {
  @ApiPropertyOptional({
    enum: ['FATHER', 'MOTHER'],
    description: 'Defaults from the onboarding role.',
  })
  @optional()
  @IsIn(['FATHER', 'MOTHER'])
  kind?: 'FATHER' | 'MOTHER';

  @ApiPropertyOptional({
    maxLength: 20,
    description: 'Empty → Papa/Mama by kind.',
  })
  @optional()
  @IsString()
  @MaxLength(20)
  callName?: string;
}

export class CreateFamilyDto {
  @ApiProperty({ maxLength: 80, example: 'Nhà của Hana' })
  @IsString()
  @MinLength(1)
  @MaxLength(80)
  name!: string;

  @ApiPropertyOptional({ type: CreateFamilyParentDto })
  @optional()
  @ValidateNested()
  @Type(() => CreateFamilyParentDto)
  parent?: CreateFamilyParentDto;
}

export class CreatePartnerInviteDto {
  @ApiPropertyOptional({
    enum: ['FATHER', 'MOTHER'],
    description: 'Role offered; defaults to the other kind.',
  })
  @optional()
  @IsIn(['FATHER', 'MOTHER'])
  kind?: 'FATHER' | 'MOTHER';

  @ApiPropertyOptional({ maxLength: 300 })
  @optional()
  @IsString()
  @MaxLength(300)
  message?: string;

  @ApiPropertyOptional({
    default: true,
    description: '§7.3 “Tôi xác nhận lần cuối”.',
  })
  @optional()
  @IsBoolean()
  requireFinalApproval?: boolean;
}

/** Either the link token or the 8-character code (INV-05). */
export class InviteReferenceDto {
  @ApiPropertyOptional({ description: 'Token from the invite link.' })
  @ValidateIf((object: InviteReferenceDto) => object.code === undefined)
  @IsString()
  @Matches(/^[A-Za-z0-9_-]{20,100}$/)
  token?: string;

  @ApiPropertyOptional({ example: 'K7Q29MXA' })
  @ValidateIf((object: InviteReferenceDto) => object.token === undefined)
  @IsString()
  @Matches(/^[A-Za-z0-9 -]{8,12}$/)
  code?: string;
}

export class AcceptInviteDto extends InviteReferenceDto {
  @ApiPropertyOptional({ maxLength: 20 })
  @optional()
  @IsString()
  @MaxLength(20)
  callName?: string;
}
