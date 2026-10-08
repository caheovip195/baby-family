import 'dart:io';

import 'package:path_provider/path_provider.dart';

class ApplicationDirectory {
  factory ApplicationDirectory() => _singleton ??= ApplicationDirectory._();

  ApplicationDirectory._();

  static ApplicationDirectory? _singleton;

  late String _applicationDocumentPath;
  late String _applicationSupportPath;
  late String _applicationDatabaseFolder;
  late String _applicationUploadFolder;
  late Directory _tempApplicationFolder;

  String get applicationDocumentPath => _applicationDocumentPath;

  String get applicationSupportPath => _applicationSupportPath;

  /// Hive box (chứng chỉ đăng nhập, cài đặt cục bộ).
  String get applicationDatabaseFolder => _applicationDatabaseFolder;

  /// File chờ tải lên (ảnh đã nén, HEIC đã đổi sang JPEG...).
  String get applicationUploadFolder => _applicationUploadFolder;

  Directory get tempApplicationFolder => _tempApplicationFolder;

  Future init() async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    final supportDirectory = await getApplicationSupportDirectory();
    _applicationDocumentPath = documentDirectory.path;
    _applicationSupportPath = supportDirectory.path;
    _tempApplicationFolder = await getTemporaryDirectory();

    _applicationDatabaseFolder = await _ensureFolder(
      '$_applicationSupportPath/database',
    );
    _applicationUploadFolder = await _ensureFolder(
      '$_applicationSupportPath/pending_uploads',
    );
  }

  Future<String> _ensureFolder(String path) async {
    final directory = Directory(path);
    if (!directory.existsSync()) {
      await directory.create(recursive: true);
    }
    return directory.path;
  }

  /// Xoá dữ liệu cục bộ khi đăng xuất / bị gỡ khỏi gia đình
  /// (tài liệu kỹ thuật mục 22.10).
  Future clearUserFiles() async {
    final uploadDir = Directory(_applicationUploadFolder);
    if (uploadDir.existsSync()) {
      await uploadDir.delete(recursive: true);
      await uploadDir.create(recursive: true);
    }
    await clearTempDirectory();
  }

  Future clearTempDirectory() async {
    if (!_tempApplicationFolder.existsSync()) {
      return;
    }
    for (final entity in _tempApplicationFolder.listSync()) {
      if (entity is File) {
        await entity.delete();
      }
    }
  }
}
