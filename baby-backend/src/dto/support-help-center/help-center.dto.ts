import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsIn, ValidateIf } from 'class-validator';
import { HELP_CENTER_CATALOG } from '../../config/help-center';

export class HelpCenterQueryDto {
  @ApiPropertyOptional({ enum: HELP_CENTER_CATALOG.locales, default: 'vi' })
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsIn(HELP_CENTER_CATALOG.locales)
  locale?: 'vi' | 'en';
}

export interface HelpCenterResponseDto {
  version: number;
  faqs: { id: string; category: string; question: string; answer: string }[];
  contact: { email: string | null; hotline: string | null };
  legal: {
    termsUrl: string | null;
    privacyUrl: string | null;
    licensesUrl: string | null;
  };
}
