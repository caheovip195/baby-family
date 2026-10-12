import 'package:baby_family/data/model/settings/data_export_info.dart';
import 'package:baby_family/data/model/settings/delete_account_info.dart';
import 'package:baby_family/data/model/settings/help_info.dart';
import 'package:baby_family/data/model/settings/notification_settings.dart';
import 'package:baby_family/data/model/settings/privacy_settings.dart';
import 'package:baby_family/data/model/settings/profile_settings.dart';
import 'package:baby_family/data/model/settings/security_settings.dart';
import 'package:baby_family/data/service/base.dart';
import 'package:baby_family/utils/constants/enum.dart';

/// Cài đặt cá nhân (SET-02/03/04/07/08/09/11). Bản mock: mọi thao tác thành
/// công ngay; dữ liệu theo `assets/data/mock/settings.json`.
abstract class ISettingsService extends IBaseService {
  /// SET-02.
  Future<ProfileSettings> profileSettings();

  Future<void> saveProfileSettings(ProfileSettings settings);

  /// SET-03.
  Future<NotificationSettings> notificationSettings();

  Future<void> saveNotificationSettings(NotificationSettings settings);

  /// SET-04.
  Future<PrivacySettings> privacySettings();

  Future<void> savePrivacySettings(PrivacySettings settings);

  /// SET-07.
  Future<SecuritySettings> securitySettings();

  Future<void> saveSecuritySettings(SecuritySettings settings);

  Future<void> signOutDevice(String deviceId);

  /// “Đăng xuất mọi thiết bị” (mock: giữ lại thiết bị này).
  Future<void> signOutOtherDevices();

  /// SET-08.
  Future<DataExportInfo> dataExport();

  Future<void> startExport(DataExportKind kind);

  Future<void> clearCache();

  /// SET-09/09b/09c — `onlyParent` chọn biến thể 09b.
  Future<DeleteAccountInfo> deleteAccountInfo();

  /// SET-09c “Xoá tài khoản”: mock đăng xuất và nạp lại seed `fresh`.
  Future<void> deleteAccount();

  /// SET-11.
  Future<HelpInfo> help();
}
