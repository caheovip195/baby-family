import type { Pregnancy } from '../../models/pregnancy.model';
import type { ContentItem } from '../../models/content-item.model';
import type { Memory } from '../../models/memory.model';
import type { JourneyCursor } from '../../config/pregnancy-journey-policy';
export const PREGNANCY_JOURNEY_REPOSITORY = Symbol(
  'PREGNANCY_JOURNEY_REPOSITORY',
);
export interface IPregnancyJourneyRepository {
  findPregnancy(id: string): Promise<Pregnancy | null>;
  userLocale(userId: string): Promise<string>;
  weekContent(week: number, locale: string): Promise<ContentItem | null>;
  memories(
    familyId: string,
    pregnancyId: string,
    userId: string,
    kind: 'BUMP' | 'ULTRASOUND',
    after: JourneyCursor | null,
    limit: number,
  ): Promise<Memory[]>;
}
