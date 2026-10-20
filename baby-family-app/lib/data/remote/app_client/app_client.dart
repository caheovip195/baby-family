import 'package:baby_family/data/remote/request_options.dart';
import 'package:baby_family/utils/constants/server.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'base_response.dart';

part 'app_client.g.dart';

/// Khai báo Retrofit — CHỈ khai báo, không xử lý logic (Skill 6).
/// Endpoint lấy từ `Api` (utils/constants/server.dart).
@RestApi()
sealed class AppClient {
  factory AppClient(Dio dio, {String? baseUrl}) = _AppClient;

  // ========================================================================
  // AUTH & ME
  // ========================================================================

  @POST(Api.authRefresh)
  @Extra({
    RequestOptionsExtra.deviceReq: true,
    RequestOptionsExtra.authRefresh: true,
  })
  Future<AuthCertificateRespond> refreshToken(
    @Body() Map<String, dynamic> body,
  );

  @POST(Api.authLogout)
  @Extra({
    RequestOptionsExtra.requiresAuth: true,
    RequestOptionsExtra.deviceReq: true,
  })
  Future<void> logout(@Body() Map<String, dynamic> body);

  @GET(Api.me)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<UserRespond> getMe();

  /// Cập nhật hồ sơ: `displayName`, `avatarAssetId`, `locale`, `timezone`.
  @PATCH(Api.me)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<UserRespond> updateMe(@Body() Map<String, dynamic> body);

  @POST(Api.meDevices)
  @Extra({
    RequestOptionsExtra.requiresAuth: true,
    RequestOptionsExtra.deviceReq: true,
  })
  Future<void> registerDevice(@Body() Map<String, dynamic> body);

  /// AUTH-02: `{phone, channel}` → 202 `{expiresIn, resendIn, channelUsed}`.
  @POST(Api.authPhoneOtp)
  @Extra({RequestOptionsExtra.deviceReq: true})
  Future<OtpDispatchRespond> requestPhoneOtp(@Body() Map<String, dynamic> body);

  /// AUTH-03: `{phone, code, device}` → cặp token.
  @POST(Api.authPhoneVerify)
  @Extra({RequestOptionsExtra.deviceReq: true})
  Future<AuthCertificateRespond> verifyPhoneOtp(
    @Body() Map<String, dynamic> body,
  );

  /// Hồ sơ + gia đình + tiến độ onboarding (SPL-01).
  @GET(Api.me)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MeProfileRespond> getMeProfile();

  /// AUTH-04: `{consents: [{document, version, granted}], platform}`.
  @POST(Api.meConsents)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> recordConsents(@Body() Map<String, dynamic> body);

  /// ONB-03: `{role: PARENT_FATHER|PARENT_MOTHER|CIRCLE}`.
  @PUT(Api.meOnboardingRole)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MeProfileRespond> setOnboardingRole(@Body() Map<String, dynamic> body);

  // ========================================================================
  // FAMILY & INVITE
  // ========================================================================

  /// ONB-06: `{name, parent: {kind?, callName?}}` → bootstrap.
  @POST(Api.families)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<FamilyBootstrapRespond> createFamily(
    @Body() Map<String, dynamic> body,
  );

  @POST(Api.familyCancel)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> cancelFamily(@Path('familyId') String familyId);

  @GET(Api.familyBootstrap)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<FamilyBootstrapRespond> getFamilyBootstrap(
    @Path('familyId') String familyId,
  );

  /// ONB-07: `{kind?, message?, requireFinalApproval?}` → mã + link (một lần).
  @POST(Api.familyPartnerInvite)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<PartnerInviteIssuedRespond> createPartnerInvite(
    @Path('familyId') String familyId,
    @Body() Map<String, dynamic> body,
  );

  @GET(Api.familyPartnerInvite)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<PartnerInviteStatusRespond> getPartnerInvite(
    @Path('familyId') String familyId,
  );

  /// INV-01/05: `{code}` hoặc `{token}` — mở được trước khi đăng nhập.
  @POST(Api.invitesResolve)
  Future<InviteResolutionRespond> resolveInvite(
    @Body() Map<String, dynamic> body,
  );

  @POST(Api.invitesAccept)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<InviteDecisionRespond> acceptInvite(@Body() Map<String, dynamic> body);

  @POST(Api.invitesDecline)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<InviteDecisionRespond> declineInvite(
    @Body() Map<String, dynamic> body,
  );

  @POST(Api.inviteApprove)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<InviteDecisionRespond> approveInvite(
    @Path('inviteId') String inviteId,
  );

  @POST(Api.inviteReject)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<InviteDecisionRespond> rejectInvite(@Path('inviteId') String inviteId);

  // ========================================================================
  // CHILD & PREGNANCY (ONB-04/05, CHD-*, PREG-*)
  // ========================================================================

  @POST(Api.familyChildren)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<ChildRecordRespond> createChild(
    @Path('familyId') String familyId,
    @Body() Map<String, dynamic> body,
  );

  @PATCH(Api.familyChild)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<ChildRecordRespond> updateChild(
    @Path('familyId') String familyId,
    @Path('childId') String childId,
    @Body() Map<String, dynamic> body,
  );

  @POST(Api.familyPregnancies)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<PregnancyRecordRespond> createPregnancy(
    @Path('familyId') String familyId,
    @Body() Map<String, dynamic> body,
  );

  @PATCH(Api.familyPregnancy)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<PregnancyRecordRespond> updatePregnancy(
    @Path('familyId') String familyId,
    @Path('pregnancyId') String pregnancyId,
    @Body() Map<String, dynamic> body,
  );

  // ========================================================================
  // MEDIA & MEMORY (MEM-04/05/06, HOME-01)
  // ========================================================================

  /// `{familyId, kind, purpose, mime, size, sha256, width?, height?}`.
  @POST(Api.mediaUploadIntents)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<UploadIntentRespond> createUploadIntent(
    @Header('Idempotency-Key') String idempotencyKey,
    @Body() Map<String, dynamic> body,
  );

  @POST(Api.mediaComplete)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<UploadStatusRespond> completeUpload(
    @Path('assetId') String assetId,
    @Body() Map<String, dynamic> body,
  );

  /// Mục 11.5.
  @POST(Api.memories)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MemoryRecordRespond> createMemory(
    @Header('Idempotency-Key') String idempotencyKey,
    @Body() Map<String, dynamic> body,
  );

  @GET(Api.memory)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MemoryRecordRespond> getMemory(@Path('memoryId') String memoryId);

  @GET(Api.familyFeed)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MemoryFeedRespond> getFeed(
    @Path('familyId') String familyId, {
    @Query('childId') String? childId,
    @Query('pregnancyId') String? pregnancyId,
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
  });

  /// MEM-09: sửa ký ức, `If-Match` = `version` hiện tại (412 khi đã cũ).
  @PATCH(Api.memory)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MemoryRecordRespond> updateMemory(
    @Path('memoryId') String memoryId,
    @Header('If-Match') String version,
    @Body() Map<String, dynamic> body,
  );

  /// MEM-01: sắp theo ngày xảy ra; [filter] = ALL|MILESTONE|MEDIA|DIARY|LETTER|PREGNANCY.
  @GET(Api.familyTimeline)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<TimelineRespond> getTimeline(
    @Path('familyId') String familyId, {
    @Query('childId') String? childId,
    @Query('pregnancyId') String? pregnancyId,
    @Query('filter') String? filter,
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
  });

  /// MEM-02: mỗi ảnh/video READY một ô, mới nhất trước.
  @GET(Api.familyMediaGrid)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MediaGridRespond> getMediaGrid(
    @Path('familyId') String familyId, {
    @Query('childId') String? childId,
    @Query('kind') String? kind,
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
  });

  @GET(Api.memoryComments)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<CommentListRespond> getComments(@Path('memoryId') String memoryId);

  @POST(Api.memoryComments)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<CommentRecordRespond> addComment(
    @Path('memoryId') String memoryId,
    @Body() Map<String, dynamic> body,
  );

  /// Sửa bình luận của mình trong 15 phút.
  @PATCH(Api.comment)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<CommentRecordRespond> editComment(
    @Path('commentId') String commentId,
    @Body() Map<String, dynamic> body,
  );

  /// 204; trả lời của bình luận bị xoá theo.
  @DELETE(Api.comment)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> deleteComment(@Path('commentId') String commentId);

  @PUT(Api.memoryReaction)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<ReactionStateRespond> setReaction(
    @Path('memoryId') String memoryId,
    @Body() Map<String, dynamic> body,
  );

  @DELETE(Api.memoryReaction)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<ReactionStateRespond> clearReaction(@Path('memoryId') String memoryId);

  /// NOTI-01: hộp thông báo của chính tôi (`tab` = FAMILY|US), mới nhất trước.
  @GET(Api.notifications)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<NotificationPageRespond> getNotifications({
    @Query('tab') String? tab,
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
  });

  @GET(Api.notificationsUnreadCount)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<NotificationCountRespond> getUnreadNotificationCount();

  /// `{ids: [...]}` hoặc `{all: true}`.
  @POST(Api.notificationsRead)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> markNotificationsRead(@Body() Map<String, dynamic> body);

  /// CARE-01: bảng nhiệm vụ của [tab] (`MINE|PARTNER|TOGETHER`); chưa có thì bày.
  @GET(Api.missionBoard)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MissionBoardRespond> getMissionBoard(
    @Path('familyId') String familyId, {
    @Query('date') String? date,
    @Query('tab') String? tab,
    @Query('childId') String? childId,
  });

  /// CARE-01/09: Hearts của CHÍNH tôi (BR-018).
  @GET(Api.heartsMe)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<HeartsMeRespond> getMyHearts(
    @Path('familyId') String familyId, {
    @Query('limit') int? limit,
  });

  /// CARE-09: cấp + % (không có số Hearts).
  @GET(Api.familyTree)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<FamilyTreeRespond> getFamilyTree(@Path('familyId') String familyId);

  /// CARE-10.
  @GET(Api.familyBadges)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<BadgeListRespond> getBadges(@Path('familyId') String familyId);

  /// CARE-08: lịch sử; `owner=PARTNER` chỉ việc đã xong, không Hearts.
  @GET(Api.missionHistory)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MissionHistoryRespond> getMissionHistory(
    @Path('familyId') String familyId, {
    @Query('from') String? from,
    @Query('to') String? to,
    @Query('owner') String? owner,
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
  });

  /// CARE-04.
  @GET(Api.missionTemplates)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MissionTemplateListRespond> getMissionTemplates({
    @Query('familyId') String? familyId,
    @Query('childId') String? childId,
  });

  /// CARE-03 (`owner: ME|TOGETHER`).
  @POST(Api.missions)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MissionResultRespond> createMission(
    @Header('Idempotency-Key') String idempotencyKey,
    @Body() Map<String, dynamic> body,
  );

  /// CARE-02 (nhiệm vụ của bạn đời: dạng rút gọn).
  @GET(Api.mission)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MissionRecordRespond> getMission(@Path('missionId') String missionId);

  /// CARE-06 hoàn thành (giữ nguyên `Idempotency-Key` khi thử lại).
  @POST(Api.missionAction)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MissionResultRespond> completeMission(
    @Path('missionId') String missionId,
    @Path('action') String action,
    @Header('Idempotency-Key') String idempotencyKey,
    @Body() Map<String, dynamic> body,
  );

  /// `undo` | `remove` → nhiệm vụ sau khi đổi; `swap` → `{removedId, mission}`.
  @POST(Api.missionAction)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MissionResultRespond> missionAction(
    @Path('missionId') String missionId,
    @Path('action') String action,
    @Body() Map<String, dynamic> body,
  );

  /// CARE-05.
  @GET(Api.missionSwapOptions)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MissionSwapOptionsRespond> getMissionSwapOptions(
    @Path('missionId') String missionId,
  );

  /// US-02: lưu check-in (chia sẻ theo `share.fields`).
  @POST(Api.coupleCheckins)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<CheckinRecordRespond> createCheckin(
    @Path('familyId') String familyId,
    @Body() Map<String, dynamic> body,
  );

  /// US-01: check-in còn hiệu lực của tôi và của bạn đời (đã lọc phần chia sẻ).
  @GET(Api.coupleCheckinsToday)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<CheckinTodayRespond> getCheckinsToday(
    @Path('familyId') String familyId,
  );

  /// US-05: gửi lời cảm ơn (💛 nhanh: `quick: true` + `linkedType/linkedId`).
  @POST(Api.coupleAppreciations)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<AppreciationRecordRespond> createAppreciation(
    @Path('familyId') String familyId,
    @Body() Map<String, dynamic> body,
  );

  /// US-06: bức tường cảm ơn hai chiều, mới nhất trước.
  @GET(Api.coupleAppreciations)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<AppreciationWallRespond> getAppreciations(
    @Path('familyId') String familyId, {
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
    @Query('month') String? month,
  });

  @POST(Api.coupleAppreciationReact)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<AppreciationRecordRespond> reactAppreciation(
    @Path('familyId') String familyId,
    @Path('appreciationId') String appreciationId,
    @Body() Map<String, dynamic> body,
  );

  /// US-07: nhật ký riêng của chính tôi.
  @GET(Api.coupleJournal)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<JournalListRespond> getJournal(
    @Path('familyId') String familyId, {
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
  });

  @POST(Api.coupleJournal)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<JournalEntryRespond> createJournalEntry(
    @Path('familyId') String familyId,
    @Body() Map<String, dynamic> body,
  );

  /// “Chia sẻ đoạn này với bạn đời” — `excerpt` nằm nguyên văn trong bài.
  @POST(Api.coupleJournalShare)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> shareJournalExcerpt(
    @Path('familyId') String familyId,
    @Path('entryId') String entryId,
    @Body() Map<String, dynamic> body,
  );

  /// US-03: gửi lời nhờ (giữ nguyên `Idempotency-Key` khi thử lại).
  @POST(Api.coupleRequests)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<RequestCreatedRespond> createRequest(
    @Path('familyId') String familyId,
    @Header('Idempotency-Key') String idempotencyKey,
    @Body() Map<String, dynamic> body,
  );

  @GET(Api.coupleRequests)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<RequestListRespond> getRequests(
    @Path('familyId') String familyId, {
    @Query('box') String? box,
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
  });

  /// US-04: `seen|accept|decline|acknowledge|done|remind-me|cancel`.
  @POST(Api.coupleRequestAction)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<RequestRecordRespond> requestAction(
    @Path('familyId') String familyId,
    @Path('requestId') String requestId,
    @Path('action') String action,
    @Body() Map<String, dynamic> body,
  );

  /// MEM-07 “Xoá” → thùng rác 30 ngày (204).
  @DELETE(Api.memory)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> trashMemory(@Path('memoryId') String memoryId);

  /// MEM-17: ký ức trong thùng rác, mới xoá trước.
  @GET(Api.familyTrash)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MemoryFeedRespond> getTrash(
    @Path('familyId') String familyId, {
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
  });

  @POST(Api.memoryRestore)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MemoryRecordRespond> restoreMemory(@Path('memoryId') String memoryId);

  /// MEM-15: tìm ký ức (bỏ dấu, theo tiền tố từ), cùng quyền xem với feed.
  @GET(Api.familySearch)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MemoryFeedRespond> searchMemories(
    @Path('familyId') String familyId,
    @Query('q') String query, {
    @Query('childId') String? childId,
    @Query('limit') int? limit,
  });

  /// MEM-16: ngày này các năm trước.
  @GET(Api.familyOnThisDay)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<OnThisDayRespond> getOnThisDay(
    @Path('familyId') String familyId, {
    @Query('date') String? date,
  });

  /// RPT-01.
  @POST(Api.reports)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<ReportRespond> createReport(@Body() Map<String, dynamic> body);

  /// RPT-02.
  @POST(Api.blocks)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> blockUser(@Body() Map<String, dynamic> body);

  @DELETE(Api.block)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> unblockUser(
    @Path('userId') String userId,
    @Query('familyId') String familyId,
  );

  @GET(Api.meBlocks)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<BlockedUserListRespond> getBlocks(@Query('familyId') String familyId);

  /// AUTH-04: xin URL tải ảnh đại diện (`{purpose: AVATAR, mime, size, sha256}`).
  @POST(Api.meAvatarUploadIntents)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<UploadIntentRespond> createAvatarUploadIntent(
    @Header('Idempotency-Key') String idempotencyKey,
    @Body() Map<String, dynamic> body,
  );

  @POST(Api.meAvatarComplete)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<UploadStatusRespond> completeAvatarUpload(
    @Path('assetId') String assetId,
    @Body() Map<String, dynamic> body,
  );

  /// REC-02: recap tuần mới nhất (404 khi chưa có).
  @GET(Api.weeklyRecapLatest)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<WeeklyRecapRespond> getLatestWeeklyRecap(
    @Path('familyId') String familyId,
  );

  /// HOME-01 “Tuần này”.
  @GET(Api.homeWeekStats)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<WeekStatsRespond> getWeekStats(@Path('familyId') String familyId);

  /// MEM-18: nháp đã lưu trên tài khoản (chỉ của tôi).
  @GET(Api.meDrafts)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MemoryFeedRespond> getDrafts(@Query('familyId') String familyId);

  /// MEM-17 “Xoá vĩnh viễn” (204).
  @DELETE(Api.memoryPurge)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> purgeMemory(@Path('memoryId') String memoryId);

  /// Mục 7.25: gửi OTP xác thực lại tới số điện thoại CỦA CHÍNH người dùng.
  @POST(Api.authReauthOtp)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<OtpDispatchRespond> requestReauthOtp();

  /// `{code}` → `{reauthToken, expiresAt}` gắn với phiên hiện tại.
  @POST(Api.authReauthVerify)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<ReauthTokenRespond> verifyReauthOtp(@Body() Map<String, dynamic> body);

  /// SET-09: tác động và lựa chọn cho gia đình khi xoá tài khoản.
  @GET(Api.meDeletionPreview)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<DeletionPreviewRespond> getDeletionPreview();

  /// SET-09c: `{familyChoice, sharedContentChoice, reauthToken}` → 202.
  @POST(Api.meDeletion)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> requestAccountDeletion(@Body() Map<String, dynamic> body);

  /// SET-08: `{scope: PERSONAL|FAMILY, familyId?}` → job xuất.
  @POST(Api.exports)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<DataExportRespond> createExport(@Body() Map<String, dynamic> body);

  @GET(Api.export)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<DataExportRespond> getExport(@Path('exportId') String exportId);

  /// CARE-07: sự kiện, nhiệm vụ, ngày đặc biệt trong [from, to] (≤ 62 ngày).
  @GET(Api.familyCalendar)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<CalendarRespond> getCalendar(
    @Path('familyId') String familyId, {
    @Query('from') required String from,
    @Query('to') required String to,
  });

  /// CAL-02 (chỉ Papa & Mama).
  @POST(Api.events)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<CalendarEventRespond> createEvent(@Body() Map<String, dynamic> body);

  /// SET-07: phiên đăng nhập của chính tôi.
  @GET(Api.meSessions)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<SessionListRespond> getSessions();

  /// SET-07 “Đăng xuất” một thiết bị (204).
  @DELETE(Api.meSession)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> revokeSession(@Path('sessionId') String sessionId);

  /// SET-07 “Đăng xuất mọi thiết bị khác”.
  @POST(Api.meSessionsRevokeOthers)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> revokeOtherSessions();

  /// FAM-07: tên, ngôn ngữ nội dung, ảnh bìa (URL ký).
  @GET(Api.family)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<FamilyRecordRespond> getFamily(@Path('familyId') String familyId);

  /// FAM-07: tên / ngôn ngữ nội dung / ảnh bìa (`coverAssetId`).
  @PATCH(Api.family)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> updateFamily(
    @Path('familyId') String familyId,
    @Body() Map<String, dynamic> body,
  );

  /// ONB-08 / FAM-07: cài đặt quyền riêng tư mặc định của gia đình.
  @GET(Api.familySettings)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<FamilySettingsRespond> getFamilySettings(
    @Path('familyId') String familyId,
  );

  /// Chỉ Papa & Mama; gửi đúng các khoá đổi (server gộp từng khoá).
  @PATCH(Api.familySettings)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<FamilySettingsRespond> updateFamilySettings(
    @Path('familyId') String familyId,
    @Body() Map<String, dynamic> body,
  );

  /// PREG-01: tuần thai hiện tại + nội dung tuần (theo ngôn ngữ).
  @GET(Api.pregnancyJourney)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<JourneyRespond> getPregnancyJourney(
    @Path('pregnancyId') String pregnancyId, {
    @Query('week') int? week,
  });

  /// PREG-04: lần đầu server tự thêm danh sách mặc định.
  @GET(Api.pregnancyPrepItems)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<PrepGroupsRespond> getPrepItems(
    @Path('pregnancyId') String pregnancyId,
  );

  @POST(Api.pregnancyPrepItems)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<PrepItemRespond> createPrepItem(
    @Path('pregnancyId') String pregnancyId,
    @Body() Map<String, dynamic> body,
  );

  @PATCH(Api.prepItem)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<PrepItemRespond> updatePrepItem(
    @Path('itemId') String itemId,
    @Body() Map<String, dynamic> body,
  );

  /// PREG-05: thai kỳ → bé đã chào đời (Idempotency-Key giữ nguyên khi thử lại).
  @POST(Api.pregnancyBirth)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<BirthResultRespond> convertPregnancy(
    @Path('pregnancyId') String pregnancyId,
    @Header('Idempotency-Key') String idempotencyKey,
    @Body() Map<String, dynamic> body,
  );

  /// PREG-06: `{reason: ARCHIVED|ENDED_PRIVATE}`.
  @POST(Api.pregnancyArchive)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> archivePregnancy(
    @Path('pregnancyId') String pregnancyId,
    @Body() Map<String, dynamic> body,
  );

  /// CHD-03.
  @PATCH(Api.familyChildrenOrder)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> reorderChildren(
    @Path('familyId') String familyId,
    @Body() Map<String, dynamic> body,
  );

  /// CHD-05.
  @POST(Api.childArchive)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> archiveChild(@Path('childId') String childId);

  @POST(Api.childRestore)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> restoreChild(@Path('childId') String childId);

  /// `{confirmName}` — phải trùng tên bé; bé phải lưu trữ đủ 7 ngày.
  @DELETE(Api.childDelete)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> deleteChild(
    @Path('childId') String childId,
    @Body() Map<String, dynamic> body,
  );

  /// Ảnh đại diện / ảnh bìa bé: `{assetId|null}`.
  @PUT(Api.childAvatar)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> setChildAvatar(
    @Path('childId') String childId,
    @Body() Map<String, dynamic> body,
  );

  @PUT(Api.childCover)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> setChildCover(
    @Path('childId') String childId,
    @Body() Map<String, dynamic> body,
  );

  /// CHD-01.
  @GET(Api.childProfileStats)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<ChildStatsRespond> getChildStats(@Path('childId') String childId);

  /// MEM-03.
  @GET(Api.familyAlbums)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<AlbumListRespond> getAlbums(@Path('familyId') String familyId);

  @POST(Api.familyAlbums)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<AlbumRecordRespond> createAlbum(
    @Path('familyId') String familyId,
    @Body() Map<String, dynamic> body,
  );

  @PATCH(Api.album)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> updateAlbum(
    @Path('albumId') String albumId,
    @Body() Map<String, dynamic> body,
  );

  @DELETE(Api.album)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> deleteAlbum(@Path('albumId') String albumId);

  /// Ký ức trong album (chỉ những ký ức người gọi xem được).
  @GET(Api.albumMemories)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MemoryFeedRespond> getAlbumMemories(
    @Path('albumId') String albumId, {
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
  });

  @POST(Api.albumMemories)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> addAlbumMemories(
    @Path('albumId') String albumId,
    @Body() Map<String, dynamic> body,
  );

  /// MEM-22: yêu thích là riêng của từng người.
  @PUT(Api.memoryFavorite)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> addFavorite(@Path('memoryId') String memoryId);

  @DELETE(Api.memoryFavorite)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> removeFavorite(@Path('memoryId') String memoryId);

  @GET(Api.familyFavorites)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MemoryFeedRespond> getFavorites(
    @Path('familyId') String familyId, {
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
  });

  /// MEM-08 “Tải về”: link bản gốc ngắn hạn.
  @POST(Api.memoryDownloadUrls)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<DownloadUrlListRespond> getDownloadUrls(
    @Path('memoryId') String memoryId,
  );

  /// MEM-24: góc nhìn của Parent còn lại.
  @GET(Api.memoryPerspectives)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<PerspectiveListRespond> getPerspectives(
    @Path('memoryId') String memoryId,
  );

  @PUT(Api.memoryPerspective)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<PerspectiveRecordRespond> putPerspective(
    @Path('memoryId') String memoryId,
    @Body() Map<String, dynamic> body,
  );

  /// Gợi ý ghi lại hôm nay.
  @GET(Api.familyMemoryPrompts)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MemoryPromptListRespond> getMemoryPrompts(
    @Path('familyId') String familyId, {
    @Query('childId') String? childId,
  });

  @POST(Api.memoryPromptDismiss)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> dismissMemoryPrompt(
    @Path('code') String code,
    @Body() Map<String, dynamic> body,
  );

  /// MEM-11: catalog cột mốc kèm trạng thái đã ghi của bé.
  @GET(Api.milestoneTemplates)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MilestoneCatalogRespond> getMilestoneTemplates({
    @Query('childId') String? childId,
    @Query('pregnancyId') String? pregnancyId,
  });

  /// MEM-14: thư gửi con (phong bì khi còn niêm phong).
  @GET(Api.childLetters)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<LetterListRespond> getChildLetters(@Path('childId') String childId);

  /// CARE-06: nhiệm vụ đã xong → ký ức của gia đình (Idempotency-Key).
  @POST(Api.missionMoment)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MemoryRecordRespond> saveMissionMoment(
    @Path('missionId') String missionId,
    @Header('Idempotency-Key') String idempotencyKey,
    @Body() Map<String, dynamic> body,
  );

  /// Nhiệm vụ lặp lại tự thêm (mục 7.13.6).
  @POST(Api.familyMissionSeries)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MissionSeriesRespond> createMissionSeries(
    @Path('familyId') String familyId,
    @Body() Map<String, dynamic> body,
  );

  /// CARE-03: chuỗi của tôi + Cùng nhau.
  @GET(Api.familyMissionSeries)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MissionSeriesListRespond> getMissionSeries(
    @Path('familyId') String familyId,
  );

  /// Tạm dừng chuỗi `{from, to}` (YYYY-MM-DD).
  @POST(Api.missionSeriesPause)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> pauseMissionSeries(
    @Path('seriesId') String seriesId,
    @Body() Map<String, dynamic> body,
  );

  /// Kết thúc chuỗi (việc đã xong giữ lại).
  @DELETE(Api.missionSeries)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> endMissionSeries(@Path('seriesId') String seriesId);

  /// CARE-12.
  @GET(Api.familyMissionSettings)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MissionSettingsRespond> getMissionSettings(
    @Path('familyId') String familyId,
  );

  @PATCH(Api.familyMissionSettings)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MissionSettingsRespond> updateMissionSettings(
    @Path('familyId') String familyId,
    @Body() Map<String, dynamic> body,
  );

  /// Chỉ tuỳ chọn của chính tôi.
  @PATCH(Api.familyMissionPreferences)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MissionSettingsRespond> updateMissionPreferences(
    @Path('familyId') String familyId,
    @Body() Map<String, dynamic> body,
  );

  /// US-05 “Đề nghị đăng thành khoảnh khắc gia đình” — bạn đời duyệt.
  @POST(Api.coupleAppreciationShareRequest)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> requestAppreciationShare(
    @Path('familyId') String familyId,
    @Path('appreciationId') String appreciationId,
  );

  /// Bạn đời duyệt / không duyệt đăng lời cảm ơn thành khoảnh khắc gia đình.
  @POST(Api.coupleAppreciationShareRespond)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> respondAppreciationShare(
    @Path('familyId') String familyId,
    @Path('appreciationId') String appreciationId,
    @Body() Map<String, dynamic> body,
  );

  /// MEM-25: trình chiếu ảnh/video trong ngày của bé.
  @GET(Api.childTodayStory)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<TodayStoryRespond> getTodayStory(@Path('childId') String childId);

  /// MEM-20: ảnh tháng của bé (đúng quyền xem).
  @GET(Api.childMonthlyPhotos)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MonthlyPhotoListRespond> getMonthlyPhotos(
    @Path('childId') String childId,
  );

  /// MEM-21: đặt/thay ảnh tháng (`{memoryId, assetId}`).
  @PUT(Api.childMonthlyPhoto)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MonthlyPhotoRespond> setMonthlyPhoto(
    @Path('childId') String childId,
    @Path('monthIndex') int monthIndex,
    @Body() Map<String, dynamic> body,
  );

  /// Xoá gia đình: trạng thái.
  @GET(Api.familyDeletion)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<FamilyDeletionRespond> getFamilyDeletion(
    @Path('familyId') String familyId,
  );

  /// Yêu cầu xoá (`{reauthToken, reason?}`).
  @POST(Api.familyDeletion)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<FamilyDeletionRespond> requestFamilyDeletion(
    @Path('familyId') String familyId,
    @Body() Map<String, dynamic> body,
  );

  /// [action] = `confirm` (`{reauthToken}`) | `cancel`.
  @POST(Api.familyDeletionAction)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<FamilyDeletionRespond> familyDeletionAction(
    @Path('familyId') String familyId,
    @Path('action') String action,
    @Body() Map<String, dynamic> body,
  );

  /// SET-04 bảng điều khiển quyền riêng tư (chỉ Parent).
  @GET(Api.familyPrivacyOverview)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<PrivacyOverviewRespond> getPrivacyOverview(
    @Path('familyId') String familyId,
  );

  /// Đổi số điện thoại: OTP tới số MỚI (`{phone, reauthToken}`).
  @POST(Api.mePhoneOtp)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> requestPhoneChangeOtp(@Body() Map<String, dynamic> body);

  /// Xác nhận số mới (`{phone, code}`) → `{phone}` đã che.
  @POST(Api.mePhoneVerify)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> verifyPhoneChange(@Body() Map<String, dynamic> body);

  /// Hỗ trợ khách hàng: danh mục yêu cầu (catalog có version).
  @GET(Api.supportCategories)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<SupportCategoriesRespond> getSupportCategories();

  /// `{category, subject, body, familyId?}` → `{id, code, status, createdAt}`.
  @POST(Api.supportTickets)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<SupportTicketRespond> createSupportTicket(
    @Body() Map<String, dynamic> body,
  );

  /// Yêu cầu tôi đã gửi, mới nhất trước.
  @GET(Api.meSupportTickets)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<SupportTicketListRespond> getMySupportTickets(
    @Query('offset') int offset,
    @Query('limit') int limit,
  );

  /// SET-06: cài đặt hiển thị/riêng của tôi.
  @GET(Api.meSettings)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<DisplaySettingsRespond> getMySettings();

  @PATCH(Api.meSettings)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<DisplaySettingsRespond> updateMySettings(
    @Body() Map<String, dynamic> body,
  );

  /// SET-03: cài đặt thông báo của tôi.
  @GET(Api.meNotificationSettings)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<NotificationSettingsRespond> getNotificationSettings();

  @PATCH(Api.meNotificationSettings)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<NotificationSettingsRespond> updateNotificationSettings(
    @Body() Map<String, dynamic> body,
  );

  /// SET-05: cài đặt AI của tôi.
  @GET(Api.meAiSettings)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<AiSettingsRespond> getAiSettings();

  @PATCH(Api.meAiSettings)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<AiSettingsRespond> updateAiSettings(@Body() Map<String, dynamic> body);

  /// SUB-01/04: catalog gói đang hiệu lực (quota/feature theo version).
  @GET(Api.billingPlans)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<BillingCatalogRespond> getBillingPlans();

  /// SUB-03/06/07: quyền lợi + usage của gia đình (đọc được khi hết hạn).
  @GET(Api.familyBilling)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<FamilyBillingRespond> getFamilyBilling(
    @Path('familyId') String familyId,
  );

  /// CIR-WAIT/CIR-01/CIR-05: các gia đình tôi là người thân.
  @GET(Api.meCircles)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MyCircleListRespond> getMyCircles();

  /// SET-10: người thân tự rời gia đình.
  @POST(Api.familyCircleLeave)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> leaveCircle(@Path('familyId') String familyId);

  /// FAM-03: mời người thân (quan hệ, tên gọi, quyền theo từng bé).
  @POST(Api.familyCircleInvites)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<CircleInviteIssuedRespond> createCircleInvite(
    @Path('familyId') String familyId,
    @Body() Map<String, dynamic> body,
  );

  /// FAM-05: lời mời đang chờ / đã hết hạn.
  @GET(Api.familyCircleInvites)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<CircleInviteListRespond> getCircleInvites(
    @Path('familyId') String familyId,
  );

  /// `revoke` | `renew` (gia hạn → mã/link mới).
  @POST(Api.inviteAction)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<CircleInviteIssuedRespond> circleInviteAction(
    @Path('inviteId') String inviteId,
    @Path('action') String action,
  );

  /// FAM-01/04: người thân của gia đình (chỉ Papa & Mama).
  @GET(Api.familyCircle)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<CircleMemberListRespond> getCircle(@Path('familyId') String familyId);

  /// FAM-04: tên gọi, tải về, quyền (thay cả bộ).
  @PATCH(Api.circleMember)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> updateCircleMember(
    @Path('memberId') String memberId,
    @Body() Map<String, dynamic> body,
  );

  /// FAM-06 gỡ người thân.
  @DELETE(Api.circleMember)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> removeCircleMember(@Path('memberId') String memberId);

  /// `pause` | `resume`.
  @POST(Api.circleMemberAction)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> circleMemberAction(
    @Path('memberId') String memberId,
    @Path('action') String action,
  );

  /// MEM-19: ảnh người thân đăng đang chờ duyệt.
  @GET(Api.familyPendingReview)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<MemoryFeedRespond> getPendingReview(@Path('familyId') String familyId);

  /// `approve {childIds?}` | `reject {reason?}`.
  @POST(Api.memoryReviewAction)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<void> reviewMemory(
    @Path('memoryId') String memoryId,
    @Path('action') String action,
    @Body() Map<String, dynamic> body,
  );

  /// US-15: cài đặt Papa & Mama của chính tôi.
  @GET(Api.meUsSettings)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<UsSettingsRespond> getUsSettings();

  @PATCH(Api.meUsSettings)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<UsSettingsRespond> updateUsSettings(@Body() Map<String, dynamic> body);
}
