import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { MISSION_POLICY } from '../config/mission-policy';
import type {
  MissionSettingsResponseDto,
  UpdateMissionFamilySettingsDto,
  UpdateMissionPreferencesDto,
} from '../dto/mission/mission-config.dto';
import { MISSION_CONFIG_REPOSITORY } from '../interfaces/repositories/mission-config-repository.interface';
import type { IMissionConfigRepository } from '../interfaces/repositories/mission-config-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type { IMissionConfigService } from '../interfaces/services/mission-config-service.interface';

/**
 * CARE-12: the board level is a family setting either Parent changes; the
 * other preferences are personal — nobody edits the other Parent's ones.
 * The board generator already reads both.
 */
@Injectable()
export class MissionConfigService implements IMissionConfigService {
  constructor(
    @Inject(MISSION_CONFIG_REPOSITORY)
    private readonly repository: IMissionConfigRepository,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
  ) {}

  async get(actor: AuthPrincipal, familyId: string) {
    await this.access.requireParent(actor, familyId, 'read');
    return this.view(familyId, actor.userId);
  }

  async updateFamily(
    actor: AuthPrincipal,
    familyId: string,
    input: UpdateMissionFamilySettingsDto,
  ) {
    await this.access.requireParent(actor, familyId, 'write');
    if (input.boardLevel)
      await this.repository.saveBoardLevel(
        familyId,
        actor.userId,
        input.boardLevel,
      );
    return this.view(familyId, actor.userId);
  }

  async updateMine(
    actor: AuthPrincipal,
    familyId: string,
    input: UpdateMissionPreferencesDto,
  ) {
    await this.access.requireParent(actor, familyId, 'write');
    await this.repository.savePreference(familyId, actor.userId, {
      disabledCategories: input.disabledCategories,
      boardPushTime: input.boardPushTime
        ? new Date(`1970-01-01T${input.boardPushTime}:00.000Z`)
        : undefined,
      eveningCarryOver: input.eveningCarryOver,
      defaultReminderMin: input.defaultReminderMin,
    });
    return this.view(familyId, actor.userId);
  }

  private async view(
    familyId: string,
    userId: string,
  ): Promise<MissionSettingsResponseDto> {
    const [level, preference] = await Promise.all([
      this.repository.boardLevel(familyId),
      this.repository.preference(familyId, userId),
    ]);
    return {
      boardLevel: level ?? MISSION_POLICY.defaultLevel,
      preferences: {
        disabledCategories: preference?.disabledCategories ?? [],
        boardPushTime:
          preference?.boardPushTime.toISOString().slice(11, 16) ?? '07:00',
        eveningCarryOver: preference?.eveningCarryOver ?? true,
        defaultReminderMin: preference?.defaultReminderMin ?? null,
      },
    };
  }
}
