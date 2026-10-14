import { ApiProperty } from '@nestjs/swagger';
import type { UserSetting } from '../../models/user-setting.model';

export class UserSettingResponseDto {
  @ApiProperty() hideSensitivePreview!: boolean;
  @ApiProperty() requestSoonBypassQuiet!: boolean;
  @ApiProperty() usLockEnabled!: boolean;
  @ApiProperty() theme!: string;
  @ApiProperty() textScale!: number;
  @ApiProperty() showLunar!: boolean;
  @ApiProperty() memoryPromptsEnabled!: boolean;
  @ApiProperty() perspectiveSuggest!: boolean;
  @ApiProperty() dailyStorySuggest!: boolean;
  @ApiProperty({ format: 'date-time' }) updatedAt!: string;

  static fromModel(model: UserSetting): UserSettingResponseDto {
    return Object.assign(new UserSettingResponseDto(), {
      hideSensitivePreview: model.hideSensitivePreview,
      requestSoonBypassQuiet: model.requestSoonBypassQuiet,
      usLockEnabled: model.usLockEnabled,
      theme: model.theme,
      textScale: Number(model.textScale.toString()),
      showLunar: model.showLunar,
      memoryPromptsEnabled: model.memoryPromptsEnabled,
      perspectiveSuggest: model.perspectiveSuggest,
      dailyStorySuggest: model.dailyStorySuggest,
      updatedAt: model.updatedAt.toISOString(),
    });
  }
}
