import { ApiProperty } from '@nestjs/swagger';
import { IsIn } from 'class-validator';

export class LifecycleArchivePregnancyDto {
  @ApiProperty({ enum: ['ARCHIVED', 'ENDED_PRIVATE'] })
  @IsIn(['ARCHIVED', 'ENDED_PRIVATE'])
  reason!: 'ARCHIVED' | 'ENDED_PRIVATE';
}
