import { DeletionRequest } from './deletion-request.model';

export type AccountDeletionStep =
  | 'PRIVATE_DATA'
  | 'CIRCLE'
  | 'SHARED_CONTENT'
  | 'FAMILY_DATA'
  | 'MEMBERSHIP'
  | 'IDENTITY';

export class AccountDeletionRequest extends DeletionRequest {
  hasStep(step: string): boolean {
    return (
      typeof this.steps === 'object' &&
      this.steps !== null &&
      !Array.isArray(this.steps) &&
      step in this.steps
    );
  }
}

export class AccountDeletionScope {
  constructor(
    readonly userId: string,
    readonly status: string,
    readonly familyId: string | null,
    readonly membershipId: string | null,
    readonly otherParentCount: number,
    readonly isPayer: boolean,
  ) {}
}

export class AccountDeletionPurgeObject {
  constructor(
    readonly assetId: string,
    readonly bucket: string,
    readonly key: string,
    readonly kind: 'asset' | 'export' = 'asset',
  ) {}
}
