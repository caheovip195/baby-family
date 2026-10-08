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
      'Mời ông bà, người thân xem cháu lớn lên — an toàn, không cần mạng xã hội.';

  @override
  String get welcomeHaveInviteCode => 'Tôi đã có mã mời';
}
