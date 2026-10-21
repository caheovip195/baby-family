/** Membership metadata only; intentionally carries no child or content data. */
export class MeFamily {
  constructor(
    public readonly familyId: string,
    public readonly name: string,
    public readonly role: 'PARENT' | 'CIRCLE',
    public readonly familyStatus: string,
    public readonly membershipStatus: string,
    public readonly canReadCover: boolean,
  ) {}
}

export class MeFamiliesState {
  constructor(
    public readonly items: MeFamily[],
    public readonly defaultFamilyId: string | null,
  ) {}
}
