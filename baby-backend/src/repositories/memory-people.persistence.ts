import { MemoryPersonView } from '../models/memory-view.model';
import type { Prisma } from '../generated/prisma/client';
import { DomainError } from '../common/errors/domain.error';
import type { MemoryPersonInputDto } from '../dto/memory/memory-people.dto';

type Client = Pick<
  Prisma.TransactionClient,
  'familyParent' | 'circleMember' | 'memoryPerson'
>;

/** Family-local names only; departed members are never resolved using user profiles. */
export async function activeMemoryPeopleMembers(
  client: Client,
  familyId: string,
): Promise<MemoryPersonView[]> {
  const now = new Date();
  const [parents, circle] = await Promise.all([
    client.familyParent.findMany({
      where: {
        familyId,
        status: 'ACTIVE',
        deletedAt: null,
        leftAt: null,
        joinedAt: { lte: now },
        user: { status: 'ACTIVE', deletedAt: null },
      },
      orderBy: { slot: 'asc' },
      select: { id: true, userId: true, callName: true },
    }),
    client.circleMember.findMany({
      where: {
        familyId,
        status: 'ACTIVE',
        deletedAt: null,
        endedAt: null,
        joinedAt: { lte: now },
        usersCircleMembersUserIdTousers: { status: 'ACTIVE', deletedAt: null },
      },
      orderBy: { id: 'asc' },
      select: { id: true, userId: true, displayName: true },
    }),
  ]);
  return [
    ...parents.map((p) => new MemoryPersonView(p.id, p.userId, p.callName)),
    ...circle.map((p) => new MemoryPersonView(p.id, p.userId, p.displayName)),
  ];
}

/** Called inside the memory write transaction; its row/version lock serializes replacement. */
export async function replaceMemoryPeople(
  client: Client,
  familyId: string,
  memoryId: string,
  addedBy: string,
  input: readonly MemoryPersonInputDto[],
): Promise<void> {
  if (input.length > 30) throw invalid('Too many people.');
  const members = await activeMemoryPeopleMembers(client, familyId);
  const seen = new Set<string>();
  const rows = input.map((person, sortOrder) => {
    if (person.memberId && person.userId)
      throw invalid('Choose memberId or userId.');
    const named = person.displayName?.trim();
    const member = members.find((m) =>
      person.memberId
        ? m.memberId === person.memberId
        : person.userId
          ? m.userId === person.userId
          : false,
    );
    if ((person.memberId || person.userId) && !member)
      throw invalid('An active family member is required.');
    if (!member && !named) throw invalid('A free name is required.');
    if (named !== undefined && (!named || named.length > 40))
      throw invalid('Invalid displayName.');
    const userId = member?.userId ?? null;
    const displayName = userId ? null : named!;
    const key = userId ?? `name:${displayName!.toLocaleLowerCase()}`;
    if (seen.has(key)) throw invalid('Duplicate person.');
    seen.add(key);
    return { familyId, memoryId, addedBy, userId, displayName, sortOrder };
  });
  await client.memoryPerson.updateMany({
    where: { memoryId, familyId, deletedAt: null },
    data: { deletedAt: new Date() },
  });
  if (rows.length) await client.memoryPerson.createMany({ data: rows });
}

const invalid = (message: string) =>
  new DomainError(message, 'MEMORY_PEOPLE_INVALID', 422);
