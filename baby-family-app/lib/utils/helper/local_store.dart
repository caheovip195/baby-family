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

  Future init() async {
    Hive.init(ApplicationDirectory().applicationDatabaseFolder);
    _encrypt = Encrypter(AES(await _loadKey(), mode: AESMode.gcm));
    final settingBox = await _getBox(boxName: LocalStoreKey.settingBoxName);
    final language = settingBox.get(LocalStoreKey.languageKey);
    _languageCode = language is String && language.isNotEmpty ? language : null;
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
  }
}
