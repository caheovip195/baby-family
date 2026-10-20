import { ApiProperty } from '@nestjs/swagger';
import { IsString, MaxLength } from 'class-validator';
import { MEMORY_POLICY } from '../../config/memory-policy';

/** `PATCH /comments/{id}` — the author, within 15 minutes (spec §7.12). */
export class UpdateCommentDto {
  @ApiProperty({ maxLength: MEMORY_POLICY.commentMaxLength })
  @IsString()
  @MaxLength(MEMORY_POLICY.commentMaxLength)
  body!: string;
}
