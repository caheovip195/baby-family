/**
 * Normalises a phone number to E.164 and enforces the allowed calling codes
 * (spec §5.3 anti SMS-pumping). Without libphonenumber this keeps rules narrow:
 * Vietnamese numbers (+84) must have 9 national digits after dropping the trunk 0;
 * other allowed codes accept 8–15 total digits.
 * Returns null when the number is invalid or its country is not allowed.
 */
export function normalizePhoneNumber(
  input: string,
  allowedCallingCodes: readonly string[],
): string | null {
  const compact = input.replace(/[\s.-]/g, '');
  let digits: string;
  if (compact.startsWith('+')) digits = compact.slice(1);
  else if (compact.startsWith('00')) digits = compact.slice(2);
  else if (compact.startsWith('0') && allowedCallingCodes.includes('84'))
    digits = `84${compact.slice(1)}`;
  else return null;
  if (!/^[1-9][0-9]{7,14}$/.test(digits)) return null;
  const callingCode = [...allowedCallingCodes]
    .sort((a, b) => b.length - a.length)
    .find((code) => digits.startsWith(code));
  if (!callingCode) return null;
  if (callingCode === '84') {
    const national = digits.slice(2).replace(/^0/, '');
    if (!/^[1-9][0-9]{8}$/.test(national)) return null;
    return `+84${national}`;
  }
  return `+${digits}`;
}
