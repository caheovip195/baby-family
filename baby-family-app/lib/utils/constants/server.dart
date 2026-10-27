/// Endpoint API Baby Family (tài liệu kỹ thuật mục 11).
///
/// Base URL lấy từ [Flavor.endPoint]; mọi đường dẫn ở đây bắt đầu bằng `/v1`.
/// Chỉ khai báo đường dẫn — không gọi HTTP ở đây (Skill 6).
mixin Api {
  // --- Cấu hình app ---
  static const appConfig = '/v1/app-config';

  // --- Đăng nhập & phiên ---
  static const authPhoneOtp = '/v1/auth/phone/otp';
  static const authPhoneVerify = '/v1/auth/phone/verify';
  static const authApple = '/v1/auth/apple';
  static const authGoogle = '/v1/auth/google';
  static const mePhoneOtp = '/v1/me/phone/otp';
  static const mePhoneVerify = '/v1/me/phone/verify';
  static const supportCategories = '/v1/support/categories';
  static const supportHelpCenter = '/v1/support/help-center';
  static const meSignInMethods = '/v1/me/sign-in-methods';
  static const meFamilies = '/v1/me/families';
  static const meDefaultFamily = '/v1/me/default-family';
  static const catalogTimezones = '/v1/catalog/timezones';
  static const supportTickets = '/v1/support/tickets';
  static const meSupportTickets = '/v1/me/support/tickets';
  static const supportTicket = '/v1/support/tickets/{ticketId}';
  static const supportTicketMessages =
      '/v1/support/tickets/{ticketId}/messages';
  static const authRefresh = '/v1/auth/refresh';
  static const authLogout = '/v1/auth/logout';

  // --- Tài khoản ---
  static const me = '/v1/me';
  static const meDevices = '/v1/me/devices';
  static const meConsents = '/v1/me/consents';
  static const meOnboardingRole = '/v1/me/onboarding-role';

  // --- Gia đình & lời mời (mục 11.3) ---
  static const families = '/v1/families';
  static const familyCancel = '/v1/families/{familyId}/cancel';
  static const familyBootstrap = '/v1/families/{familyId}/bootstrap';
  static const familyPartnerInvite = '/v1/families/{familyId}/invites/partner';
  static const invitesResolve = '/v1/invites/resolve';
  static const invitesAccept = '/v1/invites/accept';
  static const invitesDecline = '/v1/invites/decline';
  static const inviteApprove = '/v1/invites/{inviteId}/approve';
  static const inviteReject = '/v1/invites/{inviteId}/reject';

  // --- Bé & thai kỳ (mục 11.3) ---
  static const familyChildren = '/v1/families/{familyId}/children';
  static const familyChild = '/v1/families/{familyId}/children/{childId}';
  static const familyPregnancies = '/v1/families/{familyId}/pregnancies';
  static const familyPregnancy =
      '/v1/families/{familyId}/pregnancies/{pregnancyId}';

  // --- Media (mục 10.2) ---
  static const mediaUploadIntents = '/v1/media/upload-intents';
  static const mediaComplete = '/v1/media/{assetId}/complete';
  static const mediaAsset = '/v1/media/{assetId}';

  // --- Ký ức (mục 11.3, 11.5) ---
  static const memories = '/v1/memories';
  static const memory = '/v1/memories/{memoryId}';
  static const familyFeed = '/v1/families/{familyId}/feed';

  /// PREG-07 đặt tên cho con (chỉ Papa & Mama).
  static const pregnancyNames = '/v1/pregnancies/{pregnancyId}/names';
  static const pregnancyName = '/v1/pregnancy-names/{nameId}';
  static const pregnancyNameLike = '/v1/pregnancy-names/{nameId}/like';
  static const pregnancyNameChoose = '/v1/pregnancy-names/{nameId}/choose';

  /// CARE-11 thống kê chăm con (mức gia đình).
  static const familyCareStats = '/v1/families/{familyId}/care-stats';

  /// Offline-first: thay đổi theo cursor (BF-20261022-002).
  static const familyChanges = '/v1/families/{familyId}/changes';
  static const familyTimeline = '/v1/families/{familyId}/timeline';
  static const familyMediaGrid = '/v1/families/{familyId}/media-grid';

  // --- Thùng rác ký ức (MEM-17) ---
  static const familyTrash = '/v1/families/{familyId}/trash';
  static const memoryRestore = '/v1/memories/{memoryId}/restore';
  static const memoryPurge = '/v1/memories/{memoryId}/purge';
  static const meDrafts = '/v1/me/drafts';
  static const memoryPublish = '/v1/memories/{memoryId}/publish';

  // --- Tìm kiếm (MEM-15/16), báo cáo & chặn (RPT-01/02) ---
  static const familySearch = '/v1/families/{familyId}/search';
  static const familyOnThisDay = '/v1/families/{familyId}/on-this-day';
  static const reports = '/v1/reports';
  static const blocks = '/v1/blocks';
  static const block = '/v1/blocks/{userId}';
  static const meBlocks = '/v1/me/blocks';

  // --- AUTH-04 ảnh đại diện tài khoản ---
  static const meAvatarUploadIntents = '/v1/me/avatar/upload-intents';
  static const meAvatarComplete = '/v1/me/avatar/{assetId}/complete';

  // --- MEM-25 hôm nay của bé ---
  static const childTodayStory = '/v1/children/{childId}/today-story';

  // --- MEM-20/21 ảnh tháng ---
  static const childMonthlyPhotos = '/v1/children/{childId}/monthly-photos';
  static const childMonthlyPhoto =
      '/v1/children/{childId}/monthly-photos/{monthIndex}';

  // --- REC-02 & HOME-01 ---
  static const weeklyRecapLatest =
      '/v1/families/{familyId}/recaps/weekly/latest';
  static const homeWeekStats = '/v1/families/{familyId}/home/week-stats';

  // --- Bình luận & cảm xúc (MEM-07/10, mục 7.12) ---
  static const memoryComments = '/v1/memories/{memoryId}/comments';
  static const comment = '/v1/comments/{commentId}';
  static const memoryReaction = '/v1/memories/{memoryId}/reaction';

  // --- Thông báo (NOTI-01, mục 13) ---
  static const notifications = '/v1/notifications';
  static const notificationsUnreadCount = '/v1/notifications/unread-count';
  static const notificationsRead = '/v1/notifications/read';

  // --- Nhiệm vụ hằng ngày (CARE-01…06, mục 11.6) ---
  static const missionBoard = '/v1/families/{familyId}/missions/board';
  static const missions = '/v1/missions';
  static const missionTemplates = '/v1/missions/templates';
  static const mission = '/v1/missions/{missionId}';
  static const missionAction = '/v1/missions/{missionId}/{action}';
  static const missionSwapOptions = '/v1/missions/{missionId}/swap-options';
  static const missionHistory = '/v1/families/{familyId}/missions';
  static const heartsMe = '/v1/families/{familyId}/hearts/me';
  static const familyTree = '/v1/families/{familyId}/family-tree';
  static const familyBadges = '/v1/families/{familyId}/badges';

  // --- Papa & Mama (US-01…04, mục 7.16) ---
  static const coupleCheckins = '/v1/families/{familyId}/us/checkins';
  static const coupleCheckinsToday =
      '/v1/families/{familyId}/us/checkins/today';
  static const coupleRequests = '/v1/families/{familyId}/us/requests';
  static const coupleAppreciations = '/v1/families/{familyId}/us/appreciations';
  static const coupleAppreciationShareRequest =
      '/v1/families/{familyId}/us/appreciations/{appreciationId}/share-request';
  static const coupleAppreciationReact =
      '/v1/families/{familyId}/us/appreciations/{appreciationId}/react';
  static const coupleJournal = '/v1/families/{familyId}/us/journal';
  static const coupleJournalShare =
      '/v1/families/{familyId}/us/journal/{entryId}/share';
  static const coupleRequestAction =
      '/v1/families/{familyId}/us/requests/{requestId}/{action}';

  // --- Tài khoản: xác thực lại, xoá, xuất dữ liệu (mục 7.25, SET-08/09) ---
  static const authReauthOtp = '/v1/auth/reauth/otp';
  static const authReauthVerify = '/v1/auth/reauth/verify';
  static const meDeletionPreview = '/v1/me/deletion-preview';
  static const meDeletion = '/v1/me/deletion';
  static const meDeletionCancel = '/v1/me/deletion/cancel';
  static const exports = '/v1/exports';
  static const export = '/v1/exports/{exportId}';

  // --- Lịch & sự kiện (CARE-07, CAL-02) ---
  static const familyCalendar = '/v1/families/{familyId}/calendar';
  static const events = '/v1/events';
  static const event = '/v1/events/{eventId}';

  // --- Bảo mật & cài đặt gia đình (SET-07, ONB-08/FAM-07) ---
  static const meSessions = '/v1/me/sessions';
  static const meSession = '/v1/me/sessions/{sessionId}';
  static const meSessionsRevokeOthers = '/v1/me/sessions/revoke-others';
  static const family = '/v1/families/{familyId}';
  static const familySettings = '/v1/families/{familyId}/settings';

  // --- Thai kỳ & hồ sơ bé (PREG-01…06, CHD-01/03/05) ---
  static const pregnancyJourney = '/v1/pregnancies/{pregnancyId}/journey';
  static const pregnancyPrepItems = '/v1/pregnancies/{pregnancyId}/prep-items';
  static const prepItem = '/v1/prep-items/{itemId}';
  static const pregnancyBirth = '/v1/pregnancies/{pregnancyId}/birth';
  static const pregnancyArchive = '/v1/pregnancies/{pregnancyId}/archive';
  static const familyChildrenOrder = '/v1/families/{familyId}/children/order';
  static const childArchive = '/v1/children/{childId}/archive';
  static const childRestore = '/v1/children/{childId}/restore';
  static const childDelete = '/v1/children/{childId}';
  static const childAvatar = '/v1/children/{childId}/avatar';
  static const childCover = '/v1/children/{childId}/cover';
  static const childProfileStats = '/v1/children/{childId}/profile-stats';

  // --- Album, yêu thích, góc nhìn, gợi ý, cột mốc, thư (MEM-03/11/12/14/22/24) ---
  static const familyAlbums = '/v1/families/{familyId}/albums';
  static const album = '/v1/albums/{albumId}';
  static const albumMemories = '/v1/albums/{albumId}/memories';
  static const albumMemory = '/v1/albums/{albumId}/memories/{memoryId}';
  static const memoryFavorite = '/v1/memories/{memoryId}/favorite';
  static const familyFavorites = '/v1/families/{familyId}/favorites';
  static const memoryDownloadUrls = '/v1/memories/{memoryId}/download-urls';
  static const memoryPerspective = '/v1/memories/{memoryId}/perspective';
  static const memoryPerspectives = '/v1/memories/{memoryId}/perspectives';
  static const familyMemoryPrompts = '/v1/families/{familyId}/memory-prompts';
  static const memoryPromptDismiss = '/v1/memory-prompts/{code}/dismiss';
  static const milestoneTemplates = '/v1/milestone-templates';
  static const childLetters = '/v1/children/{childId}/letters';

  // --- Nhiệm vụ: lưu khoảnh khắc, lặp lại, cài đặt (CARE-06/12) ---
  static const missionMoment = '/v1/missions/{missionId}/moment';
  static const familyMissionSeries = '/v1/families/{familyId}/mission-series';
  static const missionSeriesPause = '/v1/mission-series/{seriesId}/pause';
  static const missionSeries = '/v1/mission-series/{seriesId}';
  static const familyMissionSettings =
      '/v1/families/{familyId}/mission-settings';
  static const familyMissionPreferences =
      '/v1/families/{familyId}/mission-preferences';

  // --- Family Circle (FAM-03…06, MEM-19) & Papa & Mama settings (US-15) ---
  static const familyCircleInvites = '/v1/families/{familyId}/invites/circle';
  static const inviteAction = '/v1/invites/{inviteId}/{action}';
  static const familyCircle = '/v1/families/{familyId}/circle';
  static const circleMember = '/v1/circle-members/{memberId}';
  static const circleMemberAction = '/v1/circle-members/{memberId}/{action}';
  static const familyPendingReview =
      '/v1/families/{familyId}/memories/pending-review';
  static const memoryReviewAction = '/v1/memories/{memoryId}/{action}';
  static const meUsSettings = '/v1/me/us-settings';

  // --- App của người thân (CIR-WAIT, CIR-01…06, CIR-05) ---
  static const meCircles = '/v1/me/circles';

  // --- Gói dịch vụ (SUB-01/03/04/06/07) ---
  static const billingPlans = '/v1/billing/plans';

  // --- Xoá gia đình & quyền riêng tư (§7.23, §7.25) ---
  static const familyDeletion = '/v1/families/{familyId}/deletion';
  static const familyDeletionAction =
      '/v1/families/{familyId}/deletion/{action}';
  static const familyPrivacyOverview =
      '/v1/families/{familyId}/privacy-overview';

  // --- SET-06 hiển thị ---
  static const meSettings = '/v1/me/settings';

  // --- Cài đặt thông báo (SET-03) & AI (SET-05) ---
  static const meNotificationSettings = '/v1/me/notification-settings';
  static const meAiSettings = '/v1/me/ai-settings';
  static const familyBilling = '/v1/families/{familyId}/billing';
  static const familyPurchaseIntents =
      '/v1/families/{familyId}/purchase-intents';
  static const familyPurchaseVerify =
      '/v1/families/{familyId}/purchases/verify';
  static const familyCircleLeave = '/v1/families/{familyId}/circle/leave';
  static const coupleAppreciationShareRespond =
      '/v1/families/{familyId}/us/appreciations/{appreciationId}/share-respond';
}
