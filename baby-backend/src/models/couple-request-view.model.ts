import type { Request } from './request.model';
export class CoupleRequestView {
  constructor(
    public readonly request: Request,
    public readonly childIds: string[],
  ) {}
}
