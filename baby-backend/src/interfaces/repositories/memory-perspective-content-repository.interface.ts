import type { Asset } from '../../models/asset.model';
import type { MemoryPerspective } from '../../models/memory-perspective.model';

export const MEMORY_PERSPECTIVE_CONTENT_REPOSITORY = Symbol(
  'MEMORY_PERSPECTIVE_CONTENT_REPOSITORY',
);
export interface SavePerspectiveContent {
  memoryId: string;
  familyId: string;
  authorUserId: string;
  body: string | null;
  audioAssetId: string | null;
  hiddenFromCircle: boolean;
}
export interface IMemoryPerspectiveContentRepository {
  list(
    memoryId: string,
    familyId: string,
    includeHidden: boolean,
  ): Promise<MemoryPerspective[]>;
  findOwn(
    memoryId: string,
    authorUserId: string,
  ): Promise<MemoryPerspective | null>;
  findAudio(
    assetId: string,
    familyId: string,
    actorUserId: string,
  ): Promise<Asset | null>;
  save(command: SavePerspectiveContent): Promise<MemoryPerspective>;
  remove(
    memoryId: string,
    familyId: string,
    authorUserId: string,
  ): Promise<void>;
}
