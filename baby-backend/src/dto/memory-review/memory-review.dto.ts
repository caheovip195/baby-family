import {
  ArrayMaxSize,
  ArrayUnique,
  IsArray,
  IsString,
  IsUUID,
  MaxLength,
  ValidateIf,
} from 'class-validator';
export class ApproveMemoryDto {
  @ValidateIf((_o: object, value: unknown) => value !== undefined)
  @IsArray()
  @ArrayUnique()
  @ArrayMaxSize(100)
  @IsUUID('all', { each: true })
  childIds?: string[];
}
export class RejectMemoryDto {
  @ValidateIf((_o: object, value: unknown) => value !== undefined)
  @IsString()
  @MaxLength(200)
  reason?: string;
}
