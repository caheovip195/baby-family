/// Gia hạn access token trước khi hết hạn (giây).
const kValueRenewAccessTokenBefore = 2 * 60;

/// Kích thước trang mặc định cho API có cursor.
const kValueDefaultPageSize = 30;

/// Thời gian chờ upload/download media lớn.
const kValueMediaTransferTimeoutMinutes = 10;

/// Nhãn gọi mặc định của Bố/Mẹ (tài liệu nghiệp vụ C-13) — giống nhau ở mọi
/// ngôn ngữ, không dịch; người dùng đổi được (Bố, Ba, Má...).
const kValueDefaultCallNameFather = 'Papa';
const kValueDefaultCallNameMother = 'Mama';

/// Explicit mock implementation requested for screen review; disable for production APIs.
const kValueDemoEnabled = bool.fromEnvironment(
  'BABY_FAMILY_MOCK',
  defaultValue: true,
);

/// Base URL API ghi đè (ví dụ backend local `http://localhost:3000/api`). Có giá
/// trị → app gọi API thật cho đăng nhập/onboarding (BF-20261015-012); rỗng → dùng
/// endpoint của flavor và dữ liệu mock.
const kValueApiUrlOverride = String.fromEnvironment('BABY_FAMILY_API_URL');

/// Đăng nhập, hồ sơ, vai trò, gia đình và lời mời đi qua server thật.
const kValueUseRemoteSession = kValueApiUrlOverride != '';

/// Khoá phụ trong bản ghi phiên trên máy (chế độ server): id gia đình và id
/// người dùng phía server — khác id của kho dữ liệu trên máy.
const kValueSessionKeyServerFamilyId = 'remoteFamilyId';
const kValueSessionKeyServerUserId = 'remoteUserId';

/// Id người dùng server của bạn đời (Parent còn lại, từ bootstrap) — để mời và
/// nhắc bạn đời trên lịch (BF-20261018-014).
const kValueSessionKeyServerPartnerUserId = 'remotePartnerUserId';

/// Feed ký ức hỏi lại server tối đa mỗi 10 giây (tránh gọi lặp khi nhiều
/// provider cùng đọc); URL ảnh ký sẵn được làm mới trước khi hết hạn 5 phút.
const kValueRemoteFeedRefreshInterval = Duration(seconds: 10);

/// SW-01: bé/thai kỳ đang có trong bootstrap của server (khoá trên hàng bé).
const kValueChildKeyServerSubject = 'serverSubject';

/// Thẻ chương tháng của server theo tháng tuổi (`{monthIndex: {coverUrl,
/// memoryCount, firstsCount}}`) trên hàng bé.
const kValueChildKeyServerChapters = 'serverChapters';

/// REC-02: số ký ức nổi bật / ảnh lớn của recap tuần từ server.
const kValueRecapHighlightMax = 6;
const kValueRecapHeroMax = 4;

/// MEM-15: server chỉ tìm khi có ít nhất chừng này ký tự.
const kValueSearchMinLength = 2;
const kValueSignedUrlRefreshMargin = Duration(minutes: 5);

/// Số ký ức lấy mỗi lần đồng bộ feed (giới hạn của server là 50).
const kValueRemoteFeedPageSize = 50;

/// Đồng bộ đủ mọi trang feed (theo `nextCursor`) và gỡ ký ức đã bị xoá/ẩn phía
/// server tối đa mỗi 2 phút; giữa hai lần chỉ hỏi trang đầu. Giới hạn số trang
/// một lần đồng bộ để không lặp vô hạn khi cursor lỗi (BF-20261017-001).
const kValueRemoteFeedFullSyncInterval = Duration(minutes: 2);
const kValueRemoteFeedMaxPages = 200;

/// Ký ức đang xử lý ảnh được hỏi lại (mỗi [kValueRemoteFeedRefreshInterval])
/// khi màn còn mở, tối đa 10 phút kể từ lúc thấy trạng thái PROCESSING.
const kValueRemoteProcessingPollWindow = Duration(minutes: 10);

/// Ảnh tải lên được thu nhỏ cạnh dài tối đa 2048 px, JPEG chất lượng 88
/// (tài liệu kỹ thuật 10.3: client nén, chuyển HEIC → JPEG).
const kValueUploadImageMaxSide = 2048.0;
const kValueUploadImageQuality = 88;

/// Phiên bản Điều khoản/Chính sách ghi nhận ở AUTH-04 (`POST /me/consents`).
const kValueLegalDocumentVersion = '2026-10';

/// ONB-WAIT hỏi server trạng thái bạn đời mỗi 30 giây (tài liệu kỹ thuật 23.1).
const kValuePartnerStatusPollInterval = Duration(seconds: 30);

/// AUTH-03 — OTP length and resend/expiry limits (technical spec 4.3).
/// Mã quốc gia mặc định ở AUTH-02 (tài liệu nghiệp vụ 9.1).
const kValueDefaultDialCode = '+84';

/// Số chấm tiến trình trên thanh trên các bước ONB-03 → ONB-05 (Pencil TopBar).
const kValueOnboardingStepCount = 5;

const kValueOtpLength = 6;
const kValueOtpResendSeconds = 60;
const kValueOtpExpirySeconds = 300;
const kValueOtpMaxAttempts = 5;

/// INV-05 — case-insensitive single-use invitation code.
const kValueInviteCodeLength = 8;

/// ONB-05a — supported pregnancy week range.
const kValuePregnancyMinWeek = 4;
const kValuePregnancyMaxWeek = 42;

/// MEM-25, mục 9.4: mỗi ảnh trong trình chiếu tự chuyển sau 5 giây.
const kValueStoryPhotoDuration = Duration(seconds: 5);

/// MEM-20, mục 9.4: 12 ảnh tháng trong mỗi năm.
const kValueMonthlyPhotoSlots = 12;

/// MEM-20: so sánh hai ảnh tháng cạnh nhau.
const kValueMonthlyCompareMax = 2;

/// PREG-02: so sánh tối đa bốn ảnh bụng bầu.
const kValueBumpCompareMax = 4;

/// PREG-02: so sánh mặc định ảnh bụng mới nhất với ảnh cách ~7 tuần.
const kValueBumpCompareWeeks = 7;

/// BR-023 / AC-038: maximum mission swaps per day (demo session).
const kValueMissionSwapLimit = 3;

/// BR-069: custom missions award 2 Hearts to their owner.
const kValueCustomMissionHearts = 2;

/// Bộ dữ liệu mẫu khi chạy mock: `--dart-define=BABY_FAMILY_DEMO=fresh|active|pregnant|circle|expired`
/// (mặc định `fresh` = chưa đăng nhập). `make mock-run` dùng `active`.
const kValueDemoSeed = String.fromEnvironment(
  'BABY_FAMILY_DEMO',
  defaultValue: 'fresh',
);

/// Người đang đăng nhập trong seed `active|pregnant|expired`:
/// `--dart-define=BABY_FAMILY_ACTOR=mama|papa` (mặc định Mama Lan). Dùng `papa`
/// để đối chiếu các frame Pencil vẽ theo góc nhìn Papa (CARE-01, FAM-01, US-04).
const kValueDemoActor = String.fromEnvironment(
  'BABY_FAMILY_ACTOR',
  defaultValue: 'mama',
);

/// “Hôm nay” của câu chuyện thiết kế (story v2: Haru 17 tháng 29 ngày, Bơ tuần 24 + 3).
/// Đồng hồ mock bắt đầu lúc [kValueDemoStartTime] và chạy tiếp theo thời gian thật.
final kValueDemoToday = DateTime(2026, 10, 7);
final kValueDemoStartTime = DateTime(2026, 10, 7, 20, 25);

/// Thai kỳ chuẩn 280 ngày (40 tuần) tính từ kỳ kinh cuối — tuần thai = (ngày - LMP) / 7.
const kValuePregnancyTotalDays = 280;

/// BR-054/056 (BF-20261013-005): thời lượng dùng thử **mặc định** 604800 giây
/// (7 × 24 giờ). Giá trị thật lấy từ trial policy có phiên bản trong catalog
/// (`catalog.json` → `trialPolicy.durationSeconds`); hằng số chỉ dùng khi
/// catalog thiếu policy.
const kValueDefaultTrialDuration = Duration(seconds: 604800);

/// Bản mẫu (không có thư viện ảnh thật): video chọn từ ô “+” của MEM-05 dài
/// 12 phút, vượt giới hạn 10 phút của gói Family → SUB-05 (Pencil `aISrA`).
const kValueMockPickedVideoMinutes = 12;

/// CARE-06: hoàn tác hoàn thành nhiệm vụ trong 10 giây (mục 7.13.4).
const kValueMissionUndoWindow = Duration(seconds: 10);

/// CARE-05: lựa chọn đổi nhiệm vụ có Hearts lệch tối đa ±1 (BR-019).
const kValueSwapHeartsTolerance = 1;

/// CARE-05: số lựa chọn đổi nhiệm vụ hiển thị.
const kValueSwapOptionCount = 3;

/// BR-068: lời nhờ một việc hoàn thành = +5 Hearts cho người làm.
const kValueRequestDoneHearts = 5;

/// BR-067: bị từ chối thì không gửi lại cùng nội dung trong 12 giờ.
const kValueRequestResendBlock = Duration(hours: 12);

/// BR-027: mood hết hiệu lực sau 6 giờ hoặc 0:00.
const kValueMoodLifetime = Duration(hours: 6);

/// BR-071: mỗi Parent tối đa 1 góc nhìn cho mỗi ký ức.
const kValueMaxPerspectivesPerParent = 1;

/// BR-073: gợi ý ghi lại tối đa 1/ngày/Parent.
const kValuePromptsPerDay = 1;

/// Ordered mood reactions shared by the check-in picker and the couple overview.
const kValueMoodEmoji = [
  '😊',
  '🙂',
  '😪',
  '🥱',
  '😣',
  '😢',
  '😠',
  '🤯',
  '🥺',
  '🤗',
];

/// BR-032: no more than five simultaneous requests between parents.
const kValueMaxOpenRequests = 5;

/// Hearts thưởng thêm khi đính ảnh lúc hoàn thành nhiệm vụ (mục 7.14.1).
const kValueMissionPhotoHearts = 2;

/// BR-058 / C-08: gia đình hết hạn được giữ dữ liệu ~12 tháng (SUB-07).
const kValueDataRetentionMonths = 12;

/// US-05: sticker gửi kèm lời cảm ơn (emoji — được phép theo Skill 8).
const kValueThanksStickers = ['💛', '🤗', '🌷', '☕', '🙏'];

/// CIR-01 “Thả tim”: reaction trái tim gửi lên ký ức.
const kValueHeartReaction = '❤️';

/// Năm cảm xúc của ký ức (đặc tả 7.12: Thương, Đáng yêu, Buồn cười, Xúc động,
/// Giỏi quá) ↔ loại server (`reaction_type`). Mỗi người 1 cảm xúc/ký ức.
const kValueReactionTypes = {
  '❤️': 'LOVE',
  '😍': 'CUTE',
  '😂': 'HAHA',
  '🥹': 'TOUCHED',
  '👏': 'CLAP',
};

/// MEM-10: biểu tượng cảm xúc chèn nhanh vào bình luận.
const kValueCommentEmoji = ['❤️', '🥹', '😍', '😂', '👏', '🥰'];

/// MEM-10: chỉ sửa được bình luận của mình trong 15 phút sau khi gửi.
const kValueCommentEditWindow = Duration(minutes: 15);

/// CARE-12: giờ hỏi chuyển việc tự thêm chưa xong sang ngày mai (mục 9.7).
const kValueMissionCarryOverTime = '21:00';

/// CHD-03/05: chỉ xoá vĩnh viễn hồ sơ bé sau khi đã lưu trữ đủ 7 ngày.
const kValueChildDeleteAfterArchiveDays = 7;

/// MEM-14: “Sinh nhật thứ N” mặc định khi hẹn ngày mở thư (tuổi trưởng thành).
const kValueLetterDefaultBirthday = 18;

/// MEM-07: số bình luận gốc hiện trước “Xem tất cả” (MEM-10).
const kValueCommentPreviewCount = 2;

/// US-08: độ dài tối đa của nháp riêng Cầu nối (như ghi chú check-in ≤ 500,
/// mục 7.16.1).
const kValueBridgeDraftMaxLength = 500;

/// US-08: số bước của giai đoạn riêng tư (cảm xúc → chủ đề → nhu cầu + nháp →
/// làm gì với nội dung → xem trước & gửi; mục 7.17.1).
const kValueBridgeWizardSteps = 5;

/// Hỗ trợ khách hàng: danh mục mặc định khi chưa nối server (server là nguồn
/// chính — `GET /v1/support/categories`).
const kValueSupportCategories = [
  'ACCOUNT',
  'INVITATION',
  'MEDIA',
  'BILLING',
  'PRIVACY',
  'OTHER',
];
const kValueSupportStatusOpen = 'OPEN';

/// SUB-05: mã lỗi server khi chạm giới hạn gói lúc lưu ký ức.
const kValueQuotaPhotosPerMemory = 'QUOTA_PHOTOS_PER_MEMORY';
const kValuePlanQuotaErrorCodes = {
  'QUOTA_MEMORY_COUNT_EXCEEDED',
  'QUOTA_STORAGE_EXCEEDED',
  kValueQuotaPhotosPerMemory,
};
const kValueSupportSenderUser = 'USER';

/// Trạng thái ticket không nhận tin nhắn thêm.
const kValueSupportClosedStatuses = {'RESOLVED', 'CLOSED'};

/// Cảm xúc của khoảnh khắc (mã theo enum `MomentFeeling` của server, viết
/// thường; nhãn ở l10n `memFeeling`).
const kValueMomentFeelings = [
  'love',
  'joy',
  'touched',
  'surprised',
  'peaceful',
  'proud',
];
