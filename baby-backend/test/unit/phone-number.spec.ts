import { normalizePhoneNumber } from '../../src/common/auth/phone-number';

describe('normalizePhoneNumber (spec §5.3)', () => {
  it.each([
    ['0912345678', '+84912345678'],
    ['+84 912 345 678', '+84912345678'],
    ['+840912345678', '+84912345678'],
    ['0084912345678', '+84912345678'],
    ['091-234-5678', '+84912345678'],
  ])('normalises %s to E.164', (input, expected) => {
    expect(normalizePhoneNumber(input, ['84'])).toBe(expected);
  });

  it.each(['+12025550123', '091234567', '+8491234567890', '12345678', 'abc'])(
    'rejects %s when only Vietnam is allowed',
    (input) => {
      expect(normalizePhoneNumber(input, ['84'])).toBeNull();
    },
  );

  it('accepts other configured calling codes', () => {
    expect(normalizePhoneNumber('+6591234567', ['84', '65'])).toBe(
      '+6591234567',
    );
  });
});
