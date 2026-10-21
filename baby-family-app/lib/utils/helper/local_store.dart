import 'dart:convert';
import 'dart:math';

import 'package:baby_family/data/model/auth_certificate.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

import 'application_directory.dart';
import 'local_store_key.dart';

/// Lưu trữ cục bộ có mã hoá (Hive + AES-GCM).
///
/// Khác base hanoicheck: khoá AES không truyền qua `--dart-define` mà sinh
/// ngẫu nhiên trên máy và giữ trong Keychain/Keystore; mỗi lần mã hoá dùng IV
/// ngẫu nhiên (bắt buộc với GCM), lưu dạng `base64(iv).base64(cipher)`.
class LocalStore {
  factory LocalStore() => _singleton ??= LocalStore._();

  LocalStore._();

  static LocalStore? _singleton;

  static const _secureStorage = FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  late Encrypter _encrypt;

  String? _languageCode;

  /// Ngôn ngữ đã chọn (đọc sẵn lúc [init] để dùng đồng bộ ở interceptor,
  /// `MaterialApp`). `null` = chưa chọn, đi theo ngôn ngữ thiết bị.
  String? get languageCode => _languageCode;

  Map<String, dynamic>? _display;

  /// SET-06 hiển thị (giao diện, cỡ chữ, âm lịch) đã lưu trên máy — đọc sẵn
  /// lúc [init] để `MaterialApp` dựng đúng ngay từ khung đầu.
  Map<String, dynamic>? get displayPrefs => _display;

  Future init() async {
    Hive.init(ApplicationDirectory().applicationDatabaseFolder);
    _encrypt = Encrypter(AES(await _loadKey(), mode: AESMode.gcm));
    final settingBox = await _getBox(boxName: LocalStoreKey.settingBoxName);
    final language = settingBox.get(LocalStoreKey.languageKey);
    _languageCode = language is String && language.isNotEmpty ? language : null;
    final display = settingBox.get(LocalStoreKey.displayKey);
    try {
      _display = display is String
          ? Map<String, dynamic>.from(jsonDecode(display) as Map)
          : null;
    } on FormatException {
      _display = null;
    }
  }

  Future saveDisplayPrefs(Map<String, dynamic> prefs) async {
    final box = await _getBox(boxName: LocalStoreKey.settingBoxName);
    await box.put(LocalStoreKey.displayKey, jsonEncode(prefs));
    _display = prefs;
  }

  Future saveLanguageCode(String code) async {
    final box = await _getBox(boxName: LocalStoreKey.settingBoxName);
    await box.put(LocalStoreKey.languageKey, code);
    _languageCode = code;
  }

  Future<Key> _loadKey() async {
    var secret = await _secureStorage.read(key: LocalStoreKey.localStoreSecret);
    if (secret == null || secret.isEmpty) {
      final random = Random.secure();
      secret = base64Encode(List<int>.generate(32, (_) => random.nextInt(256)));
      await _secureStorage.write(
        key: LocalStoreKey.localStoreSecret,
        value: secret,
      );
    }
    return Key(base64Decode(secret));
  }

  Future<Box> _getBox({required String boxName}) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box(boxName);
    }
    return Hive.openBox(boxName);
  }

  String encryptData(String data) {
    final iv = IV.fromSecureRandom(12);
    final encrypted = _encrypt.encrypt(data, iv: iv);
    return '${iv.base64}.${encrypted.base64}';
  }

  String decryptData(String data) {
    final separator = data.indexOf('.');
    final iv = IV.fromBase64(data.substring(0, separator));
    return _encrypt.decrypt64(data.substring(separator + 1), iv: iv);
  }

  Future saveAuthCertificate(AuthCertificate certificate) async {
    final box = await _getBox(boxName: LocalStoreKey.authBoxName);
    await box.put(
      LocalStoreKey.authCertificateKey,
      encryptData(jsonEncode(certificate.toJson())),
    );
  }

  Future<AuthCertificate?> getAuthCertificate() async {
    try {
      final box = await _getBox(boxName: LocalStoreKey.authBoxName);
      final raw = box.get(LocalStoreKey.authCertificateKey, defaultValue: '');
      if (raw is! String || raw.isEmpty) {
        return null;
      }
      return AuthCertificate.fromJson(jsonDecode(decryptData(raw)));
    } catch (e) {
      return null;
    }
  }

  Future clearAuthCertificate() async {
    final box = await _getBox(boxName: LocalStoreKey.authBoxName);
    await box.clear();
  }

  /// Bé đang chọn ở Child Switcher (`ALL` hoặc id bé/thai kỳ) — chỉ là
  /// preference hiển thị, không phải quyền (tài liệu kỹ thuật 22.3).
  Future saveSelectedSubject(String familyId, String subjectKey) async {
    final box = await _getBox(boxName: LocalStoreKey.settingBoxName);
    await box.put(
      '${LocalStoreKey.selectedSubjectPrefix}$familyId',
      subjectKey,
    );
  }

  Future<String?> getSelectedSubject(String familyId) async {
    final box = await _getBox(boxName: LocalStoreKey.settingBoxName);
    final value = box.get('${LocalStoreKey.selectedSubjectPrefix}$familyId');
    return value is String && value.isNotEmpty ? value : null;
  }

  Future saveFamilySetupDone(String familyId) async {
    final box = await _getBox(boxName: LocalStoreKey.settingBoxName);
    await box.put('${LocalStoreKey.familySetupDonePrefix}$familyId', true);
  }

  Future<bool> isFamilySetupDone(String familyId) async {
    final box = await _getBox(boxName: LocalStoreKey.settingBoxName);
    return box.get('${LocalStoreKey.familySetupDonePrefix}$familyId') == true;
  }

  /// Mã/link lời mời bạn đời: server chỉ trả một lần khi tạo (BR-041).
  Future savePartnerInvite(String familyId, Map<String, dynamic> invite) async {
    final box = await _getBox(boxName: LocalStoreKey.settingBoxName);
    await box.put(
      '${LocalStoreKey.partnerInvitePrefix}$familyId',
      encryptData(jsonEncode(invite)),
    );
  }

  Future<Map<String, dynamic>?> getPartnerInvite(String familyId) async {
    try {
      final box = await _getBox(boxName: LocalStoreKey.settingBoxName);
      final raw = box.get('${LocalStoreKey.partnerInvitePrefix}$familyId');
      if (raw is! String || raw.isEmpty) {
        return null;
      }
      return Map<String, dynamic>.from(jsonDecode(decryptData(raw)) as Map);
    } catch (e) {
      return null;
    }
  }

  /// Bản chụp dữ liệu đã đồng bộ (mở app lúc mất mạng) — trong hộp auth nên
  /// bị xoá cùng phiên khi đăng xuất.
  Future saveOfflineSnapshot(Map<String, dynamic> snapshot) async {
    final box = await _getBox(boxName: LocalStoreKey.authBoxName);
    await box.put(
      LocalStoreKey.offlineSnapshotKey,
      encryptData(jsonEncode(snapshot)),
    );
  }

  Future<Map<String, dynamic>?> getOfflineSnapshot() async {
    try {
      final box = await _getBox(boxName: LocalStoreKey.authBoxName);
      final raw = box.get(LocalStoreKey.offlineSnapshotKey);
      if (raw is! String || raw.isEmpty) {
        return null;
      }
      return Map<String, dynamic>.from(jsonDecode(decryptData(raw)) as Map);
    } catch (e) {
      return null;
    }
  }

  /// Chỉ mục ảnh/video trong thư viện máy đã khớp với asset server (id thư
  /// viện, SHA-256 đã tính) — trong hộp auth nên xoá khi đăng xuất.
  Future saveLocalMediaIndex(Map<String, dynamic> index) async {
    final box = await _getBox(boxName: LocalStoreKey.authBoxName);
    await box.put(
      LocalStoreKey.localMediaIndexKey,
      encryptData(jsonEncode(index)),
    );
  }

  Future<Map<String, dynamic>> getLocalMediaIndex() async {
    try {
      final box = await _getBox(boxName: LocalStoreKey.authBoxName);
      final raw = box.get(LocalStoreKey.localMediaIndexKey);
      if (raw is! String || raw.isEmpty) {
        return {};
      }
      return Map<String, dynamic>.from(jsonDecode(decryptData(raw)) as Map);
    } catch (e) {
      return {};
    }
  }

  /// Đăng xuất / xoá tài khoản: xoá toàn bộ dữ liệu người dùng trên máy.
  Future clearAll() async {
    final authBox = await _getBox(boxName: LocalStoreKey.authBoxName);
    final settingBox = await _getBox(boxName: LocalStoreKey.settingBoxName);
    await authBox.clear();
    // Ngôn ngữ là lựa chọn của thiết bị — giữ lại sau khi đăng xuất.
    final language = _languageCode;
    await settingBox.clear();
    if (language != null) {
      await settingBox.put(LocalStoreKey.languageKey, language);
    }
    final display = _display;
    if (display != null) {
      await settingBox.put(LocalStoreKey.displayKey, jsonEncode(display));
    }
  }
}
