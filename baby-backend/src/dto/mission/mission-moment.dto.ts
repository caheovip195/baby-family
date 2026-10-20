import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  IsArray,
  IsIn,
  IsString,
  IsUUID,
  MaxLength,
  ValidateIf,
} from 'class-validator';
import { Visibility } from '../../common/database.enums';

const optional = (_object: object, value: unknown) => value !== undefined;

/** CARE-06 `POST /missions/:id/moment` (Idempotency-Key). */
export class SaveMissionMomentDto {
  @ApiPropertyOptional({ maxLength: 2000 })
  @ValidateIf(optional)
  @IsString()
  @MaxLength(2000)
  body?: string;

  @ApiPropertyOptional({ type: [String] })
  @ValidateIf(optional)
  @IsArray()
  @ArrayMaxSize(20)
  @IsUUID('all', { each: true })
  assetIds?: string[];

  @ApiPropertyOptional({ enum: Object.values(Visibility) })
  @ValidateIf(optional)
  @IsIn(Object.values(Visibility))
  visibility?: Visibility;
}
