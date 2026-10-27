import 'dart:async';

import 'package:baby_family/data/model/sync/outbox_entry.dart';
import 'package:baby_family/data/repository/outbox.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

/// Kết quả một lần gửi thao tác outbox, báo cho service cập nhật giao diện.
enum OutboxState {
  /// Bắt đầu gửi.
  sending,

  /// Mất mạng / server quá tải: tự gửi lại sau (backoff) hoặc khi có mạng.
  waiting,

  /// Server từ chối (4xx nghiệp vụ): chờ người dùng thử lại hoặc huỷ.
  failed,

  /// Server đã nhận; thao tác rời hàng đợi.
  done,
}

/// Hàng đợi ghi offline-first dùng chung cho các service (BF-20261022-002):
/// lưu bền qua [store], gửi lần lượt từng thao tác, phân loại lỗi tạm thời /
/// bị từ chối, lùi thời gian thử lại và gửi lại ngay khi có mạng
/// ([syncAll]). Mỗi service tự quyết định cách gửi ([send]) và hiển thị
/// ([onState], [onRestore]).
class OutboxRunner {
  OutboxRunner({required this.send, required this.onState, this.onRestore});

  /// Gửi một thao tác lên server; ném lỗi khi chưa xong.
  final Future<void> Function(OutboxEntry entry) send;
  final void Function(OutboxEntry entry, OutboxState state) onState;

  /// Thao tác đọc lại từ máy lúc mở app (hiện lại bản tạm trên giao diện).
  final void Function(OutboxEntry entry)? onRestore;

  /// null (mock, test) = chỉ giữ trong RAM.
  IOutboxRepository? store;

  final _entries = <String, OutboxEntry>{};
  final _rejected = <String, Object>{};
  final _timers = <String, Timer>{};
  Future<void>? _loading;
  Future<void> _queue = Future.value();

  /// Thao tác đang gửi (null khi rảnh).
  String? active;

  static const _uuid = Uuid();

  Iterable<OutboxEntry> get entries => _entries.values;

  OutboxEntry? operator [](String id) => _entries[id];

  bool contains(String id) => _entries.containsKey(id);

  /// Chờ các thao tác đã xếp hàng gửi xong (test).
  Future<void> get settled => _queue;

  /// Idempotency-Key ổn định của thao tác (giữ nguyên qua lần tắt/mở app);
  /// [part] tách các lệnh con của cùng thao tác.
  static String keyOf(String entryId, [String part = '']) =>
      _uuid.v5(Namespace.url.value, 'baby-family:$entryId:$part');

  /// Đọc hàng đợi đã lưu (một lần mỗi phiên) và xếp hàng gửi.
  Future<void> load() => _loading ??= () async {
    final saved = await store?.load() ?? const <OutboxEntry>[];
    for (final entry in saved) {
      _entries[entry.id] = entry;
      onRestore?.call(entry);
      if (!entry.failed) {
        schedule(entry.id);
      }
    }
    await store?.pruneFiles({for (final entry in saved) entry.id});
  }();

  Future<void> add(OutboxEntry entry) async {
    await load();
    _entries[entry.id] = entry;
    await _save();
    schedule(entry.id);
  }

  /// Bỏ thao tác chưa gửi (người dùng huỷ / thao tác sau thay thế).
  Future<bool> remove(String id) async {
    _timers.remove(id)?.cancel();
    _rejected.remove(id);
    if (_entries.remove(id) == null) {
      return false;
    }
    await _save();
    return true;
  }

  /// Thêm rồi chờ lần gửi đầu: true = server đã nhận, false = mất mạng (còn
  /// trong hàng đợi, tự gửi sau). Bị từ chối (4xx) → bỏ khỏi hàng đợi và ném
  /// lỗi của server để màn hình báo như khi gọi thẳng.
  Future<bool> submit(OutboxEntry entry) async {
    await add(entry);
    await _queue;
    final error = _rejected.remove(entry.id);
    if (error != null) {
      await remove(entry.id);
      throw error;
    }
    return !contains(entry.id);
  }

  /// Gửi lại thao tác bị từ chối; false khi không có trong hàng đợi.
  Future<bool> retry(String id) async {
    await load();
    final entry = _entries[id];
    if (entry == null) {
      return false;
    }
    _rejected.remove(id);
    _entries[id] = entry.copyWith(failed: false);
    await _save();
    schedule(id);
    await _queue;
    return true;
  }

  /// Gửi lại mọi thao tác đang chờ (vừa có mạng lại).
  Future<void> syncAll() async {
    await load();
    for (final entry in [..._entries.values]) {
      if (!entry.failed && entry.id != active) {
        schedule(entry.id);
      }
    }
  }

  /// Đổi gia đình / đăng xuất: bỏ hàng đợi của phiên cũ (bản lưu đã bị xoá
  /// cùng dữ liệu đăng nhập).
  void reset() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
    _entries.clear();
    _rejected.clear();
    _loading = null;
  }

  void schedule(String id) {
    _timers.remove(id)?.cancel();
    _queue = _queue.then((_) => _run(id));
  }

  Future<void> _save() async => store?.save(_entries.values.toList());

  Future<void> _run(String id) async {
    final entry = _entries[id];
    if (entry == null || entry.failed) {
      return;
    }
    active = id;
    onState(entry, OutboxState.sending);
    try {
      await send(entry);
      _entries.remove(id);
      await _save();
      onState(entry, OutboxState.done);
    } on Object catch (error) {
      Logger().w('Thao tác chờ đồng bộ chưa xong (${entry.kind}): $error');
      final retry = isTransient(error);
      if (!retry) {
        _rejected[id] = error;
      }
      final next = entry.copyWith(attempts: entry.attempts + 1, failed: !retry);
      if (!_entries.containsKey(id)) {
        return;
      }
      _entries[id] = next;
      await _save();
      onState(next, retry ? OutboxState.waiting : OutboxState.failed);
      if (retry) {
        _timers[id] = Timer(backoff(next.attempts), () {
          _timers.remove(id);
          schedule(id);
        });
      }
    } finally {
      active = null;
    }
  }

  /// Mất mạng, hết giờ, server quá tải → tự gửi lại; lỗi nghiệp vụ (4xx) →
  /// chờ người dùng.
  static bool isTransient(Object error) {
    if (error is! DioException) {
      return false;
    }
    final status = error.response?.statusCode;
    final body = error.response?.data;
    final code = body is Map && body['error'] is Map
        ? (body['error'] as Map)['code']
        : null;
    // Lần gửi trước còn đang xử lý trên server: giữ key, thử lại sau.
    if (code == 'IDEMPOTENCY_COMMAND_PENDING') {
      return true;
    }
    return status == null || status >= 500 || status == 408 || status == 429;
  }

  /// 30 giây, gấp đôi mỗi lần, tối đa 15 phút.
  static Duration backoff(int attempts) => Duration(
    seconds: (30 * (1 << (attempts - 1).clamp(0, 5))).clamp(30, 900),
  );
}
