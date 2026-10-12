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

/// BR-054/056: dùng thử 90 ngày khi gia đình đủ Papa + Mama.
const kValueTrialDays = 90;

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
