import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/circle/circle_child/circle_child_page.dart';
import 'package:baby_family/page/circle/circle_home/circle_home_page.dart';
import 'package:baby_family/page/circle/circle_me/circle_me_page.dart';
import 'package:baby_family/page/circle/circle_memory_detail/circle_memory_detail_page.dart';
import 'package:baby_family/page/circle/circle_paused/circle_paused_page.dart';
import 'package:baby_family/page/circle/circle_post/circle_post_page.dart';
import 'package:baby_family/page/circle/circle_shell/circle_shell_page.dart';
import 'package:baby_family/page/circle/circle_waiting/circle_waiting_page.dart';
import 'package:baby_family/page/circle/leave_family/leave_family_page.dart';
import 'package:baby_family/page/general/about/about_page.dart';
import 'package:baby_family/page/general/ai_settings/ai_settings_page.dart';
import 'package:baby_family/page/general/auth/auth_page.dart';
import 'package:baby_family/page/general/auth_otp/auth_otp_page.dart';
import 'package:baby_family/page/general/auth_phone/auth_phone_page.dart';
import 'package:baby_family/page/general/auth_profile/auth_profile_page.dart';
import 'package:baby_family/page/general/blocked_people/blocked_people_page.dart';
import 'package:baby_family/page/general/delete_account/delete_account_page.dart';
import 'package:baby_family/page/general/display_settings/display_settings_page.dart';
import 'package:baby_family/page/general/expired/expired_page.dart';
import 'package:baby_family/page/general/help/help_page.dart';
import 'package:baby_family/page/general/invite_code/invite_code_page.dart';
import 'package:baby_family/page/general/invite_preview/invite_preview_page.dart';
import 'package:baby_family/page/general/my_data/my_data_page.dart';
import 'package:baby_family/page/general/notification_settings/notification_settings_page.dart';
import 'package:baby_family/page/general/notifications/notifications_page.dart';
import 'package:baby_family/page/general/onboarding_activated/onboarding_activated_page.dart';
import 'package:baby_family/page/general/onboarding_child/onboarding_child_page.dart';
import 'package:baby_family/page/general/onboarding_family/onboarding_family_page.dart';
import 'package:baby_family/page/general/onboarding_first_memory/onboarding_first_memory_page.dart';
import 'package:baby_family/page/general/onboarding_invite_partner/onboarding_invite_partner_page.dart';
import 'package:baby_family/page/general/onboarding_notifications/onboarding_notifications_page.dart';
import 'package:baby_family/page/general/onboarding_pregnancy/onboarding_pregnancy_page.dart';
import 'package:baby_family/page/general/onboarding_privacy/onboarding_privacy_page.dart';
import 'package:baby_family/page/general/onboarding_role/onboarding_role_page.dart';
import 'package:baby_family/page/general/onboarding_stage/onboarding_stage_page.dart';
import 'package:baby_family/page/general/onboarding_waiting/onboarding_waiting_page.dart';
import 'package:baby_family/page/general/plans/plans_page.dart';
import 'package:baby_family/page/general/privacy_settings/privacy_settings_page.dart';
import 'package:baby_family/page/general/profile_settings/profile_settings_page.dart';
import 'package:baby_family/page/general/security_settings/security_settings_page.dart';
import 'package:baby_family/page/general/settings/settings_page.dart';
import 'package:baby_family/page/general/splash/splash_page.dart';
import 'package:baby_family/page/general/welcome/welcome_page.dart';
import 'package:baby_family/page/parent/album_detail/album_detail_page.dart';
import 'package:baby_family/page/parent/albums/albums_page.dart';
import 'package:baby_family/page/parent/baby_names/baby_names_page.dart';
import 'package:baby_family/page/parent/badges/badges_page.dart';
import 'package:baby_family/page/parent/birth/birth_page.dart';
import 'package:baby_family/page/parent/bridge_invite/bridge_invite_page.dart';
import 'package:baby_family/page/parent/bridge_next_step/bridge_next_step_page.dart';
import 'package:baby_family/page/parent/bridge_rewrite/bridge_rewrite_page.dart';
import 'package:baby_family/page/parent/bridge_session/bridge_session_page.dart';
import 'package:baby_family/page/parent/bridge_start/bridge_start_page.dart';
import 'package:baby_family/page/parent/calendar/calendar_page.dart';
import 'package:baby_family/page/parent/care_stats/care_stats_page.dart';
import 'package:baby_family/page/parent/care_tab/care_tab_page.dart';
import 'package:baby_family/page/parent/child_add/child_add_page.dart';
import 'package:baby_family/page/parent/child_archive/child_archive_page.dart';
import 'package:baby_family/page/parent/child_edit/child_edit_page.dart';
import 'package:baby_family/page/parent/child_profile/child_profile_page.dart';
import 'package:baby_family/page/parent/children/children_page.dart';
import 'package:baby_family/page/parent/collection_detail/collection_detail_page.dart';
import 'package:baby_family/page/parent/couple_settings/couple_settings_page.dart';
import 'package:baby_family/page/parent/couple_tab/couple_tab_page.dart';
import 'package:baby_family/page/parent/couple_week/couple_week_page.dart';
import 'package:baby_family/page/parent/day_story/day_story_page.dart';
import 'package:baby_family/page/parent/diary_editor/diary_editor_page.dart';
import 'package:baby_family/page/parent/drafts/drafts_page.dart';
import 'package:baby_family/page/parent/event_create/event_create_page.dart';
import 'package:baby_family/page/parent/family/family_page.dart';
import 'package:baby_family/page/parent/family_plan/family_plan_page.dart';
import 'package:baby_family/page/parent/family_settings/family_settings_page.dart';
import 'package:baby_family/page/parent/family_tree/family_tree_page.dart';
import 'package:baby_family/page/parent/firsts/firsts_page.dart';
import 'package:baby_family/page/parent/home_tab/home_tab_page.dart';
import 'package:baby_family/page/parent/letter_composer/letter_composer_page.dart';
import 'package:baby_family/page/parent/main_shell/main_shell_page.dart';
import 'package:baby_family/page/parent/memories_tab/memories_tab_page.dart';
import 'package:baby_family/page/parent/memory_comments/memory_comments_page.dart';
import 'package:baby_family/page/parent/memory_composer/memory_composer_page.dart';
import 'package:baby_family/page/parent/memory_detail/memory_detail_page.dart';
import 'package:baby_family/page/parent/memory_perspective/memory_perspective_page.dart';
import 'package:baby_family/page/parent/memory_quote/memory_quote_page.dart';
import 'package:baby_family/page/parent/memory_search/memory_search_page.dart';
import 'package:baby_family/page/parent/memory_story/memory_story_page.dart';
import 'package:baby_family/page/parent/milestone_picker/milestone_picker_page.dart';
import 'package:baby_family/page/parent/mission_create/mission_create_page.dart';
import 'package:baby_family/page/parent/mission_detail/mission_detail_page.dart';
import 'package:baby_family/page/parent/mission_history/mission_history_page.dart';
import 'package:baby_family/page/parent/mission_library/mission_library_page.dart';
import 'package:baby_family/page/parent/mission_settings/mission_settings_page.dart';
import 'package:baby_family/page/parent/month_recap/month_recap_page.dart';
import 'package:baby_family/page/parent/monthly_camera/monthly_camera_page.dart';
import 'package:baby_family/page/parent/monthly_photos/monthly_photos_page.dart';
import 'package:baby_family/page/parent/on_this_day/on_this_day_page.dart';
import 'package:baby_family/page/parent/partner_invite/partner_invite_page.dart';
import 'package:baby_family/page/parent/pending_invites/pending_invites_page.dart';
import 'package:baby_family/page/parent/pending_review/pending_review_page.dart';
import 'package:baby_family/page/parent/photo_viewer/photo_viewer_page.dart';
import 'package:baby_family/page/parent/pregnancy_archive/pregnancy_archive_page.dart';
import 'package:baby_family/page/parent/pregnancy_journey/pregnancy_journey_page.dart';
import 'package:baby_family/page/parent/private_journal/private_journal_page.dart';
import 'package:baby_family/page/parent/relative_detail/relative_detail_page.dart';
import 'package:baby_family/page/parent/relative_invite/relative_invite_page.dart';
import 'package:baby_family/page/parent/request_compose/request_compose_page.dart';
import 'package:baby_family/page/parent/request_detail/request_detail_page.dart';
import 'package:baby_family/page/parent/safety_support/safety_support_page.dart';
import 'package:baby_family/page/parent/thanks_compose/thanks_compose_page.dart';
import 'package:baby_family/page/parent/thanks_wall/thanks_wall_page.dart';
import 'package:baby_family/page/parent/trash/trash_page.dart';
import 'package:baby_family/page/parent/upgrade_plan/upgrade_plan_page.dart';
import 'package:baby_family/page/parent/weekly_recap/weekly_recap_page.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:flutter/widgets.dart';

part 'app_router.gr.dart';

/// Khai báo route — bảng điều hướng của kế hoạch rebuild (mã màn ↔ route ↔
/// API: tài liệu kỹ thuật mục 23). Mỗi màn mới: thêm `@RoutePage()` vào Page,
/// khai báo ở [routes], chạy `make runner`.
///
/// Không có guard chặn route (UI-first): Splash đọc phiên và điều hướng bằng
/// `routeForSession`; các bước onboarding luôn đi tiếp.
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType =>
      const RouteType.material(enablePredictiveBackGesture: false);

  @override
  final List<AutoRoute> routes = [
    // --- Khởi động, đăng nhập, onboarding (general) ---
    AutoRouteCustom(page: SplashRoute.page, path: '/', initial: true).route(),
    AutoRouteCustom(page: WelcomeRoute.page, path: '/welcome').route(),
    AutoRouteCustom(page: AuthRoute.page, path: '/auth').route(),
    AutoRouteCustom(page: AuthPhoneRoute.page, path: '/auth/phone').route(),
    AutoRouteCustom(page: AuthOtpRoute.page, path: '/auth/otp').route(),
    AutoRouteCustom(page: AuthProfileRoute.page, path: '/auth/profile').route(),
    AutoRouteCustom(
      page: OnboardingRoleRoute.page,
      path: '/onboarding/role',
    ).route(),
    AutoRouteCustom(
      page: OnboardingFamilyRoute.page,
      path: '/onboarding/family',
    ).route(),
    AutoRouteCustom(
      page: OnboardingInvitePartnerRoute.page,
      path: '/onboarding/invite-partner',
    ).route(),
    AutoRouteCustom(
      page: OnboardingWaitingRoute.page,
      path: '/onboarding/waiting',
    ).route(),
    AutoRouteCustom(
      page: OnboardingActivatedRoute.page,
      path: '/onboarding/activated',
    ).route(),
    AutoRouteCustom(
      page: OnboardingStageRoute.page,
      path: '/onboarding/stage',
    ).route(),
    AutoRouteCustom(
      page: OnboardingPregnancyRoute.page,
      path: '/onboarding/pregnancy',
    ).route(),
    AutoRouteCustom(
      page: OnboardingChildRoute.page,
      path: '/onboarding/child',
    ).route(),
    AutoRouteCustom(
      page: OnboardingPrivacyRoute.page,
      path: '/onboarding/privacy',
    ).route(),
    AutoRouteCustom(
      page: OnboardingNotificationsRoute.page,
      path: '/onboarding/notifications',
    ).route(),
    AutoRouteCustom(
      page: OnboardingFirstMemoryRoute.page,
      path: '/onboarding/first-memory',
    ).route(),
    AutoRouteCustom(page: InviteCodeRoute.page, path: '/invite/code').route(),
    AutoRouteCustom(
      page: InvitePreviewRoute.page,
      path: '/invite/preview',
    ).route(),

    // --- Người thân ---
    AutoRouteCustom(
      page: CircleWaitingRoute.page,
      path: '/circle/waiting',
    ).route(),
    AutoRouteCustom(
      page: CirclePausedRoute.page,
      path: '/circle/paused',
    ).route(),
    AutoRouteCustom(page: LeaveFamilyRoute.page, path: '/circle/leave').route(),
    AutoRouteCustom(
      page: CircleMemoryDetailRoute.page,
      path: '/circle/memory/:memoryId',
    ).route(),
    // Shell người thân 4 tab (Pencil LXpog).
    AutoRouteCustom(page: CircleShellRoute.page, path: '/circle').route(
      children: [
        AutoRouteCustom(
          page: CircleHomeRoute.page,
          path: 'home',
          initial: true,
        ),
        AutoRouteCustom(page: CircleChildRoute.page, path: 'child'),
        AutoRouteCustom(page: CirclePostRoute.page, path: 'post'),
        AutoRouteCustom(page: CircleMeRoute.page, path: 'me'),
      ],
    ),

    // --- App chính: shell 4 tab (Pencil luKhc) ---
    AutoRouteCustom(page: MainShellRoute.page, path: '/main').route(
      children: [
        AutoRouteCustom(page: HomeTabRoute.page, path: 'home', initial: true),
        AutoRouteCustom(page: MemoriesTabRoute.page, path: 'memories'),
        AutoRouteCustom(page: CareTabRoute.page, path: 'care'),
        AutoRouteCustom(page: CoupleTabRoute.page, path: 'us'),
      ],
    ),

    // --- Ký ức ---
    AutoRouteCustom(
      page: MemoryComposerRoute.page,
      path: '/memory/new',
    ).route(),
    CustomRoute(
      page: MemoryQuoteRoute.page,
      path: '/memory/quote',
      opaque: false,
      barrierColor: kColorSheetScrim2E2A27Alpha60,
      transitionsBuilder: TransitionsBuilders.slideBottom,
    ),
    AutoRouteCustom(page: DiaryEditorRoute.page, path: '/memory/diary').route(),
    AutoRouteCustom(
      page: LetterComposerRoute.page,
      path: '/memory/letter',
    ).route(),
    AutoRouteCustom(
      page: MemoryDetailRoute.page,
      path: '/memory/:memoryId',
    ).route(),
    AutoRouteCustom(
      page: PhotoViewerRoute.page,
      path: '/memory/:memoryId/photos',
    ).route(),
    AutoRouteCustom(
      page: MemoryCommentsRoute.page,
      path: '/memory/:memoryId/comments',
    ).route(),
    AutoRouteCustom(
      page: MemoryPerspectiveRoute.page,
      path: '/memory/:memoryId/perspective',
    ).route(),
    AutoRouteCustom(
      page: MemoryStoryRoute.page,
      path: '/story/:childId',
    ).route(),
    AutoRouteCustom(
      page: MonthlyPhotosRoute.page,
      path: '/monthly/:childId',
    ).route(),
    AutoRouteCustom(
      page: MonthlyCameraRoute.page,
      path: '/monthly/:childId/camera',
    ).route(),
    AutoRouteCustom(page: FirstsRoute.page, path: '/firsts/:childId').route(),
    AutoRouteCustom(
      page: CollectionDetailRoute.page,
      path: '/collections/:code',
    ).route(),

    // --- Chăm con ---
    AutoRouteCustom(page: MissionCreateRoute.page, path: '/care/new').route(),
    AutoRouteCustom(
      page: MissionLibraryRoute.page,
      path: '/care/library',
    ).route(),
    AutoRouteCustom(page: FamilyTreeRoute.page, path: '/care/tree').route(),
    AutoRouteCustom(
      page: MissionDetailRoute.page,
      path: '/care/mission/:missionId',
    ).route(),

    // --- Papa & Mama ---
    AutoRouteCustom(
      page: RequestComposeRoute.page,
      path: '/us/request/new',
    ).route(),
    AutoRouteCustom(
      page: RequestDetailRoute.page,
      path: '/us/request/:requestId',
    ).route(),
    AutoRouteCustom(
      page: ThanksComposeRoute.page,
      path: '/us/thanks/new',
    ).route(),

    // --- Gia đình, gói, cài đặt, thông báo ---
    AutoRouteCustom(page: FamilyRoute.page, path: '/family').route(),
    AutoRouteCustom(
      page: RelativeInviteRoute.page,
      path: '/family/invite',
    ).route(),
    AutoRouteCustom(page: PlansRoute.page, path: '/billing/plans').route(),
    AutoRouteCustom(page: ExpiredRoute.page, path: '/billing/expired').route(),
    AutoRouteCustom(page: SettingsRoute.page, path: '/settings').route(),
    AutoRouteCustom(
      page: DisplaySettingsRoute.page,
      path: '/settings/display',
    ).route(),
    AutoRouteCustom(
      page: NotificationsRoute.page,
      path: '/notifications',
    ).route(),

    // --- Thai kỳ ---
    AutoRouteCustom(
      page: PregnancyJourneyRoute.page,
      path: '/pregnancy/:pregnancyId',
    ).route(),
    AutoRouteCustom(
      page: BirthRoute.page,
      path: '/pregnancy/:pregnancyId/birth',
    ).route(),
    AutoRouteCustom(
      page: PregnancyArchiveRoute.page,
      path: '/pregnancy/:pregnancyId/archive',
    ).route(),
    AutoRouteCustom(
      page: BabyNamesRoute.page,
      path: '/pregnancy/:pregnancyId/names',
    ).route(),

    // --- Batch 2 (33 Pencil frames, 2026-10-10) ---
    AutoRouteCustom(page: AlbumsRoute.page, path: '/albums').route(),
    AutoRouteCustom(
      page: AlbumDetailRoute.page,
      path: '/albums/:albumId',
    ).route(),
    AutoRouteCustom(
      page: MilestonePickerRoute.page,
      path: '/milestones/pick',
    ).route(),
    AutoRouteCustom(page: MemorySearchRoute.page, path: '/search').route(),
    AutoRouteCustom(page: OnThisDayRoute.page, path: '/on-this-day').route(),
    AutoRouteCustom(page: WeeklyRecapRoute.page, path: '/recap/week').route(),
    AutoRouteCustom(page: CalendarRoute.page, path: '/calendar').route(),
    AutoRouteCustom(
      page: EventCreateRoute.page,
      path: '/calendar/event/new',
    ).route(),
    AutoRouteCustom(
      page: MissionHistoryRoute.page,
      path: '/care/history',
    ).route(),
    AutoRouteCustom(page: BadgesRoute.page, path: '/care/badges').route(),
    AutoRouteCustom(
      page: MissionSettingsRoute.page,
      path: '/care/settings',
    ).route(),
    AutoRouteCustom(page: ThanksWallRoute.page, path: '/us/thanks').route(),
    AutoRouteCustom(
      page: PrivateJournalRoute.page,
      path: '/us/journal',
    ).route(),
    AutoRouteCustom(
      page: CoupleSettingsRoute.page,
      path: '/us/settings',
    ).route(),
    AutoRouteCustom(page: ChildrenRoute.page, path: '/children').route(),
    AutoRouteCustom(page: ChildAddRoute.page, path: '/children/new').route(),
    AutoRouteCustom(
      page: ChildProfileRoute.page,
      path: '/child/:childId',
    ).route(),
    AutoRouteCustom(
      page: ChildEditRoute.page,
      path: '/child/:childId/edit',
    ).route(),
    AutoRouteCustom(
      page: RelativeDetailRoute.page,
      path: '/family/relative/:memberId',
    ).route(),
    AutoRouteCustom(
      page: FamilySettingsRoute.page,
      path: '/family/settings',
    ).route(),
    AutoRouteCustom(
      page: ProfileSettingsRoute.page,
      path: '/settings/profile',
    ).route(),
    AutoRouteCustom(
      page: NotificationSettingsRoute.page,
      path: '/settings/notifications',
    ).route(),
    AutoRouteCustom(
      page: PrivacySettingsRoute.page,
      path: '/settings/privacy',
    ).route(),
    AutoRouteCustom(
      page: SecuritySettingsRoute.page,
      path: '/settings/security',
    ).route(),
    AutoRouteCustom(page: MyDataRoute.page, path: '/settings/data').route(),
    AutoRouteCustom(
      page: DeleteAccountRoute.page,
      path: '/settings/delete-account',
    ).route(),
    AutoRouteCustom(page: HelpRoute.page, path: '/settings/help').route(),
    AutoRouteCustom(page: AboutRoute.page, path: '/settings/about').route(),

    // --- Batch 3 (Pencil frames, 2026-10-12) ---
    AutoRouteCustom(
      page: BridgeStartRoute.page,
      path: '/us/bridge/new',
    ).route(),
    AutoRouteCustom(
      page: BridgeRewriteRoute.page,
      path: '/us/bridge/rewrite',
    ).route(),
    AutoRouteCustom(
      page: BridgeInviteRoute.page,
      path: '/us/bridge/:sessionId/invite',
    ).route(),
    AutoRouteCustom(
      page: BridgeNextStepRoute.page,
      path: '/us/bridge/:sessionId/next',
    ).route(),
    AutoRouteCustom(
      page: BridgeSessionRoute.page,
      path: '/us/bridge/:sessionId',
    ).route(),
    AutoRouteCustom(page: SafetySupportRoute.page, path: '/us/safety').route(),
    AutoRouteCustom(page: CoupleWeekRoute.page, path: '/us/week').route(),
    AutoRouteCustom(page: DayStoryRoute.page, path: '/recap/day').route(),
    AutoRouteCustom(page: MonthRecapRoute.page, path: '/recap/month').route(),
    AutoRouteCustom(page: CareStatsRoute.page, path: '/care/stats').route(),
    AutoRouteCustom(page: TrashRoute.page, path: '/trash').route(),
    AutoRouteCustom(page: DraftsRoute.page, path: '/drafts').route(),
    AutoRouteCustom(page: PendingReviewRoute.page, path: '/review').route(),
    AutoRouteCustom(
      page: ChildArchiveRoute.page,
      path: '/child/:childId/archive',
    ).route(),
    AutoRouteCustom(page: FamilyPlanRoute.page, path: '/billing/plan').route(),
    AutoRouteCustom(
      page: UpgradePlanRoute.page,
      path: '/billing/upgrade',
    ).route(),
    AutoRouteCustom(
      page: PartnerInviteRoute.page,
      path: '/family/invite-partner',
    ).route(),
    AutoRouteCustom(
      page: PendingInvitesRoute.page,
      path: '/family/invites',
    ).route(),
    AutoRouteCustom(page: AiSettingsRoute.page, path: '/settings/ai').route(),
    AutoRouteCustom(
      page: BlockedPeopleRoute.page,
      path: '/settings/blocked',
    ).route(),
  ];
}

class AutoRouteCustom {
  AutoRouteCustom({
    required this.page,
    required this.path,
    this.initial = false,
  });

  final PageInfo page;
  final String path;
  final bool initial;

  AutoRoute route({
    List<AutoRouteCustom> children = const [],
    List<AutoRouteGuard> guards = const [],
  }) {
    return CustomRoute(
      page: page,
      path: path,
      guards: guards,
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      initial: initial,
      children: children.map((e) => e.route()).toList(),
    );
  }
}
