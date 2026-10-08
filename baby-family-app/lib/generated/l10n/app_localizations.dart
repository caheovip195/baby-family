import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

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
  /// **'Mời ông bà, người thân xem cháu lớn lên — an toàn, không cần mạng xã hội.'**
  String get welcomeSlide3Description;

  /// ONB-01 — link nhập mã mời
  ///
  /// In vi, this message translates to:
  /// **'Tôi đã có mã mời'**
  String get welcomeHaveInviteCode;
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
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
