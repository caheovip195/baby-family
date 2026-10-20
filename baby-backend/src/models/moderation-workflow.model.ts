export class ModerationWorkflowCase {
  constructor(
    readonly id: string,
    readonly targetType: string,
    readonly targetId: string,
    readonly priority: number,
    readonly status: string,
    readonly slaDueAt: Date,
    readonly createdAt: Date,
    readonly updatedAt: Date,
    readonly deletedAt: Date | null,
  ) {}
}
