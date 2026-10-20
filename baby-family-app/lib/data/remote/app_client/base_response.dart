import 'package:baby_family/data/model/account/data_export_record.dart';
import 'package:baby_family/data/model/account/deletion_preview_record.dart';
import 'package:baby_family/data/model/account/reauth_token_record.dart';
import 'package:baby_family/data/model/account/session_list.dart';
import 'package:baby_family/data/model/auth_certificate.dart';
import 'package:baby_family/data/model/billing/billing_catalog.dart';
import 'package:baby_family/data/model/billing/family_billing_record.dart';
import 'package:baby_family/data/model/care/badge_list.dart';
import 'package:baby_family/data/model/care/calendar_event_record.dart';
import 'package:baby_family/data/model/care/calendar_record.dart';
import 'package:baby_family/data/model/care/family_tree_record.dart';
import 'package:baby_family/data/model/care/hearts_me_record.dart';
import 'package:baby_family/data/model/care/mission_board_record.dart';
import 'package:baby_family/data/model/care/mission_history_page.dart';
import 'package:baby_family/data/model/care/mission_record.dart';
import 'package:baby_family/data/model/care/mission_result_record.dart';
import 'package:baby_family/data/model/care/mission_series_list.dart';
import 'package:baby_family/data/model/care/mission_series_record.dart';
import 'package:baby_family/data/model/care/mission_settings_record.dart';
import 'package:baby_family/data/model/care/mission_swap_options_record.dart';
import 'package:baby_family/data/model/care/mission_template_list.dart';
import 'package:baby_family/data/model/child/child_record.dart';
import 'package:baby_family/data/model/child/child_stats_record.dart';
import 'package:baby_family/data/model/circle/circle_invite_issued.dart';
import 'package:baby_family/data/model/circle/circle_invite_list.dart';
import 'package:baby_family/data/model/circle/circle_member_list.dart';
import 'package:baby_family/data/model/circle/my_circle_list.dart';
import 'package:baby_family/data/model/family/family_record.dart';
import 'package:baby_family/data/model/family/family_settings_record.dart';
import 'package:baby_family/data/model/memory/album_list.dart';
import 'package:baby_family/data/model/memory/album_record.dart';
import 'package:baby_family/data/model/memory/comment_record.dart';
import 'package:baby_family/data/model/memory/download_url_list.dart';
import 'package:baby_family/data/model/memory/letter_record.dart';
import 'package:baby_family/data/model/memory/media_grid_item_record.dart';
import 'package:baby_family/data/model/memory/memory_prompt_list.dart';
import 'package:baby_family/data/model/memory/memory_record.dart';
import 'package:baby_family/data/model/memory/milestone_catalog.dart';
import 'package:baby_family/data/model/memory/monthly_photo_record.dart';
import 'package:baby_family/data/model/memory/on_this_day_record.dart';
import 'package:baby_family/data/model/memory/perspective_list.dart';
import 'package:baby_family/data/model/memory/perspective_record.dart';
import 'package:baby_family/data/model/memory/reaction_state.dart';
import 'package:baby_family/data/model/memory/timeline_item_record.dart';
import 'package:baby_family/data/model/memory/today_story_record.dart';
import 'package:baby_family/data/model/memory/upload_intent.dart';
import 'package:baby_family/data/model/memory/upload_status.dart';
import 'package:baby_family/data/model/notification/notification_count.dart';
import 'package:baby_family/data/model/notification/notification_page.dart';
import 'package:baby_family/data/model/pregnancy/birth_result_record.dart';
import 'package:baby_family/data/model/pregnancy/journey_record.dart';
import 'package:baby_family/data/model/pregnancy/pregnancy_record.dart';
import 'package:baby_family/data/model/pregnancy/prep_group_record.dart';
import 'package:baby_family/data/model/pregnancy/prep_item_record.dart';
import 'package:baby_family/data/model/privacy/family_deletion_record.dart';
import 'package:baby_family/data/model/privacy/privacy_overview_record.dart';
import 'package:baby_family/data/model/recap/week_stats_record.dart';
import 'package:baby_family/data/model/recap/weekly_recap_record.dart';
import 'package:baby_family/data/model/safety/blocked_user_list.dart';
import 'package:baby_family/data/model/safety/report_record.dart';
import 'package:baby_family/data/model/session/family_bootstrap.dart';
import 'package:baby_family/data/model/session/invite_decision.dart';
import 'package:baby_family/data/model/session/invite_resolution.dart';
import 'package:baby_family/data/model/session/me_profile.dart';
import 'package:baby_family/data/model/session/otp_dispatch.dart';
import 'package:baby_family/data/model/session/partner_invite_issued.dart';
import 'package:baby_family/data/model/session/partner_invite_status.dart';
import 'package:baby_family/data/model/settings/ai_settings_record.dart';
import 'package:baby_family/data/model/settings/display_settings_record.dart';
import 'package:baby_family/data/model/settings/notification_settings_record.dart';
import 'package:baby_family/data/model/settings/support_category_catalog.dart';
import 'package:baby_family/data/model/settings/support_ticket.dart';
import 'package:baby_family/data/model/settings/support_ticket_list.dart';
import 'package:baby_family/data/model/us/appreciation_record.dart';
import 'package:baby_family/data/model/us/appreciation_wall.dart';
import 'package:baby_family/data/model/us/checkin_record.dart';
import 'package:baby_family/data/model/us/checkin_today.dart';
import 'package:baby_family/data/model/us/journal_entry_record.dart';
import 'package:baby_family/data/model/us/journal_list.dart';
import 'package:baby_family/data/model/us/request_created.dart';
import 'package:baby_family/data/model/us/request_list.dart';
import 'package:baby_family/data/model/us/request_record.dart';
import 'package:baby_family/data/model/us/us_settings_record.dart';
import 'package:baby_family/data/model/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_response.freezed.dart';
part 'base_response.g.dart';

/// Envelope response thành công của API: `{ "data": <payload>, "nextCursor"? }`.
/// Lỗi: `{ "error": { code, messageKey, message, details, traceId } }` — xử lý
/// ở `ErrorHandleInterceptor` / `serverErrorMessage`.
///
/// Mỗi kiểu response là một factory; nhóm theo module giống tài liệu kỹ thuật
/// mục 11.3.
@freezed
sealed class BaseRespond with _$BaseRespond {
  BaseRespond._();

  // ========================================================================
  // AUTH & ME
  // ========================================================================

  factory BaseRespond.authCertificateRespond({
    @JsonKey(name: 'data') AuthCertificate? auth,
  }) = AuthCertificateRespond;

  factory BaseRespond.userRespond({@JsonKey(name: 'data') User? user}) =
      UserRespond;

  factory BaseRespond.otpDispatchRespond({
    @JsonKey(name: 'data') OtpDispatch? dispatch,
  }) = OtpDispatchRespond;

  factory BaseRespond.meProfileRespond({
    @JsonKey(name: 'data') MeProfile? profile,
  }) = MeProfileRespond;

  // ========================================================================
  // FAMILY & INVITE
  // ========================================================================

  factory BaseRespond.familyBootstrapRespond({
    @JsonKey(name: 'data') FamilyBootstrap? bootstrap,
  }) = FamilyBootstrapRespond;

  factory BaseRespond.partnerInviteIssuedRespond({
    @JsonKey(name: 'data') PartnerInviteIssued? invite,
  }) = PartnerInviteIssuedRespond;

  factory BaseRespond.partnerInviteStatusRespond({
    @JsonKey(name: 'data') PartnerInviteStatus? invite,
  }) = PartnerInviteStatusRespond;

  factory BaseRespond.inviteResolutionRespond({
    @JsonKey(name: 'data') InviteResolution? invite,
  }) = InviteResolutionRespond;

  factory BaseRespond.inviteDecisionRespond({
    @JsonKey(name: 'data') InviteDecision? decision,
  }) = InviteDecisionRespond;

  // ========================================================================
  // CHILD & PREGNANCY
  // ========================================================================

  factory BaseRespond.childRecordRespond({
    @JsonKey(name: 'data') ChildRecord? child,
  }) = ChildRecordRespond;

  factory BaseRespond.pregnancyRecordRespond({
    @JsonKey(name: 'data') PregnancyRecord? pregnancy,
  }) = PregnancyRecordRespond;

  // ========================================================================
  // MEDIA & MEMORY
  // ========================================================================

  factory BaseRespond.uploadIntentRespond({
    @JsonKey(name: 'data') UploadIntent? intent,
  }) = UploadIntentRespond;

  factory BaseRespond.uploadStatusRespond({
    @JsonKey(name: 'data') UploadStatus? upload,
  }) = UploadStatusRespond;

  factory BaseRespond.memoryRecordRespond({
    @JsonKey(name: 'data') MemoryRecord? memory,
  }) = MemoryRecordRespond;

  /// `{ data: [...], nextCursor }` của MEM-01.
  factory BaseRespond.timelineRespond({
    @JsonKey(name: 'data')
    @Default(<TimelineItemRecord>[])
    List<TimelineItemRecord> items,
    @JsonKey(name: 'nextCursor') String? nextCursor,
  }) = TimelineRespond;

  /// `{ data: [...], nextCursor }` của MEM-02.
  factory BaseRespond.mediaGridRespond({
    @JsonKey(name: 'data')
    @Default(<MediaGridItemRecord>[])
    List<MediaGridItemRecord> items,
    @JsonKey(name: 'nextCursor') String? nextCursor,
  }) = MediaGridRespond;

  factory BaseRespond.commentRecordRespond({
    @JsonKey(name: 'data') CommentRecord? comment,
  }) = CommentRecordRespond;

  /// `{ data: [...] }` — toàn bộ bình luận của ký ức (MEM-10).
  factory BaseRespond.commentListRespond({
    @JsonKey(name: 'data')
    @Default(<CommentRecord>[])
    List<CommentRecord> comments,
  }) = CommentListRespond;

  factory BaseRespond.reactionStateRespond({
    @JsonKey(name: 'data') ReactionState? reaction,
  }) = ReactionStateRespond;

  /// Danh sách cursor: `{ data: [...], nextCursor }` (mục 11.1).
  factory BaseRespond.memoryFeedRespond({
    @JsonKey(name: 'data')
    @Default(<MemoryRecord>[])
    List<MemoryRecord> memories,
    @JsonKey(name: 'nextCursor') String? nextCursor,
  }) = MemoryFeedRespond;

  // ========================================================================
  // THÔNG BÁO
  // ========================================================================

  factory BaseRespond.notificationPageRespond({
    @JsonKey(name: 'data') NotificationPage? page,
  }) = NotificationPageRespond;

  factory BaseRespond.notificationCountRespond({
    @JsonKey(name: 'data') NotificationCount? count,
  }) = NotificationCountRespond;

  // ========================================================================
  // NHIỆM VỤ
  // ========================================================================

  factory BaseRespond.heartsMeRespond({
    @JsonKey(name: 'data') HeartsMeRecord? hearts,
  }) = HeartsMeRespond;

  factory BaseRespond.familyTreeRespond({
    @JsonKey(name: 'data') FamilyTreeRecord? tree,
  }) = FamilyTreeRespond;

  factory BaseRespond.badgeListRespond({
    @JsonKey(name: 'data') BadgeList? list,
  }) = BadgeListRespond;

  factory BaseRespond.missionHistoryRespond({
    @JsonKey(name: 'data') MissionHistoryPage? page,
  }) = MissionHistoryRespond;

  factory BaseRespond.missionBoardRespond({
    @JsonKey(name: 'data') MissionBoardRecord? board,
  }) = MissionBoardRespond;

  factory BaseRespond.missionRecordRespond({
    @JsonKey(name: 'data') MissionRecord? mission,
  }) = MissionRecordRespond;

  factory BaseRespond.missionResultRespond({
    @JsonKey(name: 'data') MissionResultRecord? result,
  }) = MissionResultRespond;

  factory BaseRespond.missionTemplateListRespond({
    @JsonKey(name: 'data') MissionTemplateList? list,
  }) = MissionTemplateListRespond;

  factory BaseRespond.missionSwapOptionsRespond({
    @JsonKey(name: 'data') MissionSwapOptionsRecord? options,
  }) = MissionSwapOptionsRespond;

  // ========================================================================
  // PAPA & MAMA
  // ========================================================================

  factory BaseRespond.appreciationRecordRespond({
    @JsonKey(name: 'data') AppreciationRecord? appreciation,
  }) = AppreciationRecordRespond;

  factory BaseRespond.appreciationWallRespond({
    @JsonKey(name: 'data') AppreciationWall? wall,
  }) = AppreciationWallRespond;

  factory BaseRespond.journalEntryRespond({
    @JsonKey(name: 'data') JournalEntryRecord? entry,
  }) = JournalEntryRespond;

  factory BaseRespond.journalListRespond({
    @JsonKey(name: 'data') JournalList? page,
  }) = JournalListRespond;

  factory BaseRespond.checkinRecordRespond({
    @JsonKey(name: 'data') CheckinRecord? checkin,
  }) = CheckinRecordRespond;

  factory BaseRespond.checkinTodayRespond({
    @JsonKey(name: 'data') CheckinToday? today,
  }) = CheckinTodayRespond;

  factory BaseRespond.requestCreatedRespond({
    @JsonKey(name: 'data') RequestCreated? created,
  }) = RequestCreatedRespond;

  factory BaseRespond.requestRecordRespond({
    @JsonKey(name: 'data') RequestRecord? request,
  }) = RequestRecordRespond;

  factory BaseRespond.requestListRespond({
    @JsonKey(name: 'data') RequestList? page,
  }) = RequestListRespond;

  factory BaseRespond.reauthTokenRespond({
    @JsonKey(name: 'data') ReauthTokenRecord? token,
  }) = ReauthTokenRespond;

  factory BaseRespond.deletionPreviewRespond({
    @JsonKey(name: 'data') DeletionPreviewRecord? preview,
  }) = DeletionPreviewRespond;

  factory BaseRespond.dataExportRespond({
    @JsonKey(name: 'data') DataExportRecord? export,
  }) = DataExportRespond;

  factory BaseRespond.calendarRespond({
    @JsonKey(name: 'data') CalendarRecord? calendar,
  }) = CalendarRespond;

  factory BaseRespond.calendarEventRespond({
    @JsonKey(name: 'data') CalendarEventRecord? event,
  }) = CalendarEventRespond;

  factory BaseRespond.sessionListRespond({
    @JsonKey(name: 'data') SessionList? list,
  }) = SessionListRespond;

  factory BaseRespond.familySettingsRespond({
    @JsonKey(name: 'data') FamilySettingsRecord? settings,
  }) = FamilySettingsRespond;

  factory BaseRespond.journeyRespond({
    @JsonKey(name: 'data') JourneyRecord? journey,
  }) = JourneyRespond;

  factory BaseRespond.prepGroupsRespond({
    @JsonKey(name: 'data') List<PrepGroupRecord>? groups,
  }) = PrepGroupsRespond;

  factory BaseRespond.prepItemRespond({
    @JsonKey(name: 'data') PrepItemRecord? item,
  }) = PrepItemRespond;

  factory BaseRespond.birthResultRespond({
    @JsonKey(name: 'data') BirthResultRecord? result,
  }) = BirthResultRespond;

  factory BaseRespond.childStatsRespond({
    @JsonKey(name: 'data') ChildStatsRecord? stats,
  }) = ChildStatsRespond;

  factory BaseRespond.albumListRespond({
    @JsonKey(name: 'data') AlbumList? list,
  }) = AlbumListRespond;

  factory BaseRespond.albumRecordRespond({
    @JsonKey(name: 'data') AlbumRecord? album,
  }) = AlbumRecordRespond;

  factory BaseRespond.perspectiveListRespond({
    @JsonKey(name: 'data') PerspectiveList? list,
  }) = PerspectiveListRespond;

  factory BaseRespond.perspectiveRecordRespond({
    @JsonKey(name: 'data') PerspectiveRecord? perspective,
  }) = PerspectiveRecordRespond;

  factory BaseRespond.memoryPromptListRespond({
    @JsonKey(name: 'data') MemoryPromptList? list,
  }) = MemoryPromptListRespond;

  factory BaseRespond.downloadUrlListRespond({
    @JsonKey(name: 'data') DownloadUrlList? list,
  }) = DownloadUrlListRespond;

  factory BaseRespond.milestoneCatalogRespond({
    @JsonKey(name: 'data') MilestoneCatalog? catalog,
  }) = MilestoneCatalogRespond;

  factory BaseRespond.letterListRespond({
    @JsonKey(name: 'data')
    @Default(<LetterRecord>[])
    List<LetterRecord> letters,
  }) = LetterListRespond;

  factory BaseRespond.missionSettingsRespond({
    @JsonKey(name: 'data') MissionSettingsRecord? settings,
  }) = MissionSettingsRespond;

  factory BaseRespond.missionSeriesRespond({
    @JsonKey(name: 'data') MissionSeriesRecord? series,
  }) = MissionSeriesRespond;

  factory BaseRespond.circleMemberListRespond({
    @JsonKey(name: 'data') CircleMemberList? list,
  }) = CircleMemberListRespond;

  factory BaseRespond.circleInviteListRespond({
    @JsonKey(name: 'data') CircleInviteList? list,
  }) = CircleInviteListRespond;

  factory BaseRespond.circleInviteIssuedRespond({
    @JsonKey(name: 'data') CircleInviteIssued? invite,
  }) = CircleInviteIssuedRespond;

  factory BaseRespond.usSettingsRespond({
    @JsonKey(name: 'data') UsSettingsRecord? settings,
  }) = UsSettingsRespond;

  factory BaseRespond.myCircleListRespond({
    @JsonKey(name: 'data') MyCircleList? list,
  }) = MyCircleListRespond;

  factory BaseRespond.billingCatalogRespond({
    @JsonKey(name: 'data') BillingCatalog? catalog,
  }) = BillingCatalogRespond;

  factory BaseRespond.familyBillingRespond({
    @JsonKey(name: 'data') FamilyBillingRecord? billing,
  }) = FamilyBillingRespond;

  factory BaseRespond.notificationSettingsRespond({
    @JsonKey(name: 'data') NotificationSettingsRecord? settings,
  }) = NotificationSettingsRespond;

  factory BaseRespond.aiSettingsRespond({
    @JsonKey(name: 'data') AiSettingsRecord? settings,
  }) = AiSettingsRespond;

  factory BaseRespond.onThisDayRespond({
    @JsonKey(name: 'data') OnThisDayRecord? record,
  }) = OnThisDayRespond;

  factory BaseRespond.reportRespond({
    @JsonKey(name: 'data') ReportRecord? report,
  }) = ReportRespond;

  factory BaseRespond.blockedUserListRespond({
    @JsonKey(name: 'data') BlockedUserList? list,
  }) = BlockedUserListRespond;

  factory BaseRespond.weekStatsRespond({
    @JsonKey(name: 'data') WeekStatsRecord? stats,
  }) = WeekStatsRespond;

  factory BaseRespond.weeklyRecapRespond({
    @JsonKey(name: 'data') WeeklyRecapRecord? recap,
  }) = WeeklyRecapRespond;

  factory BaseRespond.displaySettingsRespond({
    @JsonKey(name: 'data') DisplaySettingsRecord? settings,
  }) = DisplaySettingsRespond;

  factory BaseRespond.familyDeletionRespond({
    @JsonKey(name: 'data') FamilyDeletionRecord? deletion,
  }) = FamilyDeletionRespond;

  factory BaseRespond.privacyOverviewRespond({
    @JsonKey(name: 'data') PrivacyOverviewRecord? overview,
  }) = PrivacyOverviewRespond;

  factory BaseRespond.monthlyPhotoListRespond({
    @JsonKey(name: 'data')
    @Default(<MonthlyPhotoRecord>[])
    List<MonthlyPhotoRecord> photos,
  }) = MonthlyPhotoListRespond;

  factory BaseRespond.monthlyPhotoRespond({
    @JsonKey(name: 'data') MonthlyPhotoRecord? photo,
  }) = MonthlyPhotoRespond;

  factory BaseRespond.todayStoryRespond({
    @JsonKey(name: 'data') TodayStoryRecord? story,
  }) = TodayStoryRespond;

  factory BaseRespond.familyRecordRespond({
    @JsonKey(name: 'data') FamilyRecord? family,
  }) = FamilyRecordRespond;

  factory BaseRespond.missionSeriesListRespond({
    @JsonKey(name: 'data') MissionSeriesList? list,
  }) = MissionSeriesListRespond;

  factory BaseRespond.supportCategoriesRespond({
    @JsonKey(name: 'data') SupportCategoryCatalog? catalog,
  }) = SupportCategoriesRespond;

  factory BaseRespond.supportTicketRespond({
    @JsonKey(name: 'data') SupportTicket? ticket,
  }) = SupportTicketRespond;

  factory BaseRespond.supportTicketListRespond({
    @JsonKey(name: 'data') SupportTicketList? list,
  }) = SupportTicketListRespond;

  factory BaseRespond.fromJson(Map<String, dynamic> json) =>
      _$BaseRespondFromJson(json);
}
