import {
  createCipheriv,
  createDecipheriv,
  createHmac,
  hkdfSync,
  randomBytes,
} from 'node:crypto';
import { DomainError } from '../errors/domain.error';

/** Versioned authenticated envelopes and a COUPLE-scoped blind duplicate key. */
export class PregnancyNameCipher {
  private readonly encryptionKey: Buffer;
  private readonly lookupKey: Buffer;

  constructor(
    encodedKey: string | undefined,
    private readonly coupleSpaceId: string,
  ) {
    const root = encodedKey ? Buffer.from(encodedKey, 'base64') : null;
    if (!root || root.length !== 32)
      throw new DomainError(
        'Pregnancy name encryption is unavailable.',
        'NAME_ENCRYPTION_UNAVAILABLE',
        503,
      );
    const derive = (purpose: string) =>
      Buffer.from(
        hkdfSync(
          'sha256',
          root,
          'baby-family:pregnancy-naming:v1',
          `${coupleSpaceId}:${purpose}`,
          32,
        ),
      );
    this.encryptionKey = derive('encryption');
    this.lookupKey = derive('duplicate');
  }

  fingerprint(normalized: string): string {
    return createHmac('sha256', this.lookupKey)
      .update(normalized)
      .digest('hex');
  }

  encrypt(value: string, field: 'name' | 'meaning'): Uint8Array {
    const iv = randomBytes(12);
    const cipher = createCipheriv('aes-256-gcm', this.encryptionKey, iv);
    cipher.setAAD(Buffer.from(`${this.coupleSpaceId}:${field}`));
    const encrypted = Buffer.concat([
      cipher.update(value, 'utf8'),
      cipher.final(),
    ]);
    return Buffer.concat([
      Buffer.from([1]),
      iv,
      cipher.getAuthTag(),
      encrypted,
    ]);
  }

  decrypt(value: Uint8Array, field: 'name' | 'meaning'): string {
    try {
      const bytes = Buffer.from(value);
      if (bytes[0] !== 1 || bytes.length < 29)
        throw new Error('Invalid envelope');
      const decipher = createDecipheriv(
        'aes-256-gcm',
        this.encryptionKey,
        bytes.subarray(1, 13),
      );
      decipher.setAAD(Buffer.from(`${this.coupleSpaceId}:${field}`));
      decipher.setAuthTag(bytes.subarray(13, 29));
      return Buffer.concat([
        decipher.update(bytes.subarray(29)),
        decipher.final(),
      ]).toString('utf8');
    } catch {
      throw new DomainError(
        'The encrypted pregnancy name cannot be read.',
        'NAME_UNREADABLE',
        503,
      );
    }
  }
}
