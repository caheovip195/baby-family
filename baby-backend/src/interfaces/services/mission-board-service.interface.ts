import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  CreateMissionDto,
  CreateMissionResponseDto,
  CompleteMissionDto,
  MissionActionResponseDto,
  MissionBoardQueryDto,
  MissionBoardResponseDto,
  MissionTemplateQueryDto,
  MyMissionDto,
  PartnerMissionDto,
  SwapMissionDto,
} from '../../dto/mission/mission.dto';
import type { MissionTemplateView } from '../../models/mission-board-view.model';
export const MISSION_BOARD_SERVICE = Symbol('MISSION_BOARD_SERVICE');
export type MissionBoardAction = 'complete' | 'undo' | 'swap' | 'remove';
export interface IMissionBoardService {
  board(
    actor: AuthPrincipal,
    familyId: string,
    query: MissionBoardQueryDto,
  ): Promise<MissionBoardResponseDto>;
  find(
    actor: AuthPrincipal,
    id: string,
  ): Promise<MyMissionDto | PartnerMissionDto>;
  templates(
    actor: AuthPrincipal,
    query: MissionTemplateQueryDto,
  ): Promise<{ items: MissionTemplateView[] }>;
  create(
    actor: AuthPrincipal,
    input: CreateMissionDto,
    key: string,
  ): Promise<CreateMissionResponseDto>;
  act(
    actor: AuthPrincipal,
    id: string,
    action: MissionBoardAction,
    key?: string,
    input?: SwapMissionDto | CompleteMissionDto,
  ): Promise<MissionActionResponseDto>;
  swapOptions(
    actor: AuthPrincipal,
    id: string,
  ): Promise<{
    options: MissionTemplateView[];
    optionsToken: string;
    swapsLeft: number;
  }>;
}
