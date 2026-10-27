/// Tên box Hive và khoá lưu trữ cục bộ.
mixin LocalStoreKey {
  static const String deviceId = 'vn.babyfamily.app.deviceid';

  /// Khoá AES của [LocalStore], sinh ngẫu nhiên lần đầu và giữ trong
  /// Keychain/Keystore.
  static const String localStoreSecret = 'vn.babyfamily.app.localstore_secret';

  static const String authBoxName = 'vn.babyfamily.app.authbox';
  static const String settingBoxName = 'vn.babyfamily.app.settingbox';

  /// Local DB offline-first (BF-20261022-003): mỗi dòng một khoá, giá trị mã
  /// hoá; xoá khi đăng xuất.
  static const String localDbBoxName = 'vn.babyfamily.app.localdb';

  /// keys
  static const String authCertificateKey = 'auth_certificate';

  /// Ngôn ngữ người dùng chọn (`AppLanguage.code`).
  static const String languageKey = 'language';
  static const String displayKey = 'display';
  static const String offlineSnapshotKey = 'offline_snapshot';
  static const String localMediaIndexKey = 'local_media_index';

  /// Bé đang chọn ở Child Switcher, lưu theo từng gia đình.
  static const String selectedSubjectPrefix = 'selected_subject_';

  /// Gia đình đã xong thiết lập ONB-ACT → ONB-09 trên máy này (`setupDone_{fid}`).
  static const familySetupDonePrefix = 'setupDone_';

  /// Lời mời bạn đời vừa tạo (mã/link chỉ trả một lần) — lưu mã hoá.
  static const partnerInvitePrefix = 'partnerInvite_';
}
