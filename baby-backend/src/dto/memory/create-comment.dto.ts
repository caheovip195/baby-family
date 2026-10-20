import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, IsUUID, MaxLength, ValidateIf } from 'class-validator';
import { MEMORY_POLICY } from '../../config/memory-policy';

const nullable = (_object: object, value: unknown) =>
  value !== undefined && value !== null;

/** `POST /memories/{id}/comments` (MEM-10, spec §7.12). */
export class CreateCommentDto {
  @ApiProperty({ maxLength: MEMORY_POLICY.commentMaxLength })
  @IsString()
  @MaxLength(MEMORY_POLICY.commentMaxLength)
  body!: string;

  @ApiPropertyOptional({
    format: 'uuid',
    nullable: true,
    description:
      'Reply to this comment (one level: replies attach to its root).',
  })
  @ValidateIf(nullable)
  @IsUUID()
  parentCommentId?: string | null;
}
