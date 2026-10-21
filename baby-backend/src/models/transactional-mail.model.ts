import type { TransactionalMailKind } from '../config/transactional-mail-policy';

export class TransactionalMail {
  constructor(
    readonly eventId: string,
    readonly userId: string,
    readonly kind: TransactionalMailKind,
    readonly referenceId: string,
    readonly state: string,
    readonly email: string | null,
    readonly locale: string,
    readonly timezone: string,
    readonly deadline: Date | null,
    readonly storageKey: string | null,
  ) {}
}
