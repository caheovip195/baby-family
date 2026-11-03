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
  /** Ảnh/video theo thứ tự; undefined = giữ bộ cũ (BF-20261030-006). */
  assetIds?: string[];
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
  /** Ảnh/video của góc nhìn [id] mà người hỏi được dùng (cùng luật audio). */
  findMedia(
    assetIds: string[],
    familyId: string,
    actorUserId: string,
  ): Promise<Asset[]>;
  /** Asset id theo góc nhìn, đúng thứ tự. */
  assetIds(perspectiveIds: string[]): Promise<Map<string, string[]>>;
  save(command: SavePerspectiveContent): Promise<MemoryPerspective>;
  remove(
    memoryId: string,
    familyId: string,
    authorUserId: string,
  ): Promise<void>;
}
