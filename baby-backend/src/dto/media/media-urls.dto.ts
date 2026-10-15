import { ApiProperty } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  ArrayMinSize,
  ArrayUnique,
  IsArray,
  IsUUID,
} from 'class-validator';
import { MEDIA_POLICY } from '../../config/media-policy';

export class MediaUrlsDto {
  @ApiProperty({
    type: [String],
    format: 'uuid',
    maxItems: MEDIA_POLICY.maxBatchAssets,
  })
  @IsArray()
  @ArrayMinSize(1)
  @ArrayMaxSize(MEDIA_POLICY.maxBatchAssets)
  @ArrayUnique()
  @IsUUID('all', { each: true })
  assetIds!: string[];
}
