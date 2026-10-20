import { IsOptional, IsString, IsUUID, Matches } from 'class-validator';

export class CalendarQueryDto {
  @IsString()
  @Matches(/^\d{4}-\d{2}-\d{2}$/, {
    message: 'from must be in YYYY-MM-DD format',
  })
  from!: string;

  @IsString()
  @Matches(/^\d{4}-\d{2}-\d{2}$/, {
    message: 'to must be in YYYY-MM-DD format',
  })
  to!: string;

  @IsOptional()
  @IsUUID()
  childId?: string;
}
