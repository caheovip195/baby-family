import { ApiProperty } from '@nestjs/swagger';
import type { Pregnancy } from '../../models/pregnancy.model';
import { PaginationMetaDto } from '../note/note-response.dto';

export class PregnancyResponseDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ format: 'uuid' }) familyId!: string;
  @ApiProperty() seqNo!: number;
  @ApiProperty() nickname!: string;
  @ApiProperty({ type: String, nullable: true, format: 'date' }) dueDate!:
    string | null;
  @ApiProperty() expectedCount!: number;
  @ApiProperty() status!: string;
  @ApiProperty({ format: 'date-time' }) createdAt!: string;
  @ApiProperty({ format: 'date-time' }) updatedAt!: string;

  static fromModel(model: Pregnancy): PregnancyResponseDto {
    return Object.assign(new PregnancyResponseDto(), {
      id: model.id,
      familyId: model.familyId,
      seqNo: model.seqNo,
      nickname: model.nickname,
      dueDate: model.dueDate?.toISOString().slice(0, 10) ?? null,
      expectedCount: model.expectedCount,
      status: model.status,
      createdAt: model.createdAt.toISOString(),
      updatedAt: model.updatedAt.toISOString(),
    });
  }
}
export class PregnancyPageDto {
  @ApiProperty({ type: [PregnancyResponseDto] }) data!: PregnancyResponseDto[];
  @ApiProperty({ type: PaginationMetaDto }) meta!: PaginationMetaDto;
}
