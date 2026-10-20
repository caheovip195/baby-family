import { ApiProperty } from '@nestjs/swagger';
import { IsIn } from 'class-validator';
import { ReactionType } from '../../common/database.enums';

/** `PUT /memories/{id}/reaction` — one reaction per person, changeable (§7.12). */
export class SetReactionDto {
  @ApiProperty({ enum: Object.values(ReactionType) })
  @IsIn(Object.values(ReactionType))
  type!: ReactionType;
}
