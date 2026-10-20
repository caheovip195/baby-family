import { IsInt, IsUUID, Max, Min } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
export class SetMonthlyPhotoDto {
  @ApiProperty({ format: 'uuid' }) @IsUUID() memoryId!: string;
  @ApiProperty({ format: 'uuid' }) @IsUUID() assetId!: string;
}
export class PostMonthlyPhotoDto extends SetMonthlyPhotoDto {
  @ApiProperty({ minimum: 0, maximum: 240 })
  @IsInt()
  @Min(0)
  @Max(240)
  monthIndex!: number;
}
export class MonthlyPhotoSelectionDto {
  @ApiProperty() monthIndex!: number;
  @ApiProperty() memoryId!: string;
  @ApiProperty({ nullable: true, type: String }) url!: string | null;
  @ApiProperty() occurredAt!: string;
}
