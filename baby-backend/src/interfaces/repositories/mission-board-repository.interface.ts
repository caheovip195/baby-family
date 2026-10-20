import type {
  CreateMissionDto,
  CompleteMissionDto,
  SwapMissionDto,
} from '../../dto/mission/mission.dto';
import type { MissionCategory } from '../../common/database.enums';
import type {
  MissionBoardSnapshot,
  MissionBoardView,
  MissionTemplateView,
} from '../../models/mission-board-view.model';
export const MISSION_BOARD_REPOSITORY = Symbol('MISSION_BOARD_REPOSITORY');
export interface IMissionBoardRepository {
  familyIdForActor(userId: string, childId?: string): Promise<string | null>;
  familyIdForMission(id: string): Promise<string | null>;
  board(
    familyId: string,
    userId: string,
    date: string,
    today: string,
  ): Promise<MissionBoardSnapshot>;
  find(id: string): Promise<MissionBoardView | null>;
  /** Morning job: ACTIVE families with both Parents active. */
  familiesForBoards(): Promise<{ familyId: string; timezone: string }[]>;
  /** Creates the board for `date` (yyyy-MM-dd) once; false if it exists. */
  prepareBoard(familyId: string, date: string): Promise<boolean>;
  templates(
    familyId: string,
    userId: string,
    category?: MissionCategory,
    childId?: string,
  ): Promise<MissionTemplateView[]>;
  create(
    familyId: string,
    userId: string,
    input: CreateMissionDto,
    key: string,
  ): Promise<MissionBoardView>;
  act(
    id: string,
    userId: string,
    action: 'complete' | 'undo' | 'swap' | 'remove',
    key?: string,
    input?: SwapMissionDto | CompleteMissionDto,
  ): Promise<MissionBoardView>;
  swapOptions(
    id: string,
    userId: string,
  ): Promise<{
    options: MissionTemplateView[];
    optionsToken: string;
    swapsLeft: number;
  }>;
}
