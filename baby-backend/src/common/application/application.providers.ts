import type { Provider, Type } from '@nestjs/common';
import { INTERNAL_SERVICE_PROVIDERS } from './service.providers';
import { AccessTokenGuard } from '../auth/access-token.guard';
import { AUTHENTICATION_SERVICE } from '../../interfaces/services/authentication-service.interface';
import { APPLICATION_ACCESS_SERVICE } from '../../interfaces/services/application-access-service.interface';
import { AuthenticationService } from '../../services/authentication.service';
import { ApplicationAccessService } from '../../services/application-access.service';
import { AUTH_ACCESS_REPOSITORY } from '../../interfaces/repositories/auth-access-repository.interface';
import { AuthAccessRepository } from '../../repositories/auth-access.repository';
import { CATALOG_QUERY_REPOSITORY } from '../../interfaces/repositories/catalog-query-repository.interface';
import { CatalogQueryRepository } from '../../repositories/catalog-query.repository';
import { USER_SERVICE } from '../../interfaces/services/user-service.interface';
import { UserService } from '../../services/user.service';
import { UserController } from '../../controllers/user.controller';
import { USER_SETTING_SERVICE } from '../../interfaces/services/user-setting-service.interface';
import { UserSettingService } from '../../services/user-setting.service';
import { UserSettingController } from '../../controllers/user-setting.controller';
import { FAMILY_SERVICE } from '../../interfaces/services/family-service.interface';
import { FamilyService } from '../../services/family.service';
import { FamilyController } from '../../controllers/family.controller';
import { CHILD_SERVICE } from '../../interfaces/services/child-service.interface';
import { ChildService } from '../../services/child.service';
import { ChildController } from '../../controllers/child.controller';
import { PREGNANCY_SERVICE } from '../../interfaces/services/pregnancy-service.interface';
import { PregnancyService } from '../../services/pregnancy.service';
import { PregnancyController } from '../../controllers/pregnancy.controller';
import { PREGNANCY_COMMAND_REPOSITORY } from '../../interfaces/repositories/pregnancy-command-repository.interface';
import { PregnancyCommandRepository } from '../../repositories/pregnancy-command.repository';
import { BILLING_CATALOG_SERVICE } from '../../interfaces/services/billing-catalog-service.interface';
import { BillingCatalogService } from '../../services/billing-catalog.service';
import { BillingCatalogController } from '../../controllers/billing-catalog.controller';
import { FAMILY_BILLING_SERVICE } from '../../interfaces/services/family-billing-service.interface';
import { FamilyBillingService } from '../../services/family-billing.service';
import { FamilyBillingController } from '../../controllers/family-billing.controller';
import { MEDIA_SERVICE } from '../../interfaces/services/media-service.interface';
import { MediaService } from '../../services/media.service';
import { MediaController } from '../../controllers/media.controller';
import { MEDIA_REPOSITORY } from '../../interfaces/repositories/media-repository.interface';
import { MediaRepository } from '../../repositories/media.repository';
import { AUTH_TOKEN_SERVICE } from '../../interfaces/services/auth-token-service.interface';
import { AuthTokenService } from '../../services/auth-token.service';
import { OTP_SENDER_SERVICE } from '../../interfaces/services/otp-sender-service.interface';
import { OtpSenderService } from '../../services/otp-sender.service';
import { AUTH_SESSION_REPOSITORY } from '../../interfaces/repositories/auth-session-repository.interface';
import { AuthSessionRepository } from '../../repositories/auth-session.repository';
import { AUTH_SESSION_SERVICE } from '../../interfaces/services/auth-session-service.interface';
import { AuthSessionService } from '../../services/auth-session.service';
import { AuthController } from '../../controllers/auth.controller';
import { ACCOUNT_REPOSITORY } from '../../interfaces/repositories/account-repository.interface';
import { AccountRepository } from '../../repositories/account.repository';
import { ONBOARDING_REPOSITORY } from '../../interfaces/repositories/onboarding-repository.interface';
import { OnboardingRepository } from '../../repositories/onboarding.repository';
import { ONBOARDING_SERVICE } from '../../interfaces/services/onboarding-service.interface';
import { OnboardingService } from '../../services/onboarding.service';
import { FamilyOnboardingController } from '../../controllers/family-onboarding.controller';
import { InviteController } from '../../controllers/invite.controller';
import { MEMORY_CONTENT_REPOSITORY } from '../../interfaces/repositories/memory-content-repository.interface';
import { MemoryContentRepository } from '../../repositories/memory-content.repository';
import { MEMORY_CONTENT_SERVICE } from '../../interfaces/services/memory-content-service.interface';
import { MemoryContentService } from '../../services/memory-content.service';
import { MemoryController } from '../../controllers/memory.controller';
import { MEMORY_INTERACTION_REPOSITORY } from '../../interfaces/repositories/memory-interaction-repository.interface';
import { MemoryInteractionRepository } from '../../repositories/memory-interaction.repository';
import { MEMORY_INTERACTION_SERVICE } from '../../interfaces/services/memory-interaction-service.interface';
import { MemoryInteractionService } from '../../services/memory-interaction.service';
import { MemoryInteractionController } from '../../controllers/memory-interaction.controller';

import { CoupleCheckinController } from '../../controllers/couple-checkin.controller';
import { CoupleCheckinService } from '../../services/couple-checkin.service';
import { CoupleCheckinRepository } from '../../repositories/couple-checkin.repository';
import { COUPLE_CHECKIN_SERVICE } from '../../interfaces/services/couple-checkin-service.interface';
import { COUPLE_CHECKIN_REPOSITORY } from '../../interfaces/repositories/couple-checkin-repository.interface';

import { CoupleRequestController } from '../../controllers/couple-request.controller';
import { CoupleRequestService } from '../../services/couple-request.service';
import { CoupleRequestRepository } from '../../repositories/couple-request.repository';
import { COUPLE_REQUEST_SERVICE } from '../../interfaces/services/couple-request-service.interface';
import { COUPLE_REQUEST_REPOSITORY } from '../../interfaces/repositories/couple-request-repository.interface';

import { CoupleAppreciationController } from '../../controllers/couple-appreciation.controller';
import { CoupleAppreciationService } from '../../services/couple-appreciation.service';
import { CoupleAppreciationRepository } from '../../repositories/couple-appreciation.repository';
import { COUPLE_APPRECIATION_SERVICE } from '../../interfaces/services/couple-appreciation-service.interface';
import { COUPLE_APPRECIATION_REPOSITORY } from '../../interfaces/repositories/couple-appreciation-repository.interface';

import { CoupleJournalController } from '../../controllers/couple-journal.controller';
import { CoupleJournalService } from '../../services/couple-journal.service';
import { CoupleJournalRepository } from '../../repositories/couple-journal.repository';
import { COUPLE_JOURNAL_SERVICE } from '../../interfaces/services/couple-journal-service.interface';
import { COUPLE_JOURNAL_REPOSITORY } from '../../interfaces/repositories/couple-journal-repository.interface';

import {
  MissionController,
  MissionBoardController,
} from '../../controllers/mission.controller';
import { MissionBoardService } from '../../services/mission-board.service';
import { MissionBoardRepository } from '../../repositories/mission-board.repository';
import { MISSION_BOARD_SERVICE } from '../../interfaces/services/mission-board-service.interface';
import { MISSION_BOARD_REPOSITORY } from '../../interfaces/repositories/mission-board-repository.interface';

import { CareProgressController } from '../../controllers/care-progress.controller';
import { CareProgressService } from '../../services/care-progress.service';
import { CareProgressRepository } from '../../repositories/care-progress.repository';
import { CARE_PROGRESS_SERVICE } from '../../interfaces/services/care-progress-service.interface';
import { CARE_PROGRESS_REPOSITORY } from '../../interfaces/repositories/care-progress-repository.interface';
import { NotificationInboxController } from '../../controllers/notification-inbox.controller';
import { NotificationInboxService } from '../../services/notification-inbox.service';
import { NOTIFICATION_INBOX_SERVICE } from '../../interfaces/services/notification-inbox-service.interface';
import { NotificationInboxRepository } from '../../repositories/notification-inbox.repository';
import { NOTIFICATION_INBOX_REPOSITORY } from '../../interfaces/repositories/notification-inbox-repository.interface';

import { AccountDeletionController } from '../../controllers/account-deletion.controller';
import { DataExportController } from '../../controllers/data-export.controller';
import { ACCOUNT_DELETION_SERVICE } from '../../interfaces/services/account-deletion-service.interface';
import { DATA_EXPORT_SERVICE } from '../../interfaces/services/data-export-service.interface';
import { ACCOUNT_DELETION_REPOSITORY } from '../../interfaces/repositories/account-deletion-repository.interface';
import { DATA_EXPORT_REPOSITORY } from '../../interfaces/repositories/data-export-repository.interface';
import { AccountDeletionService } from '../../services/account-deletion.service';
import { DataExportService } from '../../services/data-export.service';
import { AccountDeletionRepository } from '../../repositories/account-deletion.repository';
import { DataExportRepository } from '../../repositories/data-export.repository';

import {
  CalendarController,
  EventController,
} from '../../controllers/calendar.controller';
import { CALENDAR_SERVICE } from '../../interfaces/services/calendar-service.interface';
import { CALENDAR_REPOSITORY } from '../../interfaces/repositories/calendar-repository.interface';
import { CalendarService } from '../../services/calendar.service';
import { CalendarRepository } from '../../repositories/calendar.repository';

import { ReauthController } from '../../controllers/reauth.controller';
import { ReauthService } from '../../services/reauth.service';
import { REAUTH_SERVICE } from '../../interfaces/services/reauth-service.interface';

import { AccountSecurityController } from '../../controllers/account-security.controller';
import { AccountSecurityService } from '../../services/account-security.service';
import { ACCOUNT_SECURITY_SERVICE } from '../../interfaces/services/account-security-service.interface';
import { AccountSecurityRepository } from '../../repositories/account-security.repository';
import { ACCOUNT_SECURITY_REPOSITORY } from '../../interfaces/repositories/account-security-repository.interface';
import { FamilySettingsController } from '../../controllers/family-settings.controller';
import { FamilySettingsService } from '../../services/family-settings.service';
import { FAMILY_SETTINGS_SERVICE } from '../../interfaces/services/family-settings-service.interface';
import { FamilySettingsRepository } from '../../repositories/family-settings.repository';
import { FAMILY_SETTINGS_REPOSITORY } from '../../interfaces/repositories/family-settings-repository.interface';

import { PregnancyJourneyController } from '../../controllers/pregnancy-journey.controller';
import { PregnancyPrepController } from '../../controllers/pregnancy-prep.controller';
import { PregnancyJourneyService } from '../../services/pregnancy-journey.service';
import { PregnancyPrepService } from '../../services/pregnancy-prep.service';
import { PregnancyJourneyRepository } from '../../repositories/pregnancy-journey.repository';
import { PregnancyPrepRepository } from '../../repositories/pregnancy-prep.repository';
import { PREGNANCY_JOURNEY_SERVICE } from '../../interfaces/services/pregnancy-journey-service.interface';
import { PREGNANCY_PREP_SERVICE } from '../../interfaces/services/pregnancy-prep-service.interface';
import { PREGNANCY_JOURNEY_REPOSITORY } from '../../interfaces/repositories/pregnancy-journey-repository.interface';
import { PREGNANCY_PREP_REPOSITORY } from '../../interfaces/repositories/pregnancy-prep-repository.interface';

import { BirthConversionController } from '../../controllers/birth-conversion.controller';
import { BirthConversionWorkflowService } from '../../services/birth-conversion-workflow.service';
import { BirthConversionWorkflowRepository } from '../../repositories/birth-conversion-workflow.repository';
import { BIRTH_CONVERSION_WORKFLOW_SERVICE } from '../../interfaces/services/birth-conversion-workflow-service.interface';
import { BIRTH_CONVERSION_WORKFLOW_REPOSITORY } from '../../interfaces/repositories/birth-conversion-workflow-repository.interface';
import { PregnancyLifecycleController } from '../../controllers/pregnancy-lifecycle.controller';
import { PregnancyLifecycleService } from '../../services/pregnancy-lifecycle.service';
import { PregnancyLifecycleRepository } from '../../repositories/pregnancy-lifecycle.repository';
import { PREGNANCY_LIFECYCLE_SERVICE } from '../../interfaces/services/pregnancy-lifecycle-service.interface';
import { PREGNANCY_LIFECYCLE_REPOSITORY } from '../../interfaces/repositories/pregnancy-lifecycle-repository.interface';
import { ChildProfileController } from '../../controllers/child-profile.controller';
import { ChildProfileService } from '../../services/child-profile.service';
import { ChildProfileRepository } from '../../repositories/child-profile.repository';
import { CHILD_PROFILE_SERVICE } from '../../interfaces/services/child-profile-service.interface';
import { CHILD_PROFILE_REPOSITORY } from '../../interfaces/repositories/child-profile-repository.interface';

import { AlbumCollectionController } from '../../controllers/album-collection.controller';
import { AlbumCollectionService } from '../../services/album-collection.service';
import { AlbumCollectionRepository } from '../../repositories/album-collection.repository';
import { ALBUM_COLLECTION_SERVICE } from '../../interfaces/services/album-collection-service.interface';
import { ALBUM_COLLECTION_REPOSITORY } from '../../interfaces/repositories/album-collection-repository.interface';
import { MemoryLibraryController } from '../../controllers/memory-library.controller';
import { MemoryLibraryService } from '../../services/memory-library.service';
import { MemoryLibraryRepository } from '../../repositories/memory-library.repository';
import { MEMORY_LIBRARY_SERVICE } from '../../interfaces/services/memory-library-service.interface';
import { MEMORY_LIBRARY_REPOSITORY } from '../../interfaces/repositories/memory-library-repository.interface';
import { MemoryPerspectiveContentController } from '../../controllers/memory-perspective-content.controller';
import { MemoryPerspectiveContentService } from '../../services/memory-perspective-content.service';
import { MemoryPerspectiveContentRepository } from '../../repositories/memory-perspective-content.repository';
import { MEMORY_PERSPECTIVE_CONTENT_SERVICE } from '../../interfaces/services/memory-perspective-content-service.interface';
import { MEMORY_PERSPECTIVE_CONTENT_REPOSITORY } from '../../interfaces/repositories/memory-perspective-content-repository.interface';
import { MemoryPromptController } from '../../controllers/memory-prompt.controller';
import { MemoryPromptService } from '../../services/memory-prompt.service';
import { MemoryPromptRepository } from '../../repositories/memory-prompt.repository';
import { MEMORY_PROMPT_SERVICE } from '../../interfaces/services/memory-prompt-service.interface';
import { MEMORY_PROMPT_REPOSITORY } from '../../interfaces/repositories/memory-prompt-repository.interface';

import { MilestoneController } from '../../controllers/milestone.controller';
import { MemoryLetterController } from '../../controllers/memory-letter.controller';
import { MilestoneCatalogService } from '../../services/milestone-catalog.service';
import { MemoryCapsuleService } from '../../services/memory-capsule.service';
import { MilestoneCatalogRepository } from '../../repositories/milestone-catalog.repository';
import { MemoryCapsuleRepository } from '../../repositories/memory-capsule.repository';
import { MILESTONE_CATALOG_SERVICE } from '../../interfaces/services/milestone-catalog-service.interface';
import { MEMORY_CAPSULE_SERVICE } from '../../interfaces/services/memory-capsule-service.interface';
import { MILESTONE_CATALOG_REPOSITORY } from '../../interfaces/repositories/milestone-catalog-repository.interface';
import { MEMORY_CAPSULE_REPOSITORY } from '../../interfaces/repositories/memory-capsule-repository.interface';

import { MissionMomentService } from '../../services/mission-moment.service';
import { MissionMomentRepository } from '../../repositories/mission-moment.repository';
import { MISSION_MOMENT_SERVICE } from '../../interfaces/services/mission-moment-service.interface';
import { MISSION_MOMENT_REPOSITORY } from '../../interfaces/repositories/mission-moment-repository.interface';
import { MissionRecurrenceController } from '../../controllers/mission-recurrence.controller';
import { MissionRecurrenceService } from '../../services/mission-recurrence.service';
import { MissionRecurrenceRepository } from '../../repositories/mission-recurrence.repository';
import { MISSION_RECURRENCE_SERVICE } from '../../interfaces/services/mission-recurrence-service.interface';
import { MISSION_RECURRENCE_REPOSITORY } from '../../interfaces/repositories/mission-recurrence-repository.interface';
import { MissionConfigController } from '../../controllers/mission-config.controller';
import { MissionConfigService } from '../../services/mission-config.service';
import { MissionConfigRepository } from '../../repositories/mission-config.repository';
import { MISSION_CONFIG_SERVICE } from '../../interfaces/services/mission-config-service.interface';
import { MISSION_CONFIG_REPOSITORY } from '../../interfaces/repositories/mission-config-repository.interface';

import { CircleController } from '../../controllers/circle.controller';
import { FamilyCircleService } from '../../services/family-circle.service';
import { FamilyCircleRepository } from '../../repositories/family-circle.repository';
import { FAMILY_CIRCLE_SERVICE } from '../../interfaces/services/family-circle-service.interface';
import { FAMILY_CIRCLE_REPOSITORY } from '../../interfaces/repositories/family-circle-repository.interface';

import { MemoryReviewController } from '../../controllers/memory-review.controller';
import { MemoryReviewService } from '../../services/memory-review.service';
import { MemoryReviewRepository } from '../../repositories/memory-review.repository';
import { MEMORY_REVIEW_SERVICE } from '../../interfaces/services/memory-review-service.interface';
import { MEMORY_REVIEW_REPOSITORY } from '../../interfaces/repositories/memory-review-repository.interface';
import { UsSettingsController } from '../../controllers/us-settings.controller';
import { UsSettingsService } from '../../services/us-settings.service';
import { UsSettingsRepository } from '../../repositories/us-settings.repository';
import { US_SETTINGS_SERVICE } from '../../interfaces/services/us-settings-service.interface';
import { US_SETTINGS_REPOSITORY } from '../../interfaces/repositories/us-settings-repository.interface';
import { PreferenceSettingsController } from '../../controllers/preference-settings.controller';
import { SafetyController } from '../../controllers/safety.controller';
import { WeeklyRecapController } from '../../controllers/weekly-recap.controller';
import { ProfileImageController } from '../../controllers/profile-image.controller';
import { FamilyErasureController } from '../../controllers/family-erasure.controller';
import { MonthlyPhotoSelectionController } from '../../controllers/monthly-photo-selection.controller';
import { MONTHLY_PHOTO_SELECTION_SERVICE } from '../../interfaces/services/monthly-photo-selection-service.interface';
import { MonthlyPhotoSelectionService } from '../../services/monthly-photo-selection.service';
import { MONTHLY_PHOTO_SELECTION_REPOSITORY } from '../../interfaces/repositories/monthly-photo-selection-repository.interface';
import { MonthlyPhotoSelectionRepository } from '../../repositories/monthly-photo-selection.repository';
import { TIMELINE_CARD_REPOSITORY } from '../../interfaces/repositories/timeline-card-repository.interface';
import { TimelineCardRepository } from '../../repositories/timeline-card.repository';
import { REQUEST_LOCALE_SERVICE } from '../../interfaces/services/request-locale-service.interface';
import { RequestLocaleService } from '../../services/request-locale.service';
import { NOTIFICATION_TEXT_REPOSITORY } from '../../interfaces/repositories/notification-text-repository.interface';
import { NotificationTextRepository } from '../../repositories/notification-text.repository';
import { NOTIFICATION_TEXT_SERVICE } from '../../interfaces/services/notification-text-service.interface';
import { NotificationTextService } from '../../services/notification-text.service';
import { FamilyPrivacyController } from '../../controllers/family-privacy.controller';
import { FamilyErasureService } from '../../services/family-erasure.service';
import { FamilyErasureRepository } from '../../repositories/family-erasure.repository';
import { FamilyPrivacyService } from '../../services/family-privacy.service';
import { FamilyPrivacyRepository } from '../../repositories/family-privacy.repository';
import { FAMILY_ERASURE_SERVICE } from '../../interfaces/services/family-erasure-service.interface';
import { FAMILY_ERASURE_REPOSITORY } from '../../interfaces/repositories/family-erasure-repository.interface';
import { FAMILY_PRIVACY_SERVICE } from '../../interfaces/services/family-privacy-service.interface';
import { FAMILY_PRIVACY_REPOSITORY } from '../../interfaces/repositories/family-privacy-repository.interface';
import { PROFILE_IMAGE_SERVICE } from '../../interfaces/services/profile-image-service.interface';
import { PROFILE_IMAGE_REPOSITORY } from '../../interfaces/repositories/profile-image-repository.interface';
import { IMAGE_PROCESSOR_SERVICE } from '../../interfaces/services/image-processor-service.interface';
import { ProfileImageService } from '../../services/profile-image.service';
import { ProfileImageRepository } from '../../repositories/profile-image.repository';
import { ImageProcessorService } from '../../services/image-processor.service';
import { WeeklyRecapRepository } from '../../repositories/weekly-recap.repository';
import { WeeklyRecapService } from '../../services/weekly-recap.service';
import { WEEKLY_RECAP_REPOSITORY } from '../../interfaces/repositories/weekly-recap-repository.interface';
import { WEEKLY_RECAP_SERVICE } from '../../interfaces/services/weekly-recap-service.interface';
import { SafetyService } from '../../services/safety.service';
import { SafetyRepository } from '../../repositories/safety.repository';
import { SAFETY_SERVICE } from '../../interfaces/services/safety-service.interface';
import { SAFETY_REPOSITORY } from '../../interfaces/repositories/safety-repository.interface';
import { PreferenceSettingsService } from '../../services/preference-settings.service';
import { PreferenceSettingsRepository } from '../../repositories/preference-settings.repository';
import { PREFERENCE_SETTINGS_SERVICE } from '../../interfaces/services/preference-settings-service.interface';
import { PREFERENCE_SETTINGS_REPOSITORY } from '../../interfaces/repositories/preference-settings-repository.interface';
import { SupportHelpdeskController } from '../../controllers/support-helpdesk.controller';
import { SUPPORT_HELPDESK_SERVICE } from '../../interfaces/services/support-helpdesk-service.interface';
import { SUPPORT_HELPDESK_REPOSITORY } from '../../interfaces/repositories/support-helpdesk-repository.interface';
import { SupportHelpdeskService } from '../../services/support-helpdesk.service';
import { SupportHelpdeskRepository } from '../../repositories/support-helpdesk.repository';
import { MODERATION_WORKFLOW_SERVICE } from '../../interfaces/services/moderation-workflow-service.interface';
import { MODERATION_WORKFLOW_REPOSITORY } from '../../interfaces/repositories/moderation-workflow-repository.interface';
import { ModerationWorkflowService } from '../../services/moderation-workflow.service';
import { ModerationWorkflowRepository } from '../../repositories/moderation-workflow.repository';
import { SUBSCRIPTION_REMINDER_SERVICE } from '../../interfaces/services/subscription-reminder-service.interface';
import { SubscriptionReminderService } from '../../services/subscription-reminder.service';
import { SUBSCRIPTION_REMINDER_REPOSITORY } from '../../interfaces/repositories/subscription-reminder-repository.interface';
import { SubscriptionReminderRepository } from '../../repositories/subscription-reminder.repository';

export const APPLICATION_CONTROLLERS: Type[] = [
  SupportHelpdeskController,
  MissionController,
  MissionBoardController,
  AuthController,
  FamilyOnboardingController,
  InviteController,
  UserController,
  UserSettingController,
  FamilyController,
  ChildProfileController,
  ChildController,
  PregnancyLifecycleController,
  PregnancyController,
  BillingCatalogController,
  FamilyBillingController,
  MediaController,
  MemoryController,
  MemoryInteractionController,
  CoupleCheckinController,
  CoupleRequestController,
  CoupleAppreciationController,
  CoupleJournalController,
  CareProgressController,
  NotificationInboxController,
  AccountDeletionController,
  DataExportController,
  CalendarController,
  EventController,
  ReauthController,
  AccountSecurityController,
  FamilySettingsController,
  PregnancyJourneyController,
  PregnancyPrepController,
  BirthConversionController,
  AlbumCollectionController,
  MemoryLibraryController,
  MemoryPerspectiveContentController,
  MemoryPromptController,
  MilestoneController,
  MemoryLetterController,
  MissionRecurrenceController,
  MissionConfigController,
  CircleController,
  MemoryReviewController,
  UsSettingsController,
  PreferenceSettingsController,
  SafetyController,
  WeeklyRecapController,
  ProfileImageController,
  FamilyErasureController,
  FamilyPrivacyController,
  MonthlyPhotoSelectionController,
];

export const APPLICATION_PROVIDERS: Provider[] = [
  {
    provide: SUBSCRIPTION_REMINDER_REPOSITORY,
    useClass: SubscriptionReminderRepository,
  },
  {
    provide: SUBSCRIPTION_REMINDER_SERVICE,
    useClass: SubscriptionReminderService,
  },
  { provide: SUPPORT_HELPDESK_SERVICE, useClass: SupportHelpdeskService },
  { provide: SUPPORT_HELPDESK_REPOSITORY, useClass: SupportHelpdeskRepository },
  { provide: MODERATION_WORKFLOW_SERVICE, useClass: ModerationWorkflowService },
  {
    provide: MODERATION_WORKFLOW_REPOSITORY,
    useClass: ModerationWorkflowRepository,
  },
  ...INTERNAL_SERVICE_PROVIDERS,
  { provide: MISSION_BOARD_SERVICE, useClass: MissionBoardService },
  { provide: MISSION_BOARD_REPOSITORY, useClass: MissionBoardRepository },
  AccessTokenGuard,
  { provide: AUTH_ACCESS_REPOSITORY, useClass: AuthAccessRepository },
  { provide: CATALOG_QUERY_REPOSITORY, useClass: CatalogQueryRepository },
  { provide: MEDIA_REPOSITORY, useClass: MediaRepository },
  { provide: MEDIA_SERVICE, useClass: MediaService },
  {
    provide: PREGNANCY_COMMAND_REPOSITORY,
    useClass: PregnancyCommandRepository,
  },
  { provide: AUTHENTICATION_SERVICE, useClass: AuthenticationService },
  { provide: APPLICATION_ACCESS_SERVICE, useClass: ApplicationAccessService },
  { provide: USER_SERVICE, useClass: UserService },
  { provide: USER_SETTING_SERVICE, useClass: UserSettingService },
  { provide: FAMILY_SERVICE, useClass: FamilyService },
  { provide: CHILD_SERVICE, useClass: ChildService },
  { provide: PREGNANCY_SERVICE, useClass: PregnancyService },
  { provide: BILLING_CATALOG_SERVICE, useClass: BillingCatalogService },
  { provide: FAMILY_BILLING_SERVICE, useClass: FamilyBillingService },
  { provide: AUTH_TOKEN_SERVICE, useClass: AuthTokenService },
  { provide: OTP_SENDER_SERVICE, useClass: OtpSenderService },
  { provide: AUTH_SESSION_REPOSITORY, useClass: AuthSessionRepository },
  { provide: AUTH_SESSION_SERVICE, useClass: AuthSessionService },
  { provide: ACCOUNT_REPOSITORY, useClass: AccountRepository },
  { provide: ONBOARDING_REPOSITORY, useClass: OnboardingRepository },
  { provide: ONBOARDING_SERVICE, useClass: OnboardingService },
  { provide: MEMORY_CONTENT_REPOSITORY, useClass: MemoryContentRepository },
  { provide: MEMORY_CONTENT_SERVICE, useClass: MemoryContentService },
  {
    provide: MEMORY_INTERACTION_REPOSITORY,
    useClass: MemoryInteractionRepository,
  },
  { provide: MEMORY_INTERACTION_SERVICE, useClass: MemoryInteractionService },
  { provide: COUPLE_CHECKIN_SERVICE, useClass: CoupleCheckinService },
  { provide: COUPLE_CHECKIN_REPOSITORY, useClass: CoupleCheckinRepository },
  { provide: COUPLE_REQUEST_SERVICE, useClass: CoupleRequestService },
  { provide: COUPLE_REQUEST_REPOSITORY, useClass: CoupleRequestRepository },
  {
    provide: COUPLE_APPRECIATION_SERVICE,
    useClass: CoupleAppreciationService,
  },
  {
    provide: COUPLE_APPRECIATION_REPOSITORY,
    useClass: CoupleAppreciationRepository,
  },
  { provide: COUPLE_JOURNAL_SERVICE, useClass: CoupleJournalService },
  {
    provide: COUPLE_JOURNAL_REPOSITORY,
    useClass: CoupleJournalRepository,
  },
  { provide: CARE_PROGRESS_SERVICE, useClass: CareProgressService },
  { provide: CARE_PROGRESS_REPOSITORY, useClass: CareProgressRepository },
  { provide: NOTIFICATION_INBOX_SERVICE, useClass: NotificationInboxService },
  {
    provide: NOTIFICATION_INBOX_REPOSITORY,
    useClass: NotificationInboxRepository,
  },
  { provide: ACCOUNT_DELETION_SERVICE, useClass: AccountDeletionService },
  { provide: DATA_EXPORT_SERVICE, useClass: DataExportService },
  { provide: ACCOUNT_DELETION_REPOSITORY, useClass: AccountDeletionRepository },
  { provide: DATA_EXPORT_REPOSITORY, useClass: DataExportRepository },
  { provide: CALENDAR_SERVICE, useClass: CalendarService },
  { provide: CALENDAR_REPOSITORY, useClass: CalendarRepository },
  { provide: REAUTH_SERVICE, useClass: ReauthService },
  { provide: ACCOUNT_SECURITY_SERVICE, useClass: AccountSecurityService },
  { provide: ACCOUNT_SECURITY_REPOSITORY, useClass: AccountSecurityRepository },
  { provide: FAMILY_SETTINGS_SERVICE, useClass: FamilySettingsService },
  { provide: FAMILY_SETTINGS_REPOSITORY, useClass: FamilySettingsRepository },
  { provide: PREGNANCY_JOURNEY_SERVICE, useClass: PregnancyJourneyService },
  {
    provide: PREGNANCY_JOURNEY_REPOSITORY,
    useClass: PregnancyJourneyRepository,
  },
  { provide: PREGNANCY_PREP_SERVICE, useClass: PregnancyPrepService },
  { provide: PREGNANCY_PREP_REPOSITORY, useClass: PregnancyPrepRepository },
  {
    provide: BIRTH_CONVERSION_WORKFLOW_SERVICE,
    useClass: BirthConversionWorkflowService,
  },
  {
    provide: BIRTH_CONVERSION_WORKFLOW_REPOSITORY,
    useClass: BirthConversionWorkflowRepository,
  },
  { provide: PREGNANCY_LIFECYCLE_SERVICE, useClass: PregnancyLifecycleService },
  {
    provide: PREGNANCY_LIFECYCLE_REPOSITORY,
    useClass: PregnancyLifecycleRepository,
  },
  { provide: CHILD_PROFILE_SERVICE, useClass: ChildProfileService },
  { provide: CHILD_PROFILE_REPOSITORY, useClass: ChildProfileRepository },
  { provide: ALBUM_COLLECTION_SERVICE, useClass: AlbumCollectionService },
  { provide: ALBUM_COLLECTION_REPOSITORY, useClass: AlbumCollectionRepository },
  { provide: MEMORY_LIBRARY_SERVICE, useClass: MemoryLibraryService },
  { provide: MEMORY_LIBRARY_REPOSITORY, useClass: MemoryLibraryRepository },
  {
    provide: MEMORY_PERSPECTIVE_CONTENT_SERVICE,
    useClass: MemoryPerspectiveContentService,
  },
  {
    provide: MEMORY_PERSPECTIVE_CONTENT_REPOSITORY,
    useClass: MemoryPerspectiveContentRepository,
  },
  { provide: MEMORY_PROMPT_SERVICE, useClass: MemoryPromptService },
  { provide: MEMORY_PROMPT_REPOSITORY, useClass: MemoryPromptRepository },
  { provide: MILESTONE_CATALOG_SERVICE, useClass: MilestoneCatalogService },
  {
    provide: MILESTONE_CATALOG_REPOSITORY,
    useClass: MilestoneCatalogRepository,
  },
  { provide: MEMORY_CAPSULE_SERVICE, useClass: MemoryCapsuleService },
  { provide: MEMORY_CAPSULE_REPOSITORY, useClass: MemoryCapsuleRepository },
  { provide: MISSION_MOMENT_SERVICE, useClass: MissionMomentService },
  { provide: MISSION_MOMENT_REPOSITORY, useClass: MissionMomentRepository },
  { provide: MISSION_RECURRENCE_SERVICE, useClass: MissionRecurrenceService },
  {
    provide: MISSION_RECURRENCE_REPOSITORY,
    useClass: MissionRecurrenceRepository,
  },
  { provide: MISSION_CONFIG_SERVICE, useClass: MissionConfigService },
  { provide: MISSION_CONFIG_REPOSITORY, useClass: MissionConfigRepository },
  { provide: FAMILY_CIRCLE_SERVICE, useClass: FamilyCircleService },
  { provide: FAMILY_CIRCLE_REPOSITORY, useClass: FamilyCircleRepository },
  { provide: MEMORY_REVIEW_SERVICE, useClass: MemoryReviewService },
  { provide: MEMORY_REVIEW_REPOSITORY, useClass: MemoryReviewRepository },
  { provide: US_SETTINGS_SERVICE, useClass: UsSettingsService },
  { provide: US_SETTINGS_REPOSITORY, useClass: UsSettingsRepository },
  { provide: PREFERENCE_SETTINGS_SERVICE, useClass: PreferenceSettingsService },
  { provide: SAFETY_SERVICE, useClass: SafetyService },
  { provide: SAFETY_REPOSITORY, useClass: SafetyRepository },
  { provide: WEEKLY_RECAP_REPOSITORY, useClass: WeeklyRecapRepository },
  { provide: WEEKLY_RECAP_SERVICE, useClass: WeeklyRecapService },
  { provide: PROFILE_IMAGE_SERVICE, useClass: ProfileImageService },
  { provide: PROFILE_IMAGE_REPOSITORY, useClass: ProfileImageRepository },
  { provide: IMAGE_PROCESSOR_SERVICE, useClass: ImageProcessorService },
  { provide: FAMILY_ERASURE_REPOSITORY, useClass: FamilyErasureRepository },
  { provide: FAMILY_ERASURE_SERVICE, useClass: FamilyErasureService },
  { provide: FAMILY_PRIVACY_REPOSITORY, useClass: FamilyPrivacyRepository },
  { provide: FAMILY_PRIVACY_SERVICE, useClass: FamilyPrivacyService },
  {
    provide: MONTHLY_PHOTO_SELECTION_SERVICE,
    useClass: MonthlyPhotoSelectionService,
  },
  {
    provide: MONTHLY_PHOTO_SELECTION_REPOSITORY,
    useClass: MonthlyPhotoSelectionRepository,
  },
  { provide: TIMELINE_CARD_REPOSITORY, useClass: TimelineCardRepository },
  { provide: REQUEST_LOCALE_SERVICE, useClass: RequestLocaleService },
  {
    provide: NOTIFICATION_TEXT_REPOSITORY,
    useClass: NotificationTextRepository,
  },
  { provide: NOTIFICATION_TEXT_SERVICE, useClass: NotificationTextService },
  {
    provide: PREFERENCE_SETTINGS_REPOSITORY,
    useClass: PreferenceSettingsRepository,
  },
];
