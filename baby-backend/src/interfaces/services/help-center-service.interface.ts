import type { HelpCenterResponseDto } from '../../dto/support-help-center/help-center.dto';

export const HELP_CENTER_SERVICE = Symbol('HELP_CENTER_SERVICE');
export interface IHelpCenterService {
  get(locale?: 'vi' | 'en'): HelpCenterResponseDto;
}
