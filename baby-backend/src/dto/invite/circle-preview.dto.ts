import type { FamilyCirclePreview } from '../../models/family-circle-state.model';
export class CirclePreviewResponseDto {
  inviteId!: string;
  type!: 'CIRCLE';
  state!: 'VALID';
  familyName!: string;
  inviterCallName!: string | null;
  relation!: string;
  children!: { id: string; name: string }[];
  message!: string | null;
  expiresAt!: string;
  static fromModel(model: FamilyCirclePreview): CirclePreviewResponseDto {
    return Object.assign(new CirclePreviewResponseDto(), {
      ...model,
      state: 'VALID' as const,
      children: model.children.map(({ id, name }) => ({ id, name })),
      expiresAt: model.expiresAt.toISOString(),
    });
  }
}
