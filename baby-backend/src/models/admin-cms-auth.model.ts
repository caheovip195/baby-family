export type AdminCmsActor = Readonly<{
  id: string;
  roles: string[];
  sessionId: string;
}>;
export class AdminCmsAuthUser {
  constructor(
    public readonly id: string,
    public readonly passwordHash: string,
    public readonly totpSecretEnc: Uint8Array,
    public readonly roles: string[],
    public readonly status: string,
  ) {}
}
export class AdminCmsAuthSession {
  constructor(
    public readonly id: string,
    public readonly adminId: string,
    public readonly roles: string[],
  ) {}
}
