import { FamilyDeletionRequest } from './family-deletion-request.model';
export class FamilyErasure extends FamilyDeletionRequest {
  project() {
    const steps =
      typeof this.steps === 'object' &&
      this.steps !== null &&
      !Array.isArray(this.steps)
        ? this.steps
        : {};
    return {
      id: this.id,
      status:
        this.status === 'PENDING_APPROVAL' ? 'AWAITING_PARTNER' : this.status,
      requestedBy: this.requestedBy,
      scheduledFor: this.executeAfter?.toISOString() ?? null,
      requestedAt: this.createdAt.toISOString(),
      cancelledAt: this.cancelledAt?.toISOString() ?? null,
      completedAt: this.completedAt?.toISOString() ?? null,
      policyVersion: steps.policyVersion ?? null,
      graceDays: steps.graceDays ?? null,
    };
  }
}
export const NO_FAMILY_ERASURE = {
  id: null,
  status: 'NONE',
  requestedBy: null,
  scheduledFor: null,
  requestedAt: null,
  cancelledAt: null,
  completedAt: null,
  policyVersion: null,
  graceDays: null,
} as const;
