import { ApiProperty } from '@nestjs/swagger';
import type { Family } from '../../models/family.model';

export class FamilyResponseDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty() name!: string;
  @ApiProperty() status!: string;
  @ApiProperty() timezone!: string;
  @ApiProperty({ format: 'date-time' }) createdAt!: string;
  @ApiProperty({ format: 'date-time' }) updatedAt!: string;

  static fromModel(model: Family): FamilyResponseDto {
    return Object.assign(new FamilyResponseDto(), {
      id: model.id,
      name: model.name,
      status: model.status,
      timezone: model.timezone,
      createdAt: model.createdAt.toISOString(),
      updatedAt: model.updatedAt.toISOString(),
    });
  }
}
