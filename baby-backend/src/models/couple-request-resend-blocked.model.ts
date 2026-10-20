import { DomainError } from '../common/errors/domain.error';
/** The request API exposes this safe deadline without including private content. */
export class CoupleRequestResendBlockedError extends DomainError {
  constructor(public readonly retryAfter: string) {
    super(
      'This declined request cannot be resent yet.',
      'REQUEST_RESEND_BLOCKED',
      422,
    );
  }
}
