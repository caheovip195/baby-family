import {
  createCipheriv,
  createDecipheriv,
  createHash,
  createHmac,
  randomBytes,
  scrypt,
  timingSafeEqual,
} from 'node:crypto';
import { promisify } from 'node:util';
import { DomainError } from '../errors/domain.error';
const derive = promisify(scrypt);
export const ADMIN_CMS_ISSUER = 'baby-family-admin';
export const ADMIN_CMS_AUDIENCE = 'baby-family-admin-cms';
export function adminCmsKey(name: string): Buffer {
  const key = Buffer.from(process.env[name] ?? '', 'base64');
  if (key.length !== 32)
    throw new DomainError(
      'Admin authentication key is unavailable.',
      'ADMIN_AUTH_UNAVAILABLE',
      503,
    );
  return key;
}
export async function hashAdminPassword(password: string): Promise<string> {
  const salt = randomBytes(16);
  const hash = (await derive(password, salt, 64)) as Buffer;
  return `scrypt$${salt.toString('hex')}$${hash.toString('hex')}`;
}
export async function verifyAdminPassword(
  password: string,
  encoded: string,
): Promise<boolean> {
  const [algorithm, salt, hash] = encoded.split('$');
  if (
    algorithm !== 'scrypt' ||
    !salt ||
    !hash ||
    !/^[a-f0-9]{32}$/.test(salt) ||
    !/^[a-f0-9]{128}$/.test(hash)
  )
    return false;
  const actual = (await derive(
    password,
    Buffer.from(salt, 'hex'),
    64,
  )) as Buffer;
  return timingSafeEqual(actual, Buffer.from(hash, 'hex'));
}
export function encryptAdminTotpSecret(
  secret: string,
): Uint8Array<ArrayBuffer> {
  const iv = randomBytes(12);
  const cipher = createCipheriv(
    'aes-256-gcm',
    adminCmsKey('ADMIN_CMS_TOTP_ENCRYPTION_KEY'),
    iv,
  );
  cipher.setAAD(Buffer.from(ADMIN_CMS_ISSUER));
  return new Uint8Array(
    Buffer.concat([
      iv,
      cipher.update(secret, 'utf8'),
      cipher.final(),
      cipher.getAuthTag(),
    ]),
  );
}
export function decryptAdminTotpSecret(value: Uint8Array): string {
  const buffer = Buffer.from(value);
  const cipher = createDecipheriv(
    'aes-256-gcm',
    adminCmsKey('ADMIN_CMS_TOTP_ENCRYPTION_KEY'),
    buffer.subarray(0, 12),
  );
  cipher.setAAD(Buffer.from(ADMIN_CMS_ISSUER));
  cipher.setAuthTag(buffer.subarray(-16));
  return Buffer.concat([
    cipher.update(buffer.subarray(12, -16)),
    cipher.final(),
  ]).toString('utf8');
}
export function adminTotpCode(secret: string, at: Date = new Date()): string {
  const normalized = secret.toUpperCase().replace(/=+$/, '');
  if (!/^[A-Z2-7]{16,128}$/.test(normalized))
    throw new Error('Invalid TOTP base32 secret.');
  let bits = '';
  for (const char of normalized)
    bits += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567'
      .indexOf(char)
      .toString(2)
      .padStart(5, '0');
  const bytes = [];
  for (let i = 0; i + 8 <= bits.length; i += 8)
    bytes.push(parseInt(bits.slice(i, i + 8), 2));
  const counter = Buffer.alloc(8);
  counter.writeBigUInt64BE(BigInt(Math.floor(at.getTime() / 30000)));
  const digest = createHmac('sha1', Buffer.from(bytes))
    .update(counter)
    .digest();
  const offset = digest[19]! & 15;
  return ((digest.readUInt32BE(offset) & 0x7fffffff) % 1000000)
    .toString()
    .padStart(6, '0');
}
export function verifyAdminTotp(secret: string, code: string): boolean {
  if (!/^\d{6}$/.test(code)) return false;
  return [-1, 0, 1].some((window) =>
    timingSafeEqual(
      Buffer.from(adminTotpCode(secret, new Date(Date.now() + window * 30000))),
      Buffer.from(code),
    ),
  );
}
export function adminTokenHash(token: string): Buffer {
  return createHash('sha256')
    .update(`${ADMIN_CMS_ISSUER}\0${ADMIN_CMS_AUDIENCE}\0${token}`)
    .digest();
}

export function adminTotpStep(secret: string, code: string): Date | null {
  if (!/^\d{6}$/.test(code)) return null;
  const now = Date.now();
  for (const offset of [-1, 0, 1]) {
    const step = new Date(Math.floor(now / 30000) * 30000 + offset * 30000);
    if (
      timingSafeEqual(
        Buffer.from(adminTotpCode(secret, step)),
        Buffer.from(code),
      )
    )
      return step;
  }
  return null;
}
