import { ApiProperty } from '@nestjs/swagger';
import type { Child } from '../../models/child.model';
import { PaginationMetaDto } from '../note/note-response.dto';

export class ChildResponseDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ format: 'uuid' }) familyId!: string;
  @ApiProperty({ type: String, nullable: true }) name!: string | null;
  @ApiProperty({ type: String, nullable: true }) nickname!: string | null;
  @ApiProperty({ format: 'date' }) birthDate!: string;
  @ApiProperty({ type: String, nullable: true }) birthTime!: string | null;
  @ApiProperty() gender!: string;
  @ApiProperty() colorIndex!: number;
  @ApiProperty() status!: string;
  @ApiProperty({ format: 'date-time' }) createdAt!: string;
  @ApiProperty({ format: 'date-time' }) updatedAt!: string;

  static fromModel(model: Child): ChildResponseDto {
    return Object.assign(new ChildResponseDto(), {
      id: model.id,
      familyId: model.familyId,
      name: model.name,
      nickname: model.nickname,
      birthDate: model.birthDate.toISOString().slice(0, 10),
      birthTime: model.birthTime?.toISOString().slice(11, 16) ?? null,
      gender: model.gender,
      colorIndex: model.colorIndex,
      status: model.status,
      createdAt: model.createdAt.toISOString(),
      updatedAt: model.updatedAt.toISOString(),
    });
  }
}
export class ChildPageDto {
  @ApiProperty({ type: [ChildResponseDto] }) data!: ChildResponseDto[];
  @ApiProperty({ type: PaginationMetaDto }) meta!: PaginationMetaDto;
}
