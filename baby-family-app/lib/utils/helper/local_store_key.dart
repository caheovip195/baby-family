/// Tên box Hive và khoá lưu trữ cục bộ.
mixin LocalStoreKey {
  static const String deviceId = 'vn.babyfamily.app.deviceid';

  /// Khoá AES của [LocalStore], sinh ngẫu nhiên lần đầu và giữ trong
  /// Keychain/Keystore.
  static const String localStoreSecret = 'vn.babyfamily.app.localstore_secret';

  static const String authBoxName = 'vn.babyfamily.app.authbox';
  static const String settingBoxName = 'vn.babyfamily.app.settingbox';

  /// keys
  static const String authCertificateKey = 'auth_certificate';

  /// Ngôn ngữ người dùng chọn (`AppLanguage.code`).
  static const String languageKey = 'language';

  /// Bé đang chọn ở Child Switcher, lưu theo từng gia đình.
  static const String selectedSubjectPrefix = 'selected_subject_';
}
