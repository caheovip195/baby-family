import { ApiProperty } from '@nestjs/swagger';
import type { NoteAttributes } from '../../models/note.model';

export class NoteResponseDto implements NoteAttributes {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty() title!: string;
  @ApiProperty({ type: String, nullable: true }) content!: string | null;
  @ApiProperty({ type: String, format: 'date-time' }) createdAt!: Date;
  @ApiProperty({ type: String, format: 'date-time' }) updatedAt!: Date;
  @ApiProperty({ type: String, format: 'date-time', nullable: true })
  deletedAt!: Date | null;
}

export class PaginationMetaDto {
  @ApiProperty() page!: number;
  @ApiProperty() limit!: number;
  @ApiProperty() total!: number;
  @ApiProperty() totalPages!: number;
}

export class NotePageDto {
  @ApiProperty({ type: [NoteResponseDto] }) data!: NoteResponseDto[];
  @ApiProperty({ type: PaginationMetaDto }) meta!: PaginationMetaDto;
}
