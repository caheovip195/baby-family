import { ApiProperty } from '@nestjs/swagger';
import type { User } from '../../models/user.model';

export class UserResponseDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ type: String, nullable: true, format: 'uuid' })
  avatarAssetId!: string | null;
  @ApiProperty({ type: String, nullable: true }) avatarUrl!: string | null;
  @ApiProperty({ type: String, format: 'date-time', nullable: true })
  avatarUrlExpiresAt!: Date | null;
  @ApiProperty() displayName!: string;
  @ApiProperty() locale!: string;
  @ApiProperty() timezone!: string;
  @ApiProperty({ format: 'date-time' }) createdAt!: string;
  @ApiProperty({ format: 'date-time' }) updatedAt!: string;

  static fromModel(model: User): UserResponseDto {
    return Object.assign(new UserResponseDto(), {
      id: model.id,
      avatarAssetId: model.avatarAssetId,
      avatarUrl: null,
      avatarUrlExpiresAt: null,
      displayName: model.displayName,
      locale: model.locale,
      timezone: model.timezone,
      createdAt: model.createdAt.toISOString(),
      updatedAt: model.updatedAt.toISOString(),
    });
  }
}
