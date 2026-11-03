import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  IsArray,
  IsBoolean,
  IsInt,
  IsOptional,
  IsString,
  IsUUID,
  Max,
  MaxLength,
  Min,
  ValidateNested,
} from 'class-validator';
import { YEAR_BOOK_POLICY } from '../../config/year-book-policy';

export class YearBookItemInputDto {
  @ApiProperty({ format: 'uuid' }) @IsUUID() memoryId!: string;

  @ApiProperty({ type: [String] })
  @IsArray()
  @ArrayMaxSize(YEAR_BOOK_POLICY.maxAssetsPerItem)
  @IsUUID('all', { each: true })
  assetIds!: string[];

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(YEAR_BOOK_POLICY.captionMaxLength)
  caption?: string;
}

export class YearBookChapterInputDto {
  @ApiProperty({ minimum: 1, maximum: 12 })
  @IsInt()
  @Min(1)
  @Max(12)
  month!: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(YEAR_BOOK_POLICY.titleMaxLength)
  title?: string;

  @ApiProperty({ type: [YearBookItemInputDto] })
  @IsArray()
  @ArrayMaxSize(YEAR_BOOK_POLICY.maxItemsPerChapter)
  @ValidateNested({ each: true })
  @Type(() => YearBookItemInputDto)
  items!: YearBookItemInputDto[];
}

/** `PUT /children/:childId/year-book/:year` · `PUT /families/:familyId/year-book/:year`. */
export class SaveYearBookDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(YEAR_BOOK_POLICY.titleMaxLength)
  title?: string;

  @ApiPropertyOptional({
    description:
      'Bản cho ông bà: người thân được xem bé (sách cả nhà: mọi người thân) đọc bản này. Cần gói có Family Circle (402 PLAN_REQUIRED_FAMILY).',
  })
  @IsOptional()
  @IsBoolean()
  sharedWithCircle?: boolean;

  @ApiProperty({ type: [YearBookChapterInputDto] })
  @IsArray()
  @ArrayMaxSize(12)
  @ValidateNested({ each: true })
  @Type(() => YearBookChapterInputDto)
  chapters!: YearBookChapterInputDto[];
}

export class YearBookPhotoDto {
  @ApiProperty({ format: 'uuid' }) assetId!: string;
  @ApiProperty({
    type: String,
    nullable: true,
    description: 'URL xem có hạn (bản ~1080px).',
  })
  url!: string | null;
}

export class YearBookItemDto {
  @ApiProperty({ format: 'uuid' }) memoryId!: string;
  @ApiProperty() kind!: string;
  @ApiProperty() occurredAt!: string;
  @ApiProperty() caption!: string;
  @ApiProperty({ type: [String], description: 'Mọi ảnh của ký ức.' })
  assetIds!: string[];
  @ApiProperty({ type: [String], description: 'Ảnh đang chọn vào sách.' })
  selectedAssetIds!: string[];
  @ApiProperty({ description: 'Ký ức có trong sách.' }) included!: boolean;
  @ApiProperty({ type: [YearBookPhotoDto] }) photos!: YearBookPhotoDto[];
}

export class YearBookChapterDto {
  @ApiProperty() month!: number;
  @ApiProperty({ type: String, nullable: true }) title!: string | null;
  @ApiProperty({ type: [YearBookItemDto] }) items!: YearBookItemDto[];
}

export class YearBookDto {
  @ApiProperty({ enum: ['CHILD', 'FAMILY'] }) scope!: 'CHILD' | 'FAMILY';
  @ApiProperty({ format: 'uuid' }) familyId!: string;
  @ApiProperty({
    type: String,
    format: 'uuid',
    nullable: true,
    description: 'null = sách cả nhà.',
  })
  childId!: string | null;
  @ApiProperty({ description: 'Tên bé, hoặc tên gia đình với sách cả nhà.' })
  childName!: string;
  @ApiProperty() year!: number;
  @ApiProperty({
    type: String,
    nullable: true,
    description: 'null = app dùng tên mặc định theo ngôn ngữ.',
  })
  title!: string | null;
  @ApiProperty({ description: 'Gói cho phép xuất PDF.' }) canExport!: boolean;
  @ApiProperty({ description: 'Parent bật được bản cho ông bà (theo gói).' })
  canShare!: boolean;
  @ApiProperty({ description: 'Người thân được xem bản đã lưu.' })
  sharedWithCircle!: boolean;
  @ApiProperty({
    description: 'Người thân đọc: chỉ ký ức đã chọn, không sửa.',
  })
  readOnly!: boolean;
  @ApiProperty({ description: 'Đã lưu chỉnh sửa.' }) saved!: boolean;
  @ApiProperty({ type: [YearBookChapterDto] }) chapters!: YearBookChapterDto[];
}

export class YearBookSummaryDto {
  @ApiProperty({ enum: ['CHILD', 'FAMILY'] }) scope!: 'CHILD' | 'FAMILY';
  @ApiProperty({ type: String, format: 'uuid', nullable: true })
  childId!: string | null;
  @ApiProperty({ description: 'Tên bé / tên gia đình.' }) name!: string;
  @ApiProperty() year!: number;
  @ApiProperty({ type: String, nullable: true }) title!: string | null;
  @ApiProperty() sharedWithCircle!: boolean;
  @ApiProperty() updatedAt!: string;
}

/** `GET /families/:familyId/year-books`. */
export class YearBookListDto {
  @ApiProperty({ type: [YearBookSummaryDto] }) items!: YearBookSummaryDto[];
}
