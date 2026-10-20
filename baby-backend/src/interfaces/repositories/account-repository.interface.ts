import type { OnboardingRole, Platform } from '../../common/database.enums';
import type { AccountOverview } from '../../models/account-overview.model';
import type { User } from '../../models/user.model';
import type { UserDevice } from '../../models/user-device.model';

export const ACCOUNT_REPOSITORY = Symbol('ACCOUNT_REPOSITORY');

export interface RegisterDeviceInput {
  platform: Platform;
  pushToken: string | null;
  pushEnabled: boolean;
  appVersion: string | null;
  osVersion: string | null;
  deviceModel: string | null;
  locale: string | null;
  timezone: string | null;
}

export interface ConsentInput {
  document: string;
  version: string;
  granted: boolean;
}

export type SetOnboardingRoleResult =
  | { kind: 'UPDATED'; user: User }
  /** Spec §11.3: the role is fixed once the user belongs to a family. */
  | { kind: 'LOCKED' }
  | { kind: 'NOT_FOUND' };

/** Account-level reads/writes behind `/me` (spec §5.5, §6.5, §11.3). */
export interface IAccountRepository {
  findOverview(userId: string): Promise<AccountOverview | null>;
  setOnboardingRole(
    userId: string,
    role: OnboardingRole,
  ): Promise<SetOnboardingRoleResult>;
  /** Creates or updates the device bound to the caller's session. */
  registerDevice(
    userId: string,
    sessionId: string,
    input: RegisterDeviceInput,
    now: Date,
  ): Promise<UserDevice>;
  recordConsents(
    userId: string,
    consents: ConsentInput[],
    context: { platform: Platform | null; ip: string | null },
  ): Promise<void>;
}
