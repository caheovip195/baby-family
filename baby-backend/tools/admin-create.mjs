import 'dotenv/config';
import { createRequire } from 'node:module';
const require = createRequire(import.meta.url);
require('ts-node').register({ project: 'tsconfig.tools.json' });
const { ConfigService } = require('@nestjs/config');
const { PrismaService } = require('../src/database/prisma.service.ts');
const {
  AdminCmsAuthRepository,
} = require('../src/repositories/admin-cms-auth.repository.ts');
const {
  hashAdminPassword,
  encryptAdminTotpSecret,
  adminTotpCode,
} = require('../src/common/auth/admin-cms-crypto.ts');
async function main() {
  const email = (process.env.ADMIN_CREATE_EMAIL ?? '').trim().toLowerCase();
  const password = process.env.ADMIN_CREATE_PASSWORD ?? '';
  const secret = process.env.ADMIN_CREATE_TOTP_SECRET ?? '';
  const roles = (process.env.ADMIN_CREATE_ROLES ?? 'SUPER_ADMIN')
    .split(',')
    .map((value) => value.trim());
  const known = [
    'SUPPORT',
    'MODERATOR',
    'CONTENT',
    'BILLING_OPS',
    'OPS',
    'ADMIN',
    'SUPER_ADMIN',
  ];
  if (
    !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email) ||
    password.length < 16 ||
    password.length > 1024 ||
    roles.length === 0 ||
    roles.some((value) => !known.includes(value))
  )
    throw new Error(
      'Provide ADMIN_CREATE_EMAIL, ADMIN_CREATE_PASSWORD (16–1024 characters), ADMIN_CREATE_TOTP_SECRET (base32), ADMIN_CREATE_ROLES (comma separated).',
    );
  adminTotpCode(secret);
  const encrypted = encryptAdminTotpSecret(secret);
  if (!process.env.DATABASE_URL) throw new Error('DATABASE_URL is required.');
  const database = new PrismaService(
    new ConfigService({
      DATABASE_URL: process.env.DATABASE_URL,
      DATABASE_POOL_SIZE: 2,
    }),
  );
  try {
    await database.$connect();
    const id = await new AdminCmsAuthRepository(database).createAdmin({
      email,
      passwordHash: await hashAdminPassword(password),
      totpSecretEnc: encrypted,
      roles,
    });
    process.stdout.write(`Created admin ${id}.\n`);
  } finally {
    await database.$disconnect();
  }
}
main().catch(() => {
  process.stderr.write(
    'Admin creation failed. Check required environment, unique email and database access.\n',
  );
  process.exitCode = 1;
});
