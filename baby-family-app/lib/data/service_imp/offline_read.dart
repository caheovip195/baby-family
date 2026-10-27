import 'package:baby_family/data/service_imp/outbox_runner.dart';
import 'package:logger/logger.dart';

/// Đọc từ server theo kiểu offline-first (BF-20261022-005): mất mạng / server
/// quá tải → null để nơi gọi dùng bản trên máy thay vì làm hỏng cả màn hình.
/// Lỗi khác (4xx, lỗi lập trình) vẫn được ném.
Future<T?> whenOnline<T>(Future<T> Function() call, {String? what}) async {
  try {
    return await call();
  } on Object catch (error) {
    if (!OutboxRunner.isTransient(error)) {
      rethrow;
    }
    Logger().w('Mất mạng, dùng dữ liệu trên máy (${what ?? 'đọc'}): $error');
    return null;
  }
}

/// Bộ đệm lần đọc thành công gần nhất theo khoá (trong phiên app): mất mạng →
/// trả lại bản đó để màn phụ (lịch sử, huy hiệu, thông báo, cài đặt…) vẫn mở
/// được; chưa đọc lần nào thì ném lỗi gốc như trước (BF-20261026-007).
class OfflineReads {
  final _last = <String, Object?>{};

  Future<T> read<T>(List<Object?> key, Future<T> Function() call) async {
    final id = key.join('|');
    try {
      final value = await call();
      _last[id] = value;
      return value;
    } on Object catch (error) {
      if (!OutboxRunner.isTransient(error) || !_last.containsKey(id)) {
        rethrow;
      }
      Logger().w('Mất mạng, dùng bản đọc gần nhất ($id): $error');
      return _last[id] as T;
    }
  }

  /// Đổi gia đình / đăng xuất.
  void clear() => _last.clear();
}
