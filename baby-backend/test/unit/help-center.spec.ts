import { ConfigService } from '@nestjs/config';
import { ValidationError } from '../../src/common/errors/domain.error';
import { HELP_CENTER_CATALOG } from '../../src/config/help-center';
import { HelpCenterService } from '../../src/services/help-center.service';

describe('HelpCenterService (SET-11/12)', () => {
  it('returns the versioned FAQ in the requested locale', () => {
    const service = new HelpCenterService(new ConfigService({}));
    const vi = service.get();
    const en = service.get('en');
    expect(vi.version).toBe(HELP_CENTER_CATALOG.version);
    expect(vi.faqs.map((faq) => faq.id)).toEqual(
      HELP_CENTER_CATALOG.faqs.map((faq) => faq.id),
    );
    expect(vi.faqs[0]!.question).not.toBe(en.faqs[0]!.question);
    for (const faq of [...vi.faqs, ...en.faqs]) {
      expect(faq.question.length).toBeGreaterThan(0);
      expect(faq.answer.length).toBeGreaterThan(0);
    }
  });

  it('hides contact and legal links until they are configured', () => {
    expect(new HelpCenterService(new ConfigService({})).get()).toMatchObject({
      contact: { email: null, hotline: null },
      legal: { termsUrl: null, privacyUrl: null, licensesUrl: null },
    });
    const configured = new HelpCenterService(
      new ConfigService({
        SUPPORT_CONTACT_EMAIL: 'help@example.test',
        LEGAL_TERMS_URL: 'https://example.test/terms',
      }),
    ).get('en');
    expect(configured.contact.email).toBe('help@example.test');
    expect(configured.legal.termsUrl).toBe('https://example.test/terms');
  });

  it('rejects unsupported locales', () => {
    expect(() =>
      new HelpCenterService(new ConfigService({})).get('fr' as 'vi'),
    ).toThrow(ValidationError);
  });
});
