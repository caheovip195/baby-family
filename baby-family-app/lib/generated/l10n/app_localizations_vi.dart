// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'Baby Family';

  @override
  String get commonContinue => 'Tiếp tục';

  @override
  String get commonStart => 'Bắt đầu';

  @override
  String get commonCancel => 'Huỷ';

  @override
  String get commonConfirm => 'Xác nhận';

  @override
  String get commonRetry => 'Thử lại';

  @override
  String get commonClose => 'Đóng';

  @override
  String get commonCopyError => 'Sao chép lỗi';

  @override
  String commonDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Còn $count ngày',
      zero: 'Hôm nay là ngày cuối',
    );
    return '$_temp0';
  }

  @override
  String commonUpdatedAt(DateTime time) {
    final intl.DateFormat timeDateFormat = intl.DateFormat.Hm(localeName);
    final String timeString = timeDateFormat.format(time);

    return 'Cập nhật lúc $timeString';
  }

  @override
  String get errorGeneric => 'Có lỗi xảy ra, vui lòng thử lại.';

  @override
  String get errorNetwork =>
      'Không kết nối được máy chủ. Vui lòng kiểm tra mạng và thử lại.';

  @override
  String get errorRenewSessionNetwork =>
      'Không kết nối được máy chủ để gia hạn phiên đăng nhập. Vui lòng kiểm tra mạng và thử lại.';

  @override
  String get errorSessionExpired =>
      'Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.';

  @override
  String get errorUpgradeRequired =>
      'Phiên bản ứng dụng đã cũ. Vui lòng cập nhật để tiếp tục sử dụng.';

  @override
  String get errorStartupTitle => 'Không khởi động được ứng dụng';

  @override
  String get errorStartupDescription =>
      'Vui lòng mở lại ứng dụng. Nếu vẫn lỗi, gửi nội dung dưới đây cho bộ phận hỗ trợ:';

  @override
  String get languagePickerTitle => 'Chọn ngôn ngữ';

  @override
  String get welcomeSlide1Title => 'Lưu giữ hành trình của con';

  @override
  String get welcomeSlide1Description =>
      'Từ ảnh siêu âm đầu tiên đến bước đi chập chững — mọi khoảnh khắc được giữ riêng tư cho gia đình.';

  @override
  String get welcomeSlide2Title => 'Papa & Mama cùng chăm con';

  @override
  String get welcomeSlide2Description =>
      'Những nhiệm vụ nhỏ mỗi ngày giúp Papa và Mama chia sẻ việc chăm con mà không cần nhắc nhau.';

  @override
  String get welcomeSlide3Title => 'Ông bà cùng theo dõi cháu';

  @override
  String get welcomeSlide3Description =>
      'Mời ông bà, người thân xem cháu lớn lên — an toàn, riêng tư, không cần mạng xã hội.';

  @override
  String get welcomeHaveInviteCode => 'Tôi đã có mã mời';

  @override
  String get commonSave => 'Lưu';

  @override
  String get commonDone => 'Hoàn tất';

  @override
  String get commonAdd => 'Thêm';

  @override
  String get commonSeeAll => 'Xem tất cả';

  @override
  String get commonBack => 'Quay lại';

  @override
  String get commonEmptyTitle => 'Chưa có nội dung';

  @override
  String get commonEmptyMessage =>
      'Lưu một khoảnh khắc đầu tiên cho nhà mình nhé.';

  @override
  String get commonOffline =>
      'Bạn đang ngoại tuyến. Nội dung đã lưu vẫn ở đây.';

  @override
  String get commonMockMode => 'Dữ liệu mẫu';

  @override
  String get commonAllFamily => 'Cả nhà';

  @override
  String get commonMine => 'Của tôi';

  @override
  String commonPartnerTasks(String callName) {
    return 'Việc của $callName';
  }

  @override
  String get commonTogether => 'Cùng làm';

  @override
  String get commonOnlyYou => 'Chỉ mình tôi';

  @override
  String get commonOnlyParents => 'Chỉ Papa & Mama';

  @override
  String get commonPhotos => 'Ảnh';

  @override
  String get commonTimeline => 'Dòng thời gian';

  @override
  String get commonCollections => 'Bộ sưu tập';

  @override
  String get commonMemory => 'Ký ức';

  @override
  String get commonDiary => 'Nhật ký';

  @override
  String get commonMilestone => 'Cột mốc';

  @override
  String get commonLetter => 'Thư gửi con';

  @override
  String get commonMission => 'Nhiệm vụ';

  @override
  String get commonEvent => 'Sự kiện';

  @override
  String get commonCheckin => 'Check-in cảm xúc';

  @override
  String get commonRequest => 'Lời nhờ';

  @override
  String get commonThanks => 'Lời cảm ơn';

  @override
  String get commonSelectChild => 'Chọn bé';

  @override
  String get commonQuickCreate => 'Ghi lại một điều nhỏ';

  @override
  String get commonName => 'Tên';

  @override
  String get commonDate => 'Ngày';

  @override
  String get commonBody => 'Nội dung';

  @override
  String get commonSaved => 'Đã lưu trong bản dùng thử';

  @override
  String get commonInvalidInput => 'Bạn điền đủ thông tin trước khi lưu nhé.';

  @override
  String commonChildAge(int months, int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years tuổi $months tháng',
      zero: '$months tháng',
    );
    return '$_temp0';
  }

  @override
  String commonPregnancyWeek(int week) {
    return 'Tuần thai $week';
  }

  @override
  String commonCountMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ký ức',
      zero: '0 ký ức',
    );
    return '$_temp0';
  }

  @override
  String commonHearts(int count) {
    return '$count Hearts';
  }

  @override
  String get navHome => 'Trang chủ';

  @override
  String get navMemories => 'Ký ức';

  @override
  String get navCare => 'Chăm con';

  @override
  String get navUs => 'Papa & Mama';

  @override
  String homeGreeting(String name) {
    return 'Chào $name';
  }

  @override
  String get homeToday => 'Hôm nay của các con';

  @override
  String get homeSpecialDay => 'Ngày đặc biệt';

  @override
  String get homeMonthlyPhoto => 'Chụp ảnh tháng';

  @override
  String get homeMissions => 'Nhiệm vụ hôm nay';

  @override
  String get homePrompt => 'Gợi ý ghi lại';

  @override
  String get homeRecordQuote => 'Ghi câu nói';

  @override
  String get homeRecent => 'Mới trong nhà';

  @override
  String get homeThisWeek => 'Tuần này của nhà mình';

  @override
  String get homeFamilyTree => 'Cây gia đình';

  @override
  String get homeFamily => 'Gia đình mình';

  @override
  String get careTitle => 'Chăm con';

  @override
  String get careTodayTree => 'Cây hôm nay';

  @override
  String careProgress(int done, int total) {
    return '$done/$total việc của nhà mình';
  }

  @override
  String get careAddMission => 'Thêm nhiệm vụ';

  @override
  String get careMissionTitle => 'Tên nhiệm vụ';

  @override
  String get careWhoDoes => 'Ai thực hiện?';

  @override
  String get careWhen => 'Khi nào?';

  @override
  String get careReminder => 'Nhắc nhẹ';

  @override
  String get careRepeat => 'Lặp lại';

  @override
  String careAskPartner(String callName) {
    return 'Nhờ $callName làm giúp';
  }

  @override
  String get careCompleteTitle => 'Một việc nhỏ, một chút yêu thương';

  @override
  String get careSaveMoment => 'Lưu thành ký ức';

  @override
  String get careUndo => 'Hoàn tác';

  @override
  String get careSwapTitle => 'Đổi nhiệm vụ';

  @override
  String get careRemoveToday => 'Bỏ khỏi hôm nay (không bị trừ gì)';

  @override
  String get careTreeTitle => 'Cây gia đình';

  @override
  String careTreeLevel(int level) {
    return 'Cấp $level';
  }

  @override
  String get careTreeNext => 'Cùng chăm cây lớn thêm một chút';

  @override
  String get careContribution => 'Đóng góp của cả nhà';

  @override
  String get careHeartsPrivacy =>
      'Hearts của mỗi người chỉ người đó thấy. Không so sánh, không bao giờ bị trừ.';

  @override
  String get usTitle => 'Papa & Mama';

  @override
  String get usHowAreYou => 'Hôm nay bạn thấy thế nào?';

  @override
  String get usEnergy => 'Năng lượng của bạn';

  @override
  String get usNeed => 'Bạn đang cần gì?';

  @override
  String usShareWith(String callName) {
    return 'Chia sẻ với $callName';
  }

  @override
  String get usPrivate => 'Góc riêng chỉ Papa & Mama thấy';

  @override
  String get usSendRequest => 'Gửi lời nhờ';

  @override
  String get usRequestMessage => 'Bạn muốn nhờ điều gì?';

  @override
  String get usAccept => 'Mình nhận nhé';

  @override
  String get usDecline => 'Hôm nay mình chưa tiện';

  @override
  String get usRequestAccepted => 'Đã nhận lời';

  @override
  String get usRequestDone => 'Đã giúp xong';

  @override
  String get usDailyQuestion => 'Câu hỏi kết nối hôm nay';

  @override
  String get usJournal => 'Nhật ký riêng';

  @override
  String get usBridge => 'Cầu nối yêu thương';

  @override
  String get usWeek => 'Tuần của hai mình';

  @override
  String get usHug => 'Gửi một cái ôm';

  @override
  String get usSeen => 'Đã thấy';

  @override
  String get usTakeOver => 'Để mình lo';

  @override
  String get usThanksRecent => 'Lời cảm ơn gần đây';

  @override
  String get familyTitle => 'Gia đình mình';

  @override
  String get familyChildren => 'Các con';

  @override
  String get familyParents => 'Papa & Mama';

  @override
  String get familyRelatives => 'Ông bà & người thân';

  @override
  String get familyInvite => 'Mời người thân';

  @override
  String get familyPermissions => 'Quyền';

  @override
  String get familyPrivateNotice =>
      'Người thân chỉ thấy những gì bạn chia sẻ. Góc Papa & Mama luôn riêng tư.';

  @override
  String get familyTrial => 'Dùng thử miễn phí';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get settingsLanguage => 'Ngôn ngữ';

  @override
  String get settingsAppearance => 'Giao diện';

  @override
  String get settingsLight => 'Sáng';

  @override
  String get settingsDark => 'Tối';

  @override
  String get settingsSystem => 'Theo hệ thống';

  @override
  String get settingsTextSize => 'Cỡ chữ';

  @override
  String get settingsRegular => 'Bình thường';

  @override
  String get settingsLarge => 'Lớn';

  @override
  String get settingsExtraLarge => 'Rất lớn';

  @override
  String get settingsNotifications => 'Thông báo';

  @override
  String get settingsPrivacy => 'Quyền riêng tư';

  @override
  String get settingsAi => 'AI hỗ trợ';

  @override
  String get settingsSecurity => 'Bảo mật & Thiết bị';

  @override
  String get settingsData => 'Dữ liệu của tôi';

  @override
  String get settingsBilling => 'Gói & thanh toán';

  @override
  String get settingsHelp => 'Trợ giúp';

  @override
  String get settingsAbout => 'Giới thiệu';

  @override
  String get settingsLogout => 'Đăng xuất';

  @override
  String get settingsLanguageNotice =>
      'Đổi ngay, không cần khởi động lại. Nội dung do gia đình viết không bị dịch.';

  @override
  String get settingsLunar => 'Hiện ngày âm lịch';

  @override
  String get settingsHaptics => 'Rung nhẹ khi thao tác';

  @override
  String get billingTitle => 'Giữ trọn từng khoảnh khắc của con';

  @override
  String get billingHouse => 'House';

  @override
  String get billingFamily => 'Family';

  @override
  String get billingRestore => 'Khôi phục giao dịch';

  @override
  String get billingUpgrade => 'Nâng cấp gói';

  @override
  String get billingExpired => 'Thời gian dùng thử của nhà mình đã kết thúc';

  @override
  String get billingExport => 'Tải xuống dữ liệu';

  @override
  String get billingPrivacy =>
      'Ký ức luôn thuộc về gia đình. Bạn vẫn có thể tải dữ liệu khi gói hết hạn.';

  @override
  String get billingFamilyFeatures =>
      'Thêm tối đa 12 người thân · 200 GB lưu trữ';

  @override
  String get billingHouseFeatures => 'Dành cho Papa & Mama · 50 GB lưu trữ';

  @override
  String get notificationsTitle => 'Thông báo';

  @override
  String get notificationsAll => 'Tất cả';

  @override
  String get notificationsPrivate => 'Papa & Mama';

  @override
  String get stateLoading => 'Đang tải nội dung…';

  @override
  String get stateEmptyMemories =>
      'Chưa có ký ức nào. Lưu khoảnh khắc đầu tiên nhé!';

  @override
  String get stateEmptyCare => 'Hôm nay chưa có việc nào';

  @override
  String get stateError => 'Chưa tải được nội dung. Bạn thử lại nhé.';

  @override
  String get commonChoose => 'Chọn';

  @override
  String get commonRequired => 'Bạn hãy điền thông tin này nhé';

  @override
  String get memoriesTitle => 'Ký ức';

  @override
  String get memoriesTimeline => 'Dòng thời gian';

  @override
  String get memoriesPhotos => 'Ảnh';

  @override
  String get memoriesCollections => 'Bộ sưu tập';

  @override
  String get memoriesAll => 'Tất cả';

  @override
  String get memoriesFirsts => 'Lần đầu';

  @override
  String get memoriesQuotes => 'Câu nói';

  @override
  String get memoriesVoices => 'Giọng nói';

  @override
  String get memoriesNew => 'Ký ức mới';

  @override
  String get memoriesCaptionHint => 'Bạn muốn nhớ điều gì về khoảnh khắc này?';

  @override
  String get memoriesChildren => 'Bé trong khoảnh khắc';

  @override
  String get memoriesFamily => 'Cả nhà';

  @override
  String get memoriesDate => 'Ngày xảy ra';

  @override
  String get memoriesToday => 'Hôm nay';

  @override
  String get memoriesVisibility => 'Ai thấy';

  @override
  String get memoriesPrivacyHint =>
      'Vị trí GPS trong ảnh luôn được xoá trước khi lưu.';

  @override
  String get memoriesAddMedia => 'Thêm ảnh';

  @override
  String memUploadProgress(int done, int total) {
    return 'Đang tải $done/$total ảnh…';
  }

  @override
  String get memUploadFailed => 'Tải lên chưa xong';

  @override
  String get memUploadRetry => 'Thử lại';

  @override
  String get memUploadCancel => 'Huỷ';

  @override
  String get memoriesSetCover => 'Đặt làm ảnh bìa';

  @override
  String get memoriesRemoveMedia => 'Bỏ ảnh này';

  @override
  String get memoriesAddPerspective => 'Thêm góc nhìn của bạn';

  @override
  String get memoriesTogether => 'Cả hai cùng kể';

  @override
  String get memoriesCommentHint => 'Viết bình luận…';

  @override
  String get memoriesComments => 'Bình luận';

  @override
  String get memoriesSend => 'Gửi';

  @override
  String get memoriesMonthly => 'Con lớn từng tháng';

  @override
  String get memoriesYear => 'Năm đầu tiên';

  @override
  String get memoriesCompare => 'So sánh';

  @override
  String get memoriesCollage => 'Ghép ảnh';

  @override
  String get memoriesMonthlyPhoto => 'Chụp ảnh tháng';

  @override
  String get memoriesGhost => 'Bóng mờ ảnh trước';

  @override
  String get memoriesGallery => 'Chọn từ thư viện';

  @override
  String get memoriesCapture => 'Chụp ảnh';

  @override
  String get memoriesQuote => 'Câu nói của con';

  @override
  String get memoriesQuoteHint => 'Con đã nói điều gì hôm nay?';

  @override
  String get memoriesQuoteContext => 'Con nói khi nào?';

  @override
  String get memoriesRecordVoice => 'Ghi âm giọng con';

  @override
  String get memoriesPerspective => 'Góc nhìn của bạn';

  @override
  String get memoriesPerspectiveHint => 'Bạn nhớ gì về khoảnh khắc này?';

  @override
  String get memoriesInheritedVisibility => 'Người xem giống ký ức gốc';

  @override
  String get memoriesStory => 'Hôm nay của bé';

  @override
  String get memoriesReplyHint => 'Trả lời…';

  @override
  String get memoriesEmpty =>
      'Chưa có ký ức nào. Lưu khoảnh khắc đầu tiên nhé!';

  @override
  String get memoriesSaved => 'Khoảnh khắc đã được lưu';

  @override
  String get memoriesChooseChildren => 'Chọn ít nhất một bé hoặc Cả nhà';

  @override
  String memoriesMonthLabel(int month) {
    String _temp0 = intl.Intl.pluralLogic(
      month,
      locale: localeName,
      other: '$month tháng',
    );
    return '$_temp0';
  }

  @override
  String memoriesWeekLabel(int week) {
    return 'Tuần $week';
  }

  @override
  String memoriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ký ức',
    );
    return '$_temp0';
  }

  @override
  String get pregnancyTitle => 'Hành trình thai kỳ';

  @override
  String get pregnancyBump => 'Bụng bầu';

  @override
  String get pregnancyUltrasound => 'Siêu âm';

  @override
  String get pregnancyPreparations => 'Chuẩn bị';

  @override
  String get pregnancyCaptureBump => 'Chụp ảnh bụng tuần này';

  @override
  String get pregnancyGuide => 'Có bóng mờ ảnh trước để giữ cùng góc chụp';

  @override
  String get pregnancyBumpKindness =>
      'Bỏ lỡ vài tuần cũng không sao — mỗi tấm ảnh đều quý.';

  @override
  String get pregnancyRemind => 'Nhắc chụp mỗi Chủ nhật';

  @override
  String get pregnancyBirth => 'Bé đã chào đời';

  @override
  String get pregnancyNames => 'Đặt tên cho con';

  @override
  String get pregnancyArchive => 'Lưu trữ hành trình';

  @override
  String pregnancyPrepareProgress(int done, int total) {
    return 'Đã chuẩn bị $done/$total';
  }

  @override
  String get pregnancyAddPreparation => 'Thêm mục';

  @override
  String get pregnancyPreparationHint => 'Món nhà mình cần chuẩn bị';

  @override
  String get pregnancyCreateMission => 'Chuyển thành nhiệm vụ';

  @override
  String get pregnancyBirthWelcome => 'Chào mừng bé đến với nhà mình';

  @override
  String get pregnancyBabyName => 'Tên hoặc tên ở nhà';

  @override
  String get pregnancyNickname => 'Tên ở nhà';

  @override
  String get pregnancyBirthDate => 'Ngày sinh *';

  @override
  String get pregnancyBirthTime => 'Giờ sinh';

  @override
  String get pregnancyBirthWeight => 'Cân nặng (kg)';

  @override
  String get pregnancyBirthGender => 'Giới tính (tuỳ chọn)';

  @override
  String get pregnancyBirthPreview => 'Xem thẻ chào mừng';

  @override
  String get pregnancyAnnounce => 'Báo tin cho người thân?';

  @override
  String get pregnancyAnnounceHint =>
      'Chỉ người thân đang được chia sẻ thai kỳ. Ký ức thai kỳ trở thành chương mở đầu của bé.';

  @override
  String get pregnancyBirthComplete => 'Chào mừng bé! Thông tin đã được lưu.';

  @override
  String get pregnancyArchiveIntro =>
      'Mọi ký ức vẫn được giữ nguyên. Bạn có thể quay lại bất cứ lúc nào.';

  @override
  String get pregnancyPause => 'Tạm dừng hành trình';

  @override
  String get pregnancyPauseHint =>
      'Ẩn khỏi Trang chủ, tắt nhắc. Mở lại khi bạn muốn.';

  @override
  String get pregnancyEnd => 'Hành trình này đã dừng lại';

  @override
  String get pregnancyEndHint =>
      'Chúng tôi rất tiếc. App sẽ ngừng mọi đếm ngược, nhắc nhở và lời chúc ngay lập tức.';

  @override
  String get pregnancyParentsOnly => 'Chỉ Papa & Mama xem các ký ức này';

  @override
  String get pregnancyArchivePrivacy =>
      'Không có thông báo nào gửi tới người thân.';

  @override
  String get pregnancyArchiveSaved => 'Hành trình đã được lưu trữ riêng tư';

  @override
  String get pregnancyPrivate => 'Chỉ Papa & Mama nhìn thấy';

  @override
  String get pregnancyBothLike => 'Cả hai thích';

  @override
  String get pregnancyAddName => 'Thêm tên dự định';

  @override
  String get pregnancyNameHint => 'Tên dự định';

  @override
  String get pregnancyMeaning => 'Ý nghĩa';

  @override
  String get pregnancyChooseName => 'Chọn tên này';

  @override
  String get pregnancyNameChosen => 'Tên dự định đã được lưu';

  @override
  String get pregnancyMockMedia => 'Ảnh mẫu đã sẵn sàng';

  @override
  String get commonSkip => 'Bỏ qua';

  @override
  String get commonLater => 'Để sau';

  @override
  String get commonOr => 'hoặc';

  @override
  String get commonCopied => 'Đã sao chép';

  @override
  String get commonChoosePhoto => 'Chọn ảnh';

  @override
  String get commonRemovePhoto => 'Xoá ảnh';

  @override
  String get commonTerms => 'Điều khoản sử dụng';

  @override
  String get commonPrivacyPolicy => 'Chính sách quyền riêng tư';

  @override
  String get commonOptional => 'Tuỳ chọn';

  @override
  String get authTitle => 'Chào mừng đến Baby Family';

  @override
  String get authSubtitle =>
      'Đăng nhập để bắt đầu lưu giữ hành trình của con cùng cả nhà.';

  @override
  String get authPrivate => 'Riêng tư';

  @override
  String authTrial(int days) {
    return '$days ngày miễn phí';
  }

  @override
  String get authFamily => 'Cả nhà';

  @override
  String get authApple => 'Tiếp tục với Apple';

  @override
  String get authGoogle => 'Tiếp tục với Google';

  @override
  String get authPhone => 'Dùng số điện thoại';

  @override
  String get authLegal =>
      'Bằng việc tiếp tục, bạn đồng ý với Điều khoản sử dụng và Chính sách quyền riêng tư của Baby Family.';

  @override
  String get authPhoneTitle => 'Số điện thoại của bạn';

  @override
  String get authPhoneSubtitle =>
      'Chúng tôi sẽ gửi mã xác thực 6 số qua Zalo hoặc SMS.';

  @override
  String get authPhoneLabel => 'Số điện thoại';

  @override
  String get authCountryCode => 'Mã quốc gia';

  @override
  String get authPhonePrivate =>
      'Số điện thoại chỉ dùng để đăng nhập, không hiển thị với ai.';

  @override
  String get authSendCode => 'Gửi mã';

  @override
  String get authOtpTitle => 'Nhập mã xác thực';

  @override
  String authOtpSubtitle(String phone) {
    return 'Mã 6 số đã gửi qua Zalo tới $phone.';
  }

  @override
  String authOtpDemo(String code) {
    return 'Mã demo: $code';
  }

  @override
  String get authResend => 'Gửi lại mã';

  @override
  String authResendCountdown(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: 'Gửi lại mã sau ${seconds}s',
    );
    return '$_temp0';
  }

  @override
  String get authSendSms => 'Gửi qua SMS';

  @override
  String get authChangePhone => 'Đổi số điện thoại';

  @override
  String get authProfileTitle => 'Giới thiệu một chút về bạn';

  @override
  String get authProfileSubtitle =>
      'Tên này sẽ hiển thị với bạn đời và người thân trong gia đình.';

  @override
  String get authNameLabel => 'Tên của bạn';

  @override
  String get authTermsConsent => 'Tôi đồng ý Điều khoản sử dụng';

  @override
  String get authDataConsent =>
      'Tôi đồng ý cho Baby Family xử lý dữ liệu cá nhân của tôi và con tôi theo Chính sách quyền riêng tư';

  @override
  String get errorRequired => 'Bạn điền thông tin này nhé.';

  @override
  String get errorPhone => 'Số điện thoại chưa đúng định dạng.';

  @override
  String get errorConsent => 'Bạn cần đồng ý cả hai mục để tiếp tục.';

  @override
  String get errorOtp => 'Mã chưa đúng. Bạn thử lại nhé.';

  @override
  String get errorOtpExpired => 'Mã đã hết hạn. Gửi lại mã nhé.';

  @override
  String get errorInviteCode => 'Mã mời gồm 8 chữ và số.';

  @override
  String get errorBirthday => 'Ngày sinh không thể ở tương lai.';

  @override
  String get errorPregnancyWeek => 'Tuần thai cần nằm trong khoảng 4 đến 42.';

  @override
  String get onboardingRoleTitle => 'Bạn là ai trong gia đình?';

  @override
  String get onboardingRoleSubtitle =>
      'Baby Family cần cả Papa và Mama cùng tham gia. Ông bà, người thân sẽ được mời vào sau.';

  @override
  String get onboardingPapaDescription =>
      'Bố của bé — cùng Mama quản lý gia đình';

  @override
  String get onboardingMamaDescription =>
      'Mẹ của bé — cùng Papa quản lý gia đình';

  @override
  String get onboardingCircle => 'Người thân';

  @override
  String get onboardingCircleDescription =>
      'Ông bà, cô dì chú bác, người chăm bé — cần được mời vào gia đình';

  @override
  String get onboardingCallName => 'Các con gọi bạn là';

  @override
  String get onboardingOtherCallName => 'Khác…';

  @override
  String get onboardingFatherCallName => 'Bố';

  @override
  String get onboardingFatherCallNameAlt => 'Ba';

  @override
  String get onboardingMotherCallName => 'Mẹ';

  @override
  String get onboardingMotherCallNameAlt => 'Má';

  @override
  String get onboardingFamilyTitle => 'Đặt tên cho tổ ấm';

  @override
  String get onboardingFamilySubtitle =>
      'Tên gia đình chỉ hiển thị với Papa, Mama và người thân được mời.';

  @override
  String get onboardingFamilyName => 'Tên gia đình';

  @override
  String get onboardingCreateFamily => 'Tạo gia đình';

  @override
  String onboardingInviteTitle(String callName) {
    return 'Mời $callName cùng tham gia';
  }

  @override
  String onboardingInviteSubtitle(int days) {
    return 'Baby Family cần cả Papa và Mama. Khi bạn đời tham gia, nhà mình bắt đầu $days ngày dùng thử miễn phí.';
  }

  @override
  String get onboardingInviteCode => 'Mã mời';

  @override
  String get onboardingInviteExpiry => 'Hết hạn sau 7 ngày · dùng 1 lần';

  @override
  String get onboardingInviteApproval =>
      'Tôi xác nhận lần cuối khi bạn đời tham gia';

  @override
  String get onboardingShareInvite => 'Gửi lời mời qua Zalo, Messenger…';

  @override
  String get onboardingCopyInvite => 'Sao chép link mời';

  @override
  String get onboardingInviteSent => 'Đã gửi lời mời';

  @override
  String onboardingWaitingTitle(String callName) {
    return 'Đang chờ $callName tham gia…';
  }

  @override
  String onboardingWaitingSubtitle(int days) {
    return 'Khi bạn đời nhận lời mời, nhà mình sẽ được mở khoá và bắt đầu $days ngày dùng thử miễn phí.';
  }

  @override
  String get onboardingResendInvite => 'Gửi lại lời mời';

  @override
  String get onboardingShowQr => 'Hiện mã QR';

  @override
  String get onboardingChangeInvite => 'Đổi cách mời';

  @override
  String get onboardingCancelFamily => 'Huỷ gia đình này';

  @override
  String get onboardingActivateDemo => 'Mô phỏng bạn đời tham gia';

  @override
  String get onboardingActivatedTitle => 'Nhà mình đã đủ Papa & Mama 🎉';

  @override
  String get onboardingActivatedSubtitle =>
      'Cùng nhau lưu giữ hành trình của con, chia sẻ việc chăm con và luôn hiểu nhau hơn.';

  @override
  String onboardingTrial(int days) {
    return '$days ngày dùng thử miễn phí';
  }

  @override
  String get onboardingSetupChild => 'Thiết lập cho bé';

  @override
  String get onboardingStageTitle => 'Nhà mình đang ở giai đoạn nào?';

  @override
  String get onboardingStageSubtitle =>
      'Nhà mình có thể thêm bé hoặc thai kỳ khác bất cứ lúc nào.';

  @override
  String get onboardingPregnant => 'Đang mang thai';

  @override
  String get onboardingPregnantDescription =>
      'Lưu ảnh bụng bầu, siêu âm, thư gửi con và chuẩn bị đón bé';

  @override
  String get onboardingBorn => 'Bé đã chào đời';

  @override
  String get onboardingBornDescription =>
      'Tạo hồ sơ bé, lưu những lần đầu và cùng chăm con';

  @override
  String get onboardingBoth => 'Đã có bé và đang mang thai';

  @override
  String get onboardingBothDescription =>
      'Nhiều bé và nhiều thai kỳ cùng sống trong gia đình';

  @override
  String get onboardingPregnancyTitle => 'Chào bé yêu trong bụng mẹ';

  @override
  String get onboardingPregnancySubtitle =>
      'Chỉ cần một cái tên ở nhà. Những thông tin khác có thể bổ sung sau.';

  @override
  String get onboardingNickname => 'Tên ở nhà của bé';

  @override
  String get onboardingDueDate => 'Ngày dự sinh';

  @override
  String get onboardingKnowWeek => 'Mình chỉ biết tuần thai';

  @override
  String get onboardingWeek => 'Tuần thai';

  @override
  String get onboardingBabyCount => 'Số bé';

  @override
  String get onboardingSingle => 'Một bé';

  @override
  String get onboardingTwins => 'Song thai';

  @override
  String get onboardingTriplets => 'Ba bé';

  @override
  String get onboardingSkipDueDate => 'Bỏ qua ngày dự sinh';

  @override
  String get onboardingChildTitle => 'Giới thiệu bé của nhà mình';

  @override
  String get onboardingChildSubtitle =>
      'Tên hoặc tên ở nhà và ngày sinh là đủ để bắt đầu.';

  @override
  String get onboardingChildName => 'Tên hoặc tên ở nhà';

  @override
  String get onboardingBirthday => 'Ngày sinh';

  @override
  String get onboardingBoy => 'Bé trai';

  @override
  String get onboardingGirl => 'Bé gái';

  @override
  String get onboardingAddChild => 'Thêm bé khác';

  @override
  String get onboardingPrivacyTitle => 'Không gian riêng của nhà mình';

  @override
  String get onboardingPrivacySubtitle =>
      'Baby Family được xây để bảo vệ những khoảnh khắc quý giá nhất.';

  @override
  String get onboardingPrivacyInvited =>
      'Chỉ người được mời mới thấy ảnh của con';

  @override
  String get onboardingPrivacyInvitedDescription =>
      'Không có trang công khai, không ai tìm thấy gia đình bạn.';

  @override
  String get onboardingPrivacyUs => 'Papa & Mama là góc riêng';

  @override
  String get onboardingPrivacyUsDescription =>
      'Cảm xúc, lời nhờ, nhật ký riêng — ông bà không bao giờ thấy.';

  @override
  String get onboardingPrivacyData => 'Dữ liệu là của bạn';

  @override
  String get onboardingPrivacyDataDescription =>
      'Tải về hoặc xoá bất cứ lúc nào trong Cài đặt.';

  @override
  String get onboardingUnderstood => 'Mình hiểu rồi';

  @override
  String get onboardingNotificationsTitle => 'Đừng bỏ lỡ khoảnh khắc nào';

  @override
  String get onboardingNotificationsSubtitle =>
      'Nhận nhiệm vụ Papa/Mama giao, ảnh mới của bé và lời nhờ hỗ trợ. Bạn chỉnh từng loại và giờ yên tĩnh trong Cài đặt.';

  @override
  String get onboardingEnableNotifications => 'Bật thông báo';

  @override
  String get inviteTitle => 'Nhập mã mời';

  @override
  String get inviteSubtitle =>
      'Mã gồm 8 ký tự, có trong tin nhắn mời từ Papa hoặc Mama.';

  @override
  String get inviteView => 'Xem lời mời';

  @override
  String get inviteScanQr => 'Quét mã QR';

  @override
  String get inviteUseDemo => 'Dùng mã mời demo';

  @override
  String get inviteJoin => 'Tham gia gia đình';

  @override
  String get inviteDecline => 'Từ chối';

  @override
  String get inviteRole => 'Vai trò của bạn';

  @override
  String get inviteAccepted => 'Đã nhận lời mời trong bản demo';

  @override
  String get inviteDeclined => 'Đã từ chối lời mời trong bản demo';

  @override
  String get inviteInvalidTitle => 'Lời mời không còn hiệu lực';

  @override
  String get inviteInvalidDescription => 'Nhờ người mời gửi lại link mới nhé.';

  @override
  String get circleWaitingTitle => 'Bà cần được con cháu mời vào gia đình';

  @override
  String get circleWaitingSubtitle =>
      'Khi Papa hoặc Mama gửi lời mời, bà sẽ xem được ảnh và những lần đầu của cháu.';

  @override
  String get circleAskInvite => 'Nhờ con mời mình';

  @override
  String get circleAskMessage =>
      'Con ơi, mình đã cài Baby Family, con mời mình vào xem cháu nhé.';

  @override
  String get circleSwitchRole => 'Tôi là Papa/Mama của bé';

  @override
  String get circleSignOut => 'Đăng xuất';

  @override
  String get authDemoDescription =>
      'Các thao tác đăng nhập và cấp quyền được mô phỏng với dữ liệu mẫu.';

  @override
  String get authDemoAction => 'Tiếp tục với dữ liệu mẫu';

  @override
  String get onboardingFirstMemoryTitle => 'Ký ức đầu tiên của nhà mình';

  @override
  String get onboardingFirstMemorySubtitle =>
      'Lưu khoảnh khắc đầu tiên của bé trong Baby Family.';

  @override
  String get onboardingFirstMemoryChoosePhoto => 'Chọn ảnh';

  @override
  String get memoriesKeepsakes => 'Kỷ vật';

  @override
  String get memoriesBest => 'Ảnh đẹp nhất nhà mình';

  @override
  String get memoriesRecordedVoice => 'Đoạn ghi âm mẫu đã được lưu';

  @override
  String get familyRelationship => 'Người này là…';

  @override
  String get familyCallName => 'Cháu gọi là';

  @override
  String get familyPhotosPermission => 'Xem ảnh & ký ức';

  @override
  String get familyFirstsPermission => 'Thả tim & bình luận';

  @override
  String get familyDownloadPermission => 'Đóng góp ảnh';

  @override
  String get familyInvitePreview => 'Xem trước quyền chia sẻ';

  @override
  String get familyHidden =>
      'Papa & Mama, nhiệm vụ và nội dung riêng luôn được giữ kín.';

  @override
  String get familyCreateInvite => 'Tạo lời mời';

  @override
  String get familyInviteCreated =>
      'Đã tạo lời mời mẫu. Chưa gửi tin nhắn cho người thân.';

  @override
  String get billingMockNotice =>
      'Đây là dữ liệu mẫu. Chọn gói, khôi phục và xuất dữ liệu chỉ được mô phỏng.';

  @override
  String get billingSelected =>
      'Đã chọn gói trong bản dùng thử. Không phát sinh giao dịch.';

  @override
  String get billingRestored => 'Đã mô phỏng khôi phục giao dịch.';

  @override
  String get billingExportReady =>
      'Đã mô phỏng yêu cầu xuất dữ liệu. Ký ức của nhà mình vẫn an toàn.';

  @override
  String get notificationsReadAll => 'Đã đọc hết';

  @override
  String get circleGreeting => 'Cháu yêu của cả nhà';

  @override
  String get circleSendWish => 'Gửi lời chúc';

  @override
  String get settingsDemoSection =>
      'Các tuỳ chọn trong mục này đang được mô phỏng với dữ liệu mẫu.';

  @override
  String get usNeedSpace => 'Một chút yên tĩnh';

  @override
  String get usNeedTalk => 'Muốn được lắng nghe';

  @override
  String get usBridgeAngry => 'Mình đang giận';

  @override
  String get usBridgeStuck => 'Mình chưa biết nói sao';

  @override
  String get usBridgeHint =>
      'Hãy nói điều bạn cảm thấy và điều bạn cần. Hai mình có thể tạm nghỉ rồi quay lại khi sẵn sàng.';

  @override
  String get usThanksHint => 'Hôm nay bạn muốn cảm ơn điều gì?';

  @override
  String get usJournalHint => 'Một nơi để ghi lại điều bạn đang nghĩ.';

  @override
  String get usNeedHelp => 'Giúp đỡ thực tế';

  @override
  String get usBridgeEmotion => 'Mình đang cảm thấy…';

  @override
  String get usBridgeAnger => 'Tức giận';

  @override
  String get usBridgePrivate => 'Chỉ bạn thấy những gì bạn viết ở đây';

  @override
  String get usBridgeDraft => 'Viết nháp riêng, nếu bạn muốn';

  @override
  String get usBridgeKeepPrivate => 'Giữ riêng';

  @override
  String get usBridgePause => 'Dừng lại';

  @override
  String get usThanksWall => 'Bức tường cảm ơn';

  @override
  String get settingsDisplayTitle => 'Hiển thị & Ngôn ngữ';

  @override
  String get settingsOther => 'Khác';

  @override
  String get settingsReduceMotion => 'Giảm hiệu ứng chuyển động';

  @override
  String get settingsReduceMotionHint => 'Ít animation hơn';

  @override
  String get settingsLunarHint => 'Bên cạnh ngày dương';

  @override
  String get settingsDeleteAccount => 'Xoá tài khoản';

  @override
  String get familyManage => 'Quản lý gia đình';

  @override
  String familyYou(String callName) {
    return '$callName (bạn)';
  }

  @override
  String get familyStorageLabel => 'Dung lượng';

  @override
  String get familyViewPlans => 'Xem gói House / Family';

  @override
  String get familyAddChild => 'Thêm con / thai kỳ';

  @override
  String get familyLockedTitle => 'Mời ông bà ở gói Family';

  @override
  String get familyLockedDescription =>
      'Trong thời gian dùng thử chỉ có Papa & Mama. Nâng cấp Family để ông bà, người thân cùng theo dõi cháu.';

  @override
  String get familyFollowing => 'Được theo dõi';

  @override
  String get relationPaternalGrandfather => 'Ông nội';

  @override
  String get relationPaternalGrandmother => 'Bà nội';

  @override
  String get relationMaternalGrandfather => 'Ông ngoại';

  @override
  String get relationMaternalGrandmother => 'Bà ngoại';

  @override
  String get relationAunt => 'Cô / Dì';

  @override
  String get relationUncle => 'Chú / Bác';

  @override
  String get billingHouseChildren => 'Papa & Mama, không giới hạn số con';

  @override
  String get billingHouseCare => 'Nhiệm vụ, nhật ký, khu vực Papa & Mama';

  @override
  String get billingHouseStorage => 'Lưu trữ 50 GB';

  @override
  String get billingInviteRelatives => 'Mời ông bà, người thân';

  @override
  String get billingFamilyIncludes => 'Mọi tính năng của House';

  @override
  String get billingFamilyRelatives => 'Mời tối đa 12 ông bà, người thân';

  @override
  String get billingFamilyStorage => 'Lưu trữ 200 GB, ảnh chất lượng gốc';

  @override
  String get billingFamilyVideos => 'Video đến 10 phút, bản tin cho ông bà';

  @override
  String get billingLegal =>
      'Gói áp dụng cho cả gia đình, Papa hoặc Mama thanh toán đều được. Tự động gia hạn hằng năm, huỷ bất kỳ lúc nào trong cài đặt App Store / Google Play. Điều khoản · Quyền riêng tư';

  @override
  String get billingChoosePlans => 'Chọn gói House / Family';

  @override
  String get billingRetentionHint =>
      'Chúng tôi sẽ báo trước nhiều lần trước khi xoá.';

  @override
  String get circleTitle => 'Cháu yêu của bà';

  @override
  String get circleNewPhotos => 'Ảnh mới tuần này';

  @override
  String get circleVoiceTip =>
      'Bấm giữ “Gửi lời chúc” để ghi âm giọng nói cho cháu';

  @override
  String get notificationsToday => 'Hôm nay';

  @override
  String get notificationsYesterday => 'Hôm qua';

  @override
  String stateEmptyMemoryTitle(String name) {
    return 'Chưa có ký ức nào của $name';
  }

  @override
  String get stateEmptyMemoryDescription =>
      'Lưu khoảnh khắc đầu tiên nhé — một tấm ảnh, một dòng nhật ký hay tiếng cười của con.';

  @override
  String get stateEmptyCareDescription =>
      'Chọn vài việc nhỏ để Papa & Mama cùng chia nhau nhé.';

  @override
  String get stateErrorTitle => 'Chưa tải được ký ức';

  @override
  String get stateErrorDescription =>
      'Có trục trặc nhỏ từ phía chúng tôi. Ký ức của nhà mình vẫn an toàn — thử lại sau giây lát nhé.';

  @override
  String get stateErrorCode => 'Mã lỗi: MEM-500 · Báo cho hỗ trợ';

  @override
  String get splashTagline => 'Cùng con lớn lên — Giữ mãi yêu thương';

  @override
  String get splashPreparing => 'Đang chuẩn bị không gian của nhà mình…';

  @override
  String get onboardingChildAvatarOptional => 'Thêm ảnh đại diện (tuỳ chọn)';

  @override
  String get onboardingComplete => 'Hoàn tất';

  @override
  String get onboardingSkipGender => 'Bỏ qua';

  @override
  String inviteJoinAsParent(String callName) {
    return 'Tham gia làm $callName';
  }

  @override
  String get memoriesMilestones => 'Cột mốc';

  @override
  String get memoriesAlbum => 'Album';

  @override
  String get memoriesChooseAlbum => 'Chọn album';

  @override
  String get memoriesCaptionSuggestion => 'Gợi ý chú thích';

  @override
  String get memoriesCover => 'Bìa';

  @override
  String get memoriesVideo => 'Video [1.1]';

  @override
  String memoriesNextMonth(int month) {
    return 'Tháng $month · ngày mai';
  }

  @override
  String get memoriesPerspectivePrompt => 'Bạn nhớ gì về khoảnh khắc này?';

  @override
  String get pregnancyHeight => 'Chiều dài';

  @override
  String get pregnancyBabyBoy => 'Bé trai';

  @override
  String get pregnancyBabyGirl => 'Bé gái';

  @override
  String get pregnancyLater => 'Để sau';

  @override
  String get pregnancyBirthBag => 'ĐỒ ĐI SINH';

  @override
  String get pregnancyDocuments => 'GIẤY TỜ';

  @override
  String get pregnancyNursery => 'GÓC CỦA BÉ';

  @override
  String get pregnancySupport => 'Nguồn hỗ trợ tinh thần (tuỳ chọn)';

  @override
  String commonChildNameAge(String name, String age) {
    return '$name · $age';
  }

  @override
  String get homeEvening => 'Chào buổi tối,';

  @override
  String get homeTomorrow => 'NGÀY MAI';

  @override
  String get homeRecord => 'Ghi lại';

  @override
  String get homeParentsPrivacy => 'Papa & Mama · chỉ hai bạn';

  @override
  String get homeHug => 'Ôm một cái';

  @override
  String homeMomentCount(int count) {
    return '$count khoảnh khắc';
  }

  @override
  String homePhotoCount(int count) {
    return '$count ảnh';
  }

  @override
  String homeYourHearts(int count) {
    return '💗 $count của tôi';
  }

  @override
  String homeMoreMissions(int count) {
    return '+ $count việc nữa của tôi · 💗 chỉ bạn thấy';
  }

  @override
  String get careTreeBloom => 'Xong hết để cây nở hoa 🌸';

  @override
  String careMyHeartsToday(int count) {
    return 'Hearts của tôi hôm nay: $count';
  }

  @override
  String get carePrivateHearts => 'Chỉ bạn thấy';

  @override
  String get homeOtherPrompt => 'Gợi ý khác';

  @override
  String commonWeek(int week) {
    return 'Tuần $week';
  }

  @override
  String homeChildToday(String name) {
    return 'Hôm nay của $name';
  }

  @override
  String get homeFirstsRecent => 'Những lần đầu gần đây';

  @override
  String homeChildMissions(String name) {
    return 'Việc cho $name hôm nay';
  }

  @override
  String get homeCompare => 'So sánh';

  @override
  String careSwapHeading(String title) {
    return 'Đổi “$title”';
  }

  @override
  String get careSwapHint =>
      'Các lựa chọn có số Hearts tương đương để bảng việc của hai người luôn cân bằng.';

  @override
  String careSwapRemaining(int count) {
    return 'Còn $count lần đổi hôm nay';
  }

  @override
  String get careSwapConfirm => 'Đổi sang việc này';

  @override
  String careCompleteHearts(int count) {
    return 'Tuyệt vời! +$count 💗 cho cây';
  }

  @override
  String careCompleteHint(String title) {
    return '$title — cây thêm một chiếc lá. (+2 💗 nếu lưu ảnh)';
  }

  @override
  String get careSaveMemoryQuestion => 'Lưu lại khoảnh khắc này?';

  @override
  String get careMemoryCaption => 'Một dòng ngắn về khoảnh khắc này…';

  @override
  String get careSaveMission => 'Lưu nhiệm vụ';

  @override
  String pregnancyNamesFor(String child) {
    return 'Đặt tên cho $child';
  }

  @override
  String pregnancyChooseNameFor(String name, String child) {
    return 'Chọn “$name” làm tên của $child';
  }

  @override
  String get memoriesSavePerspective => 'Lưu góc nhìn · Cả hai cùng kể';

  @override
  String get circleViewComment => 'Xem & bình luận';

  @override
  String get homeStoryView => 'Xem dạng story';

  @override
  String get homeCurrentChapter => 'CHƯƠNG HIỆN TẠI';

  @override
  String get homeNextFirst => 'Lần đầu tiếp theo?';

  @override
  String homeMonthShort(int month) {
    return '$month th';
  }

  @override
  String get homeMomentLabel => 'khoảnh khắc';

  @override
  String get homeQuoteLabel => 'câu nói mới';

  @override
  String get commonFirsts => 'lần đầu';

  @override
  String get circleLike => 'Thả tim';

  @override
  String homeMonthlyProgress(int done, int total) {
    return '$done/$total ảnh';
  }

  @override
  String get stateAddMemory => 'Thêm ký ức';

  @override
  String get careCamera => 'Chụp ảnh';

  @override
  String get careGallery => 'Chọn ảnh';

  @override
  String get carePhotoSelected => 'Đã chọn ảnh';

  @override
  String get commonCamera => 'Camera';

  @override
  String get commonGallery => 'Thư viện';

  @override
  String get careForWho => 'Cho ai?';

  @override
  String get careOneChild => 'Một bé';

  @override
  String get careManyChildren => 'Nhiều bé';

  @override
  String get careBothParents => 'Hai ta';

  @override
  String get careWhenQuestion => 'Khi nào?';

  @override
  String get careWhoQuestion => 'Ai làm?';

  @override
  String get careMemoryPrompt => 'Gợi ý lưu ảnh khi hoàn thành';

  @override
  String get careRemindBefore => 'Nhắc trước 15 phút';

  @override
  String careAskPartnerPrompt(String callName) {
    return 'Muốn nhờ $callName một việc? Gửi lời nhờ →';
  }

  @override
  String get careTreeName => 'Cây xanh';

  @override
  String get careTreeGrows => 'Lớn lên từ Hearts của Papa & Mama';

  @override
  String get careTreeNearBloom => 'Sắp tới Cây trổ hoa 🌸';

  @override
  String get careTreeReward => 'Phần thưởng: theme “Hoa anh đào” cho album';

  @override
  String get careTreeMoments => 'Khoảnh khắc chăm con';

  @override
  String get careTreeTogether => 'Lần cùng nhau';

  @override
  String get careTreeBloomDays => 'Ngày nở hoa';

  @override
  String get careTreeYourContribution => 'Bạn đã góp';

  @override
  String get careTreeToday => 'Hôm nay';

  @override
  String get careTreeWeek => 'Tuần này';

  @override
  String get careTreeTotal => 'Tổng';

  @override
  String memoriesSelectedPhotos(int count) {
    return 'Đã chọn $count ảnh';
  }

  @override
  String get usOnlyTwo => 'Chỉ hai bạn nhìn thấy';

  @override
  String usMe(String callName) {
    return '$callName (bạn)';
  }

  @override
  String usEnergyValue(int value) {
    return 'Năng lượng $value/5';
  }

  @override
  String get usHugShort => 'Ôm';

  @override
  String get usDailyQuestionShort => 'CÂU HỎI HÔM NAY';

  @override
  String get usBridgeShort => 'Cầu nối';

  @override
  String get usWeekShort => 'Tuần của hai ta';

  @override
  String get usCheckinTitle => 'Hôm nay bạn thế nào?';

  @override
  String get usEnergyShort => 'Năng lượng';

  @override
  String get usNeedShort => 'Mình cần…';

  @override
  String get usNeedRest => 'Nghỉ ngơi';

  @override
  String get usNeedChildcare => 'Giúp trông con';

  @override
  String get usNeedQuiet => 'Yên tĩnh';

  @override
  String get usNeedHug => 'Một cái ôm';

  @override
  String get usNeedConversation => 'Nói chuyện';

  @override
  String get usNeedEncouragement => 'Động viên';

  @override
  String get usOnlyMe => 'Chỉ mình tôi';

  @override
  String usSendTo(String callName) {
    return 'Gửi cho $callName';
  }

  @override
  String usRequestTo(String callName) {
    return 'Nhờ $callName';
  }

  @override
  String usRequestGentle(String callName) {
    return 'Lời nhờ không phải nhiệm vụ — $callName luôn có thể nói “Hôm nay không được”.';
  }

  @override
  String get usRequestOneThing => 'NHỜ MỘT VIỆC';

  @override
  String get usRequestRest => 'Cần nghỉ';

  @override
  String get usRequestWatchChild => 'Trông con';

  @override
  String get usRequestRestHint => 'Trông con giúp';

  @override
  String get usRequestWatchHint => 'Một lúc';

  @override
  String get usRequestLibrary => 'Thư viện';

  @override
  String get usRequestLibraryHint => 'Chọn việc';

  @override
  String get usRequestCustom => 'Tự gõ';

  @override
  String get usRequestCustomHint => 'Việc khác';

  @override
  String get usRequestDuration => 'Bao lâu?';

  @override
  String get usRequestWhen => 'Khi nào?';

  @override
  String get usRequestWhichChild => 'Trông bé nào?';

  @override
  String usRequestMinutes(int minutes) {
    return '$minutes phút';
  }

  @override
  String get usRequestNow => 'Bây giờ';

  @override
  String get usRequestTonight => 'Tối nay';

  @override
  String get usRequestChooseTime => 'Chọn giờ';

  @override
  String get usRequestOtherChild => 'Cả hai bé';

  @override
  String get usRequestNeeds => 'HOẶC MÌNH ĐANG CẦN…  (không tính Hearts)';

  @override
  String usRequestSendCount(String callName, int count) {
    return 'Gửi cho $callName · đang mở $count/5';
  }

  @override
  String usRequestFrom(String callName) {
    return 'Lời nhờ từ $callName';
  }

  @override
  String usRequestBy(String callName) {
    return '$callName nhờ bạn';
  }

  @override
  String get usRequestSoon => 'Sớm nhé';

  @override
  String get usRequestAcceptedTitle => 'Bạn đã nhận lời nhờ';

  @override
  String get usRequestReasonHint =>
      'Nếu hôm nay không được, chọn lý do (tuỳ chọn)';

  @override
  String get usRequestReasonMeeting => 'Anh đang họp';

  @override
  String get usRequestReasonLate => 'Về muộn';

  @override
  String get usRequestAccept => 'Nhận — để anh lo';

  @override
  String get usRequestDecline => 'Hôm nay không được';

  @override
  String usRequestDeclineNote(String callName) {
    return 'Từ chối không bị trừ điểm. $callName sẽ nhận một thông báo nhẹ nhàng.';
  }

  @override
  String usRequestSent(String callName) {
    return '$callName đã gửi';
  }

  @override
  String get usRequestViewed => 'Bạn đã xem';

  @override
  String get usRequestAcceptedShort => 'Bạn đã nhận';

  @override
  String get usRequestFinished => 'Đã xong';

  @override
  String get usRequestFinish => 'Đã xong ✓';

  @override
  String get commonCreateNew => 'Tạo mới';

  @override
  String get switcherViewBy => 'Xem theo';

  @override
  String switcherPregnancy(int number, String name) {
    return 'Thai #$number · $name';
  }

  @override
  String get switcherAllDescription => 'Mọi bé và khoảnh khắc chung';

  @override
  String get familyManageChildren => 'Quản lý các con';

  @override
  String careWeekday(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      'mon': 'T2',
      'tue': 'T3',
      'wed': 'T4',
      'thu': 'T5',
      'fri': 'T6',
      'sat': 'T7',
      'other': 'CN',
    });
    return '$_temp0';
  }

  @override
  String get notificationsFamily => 'Gia đình';

  @override
  String get memoriesSaveQuote => 'Lưu câu nói';

  @override
  String get pregnancyFirstPhoto => 'Ảnh đầu tiên của bé';

  @override
  String get pregnancyFirstPhotoHint => 'Tuỳ chọn · sẽ là ký ức “Chào đời”';

  @override
  String get pregnancyCompleteAnnounce => 'Hoàn tất & báo tin';

  @override
  String pregnancyWelcomeName(String name) {
    return 'Chào mừng $name!';
  }

  @override
  String get pregnancyShort => 'Thai kỳ';

  @override
  String get memoriesPerspectiveshort => 'Góc nhìn';

  @override
  String get pregnancyBumpWeeks => 'Bụng bầu theo tuần';

  @override
  String pregnancyFirstsFor(String child) {
    return 'Lần đầu của $child';
  }

  @override
  String get pregnancyBabyLetter => 'Thư cho bé';

  @override
  String get pregnancyBumpPhoto => 'Ảnh bụng';

  @override
  String usRequestHearts(int count) {
    return 'Xong việc bạn nhận +$count 💗 (chỉ bạn thấy)';
  }

  @override
  String usRequestReminder(String time) {
    return 'Nhắc mình lúc $time';
  }

  @override
  String get usRequestAcceptedBadge => 'Đã nhận';

  @override
  String get pregnancyPrepareBaby => 'Chuẩn bị đón bé';

  @override
  String get commonAll => 'Tất cả';

  @override
  String pregnancyCaptureWeek(int week) {
    return 'Chụp ảnh bụng tuần $week';
  }

  @override
  String get memoriesMarkMilestone => 'Đánh dấu cột mốc';

  @override
  String get careMine => 'Tôi';

  @override
  String get careTogether => 'Cùng nhau';

  @override
  String get careTodayShort => 'Hôm nay';

  @override
  String get carePrivateContribution => 'Chỉ bạn thấy';

  @override
  String usRequestRestTitle(int minutes, String child) {
    return 'Cần nghỉ $minutes phút — trông $child giúp';
  }

  @override
  String usRequestWatchTitle(int minutes, String child) {
    return 'Trông $child giúp $minutes phút';
  }

  @override
  String usRequestAllChildren(int count) {
    return 'Tất cả $count bé';
  }

  @override
  String usRequestMessagePreview(int minutes, String child) {
    return '“Em cần nghỉ khoảng $minutes phút. Anh trông $child giúp em nhé? 💛”';
  }

  @override
  String get quickCheckin => 'Check-in';

  @override
  String get quickThanks => 'Cảm ơn';

  @override
  String get careFinish => 'Xong';

  @override
  String carePartnerTab(String callName) {
    return 'Của $callName';
  }

  @override
  String get billingSupport => 'Hỗ trợ';

  @override
  String get homeChildLetter => 'Thư cho con';

  @override
  String commonAgeDays(int days) {
    return '$days ngày';
  }

  @override
  String commonAgeMonths(int months) {
    return '$months tháng';
  }

  @override
  String commonAgeMonthsDays(int months, int days) {
    return '$months tháng $days ngày';
  }

  @override
  String commonAgeYears(int years) {
    return '$years tuổi';
  }

  @override
  String commonAgeYearsMonths(int years, int months) {
    return '$years tuổi $months tháng';
  }

  @override
  String commonPregnancyWeekOnly(int week) {
    return 'Tuần $week';
  }

  @override
  String commonPregnancyWeekDay(int week, int day) {
    return 'Tuần $week + $day ngày';
  }

  @override
  String get commonScreenInProgress =>
      'Màn hình đang được dựng lại theo thiết kế.';

  @override
  String get stateOfflineTitle => 'Đang ngoại tuyến';

  @override
  String stateOfflineSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đang xem dữ liệu đã lưu · $count ký ức chờ tải lên',
      zero: 'Đang xem dữ liệu đã lưu',
    );
    return '$_temp0';
  }

  @override
  String get commonPlay => 'Phát';

  @override
  String get commonPause => 'Tạm dừng';

  @override
  String get commonMarkDone => 'Đánh dấu đã xong';

  @override
  String get commonNotifications => 'Thông báo';

  @override
  String get commonComingSoon => 'Sắp ra mắt';

  @override
  String commonQuoted(String text) {
    return '“$text”';
  }

  @override
  String get commonTimeJustNow => 'Vừa xong';

  @override
  String commonTimeMinutesAgo(int count) {
    return '$count phút trước';
  }

  @override
  String commonTimeHoursAgo(int count) {
    return '$count giờ trước';
  }

  @override
  String get commonTimeYesterday => 'hôm qua';

  @override
  String commonTimeDaysAgo(int count) {
    return '$count ngày trước';
  }

  @override
  String usMoodLabel(String mood) {
    String _temp0 = intl.Intl.selectLogic(mood, {
      'ok': 'Ổn',
      'normal': 'Bình thường',
      'tired': 'Mệt',
      'exhausted': 'Kiệt sức',
      'stressed': 'Áp lực',
      'sad': 'Buồn',
      'annoyed': 'Khó chịu',
      'overwhelmed': 'Quá tải',
      'lonely': 'Cô đơn',
      'missYou': 'Nhớ bạn',
      'other': 'Ổn',
    });
    return '$_temp0';
  }

  @override
  String usCheckinNeed(String need) {
    String _temp0 = intl.Intl.selectLogic(need, {
      'rest': 'Cần nghỉ ngơi',
      'childcare': 'Cần giúp trông con',
      'quiet': 'Cần yên tĩnh',
      'hug': 'Cần một cái ôm',
      'talk': 'Cần nói chuyện',
      'encouragement': 'Cần động viên',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String usCheckinNeedMinutes(String need, int minutes) {
    return '$need $minutes\'';
  }

  @override
  String get usMoodNotShared => 'Chưa chia sẻ';

  @override
  String usReplySent(String callName) {
    return 'Đã gửi tới $callName 💛';
  }

  @override
  String get usSettingsTooltip => 'Cài đặt Papa & Mama';

  @override
  String usOpenRequestWatch(String callName, String child, int minutes) {
    return 'Bạn nhờ $callName trông $child $minutes phút';
  }

  @override
  String usOpenRequestMine(String callName, String title) {
    return 'Bạn nhờ $callName: $title';
  }

  @override
  String usOpenRequestTheirs(String callName, String title) {
    return '$callName nhờ bạn: $title';
  }

  @override
  String usRequestStatusPartner(String status, String callName, String time) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'seen': '$callName đã xem · $time',
      'accepted': '$callName đã nhận · $time',
      'done': '$callName đã xong · $time',
      'declined': '$callName: hôm nay không được',
      'other': 'Đã gửi · $time',
    });
    return '$_temp0';
  }

  @override
  String usRequestStatusMine(String status, String time) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'accepted': 'Bạn đã nhận · $time',
      'other': 'Chờ bạn trả lời · $time',
    });
    return '$_temp0';
  }

  @override
  String get usDailyQuestionHintBoth =>
      'Câu trả lời của nhau chỉ hiện khi cả hai đã trả lời.';

  @override
  String get usDailyQuestionYourAnswer => 'Câu trả lời của bạn';

  @override
  String usDailyQuestionAnswerBy(String callName, String answer) {
    return '$callName: $answer';
  }

  @override
  String usThanksByLine(String callName, String time) {
    return '$callName · $time';
  }

  @override
  String get usYou => 'Bạn';

  @override
  String usRequestRestMessage(int minutes, String child) {
    return 'Em cần nghỉ khoảng $minutes phút. Anh trông $child giúp em nhé? 💛';
  }

  @override
  String usRequestWatchMessage(int minutes, String child) {
    return 'Anh trông $child giúp em khoảng $minutes phút nhé? 💛';
  }

  @override
  String usRequestReasonBusyWith(String child) {
    return 'Đang trông $child';
  }

  @override
  String usRequestYouAsked(String callName) {
    return 'Bạn nhờ $callName';
  }

  @override
  String get usRequestMineTitle => 'Lời nhờ của bạn';

  @override
  String get usRequestYouSent => 'Bạn đã gửi';

  @override
  String usRequestPartnerViewed(String callName) {
    return '$callName đã xem';
  }

  @override
  String usRequestPartnerAccepted(String callName) {
    return '$callName đã nhận';
  }

  @override
  String usRequestBadge(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'sent': 'Đã gửi',
      'seen': 'Đã xem',
      'accepted': 'Đã nhận',
      'done': 'Đã xong',
      'declined': 'Hôm nay không được',
      'acknowledged': 'Đã thấy',
      'expired': 'Hết hạn',
      'cancelled': 'Đã huỷ',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get usRequestCancel => 'Huỷ lời nhờ';

  @override
  String get usRequestThank => 'Gửi lời cảm ơn';

  @override
  String get usRequestDoMyself => 'Tự mình làm';

  @override
  String get usRequestSendHug => 'Gửi 🤗';

  @override
  String usThanksTitle(String callName) {
    return 'Cảm ơn $callName';
  }

  @override
  String get usThanksSamples => 'CÂU MẪU';

  @override
  String get usThanksSample1 => 'Cảm ơn vì đã trông con giúp mình 💛';

  @override
  String get usThanksSample2 => 'Cảm ơn vì hôm nay đã ở bên mình';

  @override
  String get usThanksSample3 => 'Có bạn, mọi việc nhẹ hơn nhiều';

  @override
  String get usThanksSticker => 'STICKER';

  @override
  String get usThanksPostFamily => 'Đề nghị đăng thành khoảnh khắc gia đình';

  @override
  String usThanksPostFamilyHint(String callName) {
    return 'Cần $callName đồng ý';
  }

  @override
  String usThanksSent(String callName) {
    return 'Đã gửi lời cảm ơn tới $callName 💛';
  }

  @override
  String get careTreeBloomed => 'Hôm nay nhà mình đã chăm con thật tròn đầy 🌸';

  @override
  String careOpenRequestFromPartner(int count, String callName, String title) {
    return '$count lời nhờ đang mở · $callName nhờ: $title';
  }

  @override
  String careOpenRequestToPartner(int count, String callName, String title) {
    return '$count lời nhờ đang mở · Bạn nhờ $callName: $title';
  }

  @override
  String get careMetaSuggested => 'Gợi ý hôm nay';

  @override
  String get careMetaCustom => 'Tự tạo';

  @override
  String careMetaHearts(int count) {
    return '+$count 💗';
  }

  @override
  String careMetaDoneAt(String time) {
    return 'Đã xong $time';
  }

  @override
  String carePartnerDoneAt(String time) {
    return 'Xong lúc $time';
  }

  @override
  String careCategory(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'care': 'Chăm sóc',
      'bonding': 'Gắn kết',
      'outing': 'Ra ngoài',
      'memory': 'Lưu kỷ niệm',
      'support': 'Hỗ trợ bạn đời',
      'self': 'Chăm bản thân',
      'together': 'Cả nhà',
      'couple': 'Hai ta',
      'other': 'Tự gõ',
    });
    return '$_temp0';
  }

  @override
  String careDurationMin(int minutes) {
    return '$minutes phút';
  }

  @override
  String carePartnerNote(String callName) {
    return 'Bạn chỉ xem được việc $callName đã làm. Hearts của $callName chỉ $callName thấy.';
  }

  @override
  String carePartnerAllDone(String callName, int count) {
    return '$callName đã xong cả $count việc hôm nay';
  }

  @override
  String get careThank => 'Cảm ơn';

  @override
  String get careThanked => 'Đã cảm ơn';

  @override
  String get careDoneTogether => 'Xong cùng nhau';

  @override
  String get careMineEmpty => 'Hôm nay bạn chưa có việc nào';

  @override
  String carePartnerEmpty(String callName) {
    return '$callName chưa có việc nào hôm nay';
  }

  @override
  String get careTogetherEmpty => 'Chưa có việc cùng nhau hôm nay';

  @override
  String careDoneSnack(String title) {
    return 'Đã xong “$title”';
  }

  @override
  String careSuggestFor(String name, String age) {
    return 'Gợi ý cho $name · $age';
  }

  @override
  String get careSuggestToday => 'Gợi ý hôm nay';

  @override
  String careCompleteDesc(String title, int photoHearts) {
    return '$title · cây hôm nay có thêm 1 chiếc lá 🍃 (+$photoHearts 💗 nếu lưu ảnh)';
  }

  @override
  String get careNoteHint => 'Ghi chú (tuỳ chọn)…';

  @override
  String get careLibraryLink => 'Thư viện';

  @override
  String get careLibraryTitle => 'Thư viện nhiệm vụ';

  @override
  String get careTitleHint => 'Việc gì?';

  @override
  String get careTomorrow => 'Ngày mai';

  @override
  String careRepeatOption(String repeat) {
    String _temp0 = intl.Intl.selectLogic(repeat, {
      'daily': 'Hằng ngày',
      'weekdays': 'Ngày thường',
      'weekends': 'Cuối tuần',
      'other': 'Không lặp',
    });
    return '$_temp0';
  }

  @override
  String careReminderOption(String reminder) {
    String _temp0 = intl.Intl.selectLogic(reminder, {
      'atTime': 'Nhắc đúng giờ',
      'before15': 'Nhắc trước 15 phút',
      'before30': 'Nhắc trước 30 phút',
      'before60': 'Nhắc trước 60 phút',
      'other': 'Không nhắc',
    });
    return '$_temp0';
  }

  @override
  String get careTimeAny => 'Giờ bất kỳ';

  @override
  String careTreeNextLevel(String name) {
    return 'Sắp tới $name 🌸';
  }

  @override
  String careTreeRewardLabel(String reward) {
    return 'Phần thưởng: $reward';
  }

  @override
  String careTreePercent(int percent) {
    return '$percent%';
  }

  @override
  String get careTreeContributionTitle => 'Bạn đã góp 🔒 Chỉ bạn thấy';

  @override
  String careHeartsValue(int count) {
    return '$count 💗';
  }

  @override
  String careHeartsPlus(int count) {
    return '+$count';
  }

  @override
  String careHistoryWhen(String day, String time) {
    return '$day · $time';
  }

  @override
  String careHistoryTogether(String day) {
    return 'Cùng nhau · $day';
  }

  @override
  String get careYesterday => 'Hôm qua';

  @override
  String careWeekdayLong(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      'mon': 'Thứ hai',
      'tue': 'Thứ ba',
      'wed': 'Thứ tư',
      'thu': 'Thứ năm',
      'fri': 'Thứ sáu',
      'sat': 'Thứ bảy',
      'other': 'Chủ nhật',
    });
    return '$_temp0';
  }

  @override
  String get careDetailTitle => 'Chi tiết nhiệm vụ';

  @override
  String get careComplete => 'Hoàn thành';

  @override
  String get careOwnerLabel => 'Người làm';

  @override
  String get careChildLabel => 'Cho bé';

  @override
  String get careTimeLabel => 'Thời gian';

  @override
  String get careMissionNotFound => 'Không tìm thấy nhiệm vụ này';

  @override
  String get careSwapAction => 'Đổi việc khác';

  @override
  String get commonJustNow => 'Vừa xong';

  @override
  String commonMinutesAgo(int count) {
    return '$count phút trước';
  }

  @override
  String commonHoursAgo(int count) {
    return '$count giờ trước';
  }

  @override
  String commonDaysAgo(int count) {
    return '$count ngày trước';
  }

  @override
  String famTrialSubtitle(int days, String date) {
    return 'Còn $days ngày · hết hạn $date';
  }

  @override
  String famStorageUsage(String used, String total) {
    return '$used GB / $total GB';
  }

  @override
  String get famPlanHouse => 'Gói House';

  @override
  String get famPlanFamily => 'Gói Family';

  @override
  String famPlanRenews(String date) {
    return 'Gia hạn $date';
  }

  @override
  String get famRoleFather => 'Bố';

  @override
  String get famRoleMother => 'Mẹ';

  @override
  String famPregnancySubtitle(int week, String date) {
    return 'Thai $week tuần · dự sinh $date';
  }

  @override
  String get famRelativePending => 'Đang chờ tham gia';

  @override
  String get famRelationOther => 'Khác…';

  @override
  String famInviteSlots(int used, int max) {
    return 'Gói Family · đã dùng $used/$max chỗ người thân';
  }

  @override
  String famPregnancyChild(String name) {
    return '$name (thai kỳ)';
  }

  @override
  String get famPhotosPermissionHint => 'Mức hiển thị “Cả nhà”';

  @override
  String get famCommentPermissionHint => 'Gửi lời chúc cho cháu';

  @override
  String get famPostPermissionHint => 'Papa/Mama duyệt trước khi hiện';

  @override
  String get famInviteNote =>
      'Người thân không xem được khu vực Papa & Mama và nội dung riêng tư.';

  @override
  String famInviteShared(String callName, String link) {
    return 'Đã tạo lời mời cho $callName: $link';
  }

  @override
  String subTrialLeft(int days) {
    return 'Dùng thử còn $days ngày';
  }

  @override
  String subBuy(String plan, String price) {
    return 'Nâng cấp $plan · $price';
  }

  @override
  String get subCurrentPlan => 'Gói hiện tại';

  @override
  String subPurchased(String plan) {
    return 'Nhà mình đã lên gói $plan 🎉';
  }

  @override
  String get subRestoreNone => 'Chưa tìm thấy giao dịch nào để khôi phục.';

  @override
  String subExpiredStats(int memories, int firsts, String names) {
    return 'Nhà mình đã lưu $memories ký ức và $firsts lần đầu của $names. Mọi thứ vẫn an toàn — nâng cấp để cả nhà tiếp tục ghi lại hành trình của các con.';
  }

  @override
  String subRetentionTitle(String date) {
    return 'Dữ liệu được giữ đến $date';
  }

  @override
  String get subExportStarted =>
      'Đang chuẩn bị dữ liệu, nhà mình sẽ nhận thông báo khi tải về được.';

  @override
  String setProfileSubtitle(String callName, String family) {
    return '$callName · $family';
  }

  @override
  String setAiQuota(int remaining, int total) {
    return '$remaining/$total lượt';
  }

  @override
  String get setPlanTrial => 'Dùng thử';

  @override
  String get setPlanExpired => 'Hết hạn';

  @override
  String setVersion(String version) {
    return 'v$version';
  }

  @override
  String setTextPreview(String name) {
    return '$name vừa đạt cột mốc mới: tự ngồi vững 🎉';
  }

  @override
  String cirHello(String callName) {
    return 'Chào $callName';
  }

  @override
  String cirTitle(String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': 'Cháu yêu của bà',
      'grandpa': 'Cháu yêu của ông',
      'other': 'Cháu yêu của cả nhà',
    });
    return '$_temp0';
  }

  @override
  String cirHeroCaption(String text, String author, String time) {
    return '“$text” — $author, $time';
  }

  @override
  String cirLiked(String name) {
    return 'Đã thả tim cho $name 💛';
  }

  @override
  String cirWishHint(String name) {
    return 'Viết lời chúc cho $name…';
  }

  @override
  String get cirWishSend => 'Gửi';

  @override
  String cirWishSent(String name) {
    return 'Đã gửi lời chúc cho $name';
  }

  @override
  String cirEmpty(String callName) {
    return 'Papa & Mama chưa đăng ảnh mới. $callName sẽ được báo khi có nhé.';
  }

  @override
  String pregJourneyTitle(String child) {
    return 'Hành trình của $child';
  }

  @override
  String pregJourneyStats(int days, int memories, int firsts) {
    return 'Còn $days ngày · $memories ký ức · $firsts lần đầu';
  }

  @override
  String get pregWeekThis => 'tuần này';

  @override
  String get pregWeekFirsts => 'Lần đầu';

  @override
  String pregBumpGhostHint(int week) {
    return 'Có bóng mờ tuần $week để giữ cùng góc chụp';
  }

  @override
  String pregWeekDayShort(int week, int day) {
    return 'Tuần $week + $day';
  }

  @override
  String pregPostedBy(String callName) {
    return '$callName đăng';
  }

  @override
  String pregUltrasoundWeek(int week) {
    return 'SIÊU ÂM · TUẦN $week';
  }

  @override
  String pregQuoted(String text) {
    return '“$text”';
  }

  @override
  String get pregFirstLabel => 'LẦN ĐẦU';

  @override
  String get pregMilestoneLater => 'Sẽ thành cột mốc của bé sau khi chào đời';

  @override
  String get pregMenuEdit => 'Sửa thai kỳ';

  @override
  String get pregMenuArchive => 'Lưu trữ';

  @override
  String pregBumpCompare(int from, int to) {
    return 'So sánh · Tuần $from → Tuần $to';
  }

  @override
  String pregWeekShort(int week) {
    return 'T$week';
  }

  @override
  String pregWeekCapture(int week) {
    return 'T$week · chụp';
  }

  @override
  String get pregUltrasoundAdd => 'Thêm ảnh siêu âm';

  @override
  String get pregUltrasoundEmpty => 'Chưa có ảnh siêu âm';

  @override
  String get pregUltrasoundEmptyHint =>
      'Lưu ảnh siêu âm theo tuần thai kèm lời nhắn.';

  @override
  String pregDaysLeft(int days) {
    return 'còn $days ngày';
  }

  @override
  String get pregGroupBag => 'Đồ đi sinh';

  @override
  String get pregGroupPapers => 'Giấy tờ';

  @override
  String get pregGroupNursery => 'Góc của bé';

  @override
  String get pregGroupHealth => 'Sức khoẻ';

  @override
  String pregOwnerRequested(String callName) {
    return 'Đã nhờ $callName';
  }

  @override
  String pregOwnerAsk(String callName) {
    return 'Nhờ $callName';
  }

  @override
  String get pregOwnerTitle => 'Ai lo mục này?';

  @override
  String get pregBirthCountTitle => 'Chúc mừng gia đình! Có mấy bé?';

  @override
  String pregBirthBabyCount(int count) {
    return '$count bé';
  }

  @override
  String get pregBirthWelcomeTitle => 'Chào mừng bé đến với nhà mình 🎉';

  @override
  String pregBirthBabyIndex(int index, int count) {
    return 'Bé $index/$count · thông tin này sửa lại được bất cứ lúc nào';
  }

  @override
  String pregBirthNameValue(String name, String nickname) {
    return '$name ($nickname)';
  }

  @override
  String get pregBirthWeightLabel => 'Cân nặng (chỉ lưu)';

  @override
  String pregKg(String value) {
    return '$value kg';
  }

  @override
  String pregCm(String value) {
    return '$value cm';
  }

  @override
  String pregBirthFamilyWelcomes(String family) {
    return '$family chào đón';
  }

  @override
  String pregBirthWelcomeName(String name) {
    return 'Chào mừng $name! 💜';
  }

  @override
  String pregBirthNickname(String nickname) {
    return '“$nickname” của cả nhà';
  }

  @override
  String pregBirthNicknameSiblings(String nickname, String siblings) {
    return '“$nickname” của cả nhà · em của $siblings';
  }

  @override
  String pregNamesAnd(String first, String last) {
    return '$first & $last';
  }

  @override
  String pregBirthAnnounceNote(String child) {
    return 'Chỉ người thân đang được chia sẻ thai kỳ. Ký ức thai kỳ trở thành chương mở đầu của $child.';
  }

  @override
  String get pregBirthDone => 'Hoàn tất & báo tin 🎉';

  @override
  String pregArchiveTitle(String child) {
    return 'Lưu trữ hành trình của $child';
  }

  @override
  String get pregNamesBothLike => 'Cả hai thích 💞';

  @override
  String pregNamesAddedBy(String callName) {
    return 'Thêm bởi $callName';
  }

  @override
  String pregNamesLikeBy(String callName) {
    return '$callName thích';
  }

  @override
  String get authNameHint => 'Nhập tên';

  @override
  String authResendIn(String time) {
    return 'Gửi lại mã sau $time';
  }

  @override
  String authCountryCodeSemantics(String code) {
    return 'Mã quốc gia $code';
  }

  @override
  String get authChangeAvatar => 'Chọn ảnh đại diện';

  @override
  String onbFamilyDefaultName(String name) {
    return 'Nhà $name';
  }

  @override
  String onbMemberLabel(String callName, String name) {
    return '$callName $name';
  }

  @override
  String onbFamilyCoverWaiting(String member, String partnerCallName) {
    return '$member · đang chờ $partnerCallName';
  }

  @override
  String get onbFamilySuggestion1 => 'Nhà Cà Chua';

  @override
  String get onbFamilySuggestion2 => 'Tổ ấm nhỏ';

  @override
  String get onbFamilySuggestion3 => 'Nhà mình';

  @override
  String get onbChangeCover => 'Đổi ảnh bìa';

  @override
  String onbInviteSubtitle(String callName, int days) {
    return 'Baby Family cần cả Papa và Mama. Khi $callName tham gia, nhà mình bắt đầu $days ngày dùng thử miễn phí.';
  }

  @override
  String onbInviteApproval(String callName) {
    return 'Tôi xác nhận lần cuối khi $callName tham gia';
  }

  @override
  String onbInviteShareMessage(String code, String link) {
    return 'Vào Baby Family cùng mình lưu giữ hành trình của con nhé! Mã mời: $code · $link';
  }

  @override
  String onbWaitingSubtitle(String callName, int days) {
    return 'Khi $callName nhận lời mời, nhà mình sẽ được mở khoá và bắt đầu $days ngày dùng thử miễn phí.';
  }

  @override
  String onbWaitingSentAt(String time) {
    return 'Đã gửi lời mời lúc $time';
  }

  @override
  String onbWaitingOpened(String callName) {
    return '$callName đã mở link mời';
  }

  @override
  String onbWaitingExpires(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hết hạn sau $count ngày',
      zero: 'Hết hạn hôm nay',
    );
    return '$_temp0';
  }

  @override
  String get onbCancelFamilyMessage =>
      'Bạn sẽ quay lại bước chọn vai trò. Lời mời đã gửi sẽ không còn hiệu lực.';

  @override
  String onbTrialUntil(String date) {
    return 'Đến hết ngày $date · không cần thẻ thanh toán';
  }

  @override
  String onbTrialAfter(String housePrice, String familyPrice) {
    return 'Sau đó chọn gói House ($housePrice) hoặc Family ($familyPrice) để tiếp tục.';
  }

  @override
  String onbStageSubtitle(String first, String second) {
    return '$first và $second có thể thêm bé hoặc thai kỳ khác bất cứ lúc nào.';
  }

  @override
  String get onbStageBothDescription =>
      'Hồ sơ các bé và thai kỳ chạy song song trong cùng gia đình';

  @override
  String get onbNicknameIdea1 => 'Đậu';

  @override
  String get onbNicknameIdea2 => 'Cà Chua';

  @override
  String get onbNicknameIdea3 => 'Mít';

  @override
  String get onbNicknameIdea4 => 'Sóc';

  @override
  String onbMeetCountdown(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Còn $count ngày nữa gặp $name',
      zero: 'Hôm nay gặp $name',
    );
    return '$_temp0';
  }

  @override
  String get onbKnowDueDate => 'Mình biết ngày dự sinh';

  @override
  String onbWeekValue(int week) {
    return 'Tuần $week';
  }

  @override
  String onbNotifMeta(String time) {
    return 'Baby Family · $time';
  }

  @override
  String get onbNotifNow => 'bây giờ';

  @override
  String get onbNotif5Minutes => '5 phút trước';

  @override
  String get onbNotif1Hour => '1 giờ trước';

  @override
  String onbNotifRequestTitle(String sender, String receiver, String child) {
    return '$sender nhờ $receiver: Tắm cho $child tối nay';
  }

  @override
  String get onbNotifRequestBody =>
      'Nhận hoặc đề xuất giờ khác chỉ với một chạm.';

  @override
  String onbNotifPhotosTitle(String child) {
    return 'Có 3 ảnh mới của $child hôm nay';
  }

  @override
  String get onbNotifPhotosBody => 'Bà nội đã thả tim 2 ảnh.';

  @override
  String get onbNotifUsTitle => 'Bạn có cập nhật mới từ Papa & Mama';

  @override
  String get onbNotifUsBody => 'Nội dung riêng tư được ẩn trên màn hình khoá.';

  @override
  String get onbNotifChildFallback => 'bé';

  @override
  String onbFirstMemorySubtitle(String name) {
    return 'Lưu khoảnh khắc đầu tiên của $name trong Baby Family.';
  }

  @override
  String invInviterParent(String name, String callName) {
    return '$name ($callName) mời bạn tham gia';
  }

  @override
  String invInviterRelative(String name, String callName, String pronoun) {
    return '$name ($callName) mời $pronoun theo dõi cháu';
  }

  @override
  String invQuotedMessage(String message) {
    return '“$message”';
  }

  @override
  String invRoleParent(String callName) {
    return 'Vai trò của bạn: $callName của các bé';
  }

  @override
  String invRoleRelative(String callName, String permission) {
    return '$callName · $permission';
  }

  @override
  String invPronoun(String relation) {
    String _temp0 = intl.Intl.selectLogic(relation, {
      'grandmaPaternal': 'bà',
      'grandmaMaternal': 'bà',
      'grandpaPaternal': 'ông',
      'grandpaMaternal': 'ông',
      'other': 'bạn',
    });
    return '$_temp0';
  }

  @override
  String invPronounTitle(String relation) {
    String _temp0 = intl.Intl.selectLogic(relation, {
      'grandmaPaternal': 'Bà',
      'grandmaMaternal': 'Bà',
      'grandpaPaternal': 'Ông',
      'grandpaMaternal': 'Ông',
      'other': 'Bạn',
    });
    return '$_temp0';
  }

  @override
  String get invParentSees => 'Bạn sẽ thấy: ký ức, nhiệm vụ, Papa & Mama';

  @override
  String invParentManage(String callName) {
    return 'Cùng $callName quản lý gia đình và mời người thân';
  }

  @override
  String invParentApproval(String member) {
    return '$member sẽ xác nhận lần cuối khi bạn tham gia';
  }

  @override
  String invRelativeSees(String pronoun, String names) {
    return '$pronoun sẽ thấy: ảnh, video, những lần đầu của $names';
  }

  @override
  String invRelativeHiddenChildren(String pronoun, String names) {
    return '$pronoun sẽ không thấy: $names, Papa & Mama, nhiệm vụ';
  }

  @override
  String invRelativeHidden(String pronoun) {
    return '$pronoun sẽ không thấy: Papa & Mama, nhiệm vụ';
  }

  @override
  String invRelativeApproval(String pronoun) {
    return 'Ảnh $pronoun đăng sẽ được Papa/Mama duyệt trước khi hiển thị';
  }

  @override
  String get invViewOnly => 'Chỉ xem';

  @override
  String get homeMorning => 'Chào buổi sáng,';

  @override
  String get homeAfternoon => 'Chào buổi chiều,';

  @override
  String homeGreetingName(String callName, String name, String emoji) {
    return '$callName $name $emoji';
  }

  @override
  String get homeMonthlyToday => 'HÔM NAY';

  @override
  String homeMonthlyInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'CÒN $count NGÀY',
    );
    return '$_temp0';
  }

  @override
  String homeMonthlyTurns(String name, int months) {
    return '$name tròn $months tháng 🎉';
  }

  @override
  String homeMonthlyPrepare(int done, int total) {
    return 'Chuẩn bị chụp ảnh tháng — đã có $done/$total ảnh';
  }

  @override
  String homeMoodTitle(String callName, String mood) {
    String _temp0 = intl.Intl.selectLogic(mood, {
      'ok': 'đang ổn',
      'normal': 'bình thường',
      'tired': 'đang mệt',
      'exhausted': 'kiệt sức',
      'stressed': 'đang căng thẳng',
      'sad': 'đang buồn',
      'annoyed': 'đang bực',
      'overwhelmed': 'đang quá tải',
      'lonely': 'thấy cô đơn',
      'missYou': 'đang nhớ bạn',
      'other': 'đã check-in',
    });
    return '$callName $_temp0';
  }

  @override
  String homeNeedLabel(String need) {
    String _temp0 = intl.Intl.selectLogic(need, {
      'rest': 'Cần nghỉ ngơi',
      'childcare': 'Cần trông con giúp',
      'quiet': 'Cần yên tĩnh',
      'hug': 'Cần một cái ôm',
      'talk': 'Muốn nói chuyện',
      'encouragement': 'Cần động viên',
      'other': 'Cần hỗ trợ',
    });
    return '$_temp0';
  }

  @override
  String homeNeedMinutes(String need, int minutes) {
    return '$need khoảng $minutes phút';
  }

  @override
  String homeFamilyProgress(int done, int total) {
    return '$done/$total việc của nhà mình';
  }

  @override
  String homePromptKicker(String name, String age) {
    return 'Gợi ý ghi lại · $name $age';
  }

  @override
  String homeFeedAddedPhotos(String callName, int count, String name) {
    return '$callName vừa thêm $count ảnh của $name';
  }

  @override
  String homeMorePhotos(int count) {
    return '+$count';
  }

  @override
  String homeRecordedBy(String callName, String time) {
    return '$callName ghi lại $time';
  }

  @override
  String homeReactedBy(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$name và $count người khác',
      zero: '$name',
    );
    return '$_temp0';
  }

  @override
  String homePostedBy(String callName) {
    return '$callName đăng';
  }

  @override
  String homePerspectiveQuote(String callName, String text) {
    return '$callName kể: “$text”';
  }

  @override
  String homeTreeProgress(String name, int percent, String next) {
    return '$name · $percent% tới $next 🌸';
  }

  @override
  String homeChildBorn(String age, String date) {
    return '$age · sinh $date';
  }

  @override
  String homeChildBornLunar(String age, String date, int day, int month) {
    return '$age · sinh $date ($day/$month âm lịch)';
  }

  @override
  String homeChildCountdown(int count, int months) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Còn $count ngày nữa tròn $months tháng',
      zero: 'Hôm nay tròn $months tháng',
    );
    return '$_temp0';
  }

  @override
  String homeMonthlySlot(int month) {
    return 'Ảnh tháng $month';
  }

  @override
  String homeChapterTitle(int month, String name) {
    return 'Tháng thứ $month của $name';
  }

  @override
  String homeChapterStats(int memories, int firsts, int voices) {
    return '$memories ký ức · $firsts lần đầu · $voices đoạn ghi âm';
  }

  @override
  String get homeMonthlyGrowth => 'Con lớn từng tháng';

  @override
  String homeTrimester(int number) {
    return 'Tam cá nguyệt $number';
  }

  @override
  String homeDaysToMeet(int count, String name) {
    return 'Còn $count ngày gặp $name 💜';
  }

  @override
  String homeDueDate(String date) {
    return 'Dự sinh $date';
  }

  @override
  String homeFetalSize(String name, String fruit, int cm) {
    return 'Tuần này $name to cỡ $fruit · khoảng $cm cm';
  }

  @override
  String get homeReference => 'tham khảo';

  @override
  String get homeCapture => 'Chụp';

  @override
  String homeWeekShort(int week) {
    return 'T$week';
  }

  @override
  String homeBothTellWeek(int week) {
    return 'Cả hai cùng kể · Tuần $week';
  }

  @override
  String homeProgressCount(int done, int total) {
    return '$done/$total';
  }

  @override
  String homeNamesSummary(int count, int liked) {
    return '$count tên dự định · $liked tên cả hai cùng thích 💞';
  }

  @override
  String switcherPregnancyLabel(String name, int week) {
    return '$name · Tuần $week';
  }

  @override
  String get commonLastNight => 'tối qua';

  @override
  String get commonYesterdayLower => 'hôm qua';

  @override
  String commonDotJoin(String first, String second) {
    return '$first · $second';
  }

  @override
  String commonNamesAnd(String first, String second) {
    return '$first & $second';
  }

  @override
  String commonMissionCategory(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'care': 'Chăm sóc',
      'bonding': 'Gắn kết',
      'outing': 'Đi chơi',
      'memory': 'Ký ức',
      'support': 'Hỗ trợ',
      'self': 'Tự chăm',
      'together': 'Cùng nhau',
      'couple': 'Hai ta',
      'custom': 'Tự tạo',
      'other': 'Nhiệm vụ',
    });
    return '$_temp0';
  }

  @override
  String get commonSuggestedToday => 'Gợi ý hôm nay';

  @override
  String commonHeartsPlus(int count) {
    return '+$count 💗';
  }

  @override
  String get memJustNow => 'Vừa xong';

  @override
  String memMinutesAgo(int count) {
    return '$count phút trước';
  }

  @override
  String memHoursAgo(int count) {
    return '$count giờ trước';
  }

  @override
  String get memYesterday => 'Hôm qua';

  @override
  String get memTodayLower => 'hôm nay';

  @override
  String memTodayAt(String time) {
    return 'Hôm nay, $time';
  }

  @override
  String memYesterdayAt(String time) {
    return 'Hôm qua, $time';
  }

  @override
  String memDateAt(String date, String time) {
    return '$date, $time';
  }

  @override
  String get memSearch => 'Tìm kiếm ký ức';

  @override
  String get memFilterVoice => 'Ghi âm';

  @override
  String memChildStats(int memories, int firsts, int voices) {
    return '$memories ký ức · $firsts lần đầu · $voices đoạn ghi âm';
  }

  @override
  String memChapterRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String memChapterCurrent(String range) {
    return '$range · ĐANG DIỄN RA';
  }

  @override
  String memChapterTitle(int month, String name) {
    return 'Tháng thứ $month của $name';
  }

  @override
  String memChapterStats(int memories, int firsts, int voices) {
    return '$memories ký ức · $firsts lần đầu · $voices ghi âm';
  }

  @override
  String memChapterStatsMonthly(int memories, int firsts) {
    return '$memories ký ức · $firsts lần đầu · ảnh tháng ✓';
  }

  @override
  String get memChapterReplay => 'Xem lại tháng này';

  @override
  String memDueIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Còn $days ngày',
      one: 'Ngày mai',
      zero: 'Hôm nay',
    );
    return '$_temp0';
  }

  @override
  String memMonthlyNextIn(int days, int month) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Tháng $month · còn $days ngày',
      one: 'Tháng $month · ngày mai',
      zero: 'Tháng $month · hôm nay',
    );
    return '$_temp0';
  }

  @override
  String memCardMeta(String children, String author, String time) {
    return '$children · $author đăng · $time';
  }

  @override
  String memBothTellPreview(String callName, String text) {
    return '$callName kể: “$text”';
  }

  @override
  String memQuotedBy(String body, String author) {
    return '“$body” · $author';
  }

  @override
  String get memFirstTime => 'Lần đầu tiên';

  @override
  String memFirstMeta(String age, String who) {
    return '$age · $who';
  }

  @override
  String memBothParentsTell(String first, String second) {
    return '$first & $second cùng kể';
  }

  @override
  String memAuthorTells(String callName) {
    return '$callName kể';
  }

  @override
  String memQuoteMeta(String name, String age, String callName, String when) {
    return '$name · $age · $callName ghi lại $when';
  }

  @override
  String memLetterSealed(String date) {
    return 'Niêm phong tới $date';
  }

  @override
  String memCollMonthly(String name, int count, int total) {
    return '$name · $count/$total ảnh';
  }

  @override
  String memCollFirsts(int count) {
    return '$count cột mốc';
  }

  @override
  String memCollQuotes(String name, int count) {
    return '$name · $count câu';
  }

  @override
  String memCollVoices(int count) {
    return '$count đoạn ghi âm';
  }

  @override
  String memCollLetters(int count, int sealed) {
    return '$count thư · $sealed niêm phong';
  }

  @override
  String memCollBest(int count) {
    return 'Cả hai cùng thích · $count';
  }

  @override
  String memCollKeepsakes(int count) {
    return '$count đồ vật';
  }

  @override
  String get memComposerDiary => 'Viết nhật ký';

  @override
  String get memComposerMilestone => 'Ghi cột mốc';

  @override
  String get memComposerVoice => 'Ghi âm mới';

  @override
  String get memComposerKeepsake => 'Kỷ vật mới';

  @override
  String memComposerMonthly(int month, String name) {
    return 'Ảnh tháng $month · $name';
  }

  @override
  String memAudienceRelatives(int count) {
    return 'Cả nhà · $count người thân';
  }

  @override
  String memAudiencePeople(int count) {
    return 'Cả nhà · $count người';
  }

  @override
  String get memChooseMilestone => 'Chọn cột mốc';

  @override
  String get memDiaryTitleHint => 'Tiêu đề trang nhật ký';

  @override
  String get memDiaryBodyHint => 'Hôm nay nhà mình thế nào?';

  @override
  String get memLetterTo => 'Gửi tới';

  @override
  String get memLetterBodyHint => 'Con yêu, bố mẹ muốn kể con nghe…';

  @override
  String get memLetterOpenDate => 'Hẹn ngày mở';

  @override
  String get memLetterOpenNone => 'Không';

  @override
  String get memVoiceTapToRecord => 'Chạm để ghi âm';

  @override
  String memVoiceRecorded(String duration) {
    return 'Đã ghi âm · $duration';
  }

  @override
  String get memVoiceRecording => 'Đang ghi… chạm để dừng';

  @override
  String get memVoiceMicDenied =>
      'Cần quyền micro để ghi âm — bật trong Cài đặt của máy';

  @override
  String get memPeopleLabel => 'Ai ở đó';

  @override
  String get memPeopleChoose => 'Chọn người';

  @override
  String get memPeopleAddName => 'Thêm tên';

  @override
  String get memFeelingLabel => 'Cảm xúc của khoảnh khắc';

  @override
  String get memFeelingChoose => 'Chọn cảm xúc';

  @override
  String get memFeelingNone => 'Không chọn';

  @override
  String memFeeling(String feeling) {
    String _temp0 = intl.Intl.selectLogic(feeling, {
      'love': 'Thương yêu',
      'joy': 'Vui vẻ',
      'touched': 'Xúc động',
      'surprised': 'Bất ngờ',
      'peaceful': 'Bình yên',
      'proud': 'Tự hào',
      'other': '$feeling',
    });
    return '$_temp0';
  }

  @override
  String get memLocationLabel => 'Địa điểm';

  @override
  String get memLocationAdd => 'Thêm địa điểm';

  @override
  String get memLocationHint => 'Ví dụ: Nhà bà nội, Biển Vũng Tàu';

  @override
  String get memKeepsakeTitleHint => 'Tên kỷ vật';

  @override
  String get memKeepsakeHint => 'Câu chuyện của món đồ này…';

  @override
  String get memVisibilityFamilyTag => '👨‍👩‍👧‍👦 Cả nhà';

  @override
  String get memVisibilityParentsTag => '👫 Chỉ Papa & Mama';

  @override
  String get memVisibilityOnlyMeTag => '🔒 Chỉ mình tôi';

  @override
  String memSecondPerspective(String time) {
    return 'Góc nhìn thứ hai · $time';
  }

  @override
  String memCommentsCount(int count) {
    return 'Bình luận ($count)';
  }

  @override
  String get memMenuFavorite => 'Yêu thích';

  @override
  String get memMenuUnfavorite => 'Bỏ yêu thích';

  @override
  String get memEditPerspective => 'Sửa góc nhìn của bạn';

  @override
  String get memMoreActions => 'Thêm thao tác';

  @override
  String get memPregnancyAlbum => 'Thai kỳ';

  @override
  String memMonthCell(int month) {
    return 'Tháng $month';
  }

  @override
  String memGhostToggle(int month, int percent) {
    return 'Bóng mờ tháng $month · $percent%';
  }

  @override
  String get memStickerNone => 'Không';

  @override
  String get memFlipCamera => 'Đổi camera';

  @override
  String get memBrightness => 'Độ sáng';

  @override
  String memQuoteAge(String name, String age, String when) {
    return '— $name, $age · $when';
  }

  @override
  String get memQuoteContextLabel => 'Con nói khi nào? (tuỳ chọn)';

  @override
  String get memQuoteContextHint => 'Lúc đi dạo buổi tối, nhìn lên trời';

  @override
  String memOriginalTag(String callName, String when) {
    return '$callName kể · $when';
  }

  @override
  String memInheritedAudience(String audience) {
    return 'Người xem giống ký ức gốc: $audience';
  }

  @override
  String memStoryMeta(String callName, String time, int index, int total) {
    return '$callName đăng · $time · $index/$total';
  }

  @override
  String memStoryReply(String callName) {
    return 'Trả lời $callName…';
  }

  @override
  String get memFirstsTitle => 'Những lần đầu';

  @override
  String get memFirstsHideMissing => 'Ẩn cột mốc chưa có';

  @override
  String get memFirstsAdd => 'Chạm để ghi lại';

  @override
  String get homeOpenFamily => 'Gia đình mình';

  @override
  String get homeChangeCover => 'Đổi ảnh bìa';

  @override
  String get authCodeResent => 'Đã gửi lại mã';

  @override
  String commonLunarYear(String stem, String branch) {
    String _temp0 = intl.Intl.selectLogic(stem, {
      '0': 'Giáp',
      '1': 'Ất',
      '2': 'Bính',
      '3': 'Đinh',
      '4': 'Mậu',
      '5': 'Kỷ',
      '6': 'Canh',
      '7': 'Tân',
      '8': 'Nhâm',
      '9': 'Quý',
      'other': '',
    });
    String _temp1 = intl.Intl.selectLogic(branch, {
      '0': 'Tý',
      '1': 'Sửu',
      '2': 'Dần',
      '3': 'Mão',
      '4': 'Thìn',
      '5': 'Tỵ',
      '6': 'Ngọ',
      '7': 'Mùi',
      '8': 'Thân',
      '9': 'Dậu',
      '10': 'Tuất',
      '11': 'Hợi',
      'other': '',
    });
    return '$_temp0 $_temp1';
  }

  @override
  String commonLunarDate(int day, int month) {
    return '$day/$month âm lịch';
  }

  @override
  String commonAgeDaysOld(int days) {
    return '$days ngày tuổi';
  }

  @override
  String commonAgeWeeks(int weeks) {
    return '$weeks tuần';
  }

  @override
  String commonAgeWeeksDays(int weeks, int days) {
    return '$weeks tuần $days ngày';
  }

  @override
  String get memAlbumDetailTitle => 'Chi tiết album';

  @override
  String get memPhotoViewerTitle => 'Xem ảnh';

  @override
  String get memVideoPlay => 'Phát video';

  @override
  String get memVideoPause => 'Tạm dừng video';

  @override
  String get memSearchTitle => 'Tìm kiếm';

  @override
  String get memOnThisDayTitle => 'Ngày này năm xưa';

  @override
  String get recapWeekTitle => 'Tuần của nhà mình';

  @override
  String recapWeekHeadline(int moments, int firsts) {
    String _temp0 = intl.Intl.pluralLogic(
      moments,
      locale: localeName,
      other: '$moments khoảnh khắc',
      zero: 'Một tuần bình yên',
    );
    String _temp1 = intl.Intl.pluralLogic(
      firsts,
      locale: localeName,
      other: ' · $firsts lần đầu',
      zero: '',
    );
    return '$_temp0$_temp1';
  }

  @override
  String get calendarTitle => 'Lịch';

  @override
  String get calendarCreateEvent => 'Tạo sự kiện';

  @override
  String get careHistoryTitle => 'Lịch sử';

  @override
  String get careBadgesTitle => 'Huy hiệu của nhà mình';

  @override
  String get careSettingsTitle => 'Cài đặt nhiệm vụ';

  @override
  String get childProfileTitle => 'Hồ sơ bé';

  @override
  String get childEditTitle => 'Sửa hồ sơ bé';

  @override
  String get childAddTitle => 'Thêm bé';

  @override
  String get familyRelativeDetailTitle => 'Chi tiết người thân';

  @override
  String get familySettingsTitle => 'Cài đặt gia đình';

  @override
  String get settingsProfileTitle => 'Hồ sơ';

  @override
  String memoriesYearOrdinal(String year) {
    String _temp0 = intl.Intl.selectLogic(year, {
      '1': 'Năm đầu tiên',
      '2': 'Năm thứ hai',
      '3': 'Năm thứ ba',
      'other': 'Năm thứ $year',
    });
    return '$_temp0';
  }

  @override
  String careWeekdayTitle(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      'mon': 'Thứ Hai',
      'tue': 'Thứ Ba',
      'wed': 'Thứ Tư',
      'thu': 'Thứ Năm',
      'fri': 'Thứ Sáu',
      'sat': 'Thứ Bảy',
      'other': 'Chủ Nhật',
    });
    return '$_temp0';
  }

  @override
  String calendarDayTitle(String weekday, String date) {
    return '$weekday, $date';
  }

  @override
  String calendarMonthYear(String month, String year) {
    return 'Tháng $month, $year';
  }

  @override
  String get calendarModeWeek => 'Tuần';

  @override
  String get calendarModeMonth => 'Tháng';

  @override
  String get calendarLegendMission => 'Nhiệm vụ';

  @override
  String get calendarLegendEvent => 'Sự kiện';

  @override
  String get calendarLegendCouple => 'Hai ta';

  @override
  String get calendarLunar => 'Âm lịch';

  @override
  String calendarLunarShort(String day, String month) {
    return '$day/$month';
  }

  @override
  String get calendarToday => 'Hôm nay';

  @override
  String calendarItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mục',
    );
    return '$_temp0';
  }

  @override
  String get calendarAllDay => 'Cả ngày';

  @override
  String calendarKindLabel(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'family': 'Sự kiện gia đình',
      'child': 'Sự kiện của bé',
      'couple': 'Hẹn hai ta',
      'anniversary': 'Nhắc kỷ niệm',
      'health': 'Ghi chú khám/tiêm',
      'other': 'Nhiệm vụ',
    });
    return '$_temp0';
  }

  @override
  String calendarOwnerLabel(String owner, String callName) {
    String _temp0 = intl.Intl.selectLogic(owner, {
      'me': 'của tôi',
      'together': 'cùng nhau',
      'other': 'của $callName',
    });
    return '$_temp0';
  }

  @override
  String get calendarCoupleOnly => 'Chỉ hai bạn thấy';

  @override
  String get calendarEmptyDay =>
      'Ngày này chưa có gì. Thêm một sự kiện hay nhiệm vụ nhé?';

  @override
  String get calendarAddEvent => 'Sự kiện';

  @override
  String get calendarAddMission => 'Nhiệm vụ';

  @override
  String get calendarAddMenu => 'Thêm vào lịch';

  @override
  String get calendarPrevMonth => 'Tháng trước';

  @override
  String get calendarNextMonth => 'Tháng sau';

  @override
  String get calendarEventType => 'Loại sự kiện';

  @override
  String calendarEventKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'child': 'Của bé',
      'family': 'Gia đình',
      'couple': 'Hai ta',
      'anniversary': 'Nhắc kỷ niệm',
      'other': 'Ghi chú khám/tiêm',
    });
    return '$_temp0';
  }

  @override
  String get calendarEventTypeHint =>
      'Bố Mẹ luôn thấy. Người thân chỉ thấy khi bạn chọn “Mời cả nhà”.';

  @override
  String get calendarDate => 'Ngày';

  @override
  String get calendarUseLunar => 'Dùng ngày Âm lịch';

  @override
  String calendarLunarDayName(String day, String month) {
    String _temp0 = intl.Intl.selectLogic(day, {
      '15': 'Rằm tháng $month âm lịch',
      '1': 'Mùng 1 tháng $month âm lịch',
      'other': 'Ngày $day tháng $month âm lịch',
    });
    return '$_temp0';
  }

  @override
  String calendarThisYear(String date) {
    return 'Năm nay: $date';
  }

  @override
  String get calendarRepeatYearly => 'Lặp lại hằng năm';

  @override
  String get calendarRepeatByLunar => 'Theo ngày âm lịch';

  @override
  String get calendarRepeatBySolar => 'Theo ngày dương lịch';

  @override
  String get calendarTime => 'Giờ';

  @override
  String get calendarRelatedChildren => 'Bé liên quan (tuỳ chọn)';

  @override
  String get calendarParticipants => 'Người tham gia';

  @override
  String get calendarInviteFamily => 'Mời cả nhà';

  @override
  String get calendarFamilyPlanTag => 'Gói Family';

  @override
  String get calendarInviteFamilyHint =>
      'Ông bà, người thân cũng thấy sự kiện này';

  @override
  String get calendarReminders => 'Nhắc';

  @override
  String calendarReminder(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'dayBefore0900': 'Trước 1 ngày, 9:00',
      'morning': 'Sáng hôm đó',
      'atTime': 'Đúng giờ',
      'hourBefore': 'Trước 1 giờ',
      'other': 'Trước 1 tuần',
    });
    return '$_temp0';
  }

  @override
  String get calendarAddReminder => 'Thêm';

  @override
  String get calendarNote => 'Ghi chú';

  @override
  String get calendarNoteHint => 'Thêm ghi chú…';

  @override
  String get calendarSaveEvent => 'Lưu sự kiện';

  @override
  String get calendarEventSaved => 'Đã lưu sự kiện';

  @override
  String get careHistoryAll => 'Tất cả';

  @override
  String get careHistoryCategory => 'Loại';

  @override
  String get careHistoryLegendMine => 'Của tôi';

  @override
  String careHistoryLegendPartner(String callName) {
    return 'Của $callName (đã xong)';
  }

  @override
  String careHistoryToday(String date) {
    return 'Hôm nay · $date';
  }

  @override
  String careHistoryYesterday(String date) {
    return 'Hôm qua · $date';
  }

  @override
  String careHistoryDate(String weekday, String date) {
    return '$weekday $date';
  }

  @override
  String careHistoryLunar(String day, String month) {
    return '$day/$month âm';
  }

  @override
  String careHistoryPartnerDone(String callName) {
    return '$callName · đã xong';
  }

  @override
  String careHistoryTogetherDone(String couple, String time) {
    String _temp0 = intl.Intl.selectLogic(couple, {
      'yes': 'Hai ta',
      'other': 'Cùng nhau',
    });
    return '$_temp0 · đã xong $time';
  }

  @override
  String get careHistoryMissed => 'Không kịp làm';

  @override
  String careHistoryNote(String callName) {
    return 'Hearts chỉ hiện trên việc của bạn. Việc của $callName chỉ hiện khi đã xong.';
  }

  @override
  String get careHistoryEmpty => 'Chưa có việc nào trong lịch sử';

  @override
  String careCategoryName(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'care': 'Chăm sóc',
      'bonding': 'Gắn kết',
      'play': 'Vui chơi',
      'outing': 'Ra ngoài',
      'memory': 'Lưu kỷ niệm',
      'support': 'Hỗ trợ bạn đời',
      'self': 'Chăm bản thân',
      'chores': 'Việc nhà của bé',
      'other': 'Khác',
    });
    return '$_temp0';
  }

  @override
  String get careBadgesSubtitle =>
      'Ghi nhận những thói quen đẹp cả nhà cùng làm — không so sánh, không chấm điểm ai.';

  @override
  String careBadgesUnlocked(int done, int total) {
    return 'Đã mở $done / $total huy hiệu';
  }

  @override
  String careBadgesLatest(String title, String date) {
    return 'Gần nhất: $title · $date';
  }

  @override
  String get careBadgesEarned => 'Đã đạt';

  @override
  String get careBadgesUpcoming => 'Sắp mở';

  @override
  String careBadgeAchievedOn(String date) {
    return 'Đạt $date';
  }

  @override
  String get careSettingsLevelSection => 'Mức nhiệm vụ hằng ngày của cả nhà';

  @override
  String careSettingsLevel(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      'light': 'Nhẹ',
      'medium': 'Vừa',
      'other': 'Nhiều',
    });
    return '$_temp0';
  }

  @override
  String get careSettingsPerPerson => 'việc / người';

  @override
  String careSettingsTogether(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      'light': '0–1 việc cùng nhau',
      'other': '1 việc cùng nhau',
    });
    return '$_temp0';
  }

  @override
  String get careSettingsDefault => 'Mặc định';

  @override
  String careSettingsLevelNote(String partner, String me) {
    return 'Áp dụng cho cả $partner và $me — hai bảng luôn bằng nhau. $partner sẽ nhận một thông báo nhẹ khi bạn đổi.';
  }

  @override
  String get careSettingsCategoriesSection => 'Loại việc tôi muốn nhận';

  @override
  String get careSettingsCategoriesHint =>
      'Tắt bớt loại nào, bảng vẫn đủ số việc từ những loại còn lại. Chỉ áp dụng cho bảng của bạn.';

  @override
  String get careSettingsTimingSection => 'Giờ giấc & nhắc';

  @override
  String get careSettingsBoardTime => 'Giờ nhận bảng nhiệm vụ';

  @override
  String careSettingsBoardTimeHint(int count) {
    return 'Thông báo “Hôm nay bạn có $count việc nhỏ…”';
  }

  @override
  String careSettingsAskAtNight(String time) {
    return 'Hỏi lúc $time';
  }

  @override
  String get careSettingsAskAtNightHint =>
      'Việc tự thêm chưa xong — chuyển sang ngày mai?';

  @override
  String get careSettingsDefaultReminder => 'Nhắc mặc định';

  @override
  String get careSettingsDefaultReminderHint => 'Cho việc có giờ do bạn đặt';

  @override
  String careReminderShort(String reminder) {
    String _temp0 = intl.Intl.selectLogic(reminder, {
      'atTime': 'Đúng giờ',
      'before15': 'Trước 15′',
      'before30': 'Trước 30′',
      'before60': 'Trước 1 giờ',
      'other': 'Không nhắc',
    });
    return '$_temp0';
  }

  @override
  String get careSeriesSection => 'Chuỗi lặp lại';

  @override
  String get careSeriesDaily => 'Hằng ngày';

  @override
  String careSeriesPausedUntil(String date) {
    return 'Tạm dừng tới $date';
  }

  @override
  String get careSeriesPauseWeek => 'Tạm dừng 1 tuần';

  @override
  String get careSeriesEnd => 'Dừng chuỗi';

  @override
  String get careSeriesEndConfirm =>
      'Các lần chưa làm từ hôm nay sẽ được bỏ khỏi bảng. Việc đã làm vẫn được giữ.';

  @override
  String get careSeriesPaused => 'Đã tạm dừng chuỗi 1 tuần';

  @override
  String get careSeriesEnded => 'Đã dừng chuỗi';

  @override
  String famPlanPaidSubtitle(String price, String date) {
    return '$price · gia hạn $date';
  }

  @override
  String get famManagePlan => 'Quản lý gói';

  @override
  String famInviteRelativeCount(int used, int max) {
    return 'Mời người thân ($used/$max)';
  }

  @override
  String famRelativeFollows(String relation, String children) {
    return '$relation · Theo dõi $children';
  }

  @override
  String famRelativeFollowsNone(String relation) {
    return '$relation · Chưa theo dõi bé nào';
  }

  @override
  String famRelationMotherOf(String callName) {
    return 'Mẹ của $callName';
  }

  @override
  String famRelationFatherOf(String callName) {
    return 'Bố của $callName';
  }

  @override
  String get famRelationNanny => 'Người trông trẻ';

  @override
  String get famPermSummaryView => 'Xem';

  @override
  String get famPermSummaryComment => 'Xem, bình luận';

  @override
  String get famPermSummaryDownload => 'được tải ảnh';

  @override
  String get famPermSummaryContribute => 'đóng góp ảnh';

  @override
  String famRelativeSince(String relation, String date) {
    return 'Quan hệ: $relation · Tham gia $date';
  }

  @override
  String famRelativeActive(String time) {
    return 'Hoạt động $time';
  }

  @override
  String get famDisplayName => 'Tên gọi hiển thị';

  @override
  String get famSignIn => 'Đăng nhập';

  @override
  String famSignInPhone(String phone) {
    return 'SĐT $phone';
  }

  @override
  String get famPostedMemories => 'Ký ức đã đăng';

  @override
  String famMemoryCount(int count) {
    return '$count ký ức';
  }

  @override
  String get famPermByChild => 'Quyền theo từng bé';

  @override
  String get famPermHide => 'Tạm ẩn';

  @override
  String get famPermLevelView => 'Xem';

  @override
  String get famPermLevelComment => 'Bình luận';

  @override
  String get famPermLevelContribute => 'Đóng góp';

  @override
  String famPregnancyWeekShort(int week) {
    return 'Thai kỳ · Tuần $week';
  }

  @override
  String get famNotShared => 'Chưa chia sẻ';

  @override
  String get famPermHidden => 'Đang tạm ẩn';

  @override
  String get famShare => 'Chia sẻ';

  @override
  String get famAllowDownload => 'Cho phép tải ảnh về máy';

  @override
  String famAllowDownloadOff(String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': 'bà',
      'grandpa': 'ông',
      'other': 'người thân',
    });
    return 'Tắt — $_temp0 xem trong app, không lưu về máy';
  }

  @override
  String famAllowDownloadOn(String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': 'bà',
      'grandpa': 'ông',
      'other': 'người thân',
    });
    return 'Bật — $_temp0 lưu được ảnh về máy';
  }

  @override
  String famMuteFrom(String callName) {
    return 'Tắt thông báo từ $callName';
  }

  @override
  String famMuteHint(String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': 'Bà',
      'grandpa': 'Ông',
      'other': 'Người thân',
    });
    return '$_temp0 vẫn xem và bình luận như thường';
  }

  @override
  String famRelativeNote(String callName) {
    return '$callName không bao giờ thấy Papa & Mama, nhiệm vụ, lời nhờ và Hearts.';
  }

  @override
  String get famPauseView => 'Tạm dừng quyền xem';

  @override
  String get famResumeView => 'Mở lại quyền xem';

  @override
  String get famReport => 'Báo cáo';

  @override
  String get famRemoveRelative => 'Gỡ khỏi gia đình';

  @override
  String famRemoveTitle(String callName) {
    return 'Gỡ $callName khỏi gia đình?';
  }

  @override
  String famRemoveSummary(String callName, int count) {
    return '$callName đã đăng $count ký ức. $callName sẽ không còn xem được các con.';
  }

  @override
  String get famRemoveKeepPosts => 'Giữ lại ký ức đã đăng';

  @override
  String get famRemoveKeepPostsHint => 'Vẫn hiện trong ký ức của gia đình';

  @override
  String get famRemoveDeletePosts => 'Gỡ cả các ký ức này';

  @override
  String famRemoved(String callName) {
    return 'Đã gỡ $callName khỏi gia đình';
  }

  @override
  String get famSettingsChangeCover => 'Đổi ảnh bìa';

  @override
  String get famSettingsName => 'Tên gia đình';

  @override
  String get famSettingsMemoriesSection => 'Ký ức & người thân';

  @override
  String get famSettingsDefaultVisibility => 'Ai thấy ký ức mới';

  @override
  String get famSettingsDefaultVisibilityHint => 'Mặc định cho ký ức vừa đăng';

  @override
  String get famSettingsApprove => 'Duyệt ảnh do người thân đăng';

  @override
  String get famSettingsApproveHint =>
      'Ảnh của ông bà chờ Papa/Mama duyệt rồi mới hiện';

  @override
  String get famSettingsTree => 'Người thân thấy Cây gia đình';

  @override
  String get famSettingsMilestones => 'Gợi ý cột mốc';

  @override
  String get famSettingsMilestonesHint =>
      'Nhắc những lần đầu đáng nhớ của các con';

  @override
  String get famSettingsDatesSection => 'Ngày tháng & ngôn ngữ';

  @override
  String get famSettingsTimezone => 'Múi giờ gia đình';

  @override
  String get famTimezoneSearch => 'Tìm thành phố hoặc múi giờ';

  @override
  String get famSettingsLunar => 'Hiển thị âm lịch';

  @override
  String get famSettingsMilestonesBy => 'Tính đầy tháng, thôi nôi theo';

  @override
  String get famSettingsLunarCalendar => 'Âm lịch';

  @override
  String get famSettingsSolarCalendar => 'Dương lịch';

  @override
  String get famSettingsContentLanguage => 'Ngôn ngữ nội dung gợi ý';

  @override
  String get famDeleteFamily => 'Xoá gia đình';

  @override
  String get famDeleteFamilyHint => 'Cần xác nhận kỹ · có 30 ngày để khôi phục';

  @override
  String famDelBody(int days) {
    return 'Cần cả Bố và Mẹ đồng ý. Sau khi đồng ý, gia đình được giữ thêm $days ngày để huỷ; người thân mất quyền xem ngay. Hết hạn, toàn bộ ký ức, ảnh, thư và lịch sử của cả nhà bị xoá.';
  }

  @override
  String get famDelExportHint =>
      'Nên tải dữ liệu về trước: Cài đặt → Dữ liệu của tôi.';

  @override
  String get famDelVerifyHint =>
      'Xác thực lại bằng mã gửi tới số điện thoại của bạn.';

  @override
  String get famDelSendOtp => 'Gửi mã xác thực';

  @override
  String get famDelOtpSent => 'Đã gửi mã xác thực';

  @override
  String get famDelStart => 'Yêu cầu xoá gia đình';

  @override
  String get famDelAgree => 'Đồng ý xoá gia đình';

  @override
  String get famDelWaitingPartner =>
      'Đang chờ bạn đời đồng ý xoá gia đình. Bạn có thể huỷ yêu cầu bất cứ lúc nào.';

  @override
  String get famDelPartnerAsked =>
      'Bạn đời đã yêu cầu xoá gia đình. Xác thực lại để đồng ý, hoặc huỷ yêu cầu.';

  @override
  String famDelScheduled(String date) {
    return 'Gia đình sẽ bị xoá vào $date. Trong thời gian này cả nhà chỉ xem và tải về được.';
  }

  @override
  String get famDelCancel => 'Huỷ yêu cầu xoá';

  @override
  String get famDelCancelled => 'Đã huỷ yêu cầu xoá gia đình';

  @override
  String get famDelRequested => 'Đã cập nhật yêu cầu xoá gia đình';

  @override
  String get setProfileChangeAvatar => 'Đổi ảnh đại diện';

  @override
  String get setProfileName => 'Tên của bạn';

  @override
  String get setProfileCallName => 'Nhãn gọi trong gia đình';

  @override
  String setProfileCallNameHint(String callName) {
    return 'Các con và người thân sẽ thấy bạn với tên “$callName”.';
  }

  @override
  String get setSignInSection => 'Phương thức đăng nhập';

  @override
  String get setSignInApple => 'Apple';

  @override
  String get setSignInGoogle => 'Google';

  @override
  String get setNotLinked => 'Chưa liên kết';

  @override
  String get setUnlink => 'Huỷ liên kết';

  @override
  String get phoneChangeTitle => 'Đổi số điện thoại';

  @override
  String get phoneChangeReauthHint =>
      'Trước tiên, xác thực lại bằng mã gửi tới số hiện tại của bạn.';

  @override
  String get phoneChangeNewHint =>
      'Nhập số điện thoại mới. Mã xác nhận sẽ gửi tới số này.';

  @override
  String phoneChangeCodeSent(String phone) {
    return 'Đã gửi mã tới $phone';
  }

  @override
  String get phoneChangeDone =>
      'Đã đổi số điện thoại. Các thiết bị khác đã được đăng xuất.';

  @override
  String get setChangePhone => 'Đổi số';

  @override
  String get setLink => 'Liên kết';

  @override
  String get setSignInHint =>
      'Luôn giữ ít nhất 1 cách đăng nhập để không mất tài khoản.';

  @override
  String get setTimezoneSection => 'Múi giờ';

  @override
  String get setAutoTimezone => 'Tự động theo thiết bị';

  @override
  String get setAutoTimezoneHint =>
      'Giờ nhắc nhiệm vụ, lời nhờ theo nơi bạn đang ở';

  @override
  String get setPersonalTimezone => 'Múi giờ cá nhân';

  @override
  String get setSaveChanges => 'Lưu thay đổi';

  @override
  String get setChangesSaved => 'Đã lưu thay đổi';

  @override
  String get setNotifGroupsSection => 'Nhóm thông báo';

  @override
  String get setQuietSection => 'Giờ yên tĩnh & màn hình khoá';

  @override
  String get setQuietHours => 'Giờ yên tĩnh';

  @override
  String get setQuietHoursHint => 'Thông báo được gom lại, gửi sau';

  @override
  String get setFrom => 'Từ';

  @override
  String get setTo => 'Đến';

  @override
  String setUrgentBypass(String callName) {
    return 'Lời nhờ của $callName vượt giờ yên tĩnh';
  }

  @override
  String setUrgentBypassOff(String time) {
    return 'Tắt — lời nhờ “Sớm nhé” cũng chờ sau $time';
  }

  @override
  String get setUrgentBypassOn => 'Bật — lời nhờ “Sớm nhé” vẫn báo ngay';

  @override
  String get setHideLockScreen => 'Ẩn nội dung trên màn hình khoá';

  @override
  String get setHideLockScreenHint =>
      'Hiện: “Bạn có một cập nhật mới từ Papa & Mama”';

  @override
  String get setRelativesSection => 'Người thân';

  @override
  String get setDigestTime => 'Giờ gửi bản tin';

  @override
  String get setMutePeople => 'Tắt thông báo theo người';

  @override
  String setPeopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count người',
      zero: 'Chưa có ai',
    );
    return '$_temp0';
  }

  @override
  String get setVisOnlyMeHint => 'Bản nháp, điều muốn giữ riêng';

  @override
  String get setVisParents => 'Papa & Mama';

  @override
  String get setVisParentsHint => 'Chỉ Papa và Mama';

  @override
  String get setVisFamilyHint =>
      'Papa, Mama và người thân được chia sẻ bé trong ký ức';

  @override
  String get setVisibilityHint =>
      'Không có chia sẻ công khai. Bạn đổi được mức hiển thị của từng ký ức bất cứ lúc nào.';

  @override
  String get setDashboardSection => 'Bảng điều khiển quyền';

  @override
  String get setWhoSees => 'Ai đang thấy bé nào';

  @override
  String setRelativeCount(int count) {
    return '$count người thân';
  }

  @override
  String get setStatDownload => 'Được tải ảnh về';

  @override
  String get setStatPost => 'Được đăng ảnh';

  @override
  String get setStatFamilyMemories => 'Ký ức để “Cả nhà”';

  @override
  String get setStatMemoriesUnit => 'ký ức';

  @override
  String get setStatDevices => 'Thiết bị đăng nhập';

  @override
  String get setStatDevicesUnit => 'thiết bị';

  @override
  String get setStatAi => 'AI đang bật';

  @override
  String get setStatAiUnit => 'tính năng';

  @override
  String get setOpenPermissions => 'Xem chi tiết & chỉnh quyền';

  @override
  String get setPrivacyNote =>
      'Papa & Mama, nhiệm vụ, lời nhờ và Hearts luôn chỉ của hai bạn — người thân không bao giờ thấy.';

  @override
  String get setBlocked => 'Người bị chặn';

  @override
  String get setAppLockSection => 'Khoá ứng dụng';

  @override
  String get setFaceIdLock => 'Khoá bằng Face ID';

  @override
  String get setFaceIdLockHint => 'Mở Baby Family cần Face ID của bạn';

  @override
  String get setBackupPin => 'Mã PIN dự phòng';

  @override
  String get setPinSet => 'Đã đặt';

  @override
  String get setPinNotSet => 'Chưa đặt';

  @override
  String get setPinHint =>
      'Khi Face ID không nhận ra, bạn mở bằng mã PIN 6 số.';

  @override
  String get setDevicesSection => 'Thiết bị đang đăng nhập';

  @override
  String setDeviceInUse(String location) {
    return '$location · Đang dùng';
  }

  @override
  String setDeviceLastActive(String location, String time) {
    return '$location · $time';
  }

  @override
  String get setThisDevice => 'Thiết bị này';

  @override
  String get setSignOutAll => 'Đăng xuất mọi thiết bị';

  @override
  String get setSignOutAllHint =>
      'Bạn sẽ cần đăng nhập lại trên tất cả thiết bị, kể cả máy này. Ký ức và dữ liệu vẫn được giữ nguyên.';

  @override
  String setDeviceSignedOut(String device) {
    return 'Đã đăng xuất $device';
  }

  @override
  String get setDataSubtitle =>
      'Kỷ niệm của nhà mình luôn là của nhà mình — tải về bất cứ lúc nào.';

  @override
  String get setExportSection => 'Xuất dữ liệu';

  @override
  String get setExportPersonal => 'Dữ liệu cá nhân';

  @override
  String get setExportPersonalWho => 'Mọi thành viên';

  @override
  String get setExportPersonalDesc =>
      'Những gì bạn tạo: ký ức đã đăng, nhật ký riêng, mood, lời cảm ơn đã gửi và nhận.';

  @override
  String get setExportFamily => 'Dữ liệu gia đình';

  @override
  String get setExportFamilyDesc =>
      'File ZIP: ảnh/video gốc, memories.csv và trang xem offline. Không gồm Papa & Mama.';

  @override
  String get setExport => 'Xuất';

  @override
  String get setExporting => 'Đang xuất…';

  @override
  String get setExportStatusSection => 'Trạng thái xuất';

  @override
  String setExportPreparing(int percent) {
    return 'Đang chuẩn bị · $percent%';
  }

  @override
  String setExportStarted(String time) {
    return 'Bắt đầu $time hôm nay · Bạn sẽ nhận thông báo khi xong.';
  }

  @override
  String setExportReadyTitle(String name, int size) {
    return '$name · $size MB';
  }

  @override
  String setExportExpires(String date) {
    return 'Link tải hết hạn $date';
  }

  @override
  String get setDownload => 'Tải về';

  @override
  String get setDownloadStarted => 'Đã bắt đầu tải về';

  @override
  String get setOnDeviceSection => 'Trên máy này';

  @override
  String get setCache => 'Bộ nhớ đệm';

  @override
  String setCacheSize(int size) {
    return '$size MB trên máy';
  }

  @override
  String get setClearCache => 'Xoá cache';

  @override
  String get setCacheHint =>
      'Xoá cache chỉ giải phóng bộ nhớ máy. Ký ức vẫn an toàn trên đám mây.';

  @override
  String setDelStep(int step) {
    return 'Bước $step/4';
  }

  @override
  String get setDelStepFinal => 'Bước 3–4/4';

  @override
  String get setDelTitle1 => 'Trước khi xoá tài khoản';

  @override
  String setDelSubtitle1(String name) {
    return '$name ơi, đây là những gì sẽ thay đổi. Bạn có thể dừng lại bất cứ lúc nào.';
  }

  @override
  String get setDelWillDelete => 'Sẽ bị xoá';

  @override
  String get setDelItemPrivate => 'Nhật ký riêng, mood và các bản nháp của bạn';

  @override
  String setDelItemCouple(String partner) {
    return 'Phần Papa & Mama của bạn — $partner vẫn giữ phần của $partner';
  }

  @override
  String get setDelItemCoupleSolo => 'Phần Papa & Mama của bạn';

  @override
  String get setDelItemProfile => 'Hồ sơ và các phương thức đăng nhập';

  @override
  String setDelPosted(int count) {
    return '$count ký ức bạn đã đăng';
  }

  @override
  String get setDelKeepForFamily => 'Giữ lại cho gia đình';

  @override
  String get setDelKeepHint => 'Hiển thị dưới tên “Người dùng đã rời”';

  @override
  String get setDelDeleteMemories => 'Xoá các ký ức này';

  @override
  String get setDelSubscription => 'Gói dịch vụ';

  @override
  String get setDelSubscriptionBody =>
      'Gói mua qua App Store hoặc Google Play không tự huỷ khi xoá tài khoản. Hãy huỷ trong Store để không bị gia hạn.';

  @override
  String get setDelHowToCancel => 'Xem cách huỷ gói trong Store';

  @override
  String get setDelOthersNote =>
      'Bình luận của người khác trên ảnh của bạn vẫn là của họ — app không xoá nội dung của người khác.';

  @override
  String get setDelKeepAccount => 'Giữ tài khoản';

  @override
  String setDelTitle2(String family) {
    return '$family sẽ ra sao?';
  }

  @override
  String setDelSubtitle2(String partner) {
    return 'Bạn vẫn còn $partner trong gia đình, nên các con và mọi kỷ niệm sẽ ở lại với $partner.';
  }

  @override
  String setDelPartnerKeeps(String partner, String family) {
    return '$partner tiếp tục giữ $family';
  }

  @override
  String setDelPartnerItem1(String partner, String children) {
    return '$partner vẫn xem và tải về mọi ký ức của $children';
  }

  @override
  String get setDelPartnerItem2 =>
      'Gia đình chuyển sang chế độ chỉ xem & tải về';

  @override
  String setDelPartnerItem3(String partner) {
    return '$partner có thể mời một bạn đời mới vào gia đình';
  }

  @override
  String setDelCoupleData(String partner) {
    return 'Mood, nhật ký và chia sẻ của bạn trong Papa & Mama sẽ bị xoá. Phần của $partner vẫn còn nguyên.';
  }

  @override
  String get setDelExportTip => 'Muốn giữ một bản cho riêng mình?';

  @override
  String get setDelExportTipHint => 'Xuất dữ liệu cá nhân trước khi xoá';

  @override
  String get setDelOnlyBadge => 'Khi bạn là Papa/Mama duy nhất';

  @override
  String get setDelOnlyTitle => 'Ai sẽ giữ kỷ niệm của các con?';

  @override
  String setDelOnlySubtitle(String family) {
    return '$family chỉ có bạn quản lý. Hãy chọn một cách trước khi tiếp tục.';
  }

  @override
  String get setDelInviteParent => 'Mời người khác làm Parent trước';

  @override
  String get setDelInviteParentHint =>
      'Họ giữ gia đình, các con và mọi ký ức. Bạn quay lại xoá tài khoản sau khi họ tham gia.';

  @override
  String get setDelDeleteFamily => 'Xoá cả gia đình';

  @override
  String setDelDeleteFamilyHint(String children) {
    return '$children và mọi ký ức bị xoá vĩnh viễn sau 30 ngày. Trong 30 ngày đó bạn vẫn khôi phục được.';
  }

  @override
  String get setDelOnlyExportTip =>
      'Nên xuất dữ liệu gia đình trước để giữ lại toàn bộ ảnh và video gốc.';

  @override
  String get setDelInviteNewParent => 'Mời Parent mới';

  @override
  String get setDelTitle3 => 'Xác nhận lần cuối';

  @override
  String get setDelSubtitle3 =>
      'Để bảo vệ tài khoản, hãy đăng nhập lại bằng một cách bạn đã liên kết.';

  @override
  String setDelVerified(String account) {
    return 'Đã xác thực · $account';
  }

  @override
  String setDelUseOtp(String phone) {
    return 'Dùng mã OTP qua SĐT $phone';
  }

  @override
  String get setDelWhatHappens => 'Khi bạn bấm “Xoá tài khoản”';

  @override
  String get setDelHappen1 => 'Bạn được đăng xuất khỏi mọi thiết bị ngay';

  @override
  String setDelHappen2(String date) {
    return 'Tài khoản chờ xoá 30 ngày — đến $date';
  }

  @override
  String get setDelHappen3 => 'Đăng nhập lại trước ngày đó để khôi phục';

  @override
  String get setDelHappen4 =>
      'Sau 30 ngày, dữ liệu bị xoá vĩnh viễn và bạn nhận email xác nhận';

  @override
  String get setDelConfirmCheck => 'Tôi đã hiểu và muốn xoá tài khoản của mình';

  @override
  String get setFaqSection => 'Câu hỏi thường gặp';

  @override
  String get setFaqAll => 'Xem tất cả câu hỏi';

  @override
  String get setSupportSection => 'Cần thêm hỗ trợ';

  @override
  String get setSendRequest => 'Gửi yêu cầu hỗ trợ';

  @override
  String get setSendRequestHint =>
      'Mô tả vấn đề, kèm ảnh chụp màn hình nếu muốn';

  @override
  String get supportTitle => 'Gửi yêu cầu hỗ trợ';

  @override
  String get supportHint =>
      'Chỉ nội dung bạn tự nhập được gửi tới đội hỗ trợ. Đừng ghi mật khẩu hay mã OTP.';

  @override
  String get supportCategoryLabel => 'Vấn đề về';

  @override
  String supportCategory(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'ACCOUNT': 'Tài khoản',
      'INVITATION': 'Lời mời',
      'MEDIA': 'Ảnh & video',
      'BILLING': 'Gói & thanh toán',
      'PRIVACY': 'Quyền riêng tư',
      'other': 'Khác',
    });
    return '$_temp0';
  }

  @override
  String get supportSubject => 'Tiêu đề';

  @override
  String get supportBody => 'Mô tả vấn đề';

  @override
  String get supportSend => 'Gửi yêu cầu';

  @override
  String supportSent(String code) {
    return 'Đã gửi yêu cầu $code';
  }

  @override
  String get supportMine => 'Yêu cầu đã gửi';

  @override
  String get supportEmpty => 'Bạn chưa gửi yêu cầu nào.';

  @override
  String supportStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'OPEN': 'Đã tiếp nhận',
      'IN_PROGRESS': 'Đang xử lý',
      'WAITING_USER': 'Chờ bạn phản hồi',
      'RESOLVED': 'Đã giải quyết',
      'other': 'Đã đóng',
    });
    return '$_temp0';
  }

  @override
  String get supportThread => 'Trao đổi';

  @override
  String get supportNoReply => 'Đội hỗ trợ sẽ trả lời tại đây.';

  @override
  String get supportTeam => 'Đội hỗ trợ';

  @override
  String get supportReply => 'Nhắn thêm';

  @override
  String get supportSendReply => 'Gửi';

  @override
  String get supportClosedHint =>
      'Yêu cầu này đã đóng. Gửi yêu cầu mới nếu bạn cần thêm trợ giúp.';

  @override
  String get setMyReports => 'Báo cáo của tôi';

  @override
  String setReportsOpen(int count) {
    return '$count đang xử lý';
  }

  @override
  String get setContactSection => 'Liên hệ';

  @override
  String get setEmailSupport => 'Email đội hỗ trợ';

  @override
  String get setHotline => 'Đường dây hỗ trợ';

  @override
  String setAppVersion(String version) {
    return 'Phiên bản $version';
  }

  @override
  String get setTerms => 'Điều khoản sử dụng';

  @override
  String get setPrivacyPolicy => 'Chính sách quyền riêng tư';

  @override
  String get setLicenses => 'Giấy phép mã nguồn mở';

  @override
  String get setMadeWith => 'Làm với yêu thương cho các gia đình Việt';

  @override
  String setCopyright(String year) {
    return '© $year Baby Family';
  }

  @override
  String commonAndList(String items, String last) {
    return '$items và $last';
  }

  @override
  String get memAlbumsAuto => 'Album tự động';

  @override
  String get memAlbumsAutoHint => 'Tự cập nhật';

  @override
  String get memAlbumsFamily => 'Album của nhà mình';

  @override
  String get memAlbumNew => 'Album mới';

  @override
  String get memAlbumNameHint => 'Tên album';

  @override
  String get memAlbumCreate => 'Tạo album';

  @override
  String memAlbumMonthlyMeta(String name, int count) {
    return '$name · $count ảnh';
  }

  @override
  String memAlbumFirstsMeta(int count) {
    return '$count cột mốc';
  }

  @override
  String memAlbumVideosMeta(int count) {
    return '$count video';
  }

  @override
  String memAlbumQuotesMeta(int count) {
    return '$count câu nói';
  }

  @override
  String memAlbumVoicesMeta(int count) {
    return '$count ghi âm';
  }

  @override
  String memAlbumParentsMeta(int count) {
    return '$count ký ức · Papa & Mama';
  }

  @override
  String memAlbumDetailMeta(int count, String range) {
    return '$count ký ức · $range';
  }

  @override
  String memAlbumCreatedBy(String callName) {
    return '$callName tạo';
  }

  @override
  String get memAlbumPermissionNote =>
      'Người xem chỉ thấy ký ức họ có quyền xem trong album này.';

  @override
  String get memAlbumRename => 'Đổi tên';

  @override
  String get memAlbumChangeCover => 'Đổi bìa';

  @override
  String get memAlbumDelete => 'Xoá album';

  @override
  String get memAlbumDeleteNote => 'Ký ức trong album vẫn được giữ lại';

  @override
  String memAlbumDeleteConfirm(String title) {
    return 'Xoá album “$title”?';
  }

  @override
  String memNamesPair(String first, String second) {
    return '$first & $second';
  }

  @override
  String memDotMeta3(String first, String second, String third) {
    return '$first · $second · $third';
  }

  @override
  String get memViewerSwipeHint => 'Vuốt xuống để đóng';

  @override
  String get memViewerDownload => 'Tải về';

  @override
  String get memViewerShare => 'Chia sẻ';

  @override
  String get memViewerInfo => 'Thông tin';

  @override
  String get memViewerDownloaded => 'Đã lưu ảnh vào máy';

  @override
  String get memCommentReply => 'Trả lời';

  @override
  String memCommentReplying(String name) {
    return 'Đang trả lời $name';
  }

  @override
  String get memCommentEditing => 'Đang sửa bình luận';

  @override
  String get memCommentEdit => 'Sửa';

  @override
  String get memCommentCopy => 'Sao chép';

  @override
  String get memCommentDelete => 'Xoá';

  @override
  String memCommentMinutes(int count) {
    return '$count phút';
  }

  @override
  String memCommentHours(int count) {
    return '$count giờ';
  }

  @override
  String get memCommentEmoji => 'Biểu tượng cảm xúc';

  @override
  String get memMilestoneSearchHint => 'Tìm cột mốc, ví dụ “lẫy”, “răng”…';

  @override
  String memMilestoneRecordedCount(int done, int total) {
    return '$done / $total đã ghi';
  }

  @override
  String memMilestoneRecordedAt(String date) {
    return 'Đã ghi · $date';
  }

  @override
  String get memMilestoneCustom => '✏️ Cột mốc riêng của nhà mình';

  @override
  String get memMilestoneCustomHint => 'Tên cột mốc';

  @override
  String get memMilestoneNoResult => 'Chưa có cột mốc phù hợp';

  @override
  String memDiarySavedDraft(String time) {
    return 'Đã lưu nháp · $time';
  }

  @override
  String get memDiarySaved => 'Đã lưu nhật ký';

  @override
  String get memFormatBold => 'In đậm';

  @override
  String get memFormatItalic => 'In nghiêng';

  @override
  String get memFormatList => 'Danh sách';

  @override
  String get memFormatNumbered => 'Danh sách đánh số';

  @override
  String get memFormatImage => 'Chèn ảnh';

  @override
  String get memFormatHeading => 'Tiêu đề';

  @override
  String get memFormatHideKeyboard => 'Ẩn bàn phím';

  @override
  String get memLetterSaveDraft => 'Lưu nháp';

  @override
  String get memLetterDraftSaved => 'Đã lưu nháp';

  @override
  String get memLetterRecipient => 'Gửi đến';

  @override
  String get memLetterFormat => 'Hình thức';

  @override
  String get memLetterWrite => 'Viết';

  @override
  String get memLetterVideo => 'Quay video';

  @override
  String get memLetterPickDate => 'Chọn ngày';

  @override
  String get memLetterBirthdayN => 'Sinh nhật thứ N';

  @override
  String memLetterBirthdayAge(int age) {
    return 'Sinh nhật $age tuổi';
  }

  @override
  String memLetterOpensOn(String name, String date) {
    return '$name mở vào $date';
  }

  @override
  String get memLetterReaders => 'Ai được đọc khi đến ngày mở';

  @override
  String memLetterReadersNote(String mode, String me, String partner) {
    String _temp0 = intl.Intl.selectLogic(mode, {
      'onlyMe': 'Khi mở: chỉ $me đọc cùng con. $partner không thấy thư này.',
      'family':
          'Khi mở: cả nhà cùng đọc với con. Trước ngày mở, chỉ $me đọc và sửa được.',
      'other':
          'Khi mở: $me và $partner cùng đọc với con. Trước ngày mở, chỉ $me đọc và sửa được — $partner thấy có thư nhưng không đọc nội dung.',
    });
    return '$_temp0';
  }

  @override
  String get memLetterEnvelopePreview => 'Xem trước phong bì';

  @override
  String memLetterEnvelopeTo(String name) {
    return 'Gửi $name';
  }

  @override
  String memLetterEnvelopeBirthday(String date, int age) {
    return 'Mở vào $date · Sinh nhật thứ $age';
  }

  @override
  String memLetterEnvelopeDate(String date) {
    return 'Mở vào $date';
  }

  @override
  String get memLetterEnvelopeAnytime => 'Không hẹn ngày mở';

  @override
  String memLetterTimelineHint(String callName, String date) {
    return 'Trên dòng thời gian: “💌 Thư của $callName — mở vào $date”';
  }

  @override
  String memLetterTimelineHintNow(String callName) {
    return 'Trên dòng thời gian: “💌 Thư của $callName”';
  }

  @override
  String get memLetterSeal => 'Niêm phong thư';

  @override
  String memLetterSalutation(String child, String callName) {
    return 'Gửi $child của $callName,';
  }

  @override
  String get memLetterSignOff => 'Yêu con,';

  @override
  String get memSearchHint => 'Tìm ký ức, câu nói, nhật ký…';

  @override
  String get memSearchRecent => 'Gần đây';

  @override
  String get memSearchKind => 'Loại';

  @override
  String get memSearchKindAll => 'Tất cả';

  @override
  String get memSearchAuthor => 'Người đăng';

  @override
  String memSearchResults(int count, String query) {
    return '$count kết quả cho “$query”';
  }

  @override
  String memSearchMedia(int count) {
    return 'Ảnh & video · $count';
  }

  @override
  String memSearchDiaries(int count) {
    return 'Nhật ký · $count';
  }

  @override
  String get memSearchNoResult => 'Chưa tìm thấy ký ức nào';

  @override
  String memOnThisDayMonthShort(int month) {
    return 'TH $month';
  }

  @override
  String memOnThisDayHeader(int day, int month) {
    return 'Ngày $day tháng $month của nhà mình';
  }

  @override
  String memOnThisDaySummary(int years, int count) {
    return '$years năm kỷ niệm · $count ký ức';
  }

  @override
  String memOnThisDayYearsAgo(int count) {
    return '$count năm trước';
  }

  @override
  String memOnThisDayYearMeta(String date, String child, String age) {
    return '$date · $child $age';
  }

  @override
  String memOnThisDayMilestone(String title) {
    return '⭐ $title';
  }

  @override
  String memOnThisDayPhotos(int count) {
    return '$count ảnh';
  }

  @override
  String memQuoteOfChild(String name, String age) {
    return 'Câu nói của $name · $age';
  }

  @override
  String get memOnThisDayReshare => 'Chia sẻ lại với chú thích mới';

  @override
  String get memOnThisDayFooter =>
      'Chỉ hiện ký ức bạn có quyền xem · Tắt trong Cài đặt';

  @override
  String get memOnThisDayEmpty => 'Hôm nay chưa có ký ức của những năm trước';

  @override
  String recapWeekRange(String range, String audience) {
    return 'Tuần này · $range · $audience';
  }

  @override
  String recapQuoteMeta(String name, String age) {
    return 'Câu nói mới của $name · $age';
  }

  @override
  String get recapShareFamily => 'Chia sẻ với người thân';

  @override
  String get recapFamilyBadge => 'Family';

  @override
  String get recapSaveTimeline => 'Lưu vào timeline';

  @override
  String get recapDownload => 'Tải ảnh tổng kết';

  @override
  String get recapNote =>
      'Bạn xem lại trước khi chia sẻ. Không gồm nội dung Papa & Mama.';

  @override
  String get recapNextHighlights => 'Ảnh nổi bật';

  @override
  String get recapShared => 'Đã chia sẻ với người thân';

  @override
  String get recapSaved => 'Đã lưu vào timeline';

  @override
  String get memLetterSealDone => 'Đã niêm phong thư';

  @override
  String usThanksMonth(String month) {
    return 'Tháng $month';
  }

  @override
  String get usThanksAll => 'Tất cả';

  @override
  String get usThanksMine => 'Của bạn';

  @override
  String usThanksPartner(String callName) {
    return 'Của $callName';
  }

  @override
  String usThanksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lời cảm ơn',
    );
    return '$_temp0';
  }

  @override
  String get usThanksYou => 'Bạn';

  @override
  String get usThanksSendCta => 'Gửi lời cảm ơn';

  @override
  String get usThanksReact => 'Thả tim';

  @override
  String usThanksShareAsk(String name) {
    return '$name muốn đăng lời cảm ơn này thành khoảnh khắc của cả nhà';
  }

  @override
  String get usThanksShareApprove => 'Đăng cho cả nhà';

  @override
  String get usThanksShareKeep => 'Để riêng hai mình';

  @override
  String get usThanksShareFailed => 'Chưa gửi được, thử lại nhé';

  @override
  String get usThanksWallEmpty => 'Tháng này chưa có lời cảm ơn nào';

  @override
  String get usJournalOnlyYou => 'Chỉ mình bạn đọc được';

  @override
  String usJournalOnlyYouHint(String callName) {
    return '$callName cũng không thấy — trừ khi bạn tự chọn chia sẻ một đoạn.';
  }

  @override
  String get usJournalFaceId => 'Khoá bằng Face ID';

  @override
  String get usJournalFaceIdHint => 'Hỏi Face ID mỗi lần mở nhật ký';

  @override
  String usJournalMonth(String month) {
    return 'Tháng $month';
  }

  @override
  String usJournalMood(String mood) {
    String _temp0 = intl.Intl.selectLogic(mood, {
      'tired': 'Mệt',
      'grateful': 'Biết ơn',
      'worried': 'Lo lắng',
      'other': 'Bình yên',
    });
    return '$_temp0';
  }

  @override
  String get usJournalShareAction => 'Chia sẻ đoạn này với bạn đời';

  @override
  String usJournalShared(String callName) {
    return 'Đã chia sẻ 1 đoạn với $callName';
  }

  @override
  String get usJournalWrite => 'Viết trang mới';

  @override
  String usJournalSharePreview(String callName) {
    return '$callName sẽ thấy đúng đoạn này:';
  }

  @override
  String usJournalShareConfirm(String callName) {
    return 'Chia sẻ với $callName';
  }

  @override
  String get usJournalNewPage => 'Trang mới';

  @override
  String get usJournalMoodLabel => 'Bạn đang thấy thế nào?';

  @override
  String get usJournalTitleLabel => 'Tiêu đề';

  @override
  String get usJournalBodyLabel => 'Điều bạn muốn ghi lại';

  @override
  String get usJournalSave => 'Lưu trang';

  @override
  String get usJournalEmpty =>
      'Chưa có trang nào. Viết vài dòng cho riêng mình nhé.';

  @override
  String usSettingsScope(String callName) {
    return 'Chỉ áp dụng cho bạn · $callName có cài đặt riêng';
  }

  @override
  String get usSettingsCheckinSection => 'Khi check-in cảm xúc';

  @override
  String usSettingsShareMode(String mode, String callName) {
    String _temp0 = intl.Intl.selectLogic(mode, {
      'askEachTime': 'Hỏi mỗi lần',
      'alwaysShare': 'Luôn chia sẻ với $callName',
      'other': 'Luôn riêng tư',
    });
    return '$_temp0';
  }

  @override
  String usSettingsShareModeHint(String mode, String callName) {
    String _temp0 = intl.Intl.selectLogic(mode, {
      'askEachTime': 'Chọn chia sẻ hay giữ riêng sau mỗi lần check-in',
      'alwaysShare': '$callName thấy cảm xúc và những phần bạn tick',
      'other': 'Chỉ mình bạn xem lại được',
    });
    return '$_temp0';
  }

  @override
  String get usSettingsPrivacySection => 'Riêng tư';

  @override
  String get usSettingsHideLock => 'Ẩn nội dung trên màn hình khoá';

  @override
  String get usSettingsHideLockHint =>
      'Chỉ hiện “Bạn có một cập nhật mới từ Papa & Mama”';

  @override
  String get usSettingsFaceId => 'Khoá Face ID khi vào Papa & Mama';

  @override
  String get usSettingsFaceIdHint => 'Hỏi Face ID mỗi lần mở tab này';

  @override
  String get usSettingsRequestsSection => 'Lời nhờ';

  @override
  String usSettingsUrgentBypass(String callName) {
    return 'Cho phép lời nhờ “Sớm nhé” của $callName vượt giờ yên tĩnh';
  }

  @override
  String usSettingsUrgentBypassHint(String from, String to) {
    return 'Giờ yên tĩnh của bạn: $from–$to. Tắt thì lời nhờ sẽ đến sau giờ yên tĩnh.';
  }

  @override
  String get usSettingsBridgeSection => 'Cầu nối';

  @override
  String get usSettingsBridgeKeep => 'Giữ nội dung phiên Cầu nối';

  @override
  String usSettingsRetention(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days ngày',
      zero: 'Xoá ngay',
    );
    return '$_temp0';
  }

  @override
  String get usSettingsBridgeHint =>
      'Sau thời gian này, những gì hai bạn viết trong phiên sẽ tự xoá.';

  @override
  String get usSettingsDataSection => 'Dữ liệu';

  @override
  String get usSettingsClearMood => 'Xoá lịch sử cảm xúc của tôi';

  @override
  String get usSettingsClearMoodHint =>
      'Xoá mọi check-in bạn đã lưu. Không thể khôi phục.';

  @override
  String get usSettingsClearMoodConfirm => 'Xoá lịch sử cảm xúc?';

  @override
  String get usSettingsClearMoodDone => 'Đã xoá lịch sử cảm xúc';

  @override
  String get commonDelete => 'Xoá';

  @override
  String get childEditProfile => 'Sửa hồ sơ';

  @override
  String get childChangeCover => 'Đổi ảnh bìa';

  @override
  String childColorName(String index) {
    String _temp0 = intl.Intl.selectLogic(index, {
      '0': 'Đào',
      '1': 'Bạc hà',
      '2': 'Trời',
      '3': 'Oải hương',
      '4': 'Chanh',
      '5': 'Hồng',
      '6': 'Mơ',
      'other': 'Ngọc',
    });
    return '$_temp0';
  }

  @override
  String childColorNamed(String color) {
    return 'Màu $color';
  }

  @override
  String get childStatMemories => 'ký ức';

  @override
  String get childStatMilestones => 'cột mốc';

  @override
  String get childStatLetters => 'thư gửi con';

  @override
  String get childBirthDate => 'Ngày sinh';

  @override
  String childLunarBirth(String date) {
    return 'Âm lịch: $date';
  }

  @override
  String get childBirthTime => 'Giờ sinh';

  @override
  String get childBirthTimeHidden => 'Người thân không thấy giờ sinh';

  @override
  String get childBirthTimeShown => 'Người thân thấy giờ sinh';

  @override
  String get childDueDate => 'Ngày dự sinh';

  @override
  String get childOriginPregnancy => 'Thai kỳ gốc';

  @override
  String childOriginPregnancyValue(int weeks) {
    return 'Hành trình thai kỳ · $weeks tuần';
  }

  @override
  String get childNameStory => 'Câu chuyện tên';

  @override
  String childNameGivenBy(String names) {
    return '$names đặt';
  }

  @override
  String childNamesAnd(String first, String second) {
    return '$first & $second';
  }

  @override
  String childLikes(String name) {
    return '$name thích';
  }

  @override
  String get childFavFood => 'Món thích';

  @override
  String get childFavToy => 'Đồ chơi';

  @override
  String get childFavSong => 'Bài hát';

  @override
  String childQuoted(String text) {
    return '“$text”';
  }

  @override
  String childRelativesSee(String name) {
    return 'Người thân thấy $name';
  }

  @override
  String get childRelativesNone => 'Chưa chia sẻ với người thân nào';

  @override
  String get childArchiveAction => 'Lưu trữ hồ sơ bé';

  @override
  String childArchiveConfirmTitle(String name) {
    return 'Lưu trữ hồ sơ của $name?';
  }

  @override
  String get childArchiveConfirmBody =>
      'Ký ức riêng của bé sẽ được ẩn, ký ức chung vẫn còn ở anh chị em. Bạn có thể khôi phục bất cứ lúc nào.';

  @override
  String get childArchive => 'Lưu trữ';

  @override
  String childEditTitleNamed(String name) {
    return 'Sửa hồ sơ $name';
  }

  @override
  String get childChangeAvatar => 'Đổi ảnh đại diện';

  @override
  String get childChangeTimelineCover => 'Đổi ảnh bìa timeline';

  @override
  String get childFieldName => 'Tên';

  @override
  String get childFieldNickname => 'Tên ở nhà';

  @override
  String get childBirthDateWarning =>
      'Tuổi trên các ký ức sẽ được tính lại theo ngày sinh mới.';

  @override
  String get childShowBirthTime => 'Cho người thân thấy giờ sinh';

  @override
  String get childShowBirthTimeHint => 'Người thân luôn thấy tuổi của bé';

  @override
  String get childColorLabel => 'Màu nhận diện';

  @override
  String childColorUsedBy(String color, String name) {
    return 'Màu $color đang dùng cho $name';
  }

  @override
  String get childNameGivenByLabel => 'Ai đặt:';

  @override
  String get childNameGivenByOther => '+ Khác';

  @override
  String get childLikesSection => 'Sở thích';

  @override
  String get childSaveChanges => 'Lưu thay đổi';

  @override
  String get childrenReorderHint => 'Giữ và kéo để sắp xếp thứ tự hiển thị';

  @override
  String childPregnancyTag(int number) {
    return 'Thai #$number';
  }

  @override
  String childDueShort(String date) {
    return 'dự sinh $date';
  }

  @override
  String childrenArchived(int count) {
    return 'Đã lưu trữ ($count)';
  }

  @override
  String childArchivedOn(String date) {
    return 'Lưu trữ $date';
  }

  @override
  String childPrivateMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ký ức riêng',
    );
    return '$_temp0';
  }

  @override
  String get childRestore => 'Khôi phục';

  @override
  String childrenArchiveNote(int days) {
    return 'Bé đã lưu trữ được ẩn khỏi bộ chuyển bé. Có thể xoá vĩnh viễn sau khi lưu trữ đủ $days ngày.';
  }

  @override
  String childAddSubtitle(String family, String names) {
    return 'Bé mới sẽ vào gia đình $family. Hồ sơ của $names giữ nguyên.';
  }

  @override
  String childNamesList(String rest, String last) {
    return '$rest và $last';
  }

  @override
  String get childAddBorn => 'Bé đã chào đời';

  @override
  String get childAddBornHint => 'Thêm hồ sơ với tên và ngày sinh của bé';

  @override
  String get childAddExpecting => 'Nhà mình đang mong bé';

  @override
  String childAddExpectingHint(int number) {
    return 'Tạo hành trình thai kỳ mới (Thai #$number)';
  }

  @override
  String get childNameHint => 'Ví dụ: Bin, Mít, Su…';

  @override
  String get childBirthDateHint => 'Chọn ngày sinh';

  @override
  String get childDueDateHint => 'Chọn ngày dự sinh';

  @override
  String get childGenderOptional => 'Giới tính (tuỳ chọn)';

  @override
  String childGender(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'boy': 'Bé trai',
      'girl': 'Bé gái',
      'other': 'Không nêu',
    });
    return '$_temp0';
  }

  @override
  String get childAddShareNote =>
      'Sau khi thêm, bạn có thể chọn chia sẻ bé với từng người thân. Mặc định chưa chia sẻ với ai.';

  @override
  String get memSearchYear => 'Năm';

  @override
  String memDotMeta2(String first, String second) {
    return '$first · $second';
  }

  @override
  String childLunarDateYear(String day, String month, String year) {
    return '$day/$month $year';
  }

  @override
  String get careMoreMenu => 'Thêm';

  @override
  String get careMenuHistory => 'Lịch sử nhiệm vụ';

  @override
  String setDelPartnerRole(String callName) {
    return '$callName · Quản lý gia đình';
  }

  @override
  String memAlbumCount(int count) {
    return '$count album';
  }

  @override
  String get usBridgeRewriteTitle => 'Viết lại nhẹ nhàng';

  @override
  String get usBridgeNextStepTitle => 'Một bước nhỏ tiếp theo';

  @override
  String get usSafetyTitle => 'Hỗ trợ an toàn';

  @override
  String get recapDayTitle => 'Câu chuyện ngày';

  @override
  String get recapMonthTitle => 'Tháng tuổi';

  @override
  String get careStatsTitle => 'Thống kê';

  @override
  String get memTrashTitle => 'Thùng rác';

  @override
  String get memDraftsTitle => 'Nháp';

  @override
  String get memPendingTitle => 'Chờ duyệt';

  @override
  String get childArchiveTitle => 'Lưu trữ hoặc xoá bé';

  @override
  String get circleTabHome => 'Cháu yêu';

  @override
  String get circleTabMemories => 'Ký ức';

  @override
  String get circleTabPost => 'Đăng ảnh';

  @override
  String get circleTabMe => 'Tôi';

  @override
  String get circlePostTitle => 'Đăng ảnh cho cháu';

  @override
  String get circleMemoryDetailTitle => 'Chi tiết ký ức';

  @override
  String get circlePausedTitle => 'Gia đình tạm dừng chia sẻ';

  @override
  String get circleLeaveTitle => 'Rời gia đình';

  @override
  String get billingPlanTitle => 'Gói của gia đình';

  @override
  String get familyInvitePartnerTitle => 'Mời bạn đời cùng tham gia';

  @override
  String get familyPendingInvitesTitle => 'Lời mời đang chờ';

  @override
  String get settingsBlockedTitle => 'Người bị chặn';

  @override
  String get subPlanActive => 'Đang hoạt động';

  @override
  String get subPlanAutoRenew => 'Gia hạn tự động';

  @override
  String get subPlanPayer => 'Người thanh toán';

  @override
  String get subPlanChannel => 'Kênh mua';

  @override
  String get subPlanAppliesTo => 'Áp dụng cho';

  @override
  String subPlanWholeFamily(String family) {
    return 'Cả $family';
  }

  @override
  String subPlanGb(String value) {
    return '$value GB';
  }

  @override
  String subPlanUsedOf(String total) {
    return 'đã dùng / $total GB';
  }

  @override
  String subPlanStorageKind(String kind, String size) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'photo': 'Ảnh',
      'video': 'Video',
      'audio': 'Âm thanh',
      'other': 'Khác',
    });
    return '$_temp0 · $size GB';
  }

  @override
  String get subPlanIncluded => 'Trong gói của nhà mình';

  @override
  String get subPlanRelatives => 'Người thân';

  @override
  String subPlanSlots(int used, int max) {
    return '$used/$max';
  }

  @override
  String get subPlanAi => 'Lượt AI tháng này';

  @override
  String subPlanAiRenews(String date) {
    return 'Làm mới vào $date';
  }

  @override
  String subPlanAiLeft(int remaining, int total) {
    return 'Còn $remaining/$total';
  }

  @override
  String get subPlanVideo => 'Video tối đa';

  @override
  String subPlanVideoHint(int count) {
    return 'Ảnh gốc · $count ảnh mỗi ký ức';
  }

  @override
  String subPlanVideoHintCompressed(int count) {
    return '$count ảnh mỗi ký ức';
  }

  @override
  String subPlanMinutes(int count) {
    return '$count phút';
  }

  @override
  String subPlanManageStore(String channel) {
    return 'Quản lý trong $channel';
  }

  @override
  String get subPlanChange => 'Đổi gói';

  @override
  String subPlanNote(String channel, String payer, String partner) {
    return 'Gói nằm trong tài khoản $channel của $payer nên chỉ $payer đổi hoặc huỷ được. $partner sẽ thấy hướng dẫn nhờ $payer. Huỷ bất kỳ lúc nào trong cài đặt $channel — ký ức của nhà mình không bị xoá.';
  }

  @override
  String subManageStoreMock(String channel) {
    return 'Bản mẫu: trang quản lý gói của $channel chỉ được mô phỏng.';
  }

  @override
  String get subUpgradeTitle => 'Nâng cấp lên Family để mời ông bà';

  @override
  String subUpgradeSubtitle(String payer, String channel) {
    return 'Nhà mình đang dùng gói House · $payer thanh toán qua $channel. Family mở thêm ông bà, người thân và dung lượng lớn hơn.';
  }

  @override
  String get subCmpRelatives => 'Ông bà, người thân';

  @override
  String get subCmpPhotos => 'Ảnh mỗi ký ức';

  @override
  String get subCmpVideo => 'Video';

  @override
  String get subCmpVoice => 'Ghi âm';

  @override
  String get subCmpOriginal => 'Lưu ảnh chất lượng gốc';

  @override
  String get subCmpAi => 'Lượt AI mỗi tháng';

  @override
  String get subCmpDigest => 'Bản tin, duyệt ảnh người thân';

  @override
  String get subCmpNone => '—';

  @override
  String get subCmpYes => 'Có';

  @override
  String subCmpUpTo(int count) {
    return 'Tối đa $count';
  }

  @override
  String subCmpMaxMinutes(int count) {
    return '≤ $count phút';
  }

  @override
  String get subUpgradeCurrent => 'Hiện tại';

  @override
  String subUpgradeProrate(String channel) {
    return 'Nâng cấp có hiệu lực ngay. $channel tự tính phần chênh lệch cho thời gian còn lại của gói House — bạn không phải trả lại cả năm.';
  }

  @override
  String subUpgradeCta(String price) {
    return 'Nâng cấp lên Family · $price';
  }

  @override
  String get subUpgradeLegal =>
      'Tự động gia hạn hằng năm, huỷ bất kỳ lúc nào trong cài đặt App Store. Điều khoản · Quyền riêng tư · Khôi phục giao dịch';

  @override
  String subUpgradeNotPayerLabel(String partner) {
    return '$partner sẽ thấy (không phải người thanh toán)';
  }

  @override
  String subUpgradeNotPayerBody(String payer) {
    return 'Gói House đang do $payer thanh toán. Để tránh trả 2 lần, hãy nhờ $payer nâng cấp.';
  }

  @override
  String subUpgradeAskPayer(String payer) {
    return 'Gửi lời nhắn cho $payer';
  }

  @override
  String subUpgradeAskSent(String payer) {
    return 'Đã gửi lời nhắn cho $payer';
  }

  @override
  String subConfirmTitle(String plan) {
    return 'Xác nhận gói $plan';
  }

  @override
  String subConfirmAudienceFamily(String family, String papa, String mama) {
    return 'Cho cả $family · $papa, $mama và người thân';
  }

  @override
  String subConfirmAudienceHouse(String family, String papa, String mama) {
    return 'Cho cả $family · $papa & $mama';
  }

  @override
  String get subConfirmPrice => 'Giá';

  @override
  String get subConfirmMonthly => 'Quy đổi';

  @override
  String get subConfirmCycle => 'Chu kỳ';

  @override
  String get subConfirmCycleValue => '1 năm · tự động gia hạn';

  @override
  String get subConfirmEffective => 'Hiệu lực';

  @override
  String get subConfirmEffectiveValue => 'Ngay khi App Store xác nhận';

  @override
  String get subConfirmPayVia => 'Thanh toán qua';

  @override
  String get subConfirmPayViaValue => 'Tài khoản App Store của bạn';

  @override
  String subConfirmRelatives(int count) {
    return 'Mời ngay tối đa $count ông bà, người thân';
  }

  @override
  String subConfirmLimits(int storage, int video, String original) {
    String _temp0 = intl.Intl.selectLogic(original, {
      'yes': ' · lưu ảnh gốc',
      'other': '',
    });
    return '$storage GB · video ≤ $video phút$_temp0';
  }

  @override
  String get subConfirmTrialNote =>
      'Thời gian dùng thử còn lại không cộng dồn — chu kỳ năm tính từ hôm nay';

  @override
  String get subConfirmCta => 'Tiếp tục với App Store';

  @override
  String get subConfirmLegal =>
      'Bước tiếp theo là bảng thanh toán của App Store. Tự động gia hạn hằng năm, huỷ bất kỳ lúc nào trong cài đặt App Store.';

  @override
  String get subLinkTerms => 'Điều khoản';

  @override
  String subLimitVideoTitle(int minutes) {
    return 'Video này dài $minutes phút';
  }

  @override
  String subLimitVideoBody(String plan, int max) {
    return '$plan lưu được video tối đa $max phút mỗi video. Bạn có thể cắt ngắn lại, hoặc giữ khoảnh khắc này bằng lời kể.';
  }

  @override
  String get subLimitSafe =>
      'Ký ức của bạn vẫn an toàn — chưa có gì bị xoá, nội dung đang soạn vẫn được giữ nguyên.';

  @override
  String subLimitTrim(int max) {
    return 'Cắt video còn $max phút';
  }

  @override
  String get subLimitPickAnother => 'Chọn video khác';

  @override
  String get subLimitSaveDiary => 'Lưu dạng nhật ký chữ';

  @override
  String get subLimitTopPlan =>
      'Nhà mình đang dùng gói cao nhất (Family) nên không cần nâng cấp thêm.';

  @override
  String get subLimitUpgrade => 'Nâng cấp lên Family';

  @override
  String subLimitTrimmed(int max) {
    return 'Đã cắt video còn $max phút';
  }

  @override
  String subLimitQuotaTitle(String reason) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'QUOTA_STORAGE_EXCEEDED': 'Đã dùng hết dung lượng của gói',
      'QUOTA_PHOTOS_PER_MEMORY': 'Quá số ảnh cho một ký ức',
      'other': 'Đã đạt số ký ức của gói',
    });
    return '$_temp0';
  }

  @override
  String subLimitQuotaBody(String reason, String plan) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'QUOTA_PHOTOS_PER_MEMORY':
          '$plan giới hạn số ảnh mỗi ký ức. Bớt vài ảnh rồi lưu lại, hoặc nâng cấp để thêm nhiều ảnh hơn.',
      'other':
          '$plan đã chạm giới hạn này. Giữ bản đang soạn làm nháp, hoặc nâng cấp để lưu tiếp.',
    });
    return '$_temp0';
  }

  @override
  String get subLimitKeepDraft => 'Lưu thành nháp';

  @override
  String get subIssueTitle => 'Thanh toán gia hạn chưa thành công';

  @override
  String subIssueBody(String plan) {
    return 'Kiểm tra phương thức thanh toán để không gián đoạn. $plan của nhà mình vẫn hoạt động trong lúc này.';
  }

  @override
  String get subIssueAction => 'Kiểm tra trong App Store';

  @override
  String get invInvalidTipMessage =>
      'Nhắn cho người đã mời bạn (Bố/Mẹ của bé) để họ tạo lời mời mới.';

  @override
  String get invInvalidTipCode =>
      'Nếu đã có mã 8 ký tự mới, bạn có thể nhập mã ngay.';

  @override
  String get invEnterOtherCode => 'Nhập mã mời khác';

  @override
  String invElsewhereTitle(String callName) {
    return 'Bạn đang là $callName ở một gia đình khác';
  }

  @override
  String get invElsewhereBody =>
      'Mỗi tài khoản chỉ là Bố/Mẹ của một gia đình, nên bạn chưa thể nhận lời mời này.';

  @override
  String invElsewhereInvite(String inviter, String family) {
    return '$inviter mời bạn tham gia $family';
  }

  @override
  String invElsewhereRole(String callName) {
    return 'Vai trò đề xuất: $callName của các bé';
  }

  @override
  String get invElsewhereJoinRelative => 'Tham gia như người thân';

  @override
  String invElsewhereJoinRelativeHint(String inviter) {
    return 'Không khả dụng — lời mời này dành cho Bố/Mẹ. Nhờ $inviter gửi lời mời người thân nếu bạn muốn xem các bé.';
  }

  @override
  String get invElsewhereLeave => 'Tìm hiểu cách rời gia đình hiện tại';

  @override
  String get invElsewhereLeaveHint =>
      'Các lựa chọn cho Bố/Mẹ và cách nhờ hỗ trợ';

  @override
  String get invWaitingTitle => 'Đã gửi yêu cầu';

  @override
  String invWaitingBody(String inviter) {
    return '$inviter sẽ xác nhận để hoàn tất. Bạn có thể đóng app — mình sẽ báo ngay khi xong.';
  }

  @override
  String invWaitingStepJoined(String family) {
    return 'Bạn đã nhận lời mời vào $family';
  }

  @override
  String invWaitingStepRole(String callName) {
    return 'Vai trò: $callName của các bé';
  }

  @override
  String invWaitingStepConfirm(String inviter) {
    return 'Chờ $inviter xác nhận';
  }

  @override
  String invWaitingStepConfirmHint(String inviter) {
    return '$inviter bật “xác nhận lần cuối” để chắc đúng người';
  }

  @override
  String invWaitingStepTrial(int days) {
    return 'Nhà mình bắt đầu $days ngày dùng thử miễn phí';
  }

  @override
  String get invWaitingNotice => 'Bạn sẽ nhận thông báo “Chào mừng về nhà!”';

  @override
  String famPartnerLeftBanner(String partner, String family) {
    return '$partner đã rời $family (xoá tài khoản). Nhà mình đang ở chế độ chỉ xem & tải về cho tới khi có bạn đời mới.';
  }

  @override
  String get famPartnerInviteSubtitle =>
      'Khi bạn đời tham gia, cả nhà lại cùng tạo ký ức, nhiệm vụ và góc Papa & Mama như trước.';

  @override
  String get famPartnerInviteRole => 'Mời với vai trò';

  @override
  String get famPartnerRecipientSees => 'Người nhận sẽ thấy trước khi tham gia';

  @override
  String famPartnerRecipientHint(String name, String callName) {
    return 'Lời mời từ $name ($callName) · chỉ tên và ảnh đại diện các bé';
  }

  @override
  String get famPartnerRevoke => 'Thu hồi lời mời';

  @override
  String get famPartnerRevoked => 'Đã thu hồi lời mời';

  @override
  String famInvitesCapacity(String family, int active, int pending) {
    return 'Người thân $family: $active đang tham gia · $pending đang chờ';
  }

  @override
  String get famInvitesPending => 'Đang chờ';

  @override
  String get famInvitesExpired => 'Đã hết hạn';

  @override
  String get famInviteNotOpened => 'Chưa mở link';

  @override
  String get famInviteOpened => 'Đã mở link';

  @override
  String get famInviteExpiredTag => 'Hết hạn';

  @override
  String get famInviteKindRelative => 'Lời mời người thân';

  @override
  String get famInvitePermView => 'Xem';

  @override
  String get famInvitePermComment => 'Xem + Bình luận';

  @override
  String get famInvitePermPost => 'Xem + Bình luận + Đăng ảnh';

  @override
  String famInviteDates(String created, String expires, String daysLeft) {
    return 'Tạo $created · hết hạn $expires · $daysLeft';
  }

  @override
  String famInviteDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'còn $count ngày',
      zero: 'hết hạn hôm nay',
    );
    return '$_temp0';
  }

  @override
  String famInviteExpiredOn(String date) {
    return 'Hết hạn $date · link không còn mở được';
  }

  @override
  String get famInviteResend => 'Gửi lại link';

  @override
  String get famInviteRevoke => 'Thu hồi';

  @override
  String get famInviteRenew => 'Tạo lời mời mới';

  @override
  String famInviteResent(String callName) {
    return 'Đã gửi lại link cho $callName';
  }

  @override
  String famInviteRevokedName(String callName) {
    return 'Đã thu hồi lời mời của $callName';
  }

  @override
  String famInviteRenewed(String callName) {
    return 'Đã tạo lời mời mới cho $callName';
  }

  @override
  String get famInvitesRules =>
      'Lời mời người thân hết hạn sau 14 ngày và chỉ dùng 1 lần. Thu hồi để link cũ không mở được nữa. Tối đa 12 người thân, tính cả lời mời đang chờ.';

  @override
  String get famInviteMore => 'Mời thêm người thân';

  @override
  String get famInvitesEmpty => 'Chưa có lời mời nào đang chờ';

  @override
  String get famSwitchTitle => 'Chuyển gia đình';

  @override
  String famSwitchSubtitle(String callName, String family) {
    return 'Bạn là $callName ở $family và là người thân ở một gia đình khác.';
  }

  @override
  String famSwitchRoleParent(String callName) {
    return '$callName (Bố/Mẹ)';
  }

  @override
  String famSwitchRoleRelative(String callName) {
    return '$callName (người thân)';
  }

  @override
  String get famSwitchViewing => 'đang xem';

  @override
  String famSwitchFollows(String names) {
    return 'Theo dõi bé $names';
  }

  @override
  String famSwitchNote(String family) {
    return 'Chuyển gia đình sẽ đổi toàn bộ app theo gia đình được chọn. Ở $family, bạn chỉ thấy ảnh của bé được chia sẻ — không có Chăm con hay Papa & Mama. Mỗi tài khoản chỉ là Bố/Mẹ của một gia đình.';
  }

  @override
  String famSwitchMock(String family) {
    return 'Bản mẫu chỉ có dữ liệu của $family.';
  }

  @override
  String get setAiMaster => 'Dùng AI hỗ trợ';

  @override
  String get setAiMasterHint =>
      'AI chỉ chạy khi bạn bấm. Mọi kết quả là bản nháp để bạn sửa, bỏ hoặc lưu.';

  @override
  String get setAiQuotaLabel => 'Lượt AI còn lại tháng này';

  @override
  String setAiQuotaTotal(int total) {
    return '/ $total lượt';
  }

  @override
  String setAiRenews(String date) {
    return 'Làm mới $date';
  }

  @override
  String setAiPlanQuota(String plan, int total) {
    return '$plan · $total lượt mỗi tháng cho cả nhà';
  }

  @override
  String get setAiFeatures => 'Từng tính năng';

  @override
  String get setAiDataSection => 'Dữ liệu gửi đi';

  @override
  String get setAiData1 =>
      'Chỉ gửi những gì ghi ở từng tính năng, cho đúng lần bạn bấm.';

  @override
  String get setAiData2 =>
      'AI không đọc nhật ký riêng, không chẩn đoán, không tự gửi tin cho ai.';

  @override
  String get setAiData3 =>
      'Lần đầu dùng mỗi tính năng, app hỏi bạn đồng ý trước.';

  @override
  String get setAiData4 => 'Mọi bản nháp đều có nhãn “✨ Gợi ý bởi AI”.';

  @override
  String get setAiDataLink => 'Xem chi tiết dữ liệu gửi cho nhà cung cấp AI';

  @override
  String get setAiReport => 'Báo cáo nội dung AI';

  @override
  String get setAiFoot => 'Tắt AI, Baby Family vẫn dùng đầy đủ mọi tính năng.';

  @override
  String get setBlockedBody =>
      'Người bị chặn không bình luận hay thả cảm xúc vào nội dung của bạn, và bạn không nhận thông báo liên quan đến họ.';

  @override
  String setBlockedSection(int count) {
    return 'Đang chặn · $count người';
  }

  @override
  String setBlockedSince(String date) {
    return 'Chặn từ $date';
  }

  @override
  String get setUnblock => 'Bỏ chặn';

  @override
  String setUnblocked(String name) {
    return 'Đã bỏ chặn $name';
  }

  @override
  String get setUnblockInfo =>
      'Sau khi bỏ chặn, người này có thể bình luận và thả cảm xúc vào nội dung của bạn như trước. Bạn có thể chặn lại bất cứ lúc nào từ trang của họ.';

  @override
  String get setBlockedPartnerNote =>
      'Papa và Mama không chặn nhau trong app. Nếu cần khoảng lặng, bạn có thể tắt chia sẻ cảm xúc trong Papa & Mama.';

  @override
  String get setBlockedEmpty => 'Bạn chưa chặn ai';

  @override
  String get commonDeleteForever => 'Xoá vĩnh viễn';

  @override
  String memTrashInfo(int days) {
    return 'Ký ức đã xoá được giữ $days ngày rồi mới xoá hẳn. Bạn thấy mọi ký ức bị xoá trong gia đình.';
  }

  @override
  String memTrashInfoOwn(int days) {
    return 'Ký ức đã xoá được giữ $days ngày rồi mới xoá hẳn. Bạn thấy những ký ức bạn đã xoá.';
  }

  @override
  String memTrashCount(int count) {
    return '$count ký ức';
  }

  @override
  String memTrashDeletedBy(String callName, String date) {
    return '$callName xoá $date ·';
  }

  @override
  String get memTrashFootnote =>
      'Khôi phục để ký ức trở lại đúng chỗ cũ trên dòng thời gian, kèm bình luận và lượt thả tim.';

  @override
  String get memTrashEmpty => 'Thùng rác trống';

  @override
  String memTrashEmptyHint(int days) {
    return 'Ký ức bạn xoá sẽ nằm ở đây $days ngày để bạn kịp đổi ý.';
  }

  @override
  String memTrashRestored(String title) {
    return 'Đã khôi phục “$title”';
  }

  @override
  String get memTrashDeleted => 'Đã xoá vĩnh viễn';

  @override
  String get memTrashConfirmTitle => 'Xoá vĩnh viễn ký ức này?';

  @override
  String get memTrashConfirmBody =>
      'Ảnh, bình luận và lượt thả tim của ký ức sẽ mất hẳn. Không thể khôi phục sau bước này.';

  @override
  String get memTrashKeep => 'Giữ lại trong thùng rác';

  @override
  String memCommentCount(int count) {
    return '$count bình luận';
  }

  @override
  String memHeartCount(int count) {
    return '$count lượt thả tim';
  }

  @override
  String get memMoveToTrash => 'Xoá ký ức';

  @override
  String memMovedToTrash(int days) {
    return 'Đã chuyển vào thùng rác · giữ $days ngày';
  }

  @override
  String get memMoveToTrashTitle => 'Xoá ký ức này?';

  @override
  String memMoveToTrashBody(int days) {
    return 'Ký ức sẽ nằm trong Thùng rác $days ngày, bạn có thể khôi phục trong thời gian đó.';
  }

  @override
  String get memDraftsSubtitle =>
      'Ký ức đang soạn dở được tự lưu khi bạn thoát giữa chừng. Chỉ mình bạn thấy nháp.';

  @override
  String get memDraftsDevice => 'Trên máy này';

  @override
  String get memDraftsCloud => 'Đã lưu trên tài khoản';

  @override
  String get memDraftsLocalNote =>
      'Nháp trên máy chưa được lưu lên tài khoản — xoá app sẽ mất.';

  @override
  String get memDraftContinue => 'Tiếp tục soạn';

  @override
  String memDraftEditedToday(String time) {
    return 'Sửa lúc $time hôm nay';
  }

  @override
  String memDraftEditedYesterday(String time) {
    return 'Sửa lúc $time hôm qua';
  }

  @override
  String memDraftEditedOn(String date, String time) {
    return 'Sửa $date, $time';
  }

  @override
  String memDraftSavedOn(String date, String time) {
    return 'Lưu $date, $time';
  }

  @override
  String memDraftSavedOnDevice(String date, String time, String device) {
    return 'Lưu $date, $time trên $device';
  }

  @override
  String get memKindMoment => 'Khoảnh khắc';

  @override
  String memKindVoiceDuration(String duration) {
    return 'Giọng nói $duration';
  }

  @override
  String get memDraftsEmpty => 'Chưa có nháp nào';

  @override
  String get memDraftsEmptyHint =>
      'Khi bạn thoát giữa chừng lúc đang soạn, ký ức sẽ được giữ ở đây.';

  @override
  String get memDraftDeleted => 'Đã xoá nháp';

  @override
  String get memDraftSaved => 'Đã lưu vào Nháp';

  @override
  String get memDraftView => 'Xem nháp';

  @override
  String get memShortcutTrash => 'Thùng rác';

  @override
  String get memShortcutDrafts => 'Nháp';

  @override
  String get memShortcutPending => 'Ảnh chờ duyệt';

  @override
  String memPendingSubtitle(String partner) {
    return 'Ảnh người thân đăng chỉ hiện với cả nhà sau khi bạn hoặc $partner duyệt. Trong lúc chờ, chỉ người đăng và bố mẹ thấy.';
  }

  @override
  String get memPendingKids => 'Bé trong ảnh';

  @override
  String get memPendingAudience => 'Ai nhìn thấy';

  @override
  String get memPendingReject => 'Từ chối';

  @override
  String get memPendingApprove => 'Duyệt & hiện';

  @override
  String get memPendingRejectReason => 'Lý do từ chối (không bắt buộc)';

  @override
  String memPendingRejectHint(String name) {
    return '$name sẽ nhận được lời nhắn nhẹ nhàng này. Ảnh không hiện với ai khác.';
  }

  @override
  String get memPendingRejectSend => 'Từ chối ảnh';

  @override
  String memPendingWaited(int count) {
    return 'Đã chờ $count ngày';
  }

  @override
  String get memPendingEmpty => 'Không có ảnh nào chờ duyệt';

  @override
  String get memPendingEmptyHint =>
      'Ảnh người thân đăng cho các con sẽ hiện ở đây để bạn duyệt.';

  @override
  String get memPendingApproved => 'Đã duyệt — ảnh đã hiện với cả nhà';

  @override
  String get memPendingRejected => 'Đã từ chối ảnh';

  @override
  String memPendingAddChild(String name) {
    return 'Thêm $name';
  }

  @override
  String get rptTitleMemory => 'Báo cáo ký ức này';

  @override
  String get rptTitleComment => 'Báo cáo bình luận này';

  @override
  String rptTitlePerson(String name) {
    return 'Báo cáo $name';
  }

  @override
  String get rptSubtitle =>
      'Cho chúng tôi biết điều gì chưa ổn. Đội ngũ an toàn của Baby Family sẽ xem xét.';

  @override
  String get rptNoteHint => 'Mô tả thêm (không bắt buộc)…';

  @override
  String get rptHideMemory => 'Ẩn ký ức này với tôi ngay';

  @override
  String get rptHideComment => 'Ẩn bình luận này với tôi ngay';

  @override
  String get rptHidePerson => 'Ẩn người này với tôi ngay';

  @override
  String get rptRemoveContent => 'Gỡ khỏi gia đình';

  @override
  String get rptRemoveContentHint =>
      'Dành cho bố mẹ · ký ức sẽ không còn hiện với ai';

  @override
  String get rptRemovePerson => 'Gỡ người thân';

  @override
  String rptRemovePersonHint(String name) {
    return 'Dành cho bố mẹ · $name sẽ không còn xem ảnh các con';
  }

  @override
  String get rptSend => 'Gửi báo cáo';

  @override
  String get rptSentTitle => 'Đã gửi báo cáo';

  @override
  String get rptSentBodyHidden =>
      'Cảm ơn bạn đã lên tiếng. Ký ức đã được ẩn tạm thời và sẽ được xem xét trong 24 giờ. Chúng tôi sẽ báo cho bạn khi xử lý xong.';

  @override
  String get rptSentBody =>
      'Cảm ơn bạn đã lên tiếng. Báo cáo sẽ được xem xét sớm. Chúng tôi sẽ báo cho bạn khi xử lý xong.';

  @override
  String get rptCodeLabel => 'Mã báo cáo';

  @override
  String get rptStatusReviewing => 'Đang xem xét';

  @override
  String get rptStatusResolved => 'Đã xử lý';

  @override
  String get rptTrack => 'Theo dõi trong Cài đặt › Báo cáo của tôi';

  @override
  String get rptDone => 'Xong';

  @override
  String rptBlockTitle(String name) {
    return 'Chặn $name?';
  }

  @override
  String rptBlockEffectComment(String name) {
    return '$name không bình luận hay thả tim được vào ký ức của bạn nữa.';
  }

  @override
  String rptBlockEffectNotify(String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': 'Bà',
      'grandpa': 'Ông',
      'other': 'Người này',
    });
    return '$_temp0 không nhận thông báo liên quan đến bạn.';
  }

  @override
  String rptBlockEffectStay(String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': 'Bà',
      'grandpa': 'Ông',
      'other': 'Người này',
    });
    return '$_temp0 vẫn ở trong gia đình và vẫn xem ảnh các cháu được chia sẻ.';
  }

  @override
  String rptBlockRemove(String name) {
    return 'Gỡ $name khỏi gia đình luôn';
  }

  @override
  String rptBlockRemoveHint(String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': 'bà',
      'grandpa': 'ông',
      'other': 'người này',
    });
    return 'Nên chọn nếu bạn không muốn $_temp0 xem ảnh các cháu nữa.';
  }

  @override
  String get rptBlockConfirm => 'Chặn';

  @override
  String rptBlockDone(String name) {
    return 'Đã chặn $name';
  }

  @override
  String rptBlockMenu(String name) {
    return 'Chặn $name';
  }

  @override
  String chdArchiveAddedBy(String birth, String callName, String date) {
    return 'Sinh $birth · $callName thêm ngày $date';
  }

  @override
  String chdArchiveBorn(String birth) {
    return 'Sinh $birth';
  }

  @override
  String chdArchiveDuplicate(String name) {
    return 'Có thể trùng với $name';
  }

  @override
  String chdArchiveSection(String name) {
    return 'Khi lưu trữ $name';
  }

  @override
  String chdArchiveEffectHide(String name) {
    return '$name ẩn khỏi bộ chuyển bé, Trang chủ và Ký ức.';
  }

  @override
  String chdArchiveEffectPrivate(int count, String name) {
    return '$count ký ức chỉ gắn riêng $name sẽ ẩn theo.';
  }

  @override
  String chdArchiveEffectShared(int count, String others) {
    return '$count ký ức chung với $others vẫn hiện ở trang của $others.';
  }

  @override
  String get chdArchiveEffectRestore =>
      'Khôi phục bất cứ lúc nào trong Các con › Đã lưu trữ.';

  @override
  String chdArchiveAction(String name) {
    return 'Lưu trữ $name';
  }

  @override
  String get chdArchiveDeleteSection => 'Xoá vĩnh viễn';

  @override
  String chdArchiveLockedTitle(int days) {
    return 'Cần lưu trữ ít nhất $days ngày';
  }

  @override
  String chdArchiveLockedBody(String date, String name) {
    return 'Để tránh xoá nhầm, nếu lưu trữ hôm nay bạn xoá được từ $date. Nội dung chỉ thuộc riêng $name sẽ vào thùng rác 30 ngày.';
  }

  @override
  String chdArchiveLockedBodyArchived(String date, String name) {
    return 'Để tránh xoá nhầm, bạn xoá được từ $date. Nội dung chỉ thuộc riêng $name sẽ vào thùng rác 30 ngày.';
  }

  @override
  String chdArchived(String name) {
    return 'Đã lưu trữ $name';
  }

  @override
  String chdRestored(String name) {
    return 'Đã khôi phục $name';
  }

  @override
  String chdDeleteTitle(String name) {
    return 'Xoá vĩnh viễn $name';
  }

  @override
  String chdDeleteArchivedName(String name) {
    return '$name · đã lưu trữ';
  }

  @override
  String chdDeleteArchivedFor(int days, String date) {
    return 'Lưu trữ $days ngày · từ $date';
  }

  @override
  String chdDeleteEnough(int days) {
    return 'Đủ $days ngày';
  }

  @override
  String chdDeleteEffectTrash(int count, String name) {
    return '$count ký ức chỉ thuộc riêng $name chuyển vào thùng rác 30 ngày, sau đó xoá hẳn.';
  }

  @override
  String chdDeleteEffectShared(String others) {
    return 'Ký ức chung với $others vẫn giữ nguyên ở trang của $others.';
  }

  @override
  String get chdDeleteStep1 => 'Xác nhận 1/2';

  @override
  String chdDeleteConfirm1(String name) {
    return 'Tôi hiểu $name sẽ bị xoá và không thể khôi phục hồ sơ này.';
  }

  @override
  String get chdDeleteStep2 => 'Xác nhận 2/2 · Nhập tên bé';

  @override
  String chdDeleteHint(String name) {
    return 'Gõ đúng “$name” để mở nút xoá.';
  }

  @override
  String chdDeleteAction(String name) {
    return 'Xoá vĩnh viễn $name';
  }

  @override
  String chdDeleteRestoreInstead(String name) {
    return 'Khôi phục $name thay vì xoá';
  }

  @override
  String chdDeleted(String name) {
    return 'Đã xoá $name';
  }

  @override
  String cirChildTomorrow(int months) {
    return '🎉 Ngày mai tròn $months tháng';
  }

  @override
  String get cirChildFirsts => 'Những lần đầu của cháu';

  @override
  String get cirChildMemories => 'Ký ức của cháu';

  @override
  String cirChildMonth(int month) {
    return 'Tháng thứ $month';
  }

  @override
  String cirChildMonthRange(String start, String end) {
    return '· $start – $end';
  }

  @override
  String get cirChildEmpty => 'Chưa có ký ức nào của cháu';

  @override
  String cirDetailDownloadOff(String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': 'bà',
      'grandpa': 'ông',
      'other': 'bạn',
    });
    return 'Tải ảnh về: bố mẹ chưa bật cho $_temp0';
  }

  @override
  String cirDetailAuthorAge(String name, String age) {
    return '$name $age';
  }

  @override
  String get cirDetailLiked => 'Đã thả tim';

  @override
  String cirDetailYou(String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': 'Bà',
      'grandpa': 'Ông',
      'other': 'Bạn',
    });
    return '$_temp0 (bạn)';
  }

  @override
  String cirDetailReactedBy(String names) {
    return '$names đã thả tim';
  }

  @override
  String cirDetailWishes(int count) {
    return 'Lời chúc ($count)';
  }

  @override
  String get cirDetailWishHint => 'Viết lời chúc cho cháu…';

  @override
  String get cirDetailVoice => 'Ghi âm lời chúc';

  @override
  String get cirDetailSend => 'Gửi lời chúc';

  @override
  String get cirDetailReported => 'Đã gửi báo cáo';

  @override
  String get cirDetailMissing => 'Ký ức này không còn được chia sẻ';

  @override
  String cirPostSelected(int count) {
    return 'Ảnh đã chọn ($count)';
  }

  @override
  String get cirPostWhichKid => 'Ảnh của cháu nào?';

  @override
  String get cirPostDate => 'Ngày chụp';

  @override
  String get cirPostMessage => 'Lời nhắn cho cháu';

  @override
  String get cirPostMessageHint => 'Viết vài lời cho cháu…';

  @override
  String get cirPostApprovalTitle => 'Bố mẹ sẽ duyệt trước khi hiện';

  @override
  String get cirPostApprovalBody =>
      'Ảnh hiện với cả nhà sau khi bố hoặc mẹ của cháu đồng ý.';

  @override
  String get cirPostSend => 'Gửi ảnh';

  @override
  String get cirPostRemovePhoto => 'Bỏ ảnh';

  @override
  String get cirPostSentTitle => 'Đã gửi!';

  @override
  String get cirPostSentBody => 'Bố/Mẹ sẽ duyệt trước khi hiển thị cho cả nhà.';

  @override
  String get cirPostPending => 'Đang chờ Bố/Mẹ duyệt';

  @override
  String get cirPostJustSent => 'vừa gửi';

  @override
  String get cirPostBackHome => 'Về trang Cháu yêu';

  @override
  String get cirPostMore => 'Đăng thêm ảnh';

  @override
  String get cirPostNoKid => 'Bố mẹ chưa bật quyền đăng ảnh cho cháu nào';

  @override
  String cirPausedMessage(String family) {
    return '$family đang tạm dừng chia sẻ với người thân';
  }

  @override
  String get cirPausedSafe => 'Ảnh của cháu vẫn được giữ an toàn';

  @override
  String cirMeRelation(String relation, String family) {
    return '$relation · $family';
  }

  @override
  String cirMeTextPreview(String name, String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': 'bà',
      'grandpa': 'ông',
      'other': 'bạn',
    });
    return '$name vừa có ảnh mới, $_temp0 vào xem nhé 🌸';
  }

  @override
  String get cirMeInstant => 'Báo ngay khi có ảnh mới';

  @override
  String get cirMeDigest => 'Bản tin mỗi ngày';

  @override
  String cirMeDigestHint(String time) {
    return 'Gửi lúc $time · gom ảnh mới trong ngày';
  }

  @override
  String get cirMeSwitchFamily => 'Chuyển gia đình';

  @override
  String cirMeViewing(String family) {
    return 'Đang xem: $family';
  }

  @override
  String cirLeaveTitle(String family) {
    return 'Rời $family';
  }

  @override
  String cirLeaveBody(String who, String inviter) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': 'Bà',
      'grandpa': 'Ông',
      'other': 'Bạn',
    });
    String _temp1 = intl.Intl.selectLogic(who, {
      'grandma': 'bà',
      'grandpa': 'ông',
      'other': 'bạn',
    });
    return '$_temp0 sẽ không còn xem ảnh và bình luận cùng các cháu nữa. Khi nào muốn quay lại, $_temp1 nhờ $inviter gửi lời mời mới nhé.';
  }

  @override
  String cirLeaveFollowing(String who, String names) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': 'Bà',
      'grandpa': 'Ông',
      'other': 'Bạn',
    });
    return '$_temp0 đang theo dõi $names';
  }

  @override
  String cirLeavePosted(String who, int photos, int comments) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': 'bà',
      'grandpa': 'ông',
      'other': 'bạn',
    });
    return 'Những gì $_temp0 đã đăng · $photos ảnh, $comments bình luận';
  }

  @override
  String get cirLeaveKeep => 'Giữ lại cho gia đình';

  @override
  String cirLeaveKeepHint(String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': 'bà',
      'grandpa': 'ông',
      'other': 'bạn',
    });
    return 'Cả nhà vẫn xem được ảnh và lời $_temp0 đã viết. (Mặc định)';
  }

  @override
  String get cirLeaveRemove => 'Gỡ toàn bộ';

  @override
  String cirLeaveRemoveHint(String who, String family) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': 'bà',
      'grandpa': 'ông',
      'other': 'bạn',
    });
    return 'Ảnh và bình luận của $_temp0 sẽ được gỡ khỏi $family.';
  }

  @override
  String cirLeaveNotice(String inviter, String name, String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': 'Bà',
      'grandpa': 'Ông',
      'other': 'Bạn',
    });
    return '$inviter sẽ nhận một thông báo ngắn: “$name đã rời gia đình.” $_temp0 mất quyền xem ngay sau khi xác nhận.';
  }

  @override
  String get cirLeaveStay => 'Ở lại';

  @override
  String commonListAnd(String list, String last) {
    return '$list và $last';
  }

  @override
  String get commonAiSuggested => 'Gợi ý bởi AI';

  @override
  String get commonAiReport => 'Báo cáo nội dung AI';

  @override
  String get commonAiReported =>
      'Cảm ơn bạn — nội dung AI này sẽ được xem lại.';

  @override
  String commonWeekRange(String range) {
    return 'Tuần $range';
  }

  @override
  String get usOnlyParents => 'Chỉ dành cho Papa & Mama';

  @override
  String get usPartnerLeftTitle => 'Không gian này cần đủ hai người';

  @override
  String usPartnerLeftBody(String callName, String familyName) {
    return 'Tài khoản của $callName đã được xoá, nên Papa & Mama đang tạm khoá. Ký ức của $familyName vẫn còn nguyên — bạn có thể xem và tải về bất cứ lúc nào.';
  }

  @override
  String usPartnerLeftStateTitle(String familyName) {
    return '$familyName đang ở chế độ chỉ xem & tải về';
  }

  @override
  String get usPartnerLeftStateSub =>
      'Mời bạn đời mới để tiếp tục tạo ký ức và dùng Papa & Mama.';

  @override
  String get usPartnerLeftSection => 'KHI CÓ ĐỦ HAI NGƯỜI';

  @override
  String get usPartnerLeftCheckinSub => 'Hôm nay mình thế nào';

  @override
  String get usPartnerLeftRequestSub => 'Nhờ nhau, không áp lực';

  @override
  String get usPartnerLeftThanksSub => 'Giữ lại điều nhỏ';

  @override
  String get usPartnerLeftJournalSub => 'Chỉ mình bạn đọc';

  @override
  String get usPartnerLeftPrivacy =>
      'Ông bà và người thân không bao giờ thấy nội dung trong Papa & Mama.';

  @override
  String get usPartnerLeftInvite => 'Mời bạn đời tham gia';

  @override
  String usCheckinAnnoyedPartner(String callName) {
    return 'Khó chịu với $callName';
  }

  @override
  String get usBridgeAskTitle => 'Bạn muốn dùng Cầu nối không?';

  @override
  String usBridgeAskBody(String callName) {
    return 'Chưa có gì được gửi cho $callName. Cầu nối giúp hai bạn nói rõ cảm xúc và cùng chọn một bước nhỏ — bắt đầu bằng một bước riêng tư.';
  }

  @override
  String get usBridgeAskOpen => 'Mở Cầu nối';

  @override
  String usBridgeStepKicker(int step, int total) {
    return 'CẦU NỐI · BƯỚC $step/$total';
  }

  @override
  String usBridgeFeelSub(String callName) {
    return 'Chọn một hoặc vài cảm xúc. Chưa có gì được gửi cho $callName.';
  }

  @override
  String get usBridgeTopicTitle => 'Chuyện này về…';

  @override
  String usBridgeTopicSub(String callName) {
    return 'Không bắt buộc — bạn có thể bỏ qua. Chưa có gì được gửi cho $callName.';
  }

  @override
  String get usBridgeNeedTitle => 'Lúc này mình cần…';

  @override
  String usBridgeNeedSub(String callName) {
    return 'Chọn một hoặc vài điều. Chưa có gì được gửi cho $callName.';
  }

  @override
  String get usBridgeFeltLabel => 'Mình cảm thấy';

  @override
  String get usBridgeAboutLabel => 'Về chuyện';

  @override
  String get usBridgeDraftLabel => 'Viết nháp riêng (tuỳ chọn)';

  @override
  String usBridgeDraftCount(int count, int max) {
    return '$count/$max';
  }

  @override
  String get usBridgeDraftHint =>
      'Viết ra điều bạn đang nghĩ — chỉ mình bạn đọc.';

  @override
  String get usBridgeDraftNote =>
      'Nháp này không bao giờ được gửi nguyên văn hay tự động.';

  @override
  String get usBridgeUnsafe => 'Mình cảm thấy không an toàn';

  @override
  String get usBridgeChoiceTitle => 'Bạn muốn làm gì với nội dung này?';

  @override
  String usBridgeChoiceSub(String callName) {
    return 'Bạn quyết định. Chưa có gì được gửi cho $callName.';
  }

  @override
  String get usBridgeKeepPrivateDesc =>
      'Kết thúc ở đây, như một trang nhật ký.';

  @override
  String get usBridgeRewriteOption => 'Viết lại trước khi gửi';

  @override
  String get usBridgeRewriteOptionDesc =>
      'Chọn một câu và viết lại nhẹ nhàng hơn.';

  @override
  String get usBridgeShareOption => 'Chọn ý để chia sẻ';

  @override
  String usBridgeShareOptionDesc(String callName) {
    return 'Chọn cảm xúc và nhu cầu $callName sẽ thấy.';
  }

  @override
  String get usBridgeKeptPrivate => 'Đã giữ riêng — chỉ mình bạn thấy.';

  @override
  String usBridgePreviewTitle(String callName) {
    return 'Xem trước điều $callName sẽ nhận';
  }

  @override
  String get usBridgePreviewSub =>
      'Chỉ những ý bạn chọn được gửi. Nháp riêng của bạn vẫn giữ riêng.';

  @override
  String get usBridgeFeelShort => 'Cảm thấy';

  @override
  String get usBridgeNeedShort => 'Cần';

  @override
  String get usBridgeMessageLabel => 'Lời nhắn (tuỳ chọn)';

  @override
  String usBridgeMessageHint(String callName) {
    return 'Một câu bạn muốn $callName đọc';
  }

  @override
  String get usBridgeSendInvite => 'Gửi lời mời';

  @override
  String usBridgeInviteSent(String callName) {
    return 'Đã gửi lời mời cho $callName';
  }

  @override
  String get usBridgeRewriteSub =>
      'Chọn một phiên bản rồi sửa theo ý bạn. Không có gì được gửi tự động.';

  @override
  String get usBridgeRewriteOriginal => 'CÂU GỐC CỦA BẠN';

  @override
  String usBridgeRewriteTone(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'neutral': 'TRUNG TÍNH',
      'warm': 'ẤM ÁP',
      'other': 'NGẮN GỌN',
    });
    return '$_temp0';
  }

  @override
  String get usBridgeRewriteEdit => 'Sửa trước khi dùng';

  @override
  String get usBridgeRewriteKeep => 'Giữ câu gốc';

  @override
  String get usBridgeRewriteUse => 'Dùng câu này';

  @override
  String get usBridgeRewriteDataNote =>
      'Chỉ câu bạn chọn được gửi cho AI để viết lại. AI không đọc nháp riêng hay nhật ký của bạn.';

  @override
  String usBridgeInviteTitle(String callName) {
    return '$callName muốn trò chuyện bình tĩnh khi bạn sẵn sàng';
  }

  @override
  String get usBridgeInviteSub =>
      'Một không gian để nói rõ cảm xúc và cùng chọn một bước nhỏ tiếp theo. Không ai thắng, không ai thua.';

  @override
  String usBridgeInviteShared(String callName) {
    return '$callName đã chọn chia sẻ';
  }

  @override
  String usBridgeInviteSharedSub(String callName) {
    return 'Chỉ những ý này — phần còn lại $callName giữ riêng';
  }

  @override
  String get usBridgeInviteNote =>
      'Trước khi vào phiên chung, bạn cũng có một bước riêng tư để nói cảm xúc và điều mình cần.';

  @override
  String get usBridgeJoinNow => 'Tham gia ngay';

  @override
  String get usBridgeLaterLabel => 'Để sau — nhắc mình lúc';

  @override
  String get usBridgeLaterCustom => 'Tự chọn';

  @override
  String get usBridgeNotReady => 'Mình chưa sẵn sàng';

  @override
  String get usBridgeNotReadySub =>
      'Lời mời được tạm dừng — không có thông báo tiêu cực nào.';

  @override
  String get usBridgeRemindSet => 'Đã hẹn nhắc — lời mời vẫn được giữ.';

  @override
  String get usBridgePaused =>
      'Đã tạm dừng. Bạn có thể quay lại bất cứ lúc nào.';

  @override
  String get usBridgeLive => 'Đang diễn ra';

  @override
  String usBridgeStartedAt(String time, String date) {
    return 'Bắt đầu $time · $date';
  }

  @override
  String get usBridgeSessionIntro =>
      'Đọc chậm những gì hai bạn đã chọn chia sẻ. Ở đây không có ai đúng, ai sai.';

  @override
  String usBridgeYouName(String callName) {
    return 'Bạn ($callName)';
  }

  @override
  String usBridgeFeels(String callName) {
    return '$callName cảm thấy';
  }

  @override
  String usBridgeNeeds(String callName) {
    return '$callName cần';
  }

  @override
  String get usBridgeYouPending => 'Bạn chưa chọn';

  @override
  String get usBridgeYouUnderstood => 'Bạn: Mình hiểu';

  @override
  String usBridgePartnerPending(String callName) {
    return '$callName chưa chọn';
  }

  @override
  String usBridgePartnerUnderstood(String callName) {
    return '$callName: Mình hiểu';
  }

  @override
  String get usBridgeYourTurn => 'LƯỢT CỦA BẠN';

  @override
  String usBridgePartnerReadDone(String callName) {
    return '$callName đã đọc xong';
  }

  @override
  String usBridgeReadQuestion(String callName) {
    return 'Bạn đã đọc những gì $callName chia sẻ?';
  }

  @override
  String get usBridgeClarify => 'Mình cần nói rõ hơn';

  @override
  String get usBridgeUnderstand => 'Mình hiểu';

  @override
  String get usBridgeClarifyNote =>
      '“Nói rõ hơn” mở thêm 1 lượt gửi ý — bạn sẽ xem trước chính xác trước khi gửi.';

  @override
  String get usBridgeLeaveNote =>
      'Mỗi người có thể tạm dừng hoặc rời phiên bất cứ lúc nào.';

  @override
  String usBridgeWaiting(String callName) {
    return 'Đang chờ $callName đọc xong';
  }

  @override
  String usBridgeClarifyTitle(String callName) {
    return 'Nói rõ hơn với $callName';
  }

  @override
  String usBridgeClarifySent(String callName) {
    return 'Đã gửi thêm ý cho $callName';
  }

  @override
  String get usBridgeNextKicker => 'CẦU NỐI · HAI BẠN ĐỀU ĐÃ HIỂU';

  @override
  String get usBridgeNextSub =>
      'Chọn một điều cả hai có thể làm. Không cần giải quyết hết mọi chuyện hôm nay.';

  @override
  String get usBridgeWhen => 'Khi nào?';

  @override
  String get usBridgeWhichChild => 'Trông bé nào?';

  @override
  String get usBridgeReminder => 'Tạo nhắc cho cả hai';

  @override
  String usBridgeReminderSub(String time) {
    return 'Nhắc lúc $time — chỉ hai bạn thấy';
  }

  @override
  String get usBridgeNotConfirmed => 'Chưa xác nhận';

  @override
  String get usBridgeAgreed => 'Đã đồng ý';

  @override
  String get usBridgeConfirmStep => 'Xác nhận bước này';

  @override
  String get usBridgeConfirmNote =>
      'Bước được áp dụng khi cả hai cùng xác nhận. Bạn vẫn có thể đổi lựa chọn.';

  @override
  String get usBridgeCloseTitle => 'Hai bạn muốn đóng phiên này chứ?';

  @override
  String get usBridgeCloseSub => 'Phiên chỉ đóng khi cả hai cùng đồng ý.';

  @override
  String usBridgeStepChosen(String when) {
    return 'Bước đã chọn · $when';
  }

  @override
  String usBridgeRelativeWhen(String day, String time) {
    String _temp0 = intl.Intl.selectLogic(day, {
      'tonight': 'tối nay $time',
      'lastNight': 'tối qua $time',
      'today': 'hôm nay $time',
      'yesterday': 'hôm qua $time',
      'other': '$time',
    });
    return '$_temp0';
  }

  @override
  String usBridgePartnerAgreedClose(String callName) {
    return '$callName đã đồng ý đóng phiên';
  }

  @override
  String usBridgeThanksLabel(String callName) {
    return 'Gửi lời cảm ơn cho $callName? (tuỳ chọn)';
  }

  @override
  String usBridgeThanksListened(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'father': 'Cảm ơn anh đã lắng nghe 💛',
      'other': 'Cảm ơn em đã lắng nghe 💛',
    });
    return '$_temp0';
  }

  @override
  String usBridgeThanksShort(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'father': 'Cảm ơn anh',
      'other': 'Cảm ơn em',
    });
    return '$_temp0';
  }

  @override
  String usBridgeRetention(int days, String date) {
    return 'Nội dung phiên tự xoá sau $days ngày. Chỉ còn dòng “Đã có một phiên Cầu nối ngày $date”.';
  }

  @override
  String get usBridgeCloseConfirm => 'Đóng phiên';

  @override
  String get usBridgeCloseLater => 'Chưa, để sau';

  @override
  String get usBridgeClosed => 'Đã đóng phiên Cầu nối';

  @override
  String get usSafetyQuickExit => 'Thoát nhanh';

  @override
  String get usSafetyHeadline => 'Sự an toàn của bạn là quan trọng nhất';

  @override
  String get usSafetyBody =>
      'Bạn không cần nói chuyện trực tiếp lúc này. Nếu bạn hoặc các con đang gặp nguy hiểm, hãy gọi ngay cho một trong các số dưới đây.';

  @override
  String usSafetyCall(String number) {
    return 'Gọi $number';
  }

  @override
  String get usSafetyTrustedTitle => 'Liên hệ một người bạn tin cậy';

  @override
  String get usSafetyTrustedSub => 'Người thân, bạn bè hoặc hàng xóm bạn tin';

  @override
  String get usSafetyPrivateNote =>
      'Nội dung bạn vừa viết được giữ riêng, không gửi cho ai.';

  @override
  String usSafetyNoNotify(String callName) {
    return '$callName không nhận thông báo nào về màn hình này.';
  }

  @override
  String get usSafetyNoHistory =>
      'Màn hình này không được ghi vào lịch sử phiên.';

  @override
  String get usSafetyKeepPrivate => 'Giữ riêng nội dung này';

  @override
  String get usSafetyDisclaimer =>
      'Baby Family không phải dịch vụ khẩn cấp hay trị liệu. Tính năng này luôn miễn phí.';

  @override
  String get usCoupleWeekCheckins => 'lần check-in';

  @override
  String get usCoupleWeekCheckinsSub =>
      'Hai bạn đã chia sẻ hôm nay mình thế nào';

  @override
  String get usCoupleWeekRequests => 'lời nhờ được hỗ trợ';

  @override
  String get usCoupleWeekRequestsSub => 'Nhận và làm giúp nhau';

  @override
  String get usCoupleWeekThanks => 'lời cảm ơn';

  @override
  String get usCoupleWeekThanksSub => 'Gửi cho nhau trong tuần';

  @override
  String get usCoupleWeekTogether => 'nhiệm vụ cùng nhau';

  @override
  String get usCoupleWeekTogetherSub => 'Từ Nhiệm vụ hai ta';

  @override
  String get usCoupleWeekThanksKicker => 'MỘT LỜI CẢM ƠN TRONG TUẦN';

  @override
  String usCoupleWeekThanksMeta(String callName, String date) {
    return '$callName · $date';
  }

  @override
  String get usCoupleWeekTogetherLabel => 'Hai ta đã cùng nhau';

  @override
  String get usCoupleWeekNote =>
      'Không có điểm số, không so sánh — chỉ là những điều hai bạn đã làm cho nhau.';

  @override
  String get usCoupleWeekSendThanks => 'Gửi một lời cảm ơn';

  @override
  String get recapDayDiscard => 'Bỏ';

  @override
  String recapDayKicker(String date) {
    return 'CÂU CHUYỆN NGÀY · $date';
  }

  @override
  String recapDayChild(String name, String age) {
    return '$name · $age';
  }

  @override
  String get recapDayRewrite => 'Viết lại';

  @override
  String get recapDayManual => 'Tự viết';

  @override
  String get recapDayRewritten => 'Đã viết lại đoạn văn';

  @override
  String get recapDayMemories => 'Ký ức hôm nay';

  @override
  String recapDaySelected(int selected, int total) {
    return 'Đã chọn $selected/$total';
  }

  @override
  String recapDayItemMeta(String kind, String time) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'photo': 'Ảnh',
      'mission': 'Nhiệm vụ đã xong',
      'voice': 'Giọng nói',
      'quote': 'Câu nói',
      'video': 'Video',
      'other': 'Ký ức',
    });
    return '$_temp0 · $time';
  }

  @override
  String get recapDayHint => 'Câu chuyện chỉ dùng những ký ức bạn đã tick.';

  @override
  String get recapDayPhotos => 'Ảnh kèm';

  @override
  String get recapDayWhoSees => 'Ai sẽ thấy';

  @override
  String get recapDaySave => 'Lưu câu chuyện';

  @override
  String get recapDaySaved => 'Đã lưu câu chuyện ngày';

  @override
  String get recapDayTitleEdit => 'Tiêu đề câu chuyện';

  @override
  String recapDayOpen(String name) {
    return 'Câu chuyện ngày của $name';
  }

  @override
  String recapMonthHeadline(String name, int month) {
    return '$name tròn $month tháng 🎉';
  }

  @override
  String recapMonthRange(int month, String range) {
    return 'Tháng thứ $month · $range';
  }

  @override
  String recapMonthLabel(int month) {
    return 'Tháng $month';
  }

  @override
  String recapMonthNow(int month) {
    return 'Tháng $month · hôm nay';
  }

  @override
  String get recapMonthVoices => 'câu nói & giọng nói';

  @override
  String get recapMonthVoicesKicker => 'CÂU NÓI & GIỌNG NÓI';

  @override
  String recapMonthFirstMeta(String age, String date) {
    return '$age · $date';
  }

  @override
  String recapMonthVoiceMeta(String date, String callName) {
    return '$date · $callName ghi';
  }

  @override
  String get careMenuStats => 'Thống kê chăm con';

  @override
  String get careStatsDone => 'Nhiệm vụ cả nhà đã hoàn thành';

  @override
  String get careStatsUnit => 'việc trong tuần';

  @override
  String careStatsCategory(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'care': 'Chăm sóc',
      'bonding': 'Gắn kết',
      'outing': 'Ra ngoài',
      'support': 'Hỗ trợ nhau',
      'together': 'Cùng nhau',
      'other': 'Khác',
    });
    return '$_temp0';
  }

  @override
  String get careStatsNote => 'Nhiệm vụ “Hai ta” không tính vào chăm con.';

  @override
  String careStatsBloomOf(int total) {
    return '/ $total ngày';
  }

  @override
  String get careStatsBloomLabel => 'cây của nhà mình nở hoa';

  @override
  String get careStatsDisclaimer =>
      'Chỉ dựa trên hoạt động ghi trong app. Còn rất nhiều điều bố mẹ làm cho nhau mà app không đếm được.';

  @override
  String get careStatsPrivacy => 'Chỉ Papa & Mama xem được thống kê này';

  @override
  String get commonPrevWeek => 'Tuần trước';

  @override
  String get commonNextWeek => 'Tuần sau';

  @override
  String memPendingNotify(String name, int count, String child) {
    return '$name vừa đăng $count ảnh của $child — chờ bạn duyệt';
  }

  @override
  String get authProviderUnavailable =>
      'Bản này chưa hỗ trợ đăng nhập bằng Apple/Google. Vui lòng dùng số điện thoại.';

  @override
  String onboardingPartnerApproveTitle(String callName) {
    return '$callName muốn tham gia nhà mình';
  }

  @override
  String onboardingPartnerApproveBody(int days) {
    return 'Hãy chắc chắn đây đúng là bạn đời của bạn. Sau khi đồng ý, nhà mình được dùng thử miễn phí $days ngày.';
  }

  @override
  String get onboardingPartnerApprove => 'Đồng ý';

  @override
  String get onboardingPartnerReject => 'Không phải';

  @override
  String get errorOtpInvalid =>
      'Mã chưa đúng hoặc đã hết hạn. Vui lòng thử lại.';

  @override
  String get errorRateLimited =>
      'Bạn thao tác hơi nhanh. Vui lòng đợi một chút rồi thử lại.';

  @override
  String get errorPhoneNotSupported => 'Số điện thoại này chưa được hỗ trợ.';

  @override
  String get errorInviteUnavailable =>
      'Lời mời đã hết hạn hoặc đã được dùng. Nhờ người mời gửi lại nhé.';

  @override
  String get errorAlreadyInFamily =>
      'Bạn đang là Bố/Mẹ của một gia đình khác nên chưa tham gia được.';

  @override
  String get errorServiceUnavailable =>
      'Máy chủ đang bận. Vui lòng thử lại sau ít phút.';

  @override
  String get memEditTitle => 'Sửa ký ức';

  @override
  String get memEditSaved => 'Đã lưu thay đổi';

  @override
  String get memEditAuthorOnlyHint =>
      'Chỉ người đăng sửa được chú thích và ngày. Bạn vẫn đổi được bé và người xem.';

  @override
  String get memEditMediaHint => 'Chưa thêm hoặc bớt ảnh được khi sửa ký ức.';

  @override
  String get errorVersionConflict =>
      'Ký ức vừa được cập nhật ở nơi khác. Xem lại rồi lưu nhé.';

  @override
  String get errorMemoryNotEditable => 'Bạn không sửa được phần này của ký ức.';

  @override
  String get errorRequestOpenLimit =>
      'Bạn đang có 5 lời nhờ chưa xong. Chờ bớt một lời nhờ rồi gửi tiếp nhé.';

  @override
  String get errorRequestResendBlocked =>
      'Lời nhờ này vừa được trả lời “Hôm nay không được”. Thử lại sau nhé.';

  @override
  String get errorRequestChanged =>
      'Lời nhờ vừa thay đổi. Xem lại trạng thái mới nhé.';

  @override
  String get notiSomeone => 'Một thành viên';

  @override
  String notiMemoryPublished(String name) {
    return '$name vừa thêm một ký ức mới';
  }

  @override
  String notiCommentCreated(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Có $count bình luận mới trên một ký ức',
      one: '$name vừa bình luận một ký ức',
    );
    return '$_temp0';
  }

  @override
  String notiReactionChanged(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Có $count cảm xúc mới trên một ký ức',
      one: '$name đã thả cảm xúc cho một ký ức',
    );
    return '$_temp0';
  }

  @override
  String notiRequestCreated(String name) {
    return '$name vừa gửi cho bạn một lời nhờ';
  }

  @override
  String notiRequestAccepted(String name) {
    return '$name đã nhận lời nhờ của bạn';
  }

  @override
  String notiRequestDone(String name) {
    return '$name đã làm xong lời nhờ 💛';
  }

  @override
  String notiRequestDeclined(String name) {
    return '$name báo hôm nay chưa làm được lời nhờ';
  }

  @override
  String notiRequestAcknowledged(String name) {
    return '$name đã xem lời nhờ của bạn';
  }

  @override
  String notiCheckinShared(String name) {
    return '$name vừa chia sẻ trạng thái';
  }

  @override
  String get notiAppreciationCreated => 'Bạn nhận được một lời cảm ơn ❤️';

  @override
  String get notiGeneric => 'Bạn có một cập nhật mới';

  @override
  String get heartsReasonMission => 'Một việc nhỏ cho gia đình';

  @override
  String get heartsReasonRequest => 'Giúp bạn đời một lời nhờ';

  @override
  String get heartsReasonOther => 'Hearts của bạn';

  @override
  String setDelOtpSent(String phone) {
    return 'Đã gửi mã xác thực tới $phone';
  }

  @override
  String get errorReauthRequired =>
      'Phiên xác thực đã hết hạn. Bạn xác thực lại giúp mình nhé.';

  @override
  String get errorExportActive =>
      'Đang có một bản xuất chưa xong. Bạn đợi bản đó xong nhé.';

  @override
  String get errorEventDateInvalid =>
      'Ngày của sự kiện chưa hợp lệ. Bạn kiểm tra lại nhé.';

  @override
  String calendarChildBirthday(String name, int count) {
    return 'Sinh nhật $count tuổi của $name';
  }

  @override
  String calendarChildMonthiversary(String name, int count) {
    return '$name tròn $count tháng';
  }

  @override
  String notiEventReminder(String title) {
    return 'Nhắc lịch: $title';
  }

  @override
  String get notiEventReminderPrivate => 'Bạn có một lịch hẹn sắp tới';

  @override
  String get notiBadgeEarned => 'Gia đình vừa nhận một huy hiệu mới 🏅';

  @override
  String get memCommentsAllow => 'Cho phép bình luận';

  @override
  String get memCommentsAllowHint => 'Tắt thì mọi người vẫn thả cảm xúc được';

  @override
  String get memCommentsOff => 'Bình luận đã tắt cho ký ức này';
}
