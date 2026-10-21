export interface AdminCmsOperationsCaseAttributes {
  id: string;
  targetType: string;
  targetId: string;
  priority: number;
  status: string;
  assigneeAdminId: string | null;
  slaDueAt: Date;
  resolvedAt: Date | null;
  createdAt: Date;
  updatedAt: Date;
  deletedAt: Date | null;
  reports?: {
    id: string;
    reason: string;
    detail: string | null;
    severity: number;
    status: string;
    createdAt: Date;
  }[];
  actions?: {
    id: string;
    adminId: string;
    action: string;
    createdAt: Date;
  }[];
}
export class AdminCmsOperationsCase {
  constructor(readonly attributes: AdminCmsOperationsCaseAttributes) {}
}
export class AdminCmsOperationsContent {
  constructor(
    readonly caseId: string,
    readonly targetType: string,
    readonly targetId: string,
    readonly content: {
      id: string;
      title?: string | null;
      body: string | null;
      status: string;
    },
  ) {}
}
export class AdminCmsOperationsLicense {
  constructor(
    readonly familyId: string,
    readonly blockedAt: Date | null,
    readonly blockReasonCode: string | null,
  ) {}
}
