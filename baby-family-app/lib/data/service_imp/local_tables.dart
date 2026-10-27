import 'dart:async';
import 'dart:convert';

import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/local_db.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:logger/logger.dart';

/// Một bảng của kho trên máy được lưu bền (offline-first, BF-20261022-004).
class LocalTable {
  const LocalTable({
    required this.rows,
    required this.restore,
    required this.validate,
  });

  /// Dòng hiện có cần lưu (thường là bản phản chiếu của server).
  final List<JsonMap> Function() rows;

  /// Đưa một dòng đã lưu trở lại kho (khi kho chưa có).
  final void Function(JsonMap row) restore;

  /// Ném lỗi khi app hiện tại không đọc được dòng (bỏ dòng, không crash).
  final void Function(JsonMap row) validate;
}

/// Nạp / ghi các bảng của một service vào [ILocalDb]: mở app nạp lên trước
/// (dùng được khi mất mạng), thay đổi ghi gộp và chỉ ghi dòng đổi. Dòng không
/// đọc được bị bỏ và xoá; DB hỏng không chặn service.
class LocalTables {
  LocalTables(this.tables, {required this.scope});

  final Map<String, LocalTable> tables;

  /// Phạm vi hiện tại (id gia đình server); đổi → bỏ trạng thái phạm vi cũ.
  final String? Function() scope;

  /// null (mock, test) = tắt.
  ILocalDb? db;

  String? _scope;
  Future<void>? _loading;
  Timer? _timer;
  final _saved = <String, Map<String, String>>{};

  /// Đổi gia đình / đăng xuất.
  void reset() {
    _timer?.cancel();
    _timer = null;
    _scope = null;
    _loading = null;
    _saved.clear();
  }

  Future<void> hydrate() {
    final db = this.db;
    final scope = this.scope();
    if (_scope != null && _scope != scope) {
      reset();
    }
    if (db == null || scope == null || _scope == scope) {
      return Future.value();
    }
    return _loading ??= () async {
      try {
        await db.ensureSchema(kValueLocalDbSchemaVersion);
        for (final MapEntry(key: name, value: table) in tables.entries) {
          final saved = _saved[name] = {};
          final broken = <String>[];
          for (final row in await db.rows(scope, name)) {
            final id = row['id'];
            if (id is! String) {
              continue;
            }
            try {
              table.validate(row);
            } on Object catch (error) {
              Logger().w('Bỏ dòng $name lưu trên máy không đọc được: $error');
              broken.add(id);
              continue;
            }
            saved[id] = jsonEncode(row);
            table.restore(row);
          }
          await db.deleteRows(scope, name, broken);
        }
      } on Object catch (error) {
        Logger().w('Không đọc được dữ liệu trên máy: $error');
      }
      _scope = scope;
    }().whenComplete(() => _loading = null);
  }

  void schedule() {
    if (db == null) {
      return;
    }
    _timer?.cancel();
    _timer = Timer(kValueLocalDbWriteDelay, () {
      _timer = null;
      unawaited(flush());
    });
  }

  Future<void> flush() async {
    _timer?.cancel();
    _timer = null;
    final db = this.db;
    final scope = _scope;
    if (db == null || scope == null) {
      return;
    }
    if (this.scope() != scope) {
      // Đã đổi gia đình / đăng xuất: không ghi dữ liệu nhà mới vào nhà cũ.
      reset();
      return;
    }
    try {
      for (final MapEntry(key: name, value: table) in tables.entries) {
        final saved = _saved[name] ??= {};
        final rows = {
          for (final row in table.rows())
            if (row['id'] is String) row['id'] as String: row,
        };
        final changed = [
          for (final MapEntry(key: id, value: row) in rows.entries)
            if (saved[id] != jsonEncode(row)) row,
        ];
        final gone = saved.keys.where((id) => !rows.containsKey(id)).toList();
        await db.putRows(scope, name, changed);
        await db.deleteRows(scope, name, gone);
        for (final row in changed) {
          saved[row['id'] as String] = jsonEncode(row);
        }
        gone.forEach(saved.remove);
      }
    } on Object catch (error) {
      Logger().w('Không ghi được dữ liệu trên máy: $error');
    }
  }
}
