import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { ValidationError } from '../common/errors/domain.error';
import type { Environment } from '../config/environment';
import { HELP_CENTER_CATALOG } from '../config/help-center';
import type { HelpCenterResponseDto } from '../dto/support-help-center/help-center.dto';
import type { IHelpCenterService } from '../interfaces/services/help-center-service.interface';

@Injectable()
export class HelpCenterService implements IHelpCenterService {
  constructor(private readonly config: ConfigService<Environment, true>) {}

  get(locale: 'vi' | 'en' = 'vi'): HelpCenterResponseDto {
    if (!HELP_CENTER_CATALOG.locales.includes(locale))
      throw new ValidationError('Locale must be vi or en.');
    type TextKey =
      | 'SUPPORT_CONTACT_EMAIL'
      | 'SUPPORT_CONTACT_HOTLINE'
      | 'LEGAL_TERMS_URL'
      | 'LEGAL_PRIVACY_URL'
      | 'LEGAL_LICENSES_URL';
    const value = (key: TextKey): string | null =>
      this.config.get<string | undefined>(key) || null;
    return {
      version: HELP_CENTER_CATALOG.version,
      faqs: HELP_CENTER_CATALOG.faqs.map((faq) => ({
        id: faq.id,
        category: faq.category,
        question: faq[locale].question,
        answer: faq[locale].answer,
      })),
      contact: {
        email: value('SUPPORT_CONTACT_EMAIL'),
        hotline: value('SUPPORT_CONTACT_HOTLINE'),
      },
      legal: {
        termsUrl: value('LEGAL_TERMS_URL'),
        privacyUrl: value('LEGAL_PRIVACY_URL'),
        licensesUrl: value('LEGAL_LICENSES_URL'),
      },
    };
  }
}
