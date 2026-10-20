import { CircleRelation, GrantPermission } from '../common/database.enums';
import type {
  CircleRelation as Relation,
  GrantPermission as Permission,
} from '../common/database.enums';
import { ValidationError } from '../common/errors/domain.error';

/** Stored invite protocol. Unknown versions fail closed; quota comes from catalog. */
export const CIRCLE_POLICY = {
  payloadVersion: 1,
  inviteTtlMs: 14 * 86400000,
  maxGrants: 100,
} as const;
export interface CircleGrantInput {
  childId?: string;
  pregnancyId?: string;
  allowDownload: boolean;
  permission?: Permission;
}
export interface CircleInvitePayload {
  version: 1;
  relation: Relation;
  displayName: string;
  allowDownload: boolean;
  grants: CircleGrantInput[];
  message: string | null;
}
export function parseCirclePayload(value: unknown): CircleInvitePayload {
  if (!value || typeof value !== 'object')
    throw new ValidationError('Invalid Circle payload.');
  const raw = value as Record<string, unknown>;
  if (
    raw.version !== 1 ||
    !Object.values(CircleRelation).includes(raw.relation as Relation) ||
    typeof raw.displayName !== 'string' ||
    !raw.displayName.trim() ||
    raw.displayName.length > 40 ||
    typeof raw.allowDownload !== 'boolean' ||
    !Array.isArray(raw.grants) ||
    !raw.grants.length ||
    raw.grants.length > CIRCLE_POLICY.maxGrants ||
    !(
      raw.message === null ||
      (typeof raw.message === 'string' && raw.message.length <= 300)
    )
  )
    throw new ValidationError('Invalid Circle payload version or fields.');
  const seen = new Set<string>();
  const grants = raw.grants.map((value: unknown): CircleGrantInput => {
    if (!value || typeof value !== 'object')
      throw new ValidationError('Invalid grant.');
    const grant = value as Record<string, unknown>;
    const child =
      typeof grant.childId === 'string' &&
      /^[0-9a-f-]{36}$/i.test(grant.childId);
    const pregnancy =
      typeof grant.pregnancyId === 'string' &&
      /^[0-9a-f-]{36}$/i.test(grant.pregnancyId);
    if (
      Number(child) + Number(pregnancy) !== 1 ||
      (grant.childId !== undefined && !child) ||
      (grant.pregnancyId !== undefined && !pregnancy) ||
      typeof grant.allowDownload !== 'boolean' ||
      (grant.permission !== undefined &&
        !Object.values(GrantPermission).includes(
          grant.permission as Permission,
        ))
    )
      throw new ValidationError(
        'A grant requires exactly one child or pregnancy.',
      );
    const key = `${child ? 'c' : 'p'}:${String(grant.childId ?? grant.pregnancyId)}`;
    if (seen.has(key)) throw new ValidationError('Duplicate grant subject.');
    seen.add(key);
    return {
      ...(child
        ? { childId: grant.childId as string }
        : { pregnancyId: grant.pregnancyId as string }),
      allowDownload: grant.allowDownload,
      permission: (grant.permission as Permission | undefined) ?? 'VIEW',
    };
  });
  return {
    version: 1,
    relation: raw.relation as Relation,
    displayName: raw.displayName.trim(),
    allowDownload: raw.allowDownload,
    grants,
    message: raw.message,
  };
}
