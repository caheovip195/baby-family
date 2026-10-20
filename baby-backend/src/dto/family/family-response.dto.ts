import { ApiProperty } from '@nestjs/swagger';
import type { Family } from '../../models/family.model';

export class FamilyResponseDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty() name!: string;
  @ApiProperty() status!: string;
  @ApiProperty() timezone!: string;
  @ApiProperty({ enum: ['vi', 'en'] }) contentLocale!: string;
  @ApiProperty({ type: String, format: 'uuid', nullable: true })
  coverAssetId!: string | null;
  /** FAM-07: signed cover URL (short-lived); null without a cover. */
  @ApiProperty({ type: String, nullable: true }) coverUrl!: string | null;
  @ApiProperty({ type: String, format: 'date-time', nullable: true })
  coverUrlExpiresAt!: string | null;
  @ApiProperty({ format: 'date-time' }) createdAt!: string;
  @ApiProperty({ format: 'date-time' }) updatedAt!: string;

  static fromModel(model: Family): FamilyResponseDto {
    return Object.assign(new FamilyResponseDto(), {
      id: model.id,
      name: model.name,
      status: model.status,
      timezone: model.timezone,
      contentLocale: model.contentLocale,
      coverAssetId: model.coverAssetId,
      coverUrl: null,
      coverUrlExpiresAt: null,
      createdAt: model.createdAt.toISOString(),
      updatedAt: model.updatedAt.toISOString(),
    });
  }
}
