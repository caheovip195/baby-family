export const MISSION_MOMENT_REPOSITORY = Symbol('MISSION_MOMENT_REPOSITORY');

/** Active completion of a mission (CARE-06 links the saved memory to it). */
export interface MissionCompletionLink {
  readonly id: string;
  readonly completedAt: Date;
  readonly memoryId: string | null;
}

export interface IMissionMomentRepository {
  activeCompletion(missionId: string): Promise<MissionCompletionLink | null>;
  /** Sets `memoryId` once; false when another memory was linked first. */
  linkMemory(completionId: string, memoryId: string): Promise<boolean>;
}
