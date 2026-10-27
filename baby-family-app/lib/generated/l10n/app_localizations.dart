import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('vi'),
    Locale('en'),
    Locale('ja'),
    Locale('zh'),
  ];

  /// Tên ứng dụng hiển thị trong app
  ///
  /// In vi, this message translates to:
  /// **'Baby Family'**
  String get appName;

  /// Nút đi tiếp dùng chung
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get commonContinue;

  /// Nút bắt đầu (cuối onboarding/welcome)
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu'**
  String get commonStart;

  /// Nút huỷ dùng chung
  ///
  /// In vi, this message translates to:
  /// **'Huỷ'**
  String get commonCancel;

  /// Nút xác nhận dùng chung
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get commonConfirm;

  /// Nút thử lại khi lỗi
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get commonRetry;

  /// Nút đóng dùng chung
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get commonClose;

  /// Nút sao chép nội dung lỗi
  ///
  /// In vi, this message translates to:
  /// **'Sao chép lỗi'**
  String get commonCopyError;

  /// Số ngày còn lại (dùng thử, lời mời...). Mẫu ICU plural.
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =0{Hôm nay là ngày cuối} other{Còn {count} ngày}}'**
  String commonDaysLeft(int count);

  /// Mẫu placeholder ngày giờ theo locale
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật lúc {time}'**
  String commonUpdatedAt(DateTime time);

  /// Lỗi chung khi không có message từ server
  ///
  /// In vi, this message translates to:
  /// **'Có lỗi xảy ra, vui lòng thử lại.'**
  String get errorGeneric;

  /// Lỗi mạng / timeout
  ///
  /// In vi, this message translates to:
  /// **'Không kết nối được máy chủ. Vui lòng kiểm tra mạng và thử lại.'**
  String get errorNetwork;

  /// Gia hạn phiên thất bại do mạng
  ///
  /// In vi, this message translates to:
  /// **'Không kết nối được máy chủ để gia hạn phiên đăng nhập. Vui lòng kiểm tra mạng và thử lại.'**
  String get errorRenewSessionNetwork;

  /// 401 — phải đăng nhập lại
  ///
  /// In vi, this message translates to:
  /// **'Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.'**
  String get errorSessionExpired;

  /// 426 — bắt buộc cập nhật app
  ///
  /// In vi, this message translates to:
  /// **'Phiên bản ứng dụng đã cũ. Vui lòng cập nhật để tiếp tục sử dụng.'**
  String get errorUpgradeRequired;

  /// Tiêu đề màn lỗi khởi động
  ///
  /// In vi, this message translates to:
  /// **'Không khởi động được ứng dụng'**
  String get errorStartupTitle;

  /// Mô tả màn lỗi khởi động
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng mở lại ứng dụng. Nếu vẫn lỗi, gửi nội dung dưới đây cho bộ phận hỗ trợ:'**
  String get errorStartupDescription;

  /// Tiêu đề bottom sheet chọn ngôn ngữ
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngôn ngữ'**
  String get languagePickerTitle;

  /// ONB-01 slide 1 — tiêu đề
  ///
  /// In vi, this message translates to:
  /// **'Lưu giữ hành trình của con'**
  String get welcomeSlide1Title;

  /// ONB-01 slide 1 — mô tả
  ///
  /// In vi, this message translates to:
  /// **'Từ ảnh siêu âm đầu tiên đến bước đi chập chững — mọi khoảnh khắc được giữ riêng tư cho gia đình.'**
  String get welcomeSlide1Description;

  /// ONB-01 slide 2 — tiêu đề
  ///
  /// In vi, this message translates to:
  /// **'Papa & Mama cùng chăm con'**
  String get welcomeSlide2Title;

  /// ONB-01 slide 2 — mô tả
  ///
  /// In vi, this message translates to:
  /// **'Những nhiệm vụ nhỏ mỗi ngày giúp Papa và Mama chia sẻ việc chăm con mà không cần nhắc nhau.'**
  String get welcomeSlide2Description;

  /// ONB-01 slide 3 — tiêu đề
  ///
  /// In vi, this message translates to:
  /// **'Ông bà cùng theo dõi cháu'**
  String get welcomeSlide3Title;

  /// ONB-01 slide 3 — mô tả
  ///
  /// In vi, this message translates to:
  /// **'Mời ông bà, người thân xem cháu lớn lên — an toàn, riêng tư, không cần mạng xã hội.'**
  String get welcomeSlide3Description;

  /// ONB-01 — link nhập mã mời
  ///
  /// In vi, this message translates to:
  /// **'Tôi đã có mã mời'**
  String get welcomeHaveInviteCode;

  /// Dùng chung — Lưu
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get commonSave;

  /// Dùng chung — Hoàn tất
  ///
  /// In vi, this message translates to:
  /// **'Hoàn tất'**
  String get commonDone;

  /// Dùng chung — Thêm
  ///
  /// In vi, this message translates to:
  /// **'Thêm'**
  String get commonAdd;

  /// Dùng chung — Xem tất cả
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả'**
  String get commonSeeAll;

  /// Dùng chung — Quay lại
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get commonBack;

  /// Dùng chung — Chưa có nội dung
  ///
  /// In vi, this message translates to:
  /// **'Chưa có nội dung'**
  String get commonEmptyTitle;

  /// Dùng chung — Lưu một khoảnh khắc đầu tiên cho nhà mình nhé.
  ///
  /// In vi, this message translates to:
  /// **'Lưu một khoảnh khắc đầu tiên cho nhà mình nhé.'**
  String get commonEmptyMessage;

  /// Dùng chung — Bạn đang ngoại tuyến. Nội dung đã lưu vẫn ở đây.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang ngoại tuyến. Nội dung đã lưu vẫn ở đây.'**
  String get commonOffline;

  /// Dùng chung — Dữ liệu mẫu
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu mẫu'**
  String get commonMockMode;

  /// Dùng chung — Cả nhà
  ///
  /// In vi, this message translates to:
  /// **'Cả nhà'**
  String get commonAllFamily;

  /// Dùng chung — Của tôi
  ///
  /// In vi, this message translates to:
  /// **'Của tôi'**
  String get commonMine;

  /// Dùng chung — Việc của {callName}
  ///
  /// In vi, this message translates to:
  /// **'Việc của {callName}'**
  String commonPartnerTasks(String callName);

  /// Dùng chung — Cùng làm
  ///
  /// In vi, this message translates to:
  /// **'Cùng làm'**
  String get commonTogether;

  /// Dùng chung — Chỉ mình tôi
  ///
  /// In vi, this message translates to:
  /// **'Chỉ mình tôi'**
  String get commonOnlyYou;

  /// Dùng chung — Chỉ Papa & Mama
  ///
  /// In vi, this message translates to:
  /// **'Chỉ Papa & Mama'**
  String get commonOnlyParents;

  /// Dùng chung — Ảnh
  ///
  /// In vi, this message translates to:
  /// **'Ảnh'**
  String get commonPhotos;

  /// Dùng chung — Dòng thời gian
  ///
  /// In vi, this message translates to:
  /// **'Dòng thời gian'**
  String get commonTimeline;

  /// Dùng chung — Bộ sưu tập
  ///
  /// In vi, this message translates to:
  /// **'Bộ sưu tập'**
  String get commonCollections;

  /// Dùng chung — Ký ức
  ///
  /// In vi, this message translates to:
  /// **'Ký ức'**
  String get commonMemory;

  /// Dùng chung — Nhật ký
  ///
  /// In vi, this message translates to:
  /// **'Nhật ký'**
  String get commonDiary;

  /// Dùng chung — Cột mốc
  ///
  /// In vi, this message translates to:
  /// **'Cột mốc'**
  String get commonMilestone;

  /// Dùng chung — Thư gửi con
  ///
  /// In vi, this message translates to:
  /// **'Thư gửi con'**
  String get commonLetter;

  /// Dùng chung — Nhiệm vụ
  ///
  /// In vi, this message translates to:
  /// **'Nhiệm vụ'**
  String get commonMission;

  /// Dùng chung — Sự kiện
  ///
  /// In vi, this message translates to:
  /// **'Sự kiện'**
  String get commonEvent;

  /// Dùng chung — Check-in cảm xúc
  ///
  /// In vi, this message translates to:
  /// **'Check-in cảm xúc'**
  String get commonCheckin;

  /// Dùng chung — Lời nhờ
  ///
  /// In vi, this message translates to:
  /// **'Lời nhờ'**
  String get commonRequest;

  /// Dùng chung — Lời cảm ơn
  ///
  /// In vi, this message translates to:
  /// **'Lời cảm ơn'**
  String get commonThanks;

  /// Dùng chung — Chọn bé
  ///
  /// In vi, this message translates to:
  /// **'Chọn bé'**
  String get commonSelectChild;

  /// Dùng chung — Ghi lại một điều nhỏ
  ///
  /// In vi, this message translates to:
  /// **'Ghi lại một điều nhỏ'**
  String get commonQuickCreate;

  /// Dùng chung — Tên
  ///
  /// In vi, this message translates to:
  /// **'Tên'**
  String get commonName;

  /// Dùng chung — Ngày
  ///
  /// In vi, this message translates to:
  /// **'Ngày'**
  String get commonDate;

  /// Dùng chung — Nội dung
  ///
  /// In vi, this message translates to:
  /// **'Nội dung'**
  String get commonBody;

  /// Dùng chung — Đã lưu trong bản dùng thử
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu trong bản dùng thử'**
  String get commonSaved;

  /// Dùng chung — Bạn điền đủ thông tin trước khi lưu nhé.
  ///
  /// In vi, this message translates to:
  /// **'Bạn điền đủ thông tin trước khi lưu nhé.'**
  String get commonInvalidInput;

  /// Dùng chung — {years, plural, =0{{months} tháng} other{{years} tuổi {months} tháng}}
  ///
  /// In vi, this message translates to:
  /// **'{years, plural, =0{{months} tháng} other{{years} tuổi {months} tháng}}'**
  String commonChildAge(int months, int years);

  /// Dùng chung — Tuần thai {week}
  ///
  /// In vi, this message translates to:
  /// **'Tuần thai {week}'**
  String commonPregnancyWeek(int week);

  /// Dùng chung — {count, plural, =0{0 ký ức} other{{count} ký ức}}
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =0{0 ký ức} other{{count} ký ức}}'**
  String commonCountMemories(int count);

  /// Dùng chung — {count} Hearts
  ///
  /// In vi, this message translates to:
  /// **'{count} Hearts'**
  String commonHearts(int count);

  /// Điều hướng Parent — Trang chủ
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get navHome;

  /// Điều hướng Parent — Ký ức
  ///
  /// In vi, this message translates to:
  /// **'Ký ức'**
  String get navMemories;

  /// Điều hướng Parent — Chăm con
  ///
  /// In vi, this message translates to:
  /// **'Chăm con'**
  String get navCare;

  /// Điều hướng Parent — Papa & Mama
  ///
  /// In vi, this message translates to:
  /// **'Papa & Mama'**
  String get navUs;

  /// HOME-01/02 — Chào {name}
  ///
  /// In vi, this message translates to:
  /// **'Chào {name}'**
  String homeGreeting(String name);

  /// HOME-01/02 — Hôm nay của các con
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay của các con'**
  String get homeToday;

  /// HOME-01/02 — Ngày đặc biệt
  ///
  /// In vi, this message translates to:
  /// **'Ngày đặc biệt'**
  String get homeSpecialDay;

  /// HOME-01/02 — Con lớn từng tháng
  ///
  /// In vi, this message translates to:
  /// **'Chụp ảnh tháng'**
  String get homeMonthlyPhoto;

  /// HOME-01/02 — Việc nhỏ hôm nay
  ///
  /// In vi, this message translates to:
  /// **'Nhiệm vụ hôm nay'**
  String get homeMissions;

  /// HOME-01/02 — Gợi ý ghi lại
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý ghi lại'**
  String get homePrompt;

  /// HOME-01/02 — Lưu câu nói của con
  ///
  /// In vi, this message translates to:
  /// **'Ghi câu nói'**
  String get homeRecordQuote;

  /// HOME-01/02 — Ký ức gần đây
  ///
  /// In vi, this message translates to:
  /// **'Mới trong nhà'**
  String get homeRecent;

  /// HOME-01/02 — Tuần này của nhà mình
  ///
  /// In vi, this message translates to:
  /// **'Tuần này của nhà mình'**
  String get homeThisWeek;

  /// HOME-01/02 — Cây gia đình
  ///
  /// In vi, this message translates to:
  /// **'Cây gia đình'**
  String get homeFamilyTree;

  /// HOME-01/02 — Gia đình mình
  ///
  /// In vi, this message translates to:
  /// **'Gia đình mình'**
  String get homeFamily;

  /// CARE — Chăm con
  ///
  /// In vi, this message translates to:
  /// **'Chăm con'**
  String get careTitle;

  /// CARE — Cây gia đình hôm nay
  ///
  /// In vi, this message translates to:
  /// **'Cây hôm nay'**
  String get careTodayTree;

  /// CARE — Đã xong {done}/{total} việc
  ///
  /// In vi, this message translates to:
  /// **'{done}/{total} việc của nhà mình'**
  String careProgress(int done, int total);

  /// CARE — Thêm nhiệm vụ
  ///
  /// In vi, this message translates to:
  /// **'Thêm nhiệm vụ'**
  String get careAddMission;

  /// CARE — Tên nhiệm vụ
  ///
  /// In vi, this message translates to:
  /// **'Tên nhiệm vụ'**
  String get careMissionTitle;

  /// CARE — Ai thực hiện?
  ///
  /// In vi, this message translates to:
  /// **'Ai thực hiện?'**
  String get careWhoDoes;

  /// CARE — Khi nào?
  ///
  /// In vi, this message translates to:
  /// **'Khi nào?'**
  String get careWhen;

  /// CARE — Nhắc nhẹ
  ///
  /// In vi, this message translates to:
  /// **'Nhắc nhẹ'**
  String get careReminder;

  /// CARE — Lặp lại
  ///
  /// In vi, this message translates to:
  /// **'Lặp lại'**
  String get careRepeat;

  /// CARE — Nhờ {callName} làm giúp
  ///
  /// In vi, this message translates to:
  /// **'Nhờ {callName} làm giúp'**
  String careAskPartner(String callName);

  /// CARE — Một việc nhỏ, một chút yêu thương
  ///
  /// In vi, this message translates to:
  /// **'Một việc nhỏ, một chút yêu thương'**
  String get careCompleteTitle;

  /// CARE — Lưu thành ký ức
  ///
  /// In vi, this message translates to:
  /// **'Lưu thành ký ức'**
  String get careSaveMoment;

  /// CARE — Hoàn tác
  ///
  /// In vi, this message translates to:
  /// **'Hoàn tác'**
  String get careUndo;

  /// CARE — Đổi nhiệm vụ
  ///
  /// In vi, this message translates to:
  /// **'Đổi nhiệm vụ'**
  String get careSwapTitle;

  /// CARE — Bỏ qua hôm nay
  ///
  /// In vi, this message translates to:
  /// **'Bỏ khỏi hôm nay (không bị trừ gì)'**
  String get careRemoveToday;

  /// CARE — Cây gia đình
  ///
  /// In vi, this message translates to:
  /// **'Cây gia đình'**
  String get careTreeTitle;

  /// CARE — Cấp {level}
  ///
  /// In vi, this message translates to:
  /// **'Cấp {level}'**
  String careTreeLevel(int level);

  /// CARE — Cùng chăm cây lớn thêm một chút
  ///
  /// In vi, this message translates to:
  /// **'Cùng chăm cây lớn thêm một chút'**
  String get careTreeNext;

  /// CARE — Đóng góp của cả nhà
  ///
  /// In vi, this message translates to:
  /// **'Đóng góp của cả nhà'**
  String get careContribution;

  /// CARE — Hearts của mỗi người là riêng tư. Cây gia đình cùng lớn từ những việc nhỏ.
  ///
  /// In vi, this message translates to:
  /// **'Hearts của mỗi người chỉ người đó thấy. Không so sánh, không bao giờ bị trừ.'**
  String get careHeartsPrivacy;

  /// US — Papa & Mama — Papa & Mama
  ///
  /// In vi, this message translates to:
  /// **'Papa & Mama'**
  String get usTitle;

  /// US — Papa & Mama — Hôm nay bạn thấy thế nào?
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay bạn thấy thế nào?'**
  String get usHowAreYou;

  /// US — Papa & Mama — Năng lượng của bạn
  ///
  /// In vi, this message translates to:
  /// **'Năng lượng của bạn'**
  String get usEnergy;

  /// US — Papa & Mama — Bạn đang cần gì?
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang cần gì?'**
  String get usNeed;

  /// US — Papa & Mama — Chia sẻ với {callName}
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ với {callName}'**
  String usShareWith(String callName);

  /// US — Papa & Mama — Góc riêng chỉ Papa & Mama thấy
  ///
  /// In vi, this message translates to:
  /// **'Góc riêng chỉ Papa & Mama thấy'**
  String get usPrivate;

  /// US — Papa & Mama — Gửi lời nhờ
  ///
  /// In vi, this message translates to:
  /// **'Gửi lời nhờ'**
  String get usSendRequest;

  /// US — Papa & Mama — Bạn muốn nhờ điều gì?
  ///
  /// In vi, this message translates to:
  /// **'Bạn muốn nhờ điều gì?'**
  String get usRequestMessage;

  /// US — Papa & Mama — Mình nhận nhé
  ///
  /// In vi, this message translates to:
  /// **'Mình nhận nhé'**
  String get usAccept;

  /// US — Papa & Mama — Hôm nay mình chưa tiện
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay mình chưa tiện'**
  String get usDecline;

  /// US — Papa & Mama — Đã nhận lời
  ///
  /// In vi, this message translates to:
  /// **'Đã nhận lời'**
  String get usRequestAccepted;

  /// US — Papa & Mama — Đã giúp xong
  ///
  /// In vi, this message translates to:
  /// **'Đã giúp xong'**
  String get usRequestDone;

  /// US — Papa & Mama — Câu hỏi kết nối hôm nay
  ///
  /// In vi, this message translates to:
  /// **'Câu hỏi kết nối hôm nay'**
  String get usDailyQuestion;

  /// US — Papa & Mama — Nhật ký riêng
  ///
  /// In vi, this message translates to:
  /// **'Nhật ký riêng'**
  String get usJournal;

  /// US — Papa & Mama — Cầu nối yêu thương
  ///
  /// In vi, this message translates to:
  /// **'Cầu nối yêu thương'**
  String get usBridge;

  /// US — Papa & Mama — Tuần của hai mình
  ///
  /// In vi, this message translates to:
  /// **'Tuần của hai mình'**
  String get usWeek;

  /// US — Papa & Mama — Gửi một cái ôm
  ///
  /// In vi, this message translates to:
  /// **'Gửi một cái ôm'**
  String get usHug;

  /// US — Papa & Mama — Mình thấy bạn rồi
  ///
  /// In vi, this message translates to:
  /// **'Đã thấy'**
  String get usSeen;

  /// US — Papa & Mama — Mình làm thay nhé
  ///
  /// In vi, this message translates to:
  /// **'Để mình lo'**
  String get usTakeOver;

  /// US — Papa & Mama — Lời cảm ơn gần đây
  ///
  /// In vi, this message translates to:
  /// **'Lời cảm ơn gần đây'**
  String get usThanksRecent;

  /// FAM — Gia đình mình
  ///
  /// In vi, this message translates to:
  /// **'Gia đình mình'**
  String get familyTitle;

  /// FAM — Các con
  ///
  /// In vi, this message translates to:
  /// **'Các con'**
  String get familyChildren;

  /// FAM — Papa & Mama
  ///
  /// In vi, this message translates to:
  /// **'Papa & Mama'**
  String get familyParents;

  /// FAM — Người thân
  ///
  /// In vi, this message translates to:
  /// **'Ông bà & người thân'**
  String get familyRelatives;

  /// FAM — Mời người thân
  ///
  /// In vi, this message translates to:
  /// **'Mời người thân'**
  String get familyInvite;

  /// FAM — Quyền xem của người thân
  ///
  /// In vi, this message translates to:
  /// **'Quyền'**
  String get familyPermissions;

  /// FAM — Người thân chỉ thấy những gì bạn chia sẻ. Góc Papa & Mama luôn riêng tư.
  ///
  /// In vi, this message translates to:
  /// **'Người thân chỉ thấy những gì bạn chia sẻ. Góc Papa & Mama luôn riêng tư.'**
  String get familyPrivateNotice;

  /// FAM — Gia đình đang dùng thử
  ///
  /// In vi, this message translates to:
  /// **'Dùng thử miễn phí'**
  String get familyTrial;

  /// SET — Cài đặt
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settingsTitle;

  /// SET — Ngôn ngữ
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get settingsLanguage;

  /// SET — Giao diện
  ///
  /// In vi, this message translates to:
  /// **'Giao diện'**
  String get settingsAppearance;

  /// SET — Sáng
  ///
  /// In vi, this message translates to:
  /// **'Sáng'**
  String get settingsLight;

  /// SET — Tối
  ///
  /// In vi, this message translates to:
  /// **'Tối'**
  String get settingsDark;

  /// SET — Theo hệ thống
  ///
  /// In vi, this message translates to:
  /// **'Theo hệ thống'**
  String get settingsSystem;

  /// SET — Cỡ chữ
  ///
  /// In vi, this message translates to:
  /// **'Cỡ chữ'**
  String get settingsTextSize;

  /// SET — Bình thường
  ///
  /// In vi, this message translates to:
  /// **'Bình thường'**
  String get settingsRegular;

  /// SET — Lớn
  ///
  /// In vi, this message translates to:
  /// **'Lớn'**
  String get settingsLarge;

  /// SET — Rất lớn
  ///
  /// In vi, this message translates to:
  /// **'Rất lớn'**
  String get settingsExtraLarge;

  /// SET — Thông báo
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get settingsNotifications;

  /// SET — Quyền riêng tư
  ///
  /// In vi, this message translates to:
  /// **'Quyền riêng tư'**
  String get settingsPrivacy;

  /// SET — Gợi ý AI
  ///
  /// In vi, this message translates to:
  /// **'AI hỗ trợ'**
  String get settingsAi;

  /// SET — Bảo mật
  ///
  /// In vi, this message translates to:
  /// **'Bảo mật & Thiết bị'**
  String get settingsSecurity;

  /// SET — Dữ liệu của bạn
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu của tôi'**
  String get settingsData;

  /// SET — Gói dịch vụ
  ///
  /// In vi, this message translates to:
  /// **'Gói & thanh toán'**
  String get settingsBilling;

  /// SET — Trợ giúp
  ///
  /// In vi, this message translates to:
  /// **'Trợ giúp'**
  String get settingsHelp;

  /// SET — Về Baby Family
  ///
  /// In vi, this message translates to:
  /// **'Giới thiệu'**
  String get settingsAbout;

  /// SET — Đăng xuất
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get settingsLogout;

  /// SET — Đổi ngôn ngữ có hiệu lực ngay và không thay đổi múi giờ gia đình.
  ///
  /// In vi, this message translates to:
  /// **'Đổi ngay, không cần khởi động lại. Nội dung do gia đình viết không bị dịch.'**
  String get settingsLanguageNotice;

  /// SET — Hiển thị âm lịch
  ///
  /// In vi, this message translates to:
  /// **'Hiện ngày âm lịch'**
  String get settingsLunar;

  /// SET — Rung nhẹ khi thao tác
  ///
  /// In vi, this message translates to:
  /// **'Rung nhẹ khi thao tác'**
  String get settingsHaptics;

  /// SUB — Chọn gói cho nhà mình
  ///
  /// In vi, this message translates to:
  /// **'Giữ trọn từng khoảnh khắc của con'**
  String get billingTitle;

  /// SUB — House
  ///
  /// In vi, this message translates to:
  /// **'House'**
  String get billingHouse;

  /// SUB — Family
  ///
  /// In vi, this message translates to:
  /// **'Family'**
  String get billingFamily;

  /// SUB — Khôi phục giao dịch
  ///
  /// In vi, this message translates to:
  /// **'Khôi phục giao dịch'**
  String get billingRestore;

  /// SUB — Nâng cấp gói
  ///
  /// In vi, this message translates to:
  /// **'Nâng cấp gói'**
  String get billingUpgrade;

  /// SUB-07 — tiêu đề hết hạn dùng thử (không ghi cứng thời lượng)
  ///
  /// In vi, this message translates to:
  /// **'Thời gian dùng thử của nhà mình đã kết thúc'**
  String get billingExpired;

  /// SUB — Tải dữ liệu của gia đình
  ///
  /// In vi, this message translates to:
  /// **'Tải xuống dữ liệu'**
  String get billingExport;

  /// SUB — Ký ức luôn thuộc về gia đình. Bạn vẫn có thể tải dữ liệu khi gói hết hạn.
  ///
  /// In vi, this message translates to:
  /// **'Ký ức luôn thuộc về gia đình. Bạn vẫn có thể tải dữ liệu khi gói hết hạn.'**
  String get billingPrivacy;

  /// SUB — Thêm tối đa 12 người thân · 200 GB lưu trữ
  ///
  /// In vi, this message translates to:
  /// **'Thêm tối đa 12 người thân · 200 GB lưu trữ'**
  String get billingFamilyFeatures;

  /// SUB — Dành cho Papa & Mama · 50 GB lưu trữ
  ///
  /// In vi, this message translates to:
  /// **'Dành cho Papa & Mama · 50 GB lưu trữ'**
  String get billingHouseFeatures;

  /// NTF — Thông báo
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notificationsTitle;

  /// NTF — Tất cả
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get notificationsAll;

  /// NTF — Papa & Mama
  ///
  /// In vi, this message translates to:
  /// **'Papa & Mama'**
  String get notificationsPrivate;

  /// Trạng thái màn — Đang tải nội dung…
  ///
  /// In vi, this message translates to:
  /// **'Đang tải nội dung…'**
  String get stateLoading;

  /// Trạng thái màn — Chưa có ký ức nào. Lưu khoảnh khắc đầu tiên nhé!
  ///
  /// In vi, this message translates to:
  /// **'Chưa có ký ức nào. Lưu khoảnh khắc đầu tiên nhé!'**
  String get stateEmptyMemories;

  /// Trạng thái màn — Hôm nay chưa có nhiệm vụ. Thêm một việc nhỏ để cùng chăm con nhé.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay chưa có việc nào'**
  String get stateEmptyCare;

  /// Trạng thái màn — Chưa tải được nội dung. Bạn thử lại nhé.
  ///
  /// In vi, this message translates to:
  /// **'Chưa tải được nội dung. Bạn thử lại nhé.'**
  String get stateError;

  /// Dùng chung — Chọn
  ///
  /// In vi, this message translates to:
  /// **'Chọn'**
  String get commonChoose;

  /// Dùng chung — Bạn hãy điền thông tin này nhé
  ///
  /// In vi, this message translates to:
  /// **'Bạn hãy điền thông tin này nhé'**
  String get commonRequired;

  /// MEM — Ký ức
  ///
  /// In vi, this message translates to:
  /// **'Ký ức'**
  String get memoriesTitle;

  /// MEM — Dòng thời gian
  ///
  /// In vi, this message translates to:
  /// **'Dòng thời gian'**
  String get memoriesTimeline;

  /// MEM — Ảnh
  ///
  /// In vi, this message translates to:
  /// **'Ảnh'**
  String get memoriesPhotos;

  /// MEM — Bộ sưu tập
  ///
  /// In vi, this message translates to:
  /// **'Bộ sưu tập'**
  String get memoriesCollections;

  /// MEM — Tất cả
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get memoriesAll;

  /// MEM — Lần đầu
  ///
  /// In vi, this message translates to:
  /// **'Lần đầu'**
  String get memoriesFirsts;

  /// MEM — Câu nói
  ///
  /// In vi, this message translates to:
  /// **'Câu nói'**
  String get memoriesQuotes;

  /// MEM — Giọng nói
  ///
  /// In vi, this message translates to:
  /// **'Giọng nói'**
  String get memoriesVoices;

  /// MEM — Ký ức mới
  ///
  /// In vi, this message translates to:
  /// **'Ký ức mới'**
  String get memoriesNew;

  /// MEM — Bạn muốn nhớ điều gì về khoảnh khắc này?
  ///
  /// In vi, this message translates to:
  /// **'Bạn muốn nhớ điều gì về khoảnh khắc này?'**
  String get memoriesCaptionHint;

  /// MEM — Bé trong khoảnh khắc
  ///
  /// In vi, this message translates to:
  /// **'Bé trong khoảnh khắc'**
  String get memoriesChildren;

  /// MEM — Cả nhà
  ///
  /// In vi, this message translates to:
  /// **'Cả nhà'**
  String get memoriesFamily;

  /// MEM — Ngày xảy ra
  ///
  /// In vi, this message translates to:
  /// **'Ngày xảy ra'**
  String get memoriesDate;

  /// MEM — Hôm nay
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get memoriesToday;

  /// MEM — Ai thấy
  ///
  /// In vi, this message translates to:
  /// **'Ai thấy'**
  String get memoriesVisibility;

  /// MEM — Vị trí GPS trong ảnh luôn được xoá trước khi lưu.
  ///
  /// In vi, this message translates to:
  /// **'Vị trí GPS trong ảnh luôn được xoá trước khi lưu.'**
  String get memoriesPrivacyHint;

  /// MEM — Thêm ảnh
  ///
  /// In vi, this message translates to:
  /// **'Thêm ảnh'**
  String get memoriesAddMedia;

  /// MEM-06: tiến độ tải nền
  ///
  /// In vi, this message translates to:
  /// **'Đang tải {done}/{total} ảnh…'**
  String memUploadProgress(int done, int total);

  /// Offline-first: ký ức tạm chờ có mạng để tự gửi
  ///
  /// In vi, this message translates to:
  /// **'Chờ có mạng · sẽ tự đăng'**
  String get memUploadWaiting;

  /// Offline-first: ký ức không có ảnh đang gửi lên server
  ///
  /// In vi, this message translates to:
  /// **'Đang đăng…'**
  String get memPosting;

  /// MEM-06: tải lên lỗi
  ///
  /// In vi, this message translates to:
  /// **'Tải lên chưa xong'**
  String get memUploadFailed;

  /// MEM-06: thử lại tải lên
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get memUploadRetry;

  /// MEM-06: huỷ tải lên
  ///
  /// In vi, this message translates to:
  /// **'Huỷ'**
  String get memUploadCancel;

  /// MEM-05/09: chạm ảnh để đặt làm bìa
  ///
  /// In vi, this message translates to:
  /// **'Đặt làm ảnh bìa'**
  String get memoriesSetCover;

  /// MEM-05/09: nút bỏ ảnh khỏi ký ức
  ///
  /// In vi, this message translates to:
  /// **'Bỏ ảnh này'**
  String get memoriesRemoveMedia;

  /// MEM — Thêm góc nhìn của bạn
  ///
  /// In vi, this message translates to:
  /// **'Thêm góc nhìn của bạn'**
  String get memoriesAddPerspective;

  /// MEM — Cả hai cùng kể
  ///
  /// In vi, this message translates to:
  /// **'Cả hai cùng kể'**
  String get memoriesTogether;

  /// MEM — Viết bình luận…
  ///
  /// In vi, this message translates to:
  /// **'Viết bình luận…'**
  String get memoriesCommentHint;

  /// MEM — Bình luận
  ///
  /// In vi, this message translates to:
  /// **'Bình luận'**
  String get memoriesComments;

  /// MEM — Gửi
  ///
  /// In vi, this message translates to:
  /// **'Gửi'**
  String get memoriesSend;

  /// MEM — Con lớn từng tháng
  ///
  /// In vi, this message translates to:
  /// **'Con lớn từng tháng'**
  String get memoriesMonthly;

  /// MEM — Năm đầu tiên
  ///
  /// In vi, this message translates to:
  /// **'Năm đầu tiên'**
  String get memoriesYear;

  /// MEM — So sánh
  ///
  /// In vi, this message translates to:
  /// **'So sánh'**
  String get memoriesCompare;

  /// MEM — Ghép ảnh
  ///
  /// In vi, this message translates to:
  /// **'Ghép ảnh'**
  String get memoriesCollage;

  /// MEM — Chụp ảnh tháng
  ///
  /// In vi, this message translates to:
  /// **'Chụp ảnh tháng'**
  String get memoriesMonthlyPhoto;

  /// MEM — Bóng mờ ảnh trước
  ///
  /// In vi, this message translates to:
  /// **'Bóng mờ ảnh trước'**
  String get memoriesGhost;

  /// MEM — Chọn từ thư viện
  ///
  /// In vi, this message translates to:
  /// **'Chọn từ thư viện'**
  String get memoriesGallery;

  /// MEM — Chụp ảnh
  ///
  /// In vi, this message translates to:
  /// **'Chụp ảnh'**
  String get memoriesCapture;

  /// MEM — Câu nói của con
  ///
  /// In vi, this message translates to:
  /// **'Câu nói của con'**
  String get memoriesQuote;

  /// MEM — Con đã nói điều gì hôm nay?
  ///
  /// In vi, this message translates to:
  /// **'Con đã nói điều gì hôm nay?'**
  String get memoriesQuoteHint;

  /// MEM — Con nói khi nào?
  ///
  /// In vi, this message translates to:
  /// **'Con nói khi nào?'**
  String get memoriesQuoteContext;

  /// MEM — Ghi âm giọng con
  ///
  /// In vi, this message translates to:
  /// **'Ghi âm giọng con'**
  String get memoriesRecordVoice;

  /// MEM — Góc nhìn của bạn
  ///
  /// In vi, this message translates to:
  /// **'Góc nhìn của bạn'**
  String get memoriesPerspective;

  /// MEM — Bạn nhớ gì về khoảnh khắc này?
  ///
  /// In vi, this message translates to:
  /// **'Bạn nhớ gì về khoảnh khắc này?'**
  String get memoriesPerspectiveHint;

  /// MEM — Người xem giống ký ức gốc
  ///
  /// In vi, this message translates to:
  /// **'Người xem giống ký ức gốc'**
  String get memoriesInheritedVisibility;

  /// MEM — Hôm nay của bé
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay của bé'**
  String get memoriesStory;

  /// MEM — Trả lời…
  ///
  /// In vi, this message translates to:
  /// **'Trả lời…'**
  String get memoriesReplyHint;

  /// MEM — Chưa có ký ức nào. Lưu khoảnh khắc đầu tiên nhé!
  ///
  /// In vi, this message translates to:
  /// **'Chưa có ký ức nào. Lưu khoảnh khắc đầu tiên nhé!'**
  String get memoriesEmpty;

  /// MEM — Khoảnh khắc đã được lưu
  ///
  /// In vi, this message translates to:
  /// **'Khoảnh khắc đã được lưu'**
  String get memoriesSaved;

  /// MEM — Chọn ít nhất một bé hoặc Cả nhà
  ///
  /// In vi, this message translates to:
  /// **'Chọn ít nhất một bé hoặc Cả nhà'**
  String get memoriesChooseChildren;

  /// MEM — {month, plural, other{{month} tháng}}
  ///
  /// In vi, this message translates to:
  /// **'{month, plural, other{{month} tháng}}'**
  String memoriesMonthLabel(int month);

  /// MEM — Tuần {week}
  ///
  /// In vi, this message translates to:
  /// **'Tuần {week}'**
  String memoriesWeekLabel(int week);

  /// MEM — {count, plural, other{{count} ký ức}}
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, other{{count} ký ức}}'**
  String memoriesCount(int count);

  /// PRG — Hành trình thai kỳ
  ///
  /// In vi, this message translates to:
  /// **'Hành trình thai kỳ'**
  String get pregnancyTitle;

  /// PRG — Bụng bầu
  ///
  /// In vi, this message translates to:
  /// **'Bụng bầu'**
  String get pregnancyBump;

  /// PRG — Siêu âm
  ///
  /// In vi, this message translates to:
  /// **'Siêu âm'**
  String get pregnancyUltrasound;

  /// PRG — Chuẩn bị
  ///
  /// In vi, this message translates to:
  /// **'Chuẩn bị'**
  String get pregnancyPreparations;

  /// PRG — Chụp ảnh bụng tuần này
  ///
  /// In vi, this message translates to:
  /// **'Chụp ảnh bụng tuần này'**
  String get pregnancyCaptureBump;

  /// PRG — Có bóng mờ ảnh trước để giữ cùng góc chụp
  ///
  /// In vi, this message translates to:
  /// **'Có bóng mờ ảnh trước để giữ cùng góc chụp'**
  String get pregnancyGuide;

  /// PRG — Bỏ lỡ vài tuần cũng không sao — mỗi tấm ảnh đều quý.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ lỡ vài tuần cũng không sao — mỗi tấm ảnh đều quý.'**
  String get pregnancyBumpKindness;

  /// PRG — Nhắc chụp mỗi Chủ nhật
  ///
  /// In vi, this message translates to:
  /// **'Nhắc chụp mỗi Chủ nhật'**
  String get pregnancyRemind;

  /// PRG — Bé đã chào đời
  ///
  /// In vi, this message translates to:
  /// **'Bé đã chào đời'**
  String get pregnancyBirth;

  /// PRG — Đặt tên cho con
  ///
  /// In vi, this message translates to:
  /// **'Đặt tên cho con'**
  String get pregnancyNames;

  /// PRG — Lưu trữ hành trình
  ///
  /// In vi, this message translates to:
  /// **'Lưu trữ hành trình'**
  String get pregnancyArchive;

  /// PRG — Đã chuẩn bị {done}/{total}
  ///
  /// In vi, this message translates to:
  /// **'Đã chuẩn bị {done}/{total}'**
  String pregnancyPrepareProgress(int done, int total);

  /// PRG — Thêm mục
  ///
  /// In vi, this message translates to:
  /// **'Thêm mục'**
  String get pregnancyAddPreparation;

  /// PRG — Món nhà mình cần chuẩn bị
  ///
  /// In vi, this message translates to:
  /// **'Món nhà mình cần chuẩn bị'**
  String get pregnancyPreparationHint;

  /// PRG — Chuyển thành nhiệm vụ
  ///
  /// In vi, this message translates to:
  /// **'Chuyển thành nhiệm vụ'**
  String get pregnancyCreateMission;

  /// PRG — Chào mừng bé đến với nhà mình
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng bé đến với nhà mình'**
  String get pregnancyBirthWelcome;

  /// PRG — Tên của bé
  ///
  /// In vi, this message translates to:
  /// **'Tên hoặc tên ở nhà'**
  String get pregnancyBabyName;

  /// PRG — Tên ở nhà
  ///
  /// In vi, this message translates to:
  /// **'Tên ở nhà'**
  String get pregnancyNickname;

  /// PRG — Ngày chào đời
  ///
  /// In vi, this message translates to:
  /// **'Ngày sinh *'**
  String get pregnancyBirthDate;

  /// PRG — Giờ chào đời
  ///
  /// In vi, this message translates to:
  /// **'Giờ sinh'**
  String get pregnancyBirthTime;

  /// PRG — Cân nặng (kg)
  ///
  /// In vi, this message translates to:
  /// **'Cân nặng (kg)'**
  String get pregnancyBirthWeight;

  /// PRG — Giới tính (tuỳ chọn)
  ///
  /// In vi, this message translates to:
  /// **'Giới tính (tuỳ chọn)'**
  String get pregnancyBirthGender;

  /// PRG — Xem trước thẻ chào mừng
  ///
  /// In vi, this message translates to:
  /// **'Xem thẻ chào mừng'**
  String get pregnancyBirthPreview;

  /// PRG — Báo tin cho người thân?
  ///
  /// In vi, this message translates to:
  /// **'Báo tin cho người thân?'**
  String get pregnancyAnnounce;

  /// PRG — Chỉ người thân đang được chia sẻ thai kỳ. Ký ức thai kỳ trở thành chương mở đầu của bé.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ người thân đang được chia sẻ thai kỳ. Ký ức thai kỳ trở thành chương mở đầu của bé.'**
  String get pregnancyAnnounceHint;

  /// PRG — Chào mừng bé! Thông tin đã được lưu.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng bé! Thông tin đã được lưu.'**
  String get pregnancyBirthComplete;

  /// PRG — Mọi ký ức vẫn được giữ nguyên. Bạn có thể quay lại bất cứ lúc nào.
  ///
  /// In vi, this message translates to:
  /// **'Mọi ký ức vẫn được giữ nguyên. Bạn có thể quay lại bất cứ lúc nào.'**
  String get pregnancyArchiveIntro;

  /// PRG — Tạm dừng hành trình
  ///
  /// In vi, this message translates to:
  /// **'Tạm dừng hành trình'**
  String get pregnancyPause;

  /// PRG — Ẩn khỏi Trang chủ, tắt nhắc. Mở lại khi bạn muốn.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn khỏi Trang chủ, tắt nhắc. Mở lại khi bạn muốn.'**
  String get pregnancyPauseHint;

  /// PRG — Hành trình này đã dừng lại
  ///
  /// In vi, this message translates to:
  /// **'Hành trình này đã dừng lại'**
  String get pregnancyEnd;

  /// PRG — Chúng tôi rất tiếc. App sẽ ngừng mọi đếm ngược, nhắc nhở và lời chúc ngay lập tức.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi rất tiếc. App sẽ ngừng mọi đếm ngược, nhắc nhở và lời chúc ngay lập tức.'**
  String get pregnancyEndHint;

  /// PRG — Chỉ Papa & Mama xem các ký ức này
  ///
  /// In vi, this message translates to:
  /// **'Chỉ Papa & Mama xem các ký ức này'**
  String get pregnancyParentsOnly;

  /// PRG — Không có thông báo nào gửi tới người thân.
  ///
  /// In vi, this message translates to:
  /// **'Không có thông báo nào gửi tới người thân.'**
  String get pregnancyArchivePrivacy;

  /// PRG — Hành trình đã được lưu trữ riêng tư
  ///
  /// In vi, this message translates to:
  /// **'Hành trình đã được lưu trữ riêng tư'**
  String get pregnancyArchiveSaved;

  /// PRG — Chỉ Papa & Mama nhìn thấy
  ///
  /// In vi, this message translates to:
  /// **'Chỉ Papa & Mama nhìn thấy'**
  String get pregnancyPrivate;

  /// PRG — Cả hai thích
  ///
  /// In vi, this message translates to:
  /// **'Cả hai thích'**
  String get pregnancyBothLike;

  /// PRG — Thêm tên dự định
  ///
  /// In vi, this message translates to:
  /// **'Thêm tên dự định'**
  String get pregnancyAddName;

  /// PRG — Tên dự định
  ///
  /// In vi, this message translates to:
  /// **'Tên dự định'**
  String get pregnancyNameHint;

  /// PRG — Ý nghĩa
  ///
  /// In vi, this message translates to:
  /// **'Ý nghĩa'**
  String get pregnancyMeaning;

  /// PRG — Chọn tên này
  ///
  /// In vi, this message translates to:
  /// **'Chọn tên này'**
  String get pregnancyChooseName;

  /// PRG — Tên dự định đã được lưu
  ///
  /// In vi, this message translates to:
  /// **'Tên dự định đã được lưu'**
  String get pregnancyNameChosen;

  /// PRG — Ảnh mẫu đã sẵn sàng
  ///
  /// In vi, this message translates to:
  /// **'Ảnh mẫu đã sẵn sàng'**
  String get pregnancyMockMedia;

  /// Dùng chung — Bỏ qua
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua'**
  String get commonSkip;

  /// Dùng chung — Để sau
  ///
  /// In vi, this message translates to:
  /// **'Để sau'**
  String get commonLater;

  /// Dùng chung — hoặc
  ///
  /// In vi, this message translates to:
  /// **'hoặc'**
  String get commonOr;

  /// Dùng chung — Đã sao chép
  ///
  /// In vi, this message translates to:
  /// **'Đã sao chép'**
  String get commonCopied;

  /// Dùng chung — Chọn ảnh
  ///
  /// In vi, this message translates to:
  /// **'Chọn ảnh'**
  String get commonChoosePhoto;

  /// Dùng chung — Xoá ảnh
  ///
  /// In vi, this message translates to:
  /// **'Xoá ảnh'**
  String get commonRemovePhoto;

  /// Dùng chung — Điều khoản sử dụng
  ///
  /// In vi, this message translates to:
  /// **'Điều khoản sử dụng'**
  String get commonTerms;

  /// Dùng chung — Chính sách quyền riêng tư
  ///
  /// In vi, this message translates to:
  /// **'Chính sách quyền riêng tư'**
  String get commonPrivacyPolicy;

  /// Dùng chung — Tuỳ chọn
  ///
  /// In vi, this message translates to:
  /// **'Tuỳ chọn'**
  String get commonOptional;

  /// AUTH — Chào mừng đến Baby Family
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng đến Baby Family'**
  String get authTitle;

  /// AUTH — Đăng nhập để bắt đầu lưu giữ hành trình của con cùng cả nhà.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập để bắt đầu lưu giữ hành trình của con cùng cả nhà.'**
  String get authSubtitle;

  /// AUTH — Riêng tư
  ///
  /// In vi, this message translates to:
  /// **'Riêng tư'**
  String get authPrivate;

  /// AUTH-01 — chip dùng thử; {days} = thời lượng trial policy (mặc định 7)
  ///
  /// In vi, this message translates to:
  /// **'{days} ngày miễn phí'**
  String authTrial(int days);

  /// AUTH — Cả nhà
  ///
  /// In vi, this message translates to:
  /// **'Cả nhà'**
  String get authFamily;

  /// AUTH — Tiếp tục với Apple
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục với Apple'**
  String get authApple;

  /// AUTH — Tiếp tục với Google
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục với Google'**
  String get authGoogle;

  /// AUTH — Dùng số điện thoại
  ///
  /// In vi, this message translates to:
  /// **'Dùng số điện thoại'**
  String get authPhone;

  /// AUTH — Bằng việc tiếp tục, bạn đồng ý với Điều khoản sử dụng và Chính sách quyền riêng tư của Baby Family.
  ///
  /// In vi, this message translates to:
  /// **'Bằng việc tiếp tục, bạn đồng ý với Điều khoản sử dụng và Chính sách quyền riêng tư của Baby Family.'**
  String get authLegal;

  /// AUTH — Số điện thoại của bạn
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại của bạn'**
  String get authPhoneTitle;

  /// AUTH — Chúng tôi sẽ gửi mã xác thực 6 số qua Zalo hoặc SMS.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi sẽ gửi mã xác thực 6 số qua Zalo hoặc SMS.'**
  String get authPhoneSubtitle;

  /// AUTH — Số điện thoại
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại'**
  String get authPhoneLabel;

  /// AUTH — Mã quốc gia
  ///
  /// In vi, this message translates to:
  /// **'Mã quốc gia'**
  String get authCountryCode;

  /// AUTH — Số điện thoại chỉ dùng để đăng nhập, không hiển thị với ai.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại chỉ dùng để đăng nhập, không hiển thị với ai.'**
  String get authPhonePrivate;

  /// AUTH — Gửi mã
  ///
  /// In vi, this message translates to:
  /// **'Gửi mã'**
  String get authSendCode;

  /// AUTH — Nhập mã xác thực
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã xác thực'**
  String get authOtpTitle;

  /// AUTH — Mã 6 số đã gửi tới {phone}.
  ///
  /// In vi, this message translates to:
  /// **'Mã 6 số đã gửi qua Zalo tới {phone}.'**
  String authOtpSubtitle(String phone);

  /// AUTH — Mã demo: {code}
  ///
  /// In vi, this message translates to:
  /// **'Mã demo: {code}'**
  String authOtpDemo(String code);

  /// AUTH — Gửi lại mã
  ///
  /// In vi, this message translates to:
  /// **'Gửi lại mã'**
  String get authResend;

  /// AUTH — {seconds, plural, other{Gửi lại mã sau {seconds}s}}
  ///
  /// In vi, this message translates to:
  /// **'{seconds, plural, other{Gửi lại mã sau {seconds}s}}'**
  String authResendCountdown(int seconds);

  /// AUTH — Gửi qua SMS
  ///
  /// In vi, this message translates to:
  /// **'Gửi qua SMS'**
  String get authSendSms;

  /// AUTH — Đổi số điện thoại
  ///
  /// In vi, this message translates to:
  /// **'Đổi số điện thoại'**
  String get authChangePhone;

  /// AUTH — Giới thiệu một chút về bạn
  ///
  /// In vi, this message translates to:
  /// **'Giới thiệu một chút về bạn'**
  String get authProfileTitle;

  /// AUTH — Tên này sẽ hiển thị với bạn đời và người thân trong gia đình.
  ///
  /// In vi, this message translates to:
  /// **'Tên này sẽ hiển thị với bạn đời và người thân trong gia đình.'**
  String get authProfileSubtitle;

  /// AUTH — Tên của bạn
  ///
  /// In vi, this message translates to:
  /// **'Tên của bạn'**
  String get authNameLabel;

  /// AUTH — Tôi đồng ý Điều khoản sử dụng
  ///
  /// In vi, this message translates to:
  /// **'Tôi đồng ý Điều khoản sử dụng'**
  String get authTermsConsent;

  /// AUTH — Tôi đồng ý cho Baby Family xử lý dữ liệu cá nhân của tôi và con tôi theo Chính sách quyền riêng tư
  ///
  /// In vi, this message translates to:
  /// **'Tôi đồng ý cho Baby Family xử lý dữ liệu cá nhân của tôi và con tôi theo Chính sách quyền riêng tư'**
  String get authDataConsent;

  /// Lỗi xác thực/onboarding — Bạn điền thông tin này nhé.
  ///
  /// In vi, this message translates to:
  /// **'Bạn điền thông tin này nhé.'**
  String get errorRequired;

  /// Lỗi xác thực/onboarding — Số điện thoại chưa đúng định dạng.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại chưa đúng định dạng.'**
  String get errorPhone;

  /// Lỗi xác thực/onboarding — Bạn cần đồng ý cả hai mục để tiếp tục.
  ///
  /// In vi, this message translates to:
  /// **'Bạn cần đồng ý cả hai mục để tiếp tục.'**
  String get errorConsent;

  /// Lỗi xác thực/onboarding — Mã chưa đúng. Bạn thử lại nhé.
  ///
  /// In vi, this message translates to:
  /// **'Mã chưa đúng. Bạn thử lại nhé.'**
  String get errorOtp;

  /// Lỗi xác thực/onboarding — Mã đã hết hạn. Gửi lại mã nhé.
  ///
  /// In vi, this message translates to:
  /// **'Mã đã hết hạn. Gửi lại mã nhé.'**
  String get errorOtpExpired;

  /// Lỗi xác thực/onboarding — Mã mời gồm 8 chữ và số.
  ///
  /// In vi, this message translates to:
  /// **'Mã mời gồm 8 chữ và số.'**
  String get errorInviteCode;

  /// Lỗi xác thực/onboarding — Ngày sinh không thể ở tương lai.
  ///
  /// In vi, this message translates to:
  /// **'Ngày sinh không thể ở tương lai.'**
  String get errorBirthday;

  /// Lỗi xác thực/onboarding — Tuần thai cần nằm trong khoảng 4 đến 42.
  ///
  /// In vi, this message translates to:
  /// **'Tuần thai cần nằm trong khoảng 4 đến 42.'**
  String get errorPregnancyWeek;

  /// ONB — Bạn là ai trong gia đình?
  ///
  /// In vi, this message translates to:
  /// **'Bạn là ai trong gia đình?'**
  String get onboardingRoleTitle;

  /// ONB — Baby Family cần cả Papa và Mama cùng tham gia. Ông bà, người thân sẽ được mời vào sau.
  ///
  /// In vi, this message translates to:
  /// **'Baby Family cần cả Papa và Mama cùng tham gia. Ông bà, người thân sẽ được mời vào sau.'**
  String get onboardingRoleSubtitle;

  /// ONB — Bố của bé — cùng Mama quản lý gia đình
  ///
  /// In vi, this message translates to:
  /// **'Bố của bé — cùng Mama quản lý gia đình'**
  String get onboardingPapaDescription;

  /// ONB — Mẹ của bé — cùng Papa quản lý gia đình
  ///
  /// In vi, this message translates to:
  /// **'Mẹ của bé — cùng Papa quản lý gia đình'**
  String get onboardingMamaDescription;

  /// ONB — Người thân
  ///
  /// In vi, this message translates to:
  /// **'Người thân'**
  String get onboardingCircle;

  /// ONB — Ông bà, cô dì chú bác, người chăm bé — cần được mời vào gia đình
  ///
  /// In vi, this message translates to:
  /// **'Ông bà, cô dì chú bác, người chăm bé — cần được mời vào gia đình'**
  String get onboardingCircleDescription;

  /// ONB — Các con gọi bạn là
  ///
  /// In vi, this message translates to:
  /// **'Các con gọi bạn là'**
  String get onboardingCallName;

  /// ONB — Cách gọi khác
  ///
  /// In vi, this message translates to:
  /// **'Khác…'**
  String get onboardingOtherCallName;

  /// ONB — Bố
  ///
  /// In vi, this message translates to:
  /// **'Bố'**
  String get onboardingFatherCallName;

  /// ONB — Ba
  ///
  /// In vi, this message translates to:
  /// **'Ba'**
  String get onboardingFatherCallNameAlt;

  /// ONB — Mẹ
  ///
  /// In vi, this message translates to:
  /// **'Mẹ'**
  String get onboardingMotherCallName;

  /// ONB — Má
  ///
  /// In vi, this message translates to:
  /// **'Má'**
  String get onboardingMotherCallNameAlt;

  /// ONB — Đặt tên cho tổ ấm
  ///
  /// In vi, this message translates to:
  /// **'Đặt tên cho tổ ấm'**
  String get onboardingFamilyTitle;

  /// ONB — Tên gia đình chỉ hiển thị với Papa, Mama và người thân được mời.
  ///
  /// In vi, this message translates to:
  /// **'Tên gia đình chỉ hiển thị với Papa, Mama và người thân được mời.'**
  String get onboardingFamilySubtitle;

  /// ONB — Tên gia đình
  ///
  /// In vi, this message translates to:
  /// **'Tên gia đình'**
  String get onboardingFamilyName;

  /// ONB — Tạo gia đình
  ///
  /// In vi, this message translates to:
  /// **'Tạo gia đình'**
  String get onboardingCreateFamily;

  /// ONB — Mời {callName} cùng tham gia
  ///
  /// In vi, this message translates to:
  /// **'Mời {callName} cùng tham gia'**
  String onboardingInviteTitle(String callName);

  /// ONB — dòng phụ mời bạn đời (bản cũ); {days} = thời lượng trial policy
  ///
  /// In vi, this message translates to:
  /// **'Baby Family cần cả Papa và Mama. Khi bạn đời tham gia, nhà mình bắt đầu {days} ngày dùng thử miễn phí.'**
  String onboardingInviteSubtitle(int days);

  /// ONB — Mã mời
  ///
  /// In vi, this message translates to:
  /// **'Mã mời'**
  String get onboardingInviteCode;

  /// ONB — Hết hạn sau 7 ngày · dùng 1 lần
  ///
  /// In vi, this message translates to:
  /// **'Hết hạn sau 7 ngày · dùng 1 lần'**
  String get onboardingInviteExpiry;

  /// ONB — Tôi xác nhận lần cuối khi bạn đời tham gia
  ///
  /// In vi, this message translates to:
  /// **'Tôi xác nhận lần cuối khi bạn đời tham gia'**
  String get onboardingInviteApproval;

  /// ONB — Gửi lời mời qua Zalo, Messenger…
  ///
  /// In vi, this message translates to:
  /// **'Gửi lời mời qua Zalo, Messenger…'**
  String get onboardingShareInvite;

  /// ONB — Sao chép link mời
  ///
  /// In vi, this message translates to:
  /// **'Sao chép link mời'**
  String get onboardingCopyInvite;

  /// ONB — Đã gửi lời mời
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi lời mời'**
  String get onboardingInviteSent;

  /// ONB — Đang chờ {callName} tham gia…
  ///
  /// In vi, this message translates to:
  /// **'Đang chờ {callName} tham gia…'**
  String onboardingWaitingTitle(String callName);

  /// ONB — dòng phụ chờ bạn đời (bản cũ); {days} = thời lượng trial policy
  ///
  /// In vi, this message translates to:
  /// **'Khi bạn đời nhận lời mời, nhà mình sẽ được mở khoá và bắt đầu {days} ngày dùng thử miễn phí.'**
  String onboardingWaitingSubtitle(int days);

  /// ONB — Gửi lại lời mời
  ///
  /// In vi, this message translates to:
  /// **'Gửi lại lời mời'**
  String get onboardingResendInvite;

  /// ONB — Hiện mã QR
  ///
  /// In vi, this message translates to:
  /// **'Hiện mã QR'**
  String get onboardingShowQr;

  /// ONB — Đổi cách mời
  ///
  /// In vi, this message translates to:
  /// **'Đổi cách mời'**
  String get onboardingChangeInvite;

  /// ONB — Huỷ gia đình này
  ///
  /// In vi, this message translates to:
  /// **'Huỷ gia đình này'**
  String get onboardingCancelFamily;

  /// ONB — Mô phỏng bạn đời tham gia
  ///
  /// In vi, this message translates to:
  /// **'Mô phỏng bạn đời tham gia'**
  String get onboardingActivateDemo;

  /// ONB — Nhà mình đã đủ Papa & Mama
  ///
  /// In vi, this message translates to:
  /// **'Nhà mình đã đủ Papa & Mama 🎉'**
  String get onboardingActivatedTitle;

  /// ONB — Cùng nhau lưu giữ hành trình của con, chia sẻ việc chăm con và luôn hiểu nhau hơn.
  ///
  /// In vi, this message translates to:
  /// **'Cùng nhau lưu giữ hành trình của con, chia sẻ việc chăm con và luôn hiểu nhau hơn.'**
  String get onboardingActivatedSubtitle;

  /// ONB-ACT — tiêu đề thẻ dùng thử; {days} = thời lượng đã cấp
  ///
  /// In vi, this message translates to:
  /// **'{days} ngày dùng thử miễn phí'**
  String onboardingTrial(int days);

  /// ONB — Thiết lập cho bé
  ///
  /// In vi, this message translates to:
  /// **'Thiết lập cho bé'**
  String get onboardingSetupChild;

  /// ONB — Nhà mình đang ở giai đoạn nào?
  ///
  /// In vi, this message translates to:
  /// **'Nhà mình đang ở giai đoạn nào?'**
  String get onboardingStageTitle;

  /// ONB — Nhà mình có thể thêm bé hoặc thai kỳ khác bất cứ lúc nào.
  ///
  /// In vi, this message translates to:
  /// **'Nhà mình có thể thêm bé hoặc thai kỳ khác bất cứ lúc nào.'**
  String get onboardingStageSubtitle;

  /// ONB — Đang mang thai
  ///
  /// In vi, this message translates to:
  /// **'Đang mang thai'**
  String get onboardingPregnant;

  /// ONB — Lưu hành trình từ siêu âm đến ngày gặp bé
  ///
  /// In vi, this message translates to:
  /// **'Lưu ảnh bụng bầu, siêu âm, thư gửi con và chuẩn bị đón bé'**
  String get onboardingPregnantDescription;

  /// ONB — Bé đã chào đời
  ///
  /// In vi, this message translates to:
  /// **'Bé đã chào đời'**
  String get onboardingBorn;

  /// ONB — Lưu những khoảnh khắc và lần đầu của bé
  ///
  /// In vi, this message translates to:
  /// **'Tạo hồ sơ bé, lưu những lần đầu và cùng chăm con'**
  String get onboardingBornDescription;

  /// ONB — Đã có bé và đang mang thai
  ///
  /// In vi, this message translates to:
  /// **'Đã có bé và đang mang thai'**
  String get onboardingBoth;

  /// ONB — Hồ sơ các bé và thai kỳ cùng trong gia đình
  ///
  /// In vi, this message translates to:
  /// **'Nhiều bé và nhiều thai kỳ cùng sống trong gia đình'**
  String get onboardingBothDescription;

  /// ONB — Chào bé yêu trong bụng mẹ
  ///
  /// In vi, this message translates to:
  /// **'Chào bé yêu trong bụng mẹ'**
  String get onboardingPregnancyTitle;

  /// ONB — Chỉ cần một cái tên ở nhà. Những thông tin khác có thể bổ sung sau.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ cần một cái tên ở nhà. Những thông tin khác có thể bổ sung sau.'**
  String get onboardingPregnancySubtitle;

  /// ONB — Tên ở nhà của bé
  ///
  /// In vi, this message translates to:
  /// **'Tên ở nhà của bé'**
  String get onboardingNickname;

  /// ONB — Ngày dự sinh
  ///
  /// In vi, this message translates to:
  /// **'Ngày dự sinh'**
  String get onboardingDueDate;

  /// ONB — Mình chỉ biết tuần thai
  ///
  /// In vi, this message translates to:
  /// **'Mình chỉ biết tuần thai'**
  String get onboardingKnowWeek;

  /// ONB — Tuần thai
  ///
  /// In vi, this message translates to:
  /// **'Tuần thai'**
  String get onboardingWeek;

  /// ONB — Số bé
  ///
  /// In vi, this message translates to:
  /// **'Số bé'**
  String get onboardingBabyCount;

  /// ONB — Một bé
  ///
  /// In vi, this message translates to:
  /// **'Một bé'**
  String get onboardingSingle;

  /// ONB — Song thai
  ///
  /// In vi, this message translates to:
  /// **'Song thai'**
  String get onboardingTwins;

  /// ONB — Ba bé
  ///
  /// In vi, this message translates to:
  /// **'Ba bé'**
  String get onboardingTriplets;

  /// ONB — Bỏ qua ngày dự sinh
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua ngày dự sinh'**
  String get onboardingSkipDueDate;

  /// ONB — Giới thiệu bé của nhà mình
  ///
  /// In vi, this message translates to:
  /// **'Giới thiệu bé của nhà mình'**
  String get onboardingChildTitle;

  /// ONB — Tên hoặc tên ở nhà và ngày sinh là đủ để bắt đầu.
  ///
  /// In vi, this message translates to:
  /// **'Tên hoặc tên ở nhà và ngày sinh là đủ để bắt đầu.'**
  String get onboardingChildSubtitle;

  /// ONB — Tên hoặc tên ở nhà
  ///
  /// In vi, this message translates to:
  /// **'Tên hoặc tên ở nhà'**
  String get onboardingChildName;

  /// ONB — Ngày sinh
  ///
  /// In vi, this message translates to:
  /// **'Ngày sinh'**
  String get onboardingBirthday;

  /// ONB — Bé trai
  ///
  /// In vi, this message translates to:
  /// **'Bé trai'**
  String get onboardingBoy;

  /// ONB — Bé gái
  ///
  /// In vi, this message translates to:
  /// **'Bé gái'**
  String get onboardingGirl;

  /// ONB — Thêm bé khác
  ///
  /// In vi, this message translates to:
  /// **'Thêm bé khác'**
  String get onboardingAddChild;

  /// ONB — Không gian riêng của nhà mình
  ///
  /// In vi, this message translates to:
  /// **'Không gian riêng của nhà mình'**
  String get onboardingPrivacyTitle;

  /// ONB — Baby Family được xây để bảo vệ những khoảnh khắc quý giá nhất.
  ///
  /// In vi, this message translates to:
  /// **'Baby Family được xây để bảo vệ những khoảnh khắc quý giá nhất.'**
  String get onboardingPrivacySubtitle;

  /// ONB — Chỉ người được mời mới thấy ảnh của con
  ///
  /// In vi, this message translates to:
  /// **'Chỉ người được mời mới thấy ảnh của con'**
  String get onboardingPrivacyInvited;

  /// ONB — Không có trang công khai, không ai tìm thấy gia đình bạn.
  ///
  /// In vi, this message translates to:
  /// **'Không có trang công khai, không ai tìm thấy gia đình bạn.'**
  String get onboardingPrivacyInvitedDescription;

  /// ONB — Papa & Mama là góc riêng
  ///
  /// In vi, this message translates to:
  /// **'Papa & Mama là góc riêng'**
  String get onboardingPrivacyUs;

  /// ONB — Cảm xúc, lời nhờ, nhật ký riêng — ông bà không bao giờ thấy.
  ///
  /// In vi, this message translates to:
  /// **'Cảm xúc, lời nhờ, nhật ký riêng — ông bà không bao giờ thấy.'**
  String get onboardingPrivacyUsDescription;

  /// ONB — Dữ liệu là của bạn
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu là của bạn'**
  String get onboardingPrivacyData;

  /// ONB — Tải về hoặc xoá bất cứ lúc nào trong Cài đặt.
  ///
  /// In vi, this message translates to:
  /// **'Tải về hoặc xoá bất cứ lúc nào trong Cài đặt.'**
  String get onboardingPrivacyDataDescription;

  /// ONB — Mình hiểu rồi
  ///
  /// In vi, this message translates to:
  /// **'Mình hiểu rồi'**
  String get onboardingUnderstood;

  /// ONB — Đừng bỏ lỡ khoảnh khắc nào
  ///
  /// In vi, this message translates to:
  /// **'Đừng bỏ lỡ khoảnh khắc nào'**
  String get onboardingNotificationsTitle;

  /// ONB — Nhận cập nhật khi bạn đời tham gia, ảnh mới của bé và lời nhờ hỗ trợ. Bạn chỉnh từng loại và giờ yên tĩnh trong Cài đặt.
  ///
  /// In vi, this message translates to:
  /// **'Nhận nhiệm vụ Papa/Mama giao, ảnh mới của bé và lời nhờ hỗ trợ. Bạn chỉnh từng loại và giờ yên tĩnh trong Cài đặt.'**
  String get onboardingNotificationsSubtitle;

  /// ONB — Bật thông báo
  ///
  /// In vi, this message translates to:
  /// **'Bật thông báo'**
  String get onboardingEnableNotifications;

  /// INV — Nhập mã mời
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã mời'**
  String get inviteTitle;

  /// INV — Mã gồm 8 ký tự, có trong tin nhắn mời từ Papa hoặc Mama.
  ///
  /// In vi, this message translates to:
  /// **'Mã gồm 8 ký tự, có trong tin nhắn mời từ Papa hoặc Mama.'**
  String get inviteSubtitle;

  /// INV — Xem lời mời
  ///
  /// In vi, this message translates to:
  /// **'Xem lời mời'**
  String get inviteView;

  /// INV — Quét mã QR
  ///
  /// In vi, this message translates to:
  /// **'Quét mã QR'**
  String get inviteScanQr;

  /// INV — Dùng mã mời demo
  ///
  /// In vi, this message translates to:
  /// **'Dùng mã mời demo'**
  String get inviteUseDemo;

  /// INV — Tham gia gia đình
  ///
  /// In vi, this message translates to:
  /// **'Tham gia gia đình'**
  String get inviteJoin;

  /// INV — Từ chối
  ///
  /// In vi, this message translates to:
  /// **'Từ chối'**
  String get inviteDecline;

  /// INV — Vai trò của bạn
  ///
  /// In vi, this message translates to:
  /// **'Vai trò của bạn'**
  String get inviteRole;

  /// INV — Đã nhận lời mời trong bản demo
  ///
  /// In vi, this message translates to:
  /// **'Đã nhận lời mời trong bản demo'**
  String get inviteAccepted;

  /// INV — Đã từ chối lời mời trong bản demo
  ///
  /// In vi, this message translates to:
  /// **'Đã từ chối lời mời trong bản demo'**
  String get inviteDeclined;

  /// INV — Lời mời không còn hiệu lực
  ///
  /// In vi, this message translates to:
  /// **'Lời mời không còn hiệu lực'**
  String get inviteInvalidTitle;

  /// INV — Nhờ người mời gửi lại link mới nhé.
  ///
  /// In vi, this message translates to:
  /// **'Nhờ người mời gửi lại link mới nhé.'**
  String get inviteInvalidDescription;

  /// CIR — Bạn cần được con cháu mời vào gia đình
  ///
  /// In vi, this message translates to:
  /// **'Bà cần được con cháu mời vào gia đình'**
  String get circleWaitingTitle;

  /// CIR — Khi Papa hoặc Mama gửi lời mời, bạn sẽ xem được ảnh và những lần đầu của cháu.
  ///
  /// In vi, this message translates to:
  /// **'Khi Papa hoặc Mama gửi lời mời, bà sẽ xem được ảnh và những lần đầu của cháu.'**
  String get circleWaitingSubtitle;

  /// CIR-WAIT khi người thân đã nhận lời mời, chờ Papa/Mama xác nhận lần cuối (INV-04)
  ///
  /// In vi, this message translates to:
  /// **'Đã nhận lời mời'**
  String get circleAwaitingTitle;

  /// CIR-WAIT mô tả khi chờ xác nhận lần cuối
  ///
  /// In vi, this message translates to:
  /// **'Papa hoặc Mama sẽ xác nhận thêm một lần. Sau đó bà xem được ảnh và những lần đầu của cháu.'**
  String get circleAwaitingSubtitle;

  /// CIR — Nhờ con mời mình
  ///
  /// In vi, this message translates to:
  /// **'Nhờ con mời mình'**
  String get circleAskInvite;

  /// CIR — Con ơi, mình đã cài Baby Family, con mời mình vào xem cháu nhé.
  ///
  /// In vi, this message translates to:
  /// **'Con ơi, mình đã cài Baby Family, con mời mình vào xem cháu nhé.'**
  String get circleAskMessage;

  /// CIR — Tôi là Papa/Mama của bé
  ///
  /// In vi, this message translates to:
  /// **'Tôi là Papa/Mama của bé'**
  String get circleSwitchRole;

  /// CIR — Đăng xuất
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get circleSignOut;

  /// AUTH — Các thao tác đăng nhập và cấp quyền được mô phỏng với dữ liệu mẫu.
  ///
  /// In vi, this message translates to:
  /// **'Các thao tác đăng nhập và cấp quyền được mô phỏng với dữ liệu mẫu.'**
  String get authDemoDescription;

  /// AUTH — Tiếp tục với dữ liệu mẫu
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục với dữ liệu mẫu'**
  String get authDemoAction;

  /// ONB-09 — Ký ức đầu tiên của nhà mình
  ///
  /// In vi, this message translates to:
  /// **'Ký ức đầu tiên của nhà mình'**
  String get onboardingFirstMemoryTitle;

  /// ONB-09 — Lưu khoảnh khắc đầu tiên của bé trong Baby Family.
  ///
  /// In vi, this message translates to:
  /// **'Lưu khoảnh khắc đầu tiên của bé trong Baby Family.'**
  String get onboardingFirstMemorySubtitle;

  /// ONB-09 — Chọn ảnh
  ///
  /// In vi, this message translates to:
  /// **'Chọn ảnh'**
  String get onboardingFirstMemoryChoosePhoto;

  /// FAM/SET/SUB/NOTI/CIR/MEM — Kỷ vật
  ///
  /// In vi, this message translates to:
  /// **'Kỷ vật'**
  String get memoriesKeepsakes;

  /// FAM/SET/SUB/NOTI/CIR/MEM — Ảnh đẹp nhất nhà mình
  ///
  /// In vi, this message translates to:
  /// **'Ảnh đẹp nhất nhà mình'**
  String get memoriesBest;

  /// FAM/SET/SUB/NOTI/CIR/MEM — Đoạn ghi âm mẫu đã được lưu
  ///
  /// In vi, this message translates to:
  /// **'Đoạn ghi âm mẫu đã được lưu'**
  String get memoriesRecordedVoice;

  /// FAM/SET/SUB/NOTI/CIR/MEM — Mối quan hệ
  ///
  /// In vi, this message translates to:
  /// **'Người này là…'**
  String get familyRelationship;

  /// FAM/SET/SUB/NOTI/CIR/MEM — Tên gọi của người thân
  ///
  /// In vi, this message translates to:
  /// **'Cháu gọi là'**
  String get familyCallName;

  /// FAM/SET/SUB/NOTI/CIR/MEM — Xem ảnh và ký ức
  ///
  /// In vi, this message translates to:
  /// **'Xem ảnh & ký ức'**
  String get familyPhotosPermission;

  /// FAM/SET/SUB/NOTI/CIR/MEM — Xem những lần đầu
  ///
  /// In vi, this message translates to:
  /// **'Thả tim & bình luận'**
  String get familyFirstsPermission;

  /// FAM/SET/SUB/NOTI/CIR/MEM — Cho phép tải ảnh
  ///
  /// In vi, this message translates to:
  /// **'Đóng góp ảnh'**
  String get familyDownloadPermission;

  /// FAM/SET/SUB/NOTI/CIR/MEM — Xem trước quyền chia sẻ
  ///
  /// In vi, this message translates to:
  /// **'Xem trước quyền chia sẻ'**
  String get familyInvitePreview;

  /// FAM/SET/SUB/NOTI/CIR/MEM — Papa & Mama, nhiệm vụ và nội dung riêng luôn được giữ kín.
  ///
  /// In vi, this message translates to:
  /// **'Papa & Mama, nhiệm vụ và nội dung riêng luôn được giữ kín.'**
  String get familyHidden;

  /// FAM/SET/SUB/NOTI/CIR/MEM — Tạo lời mời mẫu
  ///
  /// In vi, this message translates to:
  /// **'Tạo lời mời'**
  String get familyCreateInvite;

  /// FAM/SET/SUB/NOTI/CIR/MEM — Đã tạo lời mời mẫu. Chưa gửi tin nhắn cho người thân.
  ///
  /// In vi, this message translates to:
  /// **'Đã tạo lời mời mẫu. Chưa gửi tin nhắn cho người thân.'**
  String get familyInviteCreated;

  /// FAM/SET/SUB/NOTI/CIR/MEM — Đây là dữ liệu mẫu. Chọn gói, khôi phục và xuất dữ liệu chỉ được mô phỏng.
  ///
  /// In vi, this message translates to:
  /// **'Đây là dữ liệu mẫu. Chọn gói, khôi phục và xuất dữ liệu chỉ được mô phỏng.'**
  String get billingMockNotice;

  /// FAM/SET/SUB/NOTI/CIR/MEM — Đã chọn gói trong bản dùng thử. Không phát sinh giao dịch.
  ///
  /// In vi, this message translates to:
  /// **'Đã chọn gói trong bản dùng thử. Không phát sinh giao dịch.'**
  String get billingSelected;

  /// FAM/SET/SUB/NOTI/CIR/MEM — Đã mô phỏng khôi phục giao dịch.
  ///
  /// In vi, this message translates to:
  /// **'Đã mô phỏng khôi phục giao dịch.'**
  String get billingRestored;

  /// FAM/SET/SUB/NOTI/CIR/MEM — Đã mô phỏng yêu cầu xuất dữ liệu. Ký ức của nhà mình vẫn an toàn.
  ///
  /// In vi, this message translates to:
  /// **'Đã mô phỏng yêu cầu xuất dữ liệu. Ký ức của nhà mình vẫn an toàn.'**
  String get billingExportReady;

  /// FAM/SET/SUB/NOTI/CIR/MEM — Đã đọc hết
  ///
  /// In vi, this message translates to:
  /// **'Đã đọc hết'**
  String get notificationsReadAll;

  /// NOTI-01 — hộp thông báo rỗng
  ///
  /// In vi, this message translates to:
  /// **'Chưa có thông báo nào'**
  String get notificationsEmpty;

  /// NOTI-01 — mô tả khi hộp thông báo rỗng
  ///
  /// In vi, this message translates to:
  /// **'Ký ức mới, lời nhờ và lời nhắc sẽ hiện ở đây.'**
  String get notificationsEmptyDescription;

  /// FAM/SET/SUB/NOTI/CIR/MEM — Cháu yêu của cả nhà
  ///
  /// In vi, this message translates to:
  /// **'Cháu yêu của cả nhà'**
  String get circleGreeting;

  /// FAM/SET/SUB/NOTI/CIR/MEM — Gửi lời chúc
  ///
  /// In vi, this message translates to:
  /// **'Gửi lời chúc'**
  String get circleSendWish;

  /// SET-01 — giải thích các mục đang được mô phỏng trong bản demo
  ///
  /// In vi, this message translates to:
  /// **'Các tuỳ chọn trong mục này đang được mô phỏng với dữ liệu mẫu.'**
  String get settingsDemoSection;

  /// Papa & Mama — Một chút yên tĩnh
  ///
  /// In vi, this message translates to:
  /// **'Một chút yên tĩnh'**
  String get usNeedSpace;

  /// Papa & Mama — Muốn được lắng nghe
  ///
  /// In vi, this message translates to:
  /// **'Muốn được lắng nghe'**
  String get usNeedTalk;

  /// Papa & Mama — Mình đang giận
  ///
  /// In vi, this message translates to:
  /// **'Mình đang giận'**
  String get usBridgeAngry;

  /// Papa & Mama — Mình chưa biết nói sao
  ///
  /// In vi, this message translates to:
  /// **'Mình chưa biết nói sao'**
  String get usBridgeStuck;

  /// Papa & Mama — Hãy nói điều bạn cảm thấy và điều bạn cần. Hai mình có thể tạm nghỉ rồi quay lại khi sẵn sàng.
  ///
  /// In vi, this message translates to:
  /// **'Hãy nói điều bạn cảm thấy và điều bạn cần. Hai mình có thể tạm nghỉ rồi quay lại khi sẵn sàng.'**
  String get usBridgeHint;

  /// Papa & Mama — Hôm nay bạn muốn cảm ơn điều gì?
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay bạn muốn cảm ơn điều gì?'**
  String get usThanksHint;

  /// Papa & Mama — Một nơi để ghi lại điều bạn đang nghĩ.
  ///
  /// In vi, this message translates to:
  /// **'Một nơi để ghi lại điều bạn đang nghĩ.'**
  String get usJournalHint;

  /// US — Giúp đỡ thực tế
  ///
  /// In vi, this message translates to:
  /// **'Giúp đỡ thực tế'**
  String get usNeedHelp;

  /// US — Mình đang cảm thấy…
  ///
  /// In vi, this message translates to:
  /// **'Mình đang cảm thấy…'**
  String get usBridgeEmotion;

  /// US — Tức giận
  ///
  /// In vi, this message translates to:
  /// **'Tức giận'**
  String get usBridgeAnger;

  /// US — Chỉ bạn thấy những gì bạn viết ở đây
  ///
  /// In vi, this message translates to:
  /// **'Chỉ bạn thấy những gì bạn viết ở đây'**
  String get usBridgePrivate;

  /// US — Viết nháp riêng, nếu bạn muốn
  ///
  /// In vi, this message translates to:
  /// **'Viết nháp riêng, nếu bạn muốn'**
  String get usBridgeDraft;

  /// US — Giữ riêng
  ///
  /// In vi, this message translates to:
  /// **'Giữ riêng'**
  String get usBridgeKeepPrivate;

  /// US — Dừng lại
  ///
  /// In vi, this message translates to:
  /// **'Dừng lại'**
  String get usBridgePause;

  /// US — Bức tường cảm ơn
  ///
  /// In vi, this message translates to:
  /// **'Bức tường cảm ơn'**
  String get usThanksWall;

  /// Nhãn settingsDisplayTitle theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Hiển thị & Ngôn ngữ'**
  String get settingsDisplayTitle;

  /// Nhãn settingsOther theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get settingsOther;

  /// Nhãn settingsReduceMotion theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Giảm hiệu ứng chuyển động'**
  String get settingsReduceMotion;

  /// Nhãn settingsReduceMotionHint theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Ít animation hơn'**
  String get settingsReduceMotionHint;

  /// Nhãn settingsLunarHint theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Bên cạnh ngày dương'**
  String get settingsLunarHint;

  /// Nhãn settingsDeleteAccount theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Xoá tài khoản'**
  String get settingsDeleteAccount;

  /// Nhãn familyManage theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Quản lý gia đình'**
  String get familyManage;

  /// Nhãn familyYou theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'{callName} (bạn)'**
  String familyYou(String callName);

  /// Nhãn familyStorageLabel theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Dung lượng'**
  String get familyStorageLabel;

  /// Nhãn familyViewPlans theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Xem gói House / Family'**
  String get familyViewPlans;

  /// Nhãn familyAddChild theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Thêm con / thai kỳ'**
  String get familyAddChild;

  /// Nhãn familyLockedTitle theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Mời ông bà ở gói Family'**
  String get familyLockedTitle;

  /// Nhãn familyLockedDescription theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Trong thời gian dùng thử chỉ có Papa & Mama. Nâng cấp Family để ông bà, người thân cùng theo dõi cháu.'**
  String get familyLockedDescription;

  /// Nhãn familyFollowing theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Được theo dõi'**
  String get familyFollowing;

  /// Nhãn relationPaternalGrandfather theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Ông nội'**
  String get relationPaternalGrandfather;

  /// Nhãn relationPaternalGrandmother theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Bà nội'**
  String get relationPaternalGrandmother;

  /// Nhãn relationMaternalGrandfather theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Ông ngoại'**
  String get relationMaternalGrandfather;

  /// Nhãn relationMaternalGrandmother theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Bà ngoại'**
  String get relationMaternalGrandmother;

  /// Nhãn relationAunt theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Cô / Dì'**
  String get relationAunt;

  /// Nhãn relationUncle theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Chú / Bác'**
  String get relationUncle;

  /// Nhãn billingHouseChildren theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Papa & Mama, không giới hạn số con'**
  String get billingHouseChildren;

  /// Nhãn billingHouseCare theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Nhiệm vụ, nhật ký, khu vực Papa & Mama'**
  String get billingHouseCare;

  /// Nhãn billingHouseStorage theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Lưu trữ 50 GB'**
  String get billingHouseStorage;

  /// Nhãn billingInviteRelatives theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Mời ông bà, người thân'**
  String get billingInviteRelatives;

  /// Nhãn billingFamilyIncludes theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Mọi tính năng của House'**
  String get billingFamilyIncludes;

  /// Nhãn billingFamilyRelatives theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Mời tối đa 12 ông bà, người thân'**
  String get billingFamilyRelatives;

  /// Nhãn billingFamilyStorage theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Lưu trữ 200 GB, ảnh chất lượng gốc'**
  String get billingFamilyStorage;

  /// Nhãn billingFamilyVideos theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Video đến 10 phút, bản tin cho ông bà'**
  String get billingFamilyVideos;

  /// Nhãn billingLegal theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Gói áp dụng cho cả gia đình, Papa hoặc Mama thanh toán đều được. Tự động gia hạn hằng năm, huỷ bất kỳ lúc nào trong cài đặt App Store / Google Play. Điều khoản · Quyền riêng tư'**
  String get billingLegal;

  /// Nhãn billingChoosePlans theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Chọn gói House / Family'**
  String get billingChoosePlans;

  /// Nhãn billingRetentionHint theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi sẽ báo trước nhiều lần trước khi xoá.'**
  String get billingRetentionHint;

  /// Nhãn circleTitle theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Cháu yêu của bà'**
  String get circleTitle;

  /// Nhãn circleNewPhotos theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Ảnh mới tuần này'**
  String get circleNewPhotos;

  /// Nhãn circleVoiceTip theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Bấm giữ “Gửi lời chúc” để ghi âm giọng nói cho cháu'**
  String get circleVoiceTip;

  /// Nhãn notificationsToday theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get notificationsToday;

  /// Nhãn notificationsYesterday theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Hôm qua'**
  String get notificationsYesterday;

  /// Nhãn stateEmptyMemoryTitle theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Chưa có ký ức nào của {name}'**
  String stateEmptyMemoryTitle(String name);

  /// Nhãn stateEmptyMemoryDescription theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Lưu khoảnh khắc đầu tiên nhé — một tấm ảnh, một dòng nhật ký hay tiếng cười của con.'**
  String get stateEmptyMemoryDescription;

  /// Nhãn stateEmptyCareDescription theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Chọn vài việc nhỏ để Papa & Mama cùng chia nhau nhé.'**
  String get stateEmptyCareDescription;

  /// Nhãn stateErrorTitle theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Chưa tải được ký ức'**
  String get stateErrorTitle;

  /// Nhãn stateErrorDescription theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Có trục trặc nhỏ từ phía chúng tôi. Ký ức của nhà mình vẫn an toàn — thử lại sau giây lát nhé.'**
  String get stateErrorDescription;

  /// Nhãn stateErrorCode theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Mã lỗi: MEM-500 · Báo cho hỗ trợ'**
  String get stateErrorCode;

  /// Nhãn splashTagline theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Cùng con lớn lên — Giữ mãi yêu thương'**
  String get splashTagline;

  /// Nhãn splashPreparing theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Đang chuẩn bị không gian của nhà mình…'**
  String get splashPreparing;

  /// Nhãn onboardingChildAvatarOptional theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Thêm ảnh đại diện (tuỳ chọn)'**
  String get onboardingChildAvatarOptional;

  /// Nhãn onboardingComplete theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Hoàn tất'**
  String get onboardingComplete;

  /// Nhãn onboardingSkipGender theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua'**
  String get onboardingSkipGender;

  /// Nhãn inviteJoinAsParent theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Tham gia làm {callName}'**
  String inviteJoinAsParent(String callName);

  /// Nhãn memoriesMilestones theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Cột mốc'**
  String get memoriesMilestones;

  /// Nhãn memoriesAlbum theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Album'**
  String get memoriesAlbum;

  /// Nhãn memoriesChooseAlbum theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Chọn album'**
  String get memoriesChooseAlbum;

  /// Nhãn memoriesCaptionSuggestion theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý chú thích'**
  String get memoriesCaptionSuggestion;

  /// Nhãn memoriesCover theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Bìa'**
  String get memoriesCover;

  /// Nhãn memoriesVideo theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Video [1.1]'**
  String get memoriesVideo;

  /// Nhãn memoriesNextMonth theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Tháng {month} · ngày mai'**
  String memoriesNextMonth(int month);

  /// Nhãn memoriesPerspectivePrompt theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Bạn nhớ gì về khoảnh khắc này?'**
  String get memoriesPerspectivePrompt;

  /// Nhãn pregnancyHeight theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Chiều dài'**
  String get pregnancyHeight;

  /// Nhãn pregnancyBabyBoy theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Bé trai'**
  String get pregnancyBabyBoy;

  /// Nhãn pregnancyBabyGirl theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Bé gái'**
  String get pregnancyBabyGirl;

  /// Nhãn pregnancyLater theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Để sau'**
  String get pregnancyLater;

  /// Nhãn pregnancyBirthBag theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'ĐỒ ĐI SINH'**
  String get pregnancyBirthBag;

  /// Nhãn pregnancyDocuments theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'GIẤY TỜ'**
  String get pregnancyDocuments;

  /// Nhãn pregnancyNursery theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'GÓC CỦA BÉ'**
  String get pregnancyNursery;

  /// Nhãn pregnancySupport theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Nguồn hỗ trợ tinh thần (tuỳ chọn)'**
  String get pregnancySupport;

  /// Tên bé và tuổi trong chip
  ///
  /// In vi, this message translates to:
  /// **'{name} · {age}'**
  String commonChildNameAge(String name, String age);

  /// No description provided for @homeEvening.
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi tối,'**
  String get homeEvening;

  /// No description provided for @homeTomorrow.
  ///
  /// In vi, this message translates to:
  /// **'NGÀY MAI'**
  String get homeTomorrow;

  /// No description provided for @homeRecord.
  ///
  /// In vi, this message translates to:
  /// **'Ghi lại'**
  String get homeRecord;

  /// No description provided for @homeParentsPrivacy.
  ///
  /// In vi, this message translates to:
  /// **'Papa & Mama · chỉ hai bạn'**
  String get homeParentsPrivacy;

  /// No description provided for @homeHug.
  ///
  /// In vi, this message translates to:
  /// **'Ôm một cái'**
  String get homeHug;

  /// No description provided for @homeMomentCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} khoảnh khắc'**
  String homeMomentCount(int count);

  /// No description provided for @homePhotoCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} ảnh'**
  String homePhotoCount(int count);

  /// No description provided for @homeYourHearts.
  ///
  /// In vi, this message translates to:
  /// **'💗 {count} của tôi'**
  String homeYourHearts(int count);

  /// No description provided for @homeMoreMissions.
  ///
  /// In vi, this message translates to:
  /// **'+ {count} việc nữa của tôi · 💗 chỉ bạn thấy'**
  String homeMoreMissions(int count);

  /// No description provided for @careTreeBloom.
  ///
  /// In vi, this message translates to:
  /// **'Xong hết để cây nở hoa 🌸'**
  String get careTreeBloom;

  /// No description provided for @careMyHeartsToday.
  ///
  /// In vi, this message translates to:
  /// **'Hearts của tôi hôm nay: {count}'**
  String careMyHeartsToday(int count);

  /// No description provided for @carePrivateHearts.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ bạn thấy'**
  String get carePrivateHearts;

  /// No description provided for @homeOtherPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý khác'**
  String get homeOtherPrompt;

  /// No description provided for @commonWeek.
  ///
  /// In vi, this message translates to:
  /// **'Tuần {week}'**
  String commonWeek(int week);

  /// No description provided for @homeChildToday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay của {name}'**
  String homeChildToday(String name);

  /// No description provided for @homeFirstsRecent.
  ///
  /// In vi, this message translates to:
  /// **'Những lần đầu gần đây'**
  String get homeFirstsRecent;

  /// No description provided for @homeChildMissions.
  ///
  /// In vi, this message translates to:
  /// **'Việc cho {name} hôm nay'**
  String homeChildMissions(String name);

  /// No description provided for @homeCompare.
  ///
  /// In vi, this message translates to:
  /// **'So sánh'**
  String get homeCompare;

  /// No description provided for @careSwapHeading.
  ///
  /// In vi, this message translates to:
  /// **'Đổi “{title}”'**
  String careSwapHeading(String title);

  /// No description provided for @careSwapHint.
  ///
  /// In vi, this message translates to:
  /// **'Các lựa chọn có số Hearts tương đương để bảng việc của hai người luôn cân bằng.'**
  String get careSwapHint;

  /// No description provided for @careSwapRemaining.
  ///
  /// In vi, this message translates to:
  /// **'Còn {count} lần đổi hôm nay'**
  String careSwapRemaining(int count);

  /// No description provided for @careSwapConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Đổi sang việc này'**
  String get careSwapConfirm;

  /// No description provided for @careCompleteHearts.
  ///
  /// In vi, this message translates to:
  /// **'Tuyệt vời! +{count} 💗 cho cây'**
  String careCompleteHearts(int count);

  /// Offline-first: hoàn thành nhiệm vụ khi mất mạng, Hearts cộng sau
  ///
  /// In vi, this message translates to:
  /// **'Đã xong! 💗 sẽ được cộng khi có mạng'**
  String get careCompletePendingSync;

  /// No description provided for @careCompleteHint.
  ///
  /// In vi, this message translates to:
  /// **'{title} — cây thêm một chiếc lá. (+2 💗 nếu lưu ảnh)'**
  String careCompleteHint(String title);

  /// No description provided for @careSaveMemoryQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Lưu lại khoảnh khắc này?'**
  String get careSaveMemoryQuestion;

  /// No description provided for @careMemoryCaption.
  ///
  /// In vi, this message translates to:
  /// **'Một dòng ngắn về khoảnh khắc này…'**
  String get careMemoryCaption;

  /// Nhãn careSaveMission theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Lưu nhiệm vụ'**
  String get careSaveMission;

  /// Nhãn pregnancyNamesFor theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Đặt tên cho {child}'**
  String pregnancyNamesFor(String child);

  /// Nhãn pregnancyChooseNameFor theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Chọn “{name}” làm tên của {child}'**
  String pregnancyChooseNameFor(String name, String child);

  /// Nhãn memoriesSavePerspective theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Lưu góc nhìn · Cả hai cùng kể'**
  String get memoriesSavePerspective;

  /// Nhãn circleViewComment theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Xem & bình luận'**
  String get circleViewComment;

  /// No description provided for @homeStoryView.
  ///
  /// In vi, this message translates to:
  /// **'Xem dạng story'**
  String get homeStoryView;

  /// No description provided for @homeCurrentChapter.
  ///
  /// In vi, this message translates to:
  /// **'CHƯƠNG HIỆN TẠI'**
  String get homeCurrentChapter;

  /// No description provided for @homeNextFirst.
  ///
  /// In vi, this message translates to:
  /// **'Lần đầu tiếp theo?'**
  String get homeNextFirst;

  /// No description provided for @homeMonthShort.
  ///
  /// In vi, this message translates to:
  /// **'{month} th'**
  String homeMonthShort(int month);

  /// No description provided for @homeMomentLabel.
  ///
  /// In vi, this message translates to:
  /// **'khoảnh khắc'**
  String get homeMomentLabel;

  /// No description provided for @homeQuoteLabel.
  ///
  /// In vi, this message translates to:
  /// **'câu nói mới'**
  String get homeQuoteLabel;

  /// No description provided for @commonFirsts.
  ///
  /// In vi, this message translates to:
  /// **'lần đầu'**
  String get commonFirsts;

  /// Nút thả tim CIR-01
  ///
  /// In vi, this message translates to:
  /// **'Thả tim'**
  String get circleLike;

  /// Tiến độ ảnh tháng Home
  ///
  /// In vi, this message translates to:
  /// **'{done}/{total} ảnh'**
  String homeMonthlyProgress(int done, int total);

  /// CTA thêm ký ức trong trạng thái rỗng
  ///
  /// In vi, this message translates to:
  /// **'Thêm ký ức'**
  String get stateAddMemory;

  /// No description provided for @careCamera.
  ///
  /// In vi, this message translates to:
  /// **'Chụp ảnh'**
  String get careCamera;

  /// No description provided for @careGallery.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ảnh'**
  String get careGallery;

  /// No description provided for @carePhotoSelected.
  ///
  /// In vi, this message translates to:
  /// **'Đã chọn ảnh'**
  String get carePhotoSelected;

  /// Nhãn commonCamera theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Camera'**
  String get commonCamera;

  /// Nhãn commonGallery theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Thư viện'**
  String get commonGallery;

  /// Nhãn careForWho theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Cho ai?'**
  String get careForWho;

  /// Nhãn careOneChild theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Một bé'**
  String get careOneChild;

  /// Nhãn careManyChildren theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Nhiều bé'**
  String get careManyChildren;

  /// Nhãn careBothParents theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Hai ta'**
  String get careBothParents;

  /// Nhãn careWhenQuestion theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Khi nào?'**
  String get careWhenQuestion;

  /// Nhãn careWhoQuestion theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Ai làm?'**
  String get careWhoQuestion;

  /// Nhãn careMemoryPrompt theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý lưu ảnh khi hoàn thành'**
  String get careMemoryPrompt;

  /// Nhãn careRemindBefore theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Nhắc trước 15 phút'**
  String get careRemindBefore;

  /// Nhãn careAskPartnerPrompt theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Muốn nhờ {callName} một việc? Gửi lời nhờ →'**
  String careAskPartnerPrompt(String callName);

  /// Nhãn careTreeName theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Cây xanh'**
  String get careTreeName;

  /// Nhãn careTreeGrows theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Lớn lên từ Hearts của Papa & Mama'**
  String get careTreeGrows;

  /// Nhãn careTreeNearBloom theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Sắp tới Cây trổ hoa 🌸'**
  String get careTreeNearBloom;

  /// Nhãn careTreeReward theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Phần thưởng: theme “Hoa anh đào” cho album'**
  String get careTreeReward;

  /// Nhãn careTreeMoments theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Khoảnh khắc chăm con'**
  String get careTreeMoments;

  /// Nhãn careTreeTogether theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Lần cùng nhau'**
  String get careTreeTogether;

  /// Nhãn careTreeBloomDays theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Ngày nở hoa'**
  String get careTreeBloomDays;

  /// Nhãn careTreeYourContribution theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã góp'**
  String get careTreeYourContribution;

  /// Nhãn careTreeToday theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get careTreeToday;

  /// Nhãn careTreeWeek theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Tuần này'**
  String get careTreeWeek;

  /// Nhãn careTreeTotal theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Tổng'**
  String get careTreeTotal;

  /// Nhãn memoriesSelectedPhotos theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Đã chọn {count} ảnh'**
  String memoriesSelectedPhotos(int count);

  /// Nhãn usOnlyTwo theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Chỉ hai bạn nhìn thấy'**
  String get usOnlyTwo;

  /// Nhãn usMe theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'{callName} (bạn)'**
  String usMe(String callName);

  /// Nhãn usEnergyValue theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Năng lượng {value}/5'**
  String usEnergyValue(int value);

  /// Nhãn usHugShort theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Ôm'**
  String get usHugShort;

  /// Nhãn usDailyQuestionShort theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'CÂU HỎI HÔM NAY'**
  String get usDailyQuestionShort;

  /// Nhãn usBridgeShort theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Cầu nối'**
  String get usBridgeShort;

  /// Nhãn usWeekShort theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Tuần của hai ta'**
  String get usWeekShort;

  /// Nhãn usCheckinTitle theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay bạn thế nào?'**
  String get usCheckinTitle;

  /// Nhãn usEnergyShort theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Năng lượng'**
  String get usEnergyShort;

  /// Nhãn usNeedShort theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Mình cần…'**
  String get usNeedShort;

  /// Nhãn usNeedRest theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ ngơi'**
  String get usNeedRest;

  /// Nhãn usNeedChildcare theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Giúp trông con'**
  String get usNeedChildcare;

  /// Nhãn usNeedQuiet theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Yên tĩnh'**
  String get usNeedQuiet;

  /// Nhãn usNeedHug theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Một cái ôm'**
  String get usNeedHug;

  /// Nhãn usNeedConversation theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Nói chuyện'**
  String get usNeedConversation;

  /// Nhãn usNeedEncouragement theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Động viên'**
  String get usNeedEncouragement;

  /// Nhãn usOnlyMe theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Chỉ mình tôi'**
  String get usOnlyMe;

  /// Nhãn usSendTo theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Gửi cho {callName}'**
  String usSendTo(String callName);

  /// Nhãn usRequestTo theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Nhờ {callName}'**
  String usRequestTo(String callName);

  /// Nhãn usRequestGentle theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Lời nhờ không phải nhiệm vụ — {callName} luôn có thể nói “Hôm nay không được”.'**
  String usRequestGentle(String callName);

  /// Nhãn usRequestOneThing theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'NHỜ MỘT VIỆC'**
  String get usRequestOneThing;

  /// Nhãn usRequestRest theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Cần nghỉ'**
  String get usRequestRest;

  /// Nhãn usRequestWatchChild theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Trông con'**
  String get usRequestWatchChild;

  /// Nhãn usRequestRestHint theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Trông con giúp'**
  String get usRequestRestHint;

  /// Nhãn usRequestWatchHint theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Một lúc'**
  String get usRequestWatchHint;

  /// Nhãn usRequestLibrary theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Thư viện'**
  String get usRequestLibrary;

  /// Nhãn usRequestLibraryHint theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Chọn việc'**
  String get usRequestLibraryHint;

  /// Nhãn usRequestCustom theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Tự gõ'**
  String get usRequestCustom;

  /// Nhãn usRequestCustomHint theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Việc khác'**
  String get usRequestCustomHint;

  /// Nhãn usRequestDuration theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Bao lâu?'**
  String get usRequestDuration;

  /// Nhãn usRequestWhen theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Khi nào?'**
  String get usRequestWhen;

  /// Nhãn usRequestWhichChild theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Trông bé nào?'**
  String get usRequestWhichChild;

  /// Nhãn usRequestMinutes theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'{minutes} phút'**
  String usRequestMinutes(int minutes);

  /// Nhãn usRequestNow theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Bây giờ'**
  String get usRequestNow;

  /// Nhãn usRequestTonight theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Tối nay'**
  String get usRequestTonight;

  /// Nhãn usRequestChooseTime theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Chọn giờ'**
  String get usRequestChooseTime;

  /// Nhãn usRequestOtherChild theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Cả hai bé'**
  String get usRequestOtherChild;

  /// Nhãn usRequestNeeds theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'HOẶC MÌNH ĐANG CẦN…  (không tính Hearts)'**
  String get usRequestNeeds;

  /// Nhãn usRequestSendCount theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Gửi cho {callName} · đang mở {count}/5'**
  String usRequestSendCount(String callName, int count);

  /// Nhãn usRequestFrom theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Lời nhờ từ {callName}'**
  String usRequestFrom(String callName);

  /// Nhãn usRequestBy theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'{callName} nhờ bạn'**
  String usRequestBy(String callName);

  /// Nhãn usRequestSoon theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Sớm nhé'**
  String get usRequestSoon;

  /// Nhãn usRequestAcceptedTitle theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã nhận lời nhờ'**
  String get usRequestAcceptedTitle;

  /// Nhãn usRequestReasonHint theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Nếu hôm nay không được, chọn lý do (tuỳ chọn)'**
  String get usRequestReasonHint;

  /// Nhãn usRequestReasonMeeting theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Anh đang họp'**
  String get usRequestReasonMeeting;

  /// Nhãn usRequestReasonLate theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Về muộn'**
  String get usRequestReasonLate;

  /// Nhãn usRequestAccept theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Nhận — để anh lo'**
  String get usRequestAccept;

  /// Nhãn usRequestDecline theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay không được'**
  String get usRequestDecline;

  /// Nhãn usRequestDeclineNote theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Từ chối không bị trừ điểm. {callName} sẽ nhận một thông báo nhẹ nhàng.'**
  String usRequestDeclineNote(String callName);

  /// Nhãn usRequestSent theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'{callName} đã gửi'**
  String usRequestSent(String callName);

  /// Nhãn usRequestViewed theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã xem'**
  String get usRequestViewed;

  /// Nhãn usRequestAcceptedShort theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã nhận'**
  String get usRequestAcceptedShort;

  /// Nhãn usRequestFinished theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Đã xong'**
  String get usRequestFinished;

  /// Nhãn usRequestFinish theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Đã xong ✓'**
  String get usRequestFinish;

  /// No description provided for @commonCreateNew.
  ///
  /// In vi, this message translates to:
  /// **'Tạo mới'**
  String get commonCreateNew;

  /// No description provided for @switcherViewBy.
  ///
  /// In vi, this message translates to:
  /// **'Xem theo'**
  String get switcherViewBy;

  /// No description provided for @switcherPregnancy.
  ///
  /// In vi, this message translates to:
  /// **'Thai #{number} · {name}'**
  String switcherPregnancy(int number, String name);

  /// No description provided for @switcherAllDescription.
  ///
  /// In vi, this message translates to:
  /// **'Mọi bé và khoảnh khắc chung'**
  String get switcherAllDescription;

  /// No description provided for @familyManageChildren.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý các con'**
  String get familyManageChildren;

  /// No description provided for @careWeekday.
  ///
  /// In vi, this message translates to:
  /// **'{day, select, mon{T2} tue{T3} wed{T4} thu{T5} fri{T6} sat{T7} other{CN}}'**
  String careWeekday(String day);

  /// Nhãn notificationsFamily theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Gia đình'**
  String get notificationsFamily;

  /// Nhãn memoriesSaveQuote theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Lưu câu nói'**
  String get memoriesSaveQuote;

  /// Nhãn pregnancyFirstPhoto theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Ảnh đầu tiên của bé'**
  String get pregnancyFirstPhoto;

  /// Nhãn pregnancyFirstPhotoHint theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Tuỳ chọn · sẽ là ký ức “Chào đời”'**
  String get pregnancyFirstPhotoHint;

  /// Nhãn pregnancyCompleteAnnounce theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Hoàn tất & báo tin'**
  String get pregnancyCompleteAnnounce;

  /// Nhãn pregnancyWelcomeName theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng {name}!'**
  String pregnancyWelcomeName(String name);

  /// Nhãn pregnancyShort theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Thai kỳ'**
  String get pregnancyShort;

  /// Nhãn memoriesPerspectiveshort theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Góc nhìn'**
  String get memoriesPerspectiveshort;

  /// Nhãn pregnancyBumpWeeks theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Bụng bầu theo tuần'**
  String get pregnancyBumpWeeks;

  /// Nhãn pregnancyFirstsFor theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Lần đầu của {child}'**
  String pregnancyFirstsFor(String child);

  /// Nhãn pregnancyBabyLetter theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Thư cho bé'**
  String get pregnancyBabyLetter;

  /// Nhãn pregnancyBumpPhoto theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Ảnh bụng'**
  String get pregnancyBumpPhoto;

  /// Nhãn usRequestHearts theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Xong việc bạn nhận +{count} 💗 (chỉ bạn thấy)'**
  String usRequestHearts(int count);

  /// Nhãn usRequestReminder theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Nhắc mình lúc {time}'**
  String usRequestReminder(String time);

  /// Nhãn lời nhờ đã được nhận theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Đã nhận'**
  String get usRequestAcceptedBadge;

  /// Nhãn pregnancyPrepareBaby theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Chuẩn bị đón bé'**
  String get pregnancyPrepareBaby;

  /// Nhãn commonAll theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get commonAll;

  /// Nhãn pregnancyCaptureWeek theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Chụp ảnh bụng tuần {week}'**
  String pregnancyCaptureWeek(int week);

  /// Nhãn memoriesMarkMilestone theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Đánh dấu cột mốc'**
  String get memoriesMarkMilestone;

  /// Nhãn careMine theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Tôi'**
  String get careMine;

  /// Nhãn careTogether theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Cùng nhau'**
  String get careTogether;

  /// Nhãn careTodayShort theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get careTodayShort;

  /// Nhãn carePrivateContribution theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Chỉ bạn thấy'**
  String get carePrivateContribution;

  /// Nhãn usRequestRestTitle theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Cần nghỉ {minutes} phút — trông {child} giúp'**
  String usRequestRestTitle(int minutes, String child);

  /// Nhãn usRequestWatchTitle theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Trông {child} giúp {minutes} phút'**
  String usRequestWatchTitle(int minutes, String child);

  /// Nhãn usRequestAllChildren theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Tất cả {count} bé'**
  String usRequestAllChildren(int count);

  /// Nhãn usRequestMessagePreview theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'“Em cần nghỉ khoảng {minutes} phút. Anh trông {child} giúp em nhé? 💛”'**
  String usRequestMessagePreview(int minutes, String child);

  /// Nhãn quickCheckin theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Check-in'**
  String get quickCheckin;

  /// Nhãn quickThanks theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Cảm ơn'**
  String get quickThanks;

  /// Nhãn careFinish theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Xong'**
  String get careFinish;

  /// Nhãn carePartnerTab theo thiết kế Pencil
  ///
  /// In vi, this message translates to:
  /// **'Của {callName}'**
  String carePartnerTab(String callName);

  /// Liên kết hỗ trợ trong màn hết hạn dùng thử
  ///
  /// In vi, this message translates to:
  /// **'Hỗ trợ'**
  String get billingSupport;

  /// Hành động thư cho con theo thiết kế HOME02
  ///
  /// In vi, this message translates to:
  /// **'Thư cho con'**
  String get homeChildLetter;

  /// Tuổi bé dưới 1 tháng
  ///
  /// In vi, this message translates to:
  /// **'{days} ngày'**
  String commonAgeDays(int days);

  /// Tuổi bé tròn tháng
  ///
  /// In vi, this message translates to:
  /// **'{months} tháng'**
  String commonAgeMonths(int months);

  /// Tuổi bé dưới 1 tuổi, ví dụ 5 tháng 6 ngày
  ///
  /// In vi, this message translates to:
  /// **'{months} tháng {days} ngày'**
  String commonAgeMonthsDays(int months, int days);

  /// Tuổi bé tròn năm
  ///
  /// In vi, this message translates to:
  /// **'{years} tuổi'**
  String commonAgeYears(int years);

  /// Tuổi bé từ 1 tuổi, ví dụ 2 tuổi 4 tháng
  ///
  /// In vi, this message translates to:
  /// **'{years} tuổi {months} tháng'**
  String commonAgeYearsMonths(int years, int months);

  /// Tuần thai tròn
  ///
  /// In vi, this message translates to:
  /// **'Tuần {week}'**
  String commonPregnancyWeekOnly(int week);

  /// Tuần thai kèm ngày lẻ, ví dụ Tuần 24 + 3 ngày
  ///
  /// In vi, this message translates to:
  /// **'Tuần {week} + {day} ngày'**
  String commonPregnancyWeekDay(int week, int day);

  /// Khung màn hình tạm (foundation) trước khi agent khu vực dựng UI
  ///
  /// In vi, this message translates to:
  /// **'Màn hình đang được dựng lại theo thiết kế.'**
  String get commonScreenInProgress;

  /// STATE-05 — tiêu đề băng offline
  ///
  /// In vi, this message translates to:
  /// **'Đang ngoại tuyến'**
  String get stateOfflineTitle;

  /// STATE-05 — dòng phụ băng offline
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =0{Đang xem dữ liệu đã lưu} other{Đang xem dữ liệu đã lưu · {count} ký ức chờ tải lên}}'**
  String stateOfflineSubtitle(int count);

  /// Nút phát ghi âm (a11y)
  ///
  /// In vi, this message translates to:
  /// **'Phát'**
  String get commonPlay;

  /// Nút tạm dừng ghi âm (a11y)
  ///
  /// In vi, this message translates to:
  /// **'Tạm dừng'**
  String get commonPause;

  /// Ô tròn hoàn thành trên thẻ nhiệm vụ (a11y)
  ///
  /// In vi, this message translates to:
  /// **'Đánh dấu đã xong'**
  String get commonMarkDone;

  /// Nút chuông (a11y)
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get commonNotifications;

  /// Dùng chung — tính năng chưa có màn hình
  ///
  /// In vi, this message translates to:
  /// **'Sắp ra mắt'**
  String get commonComingSoon;

  /// Dùng chung — bọc ngoặc kép quanh lời nhắn
  ///
  /// In vi, this message translates to:
  /// **'“{text}”'**
  String commonQuoted(String text);

  /// Thời gian tương đối — dưới 1 phút
  ///
  /// In vi, this message translates to:
  /// **'Vừa xong'**
  String get commonTimeJustNow;

  /// Thời gian tương đối — phút
  ///
  /// In vi, this message translates to:
  /// **'{count} phút trước'**
  String commonTimeMinutesAgo(int count);

  /// Thời gian tương đối — giờ
  ///
  /// In vi, this message translates to:
  /// **'{count} giờ trước'**
  String commonTimeHoursAgo(int count);

  /// Thời gian tương đối — hôm qua (chữ thường, đứng sau dấu ·)
  ///
  /// In vi, this message translates to:
  /// **'hôm qua'**
  String get commonTimeYesterday;

  /// Thời gian tương đối — ngày
  ///
  /// In vi, this message translates to:
  /// **'{count} ngày trước'**
  String commonTimeDaysAgo(int count);

  /// US-01/US-02 — nhãn cảm xúc theo MoodCode
  ///
  /// In vi, this message translates to:
  /// **'{mood, select, ok{Ổn} normal{Bình thường} tired{Mệt} exhausted{Kiệt sức} stressed{Áp lực} sad{Buồn} annoyed{Khó chịu} overwhelmed{Quá tải} lonely{Cô đơn} missYou{Nhớ bạn} other{Ổn}}'**
  String usMoodLabel(String mood);

  /// US-01 — dòng phụ thẻ cảm xúc khi có nhu cầu (CoupleNeed)
  ///
  /// In vi, this message translates to:
  /// **'{need, select, rest{Cần nghỉ ngơi} childcare{Cần giúp trông con} quiet{Cần yên tĩnh} hug{Cần một cái ôm} talk{Cần nói chuyện} encouragement{Cần động viên} other{}}'**
  String usCheckinNeed(String need);

  /// US-01 — “Cần yên tĩnh 20'”
  ///
  /// In vi, this message translates to:
  /// **'{need} {minutes}\''**
  String usCheckinNeedMinutes(String need, int minutes);

  /// US-01 — ô bạn đời khi chưa chia sẻ cảm xúc
  ///
  /// In vi, this message translates to:
  /// **'Chưa chia sẻ'**
  String get usMoodNotShared;

  /// US-01 — phản hồi nhanh đã gửi
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi tới {callName} 💛'**
  String usReplySent(String callName);

  /// US-01 — nhãn trợ năng nút cài đặt
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt Papa & Mama'**
  String get usSettingsTooltip;

  /// US-01 — thẻ lời nhờ đang mở (tôi gửi, trông bé)
  ///
  /// In vi, this message translates to:
  /// **'Bạn nhờ {callName} trông {child} {minutes} phút'**
  String usOpenRequestWatch(String callName, String child, int minutes);

  /// US-01 — thẻ lời nhờ đang mở (tôi gửi)
  ///
  /// In vi, this message translates to:
  /// **'Bạn nhờ {callName}: {title}'**
  String usOpenRequestMine(String callName, String title);

  /// US-01 — thẻ lời nhờ đang mở (bạn đời gửi)
  ///
  /// In vi, this message translates to:
  /// **'{callName} nhờ bạn: {title}'**
  String usOpenRequestTheirs(String callName, String title);

  /// US-01 — trạng thái lời nhờ tôi gửi
  ///
  /// In vi, this message translates to:
  /// **'{status, select, seen{{callName} đã xem · {time}} accepted{{callName} đã nhận · {time}} done{{callName} đã xong · {time}} declined{{callName}: hôm nay không được} other{Đã gửi · {time}}}'**
  String usRequestStatusPartner(String status, String callName, String time);

  /// US-01 — trạng thái lời nhờ tôi nhận
  ///
  /// In vi, this message translates to:
  /// **'{status, select, accepted{Bạn đã nhận · {time}} other{Chờ bạn trả lời · {time}}}'**
  String usRequestStatusMine(String status, String time);

  /// US-01 — gợi ý câu hỏi hôm nay
  ///
  /// In vi, this message translates to:
  /// **'Câu trả lời của nhau chỉ hiện khi cả hai đã trả lời.'**
  String get usDailyQuestionHintBoth;

  /// US-01 — ô trả lời câu hỏi hôm nay
  ///
  /// In vi, this message translates to:
  /// **'Câu trả lời của bạn'**
  String get usDailyQuestionYourAnswer;

  /// US-01 — câu trả lời đã gửi
  ///
  /// In vi, this message translates to:
  /// **'{callName}: {answer}'**
  String usDailyQuestionAnswerBy(String callName, String answer);

  /// US-01 — người gửi lời cảm ơn + thời gian
  ///
  /// In vi, this message translates to:
  /// **'{callName} · {time}'**
  String usThanksByLine(String callName, String time);

  /// US — chỉ người dùng hiện tại
  ///
  /// In vi, this message translates to:
  /// **'Bạn'**
  String get usYou;

  /// US-03 — câu mẫu lời nhờ Cần nghỉ
  ///
  /// In vi, this message translates to:
  /// **'Em cần nghỉ khoảng {minutes} phút. Anh trông {child} giúp em nhé? 💛'**
  String usRequestRestMessage(int minutes, String child);

  /// US-03 — câu mẫu lời nhờ Trông con
  ///
  /// In vi, this message translates to:
  /// **'Anh trông {child} giúp em khoảng {minutes} phút nhé? 💛'**
  String usRequestWatchMessage(int minutes, String child);

  /// US-04 — lý do từ chối nhanh
  ///
  /// In vi, this message translates to:
  /// **'Đang trông {child}'**
  String usRequestReasonBusyWith(String child);

  /// US-04 người gửi — dòng người gửi
  ///
  /// In vi, this message translates to:
  /// **'Bạn nhờ {callName}'**
  String usRequestYouAsked(String callName);

  /// US-04 người gửi — tiêu đề
  ///
  /// In vi, this message translates to:
  /// **'Lời nhờ của bạn'**
  String get usRequestMineTitle;

  /// US-04 người gửi — timeline
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã gửi'**
  String get usRequestYouSent;

  /// US-04 người gửi — timeline
  ///
  /// In vi, this message translates to:
  /// **'{callName} đã xem'**
  String usRequestPartnerViewed(String callName);

  /// US-04 người gửi — timeline
  ///
  /// In vi, this message translates to:
  /// **'{callName} đã nhận'**
  String usRequestPartnerAccepted(String callName);

  /// US-04 — nhãn trạng thái lời nhờ
  ///
  /// In vi, this message translates to:
  /// **'{status, select, sent{Đã gửi} seen{Đã xem} accepted{Đã nhận} done{Đã xong} declined{Hôm nay không được} acknowledged{Đã thấy} expired{Hết hạn} cancelled{Đã huỷ} other{}}'**
  String usRequestBadge(String status);

  /// US-04 người gửi — huỷ
  ///
  /// In vi, this message translates to:
  /// **'Huỷ lời nhờ'**
  String get usRequestCancel;

  /// US-04 người gửi — cảm ơn khi xong
  ///
  /// In vi, this message translates to:
  /// **'Gửi lời cảm ơn'**
  String get usRequestThank;

  /// US-04 người gửi — khi bị từ chối
  ///
  /// In vi, this message translates to:
  /// **'Tự mình làm'**
  String get usRequestDoMyself;

  /// US-04 NEED — gửi ôm
  ///
  /// In vi, this message translates to:
  /// **'Gửi 🤗'**
  String get usRequestSendHug;

  /// US-05 — tiêu đề
  ///
  /// In vi, this message translates to:
  /// **'Cảm ơn {callName}'**
  String usThanksTitle(String callName);

  /// US-05 — nhóm câu mẫu
  ///
  /// In vi, this message translates to:
  /// **'CÂU MẪU'**
  String get usThanksSamples;

  /// US-05 — câu mẫu 1
  ///
  /// In vi, this message translates to:
  /// **'Cảm ơn vì đã trông con giúp mình 💛'**
  String get usThanksSample1;

  /// US-05 — câu mẫu 2
  ///
  /// In vi, this message translates to:
  /// **'Cảm ơn vì hôm nay đã ở bên mình'**
  String get usThanksSample2;

  /// US-05 — câu mẫu 3
  ///
  /// In vi, this message translates to:
  /// **'Có bạn, mọi việc nhẹ hơn nhiều'**
  String get usThanksSample3;

  /// US-05 — nhóm sticker
  ///
  /// In vi, this message translates to:
  /// **'STICKER'**
  String get usThanksSticker;

  /// US-05 — công tắc đăng khoảnh khắc
  ///
  /// In vi, this message translates to:
  /// **'Đề nghị đăng thành khoảnh khắc gia đình'**
  String get usThanksPostFamily;

  /// US-05 — chú thích công tắc
  ///
  /// In vi, this message translates to:
  /// **'Cần {callName} đồng ý'**
  String usThanksPostFamilyHint(String callName);

  /// US-05 — đã gửi
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi lời cảm ơn tới {callName} 💛'**
  String usThanksSent(String callName);

  /// CARE-01 tree card when every mission is done
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay nhà mình đã chăm con thật tròn đầy 🌸'**
  String get careTreeBloomed;

  /// CARE-01 open request row (partner sent)
  ///
  /// In vi, this message translates to:
  /// **'{count} lời nhờ đang mở · {callName} nhờ: {title}'**
  String careOpenRequestFromPartner(int count, String callName, String title);

  /// CARE-01 open request row (I sent)
  ///
  /// In vi, this message translates to:
  /// **'{count} lời nhờ đang mở · Bạn nhờ {callName}: {title}'**
  String careOpenRequestToPartner(int count, String callName, String title);

  /// Mission meta: system mission
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý hôm nay'**
  String get careMetaSuggested;

  /// Mission meta: self-added mission
  ///
  /// In vi, this message translates to:
  /// **'Tự tạo'**
  String get careMetaCustom;

  /// Mission Hearts in meta line
  ///
  /// In vi, this message translates to:
  /// **'+{count} 💗'**
  String careMetaHearts(int count);

  /// My mission done meta
  ///
  /// In vi, this message translates to:
  /// **'Đã xong {time}'**
  String careMetaDoneAt(String time);

  /// Partner mission done meta
  ///
  /// In vi, this message translates to:
  /// **'Xong lúc {time}'**
  String carePartnerDoneAt(String time);

  /// Mission category label
  ///
  /// In vi, this message translates to:
  /// **'{category, select, care{Chăm sóc} bonding{Gắn kết} outing{Ra ngoài} memory{Lưu kỷ niệm} support{Hỗ trợ bạn đời} self{Chăm bản thân} together{Cả nhà} couple{Hai ta} other{Tự gõ}}'**
  String careCategory(String category);

  /// Mission duration
  ///
  /// In vi, this message translates to:
  /// **'{minutes} phút'**
  String careDurationMin(int minutes);

  /// CARE-01b partner tab privacy note
  ///
  /// In vi, this message translates to:
  /// **'Bạn chỉ xem được việc {callName} đã làm. Hearts của {callName} chỉ {callName} thấy.'**
  String carePartnerNote(String callName);

  /// CARE-01b all partner missions done
  ///
  /// In vi, this message translates to:
  /// **'{callName} đã xong cả {count} việc hôm nay'**
  String carePartnerAllDone(String callName, int count);

  /// Quick thanks on partner done mission
  ///
  /// In vi, this message translates to:
  /// **'Cảm ơn'**
  String get careThank;

  /// Thanks already sent
  ///
  /// In vi, this message translates to:
  /// **'Đã cảm ơn'**
  String get careThanked;

  /// Complete a together mission
  ///
  /// In vi, this message translates to:
  /// **'Xong cùng nhau'**
  String get careDoneTogether;

  /// CARE-01 my tab empty
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay bạn chưa có việc nào'**
  String get careMineEmpty;

  /// CARE-01 partner tab empty
  ///
  /// In vi, this message translates to:
  /// **'{callName} chưa có việc nào hôm nay'**
  String carePartnerEmpty(String callName);

  /// CARE-01 together tab empty
  ///
  /// In vi, this message translates to:
  /// **'Chưa có việc cùng nhau hôm nay'**
  String get careTogetherEmpty;

  /// Undo snackbar after completing
  ///
  /// In vi, this message translates to:
  /// **'Đã xong “{title}”'**
  String careDoneSnack(String title);

  /// STATE-03 section title
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý cho {name} · {age}'**
  String careSuggestFor(String name, String age);

  /// STATE-03 section title for whole family
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý hôm nay'**
  String get careSuggestToday;

  /// CARE-06 description
  ///
  /// In vi, this message translates to:
  /// **'{title} · cây hôm nay có thêm 1 chiếc lá 🍃 (+{photoHearts} 💗 nếu lưu ảnh)'**
  String careCompleteDesc(String title, int photoHearts);

  /// CARE-06 note field
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú (tuỳ chọn)…'**
  String get careNoteHint;

  /// CARE-03 open mission library
  ///
  /// In vi, this message translates to:
  /// **'Thư viện'**
  String get careLibraryLink;

  /// CARE-04 title
  ///
  /// In vi, this message translates to:
  /// **'Thư viện nhiệm vụ'**
  String get careLibraryTitle;

  /// CARE-03 mission title hint
  ///
  /// In vi, this message translates to:
  /// **'Việc gì?'**
  String get careTitleHint;

  /// CARE-03 date option
  ///
  /// In vi, this message translates to:
  /// **'Ngày mai'**
  String get careTomorrow;

  /// CARE-03 repeat option
  ///
  /// In vi, this message translates to:
  /// **'{repeat, select, daily{Hằng ngày} weekdays{Ngày thường} weekends{Cuối tuần} other{Không lặp}}'**
  String careRepeatOption(String repeat);

  /// CARE-03 reminder option
  ///
  /// In vi, this message translates to:
  /// **'{reminder, select, atTime{Nhắc đúng giờ} before15{Nhắc trước 15 phút} before30{Nhắc trước 30 phút} before60{Nhắc trước 60 phút} other{Không nhắc}}'**
  String careReminderOption(String reminder);

  /// CARE-03 no due time
  ///
  /// In vi, this message translates to:
  /// **'Giờ bất kỳ'**
  String get careTimeAny;

  /// CARE-09 next level
  ///
  /// In vi, this message translates to:
  /// **'Sắp tới {name} 🌸'**
  String careTreeNextLevel(String name);

  /// CARE-09 next level reward
  ///
  /// In vi, this message translates to:
  /// **'Phần thưởng: {reward}'**
  String careTreeRewardLabel(String reward);

  /// CARE-09 progress percent
  ///
  /// In vi, this message translates to:
  /// **'{percent}%'**
  String careTreePercent(int percent);

  /// CARE-09 my hearts section title
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã góp 🔒 Chỉ bạn thấy'**
  String get careTreeContributionTitle;

  /// Hearts amount
  ///
  /// In vi, this message translates to:
  /// **'{count} 💗'**
  String careHeartsValue(int count);

  /// Hearts earned badge
  ///
  /// In vi, this message translates to:
  /// **'+{count}'**
  String careHeartsPlus(int count);

  /// CARE-09 history time
  ///
  /// In vi, this message translates to:
  /// **'{day} · {time}'**
  String careHistoryWhen(String day, String time);

  /// CARE-09 history together
  ///
  /// In vi, this message translates to:
  /// **'Cùng nhau · {day}'**
  String careHistoryTogether(String day);

  /// Yesterday
  ///
  /// In vi, this message translates to:
  /// **'Hôm qua'**
  String get careYesterday;

  /// Weekday full name
  ///
  /// In vi, this message translates to:
  /// **'{day, select, mon{Thứ hai} tue{Thứ ba} wed{Thứ tư} thu{Thứ năm} fri{Thứ sáu} sat{Thứ bảy} other{Chủ nhật}}'**
  String careWeekdayLong(String day);

  /// CARE-02 title
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết nhiệm vụ'**
  String get careDetailTitle;

  /// CARE-02 complete button
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành'**
  String get careComplete;

  /// CARE-02 owner row label
  ///
  /// In vi, this message translates to:
  /// **'Người làm'**
  String get careOwnerLabel;

  /// CARE-02 child row label
  ///
  /// In vi, this message translates to:
  /// **'Cho bé'**
  String get careChildLabel;

  /// CARE-02 time row label
  ///
  /// In vi, this message translates to:
  /// **'Thời gian'**
  String get careTimeLabel;

  /// CARE-02 missing mission
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy nhiệm vụ này'**
  String get careMissionNotFound;

  /// CARE-02 swap button
  ///
  /// In vi, this message translates to:
  /// **'Đổi việc khác'**
  String get careSwapAction;

  /// Thời gian tương đối
  ///
  /// In vi, this message translates to:
  /// **'Vừa xong'**
  String get commonJustNow;

  /// Thời gian tương đối (phút)
  ///
  /// In vi, this message translates to:
  /// **'{count} phút trước'**
  String commonMinutesAgo(int count);

  /// Thời gian tương đối (giờ)
  ///
  /// In vi, this message translates to:
  /// **'{count} giờ trước'**
  String commonHoursAgo(int count);

  /// Thời gian tương đối (ngày)
  ///
  /// In vi, this message translates to:
  /// **'{count} ngày trước'**
  String commonDaysAgo(int count);

  /// FAM-01 thẻ gói dùng thử
  ///
  /// In vi, this message translates to:
  /// **'Còn {days} ngày · hết hạn {date}'**
  String famTrialSubtitle(int days, String date);

  /// FAM-01 dung lượng đã dùng
  ///
  /// In vi, this message translates to:
  /// **'{used} GB / {total} GB'**
  String famStorageUsage(String used, String total);

  /// FAM-01 tên gói House
  ///
  /// In vi, this message translates to:
  /// **'Gói House'**
  String get famPlanHouse;

  /// FAM-01 tên gói Family
  ///
  /// In vi, this message translates to:
  /// **'Gói Family'**
  String get famPlanFamily;

  /// FAM-01 ngày gia hạn gói
  ///
  /// In vi, this message translates to:
  /// **'Gia hạn {date}'**
  String famPlanRenews(String date);

  /// FAM-01 nhãn vai trò cha (không phải tên gọi)
  ///
  /// In vi, this message translates to:
  /// **'Bố'**
  String get famRoleFather;

  /// FAM-01 nhãn vai trò mẹ (không phải tên gọi)
  ///
  /// In vi, this message translates to:
  /// **'Mẹ'**
  String get famRoleMother;

  /// FAM-01 dòng phụ thai kỳ
  ///
  /// In vi, this message translates to:
  /// **'Thai {week} tuần · dự sinh {date}'**
  String famPregnancySubtitle(int week, String date);

  /// FAM-01 người thân chưa nhận lời mời
  ///
  /// In vi, this message translates to:
  /// **'Đang chờ tham gia'**
  String get famRelativePending;

  /// FAM-03 chip quan hệ khác
  ///
  /// In vi, this message translates to:
  /// **'Khác…'**
  String get famRelationOther;

  /// FAM-03 dòng phụ
  ///
  /// In vi, this message translates to:
  /// **'Gói Family · đã dùng {used}/{max} chỗ người thân'**
  String famInviteSlots(int used, int max);

  /// FAM-03 tên thai kỳ trong danh sách bé
  ///
  /// In vi, this message translates to:
  /// **'{name} (thai kỳ)'**
  String famPregnancyChild(String name);

  /// FAM-03 mô tả quyền xem
  ///
  /// In vi, this message translates to:
  /// **'Mức hiển thị “Cả nhà”'**
  String get famPhotosPermissionHint;

  /// FAM-03 mô tả quyền bình luận
  ///
  /// In vi, this message translates to:
  /// **'Gửi lời chúc cho cháu'**
  String get famCommentPermissionHint;

  /// FAM-03 mô tả quyền đóng góp ảnh
  ///
  /// In vi, this message translates to:
  /// **'Papa/Mama duyệt trước khi hiện'**
  String get famPostPermissionHint;

  /// FAM-03 ghi chú quyền riêng tư
  ///
  /// In vi, this message translates to:
  /// **'Người thân không xem được khu vực Papa & Mama và nội dung riêng tư.'**
  String get famInviteNote;

  /// FAM-03 snackbar sau khi tạo lời mời (mô phỏng chia sẻ)
  ///
  /// In vi, this message translates to:
  /// **'Đã tạo lời mời cho {callName}: {link}'**
  String famInviteShared(String callName, String link);

  /// FAM-03/05 tin nhắn soạn sẵn gửi kèm link mời người thân (share sheet)
  ///
  /// In vi, this message translates to:
  /// **'{callName} ơi, vào Baby Family xem ảnh và ký ức của {children} cùng nhà mình nhé! Mã mời: {code} · {link}'**
  String famInviteShareMessage(
    String callName,
    String children,
    String code,
    String link,
  );

  /// SUB-01 nhãn dùng thử
  ///
  /// In vi, this message translates to:
  /// **'Dùng thử còn {days} ngày'**
  String subTrialLeft(int days);

  /// SUB-01 nút mua
  ///
  /// In vi, this message translates to:
  /// **'Nâng cấp {plan} · {price}'**
  String subBuy(String plan, String price);

  /// SUB-01 nút khi đã có gói
  ///
  /// In vi, this message translates to:
  /// **'Gói hiện tại'**
  String get subCurrentPlan;

  /// SUB-01 snackbar mua thành công (mô phỏng)
  ///
  /// In vi, this message translates to:
  /// **'Nhà mình đã lên gói {plan} 🎉'**
  String subPurchased(String plan);

  /// SUB-01/07 khôi phục giao dịch (mô phỏng)
  ///
  /// In vi, this message translates to:
  /// **'Chưa tìm thấy giao dịch nào để khôi phục.'**
  String get subRestoreNone;

  /// SUB-07 thống kê ấm áp
  ///
  /// In vi, this message translates to:
  /// **'Nhà mình đã lưu {memories} ký ức và {firsts} lần đầu của {names}. Mọi thứ vẫn an toàn — nâng cấp để cả nhà tiếp tục ghi lại hành trình của các con.'**
  String subExpiredStats(int memories, int firsts, String names);

  /// SUB-07 thẻ giữ dữ liệu
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu được giữ đến {date}'**
  String subRetentionTitle(String date);

  /// SUB-07 snackbar tải dữ liệu (mô phỏng)
  ///
  /// In vi, this message translates to:
  /// **'Đang chuẩn bị dữ liệu, nhà mình sẽ nhận thông báo khi tải về được.'**
  String get subExportStarted;

  /// SET-01 dòng phụ hồ sơ
  ///
  /// In vi, this message translates to:
  /// **'{callName} · {family}'**
  String setProfileSubtitle(String callName, String family);

  /// SET-01 lượt AI còn lại
  ///
  /// In vi, this message translates to:
  /// **'{remaining}/{total} lượt'**
  String setAiQuota(int remaining, int total);

  /// SET-01 trạng thái gói dùng thử
  ///
  /// In vi, this message translates to:
  /// **'Dùng thử'**
  String get setPlanTrial;

  /// SET-01 trạng thái gói hết hạn
  ///
  /// In vi, this message translates to:
  /// **'Hết hạn'**
  String get setPlanExpired;

  /// SET-01 phiên bản app
  ///
  /// In vi, this message translates to:
  /// **'v{version}'**
  String setVersion(String version);

  /// SET-06 xem trước cỡ chữ
  ///
  /// In vi, this message translates to:
  /// **'{name} vừa đạt cột mốc mới: tự ngồi vững 🎉'**
  String setTextPreview(String name);

  /// CIR-01 lời chào
  ///
  /// In vi, this message translates to:
  /// **'Chào {callName}'**
  String cirHello(String callName);

  /// CIR-01 tiêu đề theo người xem
  ///
  /// In vi, this message translates to:
  /// **'{who, select, grandma{Cháu yêu của bà} grandpa{Cháu yêu của ông} other{Cháu yêu của cả nhà}}'**
  String cirTitle(String who);

  /// CIR-01 chú thích ký ức nổi bật
  ///
  /// In vi, this message translates to:
  /// **'“{text}” — {author}, {time}'**
  String cirHeroCaption(String text, String author, String time);

  /// CIR-01 snackbar thả tim
  ///
  /// In vi, this message translates to:
  /// **'Đã thả tim cho {name} 💛'**
  String cirLiked(String name);

  /// CIR-01 ô nhập lời chúc
  ///
  /// In vi, this message translates to:
  /// **'Viết lời chúc cho {name}…'**
  String cirWishHint(String name);

  /// CIR-01 nút gửi lời chúc
  ///
  /// In vi, this message translates to:
  /// **'Gửi'**
  String get cirWishSend;

  /// CIR-01 snackbar gửi lời chúc
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi lời chúc cho {name}'**
  String cirWishSent(String name);

  /// CIR-01 trạng thái trống
  ///
  /// In vi, this message translates to:
  /// **'Papa & Mama chưa đăng ảnh mới. {callName} sẽ được báo khi có nhé.'**
  String cirEmpty(String callName);

  /// PREG-01 — tiêu đề
  ///
  /// In vi, this message translates to:
  /// **'Hành trình của {child}'**
  String pregJourneyTitle(String child);

  /// PREG-01 — header phụ
  ///
  /// In vi, this message translates to:
  /// **'Còn {days} ngày · {memories} ký ức · {firsts} lần đầu'**
  String pregJourneyStats(int days, int memories, int firsts);

  /// PREG-01 — nhãn tuần hiện tại
  ///
  /// In vi, this message translates to:
  /// **'tuần này'**
  String get pregWeekThis;

  /// PREG-01 — nhãn tuần có cột mốc
  ///
  /// In vi, this message translates to:
  /// **'Lần đầu'**
  String get pregWeekFirsts;

  /// PREG-01 — gợi ý chụp ảnh bụng
  ///
  /// In vi, this message translates to:
  /// **'Có bóng mờ tuần {week} để giữ cùng góc chụp'**
  String pregBumpGhostHint(int week);

  /// PREG-01 — tuần thai rút gọn
  ///
  /// In vi, this message translates to:
  /// **'Tuần {week} + {day}'**
  String pregWeekDayShort(int week, int day);

  /// PREG-01 — người đăng
  ///
  /// In vi, this message translates to:
  /// **'{callName} đăng'**
  String pregPostedBy(String callName);

  /// PREG-01 — nhãn thẻ siêu âm
  ///
  /// In vi, this message translates to:
  /// **'SIÊU ÂM · TUẦN {week}'**
  String pregUltrasoundWeek(int week);

  /// Trích dẫn trong ngoặc kép
  ///
  /// In vi, this message translates to:
  /// **'“{text}”'**
  String pregQuoted(String text);

  /// PREG-01 — nhãn thẻ cột mốc
  ///
  /// In vi, this message translates to:
  /// **'LẦN ĐẦU'**
  String get pregFirstLabel;

  /// PREG-01 — mô tả cột mốc thai kỳ
  ///
  /// In vi, this message translates to:
  /// **'Sẽ thành cột mốc của bé sau khi chào đời'**
  String get pregMilestoneLater;

  /// PREG-01 — menu
  ///
  /// In vi, this message translates to:
  /// **'Sửa thai kỳ'**
  String get pregMenuEdit;

  /// PREG-01 menu / PREG-06 nút xác nhận
  ///
  /// In vi, this message translates to:
  /// **'Lưu trữ'**
  String get pregMenuArchive;

  /// PREG-02 — so sánh
  ///
  /// In vi, this message translates to:
  /// **'So sánh · Tuần {from} → Tuần {to}'**
  String pregBumpCompare(int from, int to);

  /// PREG-02 — nhãn ô tuần
  ///
  /// In vi, this message translates to:
  /// **'T{week}'**
  String pregWeekShort(int week);

  /// PREG-02 — ô chụp tuần này
  ///
  /// In vi, this message translates to:
  /// **'T{week} · chụp'**
  String pregWeekCapture(int week);

  /// PREG-03 — thêm mới
  ///
  /// In vi, this message translates to:
  /// **'Thêm ảnh siêu âm'**
  String get pregUltrasoundAdd;

  /// PREG-03 — rỗng
  ///
  /// In vi, this message translates to:
  /// **'Chưa có ảnh siêu âm'**
  String get pregUltrasoundEmpty;

  /// PREG-03 — rỗng mô tả
  ///
  /// In vi, this message translates to:
  /// **'Lưu ảnh siêu âm theo tuần thai kèm lời nhắn.'**
  String get pregUltrasoundEmptyHint;

  /// PREG-04 — đếm ngược
  ///
  /// In vi, this message translates to:
  /// **'còn {days} ngày'**
  String pregDaysLeft(int days);

  /// PREG-04 — nhóm
  ///
  /// In vi, this message translates to:
  /// **'Đồ đi sinh'**
  String get pregGroupBag;

  /// PREG-04 — nhóm
  ///
  /// In vi, this message translates to:
  /// **'Giấy tờ'**
  String get pregGroupPapers;

  /// PREG-04 — nhóm
  ///
  /// In vi, this message translates to:
  /// **'Góc của bé'**
  String get pregGroupNursery;

  /// PREG-04 — nhóm
  ///
  /// In vi, this message translates to:
  /// **'Sức khoẻ'**
  String get pregGroupHealth;

  /// PREG-04 — nhãn đã nhờ
  ///
  /// In vi, this message translates to:
  /// **'Đã nhờ {callName}'**
  String pregOwnerRequested(String callName);

  /// PREG-04 — lựa chọn nhờ bạn đời
  ///
  /// In vi, this message translates to:
  /// **'Nhờ {callName}'**
  String pregOwnerAsk(String callName);

  /// PREG-04 — sheet chọn người phụ trách
  ///
  /// In vi, this message translates to:
  /// **'Ai lo mục này?'**
  String get pregOwnerTitle;

  /// PREG-05 B1
  ///
  /// In vi, this message translates to:
  /// **'Chúc mừng gia đình! Có mấy bé?'**
  String get pregBirthCountTitle;

  /// PREG-05 B1 — lựa chọn số bé
  ///
  /// In vi, this message translates to:
  /// **'{count} bé'**
  String pregBirthBabyCount(int count);

  /// PREG-05 B2 — tiêu đề
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng bé đến với nhà mình 🎉'**
  String get pregBirthWelcomeTitle;

  /// PREG-05 B2 — phụ đề
  ///
  /// In vi, this message translates to:
  /// **'Bé {index}/{count} · thông tin này sửa lại được bất cứ lúc nào'**
  String pregBirthBabyIndex(int index, int count);

  /// PREG-05 B2 — tên kèm tên ở nhà
  ///
  /// In vi, this message translates to:
  /// **'{name} ({nickname})'**
  String pregBirthNameValue(String name, String nickname);

  /// PREG-05 B2
  ///
  /// In vi, this message translates to:
  /// **'Cân nặng (chỉ lưu)'**
  String get pregBirthWeightLabel;

  /// Đơn vị kg
  ///
  /// In vi, this message translates to:
  /// **'{value} kg'**
  String pregKg(String value);

  /// Đơn vị cm
  ///
  /// In vi, this message translates to:
  /// **'{value} cm'**
  String pregCm(String value);

  /// PREG-05 B3 — nhãn thẻ (in hoa)
  ///
  /// In vi, this message translates to:
  /// **'{family} chào đón'**
  String pregBirthFamilyWelcomes(String family);

  /// PREG-05 B3
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng {name}! 💜'**
  String pregBirthWelcomeName(String name);

  /// PREG-05 B3
  ///
  /// In vi, this message translates to:
  /// **'“{nickname}” của cả nhà'**
  String pregBirthNickname(String nickname);

  /// PREG-05 B3
  ///
  /// In vi, this message translates to:
  /// **'“{nickname}” của cả nhà · em của {siblings}'**
  String pregBirthNicknameSiblings(String nickname, String siblings);

  /// Nối danh sách tên
  ///
  /// In vi, this message translates to:
  /// **'{first} & {last}'**
  String pregNamesAnd(String first, String last);

  /// PREG-05 B4
  ///
  /// In vi, this message translates to:
  /// **'Chỉ người thân đang được chia sẻ thai kỳ. Ký ức thai kỳ trở thành chương mở đầu của {child}.'**
  String pregBirthAnnounceNote(String child);

  /// PREG-05 B4 — nút
  ///
  /// In vi, this message translates to:
  /// **'Hoàn tất & báo tin 🎉'**
  String get pregBirthDone;

  /// PREG-06 — tiêu đề
  ///
  /// In vi, this message translates to:
  /// **'Lưu trữ hành trình của {child}'**
  String pregArchiveTitle(String child);

  /// PREG-07 — nhãn
  ///
  /// In vi, this message translates to:
  /// **'Cả hai thích 💞'**
  String get pregNamesBothLike;

  /// PREG-07
  ///
  /// In vi, this message translates to:
  /// **'Thêm bởi {callName}'**
  String pregNamesAddedBy(String callName);

  /// PREG-07 — semantics nút tim
  ///
  /// In vi, this message translates to:
  /// **'{callName} thích'**
  String pregNamesLikeBy(String callName);

  /// AUTH-04 — gợi ý ô tên
  ///
  /// In vi, this message translates to:
  /// **'Nhập tên'**
  String get authNameHint;

  /// AUTH-03 — đếm ngược gửi lại mã (m:ss)
  ///
  /// In vi, this message translates to:
  /// **'Gửi lại mã sau {time}'**
  String authResendIn(String time);

  /// AUTH-02 — a11y ô mã quốc gia
  ///
  /// In vi, this message translates to:
  /// **'Mã quốc gia {code}'**
  String authCountryCodeSemantics(String code);

  /// AUTH-04 — a11y ô avatar
  ///
  /// In vi, this message translates to:
  /// **'Chọn ảnh đại diện'**
  String get authChangeAvatar;

  /// ONB-06 — tên gia đình điền sẵn từ tên người dùng
  ///
  /// In vi, this message translates to:
  /// **'Nhà {name}'**
  String onbFamilyDefaultName(String name);

  /// Tên gọi + tên (“Mama Lan”)
  ///
  /// In vi, this message translates to:
  /// **'{callName} {name}'**
  String onbMemberLabel(String callName, String name);

  /// ONB-06 — dòng phụ trên ảnh bìa
  ///
  /// In vi, this message translates to:
  /// **'{member} · đang chờ {partnerCallName}'**
  String onbFamilyCoverWaiting(String member, String partnerCallName);

  /// ONB-06 — gợi ý tên gia đình
  ///
  /// In vi, this message translates to:
  /// **'Nhà Cà Chua'**
  String get onbFamilySuggestion1;

  /// ONB-06 — gợi ý tên gia đình
  ///
  /// In vi, this message translates to:
  /// **'Tổ ấm nhỏ'**
  String get onbFamilySuggestion2;

  /// ONB-06 — gợi ý tên gia đình
  ///
  /// In vi, this message translates to:
  /// **'Nhà mình'**
  String get onbFamilySuggestion3;

  /// ONB-06 — a11y nút đổi ảnh bìa
  ///
  /// In vi, this message translates to:
  /// **'Đổi ảnh bìa'**
  String get onbChangeCover;

  /// ONB-07 — dòng phụ; {days} = thời lượng trial policy
  ///
  /// In vi, this message translates to:
  /// **'Baby Family cần cả Papa và Mama. Khi {callName} tham gia, nhà mình bắt đầu {days} ngày dùng thử miễn phí.'**
  String onbInviteSubtitle(String callName, int days);

  /// ONB-07 — công tắc xác nhận
  ///
  /// In vi, this message translates to:
  /// **'Tôi xác nhận lần cuối khi {callName} tham gia'**
  String onbInviteApproval(String callName);

  /// ONB-07/ONB-WAIT — tin nhắn chia sẻ lời mời
  ///
  /// In vi, this message translates to:
  /// **'Vào Baby Family cùng mình lưu giữ hành trình của con nhé! Mã mời: {code} · {link}'**
  String onbInviteShareMessage(String code, String link);

  /// ONB-WAIT — dòng phụ; {days} = thời lượng trial policy
  ///
  /// In vi, this message translates to:
  /// **'Khi {callName} nhận lời mời, nhà mình sẽ được mở khoá và bắt đầu {days} ngày dùng thử miễn phí.'**
  String onbWaitingSubtitle(String callName, int days);

  /// ONB-WAIT — trạng thái lời mời
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi lời mời lúc {time}'**
  String onbWaitingSentAt(String time);

  /// ONB-WAIT — trạng thái lời mời
  ///
  /// In vi, this message translates to:
  /// **'{callName} đã mở link mời'**
  String onbWaitingOpened(String callName);

  /// ONB-WAIT — hạn lời mời
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =0{Hết hạn hôm nay} other{Hết hạn sau {count} ngày}}'**
  String onbWaitingExpires(int count);

  /// ONB-WAIT — xác nhận huỷ gia đình
  ///
  /// In vi, this message translates to:
  /// **'Bạn sẽ quay lại bước chọn vai trò. Lời mời đã gửi sẽ không còn hiệu lực.'**
  String get onbCancelFamilyMessage;

  /// ONB-ACT — hạn dùng thử
  ///
  /// In vi, this message translates to:
  /// **'Đến hết ngày {date} · không cần thẻ thanh toán'**
  String onbTrialUntil(String date);

  /// ONB-ACT — sau dùng thử
  ///
  /// In vi, this message translates to:
  /// **'Sau đó chọn gói House ({housePrice}) hoặc Family ({familyPrice}) để tiếp tục.'**
  String onbTrialAfter(String housePrice, String familyPrice);

  /// ONB-04 — dòng phụ
  ///
  /// In vi, this message translates to:
  /// **'{first} và {second} có thể thêm bé hoặc thai kỳ khác bất cứ lúc nào.'**
  String onbStageSubtitle(String first, String second);

  /// ONB-04 — mô tả thẻ Đã có bé và đang mang thai
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ các bé và thai kỳ chạy song song trong cùng gia đình'**
  String get onbStageBothDescription;

  /// ONB-05a — gợi ý tên ở nhà
  ///
  /// In vi, this message translates to:
  /// **'Đậu'**
  String get onbNicknameIdea1;

  /// ONB-05a — gợi ý tên ở nhà
  ///
  /// In vi, this message translates to:
  /// **'Cà Chua'**
  String get onbNicknameIdea2;

  /// ONB-05a — gợi ý tên ở nhà
  ///
  /// In vi, this message translates to:
  /// **'Mít'**
  String get onbNicknameIdea3;

  /// ONB-05a — gợi ý tên ở nhà
  ///
  /// In vi, this message translates to:
  /// **'Sóc'**
  String get onbNicknameIdea4;

  /// ONB-05a — xem trước tuần thai
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =0{Hôm nay gặp {name}} other{Còn {count} ngày nữa gặp {name}}}'**
  String onbMeetCountdown(int count, String name);

  /// ONB-05a — chuyển về nhập ngày dự sinh
  ///
  /// In vi, this message translates to:
  /// **'Mình biết ngày dự sinh'**
  String get onbKnowDueDate;

  /// ONB-05a — giá trị ô tuần thai
  ///
  /// In vi, this message translates to:
  /// **'Tuần {week}'**
  String onbWeekValue(int week);

  /// ONB-10 — dòng ứng dụng trên thông báo mẫu
  ///
  /// In vi, this message translates to:
  /// **'Baby Family · {time}'**
  String onbNotifMeta(String time);

  /// ONB-10 — thời gian thông báo mẫu
  ///
  /// In vi, this message translates to:
  /// **'bây giờ'**
  String get onbNotifNow;

  /// ONB-10 — thời gian thông báo mẫu
  ///
  /// In vi, this message translates to:
  /// **'5 phút trước'**
  String get onbNotif5Minutes;

  /// ONB-10 — thời gian thông báo mẫu
  ///
  /// In vi, this message translates to:
  /// **'1 giờ trước'**
  String get onbNotif1Hour;

  /// ONB-10 — thông báo mẫu 1
  ///
  /// In vi, this message translates to:
  /// **'{sender} nhờ {receiver}: Tắm cho {child} tối nay'**
  String onbNotifRequestTitle(String sender, String receiver, String child);

  /// ONB-10 — thông báo mẫu 1
  ///
  /// In vi, this message translates to:
  /// **'Nhận hoặc đề xuất giờ khác chỉ với một chạm.'**
  String get onbNotifRequestBody;

  /// ONB-10 — thông báo mẫu 2
  ///
  /// In vi, this message translates to:
  /// **'Có 3 ảnh mới của {child} hôm nay'**
  String onbNotifPhotosTitle(String child);

  /// ONB-10 — thông báo mẫu 2
  ///
  /// In vi, this message translates to:
  /// **'Bà nội đã thả tim 2 ảnh.'**
  String get onbNotifPhotosBody;

  /// ONB-10 — thông báo mẫu 3
  ///
  /// In vi, this message translates to:
  /// **'Bạn có cập nhật mới từ Papa & Mama'**
  String get onbNotifUsTitle;

  /// ONB-10 — thông báo mẫu 3
  ///
  /// In vi, this message translates to:
  /// **'Nội dung riêng tư được ẩn trên màn hình khoá.'**
  String get onbNotifUsBody;

  /// ONB-10 — tên bé thay thế khi chưa có bé
  ///
  /// In vi, this message translates to:
  /// **'bé'**
  String get onbNotifChildFallback;

  /// ONB-09 — dòng phụ
  ///
  /// In vi, this message translates to:
  /// **'Lưu khoảnh khắc đầu tiên của {name} trong Baby Family.'**
  String onbFirstMemorySubtitle(String name);

  /// INV-01 — người mời (bạn đời)
  ///
  /// In vi, this message translates to:
  /// **'{name} ({callName}) mời bạn tham gia'**
  String invInviterParent(String name, String callName);

  /// INV-01 — người mời (người thân)
  ///
  /// In vi, this message translates to:
  /// **'{name} ({callName}) mời {pronoun} theo dõi cháu'**
  String invInviterRelative(String name, String callName, String pronoun);

  /// INV-01 khi server không có tên người mời (chỉ tên gọi)
  ///
  /// In vi, this message translates to:
  /// **'{callName} mời bạn tham gia'**
  String invInviterParentShort(String callName);

  /// INV-01 người thân, khi server không có tên người mời
  ///
  /// In vi, this message translates to:
  /// **'{callName} mời {pronoun} theo dõi cháu'**
  String invInviterRelativeShort(String callName, String pronoun);

  /// INV-01 — lời nhắn của người mời
  ///
  /// In vi, this message translates to:
  /// **'“{message}”'**
  String invQuotedMessage(String message);

  /// INV-01 — vai trò (bạn đời)
  ///
  /// In vi, this message translates to:
  /// **'Vai trò của bạn: {callName} của các bé'**
  String invRoleParent(String callName);

  /// INV-01 — vai trò (người thân)
  ///
  /// In vi, this message translates to:
  /// **'{callName} · {permission}'**
  String invRoleRelative(String callName, String permission);

  /// INV-01 — đại từ người được mời (giữa câu)
  ///
  /// In vi, this message translates to:
  /// **'{relation, select, grandmaPaternal{bà} grandmaMaternal{bà} grandpaPaternal{ông} grandpaMaternal{ông} other{bạn}}'**
  String invPronoun(String relation);

  /// INV-01 — đại từ người được mời (đầu câu)
  ///
  /// In vi, this message translates to:
  /// **'{relation, select, grandmaPaternal{Bà} grandmaMaternal{Bà} grandpaPaternal{Ông} grandpaMaternal{Ông} other{Bạn}}'**
  String invPronounTitle(String relation);

  /// INV-01 — quyền (bạn đời)
  ///
  /// In vi, this message translates to:
  /// **'Bạn sẽ thấy: ký ức, nhiệm vụ, Papa & Mama'**
  String get invParentSees;

  /// INV-01 — quyền (bạn đời)
  ///
  /// In vi, this message translates to:
  /// **'Cùng {callName} quản lý gia đình và mời người thân'**
  String invParentManage(String callName);

  /// INV-01 — ghi chú xác nhận (bạn đời)
  ///
  /// In vi, this message translates to:
  /// **'{member} sẽ xác nhận lần cuối khi bạn tham gia'**
  String invParentApproval(String member);

  /// INV-01 — quyền (người thân)
  ///
  /// In vi, this message translates to:
  /// **'{pronoun} sẽ thấy: ảnh, video, những lần đầu của {names}'**
  String invRelativeSees(String pronoun, String names);

  /// INV-01 — phần ẩn (người thân)
  ///
  /// In vi, this message translates to:
  /// **'{pronoun} sẽ không thấy: {names}, Papa & Mama, nhiệm vụ'**
  String invRelativeHiddenChildren(String pronoun, String names);

  /// INV-01 — phần ẩn (người thân)
  ///
  /// In vi, this message translates to:
  /// **'{pronoun} sẽ không thấy: Papa & Mama, nhiệm vụ'**
  String invRelativeHidden(String pronoun);

  /// INV-01 — ghi chú duyệt ảnh (người thân)
  ///
  /// In vi, this message translates to:
  /// **'Ảnh {pronoun} đăng sẽ được Papa/Mama duyệt trước khi hiển thị'**
  String invRelativeApproval(String pronoun);

  /// INV-01 — quyền với bé
  ///
  /// In vi, this message translates to:
  /// **'Chỉ xem'**
  String get invViewOnly;

  /// HOME-01 — lời chào buổi sáng
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi sáng,'**
  String get homeMorning;

  /// HOME-01 — lời chào buổi chiều
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi chiều,'**
  String get homeAfternoon;

  /// HOME-01 — tên người dùng dưới lời chào (Mama Lan 🌙)
  ///
  /// In vi, this message translates to:
  /// **'{callName} {name} {emoji}'**
  String homeGreetingName(String callName, String name, String emoji);

  /// HOME-01 — nhãn thẻ ngày đặc biệt khi là hôm nay
  ///
  /// In vi, this message translates to:
  /// **'HÔM NAY'**
  String get homeMonthlyToday;

  /// HOME-01 — nhãn thẻ ngày đặc biệt khi còn nhiều ngày
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, other{CÒN {count} NGÀY}}'**
  String homeMonthlyInDays(int count);

  /// HOME-01 — tiêu đề thẻ ảnh tháng
  ///
  /// In vi, this message translates to:
  /// **'{name} tròn {months} tháng 🎉'**
  String homeMonthlyTurns(String name, int months);

  /// HOME-01 — mô tả thẻ ảnh tháng
  ///
  /// In vi, this message translates to:
  /// **'Chuẩn bị chụp ảnh tháng — đã có {done}/{total} ảnh'**
  String homeMonthlyPrepare(int done, int total);

  /// HOME-01 — tâm trạng bạn đời (Papa đang mệt)
  ///
  /// In vi, this message translates to:
  /// **'{callName} {mood, select, ok{đang ổn} normal{bình thường} tired{đang mệt} exhausted{kiệt sức} stressed{đang căng thẳng} sad{đang buồn} annoyed{đang bực} overwhelmed{đang quá tải} lonely{thấy cô đơn} missYou{đang nhớ bạn} other{đã check-in}}'**
  String homeMoodTitle(String callName, String mood);

  /// HOME-01 — nhu cầu trong check-in của bạn đời
  ///
  /// In vi, this message translates to:
  /// **'{need, select, rest{Cần nghỉ ngơi} childcare{Cần trông con giúp} quiet{Cần yên tĩnh} hug{Cần một cái ôm} talk{Muốn nói chuyện} encouragement{Cần động viên} other{Cần hỗ trợ}}'**
  String homeNeedLabel(String need);

  /// HOME-01 — nhu cầu kèm thời lượng (Cần yên tĩnh khoảng 20 phút)
  ///
  /// In vi, this message translates to:
  /// **'{need} khoảng {minutes} phút'**
  String homeNeedMinutes(String need, int minutes);

  /// HOME-01 — tiến độ nhiệm vụ cả nhà
  ///
  /// In vi, this message translates to:
  /// **'{done}/{total} việc của nhà mình'**
  String homeFamilyProgress(int done, int total);

  /// HOME-01 — nhãn thẻ gợi ý (viết hoa khi hiển thị)
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý ghi lại · {name} {age}'**
  String homePromptKicker(String name, String age);

  /// HOME-01 — thẻ nhóm ảnh trong Mới trong nhà
  ///
  /// In vi, this message translates to:
  /// **'{callName} vừa thêm {count} ảnh của {name}'**
  String homeFeedAddedPhotos(String callName, int count, String name);

  /// HOME-01 — số ảnh còn lại phủ trên ảnh cuối
  ///
  /// In vi, this message translates to:
  /// **'+{count}'**
  String homeMorePhotos(int count);

  /// HOME-01 — người ghi câu nói (Papa ghi lại tối qua)
  ///
  /// In vi, this message translates to:
  /// **'{callName} ghi lại {time}'**
  String homeRecordedBy(String callName, String time);

  /// HOME-01 — người thả cảm xúc
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =0{{name}} other{{name} và {count} người khác}}'**
  String homeReactedBy(String name, int count);

  /// HOME-01 — người đăng ký ức
  ///
  /// In vi, this message translates to:
  /// **'{callName} đăng'**
  String homePostedBy(String callName);

  /// HOME-01 — trích góc nhìn thứ hai (Cả hai cùng kể)
  ///
  /// In vi, this message translates to:
  /// **'{callName} kể: “{text}”'**
  String homePerspectiveQuote(String callName, String text);

  /// HOME-01 — tiến độ cây gia đình
  ///
  /// In vi, this message translates to:
  /// **'{name} · {percent}% tới {next} 🌸'**
  String homeTreeProgress(String name, int percent, String next);

  /// HOME-02 — tuổi và ngày sinh
  ///
  /// In vi, this message translates to:
  /// **'{age} · sinh {date}'**
  String homeChildBorn(String age, String date);

  /// HOME-02 — tuổi, ngày sinh kèm âm lịch
  ///
  /// In vi, this message translates to:
  /// **'{age} · sinh {date} ({day}/{month} âm lịch)'**
  String homeChildBornLunar(String age, String date, int day, int month);

  /// HOME-02 — đếm ngược tròn tháng
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =0{Hôm nay tròn {months} tháng} other{Còn {count} ngày nữa tròn {months} tháng}}'**
  String homeChildCountdown(int count, int months);

  /// HOME-02 — ô ảnh tháng trong thẻ chương
  ///
  /// In vi, this message translates to:
  /// **'Ảnh tháng {month}'**
  String homeMonthlySlot(int month);

  /// HOME-02 — tên chương hiện tại
  ///
  /// In vi, this message translates to:
  /// **'Tháng thứ {month} của {name}'**
  String homeChapterTitle(int month, String name);

  /// HOME-02 — số liệu chương hiện tại
  ///
  /// In vi, this message translates to:
  /// **'{memories} ký ức · {firsts} lần đầu · {voices} đoạn ghi âm'**
  String homeChapterStats(int memories, int firsts, int voices);

  /// HOME-02 — tiêu đề hàng ảnh tháng
  ///
  /// In vi, this message translates to:
  /// **'Con lớn từng tháng'**
  String get homeMonthlyGrowth;

  /// HOME-03 — tam cá nguyệt (viết hoa khi hiển thị)
  ///
  /// In vi, this message translates to:
  /// **'Tam cá nguyệt {number}'**
  String homeTrimester(int number);

  /// HOME-03 — số ngày tới ngày dự sinh
  ///
  /// In vi, this message translates to:
  /// **'Còn {count} ngày gặp {name} 💜'**
  String homeDaysToMeet(int count, String name);

  /// HOME-03 — ngày dự sinh
  ///
  /// In vi, this message translates to:
  /// **'Dự sinh {date}'**
  String homeDueDate(String date);

  /// HOME-03 — kích thước thai theo tuần
  ///
  /// In vi, this message translates to:
  /// **'Tuần này {name} to cỡ {fruit} · khoảng {cm} cm'**
  String homeFetalSize(String name, String fruit, int cm);

  /// HOME-03 — ghi chú số liệu tham khảo
  ///
  /// In vi, this message translates to:
  /// **'tham khảo'**
  String get homeReference;

  /// HOME-03 — ô chụp ảnh bụng tuần này
  ///
  /// In vi, this message translates to:
  /// **'Chụp'**
  String get homeCapture;

  /// HOME-03 — nhãn tuần ngắn dưới ảnh bụng
  ///
  /// In vi, this message translates to:
  /// **'T{week}'**
  String homeWeekShort(int week);

  /// HOME-03 — nhãn thẻ cả hai cùng kể (viết hoa khi hiển thị)
  ///
  /// In vi, this message translates to:
  /// **'Cả hai cùng kể · Tuần {week}'**
  String homeBothTellWeek(int week);

  /// HOME-03 — tiến độ chuẩn bị đón bé
  ///
  /// In vi, this message translates to:
  /// **'{done}/{total}'**
  String homeProgressCount(int done, int total);

  /// HOME-03 — tóm tắt đặt tên
  ///
  /// In vi, this message translates to:
  /// **'{count} tên dự định · {liked} tên cả hai cùng thích 💞'**
  String homeNamesSummary(int count, int liked);

  /// Nút chọn bé khi đang xem thai kỳ (Bơ · Tuần 24)
  ///
  /// In vi, this message translates to:
  /// **'{name} · Tuần {week}'**
  String switcherPregnancyLabel(String name, int week);

  /// Thời gian tương đối — tối hôm qua
  ///
  /// In vi, this message translates to:
  /// **'tối qua'**
  String get commonLastNight;

  /// Thời gian tương đối — hôm qua (viết thường, giữa câu)
  ///
  /// In vi, this message translates to:
  /// **'hôm qua'**
  String get commonYesterdayLower;

  /// Ghép hai thông tin bằng dấu chấm giữa
  ///
  /// In vi, this message translates to:
  /// **'{first} · {second}'**
  String commonDotJoin(String first, String second);

  /// Ghép hai tên bé (Hana & Haru)
  ///
  /// In vi, this message translates to:
  /// **'{first} & {second}'**
  String commonNamesAnd(String first, String second);

  /// Nhóm nhiệm vụ (mục 7.13.1)
  ///
  /// In vi, this message translates to:
  /// **'{category, select, care{Chăm sóc} bonding{Gắn kết} outing{Đi chơi} memory{Ký ức} support{Hỗ trợ} self{Tự chăm} together{Cùng nhau} couple{Hai ta} custom{Tự tạo} other{Nhiệm vụ}}'**
  String commonMissionCategory(String category);

  /// Nhãn nhiệm vụ hệ thống gợi ý
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý hôm nay'**
  String get commonSuggestedToday;

  /// Số Hearts của nhiệm vụ
  ///
  /// In vi, this message translates to:
  /// **'+{count} 💗'**
  String commonHeartsPlus(int count);

  /// MEM — thời gian tương đối
  ///
  /// In vi, this message translates to:
  /// **'Vừa xong'**
  String get memJustNow;

  /// MEM — x phút trước
  ///
  /// In vi, this message translates to:
  /// **'{count} phút trước'**
  String memMinutesAgo(int count);

  /// MEM — x giờ trước
  ///
  /// In vi, this message translates to:
  /// **'{count} giờ trước'**
  String memHoursAgo(int count);

  /// MEM — hôm qua
  ///
  /// In vi, this message translates to:
  /// **'Hôm qua'**
  String get memYesterday;

  /// MEM-23 — “· hôm nay”
  ///
  /// In vi, this message translates to:
  /// **'hôm nay'**
  String get memTodayLower;

  /// MEM-05/07 — Hôm nay, 07/10 hoặc 19:05
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay, {time}'**
  String memTodayAt(String time);

  /// MEM-07 — Hôm qua, 19:05
  ///
  /// In vi, this message translates to:
  /// **'Hôm qua, {time}'**
  String memYesterdayAt(String time);

  /// MEM-07 — 05/10, 19:05
  ///
  /// In vi, this message translates to:
  /// **'{date}, {time}'**
  String memDateAt(String date, String time);

  /// MEM-01 — nút tìm kiếm (semantics)
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm ký ức'**
  String get memSearch;

  /// MEM-01 — chip lọc Ghi âm; MEM-24 ô Ghi âm
  ///
  /// In vi, this message translates to:
  /// **'Ghi âm'**
  String get memFilterVoice;

  /// MEM-01 — header bé
  ///
  /// In vi, this message translates to:
  /// **'{memories} ký ức · {firsts} lần đầu · {voices} đoạn ghi âm'**
  String memChildStats(int memories, int firsts, int voices);

  /// MEM-01 — khoảng ngày chương tháng
  ///
  /// In vi, this message translates to:
  /// **'{start} – {end}'**
  String memChapterRange(String start, String end);

  /// MEM-01 — chương tháng hiện tại
  ///
  /// In vi, this message translates to:
  /// **'{range} · ĐANG DIỄN RA'**
  String memChapterCurrent(String range);

  /// MEM-01 — tiêu đề chương tháng
  ///
  /// In vi, this message translates to:
  /// **'Tháng thứ {month} của {name}'**
  String memChapterTitle(int month, String name);

  /// MEM-01 — số liệu chương tháng
  ///
  /// In vi, this message translates to:
  /// **'{memories} ký ức · {firsts} lần đầu · {voices} ghi âm'**
  String memChapterStats(int memories, int firsts, int voices);

  /// MEM-01 — chương tháng đã có ảnh tháng
  ///
  /// In vi, this message translates to:
  /// **'{memories} ký ức · {firsts} lần đầu · ảnh tháng ✓'**
  String memChapterStatsMonthly(int memories, int firsts);

  /// MEM-01 — Xem lại tháng này
  ///
  /// In vi, this message translates to:
  /// **'Xem lại tháng này'**
  String get memChapterReplay;

  /// MEM-01 — bìa chương: ngày chụp ảnh tháng
  ///
  /// In vi, this message translates to:
  /// **'{days, plural, =0{Hôm nay} =1{Ngày mai} other{Còn {days} ngày}}'**
  String memDueIn(int days);

  /// MEM-20 — ô ảnh tháng sắp tới
  ///
  /// In vi, this message translates to:
  /// **'{days, plural, =0{Tháng {month} · hôm nay} =1{Tháng {month} · ngày mai} other{Tháng {month} · còn {days} ngày}}'**
  String memMonthlyNextIn(int days, int month);

  /// MEM-01 — meta thẻ ký ức
  ///
  /// In vi, this message translates to:
  /// **'{children} · {author} đăng · {time}'**
  String memCardMeta(String children, String author, String time);

  /// MEM-01 — trích góc nhìn thứ hai
  ///
  /// In vi, this message translates to:
  /// **'{callName} kể: “{text}”'**
  String memBothTellPreview(String callName, String text);

  /// MEM-01 — thẻ kỷ vật: câu chuyện + người kể
  ///
  /// In vi, this message translates to:
  /// **'“{body}” · {author}'**
  String memQuotedBy(String body, String author);

  /// MEM-01 — nhãn thẻ cột mốc (viết hoa khi hiển thị)
  ///
  /// In vi, this message translates to:
  /// **'Lần đầu tiên'**
  String get memFirstTime;

  /// MEM-01 — meta thẻ cột mốc
  ///
  /// In vi, this message translates to:
  /// **'{age} · {who}'**
  String memFirstMeta(String age, String who);

  /// MEM-01 — Papa & Mama cùng kể
  ///
  /// In vi, this message translates to:
  /// **'{first} & {second} cùng kể'**
  String memBothParentsTell(String first, String second);

  /// MEM-01/07 — “Papa kể”
  ///
  /// In vi, this message translates to:
  /// **'{callName} kể'**
  String memAuthorTells(String callName);

  /// MEM-01 — meta thẻ câu nói
  ///
  /// In vi, this message translates to:
  /// **'{name} · {age} · {callName} ghi lại {when}'**
  String memQuoteMeta(String name, String age, String callName, String when);

  /// MEM-01 — thẻ thư niêm phong
  ///
  /// In vi, this message translates to:
  /// **'Niêm phong tới {date}'**
  String memLetterSealed(String date);

  /// MEM-22 — Con lớn từng tháng
  ///
  /// In vi, this message translates to:
  /// **'{name} · {count}/{total} ảnh'**
  String memCollMonthly(String name, int count, int total);

  /// MEM-22 — Con lớn từng tháng khi chưa có bé đã chào đời (không có tên bé)
  ///
  /// In vi, this message translates to:
  /// **'{count}/{total} ảnh'**
  String memCollMonthlyCount(int count, int total);

  /// MEM-22 — Những lần đầu
  ///
  /// In vi, this message translates to:
  /// **'{count} cột mốc'**
  String memCollFirsts(int count);

  /// MEM-22 — Câu nói của con
  ///
  /// In vi, this message translates to:
  /// **'{name} · {count} câu'**
  String memCollQuotes(String name, int count);

  /// MEM-22 — Câu nói của con khi chưa có câu nói gắn với bé (không có tên bé)
  ///
  /// In vi, this message translates to:
  /// **'{count} câu'**
  String memCollQuotesCount(int count);

  /// MEM-22 — Giọng nói
  ///
  /// In vi, this message translates to:
  /// **'{count} đoạn ghi âm'**
  String memCollVoices(int count);

  /// MEM-22 — Thư gửi con
  ///
  /// In vi, this message translates to:
  /// **'{count} thư · {sealed} niêm phong'**
  String memCollLetters(int count, int sealed);

  /// MEM-22 — Ảnh đẹp nhất nhà mình
  ///
  /// In vi, this message translates to:
  /// **'Cả hai cùng thích · {count}'**
  String memCollBest(int count);

  /// MEM-22 — Kỷ vật
  ///
  /// In vi, this message translates to:
  /// **'{count} đồ vật'**
  String memCollKeepsakes(int count);

  /// MEM-13 — tiêu đề
  ///
  /// In vi, this message translates to:
  /// **'Viết nhật ký'**
  String get memComposerDiary;

  /// MEM-05 (cột mốc) — tiêu đề
  ///
  /// In vi, this message translates to:
  /// **'Ghi cột mốc'**
  String get memComposerMilestone;

  /// MEM-05 (ghi âm) — tiêu đề
  ///
  /// In vi, this message translates to:
  /// **'Ghi âm mới'**
  String get memComposerVoice;

  /// MEM-05 (kỷ vật) — tiêu đề
  ///
  /// In vi, this message translates to:
  /// **'Kỷ vật mới'**
  String get memComposerKeepsake;

  /// MEM-05 (ảnh tháng) — tiêu đề; MEM-21 tiêu đề camera
  ///
  /// In vi, this message translates to:
  /// **'Ảnh tháng {month} · {name}'**
  String memComposerMonthly(int month, String name);

  /// MEM-05 — Ai thấy
  ///
  /// In vi, this message translates to:
  /// **'Cả nhà · {count} người thân'**
  String memAudienceRelatives(int count);

  /// MEM-23/24 — Ai thấy
  ///
  /// In vi, this message translates to:
  /// **'Cả nhà · {count} người'**
  String memAudiencePeople(int count);

  /// MEM-05 — giá trị trống dòng cột mốc
  ///
  /// In vi, this message translates to:
  /// **'Chọn cột mốc'**
  String get memChooseMilestone;

  /// MEM-13 — gợi ý tiêu đề
  ///
  /// In vi, this message translates to:
  /// **'Tiêu đề trang nhật ký'**
  String get memDiaryTitleHint;

  /// MEM-13 — gợi ý nội dung
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay nhà mình thế nào?'**
  String get memDiaryBodyHint;

  /// MEM-14 — người nhận
  ///
  /// In vi, this message translates to:
  /// **'Gửi tới'**
  String get memLetterTo;

  /// MEM-14 — gợi ý nội dung thư
  ///
  /// In vi, this message translates to:
  /// **'Con yêu, bố mẹ muốn kể con nghe…'**
  String get memLetterBodyHint;

  /// MEM-14 — Hẹn ngày mở
  ///
  /// In vi, this message translates to:
  /// **'Hẹn ngày mở'**
  String get memLetterOpenDate;

  /// MEM-14 — không hẹn ngày mở
  ///
  /// In vi, this message translates to:
  /// **'Không'**
  String get memLetterOpenNone;

  /// MEM-05 (ghi âm) — nút ghi
  ///
  /// In vi, this message translates to:
  /// **'Chạm để ghi âm'**
  String get memVoiceTapToRecord;

  /// MEM-05 (ghi âm) — đã ghi
  ///
  /// In vi, this message translates to:
  /// **'Đã ghi âm · {duration}'**
  String memVoiceRecorded(String duration);

  /// MEM-04 ghi âm
  ///
  /// In vi, this message translates to:
  /// **'Đang ghi… chạm để dừng'**
  String get memVoiceRecording;

  /// MEM-04 ghi âm
  ///
  /// In vi, this message translates to:
  /// **'Cần quyền micro để ghi âm — bật trong Cài đặt của máy'**
  String get memVoiceMicDenied;

  /// MEM-05 nâng cao: ai ở đó, cảm xúc, địa điểm
  ///
  /// In vi, this message translates to:
  /// **'Ai ở đó'**
  String get memPeopleLabel;

  /// MEM-05 nâng cao: ai ở đó, cảm xúc, địa điểm
  ///
  /// In vi, this message translates to:
  /// **'Chọn người'**
  String get memPeopleChoose;

  /// MEM-05 nâng cao: ai ở đó, cảm xúc, địa điểm
  ///
  /// In vi, this message translates to:
  /// **'Thêm tên'**
  String get memPeopleAddName;

  /// MEM-05 nâng cao: ai ở đó, cảm xúc, địa điểm
  ///
  /// In vi, this message translates to:
  /// **'Cảm xúc của khoảnh khắc'**
  String get memFeelingLabel;

  /// MEM-05 nâng cao: ai ở đó, cảm xúc, địa điểm
  ///
  /// In vi, this message translates to:
  /// **'Chọn cảm xúc'**
  String get memFeelingChoose;

  /// MEM-05 nâng cao: ai ở đó, cảm xúc, địa điểm
  ///
  /// In vi, this message translates to:
  /// **'Không chọn'**
  String get memFeelingNone;

  /// MEM-05 nâng cao: ai ở đó, cảm xúc, địa điểm
  ///
  /// In vi, this message translates to:
  /// **'{feeling, select, love{Thương yêu} joy{Vui vẻ} touched{Xúc động} surprised{Bất ngờ} peaceful{Bình yên} proud{Tự hào} other{{feeling}}}'**
  String memFeeling(String feeling);

  /// MEM-05 nâng cao: ai ở đó, cảm xúc, địa điểm
  ///
  /// In vi, this message translates to:
  /// **'Địa điểm'**
  String get memLocationLabel;

  /// MEM-05 nâng cao: ai ở đó, cảm xúc, địa điểm
  ///
  /// In vi, this message translates to:
  /// **'Thêm địa điểm'**
  String get memLocationAdd;

  /// MEM-05 nâng cao: ai ở đó, cảm xúc, địa điểm
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ: Nhà bà nội, Biển Vũng Tàu'**
  String get memLocationHint;

  /// MEM-05 (kỷ vật) — gợi ý tên
  ///
  /// In vi, this message translates to:
  /// **'Tên kỷ vật'**
  String get memKeepsakeTitleHint;

  /// MEM-05 (kỷ vật) — gợi ý câu chuyện
  ///
  /// In vi, this message translates to:
  /// **'Câu chuyện của món đồ này…'**
  String get memKeepsakeHint;

  /// MEM-07 — visibility
  ///
  /// In vi, this message translates to:
  /// **'👨‍👩‍👧‍👦 Cả nhà'**
  String get memVisibilityFamilyTag;

  /// MEM-07 — visibility
  ///
  /// In vi, this message translates to:
  /// **'👫 Chỉ Papa & Mama'**
  String get memVisibilityParentsTag;

  /// MEM-07 — visibility
  ///
  /// In vi, this message translates to:
  /// **'🔒 Chỉ mình tôi'**
  String get memVisibilityOnlyMeTag;

  /// MEM-07 — dòng phụ khối Papa kể
  ///
  /// In vi, this message translates to:
  /// **'Góc nhìn thứ hai · {time}'**
  String memSecondPerspective(String time);

  /// MEM-07 — tiêu đề bình luận
  ///
  /// In vi, this message translates to:
  /// **'Bình luận ({count})'**
  String memCommentsCount(int count);

  /// MEM-07 — menu
  ///
  /// In vi, this message translates to:
  /// **'Yêu thích'**
  String get memMenuFavorite;

  /// MEM-07 — menu
  ///
  /// In vi, this message translates to:
  /// **'Bỏ yêu thích'**
  String get memMenuUnfavorite;

  /// MEM-07 — menu
  ///
  /// In vi, this message translates to:
  /// **'Sửa góc nhìn của bạn'**
  String get memEditPerspective;

  /// MEM-07 — nút ⋯ (semantics)
  ///
  /// In vi, this message translates to:
  /// **'Thêm thao tác'**
  String get memMoreActions;

  /// MEM-20 — chip Thai kỳ
  ///
  /// In vi, this message translates to:
  /// **'Thai kỳ'**
  String get memPregnancyAlbum;

  /// MEM-20 — ô tháng trống
  ///
  /// In vi, this message translates to:
  /// **'Tháng {month}'**
  String memMonthCell(int month);

  /// MEM-21 — bóng mờ
  ///
  /// In vi, this message translates to:
  /// **'Bóng mờ tháng {month} · {percent}%'**
  String memGhostToggle(int month, int percent);

  /// MEM-21 — không sticker
  ///
  /// In vi, this message translates to:
  /// **'Không'**
  String get memStickerNone;

  /// MEM-21 — semantics
  ///
  /// In vi, this message translates to:
  /// **'Đổi camera'**
  String get memFlipCamera;

  /// MEM-21 — semantics
  ///
  /// In vi, this message translates to:
  /// **'Độ sáng'**
  String get memBrightness;

  /// MEM-23 — dòng tuổi
  ///
  /// In vi, this message translates to:
  /// **'— {name}, {age} · {when}'**
  String memQuoteAge(String name, String age, String when);

  /// MEM-23 — nhãn ngữ cảnh
  ///
  /// In vi, this message translates to:
  /// **'Con nói khi nào? (tuỳ chọn)'**
  String get memQuoteContextLabel;

  /// MEM-23 — gợi ý ngữ cảnh
  ///
  /// In vi, this message translates to:
  /// **'Lúc đi dạo buổi tối, nhìn lên trời'**
  String get memQuoteContextHint;

  /// MEM-24 — nhãn ký ức gốc (viết hoa)
  ///
  /// In vi, this message translates to:
  /// **'{callName} kể · {when}'**
  String memOriginalTag(String callName, String when);

  /// MEM-24 — thông tin người xem
  ///
  /// In vi, this message translates to:
  /// **'Người xem giống ký ức gốc: {audience}'**
  String memInheritedAudience(String audience);

  /// MEM-25 — dòng phụ
  ///
  /// In vi, this message translates to:
  /// **'{callName} đăng · {time} · {index}/{total}'**
  String memStoryMeta(String callName, String time, int index, int total);

  /// MEM-25 — ô trả lời
  ///
  /// In vi, this message translates to:
  /// **'Trả lời {callName}…'**
  String memStoryReply(String callName);

  /// MEM-12 — tiêu đề
  ///
  /// In vi, this message translates to:
  /// **'Những lần đầu'**
  String get memFirstsTitle;

  /// MEM-12 — công tắc
  ///
  /// In vi, this message translates to:
  /// **'Ẩn cột mốc chưa có'**
  String get memFirstsHideMissing;

  /// MEM-12 — ô chưa có
  ///
  /// In vi, this message translates to:
  /// **'Chạm để ghi lại'**
  String get memFirstsAdd;

  /// HOME-01 — nút avatar gia đình (a11y)
  ///
  /// In vi, this message translates to:
  /// **'Gia đình mình'**
  String get homeOpenFamily;

  /// HOME-02 — nút đổi ảnh bìa (a11y)
  ///
  /// In vi, this message translates to:
  /// **'Đổi ảnh bìa'**
  String get homeChangeCover;

  /// AUTH-03 — snackbar sau khi gửi lại mã
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi lại mã'**
  String get authCodeResent;

  /// Tên năm âm lịch (can chi), ví dụ Ất Tỵ — truyền chỉ số từ lunarYearCanChi()
  ///
  /// In vi, this message translates to:
  /// **'{stem, select, 0{Giáp} 1{Ất} 2{Bính} 3{Đinh} 4{Mậu} 5{Kỷ} 6{Canh} 7{Tân} 8{Nhâm} 9{Quý} other{}} {branch, select, 0{Tý} 1{Sửu} 2{Dần} 3{Mão} 4{Thìn} 5{Tỵ} 6{Ngọ} 7{Mùi} 8{Thân} 9{Dậu} 10{Tuất} 11{Hợi} other{}}'**
  String commonLunarYear(String stem, String branch);

  /// Ngày âm lịch đầy đủ (CARE-07 “27/8 âm lịch”)
  ///
  /// In vi, this message translates to:
  /// **'{day}/{month} âm lịch'**
  String commonLunarDate(int day, int month);

  /// Tuổi bé 0–13 ngày (mục 7.3 “5 ngày tuổi”)
  ///
  /// In vi, this message translates to:
  /// **'{days} ngày tuổi'**
  String commonAgeDaysOld(int days);

  /// Tuổi bé 2–12 tuần, tròn tuần
  ///
  /// In vi, this message translates to:
  /// **'{weeks} tuần'**
  String commonAgeWeeks(int weeks);

  /// Tuổi bé 2–12 tuần (mục 7.3 “6 tuần 3 ngày”)
  ///
  /// In vi, this message translates to:
  /// **'{weeks} tuần {days} ngày'**
  String commonAgeWeeksDays(int weeks, int days);

  /// MEM-03a — tiêu đề tạm/semantics
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết album'**
  String get memAlbumDetailTitle;

  /// MEM-08 — tiêu đề tạm/semantics
  ///
  /// In vi, this message translates to:
  /// **'Xem ảnh'**
  String get memPhotoViewerTitle;

  /// MEM-08 phát video
  ///
  /// In vi, this message translates to:
  /// **'Phát video'**
  String get memVideoPlay;

  /// MEM-08 tạm dừng video
  ///
  /// In vi, this message translates to:
  /// **'Tạm dừng video'**
  String get memVideoPause;

  /// MEM-15
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm'**
  String get memSearchTitle;

  /// MEM-16
  ///
  /// In vi, this message translates to:
  /// **'Ngày này năm xưa'**
  String get memOnThisDayTitle;

  /// REC-02
  ///
  /// In vi, this message translates to:
  /// **'Tuần của nhà mình'**
  String get recapWeekTitle;

  /// REC-02: tiêu đề recap tuần từ server
  ///
  /// In vi, this message translates to:
  /// **'{moments, plural, =0{Một tuần bình yên} other{{moments} khoảnh khắc}}{firsts, plural, =0{} other{ · {firsts} lần đầu}}'**
  String recapWeekHeadline(int moments, int firsts);

  /// CARE-07
  ///
  /// In vi, this message translates to:
  /// **'Lịch'**
  String get calendarTitle;

  /// CAL-02
  ///
  /// In vi, this message translates to:
  /// **'Tạo sự kiện'**
  String get calendarCreateEvent;

  /// CARE-08
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử'**
  String get careHistoryTitle;

  /// CARE-10
  ///
  /// In vi, this message translates to:
  /// **'Huy hiệu của nhà mình'**
  String get careBadgesTitle;

  /// CARE-12
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt nhiệm vụ'**
  String get careSettingsTitle;

  /// CHD-01
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ bé'**
  String get childProfileTitle;

  /// CHD-02
  ///
  /// In vi, this message translates to:
  /// **'Sửa hồ sơ bé'**
  String get childEditTitle;

  /// CHD-04
  ///
  /// In vi, this message translates to:
  /// **'Thêm bé'**
  String get childAddTitle;

  /// FAM-04
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết người thân'**
  String get familyRelativeDetailTitle;

  /// FAM-07
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt gia đình'**
  String get familySettingsTitle;

  /// SET-02
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ'**
  String get settingsProfileTitle;

  /// MEM-20 — chip năm của ảnh tháng (story v2: Haru ở năm thứ hai)
  ///
  /// In vi, this message translates to:
  /// **'{year, select, 1{Năm đầu tiên} 2{Năm thứ hai} 3{Năm thứ ba} other{Năm thứ {year}}}'**
  String memoriesYearOrdinal(String year);

  /// Thứ trong tuần viết hoa (CARE-07, CARE-08, CHD-01)
  ///
  /// In vi, this message translates to:
  /// **'{day, select, mon{Thứ Hai} tue{Thứ Ba} wed{Thứ Tư} thu{Thứ Năm} fri{Thứ Sáu} sat{Thứ Bảy} other{Chủ Nhật}}'**
  String careWeekdayTitle(String day);

  /// Thứ, ngày (Thứ Tư, 07/10)
  ///
  /// In vi, this message translates to:
  /// **'{weekday}, {date}'**
  String calendarDayTitle(String weekday, String date);

  /// CARE-07 tiêu đề tháng
  ///
  /// In vi, this message translates to:
  /// **'Tháng {month}, {year}'**
  String calendarMonthYear(String month, String year);

  /// CARE-07 chế độ tuần
  ///
  /// In vi, this message translates to:
  /// **'Tuần'**
  String get calendarModeWeek;

  /// CARE-07 chế độ tháng
  ///
  /// In vi, this message translates to:
  /// **'Tháng'**
  String get calendarModeMonth;

  /// CARE-07 chú thích chấm
  ///
  /// In vi, this message translates to:
  /// **'Nhiệm vụ'**
  String get calendarLegendMission;

  /// CARE-07 chú thích chấm
  ///
  /// In vi, this message translates to:
  /// **'Sự kiện'**
  String get calendarLegendEvent;

  /// CARE-07 chú thích chấm
  ///
  /// In vi, this message translates to:
  /// **'Hai ta'**
  String get calendarLegendCouple;

  /// CARE-07 công tắc âm lịch
  ///
  /// In vi, this message translates to:
  /// **'Âm lịch'**
  String get calendarLunar;

  /// Ngày mùng 1 âm lịch dưới ô ngày (1/9)
  ///
  /// In vi, this message translates to:
  /// **'{day}/{month}'**
  String calendarLunarShort(String day, String month);

  /// CARE-07 nhãn hôm nay
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get calendarToday;

  /// CARE-07 số mục trong ngày
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, other{{count} mục}}'**
  String calendarItemCount(int count);

  /// Sự kiện cả ngày
  ///
  /// In vi, this message translates to:
  /// **'Cả ngày'**
  String get calendarAllDay;

  /// CARE-07 loại mục
  ///
  /// In vi, this message translates to:
  /// **'{kind, select, family{Sự kiện gia đình} child{Sự kiện của bé} couple{Hẹn hai ta} anniversary{Nhắc kỷ niệm} health{Ghi chú khám/tiêm} other{Nhiệm vụ}}'**
  String calendarKindLabel(String kind);

  /// CARE-07 người làm nhiệm vụ
  ///
  /// In vi, this message translates to:
  /// **'{owner, select, me{của tôi} together{cùng nhau} other{của {callName}}}'**
  String calendarOwnerLabel(String owner, String callName);

  /// CARE-07 mục hai ta
  ///
  /// In vi, this message translates to:
  /// **'Chỉ hai bạn thấy'**
  String get calendarCoupleOnly;

  /// CARE-07 ngày trống
  ///
  /// In vi, this message translates to:
  /// **'Ngày này chưa có gì. Thêm một sự kiện hay nhiệm vụ nhé?'**
  String get calendarEmptyDay;

  /// CARE-07 FAB thêm sự kiện
  ///
  /// In vi, this message translates to:
  /// **'Sự kiện'**
  String get calendarAddEvent;

  /// CARE-07 FAB thêm nhiệm vụ
  ///
  /// In vi, this message translates to:
  /// **'Nhiệm vụ'**
  String get calendarAddMission;

  /// CARE-07 FAB mở menu
  ///
  /// In vi, this message translates to:
  /// **'Thêm vào lịch'**
  String get calendarAddMenu;

  /// Tooltip
  ///
  /// In vi, this message translates to:
  /// **'Tháng trước'**
  String get calendarPrevMonth;

  /// Tooltip
  ///
  /// In vi, this message translates to:
  /// **'Tháng sau'**
  String get calendarNextMonth;

  /// CAL-02
  ///
  /// In vi, this message translates to:
  /// **'Loại sự kiện'**
  String get calendarEventType;

  /// CAL-02 chip loại
  ///
  /// In vi, this message translates to:
  /// **'{kind, select, child{Của bé} family{Gia đình} couple{Hai ta} anniversary{Nhắc kỷ niệm} other{Ghi chú khám/tiêm}}'**
  String calendarEventKind(String kind);

  /// CAL-02 gợi ý quyền xem
  ///
  /// In vi, this message translates to:
  /// **'Bố Mẹ luôn thấy. Người thân chỉ thấy khi bạn chọn “Mời cả nhà”.'**
  String get calendarEventTypeHint;

  /// CAL-02
  ///
  /// In vi, this message translates to:
  /// **'Ngày'**
  String get calendarDate;

  /// CAL-02
  ///
  /// In vi, this message translates to:
  /// **'Dùng ngày Âm lịch'**
  String get calendarUseLunar;

  /// CAL-02 ngày âm
  ///
  /// In vi, this message translates to:
  /// **'{day, select, 15{Rằm tháng {month} âm lịch} 1{Mùng 1 tháng {month} âm lịch} other{Ngày {day} tháng {month} âm lịch}}'**
  String calendarLunarDayName(String day, String month);

  /// CAL-02 ngày dương năm nay
  ///
  /// In vi, this message translates to:
  /// **'Năm nay: {date}'**
  String calendarThisYear(String date);

  /// CAL-02
  ///
  /// In vi, this message translates to:
  /// **'Lặp lại hằng năm'**
  String get calendarRepeatYearly;

  /// CAL-02
  ///
  /// In vi, this message translates to:
  /// **'Theo ngày âm lịch'**
  String get calendarRepeatByLunar;

  /// CAL-02
  ///
  /// In vi, this message translates to:
  /// **'Theo ngày dương lịch'**
  String get calendarRepeatBySolar;

  /// CAL-02
  ///
  /// In vi, this message translates to:
  /// **'Giờ'**
  String get calendarTime;

  /// CAL-02
  ///
  /// In vi, this message translates to:
  /// **'Bé liên quan (tuỳ chọn)'**
  String get calendarRelatedChildren;

  /// CAL-02
  ///
  /// In vi, this message translates to:
  /// **'Người tham gia'**
  String get calendarParticipants;

  /// CAL-02
  ///
  /// In vi, this message translates to:
  /// **'Mời cả nhà'**
  String get calendarInviteFamily;

  /// CAL-02 nhãn gói
  ///
  /// In vi, this message translates to:
  /// **'Gói Family'**
  String get calendarFamilyPlanTag;

  /// CAL-02
  ///
  /// In vi, this message translates to:
  /// **'Ông bà, người thân cũng thấy sự kiện này'**
  String get calendarInviteFamilyHint;

  /// CAL-02
  ///
  /// In vi, this message translates to:
  /// **'Nhắc'**
  String get calendarReminders;

  /// CAL-02 lựa chọn nhắc
  ///
  /// In vi, this message translates to:
  /// **'{code, select, dayBefore0900{Trước 1 ngày, 9:00} morning{Sáng hôm đó} atTime{Đúng giờ} hourBefore{Trước 1 giờ} other{Trước 1 tuần}}'**
  String calendarReminder(String code);

  /// CAL-02 thêm nhắc
  ///
  /// In vi, this message translates to:
  /// **'Thêm'**
  String get calendarAddReminder;

  /// CAL-02
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú'**
  String get calendarNote;

  /// CAL-02 gợi ý ghi chú
  ///
  /// In vi, this message translates to:
  /// **'Thêm ghi chú…'**
  String get calendarNoteHint;

  /// CAL-02
  ///
  /// In vi, this message translates to:
  /// **'Lưu sự kiện'**
  String get calendarSaveEvent;

  /// CAL-02 snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu sự kiện'**
  String get calendarEventSaved;

  /// CARE-08 bộ lọc
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get careHistoryAll;

  /// CARE-08 bộ lọc loại
  ///
  /// In vi, this message translates to:
  /// **'Loại'**
  String get careHistoryCategory;

  /// CARE-08 chú thích
  ///
  /// In vi, this message translates to:
  /// **'Của tôi'**
  String get careHistoryLegendMine;

  /// CARE-08 chú thích
  ///
  /// In vi, this message translates to:
  /// **'Của {callName} (đã xong)'**
  String careHistoryLegendPartner(String callName);

  /// CARE-08 đầu ngày
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay · {date}'**
  String careHistoryToday(String date);

  /// CARE-08 đầu ngày
  ///
  /// In vi, this message translates to:
  /// **'Hôm qua · {date}'**
  String careHistoryYesterday(String date);

  /// CARE-08 thứ + ngày (Thứ Tư 07/10)
  ///
  /// In vi, this message translates to:
  /// **'{weekday} {date}'**
  String careHistoryDate(String weekday, String date);

  /// CARE-08 ngày âm
  ///
  /// In vi, this message translates to:
  /// **'{day}/{month} âm'**
  String careHistoryLunar(String day, String month);

  /// CARE-08
  ///
  /// In vi, this message translates to:
  /// **'{callName} · đã xong'**
  String careHistoryPartnerDone(String callName);

  /// CARE-08
  ///
  /// In vi, this message translates to:
  /// **'{couple, select, yes{Hai ta} other{Cùng nhau}} · đã xong {time}'**
  String careHistoryTogetherDone(String couple, String time);

  /// CARE-08 việc cùng nhau chưa làm (trung tính)
  ///
  /// In vi, this message translates to:
  /// **'{couple, select, yes{Hai ta} other{Cùng nhau}} · Không kịp làm'**
  String careHistoryTogetherMissed(String couple);

  /// CARE-08 nhiệm vụ hết hạn (trung tính)
  ///
  /// In vi, this message translates to:
  /// **'Không kịp làm'**
  String get careHistoryMissed;

  /// CARE-08 ghi chú
  ///
  /// In vi, this message translates to:
  /// **'Hearts chỉ hiện trên việc của bạn. Việc của {callName} chỉ hiện khi đã xong.'**
  String careHistoryNote(String callName);

  /// CARE-08 trống
  ///
  /// In vi, this message translates to:
  /// **'Chưa có việc nào trong lịch sử'**
  String get careHistoryEmpty;

  /// Tên loại nhiệm vụ (CARE-08)
  ///
  /// In vi, this message translates to:
  /// **'{category, select, care{Chăm sóc} bonding{Gắn kết} play{Vui chơi} outing{Ra ngoài} memory{Lưu kỷ niệm} support{Hỗ trợ bạn đời} self{Chăm bản thân} chores{Việc nhà của bé} other{Khác}}'**
  String careCategoryName(String category);

  /// CARE-10
  ///
  /// In vi, this message translates to:
  /// **'Ghi nhận những thói quen đẹp cả nhà cùng làm — không so sánh, không chấm điểm ai.'**
  String get careBadgesSubtitle;

  /// CARE-10
  ///
  /// In vi, this message translates to:
  /// **'Đã mở {done} / {total} huy hiệu'**
  String careBadgesUnlocked(int done, int total);

  /// CARE-10
  ///
  /// In vi, this message translates to:
  /// **'Gần nhất: {title} · {date}'**
  String careBadgesLatest(String title, String date);

  /// CARE-10 nhóm
  ///
  /// In vi, this message translates to:
  /// **'Đã đạt'**
  String get careBadgesEarned;

  /// CARE-10 nhóm
  ///
  /// In vi, this message translates to:
  /// **'Sắp mở'**
  String get careBadgesUpcoming;

  /// CARE-10
  ///
  /// In vi, this message translates to:
  /// **'Đạt {date}'**
  String careBadgeAchievedOn(String date);

  /// CARE-12
  ///
  /// In vi, this message translates to:
  /// **'Mức nhiệm vụ hằng ngày của cả nhà'**
  String get careSettingsLevelSection;

  /// CARE-12 mức
  ///
  /// In vi, this message translates to:
  /// **'{level, select, light{Nhẹ} medium{Vừa} other{Nhiều}}'**
  String careSettingsLevel(String level);

  /// CARE-12
  ///
  /// In vi, this message translates to:
  /// **'việc / người'**
  String get careSettingsPerPerson;

  /// CARE-12
  ///
  /// In vi, this message translates to:
  /// **'{level, select, light{0–1 việc cùng nhau} other{1 việc cùng nhau}}'**
  String careSettingsTogether(String level);

  /// CARE-12 nhãn
  ///
  /// In vi, this message translates to:
  /// **'Mặc định'**
  String get careSettingsDefault;

  /// CARE-12
  ///
  /// In vi, this message translates to:
  /// **'Áp dụng cho cả {partner} và {me} — hai bảng luôn bằng nhau. {partner} sẽ nhận một thông báo nhẹ khi bạn đổi.'**
  String careSettingsLevelNote(String partner, String me);

  /// CARE-12
  ///
  /// In vi, this message translates to:
  /// **'Loại việc tôi muốn nhận'**
  String get careSettingsCategoriesSection;

  /// CARE-12
  ///
  /// In vi, this message translates to:
  /// **'Tắt bớt loại nào, bảng vẫn đủ số việc từ những loại còn lại. Chỉ áp dụng cho bảng của bạn.'**
  String get careSettingsCategoriesHint;

  /// CARE-12
  ///
  /// In vi, this message translates to:
  /// **'Giờ giấc & nhắc'**
  String get careSettingsTimingSection;

  /// CARE-12
  ///
  /// In vi, this message translates to:
  /// **'Giờ nhận bảng nhiệm vụ'**
  String get careSettingsBoardTime;

  /// CARE-12
  ///
  /// In vi, this message translates to:
  /// **'Thông báo “Hôm nay bạn có {count} việc nhỏ…”'**
  String careSettingsBoardTimeHint(int count);

  /// CARE-12
  ///
  /// In vi, this message translates to:
  /// **'Hỏi lúc {time}'**
  String careSettingsAskAtNight(String time);

  /// CARE-12
  ///
  /// In vi, this message translates to:
  /// **'Việc tự thêm chưa xong — chuyển sang ngày mai?'**
  String get careSettingsAskAtNightHint;

  /// CARE-12
  ///
  /// In vi, this message translates to:
  /// **'Nhắc mặc định'**
  String get careSettingsDefaultReminder;

  /// CARE-12
  ///
  /// In vi, this message translates to:
  /// **'Cho việc có giờ do bạn đặt'**
  String get careSettingsDefaultReminderHint;

  /// CARE-12 giá trị nhắc ngắn
  ///
  /// In vi, this message translates to:
  /// **'{reminder, select, atTime{Đúng giờ} before15{Trước 15′} before30{Trước 30′} before60{Trước 1 giờ} other{Không nhắc}}'**
  String careReminderShort(String reminder);

  /// CARE-03 chuỗi lặp lại (mục 7.13.6)
  ///
  /// In vi, this message translates to:
  /// **'Chuỗi lặp lại'**
  String get careSeriesSection;

  /// CARE-03 chuỗi lặp lại (mục 7.13.6)
  ///
  /// In vi, this message translates to:
  /// **'Hằng ngày'**
  String get careSeriesDaily;

  /// CARE-03 chuỗi lặp lại (mục 7.13.6)
  ///
  /// In vi, this message translates to:
  /// **'Tạm dừng tới {date}'**
  String careSeriesPausedUntil(String date);

  /// CARE-03 chuỗi lặp lại (mục 7.13.6)
  ///
  /// In vi, this message translates to:
  /// **'Tạm dừng 1 tuần'**
  String get careSeriesPauseWeek;

  /// CARE-03 chuỗi lặp lại (mục 7.13.6)
  ///
  /// In vi, this message translates to:
  /// **'Dừng chuỗi'**
  String get careSeriesEnd;

  /// CARE-03 chuỗi lặp lại (mục 7.13.6)
  ///
  /// In vi, this message translates to:
  /// **'Các lần chưa làm từ hôm nay sẽ được bỏ khỏi bảng. Việc đã làm vẫn được giữ.'**
  String get careSeriesEndConfirm;

  /// CARE-03 chuỗi lặp lại (mục 7.13.6)
  ///
  /// In vi, this message translates to:
  /// **'Đã tạm dừng chuỗi 1 tuần'**
  String get careSeriesPaused;

  /// CARE-03 chuỗi lặp lại (mục 7.13.6)
  ///
  /// In vi, this message translates to:
  /// **'Đã dừng chuỗi'**
  String get careSeriesEnded;

  /// FAM-01 plan card subtitle (paid plan)
  ///
  /// In vi, this message translates to:
  /// **'{price} · gia hạn {date}'**
  String famPlanPaidSubtitle(String price, String date);

  /// FAM-01 plan card button
  ///
  /// In vi, this message translates to:
  /// **'Quản lý gói'**
  String get famManagePlan;

  /// FAM-01 invite row
  ///
  /// In vi, this message translates to:
  /// **'Mời người thân ({used}/{max})'**
  String famInviteRelativeCount(int used, int max);

  /// FAM-01 relative row subtitle
  ///
  /// In vi, this message translates to:
  /// **'{relation} · Theo dõi {children}'**
  String famRelativeFollows(String relation, String children);

  /// FAM-01 relative row subtitle without children
  ///
  /// In vi, this message translates to:
  /// **'{relation} · Chưa theo dõi bé nào'**
  String famRelativeFollowsNone(String relation);

  /// FAM-01 relation description
  ///
  /// In vi, this message translates to:
  /// **'Mẹ của {callName}'**
  String famRelationMotherOf(String callName);

  /// FAM-01 relation description
  ///
  /// In vi, this message translates to:
  /// **'Bố của {callName}'**
  String famRelationFatherOf(String callName);

  /// Relation label: nanny
  ///
  /// In vi, this message translates to:
  /// **'Người trông trẻ'**
  String get famRelationNanny;

  /// FAM-01 permission summary: view only
  ///
  /// In vi, this message translates to:
  /// **'Xem'**
  String get famPermSummaryView;

  /// FAM-01 permission summary: view + comment
  ///
  /// In vi, this message translates to:
  /// **'Xem, bình luận'**
  String get famPermSummaryComment;

  /// FAM-01 permission summary extra
  ///
  /// In vi, this message translates to:
  /// **'được tải ảnh'**
  String get famPermSummaryDownload;

  /// FAM-01 permission summary extra
  ///
  /// In vi, this message translates to:
  /// **'đóng góp ảnh'**
  String get famPermSummaryContribute;

  /// FAM-04 header subtitle
  ///
  /// In vi, this message translates to:
  /// **'Quan hệ: {relation} · Tham gia {date}'**
  String famRelativeSince(String relation, String date);

  /// FAM-04 status pill
  ///
  /// In vi, this message translates to:
  /// **'Hoạt động {time}'**
  String famRelativeActive(String time);

  /// FAM-04 info row
  ///
  /// In vi, this message translates to:
  /// **'Tên gọi hiển thị'**
  String get famDisplayName;

  /// FAM-04 info row
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get famSignIn;

  /// FAM-04 sign-in value
  ///
  /// In vi, this message translates to:
  /// **'SĐT {phone}'**
  String famSignInPhone(String phone);

  /// FAM-04 info row
  ///
  /// In vi, this message translates to:
  /// **'Ký ức đã đăng'**
  String get famPostedMemories;

  /// Memory count
  ///
  /// In vi, this message translates to:
  /// **'{count} ký ức'**
  String famMemoryCount(int count);

  /// FAM-04 section
  ///
  /// In vi, this message translates to:
  /// **'Quyền theo từng bé'**
  String get famPermByChild;

  /// FAM-04 hide action
  ///
  /// In vi, this message translates to:
  /// **'Tạm ẩn'**
  String get famPermHide;

  /// FAM-04 permission segment
  ///
  /// In vi, this message translates to:
  /// **'Xem'**
  String get famPermLevelView;

  /// FAM-04 permission segment
  ///
  /// In vi, this message translates to:
  /// **'Bình luận'**
  String get famPermLevelComment;

  /// FAM-04 permission segment
  ///
  /// In vi, this message translates to:
  /// **'Đóng góp'**
  String get famPermLevelContribute;

  /// FAM-04 pregnancy row
  ///
  /// In vi, this message translates to:
  /// **'Thai kỳ · Tuần {week}'**
  String famPregnancyWeekShort(int week);

  /// FAM-04 child not shared
  ///
  /// In vi, this message translates to:
  /// **'Chưa chia sẻ'**
  String get famNotShared;

  /// FAM-04 child hidden
  ///
  /// In vi, this message translates to:
  /// **'Đang tạm ẩn'**
  String get famPermHidden;

  /// FAM-04 share button
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ'**
  String get famShare;

  /// FAM-04 toggle
  ///
  /// In vi, this message translates to:
  /// **'Cho phép tải ảnh về máy'**
  String get famAllowDownload;

  /// FAM-04 toggle hint (off)
  ///
  /// In vi, this message translates to:
  /// **'Tắt — {who, select, grandma{bà} grandpa{ông} other{người thân}} xem trong app, không lưu về máy'**
  String famAllowDownloadOff(String who);

  /// FAM-04 toggle hint (on)
  ///
  /// In vi, this message translates to:
  /// **'Bật — {who, select, grandma{bà} grandpa{ông} other{người thân}} lưu được ảnh về máy'**
  String famAllowDownloadOn(String who);

  /// FAM-04 toggle
  ///
  /// In vi, this message translates to:
  /// **'Tắt thông báo từ {callName}'**
  String famMuteFrom(String callName);

  /// FAM-04 toggle hint
  ///
  /// In vi, this message translates to:
  /// **'{who, select, grandma{Bà} grandpa{Ông} other{Người thân}} vẫn xem và bình luận như thường'**
  String famMuteHint(String who);

  /// FAM-04 privacy note
  ///
  /// In vi, this message translates to:
  /// **'{callName} không bao giờ thấy Papa & Mama, nhiệm vụ, lời nhờ và Hearts.'**
  String famRelativeNote(String callName);

  /// FAM-04 action
  ///
  /// In vi, this message translates to:
  /// **'Tạm dừng quyền xem'**
  String get famPauseView;

  /// FAM-04 action (paused)
  ///
  /// In vi, this message translates to:
  /// **'Mở lại quyền xem'**
  String get famResumeView;

  /// FAM-04 action
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo'**
  String get famReport;

  /// FAM-04 action / FAM-06 confirm
  ///
  /// In vi, this message translates to:
  /// **'Gỡ khỏi gia đình'**
  String get famRemoveRelative;

  /// FAM-06 title
  ///
  /// In vi, this message translates to:
  /// **'Gỡ {callName} khỏi gia đình?'**
  String famRemoveTitle(String callName);

  /// FAM-06 summary
  ///
  /// In vi, this message translates to:
  /// **'{callName} đã đăng {count} ký ức. {callName} sẽ không còn xem được các con.'**
  String famRemoveSummary(String callName, int count);

  /// FAM-06 option
  ///
  /// In vi, this message translates to:
  /// **'Giữ lại ký ức đã đăng'**
  String get famRemoveKeepPosts;

  /// FAM-06 option hint
  ///
  /// In vi, this message translates to:
  /// **'Vẫn hiện trong ký ức của gia đình'**
  String get famRemoveKeepPostsHint;

  /// FAM-06 option
  ///
  /// In vi, this message translates to:
  /// **'Gỡ cả các ký ức này'**
  String get famRemoveDeletePosts;

  /// FAM-06 snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã gỡ {callName} khỏi gia đình'**
  String famRemoved(String callName);

  /// FAM-07 cover button
  ///
  /// In vi, this message translates to:
  /// **'Đổi ảnh bìa'**
  String get famSettingsChangeCover;

  /// FAM-07 field
  ///
  /// In vi, this message translates to:
  /// **'Tên gia đình'**
  String get famSettingsName;

  /// FAM-07 section
  ///
  /// In vi, this message translates to:
  /// **'Ký ức & người thân'**
  String get famSettingsMemoriesSection;

  /// FAM-07 row / SET-04 section
  ///
  /// In vi, this message translates to:
  /// **'Ai thấy ký ức mới'**
  String get famSettingsDefaultVisibility;

  /// FAM-07 row hint
  ///
  /// In vi, this message translates to:
  /// **'Mặc định cho ký ức vừa đăng'**
  String get famSettingsDefaultVisibilityHint;

  /// FAM-07 toggle
  ///
  /// In vi, this message translates to:
  /// **'Duyệt ảnh do người thân đăng'**
  String get famSettingsApprove;

  /// FAM-07 toggle hint
  ///
  /// In vi, this message translates to:
  /// **'Ảnh của ông bà chờ Papa/Mama duyệt rồi mới hiện'**
  String get famSettingsApproveHint;

  /// FAM-07 toggle
  ///
  /// In vi, this message translates to:
  /// **'Người thân thấy Cây gia đình'**
  String get famSettingsTree;

  /// FAM-07 toggle
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý cột mốc'**
  String get famSettingsMilestones;

  /// FAM-07 toggle hint
  ///
  /// In vi, this message translates to:
  /// **'Nhắc những lần đầu đáng nhớ của các con'**
  String get famSettingsMilestonesHint;

  /// FAM-07 section
  ///
  /// In vi, this message translates to:
  /// **'Ngày tháng & ngôn ngữ'**
  String get famSettingsDatesSection;

  /// FAM-07 row
  ///
  /// In vi, this message translates to:
  /// **'Múi giờ gia đình'**
  String get famSettingsTimezone;

  /// FAM-07 chọn múi giờ
  ///
  /// In vi, this message translates to:
  /// **'Tìm thành phố hoặc múi giờ'**
  String get famTimezoneSearch;

  /// FAM-07 toggle
  ///
  /// In vi, this message translates to:
  /// **'Hiển thị âm lịch'**
  String get famSettingsLunar;

  /// FAM-07 row
  ///
  /// In vi, this message translates to:
  /// **'Tính đầy tháng, thôi nôi theo'**
  String get famSettingsMilestonesBy;

  /// FAM-07 value
  ///
  /// In vi, this message translates to:
  /// **'Âm lịch'**
  String get famSettingsLunarCalendar;

  /// FAM-07 value
  ///
  /// In vi, this message translates to:
  /// **'Dương lịch'**
  String get famSettingsSolarCalendar;

  /// FAM-07 row
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ nội dung gợi ý'**
  String get famSettingsContentLanguage;

  /// FAM-07 danger row
  ///
  /// In vi, this message translates to:
  /// **'Xoá gia đình'**
  String get famDeleteFamily;

  /// FAM-07 danger hint
  ///
  /// In vi, this message translates to:
  /// **'Cần xác nhận kỹ · có 30 ngày để khôi phục'**
  String get famDeleteFamilyHint;

  /// FAM-07 xoá gia đình (BF-20261019-008)
  ///
  /// In vi, this message translates to:
  /// **'Cần cả Bố và Mẹ đồng ý. Sau khi đồng ý, gia đình được giữ thêm {days} ngày để huỷ; người thân mất quyền xem ngay. Hết hạn, toàn bộ ký ức, ảnh, thư và lịch sử của cả nhà bị xoá.'**
  String famDelBody(int days);

  /// FAM-07 xoá gia đình (BF-20261019-008)
  ///
  /// In vi, this message translates to:
  /// **'Nên tải dữ liệu về trước: Cài đặt → Dữ liệu của tôi.'**
  String get famDelExportHint;

  /// FAM-07 xoá gia đình (BF-20261019-008)
  ///
  /// In vi, this message translates to:
  /// **'Xác thực lại bằng mã gửi tới số điện thoại của bạn.'**
  String get famDelVerifyHint;

  /// FAM-07 xoá gia đình (BF-20261019-008)
  ///
  /// In vi, this message translates to:
  /// **'Gửi mã xác thực'**
  String get famDelSendOtp;

  /// FAM-07 xoá gia đình (BF-20261019-008)
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi mã xác thực'**
  String get famDelOtpSent;

  /// FAM-07 xoá gia đình (BF-20261019-008)
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu xoá gia đình'**
  String get famDelStart;

  /// FAM-07 xoá gia đình (BF-20261019-008)
  ///
  /// In vi, this message translates to:
  /// **'Đồng ý xoá gia đình'**
  String get famDelAgree;

  /// FAM-07 xoá gia đình (BF-20261019-008)
  ///
  /// In vi, this message translates to:
  /// **'Đang chờ bạn đời đồng ý xoá gia đình. Bạn có thể huỷ yêu cầu bất cứ lúc nào.'**
  String get famDelWaitingPartner;

  /// FAM-07 xoá gia đình (BF-20261019-008)
  ///
  /// In vi, this message translates to:
  /// **'Bạn đời đã yêu cầu xoá gia đình. Xác thực lại để đồng ý, hoặc huỷ yêu cầu.'**
  String get famDelPartnerAsked;

  /// FAM-07 xoá gia đình (BF-20261019-008)
  ///
  /// In vi, this message translates to:
  /// **'Gia đình sẽ bị xoá vào {date}. Trong thời gian này cả nhà chỉ xem và tải về được.'**
  String famDelScheduled(String date);

  /// FAM-07 xoá gia đình (BF-20261019-008)
  ///
  /// In vi, this message translates to:
  /// **'Huỷ yêu cầu xoá'**
  String get famDelCancel;

  /// FAM-07 xoá gia đình (BF-20261019-008)
  ///
  /// In vi, this message translates to:
  /// **'Đã huỷ yêu cầu xoá gia đình'**
  String get famDelCancelled;

  /// FAM-07 xoá gia đình (BF-20261019-008)
  ///
  /// In vi, this message translates to:
  /// **'Đã cập nhật yêu cầu xoá gia đình'**
  String get famDelRequested;

  /// SET-02
  ///
  /// In vi, this message translates to:
  /// **'Đổi ảnh đại diện'**
  String get setProfileChangeAvatar;

  /// SET-02 field
  ///
  /// In vi, this message translates to:
  /// **'Tên của bạn'**
  String get setProfileName;

  /// SET-02 field
  ///
  /// In vi, this message translates to:
  /// **'Nhãn gọi trong gia đình'**
  String get setProfileCallName;

  /// SET-02 hint
  ///
  /// In vi, this message translates to:
  /// **'Các con và người thân sẽ thấy bạn với tên “{callName}”.'**
  String setProfileCallNameHint(String callName);

  /// SET-02 section
  ///
  /// In vi, this message translates to:
  /// **'Phương thức đăng nhập'**
  String get setSignInSection;

  /// SET-02 method
  ///
  /// In vi, this message translates to:
  /// **'Apple'**
  String get setSignInApple;

  /// SET-02 method
  ///
  /// In vi, this message translates to:
  /// **'Google'**
  String get setSignInGoogle;

  /// SET-02
  ///
  /// In vi, this message translates to:
  /// **'Chưa liên kết'**
  String get setNotLinked;

  /// SET-02
  ///
  /// In vi, this message translates to:
  /// **'Huỷ liên kết'**
  String get setUnlink;

  /// Đổi số điện thoại (BF-20261019-010)
  ///
  /// In vi, this message translates to:
  /// **'Đổi số điện thoại'**
  String get phoneChangeTitle;

  /// Đổi số điện thoại (BF-20261019-010)
  ///
  /// In vi, this message translates to:
  /// **'Trước tiên, xác thực lại bằng mã gửi tới số hiện tại của bạn.'**
  String get phoneChangeReauthHint;

  /// Đổi số điện thoại (BF-20261019-010)
  ///
  /// In vi, this message translates to:
  /// **'Nhập số điện thoại mới. Mã xác nhận sẽ gửi tới số này.'**
  String get phoneChangeNewHint;

  /// Đổi số điện thoại (BF-20261019-010)
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi mã tới {phone}'**
  String phoneChangeCodeSent(String phone);

  /// Đổi số điện thoại (BF-20261019-010)
  ///
  /// In vi, this message translates to:
  /// **'Đã đổi số điện thoại. Các thiết bị khác đã được đăng xuất.'**
  String get phoneChangeDone;

  /// Đổi số điện thoại (BF-20261019-010)
  ///
  /// In vi, this message translates to:
  /// **'Đổi số'**
  String get setChangePhone;

  /// SET-02
  ///
  /// In vi, this message translates to:
  /// **'Liên kết'**
  String get setLink;

  /// SET-02 hint
  ///
  /// In vi, this message translates to:
  /// **'Luôn giữ ít nhất 1 cách đăng nhập để không mất tài khoản.'**
  String get setSignInHint;

  /// SET-02 section
  ///
  /// In vi, this message translates to:
  /// **'Múi giờ'**
  String get setTimezoneSection;

  /// SET-02 toggle
  ///
  /// In vi, this message translates to:
  /// **'Tự động theo thiết bị'**
  String get setAutoTimezone;

  /// SET-02 toggle hint
  ///
  /// In vi, this message translates to:
  /// **'Giờ nhắc nhiệm vụ, lời nhờ theo nơi bạn đang ở'**
  String get setAutoTimezoneHint;

  /// SET-02 row
  ///
  /// In vi, this message translates to:
  /// **'Múi giờ cá nhân'**
  String get setPersonalTimezone;

  /// SET-02 button
  ///
  /// In vi, this message translates to:
  /// **'Lưu thay đổi'**
  String get setSaveChanges;

  /// SET-02 snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu thay đổi'**
  String get setChangesSaved;

  /// SET-03 section
  ///
  /// In vi, this message translates to:
  /// **'Nhóm thông báo'**
  String get setNotifGroupsSection;

  /// SET-03 section
  ///
  /// In vi, this message translates to:
  /// **'Giờ yên tĩnh & màn hình khoá'**
  String get setQuietSection;

  /// SET-03 toggle
  ///
  /// In vi, this message translates to:
  /// **'Giờ yên tĩnh'**
  String get setQuietHours;

  /// SET-03 toggle hint
  ///
  /// In vi, this message translates to:
  /// **'Thông báo được gom lại, gửi sau'**
  String get setQuietHoursHint;

  /// SET-03 time range
  ///
  /// In vi, this message translates to:
  /// **'Từ'**
  String get setFrom;

  /// SET-03 time range
  ///
  /// In vi, this message translates to:
  /// **'Đến'**
  String get setTo;

  /// SET-03 toggle
  ///
  /// In vi, this message translates to:
  /// **'Lời nhờ của {callName} vượt giờ yên tĩnh'**
  String setUrgentBypass(String callName);

  /// SET-03 hint (off)
  ///
  /// In vi, this message translates to:
  /// **'Tắt — lời nhờ “Sớm nhé” cũng chờ sau {time}'**
  String setUrgentBypassOff(String time);

  /// SET-03 hint (on)
  ///
  /// In vi, this message translates to:
  /// **'Bật — lời nhờ “Sớm nhé” vẫn báo ngay'**
  String get setUrgentBypassOn;

  /// SET-03 toggle
  ///
  /// In vi, this message translates to:
  /// **'Ẩn nội dung trên màn hình khoá'**
  String get setHideLockScreen;

  /// SET-03 toggle hint
  ///
  /// In vi, this message translates to:
  /// **'Hiện: “Bạn có một cập nhật mới từ Papa & Mama”'**
  String get setHideLockScreenHint;

  /// SET-03 section
  ///
  /// In vi, this message translates to:
  /// **'Người thân'**
  String get setRelativesSection;

  /// SET-03 row
  ///
  /// In vi, this message translates to:
  /// **'Giờ gửi bản tin'**
  String get setDigestTime;

  /// SET-03 row
  ///
  /// In vi, this message translates to:
  /// **'Tắt thông báo theo người'**
  String get setMutePeople;

  /// SET-03 muted people
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =0{Chưa có ai} other{{count} người}}'**
  String setPeopleCount(int count);

  /// SET-04 option hint
  ///
  /// In vi, this message translates to:
  /// **'Bản nháp, điều muốn giữ riêng'**
  String get setVisOnlyMeHint;

  /// SET-04 option
  ///
  /// In vi, this message translates to:
  /// **'Papa & Mama'**
  String get setVisParents;

  /// SET-04 option hint
  ///
  /// In vi, this message translates to:
  /// **'Chỉ Papa và Mama'**
  String get setVisParentsHint;

  /// SET-04 option hint
  ///
  /// In vi, this message translates to:
  /// **'Papa, Mama và người thân được chia sẻ bé trong ký ức'**
  String get setVisFamilyHint;

  /// SET-04 hint
  ///
  /// In vi, this message translates to:
  /// **'Không có chia sẻ công khai. Bạn đổi được mức hiển thị của từng ký ức bất cứ lúc nào.'**
  String get setVisibilityHint;

  /// SET-04 section
  ///
  /// In vi, this message translates to:
  /// **'Bảng điều khiển quyền'**
  String get setDashboardSection;

  /// SET-04
  ///
  /// In vi, this message translates to:
  /// **'Ai đang thấy bé nào'**
  String get setWhoSees;

  /// SET-04 audience
  ///
  /// In vi, this message translates to:
  /// **'{count} người thân'**
  String setRelativeCount(int count);

  /// SET-04 stat
  ///
  /// In vi, this message translates to:
  /// **'Được tải ảnh về'**
  String get setStatDownload;

  /// SET-04 stat
  ///
  /// In vi, this message translates to:
  /// **'Được đăng ảnh'**
  String get setStatPost;

  /// SET-04 stat
  ///
  /// In vi, this message translates to:
  /// **'Ký ức để “Cả nhà”'**
  String get setStatFamilyMemories;

  /// SET-04 stat unit
  ///
  /// In vi, this message translates to:
  /// **'ký ức'**
  String get setStatMemoriesUnit;

  /// SET-04 stat
  ///
  /// In vi, this message translates to:
  /// **'Thiết bị đăng nhập'**
  String get setStatDevices;

  /// SET-04 stat unit
  ///
  /// In vi, this message translates to:
  /// **'thiết bị'**
  String get setStatDevicesUnit;

  /// SET-04 stat
  ///
  /// In vi, this message translates to:
  /// **'AI đang bật'**
  String get setStatAi;

  /// SET-04 stat unit
  ///
  /// In vi, this message translates to:
  /// **'tính năng'**
  String get setStatAiUnit;

  /// SET-04 link
  ///
  /// In vi, this message translates to:
  /// **'Xem chi tiết & chỉnh quyền'**
  String get setOpenPermissions;

  /// SET-04 note
  ///
  /// In vi, this message translates to:
  /// **'Papa & Mama, nhiệm vụ, lời nhờ và Hearts luôn chỉ của hai bạn — người thân không bao giờ thấy.'**
  String get setPrivacyNote;

  /// SET-04 row
  ///
  /// In vi, this message translates to:
  /// **'Người bị chặn'**
  String get setBlocked;

  /// SET-07 section
  ///
  /// In vi, this message translates to:
  /// **'Khoá ứng dụng'**
  String get setAppLockSection;

  /// SET-07 toggle
  ///
  /// In vi, this message translates to:
  /// **'Khoá bằng Face ID'**
  String get setFaceIdLock;

  /// SET-07 toggle hint
  ///
  /// In vi, this message translates to:
  /// **'Mở Baby Family cần Face ID của bạn'**
  String get setFaceIdLockHint;

  /// SET-07 row
  ///
  /// In vi, this message translates to:
  /// **'Mã PIN dự phòng'**
  String get setBackupPin;

  /// SET-07 value
  ///
  /// In vi, this message translates to:
  /// **'Đã đặt'**
  String get setPinSet;

  /// SET-07 value
  ///
  /// In vi, this message translates to:
  /// **'Chưa đặt'**
  String get setPinNotSet;

  /// SET-07 hint
  ///
  /// In vi, this message translates to:
  /// **'Khi Face ID không nhận ra, bạn mở bằng mã PIN 6 số.'**
  String get setPinHint;

  /// SET-07 section
  ///
  /// In vi, this message translates to:
  /// **'Thiết bị đang đăng nhập'**
  String get setDevicesSection;

  /// SET-07 current device
  ///
  /// In vi, this message translates to:
  /// **'{location} · Đang dùng'**
  String setDeviceInUse(String location);

  /// SET-07 current device khi server không có vị trí
  ///
  /// In vi, this message translates to:
  /// **'Đang dùng'**
  String get setDeviceInUseNoLocation;

  /// SET-07 device subtitle
  ///
  /// In vi, this message translates to:
  /// **'{location} · {time}'**
  String setDeviceLastActive(String location, String time);

  /// SET-07 tag
  ///
  /// In vi, this message translates to:
  /// **'Thiết bị này'**
  String get setThisDevice;

  /// SET-07 button
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất mọi thiết bị'**
  String get setSignOutAll;

  /// SET-07 hint
  ///
  /// In vi, this message translates to:
  /// **'Bạn sẽ cần đăng nhập lại trên tất cả thiết bị, kể cả máy này. Ký ức và dữ liệu vẫn được giữ nguyên.'**
  String get setSignOutAllHint;

  /// SET-07 snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã đăng xuất {device}'**
  String setDeviceSignedOut(String device);

  /// SET-08 subtitle
  ///
  /// In vi, this message translates to:
  /// **'Kỷ niệm của nhà mình luôn là của nhà mình — tải về bất cứ lúc nào.'**
  String get setDataSubtitle;

  /// SET-08 section
  ///
  /// In vi, this message translates to:
  /// **'Xuất dữ liệu'**
  String get setExportSection;

  /// SET-08
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu cá nhân'**
  String get setExportPersonal;

  /// SET-08
  ///
  /// In vi, this message translates to:
  /// **'Mọi thành viên'**
  String get setExportPersonalWho;

  /// SET-08
  ///
  /// In vi, this message translates to:
  /// **'Những gì bạn tạo: ký ức đã đăng, nhật ký riêng, mood, lời cảm ơn đã gửi và nhận.'**
  String get setExportPersonalDesc;

  /// SET-08
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu gia đình'**
  String get setExportFamily;

  /// SET-08
  ///
  /// In vi, this message translates to:
  /// **'File ZIP: ảnh/video gốc, memories.csv và trang xem offline. Không gồm Papa & Mama.'**
  String get setExportFamilyDesc;

  /// SET-08 button
  ///
  /// In vi, this message translates to:
  /// **'Xuất'**
  String get setExport;

  /// SET-08 button
  ///
  /// In vi, this message translates to:
  /// **'Đang xuất…'**
  String get setExporting;

  /// SET-08 section
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái xuất'**
  String get setExportStatusSection;

  /// SET-08
  ///
  /// In vi, this message translates to:
  /// **'Đang chuẩn bị · {percent}%'**
  String setExportPreparing(int percent);

  /// SET-08
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu {time} hôm nay · Bạn sẽ nhận thông báo khi xong.'**
  String setExportStarted(String time);

  /// SET-08
  ///
  /// In vi, this message translates to:
  /// **'{name} · {size} MB'**
  String setExportReadyTitle(String name, int size);

  /// SET-08
  ///
  /// In vi, this message translates to:
  /// **'Link tải hết hạn {date}'**
  String setExportExpires(String date);

  /// SET-08 button
  ///
  /// In vi, this message translates to:
  /// **'Tải về'**
  String get setDownload;

  /// SET-08 snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã bắt đầu tải về'**
  String get setDownloadStarted;

  /// SET-08 section
  ///
  /// In vi, this message translates to:
  /// **'Trên máy này'**
  String get setOnDeviceSection;

  /// SET-08
  ///
  /// In vi, this message translates to:
  /// **'Bộ nhớ đệm'**
  String get setCache;

  /// SET-08
  ///
  /// In vi, this message translates to:
  /// **'{size} MB trên máy'**
  String setCacheSize(int size);

  /// SET-08 button
  ///
  /// In vi, this message translates to:
  /// **'Xoá cache'**
  String get setClearCache;

  /// SET-08 hint
  ///
  /// In vi, this message translates to:
  /// **'Xoá cache chỉ giải phóng bộ nhớ máy. Ký ức vẫn an toàn trên đám mây.'**
  String get setCacheHint;

  /// SET-09 step label
  ///
  /// In vi, this message translates to:
  /// **'Bước {step}/4'**
  String setDelStep(int step);

  /// SET-09c step label
  ///
  /// In vi, this message translates to:
  /// **'Bước 3–4/4'**
  String get setDelStepFinal;

  /// SET-09 title
  ///
  /// In vi, this message translates to:
  /// **'Trước khi xoá tài khoản'**
  String get setDelTitle1;

  /// SET-09 subtitle
  ///
  /// In vi, this message translates to:
  /// **'{name} ơi, đây là những gì sẽ thay đổi. Bạn có thể dừng lại bất cứ lúc nào.'**
  String setDelSubtitle1(String name);

  /// SET-09
  ///
  /// In vi, this message translates to:
  /// **'Sẽ bị xoá'**
  String get setDelWillDelete;

  /// SET-09
  ///
  /// In vi, this message translates to:
  /// **'Nhật ký riêng, mood và các bản nháp của bạn'**
  String get setDelItemPrivate;

  /// SET-09
  ///
  /// In vi, this message translates to:
  /// **'Phần Papa & Mama của bạn — {partner} vẫn giữ phần của {partner}'**
  String setDelItemCouple(String partner);

  /// SET-09 (no partner)
  ///
  /// In vi, this message translates to:
  /// **'Phần Papa & Mama của bạn'**
  String get setDelItemCoupleSolo;

  /// SET-09
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ và các phương thức đăng nhập'**
  String get setDelItemProfile;

  /// SET-09
  ///
  /// In vi, this message translates to:
  /// **'{count} ký ức bạn đã đăng'**
  String setDelPosted(int count);

  /// SET-09 option
  ///
  /// In vi, this message translates to:
  /// **'Giữ lại cho gia đình'**
  String get setDelKeepForFamily;

  /// SET-09 option hint
  ///
  /// In vi, this message translates to:
  /// **'Hiển thị dưới tên “Người dùng đã rời”'**
  String get setDelKeepHint;

  /// SET-09 option
  ///
  /// In vi, this message translates to:
  /// **'Xoá các ký ức này'**
  String get setDelDeleteMemories;

  /// SET-09
  ///
  /// In vi, this message translates to:
  /// **'Gói dịch vụ'**
  String get setDelSubscription;

  /// SET-09
  ///
  /// In vi, this message translates to:
  /// **'Gói mua qua App Store hoặc Google Play không tự huỷ khi xoá tài khoản. Hãy huỷ trong Store để không bị gia hạn.'**
  String get setDelSubscriptionBody;

  /// SET-09 link
  ///
  /// In vi, this message translates to:
  /// **'Xem cách huỷ gói trong Store'**
  String get setDelHowToCancel;

  /// SET-09 note
  ///
  /// In vi, this message translates to:
  /// **'Bình luận của người khác trên ảnh của bạn vẫn là của họ — app không xoá nội dung của người khác.'**
  String get setDelOthersNote;

  /// SET-09 secondary
  ///
  /// In vi, this message translates to:
  /// **'Giữ tài khoản'**
  String get setDelKeepAccount;

  /// SET-09b title
  ///
  /// In vi, this message translates to:
  /// **'{family} sẽ ra sao?'**
  String setDelTitle2(String family);

  /// SET-09b subtitle
  ///
  /// In vi, this message translates to:
  /// **'Bạn vẫn còn {partner} trong gia đình, nên các con và mọi kỷ niệm sẽ ở lại với {partner}.'**
  String setDelSubtitle2(String partner);

  /// SET-09b
  ///
  /// In vi, this message translates to:
  /// **'{partner} tiếp tục giữ {family}'**
  String setDelPartnerKeeps(String partner, String family);

  /// SET-09b
  ///
  /// In vi, this message translates to:
  /// **'{partner} vẫn xem và tải về mọi ký ức của {children}'**
  String setDelPartnerItem1(String partner, String children);

  /// SET-09b
  ///
  /// In vi, this message translates to:
  /// **'Gia đình chuyển sang chế độ chỉ xem & tải về'**
  String get setDelPartnerItem2;

  /// SET-09b
  ///
  /// In vi, this message translates to:
  /// **'{partner} có thể mời một bạn đời mới vào gia đình'**
  String setDelPartnerItem3(String partner);

  /// SET-09b
  ///
  /// In vi, this message translates to:
  /// **'Mood, nhật ký và chia sẻ của bạn trong Papa & Mama sẽ bị xoá. Phần của {partner} vẫn còn nguyên.'**
  String setDelCoupleData(String partner);

  /// SET-09b
  ///
  /// In vi, this message translates to:
  /// **'Muốn giữ một bản cho riêng mình?'**
  String get setDelExportTip;

  /// SET-09b
  ///
  /// In vi, this message translates to:
  /// **'Xuất dữ liệu cá nhân trước khi xoá'**
  String get setDelExportTipHint;

  /// SET-09b only-parent badge
  ///
  /// In vi, this message translates to:
  /// **'Khi bạn là Papa/Mama duy nhất'**
  String get setDelOnlyBadge;

  /// SET-09b only-parent title
  ///
  /// In vi, this message translates to:
  /// **'Ai sẽ giữ kỷ niệm của các con?'**
  String get setDelOnlyTitle;

  /// SET-09b only-parent
  ///
  /// In vi, this message translates to:
  /// **'{family} chỉ có bạn quản lý. Hãy chọn một cách trước khi tiếp tục.'**
  String setDelOnlySubtitle(String family);

  /// SET-09b option
  ///
  /// In vi, this message translates to:
  /// **'Mời người khác làm Parent trước'**
  String get setDelInviteParent;

  /// SET-09b option hint
  ///
  /// In vi, this message translates to:
  /// **'Họ giữ gia đình, các con và mọi ký ức. Bạn quay lại xoá tài khoản sau khi họ tham gia.'**
  String get setDelInviteParentHint;

  /// SET-09b option
  ///
  /// In vi, this message translates to:
  /// **'Xoá cả gia đình'**
  String get setDelDeleteFamily;

  /// SET-09b option hint
  ///
  /// In vi, this message translates to:
  /// **'{children} và mọi ký ức bị xoá vĩnh viễn sau 30 ngày. Trong 30 ngày đó bạn vẫn khôi phục được.'**
  String setDelDeleteFamilyHint(String children);

  /// SET-09b only-parent tip
  ///
  /// In vi, this message translates to:
  /// **'Nên xuất dữ liệu gia đình trước để giữ lại toàn bộ ảnh và video gốc.'**
  String get setDelOnlyExportTip;

  /// SET-09b only-parent button
  ///
  /// In vi, this message translates to:
  /// **'Mời Parent mới'**
  String get setDelInviteNewParent;

  /// SET-09c title
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận lần cuối'**
  String get setDelTitle3;

  /// SET-09c subtitle
  ///
  /// In vi, this message translates to:
  /// **'Để bảo vệ tài khoản, hãy đăng nhập lại bằng một cách bạn đã liên kết.'**
  String get setDelSubtitle3;

  /// SET-09c
  ///
  /// In vi, this message translates to:
  /// **'Đã xác thực · {account}'**
  String setDelVerified(String account);

  /// SET-09c
  ///
  /// In vi, this message translates to:
  /// **'Dùng mã OTP qua SĐT {phone}'**
  String setDelUseOtp(String phone);

  /// SET-09c
  ///
  /// In vi, this message translates to:
  /// **'Khi bạn bấm “Xoá tài khoản”'**
  String get setDelWhatHappens;

  /// SET-09c
  ///
  /// In vi, this message translates to:
  /// **'Bạn được đăng xuất khỏi mọi thiết bị ngay'**
  String get setDelHappen1;

  /// SET-09c
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản chờ xoá 30 ngày — đến {date}'**
  String setDelHappen2(String date);

  /// SET-09c
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập lại trước ngày đó để khôi phục'**
  String get setDelHappen3;

  /// SET-09c
  ///
  /// In vi, this message translates to:
  /// **'Sau 30 ngày, dữ liệu bị xoá vĩnh viễn và bạn nhận email xác nhận'**
  String get setDelHappen4;

  /// SET-09c checkbox
  ///
  /// In vi, this message translates to:
  /// **'Tôi đã hiểu và muốn xoá tài khoản của mình'**
  String get setDelConfirmCheck;

  /// SET-11 section
  ///
  /// In vi, this message translates to:
  /// **'Câu hỏi thường gặp'**
  String get setFaqSection;

  /// SET-11
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả câu hỏi'**
  String get setFaqAll;

  /// SET-11 section
  ///
  /// In vi, this message translates to:
  /// **'Cần thêm hỗ trợ'**
  String get setSupportSection;

  /// SET-11
  ///
  /// In vi, this message translates to:
  /// **'Gửi yêu cầu hỗ trợ'**
  String get setSendRequest;

  /// SET-11
  ///
  /// In vi, this message translates to:
  /// **'Mô tả vấn đề, kèm ảnh chụp màn hình nếu muốn'**
  String get setSendRequestHint;

  /// SET-11 gửi yêu cầu hỗ trợ
  ///
  /// In vi, this message translates to:
  /// **'Gửi yêu cầu hỗ trợ'**
  String get supportTitle;

  /// SET-11 gửi yêu cầu hỗ trợ
  ///
  /// In vi, this message translates to:
  /// **'Chỉ nội dung bạn tự nhập được gửi tới đội hỗ trợ. Đừng ghi mật khẩu hay mã OTP.'**
  String get supportHint;

  /// SET-11 gửi yêu cầu hỗ trợ
  ///
  /// In vi, this message translates to:
  /// **'Vấn đề về'**
  String get supportCategoryLabel;

  /// SET-11 gửi yêu cầu hỗ trợ
  ///
  /// In vi, this message translates to:
  /// **'{category, select, ACCOUNT{Tài khoản} INVITATION{Lời mời} MEDIA{Ảnh & video} BILLING{Gói & thanh toán} PRIVACY{Quyền riêng tư} other{Khác}}'**
  String supportCategory(String category);

  /// SET-11 gửi yêu cầu hỗ trợ
  ///
  /// In vi, this message translates to:
  /// **'Tiêu đề'**
  String get supportSubject;

  /// SET-11 gửi yêu cầu hỗ trợ
  ///
  /// In vi, this message translates to:
  /// **'Mô tả vấn đề'**
  String get supportBody;

  /// SET-11 gửi yêu cầu hỗ trợ
  ///
  /// In vi, this message translates to:
  /// **'Gửi yêu cầu'**
  String get supportSend;

  /// SET-11 gửi yêu cầu hỗ trợ
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi yêu cầu {code}'**
  String supportSent(String code);

  /// SET-11 gửi yêu cầu hỗ trợ
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu đã gửi'**
  String get supportMine;

  /// SET-11 gửi yêu cầu hỗ trợ
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa gửi yêu cầu nào.'**
  String get supportEmpty;

  /// SET-11 gửi yêu cầu hỗ trợ
  ///
  /// In vi, this message translates to:
  /// **'{status, select, OPEN{Đã tiếp nhận} IN_PROGRESS{Đang xử lý} WAITING_USER{Chờ bạn phản hồi} RESOLVED{Đã giải quyết} other{Đã đóng}}'**
  String supportStatus(String status);

  /// SET-11 chi tiết yêu cầu hỗ trợ
  ///
  /// In vi, this message translates to:
  /// **'Trao đổi'**
  String get supportThread;

  /// SET-11 chi tiết yêu cầu hỗ trợ
  ///
  /// In vi, this message translates to:
  /// **'Đội hỗ trợ sẽ trả lời tại đây.'**
  String get supportNoReply;

  /// SET-11 chi tiết yêu cầu hỗ trợ
  ///
  /// In vi, this message translates to:
  /// **'Đội hỗ trợ'**
  String get supportTeam;

  /// SET-11 chi tiết yêu cầu hỗ trợ
  ///
  /// In vi, this message translates to:
  /// **'Nhắn thêm'**
  String get supportReply;

  /// SET-11 chi tiết yêu cầu hỗ trợ
  ///
  /// In vi, this message translates to:
  /// **'Gửi'**
  String get supportSendReply;

  /// SET-11 chi tiết yêu cầu hỗ trợ
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu này đã đóng. Gửi yêu cầu mới nếu bạn cần thêm trợ giúp.'**
  String get supportClosedHint;

  /// SET-11
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo của tôi'**
  String get setMyReports;

  /// SET-11 tag
  ///
  /// In vi, this message translates to:
  /// **'{count} đang xử lý'**
  String setReportsOpen(int count);

  /// SET-11 section
  ///
  /// In vi, this message translates to:
  /// **'Liên hệ'**
  String get setContactSection;

  /// SET-11
  ///
  /// In vi, this message translates to:
  /// **'Email đội hỗ trợ'**
  String get setEmailSupport;

  /// SET-11
  ///
  /// In vi, this message translates to:
  /// **'Đường dây hỗ trợ'**
  String get setHotline;

  /// SET-12
  ///
  /// In vi, this message translates to:
  /// **'Phiên bản {version}'**
  String setAppVersion(String version);

  /// SET-12
  ///
  /// In vi, this message translates to:
  /// **'Điều khoản sử dụng'**
  String get setTerms;

  /// SET-12
  ///
  /// In vi, this message translates to:
  /// **'Chính sách quyền riêng tư'**
  String get setPrivacyPolicy;

  /// SET-12
  ///
  /// In vi, this message translates to:
  /// **'Giấy phép mã nguồn mở'**
  String get setLicenses;

  /// SET-12 footer
  ///
  /// In vi, this message translates to:
  /// **'Làm với yêu thương cho các gia đình Việt'**
  String get setMadeWith;

  /// SET-12 copyright
  ///
  /// In vi, this message translates to:
  /// **'© {year} Baby Family'**
  String setCopyright(String year);

  /// Join the last item of a list (“Hana, Haru và Bơ”)
  ///
  /// In vi, this message translates to:
  /// **'{items} và {last}'**
  String commonAndList(String items, String last);

  /// MEM-03 section
  ///
  /// In vi, this message translates to:
  /// **'Album tự động'**
  String get memAlbumsAuto;

  /// MEM-03 section hint
  ///
  /// In vi, this message translates to:
  /// **'Tự cập nhật'**
  String get memAlbumsAutoHint;

  /// MEM-03 section
  ///
  /// In vi, this message translates to:
  /// **'Album của nhà mình'**
  String get memAlbumsFamily;

  /// MEM-03 — chưa có album của nhà mình
  ///
  /// In vi, this message translates to:
  /// **'Chưa có album nào'**
  String get memAlbumsEmpty;

  /// MEM-03 — mô tả khi chưa có album
  ///
  /// In vi, this message translates to:
  /// **'Tạo album để gom ký ức theo chuyến đi, ngày lễ hay bất cứ điều gì bạn thích.'**
  String get memAlbumsEmptyDescription;

  /// MEM-03 button
  ///
  /// In vi, this message translates to:
  /// **'Album mới'**
  String get memAlbumNew;

  /// MEM-03 new album field
  ///
  /// In vi, this message translates to:
  /// **'Tên album'**
  String get memAlbumNameHint;

  /// MEM-03 new album confirm
  ///
  /// In vi, this message translates to:
  /// **'Tạo album'**
  String get memAlbumCreate;

  /// MEM-03 monthly album meta
  ///
  /// In vi, this message translates to:
  /// **'{name} · {count} ảnh'**
  String memAlbumMonthlyMeta(String name, int count);

  /// MEM-03 firsts album meta
  ///
  /// In vi, this message translates to:
  /// **'{count} cột mốc'**
  String memAlbumFirstsMeta(int count);

  /// MEM-03 videos album meta
  ///
  /// In vi, this message translates to:
  /// **'{count} video'**
  String memAlbumVideosMeta(int count);

  /// MEM-03 quotes album meta
  ///
  /// In vi, this message translates to:
  /// **'{count} câu nói'**
  String memAlbumQuotesMeta(int count);

  /// MEM-03 voices album meta
  ///
  /// In vi, this message translates to:
  /// **'{count} ghi âm'**
  String memAlbumVoicesMeta(int count);

  /// MEM-03 parents-only album meta
  ///
  /// In vi, this message translates to:
  /// **'{count} ký ức · Papa & Mama'**
  String memAlbumParentsMeta(int count);

  /// MEM-03a cover meta
  ///
  /// In vi, this message translates to:
  /// **'{count} ký ức · {range}'**
  String memAlbumDetailMeta(int count, String range);

  /// MEM-03a creator chip
  ///
  /// In vi, this message translates to:
  /// **'{callName} tạo'**
  String memAlbumCreatedBy(String callName);

  /// MEM-03a note
  ///
  /// In vi, this message translates to:
  /// **'Người xem chỉ thấy ký ức họ có quyền xem trong album này.'**
  String get memAlbumPermissionNote;

  /// MEM-03a menu
  ///
  /// In vi, this message translates to:
  /// **'Đổi tên'**
  String get memAlbumRename;

  /// MEM-03a menu
  ///
  /// In vi, this message translates to:
  /// **'Đổi bìa'**
  String get memAlbumChangeCover;

  /// MEM-03a menu
  ///
  /// In vi, this message translates to:
  /// **'Xoá album'**
  String get memAlbumDelete;

  /// MEM-03a menu note
  ///
  /// In vi, this message translates to:
  /// **'Ký ức trong album vẫn được giữ lại'**
  String get memAlbumDeleteNote;

  /// MEM-03a delete dialog
  ///
  /// In vi, this message translates to:
  /// **'Xoá album “{title}”?'**
  String memAlbumDeleteConfirm(String title);

  /// Two names joined
  ///
  /// In vi, this message translates to:
  /// **'{first} & {second}'**
  String memNamesPair(String first, String second);

  /// Three meta parts
  ///
  /// In vi, this message translates to:
  /// **'{first} · {second} · {third}'**
  String memDotMeta3(String first, String second, String third);

  /// MEM-08 hint
  ///
  /// In vi, this message translates to:
  /// **'Vuốt xuống để đóng'**
  String get memViewerSwipeHint;

  /// MEM-08 action
  ///
  /// In vi, this message translates to:
  /// **'Tải về'**
  String get memViewerDownload;

  /// MEM-08 action
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ'**
  String get memViewerShare;

  /// MEM-08 action
  ///
  /// In vi, this message translates to:
  /// **'Thông tin'**
  String get memViewerInfo;

  /// MEM-08 download done
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu ảnh vào máy'**
  String get memViewerDownloaded;

  /// MEM-10 reply link
  ///
  /// In vi, this message translates to:
  /// **'Trả lời'**
  String get memCommentReply;

  /// MEM-10 composer
  ///
  /// In vi, this message translates to:
  /// **'Đang trả lời {name}'**
  String memCommentReplying(String name);

  /// MEM-10 composer
  ///
  /// In vi, this message translates to:
  /// **'Đang sửa bình luận'**
  String get memCommentEditing;

  /// MEM-10 long-press
  ///
  /// In vi, this message translates to:
  /// **'Sửa'**
  String get memCommentEdit;

  /// MEM-10 long-press
  ///
  /// In vi, this message translates to:
  /// **'Sao chép'**
  String get memCommentCopy;

  /// MEM-10 long-press
  ///
  /// In vi, this message translates to:
  /// **'Xoá'**
  String get memCommentDelete;

  /// MEM-10 age
  ///
  /// In vi, this message translates to:
  /// **'{count} phút'**
  String memCommentMinutes(int count);

  /// MEM-10 age
  ///
  /// In vi, this message translates to:
  /// **'{count} giờ'**
  String memCommentHours(int count);

  /// MEM-10 emoji button
  ///
  /// In vi, this message translates to:
  /// **'Biểu tượng cảm xúc'**
  String get memCommentEmoji;

  /// MEM-11 search
  ///
  /// In vi, this message translates to:
  /// **'Tìm cột mốc, ví dụ “lẫy”, “răng”…'**
  String get memMilestoneSearchHint;

  /// MEM-11 group count
  ///
  /// In vi, this message translates to:
  /// **'{done} / {total} đã ghi'**
  String memMilestoneRecordedCount(int done, int total);

  /// MEM-11 row
  ///
  /// In vi, this message translates to:
  /// **'Đã ghi · {date}'**
  String memMilestoneRecordedAt(String date);

  /// MEM-11 custom
  ///
  /// In vi, this message translates to:
  /// **'✏️ Cột mốc riêng của nhà mình'**
  String get memMilestoneCustom;

  /// MEM-11 custom dialog
  ///
  /// In vi, this message translates to:
  /// **'Tên cột mốc'**
  String get memMilestoneCustomHint;

  /// MEM-11 empty search
  ///
  /// In vi, this message translates to:
  /// **'Chưa có cột mốc phù hợp'**
  String get memMilestoneNoResult;

  /// MEM-13 subtitle
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu nháp · {time}'**
  String memDiarySavedDraft(String time);

  /// MEM-13 snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu nhật ký'**
  String get memDiarySaved;

  /// MEM-13 toolbar
  ///
  /// In vi, this message translates to:
  /// **'In đậm'**
  String get memFormatBold;

  /// MEM-13 toolbar
  ///
  /// In vi, this message translates to:
  /// **'In nghiêng'**
  String get memFormatItalic;

  /// MEM-13 toolbar
  ///
  /// In vi, this message translates to:
  /// **'Danh sách'**
  String get memFormatList;

  /// MEM-13 toolbar
  ///
  /// In vi, this message translates to:
  /// **'Danh sách đánh số'**
  String get memFormatNumbered;

  /// MEM-13 toolbar
  ///
  /// In vi, this message translates to:
  /// **'Chèn ảnh'**
  String get memFormatImage;

  /// MEM-13 toolbar
  ///
  /// In vi, this message translates to:
  /// **'Tiêu đề'**
  String get memFormatHeading;

  /// MEM-13 toolbar
  ///
  /// In vi, this message translates to:
  /// **'Ẩn bàn phím'**
  String get memFormatHideKeyboard;

  /// MEM-14 top
  ///
  /// In vi, this message translates to:
  /// **'Lưu nháp'**
  String get memLetterSaveDraft;

  /// MEM-14 snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu nháp'**
  String get memLetterDraftSaved;

  /// MEM-14 label
  ///
  /// In vi, this message translates to:
  /// **'Gửi đến'**
  String get memLetterRecipient;

  /// MEM-14 label
  ///
  /// In vi, this message translates to:
  /// **'Hình thức'**
  String get memLetterFormat;

  /// MEM-14 format
  ///
  /// In vi, this message translates to:
  /// **'Viết'**
  String get memLetterWrite;

  /// MEM-14 format
  ///
  /// In vi, this message translates to:
  /// **'Quay video'**
  String get memLetterVideo;

  /// MEM-14 open date
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngày'**
  String get memLetterPickDate;

  /// MEM-14 open date
  ///
  /// In vi, this message translates to:
  /// **'Sinh nhật thứ N'**
  String get memLetterBirthdayN;

  /// MEM-14 picker
  ///
  /// In vi, this message translates to:
  /// **'Sinh nhật {age} tuổi'**
  String memLetterBirthdayAge(int age);

  /// MEM-14 picker
  ///
  /// In vi, this message translates to:
  /// **'{name} mở vào {date}'**
  String memLetterOpensOn(String name, String date);

  /// MEM-14 label
  ///
  /// In vi, this message translates to:
  /// **'Ai được đọc khi đến ngày mở'**
  String get memLetterReaders;

  /// MEM-14 readers note
  ///
  /// In vi, this message translates to:
  /// **'{mode, select, onlyMe{Khi mở: chỉ {me} đọc cùng con. {partner} không thấy thư này.} family{Khi mở: cả nhà cùng đọc với con. Trước ngày mở, chỉ {me} đọc và sửa được.} other{Khi mở: {me} và {partner} cùng đọc với con. Trước ngày mở, chỉ {me} đọc và sửa được — {partner} thấy có thư nhưng không đọc nội dung.}}'**
  String memLetterReadersNote(String mode, String me, String partner);

  /// MEM-14 label
  ///
  /// In vi, this message translates to:
  /// **'Xem trước phong bì'**
  String get memLetterEnvelopePreview;

  /// MEM-14 envelope
  ///
  /// In vi, this message translates to:
  /// **'Gửi {name}'**
  String memLetterEnvelopeTo(String name);

  /// MEM-14 envelope
  ///
  /// In vi, this message translates to:
  /// **'Mở vào {date} · Sinh nhật thứ {age}'**
  String memLetterEnvelopeBirthday(String date, int age);

  /// MEM-14 envelope
  ///
  /// In vi, this message translates to:
  /// **'Mở vào {date}'**
  String memLetterEnvelopeDate(String date);

  /// MEM-14 envelope
  ///
  /// In vi, this message translates to:
  /// **'Không hẹn ngày mở'**
  String get memLetterEnvelopeAnytime;

  /// MEM-14 hint
  ///
  /// In vi, this message translates to:
  /// **'Trên dòng thời gian: “💌 Thư của {callName} — mở vào {date}”'**
  String memLetterTimelineHint(String callName, String date);

  /// MEM-14 hint
  ///
  /// In vi, this message translates to:
  /// **'Trên dòng thời gian: “💌 Thư của {callName}”'**
  String memLetterTimelineHintNow(String callName);

  /// MEM-14 button
  ///
  /// In vi, this message translates to:
  /// **'Niêm phong thư'**
  String get memLetterSeal;

  /// MEM-14 default salutation
  ///
  /// In vi, this message translates to:
  /// **'Gửi {child} của {callName},'**
  String memLetterSalutation(String child, String callName);

  /// MEM-14 default sign-off
  ///
  /// In vi, this message translates to:
  /// **'Yêu con,'**
  String get memLetterSignOff;

  /// MEM-15 field
  ///
  /// In vi, this message translates to:
  /// **'Tìm ký ức, câu nói, nhật ký…'**
  String get memSearchHint;

  /// MEM-15 label
  ///
  /// In vi, this message translates to:
  /// **'Gần đây'**
  String get memSearchRecent;

  /// MEM-15 filter
  ///
  /// In vi, this message translates to:
  /// **'Loại'**
  String get memSearchKind;

  /// MEM-15 filter option
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get memSearchKindAll;

  /// MEM-15 filter
  ///
  /// In vi, this message translates to:
  /// **'Người đăng'**
  String get memSearchAuthor;

  /// MEM-15 count
  ///
  /// In vi, this message translates to:
  /// **'{count} kết quả cho “{query}”'**
  String memSearchResults(int count, String query);

  /// MEM-15 section
  ///
  /// In vi, this message translates to:
  /// **'Ảnh & video · {count}'**
  String memSearchMedia(int count);

  /// MEM-15 section
  ///
  /// In vi, this message translates to:
  /// **'Nhật ký · {count}'**
  String memSearchDiaries(int count);

  /// MEM-15 empty
  ///
  /// In vi, this message translates to:
  /// **'Chưa tìm thấy ký ức nào'**
  String get memSearchNoResult;

  /// MEM-16 calendar chip
  ///
  /// In vi, this message translates to:
  /// **'TH {month}'**
  String memOnThisDayMonthShort(int month);

  /// MEM-16 header
  ///
  /// In vi, this message translates to:
  /// **'Ngày {day} tháng {month} của nhà mình'**
  String memOnThisDayHeader(int day, int month);

  /// MEM-16 header
  ///
  /// In vi, this message translates to:
  /// **'{years} năm kỷ niệm · {count} ký ức'**
  String memOnThisDaySummary(int years, int count);

  /// MEM-16 pill
  ///
  /// In vi, this message translates to:
  /// **'{count} năm trước'**
  String memOnThisDayYearsAgo(int count);

  /// MEM-16 year meta
  ///
  /// In vi, this message translates to:
  /// **'{date} · {child} {age}'**
  String memOnThisDayYearMeta(String date, String child, String age);

  /// MEM-16 milestone tag
  ///
  /// In vi, this message translates to:
  /// **'⭐ {title}'**
  String memOnThisDayMilestone(String title);

  /// MEM-16 photo count
  ///
  /// In vi, this message translates to:
  /// **'{count} ảnh'**
  String memOnThisDayPhotos(int count);

  /// MEM-16 quote meta
  ///
  /// In vi, this message translates to:
  /// **'Câu nói của {name} · {age}'**
  String memQuoteOfChild(String name, String age);

  /// MEM-16 button
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ lại với chú thích mới'**
  String get memOnThisDayReshare;

  /// MEM-16 footer
  ///
  /// In vi, this message translates to:
  /// **'Chỉ hiện ký ức bạn có quyền xem · Tắt trong Cài đặt'**
  String get memOnThisDayFooter;

  /// MEM-16 empty
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay chưa có ký ức của những năm trước'**
  String get memOnThisDayEmpty;

  /// REC-02 subtitle
  ///
  /// In vi, this message translates to:
  /// **'Tuần này · {range} · {audience}'**
  String recapWeekRange(String range, String audience);

  /// REC-02 quote meta
  ///
  /// In vi, this message translates to:
  /// **'Câu nói mới của {name} · {age}'**
  String recapQuoteMeta(String name, String age);

  /// REC-02 button
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ với người thân'**
  String get recapShareFamily;

  /// REC-02 plan badge
  ///
  /// In vi, this message translates to:
  /// **'Family'**
  String get recapFamilyBadge;

  /// REC-02 button
  ///
  /// In vi, this message translates to:
  /// **'Lưu vào timeline'**
  String get recapSaveTimeline;

  /// REC-02 button
  ///
  /// In vi, this message translates to:
  /// **'Tải ảnh tổng kết'**
  String get recapDownload;

  /// REC-02 note
  ///
  /// In vi, this message translates to:
  /// **'Bạn xem lại trước khi chia sẻ. Không gồm nội dung Papa & Mama.'**
  String get recapNote;

  /// REC-02 next page
  ///
  /// In vi, this message translates to:
  /// **'Ảnh nổi bật'**
  String get recapNextHighlights;

  /// REC-02 snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã chia sẻ với người thân'**
  String get recapShared;

  /// REC-02 snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu vào timeline'**
  String get recapSaved;

  /// MEM-14 snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã niêm phong thư'**
  String get memLetterSealDone;

  /// US-06 lọc tháng
  ///
  /// In vi, this message translates to:
  /// **'Tháng {month}'**
  String usThanksMonth(String month);

  /// US-06 lọc
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get usThanksAll;

  /// US-06 chú thích
  ///
  /// In vi, this message translates to:
  /// **'Của bạn'**
  String get usThanksMine;

  /// US-06 chú thích
  ///
  /// In vi, this message translates to:
  /// **'Của {callName}'**
  String usThanksPartner(String callName);

  /// US-06
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, other{{count} lời cảm ơn}}'**
  String usThanksCount(int count);

  /// US-06 người gửi/thả tim là tôi
  ///
  /// In vi, this message translates to:
  /// **'Bạn'**
  String get usThanksYou;

  /// US-06 FAB
  ///
  /// In vi, this message translates to:
  /// **'Gửi lời cảm ơn'**
  String get usThanksSendCta;

  /// US-06 tooltip
  ///
  /// In vi, this message translates to:
  /// **'Thả tim'**
  String get usThanksReact;

  /// Thẻ lời cảm ơn: bạn đời đề nghị đăng thành khoảnh khắc gia đình
  ///
  /// In vi, this message translates to:
  /// **'{name} muốn đăng lời cảm ơn này thành khoảnh khắc của cả nhà'**
  String usThanksShareAsk(String name);

  /// Nút duyệt đăng lời cảm ơn lên gia đình
  ///
  /// In vi, this message translates to:
  /// **'Đăng cho cả nhà'**
  String get usThanksShareApprove;

  /// Nút giữ lời cảm ơn riêng hai bố mẹ
  ///
  /// In vi, this message translates to:
  /// **'Để riêng hai mình'**
  String get usThanksShareKeep;

  /// Lỗi khi duyệt/để riêng đề nghị đăng lời cảm ơn
  ///
  /// In vi, this message translates to:
  /// **'Chưa gửi được, thử lại nhé'**
  String get usThanksShareFailed;

  /// US-06 trống
  ///
  /// In vi, this message translates to:
  /// **'Tháng này chưa có lời cảm ơn nào'**
  String get usThanksWallEmpty;

  /// US-07
  ///
  /// In vi, this message translates to:
  /// **'Chỉ mình bạn đọc được'**
  String get usJournalOnlyYou;

  /// US-07
  ///
  /// In vi, this message translates to:
  /// **'{callName} cũng không thấy — trừ khi bạn tự chọn chia sẻ một đoạn.'**
  String usJournalOnlyYouHint(String callName);

  /// US-07
  ///
  /// In vi, this message translates to:
  /// **'Khoá bằng Face ID'**
  String get usJournalFaceId;

  /// US-07
  ///
  /// In vi, this message translates to:
  /// **'Hỏi Face ID mỗi lần mở nhật ký'**
  String get usJournalFaceIdHint;

  /// US-07 nhóm tháng
  ///
  /// In vi, this message translates to:
  /// **'Tháng {month}'**
  String usJournalMonth(String month);

  /// US-07 cảm xúc
  ///
  /// In vi, this message translates to:
  /// **'{mood, select, tired{Mệt} grateful{Biết ơn} worried{Lo lắng} other{Bình yên}}'**
  String usJournalMood(String mood);

  /// US-07
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ đoạn này với bạn đời'**
  String get usJournalShareAction;

  /// US-07
  ///
  /// In vi, this message translates to:
  /// **'Đã chia sẻ 1 đoạn với {callName}'**
  String usJournalShared(String callName);

  /// US-07 FAB
  ///
  /// In vi, this message translates to:
  /// **'Viết trang mới'**
  String get usJournalWrite;

  /// US-07 sheet chia sẻ
  ///
  /// In vi, this message translates to:
  /// **'{callName} sẽ thấy đúng đoạn này:'**
  String usJournalSharePreview(String callName);

  /// US-07
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ với {callName}'**
  String usJournalShareConfirm(String callName);

  /// US-07 sheet viết
  ///
  /// In vi, this message translates to:
  /// **'Trang mới'**
  String get usJournalNewPage;

  /// US-07 sheet viết
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang thấy thế nào?'**
  String get usJournalMoodLabel;

  /// US-07
  ///
  /// In vi, this message translates to:
  /// **'Tiêu đề'**
  String get usJournalTitleLabel;

  /// US-07
  ///
  /// In vi, this message translates to:
  /// **'Điều bạn muốn ghi lại'**
  String get usJournalBodyLabel;

  /// US-07
  ///
  /// In vi, this message translates to:
  /// **'Lưu trang'**
  String get usJournalSave;

  /// US-07 trống
  ///
  /// In vi, this message translates to:
  /// **'Chưa có trang nào. Viết vài dòng cho riêng mình nhé.'**
  String get usJournalEmpty;

  /// US-15
  ///
  /// In vi, this message translates to:
  /// **'Chỉ áp dụng cho bạn · {callName} có cài đặt riêng'**
  String usSettingsScope(String callName);

  /// US-15
  ///
  /// In vi, this message translates to:
  /// **'Khi check-in cảm xúc'**
  String get usSettingsCheckinSection;

  /// US-15
  ///
  /// In vi, this message translates to:
  /// **'{mode, select, askEachTime{Hỏi mỗi lần} alwaysShare{Luôn chia sẻ với {callName}} other{Luôn riêng tư}}'**
  String usSettingsShareMode(String mode, String callName);

  /// US-15
  ///
  /// In vi, this message translates to:
  /// **'{mode, select, askEachTime{Chọn chia sẻ hay giữ riêng sau mỗi lần check-in} alwaysShare{{callName} thấy cảm xúc và những phần bạn tick} other{Chỉ mình bạn xem lại được}}'**
  String usSettingsShareModeHint(String mode, String callName);

  /// US-15
  ///
  /// In vi, this message translates to:
  /// **'Riêng tư'**
  String get usSettingsPrivacySection;

  /// US-15
  ///
  /// In vi, this message translates to:
  /// **'Ẩn nội dung trên màn hình khoá'**
  String get usSettingsHideLock;

  /// US-15
  ///
  /// In vi, this message translates to:
  /// **'Chỉ hiện “Bạn có một cập nhật mới từ Papa & Mama”'**
  String get usSettingsHideLockHint;

  /// US-15
  ///
  /// In vi, this message translates to:
  /// **'Khoá Face ID khi vào Papa & Mama'**
  String get usSettingsFaceId;

  /// US-15
  ///
  /// In vi, this message translates to:
  /// **'Hỏi Face ID mỗi lần mở tab này'**
  String get usSettingsFaceIdHint;

  /// US-15
  ///
  /// In vi, this message translates to:
  /// **'Lời nhờ'**
  String get usSettingsRequestsSection;

  /// US-15
  ///
  /// In vi, this message translates to:
  /// **'Cho phép lời nhờ “Sớm nhé” của {callName} vượt giờ yên tĩnh'**
  String usSettingsUrgentBypass(String callName);

  /// US-15
  ///
  /// In vi, this message translates to:
  /// **'Giờ yên tĩnh của bạn: {from}–{to}. Tắt thì lời nhờ sẽ đến sau giờ yên tĩnh.'**
  String usSettingsUrgentBypassHint(String from, String to);

  /// US-15
  ///
  /// In vi, this message translates to:
  /// **'Cầu nối'**
  String get usSettingsBridgeSection;

  /// US-15
  ///
  /// In vi, this message translates to:
  /// **'Giữ nội dung phiên Cầu nối'**
  String get usSettingsBridgeKeep;

  /// US-15
  ///
  /// In vi, this message translates to:
  /// **'{days, plural, =0{Xoá ngay} other{{days} ngày}}'**
  String usSettingsRetention(int days);

  /// US-15
  ///
  /// In vi, this message translates to:
  /// **'Sau thời gian này, những gì hai bạn viết trong phiên sẽ tự xoá.'**
  String get usSettingsBridgeHint;

  /// US-15
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu'**
  String get usSettingsDataSection;

  /// US-15
  ///
  /// In vi, this message translates to:
  /// **'Xoá lịch sử cảm xúc của tôi'**
  String get usSettingsClearMood;

  /// US-15
  ///
  /// In vi, this message translates to:
  /// **'Xoá mọi check-in bạn đã lưu. Không thể khôi phục.'**
  String get usSettingsClearMoodHint;

  /// US-15 hộp thoại
  ///
  /// In vi, this message translates to:
  /// **'Xoá lịch sử cảm xúc?'**
  String get usSettingsClearMoodConfirm;

  /// US-15 snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã xoá lịch sử cảm xúc'**
  String get usSettingsClearMoodDone;

  /// Nút xoá
  ///
  /// In vi, this message translates to:
  /// **'Xoá'**
  String get commonDelete;

  /// CHD-01
  ///
  /// In vi, this message translates to:
  /// **'Sửa hồ sơ'**
  String get childEditProfile;

  /// CHD-01 tooltip
  ///
  /// In vi, this message translates to:
  /// **'Đổi ảnh bìa'**
  String get childChangeCover;

  /// Tên màu nhận diện bé (kChildPalette)
  ///
  /// In vi, this message translates to:
  /// **'{index, select, 0{Đào} 1{Bạc hà} 2{Trời} 3{Oải hương} 4{Chanh} 5{Hồng} 6{Mơ} other{Ngọc}}'**
  String childColorName(String index);

  /// CHD-03 màu bé
  ///
  /// In vi, this message translates to:
  /// **'Màu {color}'**
  String childColorNamed(String color);

  /// CHD-01
  ///
  /// In vi, this message translates to:
  /// **'ký ức'**
  String get childStatMemories;

  /// CHD-01
  ///
  /// In vi, this message translates to:
  /// **'cột mốc'**
  String get childStatMilestones;

  /// CHD-01
  ///
  /// In vi, this message translates to:
  /// **'thư gửi con'**
  String get childStatLetters;

  /// CHD-01/02
  ///
  /// In vi, this message translates to:
  /// **'Ngày sinh'**
  String get childBirthDate;

  /// CHD-01/02
  ///
  /// In vi, this message translates to:
  /// **'Âm lịch: {date}'**
  String childLunarBirth(String date);

  /// CHD-01/02
  ///
  /// In vi, this message translates to:
  /// **'Giờ sinh'**
  String get childBirthTime;

  /// CHD-01
  ///
  /// In vi, this message translates to:
  /// **'Người thân không thấy giờ sinh'**
  String get childBirthTimeHidden;

  /// CHD-01
  ///
  /// In vi, this message translates to:
  /// **'Người thân thấy giờ sinh'**
  String get childBirthTimeShown;

  /// CHD-01 thai kỳ
  ///
  /// In vi, this message translates to:
  /// **'Ngày dự sinh'**
  String get childDueDate;

  /// CHD-01
  ///
  /// In vi, this message translates to:
  /// **'Thai kỳ gốc'**
  String get childOriginPregnancy;

  /// CHD-01
  ///
  /// In vi, this message translates to:
  /// **'Hành trình thai kỳ · {weeks} tuần'**
  String childOriginPregnancyValue(int weeks);

  /// CHD-01/02
  ///
  /// In vi, this message translates to:
  /// **'Câu chuyện tên'**
  String get childNameStory;

  /// CHD-01
  ///
  /// In vi, this message translates to:
  /// **'{names} đặt'**
  String childNameGivenBy(String names);

  /// Nối hai tên
  ///
  /// In vi, this message translates to:
  /// **'{first} & {second}'**
  String childNamesAnd(String first, String second);

  /// CHD-01
  ///
  /// In vi, this message translates to:
  /// **'{name} thích'**
  String childLikes(String name);

  /// CHD-01/02
  ///
  /// In vi, this message translates to:
  /// **'Món thích'**
  String get childFavFood;

  /// CHD-01/02
  ///
  /// In vi, this message translates to:
  /// **'Đồ chơi'**
  String get childFavToy;

  /// CHD-01/02
  ///
  /// In vi, this message translates to:
  /// **'Bài hát'**
  String get childFavSong;

  /// Đặt trong ngoặc kép
  ///
  /// In vi, this message translates to:
  /// **'“{text}”'**
  String childQuoted(String text);

  /// CHD-01
  ///
  /// In vi, this message translates to:
  /// **'Người thân thấy {name}'**
  String childRelativesSee(String name);

  /// CHD-01
  ///
  /// In vi, this message translates to:
  /// **'Chưa chia sẻ với người thân nào'**
  String get childRelativesNone;

  /// CHD-01
  ///
  /// In vi, this message translates to:
  /// **'Lưu trữ hồ sơ bé'**
  String get childArchiveAction;

  /// CHD-05
  ///
  /// In vi, this message translates to:
  /// **'Lưu trữ hồ sơ của {name}?'**
  String childArchiveConfirmTitle(String name);

  /// CHD-05
  ///
  /// In vi, this message translates to:
  /// **'Ký ức riêng của bé sẽ được ẩn, ký ức chung vẫn còn ở anh chị em. Bạn có thể khôi phục bất cứ lúc nào.'**
  String get childArchiveConfirmBody;

  /// CHD-05
  ///
  /// In vi, this message translates to:
  /// **'Lưu trữ'**
  String get childArchive;

  /// CHD-02
  ///
  /// In vi, this message translates to:
  /// **'Sửa hồ sơ {name}'**
  String childEditTitleNamed(String name);

  /// CHD-02
  ///
  /// In vi, this message translates to:
  /// **'Đổi ảnh đại diện'**
  String get childChangeAvatar;

  /// CHD-02
  ///
  /// In vi, this message translates to:
  /// **'Đổi ảnh bìa timeline'**
  String get childChangeTimelineCover;

  /// CHD-02
  ///
  /// In vi, this message translates to:
  /// **'Tên'**
  String get childFieldName;

  /// CHD-02
  ///
  /// In vi, this message translates to:
  /// **'Tên ở nhà'**
  String get childFieldNickname;

  /// CHD-02
  ///
  /// In vi, this message translates to:
  /// **'Tuổi trên các ký ức sẽ được tính lại theo ngày sinh mới.'**
  String get childBirthDateWarning;

  /// CHD-02
  ///
  /// In vi, this message translates to:
  /// **'Cho người thân thấy giờ sinh'**
  String get childShowBirthTime;

  /// CHD-02
  ///
  /// In vi, this message translates to:
  /// **'Người thân luôn thấy tuổi của bé'**
  String get childShowBirthTimeHint;

  /// CHD-02
  ///
  /// In vi, this message translates to:
  /// **'Màu nhận diện'**
  String get childColorLabel;

  /// CHD-02
  ///
  /// In vi, this message translates to:
  /// **'Màu {color} đang dùng cho {name}'**
  String childColorUsedBy(String color, String name);

  /// CHD-02
  ///
  /// In vi, this message translates to:
  /// **'Ai đặt:'**
  String get childNameGivenByLabel;

  /// CHD-02
  ///
  /// In vi, this message translates to:
  /// **'+ Khác'**
  String get childNameGivenByOther;

  /// CHD-02
  ///
  /// In vi, this message translates to:
  /// **'Sở thích'**
  String get childLikesSection;

  /// CHD-02
  ///
  /// In vi, this message translates to:
  /// **'Lưu thay đổi'**
  String get childSaveChanges;

  /// CHD-03
  ///
  /// In vi, this message translates to:
  /// **'Giữ và kéo để sắp xếp thứ tự hiển thị'**
  String get childrenReorderHint;

  /// CHD-03
  ///
  /// In vi, this message translates to:
  /// **'Thai #{number}'**
  String childPregnancyTag(int number);

  /// CHD-03
  ///
  /// In vi, this message translates to:
  /// **'dự sinh {date}'**
  String childDueShort(String date);

  /// CHD-03
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu trữ ({count})'**
  String childrenArchived(int count);

  /// CHD-03
  ///
  /// In vi, this message translates to:
  /// **'Lưu trữ {date}'**
  String childArchivedOn(String date);

  /// CHD-03
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, other{{count} ký ức riêng}}'**
  String childPrivateMemories(int count);

  /// CHD-03
  ///
  /// In vi, this message translates to:
  /// **'Khôi phục'**
  String get childRestore;

  /// CHD-03
  ///
  /// In vi, this message translates to:
  /// **'Bé đã lưu trữ được ẩn khỏi bộ chuyển bé. Có thể xoá vĩnh viễn sau khi lưu trữ đủ {days} ngày.'**
  String childrenArchiveNote(int days);

  /// CHD-04
  ///
  /// In vi, this message translates to:
  /// **'Bé mới sẽ vào gia đình {family}. Hồ sơ của {names} giữ nguyên.'**
  String childAddSubtitle(String family, String names);

  /// Nối danh sách tên
  ///
  /// In vi, this message translates to:
  /// **'{rest} và {last}'**
  String childNamesList(String rest, String last);

  /// CHD-04
  ///
  /// In vi, this message translates to:
  /// **'Bé đã chào đời'**
  String get childAddBorn;

  /// CHD-04
  ///
  /// In vi, this message translates to:
  /// **'Thêm hồ sơ với tên và ngày sinh của bé'**
  String get childAddBornHint;

  /// CHD-04
  ///
  /// In vi, this message translates to:
  /// **'Nhà mình đang mong bé'**
  String get childAddExpecting;

  /// CHD-04
  ///
  /// In vi, this message translates to:
  /// **'Tạo hành trình thai kỳ mới (Thai #{number})'**
  String childAddExpectingHint(int number);

  /// CHD-04
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ: Bin, Mít, Su…'**
  String get childNameHint;

  /// CHD-04
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngày sinh'**
  String get childBirthDateHint;

  /// CHD-04
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngày dự sinh'**
  String get childDueDateHint;

  /// CHD-04
  ///
  /// In vi, this message translates to:
  /// **'Giới tính (tuỳ chọn)'**
  String get childGenderOptional;

  /// CHD-04
  ///
  /// In vi, this message translates to:
  /// **'{gender, select, boy{Bé trai} girl{Bé gái} other{Không nêu}}'**
  String childGender(String gender);

  /// CHD-04
  ///
  /// In vi, this message translates to:
  /// **'Sau khi thêm, bạn có thể chọn chia sẻ bé với từng người thân. Mặc định chưa chia sẻ với ai.'**
  String get childAddShareNote;

  /// MEM-15 year filter sheet title
  ///
  /// In vi, this message translates to:
  /// **'Năm'**
  String get memSearchYear;

  /// Two meta parts
  ///
  /// In vi, this message translates to:
  /// **'{first} · {second}'**
  String memDotMeta2(String first, String second);

  /// Ngày âm có năm can chi (11/03 Ất Tỵ)
  ///
  /// In vi, this message translates to:
  /// **'{day}/{month} {year}'**
  String childLunarDateYear(String day, String month, String year);

  /// CARE-09 nút ⋯
  ///
  /// In vi, this message translates to:
  /// **'Thêm'**
  String get careMoreMenu;

  /// CARE-09 menu
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử nhiệm vụ'**
  String get careMenuHistory;

  /// SET-09b partner subtitle
  ///
  /// In vi, this message translates to:
  /// **'{callName} · Quản lý gia đình'**
  String setDelPartnerRole(String callName);

  /// MEM-22 albums card subtitle
  ///
  /// In vi, this message translates to:
  /// **'{count} album'**
  String memAlbumCount(int count);

  /// US-09 title
  ///
  /// In vi, this message translates to:
  /// **'Viết lại nhẹ nhàng'**
  String get usBridgeRewriteTitle;

  /// US-12 title
  ///
  /// In vi, this message translates to:
  /// **'Một bước nhỏ tiếp theo'**
  String get usBridgeNextStepTitle;

  /// US-13 title
  ///
  /// In vi, this message translates to:
  /// **'Hỗ trợ an toàn'**
  String get usSafetyTitle;

  /// REC-01 title
  ///
  /// In vi, this message translates to:
  /// **'Câu chuyện ngày'**
  String get recapDayTitle;

  /// REC-03 title
  ///
  /// In vi, this message translates to:
  /// **'Tháng tuổi'**
  String get recapMonthTitle;

  /// CARE-11 title
  ///
  /// In vi, this message translates to:
  /// **'Thống kê'**
  String get careStatsTitle;

  /// CARE-09 thống kê — chưa có dữ liệu
  ///
  /// In vi, this message translates to:
  /// **'Tuần này chưa có thống kê'**
  String get careStatsEmpty;

  /// MEM-17 title
  ///
  /// In vi, this message translates to:
  /// **'Thùng rác'**
  String get memTrashTitle;

  /// MEM-18 title
  ///
  /// In vi, this message translates to:
  /// **'Nháp'**
  String get memDraftsTitle;

  /// MEM-19 title
  ///
  /// In vi, this message translates to:
  /// **'Chờ duyệt'**
  String get memPendingTitle;

  /// CHD-05 title
  ///
  /// In vi, this message translates to:
  /// **'Lưu trữ hoặc xoá bé'**
  String get childArchiveTitle;

  /// Circle tab bar
  ///
  /// In vi, this message translates to:
  /// **'Cháu yêu'**
  String get circleTabHome;

  /// Circle tab bar
  ///
  /// In vi, this message translates to:
  /// **'Ký ức'**
  String get circleTabMemories;

  /// Circle tab bar
  ///
  /// In vi, this message translates to:
  /// **'Đăng ảnh'**
  String get circleTabPost;

  /// Circle tab bar
  ///
  /// In vi, this message translates to:
  /// **'Tôi'**
  String get circleTabMe;

  /// CIR-04 title
  ///
  /// In vi, this message translates to:
  /// **'Đăng ảnh cho cháu'**
  String get circlePostTitle;

  /// CIR-03 title
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết ký ức'**
  String get circleMemoryDetailTitle;

  /// CIR-05 title
  ///
  /// In vi, this message translates to:
  /// **'Gia đình tạm dừng chia sẻ'**
  String get circlePausedTitle;

  /// SET-10 title
  ///
  /// In vi, this message translates to:
  /// **'Rời gia đình'**
  String get circleLeaveTitle;

  /// SUB-03 title
  ///
  /// In vi, this message translates to:
  /// **'Gói của gia đình'**
  String get billingPlanTitle;

  /// FAM-02 title
  ///
  /// In vi, this message translates to:
  /// **'Mời bạn đời cùng tham gia'**
  String get familyInvitePartnerTitle;

  /// FAM-05 title
  ///
  /// In vi, this message translates to:
  /// **'Lời mời đang chờ'**
  String get familyPendingInvitesTitle;

  /// SET-13 title
  ///
  /// In vi, this message translates to:
  /// **'Người bị chặn'**
  String get settingsBlockedTitle;

  /// SUB-03 status pill
  ///
  /// In vi, this message translates to:
  /// **'Đang hoạt động'**
  String get subPlanActive;

  /// SUB-03 info label
  ///
  /// In vi, this message translates to:
  /// **'Gia hạn tự động'**
  String get subPlanAutoRenew;

  /// SUB-03 info label
  ///
  /// In vi, this message translates to:
  /// **'Người thanh toán'**
  String get subPlanPayer;

  /// SUB-03 info label
  ///
  /// In vi, this message translates to:
  /// **'Kênh mua'**
  String get subPlanChannel;

  /// SUB-03 info label
  ///
  /// In vi, this message translates to:
  /// **'Áp dụng cho'**
  String get subPlanAppliesTo;

  /// SUB-03 applies-to value
  ///
  /// In vi, this message translates to:
  /// **'Cả {family}'**
  String subPlanWholeFamily(String family);

  /// Storage amount in GB
  ///
  /// In vi, this message translates to:
  /// **'{value} GB'**
  String subPlanGb(String value);

  /// SUB-03 storage caption
  ///
  /// In vi, this message translates to:
  /// **'đã dùng / {total} GB'**
  String subPlanUsedOf(String total);

  /// SUB-03 storage legend
  ///
  /// In vi, this message translates to:
  /// **'{kind, select, photo{Ảnh} video{Video} audio{Âm thanh} other{Khác}} · {size} GB'**
  String subPlanStorageKind(String kind, String size);

  /// SUB-03 section
  ///
  /// In vi, this message translates to:
  /// **'Trong gói của nhà mình'**
  String get subPlanIncluded;

  /// SUB-03 usage row
  ///
  /// In vi, this message translates to:
  /// **'Người thân'**
  String get subPlanRelatives;

  /// Used/max counter
  ///
  /// In vi, this message translates to:
  /// **'{used}/{max}'**
  String subPlanSlots(int used, int max);

  /// SUB-03 usage row
  ///
  /// In vi, this message translates to:
  /// **'Lượt AI tháng này'**
  String get subPlanAi;

  /// SUB-03 AI reset date
  ///
  /// In vi, this message translates to:
  /// **'Làm mới vào {date}'**
  String subPlanAiRenews(String date);

  /// SUB-03 AI remaining
  ///
  /// In vi, this message translates to:
  /// **'Còn {remaining}/{total}'**
  String subPlanAiLeft(int remaining, int total);

  /// SUB-03 usage row
  ///
  /// In vi, this message translates to:
  /// **'Video tối đa'**
  String get subPlanVideo;

  /// SUB-03 usage hint
  ///
  /// In vi, this message translates to:
  /// **'Ảnh gốc · {count} ảnh mỗi ký ức'**
  String subPlanVideoHint(int count);

  /// SUB-03 usage hint (no original quality)
  ///
  /// In vi, this message translates to:
  /// **'{count} ảnh mỗi ký ức'**
  String subPlanVideoHintCompressed(int count);

  /// Minutes value
  ///
  /// In vi, this message translates to:
  /// **'{count} phút'**
  String subPlanMinutes(int count);

  /// SUB-03 primary button
  ///
  /// In vi, this message translates to:
  /// **'Quản lý trong {channel}'**
  String subPlanManageStore(String channel);

  /// SUB-03 secondary button
  ///
  /// In vi, this message translates to:
  /// **'Đổi gói'**
  String get subPlanChange;

  /// SUB-03 note
  ///
  /// In vi, this message translates to:
  /// **'Gói nằm trong tài khoản {channel} của {payer} nên chỉ {payer} đổi hoặc huỷ được. {partner} sẽ thấy hướng dẫn nhờ {payer}. Huỷ bất kỳ lúc nào trong cài đặt {channel} — ký ức của nhà mình không bị xoá.'**
  String subPlanNote(String channel, String payer, String partner);

  /// SUB-03/06 mock store snackbar
  ///
  /// In vi, this message translates to:
  /// **'Bản mẫu: trang quản lý gói của {channel} chỉ được mô phỏng.'**
  String subManageStoreMock(String channel);

  /// SUB-04 title
  ///
  /// In vi, this message translates to:
  /// **'Nâng cấp lên Family để mời ông bà'**
  String get subUpgradeTitle;

  /// SUB-04 subtitle
  ///
  /// In vi, this message translates to:
  /// **'Nhà mình đang dùng gói House · {payer} thanh toán qua {channel}. Family mở thêm ông bà, người thân và dung lượng lớn hơn.'**
  String subUpgradeSubtitle(String payer, String channel);

  /// SUB-04 compare row
  ///
  /// In vi, this message translates to:
  /// **'Ông bà, người thân'**
  String get subCmpRelatives;

  /// SUB-04 compare row
  ///
  /// In vi, this message translates to:
  /// **'Ảnh mỗi ký ức'**
  String get subCmpPhotos;

  /// SUB-04 compare row
  ///
  /// In vi, this message translates to:
  /// **'Video'**
  String get subCmpVideo;

  /// SUB-04 compare row
  ///
  /// In vi, this message translates to:
  /// **'Ghi âm'**
  String get subCmpVoice;

  /// SUB-04 compare row
  ///
  /// In vi, this message translates to:
  /// **'Lưu ảnh chất lượng gốc'**
  String get subCmpOriginal;

  /// SUB-04 compare row
  ///
  /// In vi, this message translates to:
  /// **'Lượt AI mỗi tháng'**
  String get subCmpAi;

  /// SUB-04 compare row
  ///
  /// In vi, this message translates to:
  /// **'Bản tin, duyệt ảnh người thân'**
  String get subCmpDigest;

  /// SUB-04 not included
  ///
  /// In vi, this message translates to:
  /// **'—'**
  String get subCmpNone;

  /// SUB-04 included
  ///
  /// In vi, this message translates to:
  /// **'Có'**
  String get subCmpYes;

  /// SUB-04 relatives value
  ///
  /// In vi, this message translates to:
  /// **'Tối đa {count}'**
  String subCmpUpTo(int count);

  /// SUB-04 max minutes
  ///
  /// In vi, this message translates to:
  /// **'≤ {count} phút'**
  String subCmpMaxMinutes(int count);

  /// SUB-04 price label
  ///
  /// In vi, this message translates to:
  /// **'Hiện tại'**
  String get subUpgradeCurrent;

  /// SUB-04 prorate note
  ///
  /// In vi, this message translates to:
  /// **'Nâng cấp có hiệu lực ngay. {channel} tự tính phần chênh lệch cho thời gian còn lại của gói House — bạn không phải trả lại cả năm.'**
  String subUpgradeProrate(String channel);

  /// SUB-04 button
  ///
  /// In vi, this message translates to:
  /// **'Nâng cấp lên Family · {price}'**
  String subUpgradeCta(String price);

  /// SUB-04 legal
  ///
  /// In vi, this message translates to:
  /// **'Tự động gia hạn hằng năm, huỷ bất kỳ lúc nào trong cài đặt App Store. Điều khoản · Quyền riêng tư · Khôi phục giao dịch'**
  String get subUpgradeLegal;

  /// SUB-04 non-payer preview label
  ///
  /// In vi, this message translates to:
  /// **'{partner} sẽ thấy (không phải người thanh toán)'**
  String subUpgradeNotPayerLabel(String partner);

  /// SUB-04 non-payer preview body
  ///
  /// In vi, this message translates to:
  /// **'Gói House đang do {payer} thanh toán. Để tránh trả 2 lần, hãy nhờ {payer} nâng cấp.'**
  String subUpgradeNotPayerBody(String payer);

  /// SUB-04 non-payer button
  ///
  /// In vi, this message translates to:
  /// **'Gửi lời nhắn cho {payer}'**
  String subUpgradeAskPayer(String payer);

  /// SUB-04 snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi lời nhắn cho {payer}'**
  String subUpgradeAskSent(String payer);

  /// SUB-02 title
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận gói {plan}'**
  String subConfirmTitle(String plan);

  /// SUB-02 subtitle (Family)
  ///
  /// In vi, this message translates to:
  /// **'Cho cả {family} · {papa}, {mama} và người thân'**
  String subConfirmAudienceFamily(String family, String papa, String mama);

  /// SUB-02 subtitle (House)
  ///
  /// In vi, this message translates to:
  /// **'Cho cả {family} · {papa} & {mama}'**
  String subConfirmAudienceHouse(String family, String papa, String mama);

  /// SUB-02 row
  ///
  /// In vi, this message translates to:
  /// **'Giá'**
  String get subConfirmPrice;

  /// SUB-02 row
  ///
  /// In vi, this message translates to:
  /// **'Quy đổi'**
  String get subConfirmMonthly;

  /// SUB-02 row
  ///
  /// In vi, this message translates to:
  /// **'Chu kỳ'**
  String get subConfirmCycle;

  /// SUB-02 value
  ///
  /// In vi, this message translates to:
  /// **'1 năm · tự động gia hạn'**
  String get subConfirmCycleValue;

  /// SUB-02 row
  ///
  /// In vi, this message translates to:
  /// **'Hiệu lực'**
  String get subConfirmEffective;

  /// SUB-02 value
  ///
  /// In vi, this message translates to:
  /// **'Ngay khi App Store xác nhận'**
  String get subConfirmEffectiveValue;

  /// SUB-02 row
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán qua'**
  String get subConfirmPayVia;

  /// SUB-02 value
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản App Store của bạn'**
  String get subConfirmPayViaValue;

  /// SUB-02 point
  ///
  /// In vi, this message translates to:
  /// **'Mời ngay tối đa {count} ông bà, người thân'**
  String subConfirmRelatives(int count);

  /// SUB-02 point
  ///
  /// In vi, this message translates to:
  /// **'{storage} GB · video ≤ {video} phút{original, select, yes{ · lưu ảnh gốc} other{}}'**
  String subConfirmLimits(int storage, int video, String original);

  /// SUB-02 point
  ///
  /// In vi, this message translates to:
  /// **'Thời gian dùng thử còn lại không cộng dồn — chu kỳ năm tính từ hôm nay'**
  String get subConfirmTrialNote;

  /// SUB-02 button
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục với App Store'**
  String get subConfirmCta;

  /// SUB-02 legal
  ///
  /// In vi, this message translates to:
  /// **'Bước tiếp theo là bảng thanh toán của App Store. Tự động gia hạn hằng năm, huỷ bất kỳ lúc nào trong cài đặt App Store.'**
  String get subConfirmLegal;

  /// SUB-02 link
  ///
  /// In vi, this message translates to:
  /// **'Điều khoản'**
  String get subLinkTerms;

  /// SUB-05 title
  ///
  /// In vi, this message translates to:
  /// **'Video này dài {minutes} phút'**
  String subLimitVideoTitle(int minutes);

  /// SUB-05 body
  ///
  /// In vi, this message translates to:
  /// **'{plan} lưu được video tối đa {max} phút mỗi video. Bạn có thể cắt ngắn lại, hoặc giữ khoảnh khắc này bằng lời kể.'**
  String subLimitVideoBody(String plan, int max);

  /// SUB-05 safe note
  ///
  /// In vi, this message translates to:
  /// **'Ký ức của bạn vẫn an toàn — chưa có gì bị xoá, nội dung đang soạn vẫn được giữ nguyên.'**
  String get subLimitSafe;

  /// SUB-05 primary
  ///
  /// In vi, this message translates to:
  /// **'Cắt video còn {max} phút'**
  String subLimitTrim(int max);

  /// SUB-05 secondary
  ///
  /// In vi, this message translates to:
  /// **'Chọn video khác'**
  String get subLimitPickAnother;

  /// SUB-05 text button
  ///
  /// In vi, this message translates to:
  /// **'Lưu dạng nhật ký chữ'**
  String get subLimitSaveDiary;

  /// SUB-05 plan note
  ///
  /// In vi, this message translates to:
  /// **'Nhà mình đang dùng gói cao nhất (Family) nên không cần nâng cấp thêm.'**
  String get subLimitTopPlan;

  /// SUB-05 upgrade link (House/trial)
  ///
  /// In vi, this message translates to:
  /// **'Nâng cấp lên Family'**
  String get subLimitUpgrade;

  /// SUB-05 snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã cắt video còn {max} phút'**
  String subLimitTrimmed(int max);

  /// SUB-05 giới hạn gói theo mã lỗi server
  ///
  /// In vi, this message translates to:
  /// **'{reason, select, QUOTA_STORAGE_EXCEEDED{Đã dùng hết dung lượng của gói} QUOTA_PHOTOS_PER_MEMORY{Quá số ảnh cho một ký ức} other{Đã đạt số ký ức của gói}}'**
  String subLimitQuotaTitle(String reason);

  /// SUB-05 giới hạn gói theo mã lỗi server
  ///
  /// In vi, this message translates to:
  /// **'{reason, select, QUOTA_PHOTOS_PER_MEMORY{{plan} giới hạn số ảnh mỗi ký ức. Bớt vài ảnh rồi lưu lại, hoặc nâng cấp để thêm nhiều ảnh hơn.} other{{plan} đã chạm giới hạn này. Giữ bản đang soạn làm nháp, hoặc nâng cấp để lưu tiếp.}}'**
  String subLimitQuotaBody(String reason, String plan);

  /// SUB-05 giới hạn gói theo mã lỗi server
  ///
  /// In vi, this message translates to:
  /// **'Lưu thành nháp'**
  String get subLimitKeepDraft;

  /// SUB-06 banner title
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán gia hạn chưa thành công'**
  String get subIssueTitle;

  /// SUB-06 banner body
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra phương thức thanh toán để không gián đoạn. {plan} của nhà mình vẫn hoạt động trong lúc này.'**
  String subIssueBody(String plan);

  /// SUB-06 banner action
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra trong App Store'**
  String get subIssueAction;

  /// INV-02 tip
  ///
  /// In vi, this message translates to:
  /// **'Nhắn cho người đã mời bạn (Bố/Mẹ của bé) để họ tạo lời mời mới.'**
  String get invInvalidTipMessage;

  /// INV-02 tip
  ///
  /// In vi, this message translates to:
  /// **'Nếu đã có mã 8 ký tự mới, bạn có thể nhập mã ngay.'**
  String get invInvalidTipCode;

  /// INV-02 primary
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã mời khác'**
  String get invEnterOtherCode;

  /// INV-03 title
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang là {callName} ở một gia đình khác'**
  String invElsewhereTitle(String callName);

  /// INV-03 body
  ///
  /// In vi, this message translates to:
  /// **'Mỗi tài khoản chỉ là Bố/Mẹ của một gia đình, nên bạn chưa thể nhận lời mời này.'**
  String get invElsewhereBody;

  /// INV-03 invite card
  ///
  /// In vi, this message translates to:
  /// **'{inviter} mời bạn tham gia {family}'**
  String invElsewhereInvite(String inviter, String family);

  /// INV-03 invite card
  ///
  /// In vi, this message translates to:
  /// **'Vai trò đề xuất: {callName} của các bé'**
  String invElsewhereRole(String callName);

  /// INV-03 disabled option
  ///
  /// In vi, this message translates to:
  /// **'Tham gia như người thân'**
  String get invElsewhereJoinRelative;

  /// INV-03 disabled option hint
  ///
  /// In vi, this message translates to:
  /// **'Không khả dụng — lời mời này dành cho Bố/Mẹ. Nhờ {inviter} gửi lời mời người thân nếu bạn muốn xem các bé.'**
  String invElsewhereJoinRelativeHint(String inviter);

  /// INV-03 option
  ///
  /// In vi, this message translates to:
  /// **'Tìm hiểu cách rời gia đình hiện tại'**
  String get invElsewhereLeave;

  /// INV-03 option hint
  ///
  /// In vi, this message translates to:
  /// **'Các lựa chọn cho Bố/Mẹ và cách nhờ hỗ trợ'**
  String get invElsewhereLeaveHint;

  /// INV-04 title
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi yêu cầu'**
  String get invWaitingTitle;

  /// INV-04 body
  ///
  /// In vi, this message translates to:
  /// **'{inviter} sẽ xác nhận để hoàn tất. Bạn có thể đóng app — mình sẽ báo ngay khi xong.'**
  String invWaitingBody(String inviter);

  /// INV-04 step
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã nhận lời mời vào {family}'**
  String invWaitingStepJoined(String family);

  /// INV-04 step hint
  ///
  /// In vi, this message translates to:
  /// **'Vai trò: {callName} của các bé'**
  String invWaitingStepRole(String callName);

  /// INV-04 step
  ///
  /// In vi, this message translates to:
  /// **'Chờ {inviter} xác nhận'**
  String invWaitingStepConfirm(String inviter);

  /// INV-04 step hint
  ///
  /// In vi, this message translates to:
  /// **'{inviter} bật “xác nhận lần cuối” để chắc đúng người'**
  String invWaitingStepConfirmHint(String inviter);

  /// INV-04 step; {days} = thời lượng trial policy
  ///
  /// In vi, this message translates to:
  /// **'Nhà mình bắt đầu {days} ngày dùng thử miễn phí'**
  String invWaitingStepTrial(int days);

  /// INV-04 notice
  ///
  /// In vi, this message translates to:
  /// **'Bạn sẽ nhận thông báo “Chào mừng về nhà!”'**
  String get invWaitingNotice;

  /// FAM-02 banner
  ///
  /// In vi, this message translates to:
  /// **'{partner} đã rời {family} (xoá tài khoản). Nhà mình đang ở chế độ chỉ xem & tải về cho tới khi có bạn đời mới.'**
  String famPartnerLeftBanner(String partner, String family);

  /// FAM-02 subtitle
  ///
  /// In vi, this message translates to:
  /// **'Khi bạn đời tham gia, cả nhà lại cùng tạo ký ức, nhiệm vụ và góc Papa & Mama như trước.'**
  String get famPartnerInviteSubtitle;

  /// FAM-02 role label
  ///
  /// In vi, this message translates to:
  /// **'Mời với vai trò'**
  String get famPartnerInviteRole;

  /// FAM-02 preview title
  ///
  /// In vi, this message translates to:
  /// **'Người nhận sẽ thấy trước khi tham gia'**
  String get famPartnerRecipientSees;

  /// FAM-02 preview hint
  ///
  /// In vi, this message translates to:
  /// **'Lời mời từ {name} ({callName}) · chỉ tên và ảnh đại diện các bé'**
  String famPartnerRecipientHint(String name, String callName);

  /// FAM-02 revoke
  ///
  /// In vi, this message translates to:
  /// **'Thu hồi lời mời'**
  String get famPartnerRevoke;

  /// FAM-02 snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã thu hồi lời mời'**
  String get famPartnerRevoked;

  /// FAM-05 capacity
  ///
  /// In vi, this message translates to:
  /// **'Người thân {family}: {active} đang tham gia · {pending} đang chờ'**
  String famInvitesCapacity(String family, int active, int pending);

  /// FAM-05 section
  ///
  /// In vi, this message translates to:
  /// **'Đang chờ'**
  String get famInvitesPending;

  /// FAM-05 section
  ///
  /// In vi, this message translates to:
  /// **'Đã hết hạn'**
  String get famInvitesExpired;

  /// FAM-05 status
  ///
  /// In vi, this message translates to:
  /// **'Chưa mở link'**
  String get famInviteNotOpened;

  /// FAM-05 status
  ///
  /// In vi, this message translates to:
  /// **'Đã mở link'**
  String get famInviteOpened;

  /// FAM-05 status
  ///
  /// In vi, this message translates to:
  /// **'Hết hạn'**
  String get famInviteExpiredTag;

  /// FAM-05 description
  ///
  /// In vi, this message translates to:
  /// **'Lời mời người thân'**
  String get famInviteKindRelative;

  /// FAM-05/08 permission
  ///
  /// In vi, this message translates to:
  /// **'Xem'**
  String get famInvitePermView;

  /// FAM-05/08 permission
  ///
  /// In vi, this message translates to:
  /// **'Xem + Bình luận'**
  String get famInvitePermComment;

  /// FAM-05 permission
  ///
  /// In vi, this message translates to:
  /// **'Xem + Bình luận + Đăng ảnh'**
  String get famInvitePermPost;

  /// FAM-05 dates
  ///
  /// In vi, this message translates to:
  /// **'Tạo {created} · hết hạn {expires} · {daysLeft}'**
  String famInviteDates(String created, String expires, String daysLeft);

  /// FAM-05 days left
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =0{hết hạn hôm nay} other{còn {count} ngày}}'**
  String famInviteDaysLeft(int count);

  /// FAM-05 expired date
  ///
  /// In vi, this message translates to:
  /// **'Hết hạn {date} · link không còn mở được'**
  String famInviteExpiredOn(String date);

  /// FAM-05 action
  ///
  /// In vi, this message translates to:
  /// **'Gửi lại link'**
  String get famInviteResend;

  /// FAM-05 action
  ///
  /// In vi, this message translates to:
  /// **'Thu hồi'**
  String get famInviteRevoke;

  /// FAM-05 action
  ///
  /// In vi, this message translates to:
  /// **'Tạo lời mời mới'**
  String get famInviteRenew;

  /// FAM-05 snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi lại link cho {callName}'**
  String famInviteResent(String callName);

  /// FAM-05 snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã thu hồi lời mời của {callName}'**
  String famInviteRevokedName(String callName);

  /// FAM-05 snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã tạo lời mời mới cho {callName}'**
  String famInviteRenewed(String callName);

  /// FAM-05 rules
  ///
  /// In vi, this message translates to:
  /// **'Lời mời người thân hết hạn sau 14 ngày và chỉ dùng 1 lần. Thu hồi để link cũ không mở được nữa. Tối đa 12 người thân, tính cả lời mời đang chờ.'**
  String get famInvitesRules;

  /// FAM-05 button
  ///
  /// In vi, this message translates to:
  /// **'Mời thêm người thân'**
  String get famInviteMore;

  /// FAM-05 empty
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lời mời nào đang chờ'**
  String get famInvitesEmpty;

  /// FAM-08 title
  ///
  /// In vi, this message translates to:
  /// **'Chuyển gia đình'**
  String get famSwitchTitle;

  /// FAM-08 subtitle
  ///
  /// In vi, this message translates to:
  /// **'Bạn là {callName} ở {family} và là người thân ở một gia đình khác.'**
  String famSwitchSubtitle(String callName, String family);

  /// FAM-08 role pill
  ///
  /// In vi, this message translates to:
  /// **'{callName} (Bố/Mẹ)'**
  String famSwitchRoleParent(String callName);

  /// FAM-08 role pill
  ///
  /// In vi, this message translates to:
  /// **'{callName} (người thân)'**
  String famSwitchRoleRelative(String callName);

  /// FAM-08 current marker
  ///
  /// In vi, this message translates to:
  /// **'đang xem'**
  String get famSwitchViewing;

  /// FAM-08 relative line
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi bé {names}'**
  String famSwitchFollows(String names);

  /// FAM-08 note
  ///
  /// In vi, this message translates to:
  /// **'Chuyển gia đình sẽ đổi toàn bộ app theo gia đình được chọn. Ở {family}, bạn chỉ thấy ảnh của bé được chia sẻ — không có Chăm con hay Papa & Mama. Mỗi tài khoản chỉ là Bố/Mẹ của một gia đình.'**
  String famSwitchNote(String family);

  /// FAM-08 mock snackbar
  ///
  /// In vi, this message translates to:
  /// **'Bản mẫu chỉ có dữ liệu của {family}.'**
  String famSwitchMock(String family);

  /// SET-05 master
  ///
  /// In vi, this message translates to:
  /// **'Dùng AI hỗ trợ'**
  String get setAiMaster;

  /// SET-05 master hint
  ///
  /// In vi, this message translates to:
  /// **'AI chỉ chạy khi bạn bấm. Mọi kết quả là bản nháp để bạn sửa, bỏ hoặc lưu.'**
  String get setAiMasterHint;

  /// SET-05 quota
  ///
  /// In vi, this message translates to:
  /// **'Lượt AI còn lại tháng này'**
  String get setAiQuotaLabel;

  /// SET-05 quota total
  ///
  /// In vi, this message translates to:
  /// **'/ {total} lượt'**
  String setAiQuotaTotal(int total);

  /// SET-05 reset
  ///
  /// In vi, this message translates to:
  /// **'Làm mới {date}'**
  String setAiRenews(String date);

  /// SET-05 quota footer
  ///
  /// In vi, this message translates to:
  /// **'{plan} · {total} lượt mỗi tháng cho cả nhà'**
  String setAiPlanQuota(String plan, int total);

  /// SET-05 section
  ///
  /// In vi, this message translates to:
  /// **'Từng tính năng'**
  String get setAiFeatures;

  /// SET-05 section
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu gửi đi'**
  String get setAiDataSection;

  /// SET-05 data point
  ///
  /// In vi, this message translates to:
  /// **'Chỉ gửi những gì ghi ở từng tính năng, cho đúng lần bạn bấm.'**
  String get setAiData1;

  /// SET-05 data point
  ///
  /// In vi, this message translates to:
  /// **'AI không đọc nhật ký riêng, không chẩn đoán, không tự gửi tin cho ai.'**
  String get setAiData2;

  /// SET-05 data point
  ///
  /// In vi, this message translates to:
  /// **'Lần đầu dùng mỗi tính năng, app hỏi bạn đồng ý trước.'**
  String get setAiData3;

  /// SET-05 data point
  ///
  /// In vi, this message translates to:
  /// **'Mọi bản nháp đều có nhãn “✨ Gợi ý bởi AI”.'**
  String get setAiData4;

  /// SET-05 link
  ///
  /// In vi, this message translates to:
  /// **'Xem chi tiết dữ liệu gửi cho nhà cung cấp AI'**
  String get setAiDataLink;

  /// SET-05 row
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo nội dung AI'**
  String get setAiReport;

  /// SET-05 footer
  ///
  /// In vi, this message translates to:
  /// **'Tắt AI, Baby Family vẫn dùng đầy đủ mọi tính năng.'**
  String get setAiFoot;

  /// SET-13 body
  ///
  /// In vi, this message translates to:
  /// **'Người bị chặn không bình luận hay thả cảm xúc vào nội dung của bạn, và bạn không nhận thông báo liên quan đến họ.'**
  String get setBlockedBody;

  /// SET-13 section
  ///
  /// In vi, this message translates to:
  /// **'Đang chặn · {count} người'**
  String setBlockedSection(int count);

  /// SET-13 row
  ///
  /// In vi, this message translates to:
  /// **'Chặn từ {date}'**
  String setBlockedSince(String date);

  /// SET-13 button
  ///
  /// In vi, this message translates to:
  /// **'Bỏ chặn'**
  String get setUnblock;

  /// SET-13 snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã bỏ chặn {name}'**
  String setUnblocked(String name);

  /// SET-13 info
  ///
  /// In vi, this message translates to:
  /// **'Sau khi bỏ chặn, người này có thể bình luận và thả cảm xúc vào nội dung của bạn như trước. Bạn có thể chặn lại bất cứ lúc nào từ trang của họ.'**
  String get setUnblockInfo;

  /// SET-13 partner note
  ///
  /// In vi, this message translates to:
  /// **'Papa và Mama không chặn nhau trong app. Nếu cần khoảng lặng, bạn có thể tắt chia sẻ cảm xúc trong Papa & Mama.'**
  String get setBlockedPartnerNote;

  /// SET-13 empty
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa chặn ai'**
  String get setBlockedEmpty;

  /// Delete permanently (MEM-17, CHD-05)
  ///
  /// In vi, this message translates to:
  /// **'Xoá vĩnh viễn'**
  String get commonDeleteForever;

  /// MEM-17 info
  ///
  /// In vi, this message translates to:
  /// **'Ký ức đã xoá được giữ {days} ngày rồi mới xoá hẳn. Bạn thấy mọi ký ức bị xoá trong gia đình.'**
  String memTrashInfo(int days);

  /// MEM-17 info for relatives
  ///
  /// In vi, this message translates to:
  /// **'Ký ức đã xoá được giữ {days} ngày rồi mới xoá hẳn. Bạn thấy những ký ức bạn đã xoá.'**
  String memTrashInfoOwn(int days);

  /// MEM-17 section
  ///
  /// In vi, this message translates to:
  /// **'{count} ký ức'**
  String memTrashCount(int count);

  /// MEM-17 who deleted
  ///
  /// In vi, this message translates to:
  /// **'{callName} xoá {date} ·'**
  String memTrashDeletedBy(String callName, String date);

  /// MEM-17 footnote
  ///
  /// In vi, this message translates to:
  /// **'Khôi phục để ký ức trở lại đúng chỗ cũ trên dòng thời gian, kèm bình luận và lượt thả tim.'**
  String get memTrashFootnote;

  /// MEM-17 empty title
  ///
  /// In vi, this message translates to:
  /// **'Thùng rác trống'**
  String get memTrashEmpty;

  /// MEM-17 empty hint
  ///
  /// In vi, this message translates to:
  /// **'Ký ức bạn xoá sẽ nằm ở đây {days} ngày để bạn kịp đổi ý.'**
  String memTrashEmptyHint(int days);

  /// MEM-17 snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã khôi phục “{title}”'**
  String memTrashRestored(String title);

  /// MEM-17 snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã xoá vĩnh viễn'**
  String get memTrashDeleted;

  /// MEM-17b title
  ///
  /// In vi, this message translates to:
  /// **'Xoá vĩnh viễn ký ức này?'**
  String get memTrashConfirmTitle;

  /// MEM-17b body
  ///
  /// In vi, this message translates to:
  /// **'Ảnh, bình luận và lượt thả tim của ký ức sẽ mất hẳn. Không thể khôi phục sau bước này.'**
  String get memTrashConfirmBody;

  /// MEM-17b secondary button
  ///
  /// In vi, this message translates to:
  /// **'Giữ lại trong thùng rác'**
  String get memTrashKeep;

  /// Comment count
  ///
  /// In vi, this message translates to:
  /// **'{count} bình luận'**
  String memCommentCount(int count);

  /// Heart count
  ///
  /// In vi, this message translates to:
  /// **'{count} lượt thả tim'**
  String memHeartCount(int count);

  /// MEM-07 menu
  ///
  /// In vi, this message translates to:
  /// **'Xoá ký ức'**
  String get memMoveToTrash;

  /// MEM-07 snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã chuyển vào thùng rác · giữ {days} ngày'**
  String memMovedToTrash(int days);

  /// MEM-07 delete dialog
  ///
  /// In vi, this message translates to:
  /// **'Xoá ký ức này?'**
  String get memMoveToTrashTitle;

  /// MEM-07 delete dialog
  ///
  /// In vi, this message translates to:
  /// **'Ký ức sẽ nằm trong Thùng rác {days} ngày, bạn có thể khôi phục trong thời gian đó.'**
  String memMoveToTrashBody(int days);

  /// MEM-18 subtitle
  ///
  /// In vi, this message translates to:
  /// **'Ký ức đang soạn dở được tự lưu khi bạn thoát giữa chừng. Chỉ mình bạn thấy nháp.'**
  String get memDraftsSubtitle;

  /// MEM-18 section
  ///
  /// In vi, this message translates to:
  /// **'Trên máy này'**
  String get memDraftsDevice;

  /// MEM-18 section
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu trên tài khoản'**
  String get memDraftsCloud;

  /// MEM-18 note
  ///
  /// In vi, this message translates to:
  /// **'Nháp trên máy chưa được lưu lên tài khoản — xoá app sẽ mất.'**
  String get memDraftsLocalNote;

  /// MEM-18 action
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục soạn'**
  String get memDraftContinue;

  /// MEM-18 meta
  ///
  /// In vi, this message translates to:
  /// **'Sửa lúc {time} hôm nay'**
  String memDraftEditedToday(String time);

  /// MEM-18 meta
  ///
  /// In vi, this message translates to:
  /// **'Sửa lúc {time} hôm qua'**
  String memDraftEditedYesterday(String time);

  /// MEM-18 meta
  ///
  /// In vi, this message translates to:
  /// **'Sửa {date}, {time}'**
  String memDraftEditedOn(String date, String time);

  /// MEM-18 meta
  ///
  /// In vi, this message translates to:
  /// **'Lưu {date}, {time}'**
  String memDraftSavedOn(String date, String time);

  /// MEM-18 meta
  ///
  /// In vi, this message translates to:
  /// **'Lưu {date}, {time} trên {device}'**
  String memDraftSavedOnDevice(String date, String time, String device);

  /// Memory kind label (photo)
  ///
  /// In vi, this message translates to:
  /// **'Khoảnh khắc'**
  String get memKindMoment;

  /// MEM-18 voice draft
  ///
  /// In vi, this message translates to:
  /// **'Giọng nói {duration}'**
  String memKindVoiceDuration(String duration);

  /// MEM-18 empty
  ///
  /// In vi, this message translates to:
  /// **'Chưa có nháp nào'**
  String get memDraftsEmpty;

  /// MEM-18 empty hint
  ///
  /// In vi, this message translates to:
  /// **'Khi bạn thoát giữa chừng lúc đang soạn, ký ức sẽ được giữ ở đây.'**
  String get memDraftsEmptyHint;

  /// MEM-18 snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã xoá nháp'**
  String get memDraftDeleted;

  /// Composer close snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu vào Nháp'**
  String get memDraftSaved;

  /// Composer close snackbar action
  ///
  /// In vi, this message translates to:
  /// **'Xem nháp'**
  String get memDraftView;

  /// MEM-15 shortcut
  ///
  /// In vi, this message translates to:
  /// **'Thùng rác'**
  String get memShortcutTrash;

  /// MEM-15 shortcut
  ///
  /// In vi, this message translates to:
  /// **'Nháp'**
  String get memShortcutDrafts;

  /// MEM-15 shortcut
  ///
  /// In vi, this message translates to:
  /// **'Ảnh chờ duyệt'**
  String get memShortcutPending;

  /// MEM-19 subtitle
  ///
  /// In vi, this message translates to:
  /// **'Ảnh người thân đăng chỉ hiện với cả nhà sau khi bạn hoặc {partner} duyệt. Trong lúc chờ, chỉ người đăng và bố mẹ thấy.'**
  String memPendingSubtitle(String partner);

  /// MEM-19 edit row
  ///
  /// In vi, this message translates to:
  /// **'Bé trong ảnh'**
  String get memPendingKids;

  /// MEM-19 edit row
  ///
  /// In vi, this message translates to:
  /// **'Ai nhìn thấy'**
  String get memPendingAudience;

  /// MEM-19 button
  ///
  /// In vi, this message translates to:
  /// **'Từ chối'**
  String get memPendingReject;

  /// MEM-19 button
  ///
  /// In vi, this message translates to:
  /// **'Duyệt & hiện'**
  String get memPendingApprove;

  /// MEM-19 reject panel
  ///
  /// In vi, this message translates to:
  /// **'Lý do từ chối (không bắt buộc)'**
  String get memPendingRejectReason;

  /// MEM-19 reject hint
  ///
  /// In vi, this message translates to:
  /// **'{name} sẽ nhận được lời nhắn nhẹ nhàng này. Ảnh không hiện với ai khác.'**
  String memPendingRejectHint(String name);

  /// MEM-19 reject confirm
  ///
  /// In vi, this message translates to:
  /// **'Từ chối ảnh'**
  String get memPendingRejectSend;

  /// MEM-19 waiting badge
  ///
  /// In vi, this message translates to:
  /// **'Đã chờ {count} ngày'**
  String memPendingWaited(int count);

  /// MEM-19 empty
  ///
  /// In vi, this message translates to:
  /// **'Không có ảnh nào chờ duyệt'**
  String get memPendingEmpty;

  /// MEM-19 empty hint
  ///
  /// In vi, this message translates to:
  /// **'Ảnh người thân đăng cho các con sẽ hiện ở đây để bạn duyệt.'**
  String get memPendingEmptyHint;

  /// MEM-19 snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã duyệt — ảnh đã hiện với cả nhà'**
  String get memPendingApproved;

  /// MEM-19 snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã từ chối ảnh'**
  String get memPendingRejected;

  /// MEM-19 add child chip (semantics)
  ///
  /// In vi, this message translates to:
  /// **'Thêm {name}'**
  String memPendingAddChild(String name);

  /// RPT-01 title
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo ký ức này'**
  String get rptTitleMemory;

  /// RPT-01 title (comment)
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo bình luận này'**
  String get rptTitleComment;

  /// RPT-01 title (member)
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo {name}'**
  String rptTitlePerson(String name);

  /// RPT-01 subtitle
  ///
  /// In vi, this message translates to:
  /// **'Cho chúng tôi biết điều gì chưa ổn. Đội ngũ an toàn của Baby Family sẽ xem xét.'**
  String get rptSubtitle;

  /// RPT-01 note
  ///
  /// In vi, this message translates to:
  /// **'Mô tả thêm (không bắt buộc)…'**
  String get rptNoteHint;

  /// RPT-01 toggle
  ///
  /// In vi, this message translates to:
  /// **'Ẩn ký ức này với tôi ngay'**
  String get rptHideMemory;

  /// RPT-01 toggle (comment)
  ///
  /// In vi, this message translates to:
  /// **'Ẩn bình luận này với tôi ngay'**
  String get rptHideComment;

  /// RPT-01 toggle (member)
  ///
  /// In vi, this message translates to:
  /// **'Ẩn người này với tôi ngay'**
  String get rptHidePerson;

  /// RPT-01 parent toggle
  ///
  /// In vi, this message translates to:
  /// **'Gỡ khỏi gia đình'**
  String get rptRemoveContent;

  /// RPT-01 parent toggle hint
  ///
  /// In vi, this message translates to:
  /// **'Dành cho bố mẹ · ký ức sẽ không còn hiện với ai'**
  String get rptRemoveContentHint;

  /// RPT-01 parent toggle (member)
  ///
  /// In vi, this message translates to:
  /// **'Gỡ người thân'**
  String get rptRemovePerson;

  /// RPT-01 parent toggle hint (member)
  ///
  /// In vi, this message translates to:
  /// **'Dành cho bố mẹ · {name} sẽ không còn xem ảnh các con'**
  String rptRemovePersonHint(String name);

  /// RPT-01 button
  ///
  /// In vi, this message translates to:
  /// **'Gửi báo cáo'**
  String get rptSend;

  /// RPT-01b title
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi báo cáo'**
  String get rptSentTitle;

  /// RPT-01b body (content hidden)
  ///
  /// In vi, this message translates to:
  /// **'Cảm ơn bạn đã lên tiếng. Ký ức đã được ẩn tạm thời và sẽ được xem xét trong 24 giờ. Chúng tôi sẽ báo cho bạn khi xử lý xong.'**
  String get rptSentBodyHidden;

  /// RPT-01b body
  ///
  /// In vi, this message translates to:
  /// **'Cảm ơn bạn đã lên tiếng. Báo cáo sẽ được xem xét sớm. Chúng tôi sẽ báo cho bạn khi xử lý xong.'**
  String get rptSentBody;

  /// RPT-01b label
  ///
  /// In vi, this message translates to:
  /// **'Mã báo cáo'**
  String get rptCodeLabel;

  /// RPT-01b status
  ///
  /// In vi, this message translates to:
  /// **'Đang xem xét'**
  String get rptStatusReviewing;

  /// RPT-01b status
  ///
  /// In vi, this message translates to:
  /// **'Đã xử lý'**
  String get rptStatusResolved;

  /// RPT-01b link
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi trong Cài đặt › Báo cáo của tôi'**
  String get rptTrack;

  /// RPT-01b button
  ///
  /// In vi, this message translates to:
  /// **'Xong'**
  String get rptDone;

  /// RPT-02 title
  ///
  /// In vi, this message translates to:
  /// **'Chặn {name}?'**
  String rptBlockTitle(String name);

  /// RPT-02 effect
  ///
  /// In vi, this message translates to:
  /// **'{name} không bình luận hay thả tim được vào ký ức của bạn nữa.'**
  String rptBlockEffectComment(String name);

  /// RPT-02 effect
  ///
  /// In vi, this message translates to:
  /// **'{who, select, grandma{Bà} grandpa{Ông} other{Người này}} không nhận thông báo liên quan đến bạn.'**
  String rptBlockEffectNotify(String who);

  /// RPT-02 effect
  ///
  /// In vi, this message translates to:
  /// **'{who, select, grandma{Bà} grandpa{Ông} other{Người này}} vẫn ở trong gia đình và vẫn xem ảnh các cháu được chia sẻ.'**
  String rptBlockEffectStay(String who);

  /// RPT-02 option
  ///
  /// In vi, this message translates to:
  /// **'Gỡ {name} khỏi gia đình luôn'**
  String rptBlockRemove(String name);

  /// RPT-02 option hint
  ///
  /// In vi, this message translates to:
  /// **'Nên chọn nếu bạn không muốn {who, select, grandma{bà} grandpa{ông} other{người này}} xem ảnh các cháu nữa.'**
  String rptBlockRemoveHint(String who);

  /// RPT-02 button
  ///
  /// In vi, this message translates to:
  /// **'Chặn'**
  String get rptBlockConfirm;

  /// RPT-02 snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã chặn {name}'**
  String rptBlockDone(String name);

  /// FAM-04 row
  ///
  /// In vi, this message translates to:
  /// **'Chặn {name}'**
  String rptBlockMenu(String name);

  /// CHD-05 child meta
  ///
  /// In vi, this message translates to:
  /// **'Sinh {birth} · {callName} thêm ngày {date}'**
  String chdArchiveAddedBy(String birth, String callName, String date);

  /// CHD-05 child meta (no adder)
  ///
  /// In vi, this message translates to:
  /// **'Sinh {birth}'**
  String chdArchiveBorn(String birth);

  /// CHD-05 badge
  ///
  /// In vi, this message translates to:
  /// **'Có thể trùng với {name}'**
  String chdArchiveDuplicate(String name);

  /// CHD-05 section
  ///
  /// In vi, this message translates to:
  /// **'Khi lưu trữ {name}'**
  String chdArchiveSection(String name);

  /// CHD-05 effect
  ///
  /// In vi, this message translates to:
  /// **'{name} ẩn khỏi bộ chuyển bé, Trang chủ và Ký ức.'**
  String chdArchiveEffectHide(String name);

  /// CHD-05 effect
  ///
  /// In vi, this message translates to:
  /// **'{count} ký ức chỉ gắn riêng {name} sẽ ẩn theo.'**
  String chdArchiveEffectPrivate(int count, String name);

  /// CHD-05 effect
  ///
  /// In vi, this message translates to:
  /// **'{count} ký ức chung với {others} vẫn hiện ở trang của {others}.'**
  String chdArchiveEffectShared(int count, String others);

  /// CHD-05 effect
  ///
  /// In vi, this message translates to:
  /// **'Khôi phục bất cứ lúc nào trong Các con › Đã lưu trữ.'**
  String get chdArchiveEffectRestore;

  /// CHD-05 button
  ///
  /// In vi, this message translates to:
  /// **'Lưu trữ {name}'**
  String chdArchiveAction(String name);

  /// CHD-05 section
  ///
  /// In vi, this message translates to:
  /// **'Xoá vĩnh viễn'**
  String get chdArchiveDeleteSection;

  /// CHD-05 locked title
  ///
  /// In vi, this message translates to:
  /// **'Cần lưu trữ ít nhất {days} ngày'**
  String chdArchiveLockedTitle(int days);

  /// CHD-05 locked body
  ///
  /// In vi, this message translates to:
  /// **'Để tránh xoá nhầm, nếu lưu trữ hôm nay bạn xoá được từ {date}. Nội dung chỉ thuộc riêng {name} sẽ vào thùng rác 30 ngày.'**
  String chdArchiveLockedBody(String date, String name);

  /// CHD-05 locked body (already archived)
  ///
  /// In vi, this message translates to:
  /// **'Để tránh xoá nhầm, bạn xoá được từ {date}. Nội dung chỉ thuộc riêng {name} sẽ vào thùng rác 30 ngày.'**
  String chdArchiveLockedBodyArchived(String date, String name);

  /// CHD-05 snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu trữ {name}'**
  String chdArchived(String name);

  /// CHD-05b snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã khôi phục {name}'**
  String chdRestored(String name);

  /// CHD-05b title
  ///
  /// In vi, this message translates to:
  /// **'Xoá vĩnh viễn {name}'**
  String chdDeleteTitle(String name);

  /// CHD-05b card
  ///
  /// In vi, this message translates to:
  /// **'{name} · đã lưu trữ'**
  String chdDeleteArchivedName(String name);

  /// CHD-05b card
  ///
  /// In vi, this message translates to:
  /// **'Lưu trữ {days} ngày · từ {date}'**
  String chdDeleteArchivedFor(int days, String date);

  /// CHD-05b badge
  ///
  /// In vi, this message translates to:
  /// **'Đủ {days} ngày'**
  String chdDeleteEnough(int days);

  /// CHD-05b effect
  ///
  /// In vi, this message translates to:
  /// **'{count} ký ức chỉ thuộc riêng {name} chuyển vào thùng rác 30 ngày, sau đó xoá hẳn.'**
  String chdDeleteEffectTrash(int count, String name);

  /// CHD-05b effect
  ///
  /// In vi, this message translates to:
  /// **'Ký ức chung với {others} vẫn giữ nguyên ở trang của {others}.'**
  String chdDeleteEffectShared(String others);

  /// CHD-05b step
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận 1/2'**
  String get chdDeleteStep1;

  /// CHD-05b checkbox
  ///
  /// In vi, this message translates to:
  /// **'Tôi hiểu {name} sẽ bị xoá và không thể khôi phục hồ sơ này.'**
  String chdDeleteConfirm1(String name);

  /// CHD-05b step
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận 2/2 · Nhập tên bé'**
  String get chdDeleteStep2;

  /// CHD-05b hint
  ///
  /// In vi, this message translates to:
  /// **'Gõ đúng “{name}” để mở nút xoá.'**
  String chdDeleteHint(String name);

  /// CHD-05b button
  ///
  /// In vi, this message translates to:
  /// **'Xoá vĩnh viễn {name}'**
  String chdDeleteAction(String name);

  /// CHD-05b secondary
  ///
  /// In vi, this message translates to:
  /// **'Khôi phục {name} thay vì xoá'**
  String chdDeleteRestoreInstead(String name);

  /// CHD-05b snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã xoá {name}'**
  String chdDeleted(String name);

  /// CIR-02 badge
  ///
  /// In vi, this message translates to:
  /// **'🎉 Ngày mai tròn {months} tháng'**
  String cirChildTomorrow(int months);

  /// CIR-02 section
  ///
  /// In vi, this message translates to:
  /// **'Những lần đầu của cháu'**
  String get cirChildFirsts;

  /// CIR-02 section
  ///
  /// In vi, this message translates to:
  /// **'Ký ức của cháu'**
  String get cirChildMemories;

  /// CIR-02 month header
  ///
  /// In vi, this message translates to:
  /// **'Tháng thứ {month}'**
  String cirChildMonth(int month);

  /// CIR-02 month range
  ///
  /// In vi, this message translates to:
  /// **'· {start} – {end}'**
  String cirChildMonthRange(String start, String end);

  /// CIR-02 empty
  ///
  /// In vi, this message translates to:
  /// **'Chưa có ký ức nào của cháu'**
  String get cirChildEmpty;

  /// CIR-03 menu note
  ///
  /// In vi, this message translates to:
  /// **'Tải ảnh về: bố mẹ chưa bật cho {who, select, grandma{bà} grandpa{ông} other{bạn}}'**
  String cirDetailDownloadOff(String who);

  /// CIR-03 author meta (child age)
  ///
  /// In vi, this message translates to:
  /// **'{name} {age}'**
  String cirDetailAuthorAge(String name, String age);

  /// CIR-03 button
  ///
  /// In vi, this message translates to:
  /// **'Đã thả tim'**
  String get cirDetailLiked;

  /// CIR-03 own name
  ///
  /// In vi, this message translates to:
  /// **'{who, select, grandma{Bà} grandpa{Ông} other{Bạn}} (bạn)'**
  String cirDetailYou(String who);

  /// CIR-03 reacted line
  ///
  /// In vi, this message translates to:
  /// **'{names} đã thả tim'**
  String cirDetailReactedBy(String names);

  /// CIR-03 comments title
  ///
  /// In vi, this message translates to:
  /// **'Lời chúc ({count})'**
  String cirDetailWishes(int count);

  /// CIR-03 input hint
  ///
  /// In vi, this message translates to:
  /// **'Viết lời chúc cho cháu…'**
  String get cirDetailWishHint;

  /// CIR-03 mic
  ///
  /// In vi, this message translates to:
  /// **'Ghi âm lời chúc'**
  String get cirDetailVoice;

  /// CIR-03 send
  ///
  /// In vi, this message translates to:
  /// **'Gửi lời chúc'**
  String get cirDetailSend;

  /// CIR-03 snackbar
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi báo cáo'**
  String get cirDetailReported;

  /// CIR-03 missing
  ///
  /// In vi, this message translates to:
  /// **'Ký ức này không còn được chia sẻ'**
  String get cirDetailMissing;

  /// CIR-04 section
  ///
  /// In vi, this message translates to:
  /// **'Ảnh đã chọn ({count})'**
  String cirPostSelected(int count);

  /// CIR-04 section
  ///
  /// In vi, this message translates to:
  /// **'Ảnh của cháu nào?'**
  String get cirPostWhichKid;

  /// CIR-04 section
  ///
  /// In vi, this message translates to:
  /// **'Ngày chụp'**
  String get cirPostDate;

  /// CIR-04 section
  ///
  /// In vi, this message translates to:
  /// **'Lời nhắn cho cháu'**
  String get cirPostMessage;

  /// CIR-04 field hint
  ///
  /// In vi, this message translates to:
  /// **'Viết vài lời cho cháu…'**
  String get cirPostMessageHint;

  /// CIR-04 note title
  ///
  /// In vi, this message translates to:
  /// **'Bố mẹ sẽ duyệt trước khi hiện'**
  String get cirPostApprovalTitle;

  /// CIR-04 note body
  ///
  /// In vi, this message translates to:
  /// **'Ảnh hiện với cả nhà sau khi bố hoặc mẹ của cháu đồng ý.'**
  String get cirPostApprovalBody;

  /// CIR-04 button
  ///
  /// In vi, this message translates to:
  /// **'Gửi ảnh'**
  String get cirPostSend;

  /// CIR-04 remove (semantics)
  ///
  /// In vi, this message translates to:
  /// **'Bỏ ảnh'**
  String get cirPostRemovePhoto;

  /// CIR-04b title
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi!'**
  String get cirPostSentTitle;

  /// CIR-04b body
  ///
  /// In vi, this message translates to:
  /// **'Bố/Mẹ sẽ duyệt trước khi hiển thị cho cả nhà.'**
  String get cirPostSentBody;

  /// CIR-04b banner
  ///
  /// In vi, this message translates to:
  /// **'Đang chờ Bố/Mẹ duyệt'**
  String get cirPostPending;

  /// CIR-04b meta
  ///
  /// In vi, this message translates to:
  /// **'vừa gửi'**
  String get cirPostJustSent;

  /// CIR-04b button
  ///
  /// In vi, this message translates to:
  /// **'Về trang Cháu yêu'**
  String get cirPostBackHome;

  /// CIR-04b button
  ///
  /// In vi, this message translates to:
  /// **'Đăng thêm ảnh'**
  String get cirPostMore;

  /// CIR-04 no contribute permission
  ///
  /// In vi, this message translates to:
  /// **'Bố mẹ chưa bật quyền đăng ảnh cho cháu nào'**
  String get cirPostNoKid;

  /// CIR-05 title
  ///
  /// In vi, this message translates to:
  /// **'{family} đang tạm dừng chia sẻ với người thân'**
  String cirPausedMessage(String family);

  /// CIR-05 pill
  ///
  /// In vi, this message translates to:
  /// **'Ảnh của cháu vẫn được giữ an toàn'**
  String get cirPausedSafe;

  /// CIR-06 profile meta
  ///
  /// In vi, this message translates to:
  /// **'{relation} · {family}'**
  String cirMeRelation(String relation, String family);

  /// CIR-06 text size preview
  ///
  /// In vi, this message translates to:
  /// **'{name} vừa có ảnh mới, {who, select, grandma{bà} grandpa{ông} other{bạn}} vào xem nhé 🌸'**
  String cirMeTextPreview(String name, String who);

  /// CIR-06 notification option
  ///
  /// In vi, this message translates to:
  /// **'Báo ngay khi có ảnh mới'**
  String get cirMeInstant;

  /// CIR-06 notification option
  ///
  /// In vi, this message translates to:
  /// **'Bản tin mỗi ngày'**
  String get cirMeDigest;

  /// CIR-06 digest hint
  ///
  /// In vi, this message translates to:
  /// **'Gửi lúc {time} · gom ảnh mới trong ngày'**
  String cirMeDigestHint(String time);

  /// CIR-06 row
  ///
  /// In vi, this message translates to:
  /// **'Chuyển gia đình'**
  String get cirMeSwitchFamily;

  /// CIR-06 row hint
  ///
  /// In vi, this message translates to:
  /// **'Đang xem: {family}'**
  String cirMeViewing(String family);

  /// SET-10 title
  ///
  /// In vi, this message translates to:
  /// **'Rời {family}'**
  String cirLeaveTitle(String family);

  /// SET-10 body
  ///
  /// In vi, this message translates to:
  /// **'{who, select, grandma{Bà} grandpa{Ông} other{Bạn}} sẽ không còn xem ảnh và bình luận cùng các cháu nữa. Khi nào muốn quay lại, {who, select, grandma{bà} grandpa{ông} other{bạn}} nhờ {inviter} gửi lời mời mới nhé.'**
  String cirLeaveBody(String who, String inviter);

  /// SET-10 following
  ///
  /// In vi, this message translates to:
  /// **'{who, select, grandma{Bà} grandpa{Ông} other{Bạn}} đang theo dõi {names}'**
  String cirLeaveFollowing(String who, String names);

  /// SET-10 section
  ///
  /// In vi, this message translates to:
  /// **'Những gì {who, select, grandma{bà} grandpa{ông} other{bạn}} đã đăng · {photos} ảnh, {comments} bình luận'**
  String cirLeavePosted(String who, int photos, int comments);

  /// SET-10 option
  ///
  /// In vi, this message translates to:
  /// **'Giữ lại cho gia đình'**
  String get cirLeaveKeep;

  /// SET-10 option hint
  ///
  /// In vi, this message translates to:
  /// **'Cả nhà vẫn xem được ảnh và lời {who, select, grandma{bà} grandpa{ông} other{bạn}} đã viết. (Mặc định)'**
  String cirLeaveKeepHint(String who);

  /// SET-10 option
  ///
  /// In vi, this message translates to:
  /// **'Gỡ toàn bộ'**
  String get cirLeaveRemove;

  /// SET-10 option hint
  ///
  /// In vi, this message translates to:
  /// **'Ảnh và bình luận của {who, select, grandma{bà} grandpa{ông} other{bạn}} sẽ được gỡ khỏi {family}.'**
  String cirLeaveRemoveHint(String who, String family);

  /// SET-10 notice
  ///
  /// In vi, this message translates to:
  /// **'{inviter} sẽ nhận một thông báo ngắn: “{name} đã rời gia đình.” {who, select, grandma{Bà} grandpa{Ông} other{Bạn}} mất quyền xem ngay sau khi xác nhận.'**
  String cirLeaveNotice(String inviter, String name, String who);

  /// SET-10 button
  ///
  /// In vi, this message translates to:
  /// **'Ở lại'**
  String get cirLeaveStay;

  /// Join a list with its last item (“Bà, Ông và Papa”)
  ///
  /// In vi, this message translates to:
  /// **'{list} và {last}'**
  String commonListAnd(String list, String last);

  /// Nhãn bản nháp AI (US-09, REC-01)
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý bởi AI'**
  String get commonAiSuggested;

  /// Nút báo cáo nội dung AI (US-09, REC-01)
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo nội dung AI'**
  String get commonAiReport;

  /// Snack sau khi báo cáo nội dung AI
  ///
  /// In vi, this message translates to:
  /// **'Cảm ơn bạn — nội dung AI này sẽ được xem lại.'**
  String get commonAiReported;

  /// Bộ chọn tuần (US-14, CARE-11)
  ///
  /// In vi, this message translates to:
  /// **'Tuần {range}'**
  String commonWeekRange(String range);

  /// US-00 — dải khoá dưới tiêu đề
  ///
  /// In vi, this message translates to:
  /// **'Chỉ dành cho Papa & Mama'**
  String get usOnlyParents;

  /// US-00 tiêu đề
  ///
  /// In vi, this message translates to:
  /// **'Không gian này cần đủ hai người'**
  String get usPartnerLeftTitle;

  /// US-00 nội dung
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản của {callName} đã được xoá, nên Papa & Mama đang tạm khoá. Ký ức của {familyName} vẫn còn nguyên — bạn có thể xem và tải về bất cứ lúc nào.'**
  String usPartnerLeftBody(String callName, String familyName);

  /// US-00 thẻ trạng thái gia đình
  ///
  /// In vi, this message translates to:
  /// **'{familyName} đang ở chế độ chỉ xem & tải về'**
  String usPartnerLeftStateTitle(String familyName);

  /// US-00 thẻ trạng thái — dòng phụ
  ///
  /// In vi, this message translates to:
  /// **'Mời bạn đời mới để tiếp tục tạo ký ức và dùng Papa & Mama.'**
  String get usPartnerLeftStateSub;

  /// US-00 nhãn nhóm tính năng
  ///
  /// In vi, this message translates to:
  /// **'KHI CÓ ĐỦ HAI NGƯỜI'**
  String get usPartnerLeftSection;

  /// US-00 ô Check-in
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay mình thế nào'**
  String get usPartnerLeftCheckinSub;

  /// US-00 ô Lời nhờ
  ///
  /// In vi, this message translates to:
  /// **'Nhờ nhau, không áp lực'**
  String get usPartnerLeftRequestSub;

  /// US-00 ô Lời cảm ơn
  ///
  /// In vi, this message translates to:
  /// **'Giữ lại điều nhỏ'**
  String get usPartnerLeftThanksSub;

  /// US-00 ô Nhật ký riêng
  ///
  /// In vi, this message translates to:
  /// **'Chỉ mình bạn đọc'**
  String get usPartnerLeftJournalSub;

  /// US-00 ghi chú riêng tư
  ///
  /// In vi, this message translates to:
  /// **'Ông bà và người thân không bao giờ thấy nội dung trong Papa & Mama.'**
  String get usPartnerLeftPrivacy;

  /// US-00 nút chính
  ///
  /// In vi, this message translates to:
  /// **'Mời bạn đời tham gia'**
  String get usPartnerLeftInvite;

  /// US-02 biến thể “Khó chịu với bạn đời” (mục 7.16.1)
  ///
  /// In vi, this message translates to:
  /// **'Khó chịu với {callName}'**
  String usCheckinAnnoyedPartner(String callName);

  /// US-02 → hỏi Cầu nối
  ///
  /// In vi, this message translates to:
  /// **'Bạn muốn dùng Cầu nối không?'**
  String get usBridgeAskTitle;

  /// US-02 → hỏi Cầu nối — nội dung
  ///
  /// In vi, this message translates to:
  /// **'Chưa có gì được gửi cho {callName}. Cầu nối giúp hai bạn nói rõ cảm xúc và cùng chọn một bước nhỏ — bắt đầu bằng một bước riêng tư.'**
  String usBridgeAskBody(String callName);

  /// US-02 → mở US-08
  ///
  /// In vi, this message translates to:
  /// **'Mở Cầu nối'**
  String get usBridgeAskOpen;

  /// US-08 kicker
  ///
  /// In vi, this message translates to:
  /// **'CẦU NỐI · BƯỚC {step}/{total}'**
  String usBridgeStepKicker(int step, int total);

  /// US-08 bước 1
  ///
  /// In vi, this message translates to:
  /// **'Chọn một hoặc vài cảm xúc. Chưa có gì được gửi cho {callName}.'**
  String usBridgeFeelSub(String callName);

  /// US-08 bước 2
  ///
  /// In vi, this message translates to:
  /// **'Chuyện này về…'**
  String get usBridgeTopicTitle;

  /// US-08 bước 2
  ///
  /// In vi, this message translates to:
  /// **'Không bắt buộc — bạn có thể bỏ qua. Chưa có gì được gửi cho {callName}.'**
  String usBridgeTopicSub(String callName);

  /// US-08 bước 3
  ///
  /// In vi, this message translates to:
  /// **'Lúc này mình cần…'**
  String get usBridgeNeedTitle;

  /// US-08 bước 3
  ///
  /// In vi, this message translates to:
  /// **'Chọn một hoặc vài điều. Chưa có gì được gửi cho {callName}.'**
  String usBridgeNeedSub(String callName);

  /// US-08 thẻ tóm tắt
  ///
  /// In vi, this message translates to:
  /// **'Mình cảm thấy'**
  String get usBridgeFeltLabel;

  /// US-08 thẻ tóm tắt
  ///
  /// In vi, this message translates to:
  /// **'Về chuyện'**
  String get usBridgeAboutLabel;

  /// US-08 nháp riêng
  ///
  /// In vi, this message translates to:
  /// **'Viết nháp riêng (tuỳ chọn)'**
  String get usBridgeDraftLabel;

  /// US-08 đếm ký tự
  ///
  /// In vi, this message translates to:
  /// **'{count}/{max}'**
  String usBridgeDraftCount(int count, int max);

  /// US-08 gợi ý ô nháp
  ///
  /// In vi, this message translates to:
  /// **'Viết ra điều bạn đang nghĩ — chỉ mình bạn đọc.'**
  String get usBridgeDraftHint;

  /// US-08 ghi chú nháp (BR-030)
  ///
  /// In vi, this message translates to:
  /// **'Nháp này không bao giờ được gửi nguyên văn hay tự động.'**
  String get usBridgeDraftNote;

  /// US-08 → US-13
  ///
  /// In vi, this message translates to:
  /// **'Mình cảm thấy không an toàn'**
  String get usBridgeUnsafe;

  /// US-08 bước 4
  ///
  /// In vi, this message translates to:
  /// **'Bạn muốn làm gì với nội dung này?'**
  String get usBridgeChoiceTitle;

  /// US-08 bước 4
  ///
  /// In vi, this message translates to:
  /// **'Bạn quyết định. Chưa có gì được gửi cho {callName}.'**
  String usBridgeChoiceSub(String callName);

  /// US-08 bước 4 — Giữ riêng
  ///
  /// In vi, this message translates to:
  /// **'Kết thúc ở đây, như một trang nhật ký.'**
  String get usBridgeKeepPrivateDesc;

  /// US-08 bước 4 → US-09
  ///
  /// In vi, this message translates to:
  /// **'Viết lại trước khi gửi'**
  String get usBridgeRewriteOption;

  /// US-08 bước 4
  ///
  /// In vi, this message translates to:
  /// **'Chọn một câu và viết lại nhẹ nhàng hơn.'**
  String get usBridgeRewriteOptionDesc;

  /// US-08 bước 4
  ///
  /// In vi, this message translates to:
  /// **'Chọn ý để chia sẻ'**
  String get usBridgeShareOption;

  /// US-08 bước 4
  ///
  /// In vi, this message translates to:
  /// **'Chọn cảm xúc và nhu cầu {callName} sẽ thấy.'**
  String usBridgeShareOptionDesc(String callName);

  /// Snack sau Giữ riêng
  ///
  /// In vi, this message translates to:
  /// **'Đã giữ riêng — chỉ mình bạn thấy.'**
  String get usBridgeKeptPrivate;

  /// US-08 bước 5
  ///
  /// In vi, this message translates to:
  /// **'Xem trước điều {callName} sẽ nhận'**
  String usBridgePreviewTitle(String callName);

  /// US-08 bước 5
  ///
  /// In vi, this message translates to:
  /// **'Chỉ những ý bạn chọn được gửi. Nháp riêng của bạn vẫn giữ riêng.'**
  String get usBridgePreviewSub;

  /// Nhãn hàng cảm xúc (US-08, US-10)
  ///
  /// In vi, this message translates to:
  /// **'Cảm thấy'**
  String get usBridgeFeelShort;

  /// Nhãn hàng nhu cầu (US-08, US-10)
  ///
  /// In vi, this message translates to:
  /// **'Cần'**
  String get usBridgeNeedShort;

  /// US-08 bước 5
  ///
  /// In vi, this message translates to:
  /// **'Lời nhắn (tuỳ chọn)'**
  String get usBridgeMessageLabel;

  /// US-08 bước 5
  ///
  /// In vi, this message translates to:
  /// **'Một câu bạn muốn {callName} đọc'**
  String usBridgeMessageHint(String callName);

  /// US-08 bước 5
  ///
  /// In vi, this message translates to:
  /// **'Gửi lời mời'**
  String get usBridgeSendInvite;

  /// Snack sau khi gửi lời mời
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi lời mời cho {callName}'**
  String usBridgeInviteSent(String callName);

  /// US-09
  ///
  /// In vi, this message translates to:
  /// **'Chọn một phiên bản rồi sửa theo ý bạn. Không có gì được gửi tự động.'**
  String get usBridgeRewriteSub;

  /// US-09
  ///
  /// In vi, this message translates to:
  /// **'CÂU GỐC CỦA BẠN'**
  String get usBridgeRewriteOriginal;

  /// US-09 nhãn giọng
  ///
  /// In vi, this message translates to:
  /// **'{tone, select, neutral{TRUNG TÍNH} warm{ẤM ÁP} other{NGẮN GỌN}}'**
  String usBridgeRewriteTone(String tone);

  /// US-09
  ///
  /// In vi, this message translates to:
  /// **'Sửa trước khi dùng'**
  String get usBridgeRewriteEdit;

  /// US-09
  ///
  /// In vi, this message translates to:
  /// **'Giữ câu gốc'**
  String get usBridgeRewriteKeep;

  /// US-09
  ///
  /// In vi, this message translates to:
  /// **'Dùng câu này'**
  String get usBridgeRewriteUse;

  /// US-09 ghi chú dữ liệu AI
  ///
  /// In vi, this message translates to:
  /// **'Chỉ câu bạn chọn được gửi cho AI để viết lại. AI không đọc nháp riêng hay nhật ký của bạn.'**
  String get usBridgeRewriteDataNote;

  /// US-10 tiêu đề
  ///
  /// In vi, this message translates to:
  /// **'{callName} muốn trò chuyện bình tĩnh khi bạn sẵn sàng'**
  String usBridgeInviteTitle(String callName);

  /// US-10
  ///
  /// In vi, this message translates to:
  /// **'Một không gian để nói rõ cảm xúc và cùng chọn một bước nhỏ tiếp theo. Không ai thắng, không ai thua.'**
  String get usBridgeInviteSub;

  /// US-10 thẻ chia sẻ
  ///
  /// In vi, this message translates to:
  /// **'{callName} đã chọn chia sẻ'**
  String usBridgeInviteShared(String callName);

  /// US-10 thẻ chia sẻ
  ///
  /// In vi, this message translates to:
  /// **'Chỉ những ý này — phần còn lại {callName} giữ riêng'**
  String usBridgeInviteSharedSub(String callName);

  /// US-10
  ///
  /// In vi, this message translates to:
  /// **'Trước khi vào phiên chung, bạn cũng có một bước riêng tư để nói cảm xúc và điều mình cần.'**
  String get usBridgeInviteNote;

  /// US-10
  ///
  /// In vi, this message translates to:
  /// **'Tham gia ngay'**
  String get usBridgeJoinNow;

  /// US-10
  ///
  /// In vi, this message translates to:
  /// **'Để sau — nhắc mình lúc'**
  String get usBridgeLaterLabel;

  /// US-10
  ///
  /// In vi, this message translates to:
  /// **'Tự chọn'**
  String get usBridgeLaterCustom;

  /// US-10
  ///
  /// In vi, this message translates to:
  /// **'Mình chưa sẵn sàng'**
  String get usBridgeNotReady;

  /// US-10
  ///
  /// In vi, this message translates to:
  /// **'Lời mời được tạm dừng — không có thông báo tiêu cực nào.'**
  String get usBridgeNotReadySub;

  /// US-10 snack
  ///
  /// In vi, this message translates to:
  /// **'Đã hẹn nhắc — lời mời vẫn được giữ.'**
  String get usBridgeRemindSet;

  /// Snack tạm dừng (US-10/11/12)
  ///
  /// In vi, this message translates to:
  /// **'Đã tạm dừng. Bạn có thể quay lại bất cứ lúc nào.'**
  String get usBridgePaused;

  /// US-11 trạng thái
  ///
  /// In vi, this message translates to:
  /// **'Đang diễn ra'**
  String get usBridgeLive;

  /// US-11
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu {time} · {date}'**
  String usBridgeStartedAt(String time, String date);

  /// US-11
  ///
  /// In vi, this message translates to:
  /// **'Đọc chậm những gì hai bạn đã chọn chia sẻ. Ở đây không có ai đúng, ai sai.'**
  String get usBridgeSessionIntro;

  /// US-11 cột của tôi
  ///
  /// In vi, this message translates to:
  /// **'Bạn ({callName})'**
  String usBridgeYouName(String callName);

  /// US-11
  ///
  /// In vi, this message translates to:
  /// **'{callName} cảm thấy'**
  String usBridgeFeels(String callName);

  /// US-11
  ///
  /// In vi, this message translates to:
  /// **'{callName} cần'**
  String usBridgeNeeds(String callName);

  /// US-11 trạng thái của tôi
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa chọn'**
  String get usBridgeYouPending;

  /// US-11 trạng thái của tôi
  ///
  /// In vi, this message translates to:
  /// **'Bạn: Mình hiểu'**
  String get usBridgeYouUnderstood;

  /// US-11
  ///
  /// In vi, this message translates to:
  /// **'{callName} chưa chọn'**
  String usBridgePartnerPending(String callName);

  /// US-11
  ///
  /// In vi, this message translates to:
  /// **'{callName}: Mình hiểu'**
  String usBridgePartnerUnderstood(String callName);

  /// US-11
  ///
  /// In vi, this message translates to:
  /// **'LƯỢT CỦA BẠN'**
  String get usBridgeYourTurn;

  /// US-11
  ///
  /// In vi, this message translates to:
  /// **'{callName} đã đọc xong'**
  String usBridgePartnerReadDone(String callName);

  /// US-11
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã đọc những gì {callName} chia sẻ?'**
  String usBridgeReadQuestion(String callName);

  /// US-11
  ///
  /// In vi, this message translates to:
  /// **'Mình cần nói rõ hơn'**
  String get usBridgeClarify;

  /// US-11
  ///
  /// In vi, this message translates to:
  /// **'Mình hiểu'**
  String get usBridgeUnderstand;

  /// US-11
  ///
  /// In vi, this message translates to:
  /// **'“Nói rõ hơn” mở thêm 1 lượt gửi ý — bạn sẽ xem trước chính xác trước khi gửi.'**
  String get usBridgeClarifyNote;

  /// US-11
  ///
  /// In vi, this message translates to:
  /// **'Mỗi người có thể tạm dừng hoặc rời phiên bất cứ lúc nào.'**
  String get usBridgeLeaveNote;

  /// US-11
  ///
  /// In vi, this message translates to:
  /// **'Đang chờ {callName} đọc xong'**
  String usBridgeWaiting(String callName);

  /// US-11 sheet
  ///
  /// In vi, this message translates to:
  /// **'Nói rõ hơn với {callName}'**
  String usBridgeClarifyTitle(String callName);

  /// US-11 snack
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi thêm ý cho {callName}'**
  String usBridgeClarifySent(String callName);

  /// US-12 kicker
  ///
  /// In vi, this message translates to:
  /// **'CẦU NỐI · HAI BẠN ĐỀU ĐÃ HIỂU'**
  String get usBridgeNextKicker;

  /// US-12
  ///
  /// In vi, this message translates to:
  /// **'Chọn một điều cả hai có thể làm. Không cần giải quyết hết mọi chuyện hôm nay.'**
  String get usBridgeNextSub;

  /// US-12
  ///
  /// In vi, this message translates to:
  /// **'Khi nào?'**
  String get usBridgeWhen;

  /// US-12
  ///
  /// In vi, this message translates to:
  /// **'Trông bé nào?'**
  String get usBridgeWhichChild;

  /// US-12
  ///
  /// In vi, this message translates to:
  /// **'Tạo nhắc cho cả hai'**
  String get usBridgeReminder;

  /// US-12
  ///
  /// In vi, this message translates to:
  /// **'Nhắc lúc {time} — chỉ hai bạn thấy'**
  String usBridgeReminderSub(String time);

  /// US-12
  ///
  /// In vi, this message translates to:
  /// **'Chưa xác nhận'**
  String get usBridgeNotConfirmed;

  /// US-12
  ///
  /// In vi, this message translates to:
  /// **'Đã đồng ý'**
  String get usBridgeAgreed;

  /// US-12
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận bước này'**
  String get usBridgeConfirmStep;

  /// US-12
  ///
  /// In vi, this message translates to:
  /// **'Bước được áp dụng khi cả hai cùng xác nhận. Bạn vẫn có thể đổi lựa chọn.'**
  String get usBridgeConfirmNote;

  /// US-12b
  ///
  /// In vi, this message translates to:
  /// **'Hai bạn muốn đóng phiên này chứ?'**
  String get usBridgeCloseTitle;

  /// US-12b
  ///
  /// In vi, this message translates to:
  /// **'Phiên chỉ đóng khi cả hai cùng đồng ý.'**
  String get usBridgeCloseSub;

  /// US-12b
  ///
  /// In vi, this message translates to:
  /// **'Bước đã chọn · {when}'**
  String usBridgeStepChosen(String when);

  /// US-12b thời điểm tương đối
  ///
  /// In vi, this message translates to:
  /// **'{day, select, tonight{tối nay {time}} lastNight{tối qua {time}} today{hôm nay {time}} yesterday{hôm qua {time}} other{{time}}}'**
  String usBridgeRelativeWhen(String day, String time);

  /// US-12b
  ///
  /// In vi, this message translates to:
  /// **'{callName} đã đồng ý đóng phiên'**
  String usBridgePartnerAgreedClose(String callName);

  /// US-12b
  ///
  /// In vi, this message translates to:
  /// **'Gửi lời cảm ơn cho {callName}? (tuỳ chọn)'**
  String usBridgeThanksLabel(String callName);

  /// US-12b câu cảm ơn (xưng hô theo vai bạn đời)
  ///
  /// In vi, this message translates to:
  /// **'{role, select, father{Cảm ơn anh đã lắng nghe 💛} other{Cảm ơn em đã lắng nghe 💛}}'**
  String usBridgeThanksListened(String role);

  /// US-12b câu cảm ơn ngắn
  ///
  /// In vi, this message translates to:
  /// **'{role, select, father{Cảm ơn anh} other{Cảm ơn em}}'**
  String usBridgeThanksShort(String role);

  /// US-12b lưu trữ ngắn (D-14)
  ///
  /// In vi, this message translates to:
  /// **'Nội dung phiên tự xoá sau {days} ngày. Chỉ còn dòng “Đã có một phiên Cầu nối ngày {date}”.'**
  String usBridgeRetention(int days, String date);

  /// US-12b
  ///
  /// In vi, this message translates to:
  /// **'Đóng phiên'**
  String get usBridgeCloseConfirm;

  /// US-12b
  ///
  /// In vi, this message translates to:
  /// **'Chưa, để sau'**
  String get usBridgeCloseLater;

  /// US-12b snack
  ///
  /// In vi, this message translates to:
  /// **'Đã đóng phiên Cầu nối'**
  String get usBridgeClosed;

  /// US-13
  ///
  /// In vi, this message translates to:
  /// **'Thoát nhanh'**
  String get usSafetyQuickExit;

  /// US-13
  ///
  /// In vi, this message translates to:
  /// **'Sự an toàn của bạn là quan trọng nhất'**
  String get usSafetyHeadline;

  /// US-13
  ///
  /// In vi, this message translates to:
  /// **'Bạn không cần nói chuyện trực tiếp lúc này. Nếu bạn hoặc các con đang gặp nguy hiểm, hãy gọi ngay cho một trong các số dưới đây.'**
  String get usSafetyBody;

  /// US-13 nút gọi (trợ năng)
  ///
  /// In vi, this message translates to:
  /// **'Gọi {number}'**
  String usSafetyCall(String number);

  /// US-13
  ///
  /// In vi, this message translates to:
  /// **'Liên hệ một người bạn tin cậy'**
  String get usSafetyTrustedTitle;

  /// US-13
  ///
  /// In vi, this message translates to:
  /// **'Người thân, bạn bè hoặc hàng xóm bạn tin'**
  String get usSafetyTrustedSub;

  /// US-13
  ///
  /// In vi, this message translates to:
  /// **'Nội dung bạn vừa viết được giữ riêng, không gửi cho ai.'**
  String get usSafetyPrivateNote;

  /// US-13
  ///
  /// In vi, this message translates to:
  /// **'{callName} không nhận thông báo nào về màn hình này.'**
  String usSafetyNoNotify(String callName);

  /// US-13
  ///
  /// In vi, this message translates to:
  /// **'Màn hình này không được ghi vào lịch sử phiên.'**
  String get usSafetyNoHistory;

  /// US-13
  ///
  /// In vi, this message translates to:
  /// **'Giữ riêng nội dung này'**
  String get usSafetyKeepPrivate;

  /// US-13
  ///
  /// In vi, this message translates to:
  /// **'Baby Family không phải dịch vụ khẩn cấp hay trị liệu. Tính năng này luôn miễn phí.'**
  String get usSafetyDisclaimer;

  /// US-14
  ///
  /// In vi, this message translates to:
  /// **'lần check-in'**
  String get usCoupleWeekCheckins;

  /// US-14
  ///
  /// In vi, this message translates to:
  /// **'Hai bạn đã chia sẻ hôm nay mình thế nào'**
  String get usCoupleWeekCheckinsSub;

  /// US-14
  ///
  /// In vi, this message translates to:
  /// **'lời nhờ được hỗ trợ'**
  String get usCoupleWeekRequests;

  /// US-14
  ///
  /// In vi, this message translates to:
  /// **'Nhận và làm giúp nhau'**
  String get usCoupleWeekRequestsSub;

  /// US-14
  ///
  /// In vi, this message translates to:
  /// **'lời cảm ơn'**
  String get usCoupleWeekThanks;

  /// US-14
  ///
  /// In vi, this message translates to:
  /// **'Gửi cho nhau trong tuần'**
  String get usCoupleWeekThanksSub;

  /// US-14
  ///
  /// In vi, this message translates to:
  /// **'nhiệm vụ cùng nhau'**
  String get usCoupleWeekTogether;

  /// US-14
  ///
  /// In vi, this message translates to:
  /// **'Từ Nhiệm vụ hai ta'**
  String get usCoupleWeekTogetherSub;

  /// US-14
  ///
  /// In vi, this message translates to:
  /// **'MỘT LỜI CẢM ƠN TRONG TUẦN'**
  String get usCoupleWeekThanksKicker;

  /// US-14
  ///
  /// In vi, this message translates to:
  /// **'{callName} · {date}'**
  String usCoupleWeekThanksMeta(String callName, String date);

  /// US-14
  ///
  /// In vi, this message translates to:
  /// **'Hai ta đã cùng nhau'**
  String get usCoupleWeekTogetherLabel;

  /// US-14
  ///
  /// In vi, this message translates to:
  /// **'Không có điểm số, không so sánh — chỉ là những điều hai bạn đã làm cho nhau.'**
  String get usCoupleWeekNote;

  /// US-14
  ///
  /// In vi, this message translates to:
  /// **'Gửi một lời cảm ơn'**
  String get usCoupleWeekSendThanks;

  /// REC-01
  ///
  /// In vi, this message translates to:
  /// **'Bỏ'**
  String get recapDayDiscard;

  /// REC-01 kicker
  ///
  /// In vi, this message translates to:
  /// **'CÂU CHUYỆN NGÀY · {date}'**
  String recapDayKicker(String date);

  /// REC-01 bé
  ///
  /// In vi, this message translates to:
  /// **'{name} · {age}'**
  String recapDayChild(String name, String age);

  /// REC-01
  ///
  /// In vi, this message translates to:
  /// **'Viết lại'**
  String get recapDayRewrite;

  /// REC-01
  ///
  /// In vi, this message translates to:
  /// **'Tự viết'**
  String get recapDayManual;

  /// REC-01 snack
  ///
  /// In vi, this message translates to:
  /// **'Đã viết lại đoạn văn'**
  String get recapDayRewritten;

  /// REC-01
  ///
  /// In vi, this message translates to:
  /// **'Ký ức hôm nay'**
  String get recapDayMemories;

  /// REC-01
  ///
  /// In vi, this message translates to:
  /// **'Đã chọn {selected}/{total}'**
  String recapDaySelected(int selected, int total);

  /// REC-01 dòng ký ức
  ///
  /// In vi, this message translates to:
  /// **'{kind, select, photo{Ảnh} mission{Nhiệm vụ đã xong} voice{Giọng nói} quote{Câu nói} video{Video} other{Ký ức}} · {time}'**
  String recapDayItemMeta(String kind, String time);

  /// REC-01
  ///
  /// In vi, this message translates to:
  /// **'Câu chuyện chỉ dùng những ký ức bạn đã tick.'**
  String get recapDayHint;

  /// REC-01
  ///
  /// In vi, this message translates to:
  /// **'Ảnh kèm'**
  String get recapDayPhotos;

  /// REC-01
  ///
  /// In vi, this message translates to:
  /// **'Ai sẽ thấy'**
  String get recapDayWhoSees;

  /// REC-01
  ///
  /// In vi, this message translates to:
  /// **'Lưu câu chuyện'**
  String get recapDaySave;

  /// REC-01 snack
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu câu chuyện ngày'**
  String get recapDaySaved;

  /// REC-01 sheet sửa tiêu đề
  ///
  /// In vi, this message translates to:
  /// **'Tiêu đề câu chuyện'**
  String get recapDayTitleEdit;

  /// HOME-02 → REC-01 (nhãn trợ năng)
  ///
  /// In vi, this message translates to:
  /// **'Câu chuyện ngày của {name}'**
  String recapDayOpen(String name);

  /// REC-03 tiêu đề
  ///
  /// In vi, this message translates to:
  /// **'{name} tròn {month} tháng 🎉'**
  String recapMonthHeadline(String name, int month);

  /// REC-03 phụ đề
  ///
  /// In vi, this message translates to:
  /// **'Tháng thứ {month} · {range}'**
  String recapMonthRange(int month, String range);

  /// REC-03 ảnh tháng trước
  ///
  /// In vi, this message translates to:
  /// **'Tháng {month}'**
  String recapMonthLabel(int month);

  /// REC-03 ảnh tháng này
  ///
  /// In vi, this message translates to:
  /// **'Tháng {month} · hôm nay'**
  String recapMonthNow(int month);

  /// REC-03
  ///
  /// In vi, this message translates to:
  /// **'câu nói & giọng nói'**
  String get recapMonthVoices;

  /// REC-03
  ///
  /// In vi, this message translates to:
  /// **'CÂU NÓI & GIỌNG NÓI'**
  String get recapMonthVoicesKicker;

  /// REC-03 lần đầu
  ///
  /// In vi, this message translates to:
  /// **'{age} · {date}'**
  String recapMonthFirstMeta(String age, String date);

  /// REC-03 giọng nói
  ///
  /// In vi, this message translates to:
  /// **'{date} · {callName} ghi'**
  String recapMonthVoiceMeta(String date, String callName);

  /// CARE ⋯ → CARE-11
  ///
  /// In vi, this message translates to:
  /// **'Thống kê chăm con'**
  String get careMenuStats;

  /// CARE-11
  ///
  /// In vi, this message translates to:
  /// **'Nhiệm vụ cả nhà đã hoàn thành'**
  String get careStatsDone;

  /// CARE-11
  ///
  /// In vi, this message translates to:
  /// **'việc trong tuần'**
  String get careStatsUnit;

  /// CARE-11 nhãn cột
  ///
  /// In vi, this message translates to:
  /// **'{category, select, care{Chăm sóc} bonding{Gắn kết} outing{Ra ngoài} support{Hỗ trợ nhau} together{Cùng nhau} other{Khác}}'**
  String careStatsCategory(String category);

  /// CARE-11 (mục 7.15)
  ///
  /// In vi, this message translates to:
  /// **'Nhiệm vụ “Hai ta” không tính vào chăm con.'**
  String get careStatsNote;

  /// CARE-11
  ///
  /// In vi, this message translates to:
  /// **'/ {total} ngày'**
  String careStatsBloomOf(int total);

  /// CARE-11
  ///
  /// In vi, this message translates to:
  /// **'cây của nhà mình nở hoa'**
  String get careStatsBloomLabel;

  /// CARE-11 disclaimer cố định (mục 7.15)
  ///
  /// In vi, this message translates to:
  /// **'Chỉ dựa trên hoạt động ghi trong app. Còn rất nhiều điều bố mẹ làm cho nhau mà app không đếm được.'**
  String get careStatsDisclaimer;

  /// CARE-11
  ///
  /// In vi, this message translates to:
  /// **'Chỉ Papa & Mama xem được thống kê này'**
  String get careStatsPrivacy;

  /// Bộ chọn tuần — nhãn trợ năng (US-14, CARE-11)
  ///
  /// In vi, this message translates to:
  /// **'Tuần trước'**
  String get commonPrevWeek;

  /// Bộ chọn tuần — nhãn trợ năng (US-14, CARE-11)
  ///
  /// In vi, this message translates to:
  /// **'Tuần sau'**
  String get commonNextWeek;

  /// Parent notification after a relative posts (CIR-04 → MEM-19)
  ///
  /// In vi, this message translates to:
  /// **'{name} vừa đăng {count} ảnh của {child} — chờ bạn duyệt'**
  String memPendingNotify(String name, int count, String child);

  /// AUTH-01: Apple/Google sign-in is not wired to the server yet (local API build).
  ///
  /// In vi, this message translates to:
  /// **'Bản này chưa hỗ trợ đăng nhập bằng Apple/Google. Vui lòng dùng số điện thoại.'**
  String get authProviderUnavailable;

  /// ONB-WAIT final approval dialog title (business spec 7.3 step 6).
  ///
  /// In vi, this message translates to:
  /// **'{callName} muốn tham gia nhà mình'**
  String onboardingPartnerApproveTitle(String callName);

  /// ONB-WAIT final approval dialog body.
  ///
  /// In vi, this message translates to:
  /// **'Hãy chắc chắn đây đúng là bạn đời của bạn. Sau khi đồng ý, nhà mình được dùng thử miễn phí {days} ngày.'**
  String onboardingPartnerApproveBody(int days);

  /// ONB-WAIT final approval: approve button.
  ///
  /// In vi, this message translates to:
  /// **'Đồng ý'**
  String get onboardingPartnerApprove;

  /// ONB-WAIT final approval: reject button (wrong person).
  ///
  /// In vi, this message translates to:
  /// **'Không phải'**
  String get onboardingPartnerReject;

  /// AUTH-03: wrong/expired OTP (OTP_INVALID).
  ///
  /// In vi, this message translates to:
  /// **'Mã chưa đúng hoặc đã hết hạn. Vui lòng thử lại.'**
  String get errorOtpInvalid;

  /// 429 RATE_LIMITED / INVITE_DAILY_LIMIT.
  ///
  /// In vi, this message translates to:
  /// **'Bạn thao tác hơi nhanh. Vui lòng đợi một chút rồi thử lại.'**
  String get errorRateLimited;

  /// AUTH-02: PHONE_NOT_SUPPORTED.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại này chưa được hỗ trợ.'**
  String get errorPhoneNotSupported;

  /// INV-01: INVITE_EXPIRED / INVITE_ALREADY_USED.
  ///
  /// In vi, this message translates to:
  /// **'Lời mời đã hết hạn hoặc đã được dùng. Nhờ người mời gửi lại nhé.'**
  String get errorInviteUnavailable;

  /// ALREADY_PARENT_OF_ANOTHER_FAMILY / PARENT_SLOTS_FULL.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang là Bố/Mẹ của một gia đình khác nên chưa tham gia được.'**
  String get errorAlreadyInFamily;

  /// 503 SERVICE_UNAVAILABLE.
  ///
  /// In vi, this message translates to:
  /// **'Máy chủ đang bận. Vui lòng thử lại sau ít phút.'**
  String get errorServiceUnavailable;

  /// MEM-09: tiêu đề màn sửa ký ức và mục trong menu ⋯ của MEM-07
  ///
  /// In vi, this message translates to:
  /// **'Sửa ký ức'**
  String get memEditTitle;

  /// MEM-09: snackbar sau khi lưu thay đổi
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu thay đổi'**
  String get memEditSaved;

  /// MEM-09: Parent không phải tác giả — trường bị khoá (đặc tả 7.8.3)
  ///
  /// In vi, this message translates to:
  /// **'Chỉ người đăng sửa được chú thích và ngày. Bạn vẫn đổi được bé và người xem.'**
  String get memEditAuthorOnlyHint;

  /// MEM-09: băng ảnh khi sửa (chưa hỗ trợ đổi ảnh)
  ///
  /// In vi, this message translates to:
  /// **'Chưa thêm hoặc bớt ảnh được khi sửa ký ức.'**
  String get memEditMediaHint;

  /// Lỗi 412 VERSION_CONFLICT khi sửa
  ///
  /// In vi, this message translates to:
  /// **'Ký ức vừa được cập nhật ở nơi khác. Xem lại rồi lưu nhé.'**
  String get errorVersionConflict;

  /// Lỗi MEMORY_FIELD_NOT_EDITABLE / MEMORY_VISIBILITY_INVALID
  ///
  /// In vi, this message translates to:
  /// **'Bạn không sửa được phần này của ký ức.'**
  String get errorMemoryNotEditable;

  /// US-03: 422 REQUEST_OPEN_LIMIT (BR-067)
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang có 5 lời nhờ chưa xong. Chờ bớt một lời nhờ rồi gửi tiếp nhé.'**
  String get errorRequestOpenLimit;

  /// US-03: 422 REQUEST_RESEND_BLOCKED (12 giờ sau khi bị từ chối)
  ///
  /// In vi, this message translates to:
  /// **'Lời nhờ này vừa được trả lời “Hôm nay không được”. Thử lại sau nhé.'**
  String get errorRequestResendBlocked;

  /// US-04: 409 INVALID_REQUEST_TRANSITION / REQUEST_REMINDER_USED
  ///
  /// In vi, this message translates to:
  /// **'Lời nhờ vừa thay đổi. Xem lại trạng thái mới nhé.'**
  String get errorRequestChanged;

  /// NOTI-01: tên người thao tác khi không xác định được
  ///
  /// In vi, this message translates to:
  /// **'Một thành viên'**
  String get notiSomeone;

  /// NOTI-01 NOTI_MEMORY_PUBLISHED
  ///
  /// In vi, this message translates to:
  /// **'{name} vừa thêm một ký ức mới'**
  String notiMemoryPublished(String name);

  /// NOTI-01 NOTI_COMMENT_CREATED (gộp 30 phút)
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =1{{name} vừa bình luận một ký ức} other{Có {count} bình luận mới trên một ký ức}}'**
  String notiCommentCreated(String name, int count);

  /// NOTI-01 NOTI_REACTION_CHANGED (gộp 30 phút)
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =1{{name} đã thả cảm xúc cho một ký ức} other{Có {count} cảm xúc mới trên một ký ức}}'**
  String notiReactionChanged(String name, int count);

  /// NOTI-01 NOTI_REQUEST_CREATED
  ///
  /// In vi, this message translates to:
  /// **'{name} vừa gửi cho bạn một lời nhờ'**
  String notiRequestCreated(String name);

  /// NOTI-01 NOTI_REQUEST_ACCEPTED
  ///
  /// In vi, this message translates to:
  /// **'{name} đã nhận lời nhờ của bạn'**
  String notiRequestAccepted(String name);

  /// NOTI-01 NOTI_REQUEST_DONE
  ///
  /// In vi, this message translates to:
  /// **'{name} đã làm xong lời nhờ 💛'**
  String notiRequestDone(String name);

  /// NOTI-01 NOTI_REQUEST_DECLINED (giọng trung tính, BR-067)
  ///
  /// In vi, this message translates to:
  /// **'{name} báo hôm nay chưa làm được lời nhờ'**
  String notiRequestDeclined(String name);

  /// NOTI-01 NOTI_REQUEST_ACKNOWLEDGED
  ///
  /// In vi, this message translates to:
  /// **'{name} đã xem lời nhờ của bạn'**
  String notiRequestAcknowledged(String name);

  /// NOTI-01 NOTI_CHECKIN_SHARED (nhạy cảm, không hiện cảm xúc)
  ///
  /// In vi, this message translates to:
  /// **'{name} vừa chia sẻ trạng thái'**
  String notiCheckinShared(String name);

  /// NOTI-01 NOTI_APPRECIATION_CREATED
  ///
  /// In vi, this message translates to:
  /// **'Bạn nhận được một lời cảm ơn ❤️'**
  String get notiAppreciationCreated;

  /// NOTI-01: mẫu chưa biết (server mới hơn app)
  ///
  /// In vi, this message translates to:
  /// **'Bạn có một cập nhật mới'**
  String get notiGeneric;

  /// CARE: dòng Hearts khi server không có tiêu đề (nhiệm vụ)
  ///
  /// In vi, this message translates to:
  /// **'Một việc nhỏ cho gia đình'**
  String get heartsReasonMission;

  /// CARE: dòng Hearts từ lời nhờ (REQUEST_DONE)
  ///
  /// In vi, this message translates to:
  /// **'Giúp bạn đời một lời nhờ'**
  String get heartsReasonRequest;

  /// CARE: dòng Hearts khác
  ///
  /// In vi, this message translates to:
  /// **'Hearts của bạn'**
  String get heartsReasonOther;

  /// SET-09c: đã gửi OTP xác thực lại
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi mã xác thực tới {phone}'**
  String setDelOtpSent(String phone);

  /// Lỗi REAUTH_REQUIRED
  ///
  /// In vi, this message translates to:
  /// **'Phiên xác thực đã hết hạn. Bạn xác thực lại giúp mình nhé.'**
  String get errorReauthRequired;

  /// Lỗi EXPORT_ALREADY_ACTIVE
  ///
  /// In vi, this message translates to:
  /// **'Đang có một bản xuất chưa xong. Bạn đợi bản đó xong nhé.'**
  String get errorExportActive;

  /// Lỗi EVENT_DATE_INVALID / EVENT_LUNAR_DATE_INVALID
  ///
  /// In vi, this message translates to:
  /// **'Ngày của sự kiện chưa hợp lệ. Bạn kiểm tra lại nhé.'**
  String get errorEventDateInvalid;

  /// CARE-07: sinh nhật của bé (server tính)
  ///
  /// In vi, this message translates to:
  /// **'Sinh nhật {count} tuổi của {name}'**
  String calendarChildBirthday(String name, int count);

  /// CARE-07: tròn tháng của bé (server tính)
  ///
  /// In vi, this message translates to:
  /// **'{name} tròn {count} tháng'**
  String calendarChildMonthiversary(String name, int count);

  /// NOTI_EVENT_REMINDER (CAL-02)
  ///
  /// In vi, this message translates to:
  /// **'Nhắc lịch: {title}'**
  String notiEventReminder(String title);

  /// NOTI_EVENT_REMINDER của sự kiện riêng tư (không có tiêu đề)
  ///
  /// In vi, this message translates to:
  /// **'Bạn có một lịch hẹn sắp tới'**
  String get notiEventReminderPrivate;

  /// NOTI_BADGE_EARNED (CARE-10)
  ///
  /// In vi, this message translates to:
  /// **'Gia đình vừa nhận một huy hiệu mới 🏅'**
  String get notiBadgeEarned;

  /// MEM-07/09 bật/tắt bình luận theo ký ức
  ///
  /// In vi, this message translates to:
  /// **'Cho phép bình luận'**
  String get memCommentsAllow;

  /// MEM-07/09 bật/tắt bình luận theo ký ức
  ///
  /// In vi, this message translates to:
  /// **'Tắt thì mọi người vẫn thả cảm xúc được'**
  String get memCommentsAllowHint;

  /// MEM-07/09 bật/tắt bình luận theo ký ức
  ///
  /// In vi, this message translates to:
  /// **'Bình luận đã tắt cho ký ức này'**
  String get memCommentsOff;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'vi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
