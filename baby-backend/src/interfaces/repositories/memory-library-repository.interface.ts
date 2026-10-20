import type { Memory } from '../../models/memory.model';
import type { AssetVariant } from '../../models/asset-variant.model';
import type { Asset } from '../../models/asset.model';
import type { Family } from '../../models/family.model';
import type { FamilyEntitlement } from '../../models/family-entitlement.model';
export const MEMORY_LIBRARY_REPOSITORY = Symbol('MEMORY_LIBRARY_REPOSITORY');
export interface LibraryFamilyAccess {
  circleEnabled?: boolean;
  isParent: boolean;
  circleActive: boolean;
  family: Family;
  entitlement: FamilyEntitlement | null;
  licenseBlocked: boolean;
}
export interface LibraryMemory {
  memory: Memory;
  assets: Asset[];
  variants: AssetVariant[];
  childIds: string[];
  coverAssetId: string | null;
  canDownload: boolean;
  perspectiveCount: number;
}
export interface LibraryCursor {
  createdAt: Date;
  id: string;
}
export interface IMemoryLibraryRepository {
  findFamilyId?(id: string): Promise<string | null>;
  familyAccess(
    familyId: string,
    userId: string,
  ): Promise<LibraryFamilyAccess | null>;
  find(
    id: string,
    userId: string,
    includeOwnPending?: boolean,
  ): Promise<LibraryMemory | null>;
  setFavorite(
    userId: string,
    memoryId: string,
    familyId: string,
    enabled: boolean,
  ): Promise<void>;
  favorites(
    userId: string,
    familyId: string,
    cursor: LibraryCursor | null,
    limit: number,
  ): Promise<LibraryCursor[]>;
  auditDownload(
    userId: string,
    familyId: string,
    memoryId: string,
  ): Promise<void>;
}
