import 'dart:typed_data';

import 'package:baby_family/data/model/sync/outbox_entry.dart';
import 'package:baby_family/data/model/year_book/year_book.dart';
import 'package:baby_family/data/repository/local_db.dart';
import 'package:baby_family/data/repository/outbox.dart';
import 'package:baby_family/data/repository/year_book_remote.dart';
import 'package:baby_family/data/service_imp/outbox_runner.dart';
import 'package:baby_family/data/service_imp/year_book.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

/// REC-04 qua server (BF-20261028-013), offline-first: bản đọc gần nhất lưu
/// ở local DB; bản chỉnh sửa gửi qua outbox (`PUT` ghi đè cả bản nên gửi lại
/// an toàn), bản sau thay bản chưa gửi của cùng bé + năm.
class YearBookRemoteServiceImp extends YearBookServiceImp {
  YearBookRemoteServiceImp(super.sessionRepository, super.clock, this._remote);

  final IYearBookRemoteRepository _remote;

  IOutboxRepository? get outbox => _outbox.store;
  set outbox(IOutboxRepository? store) => _outbox.store = store;

  /// null (test) = chỉ trong RAM.
  ILocalDb? localDb;

  static const _kind = 'yearbook.put';
  static const _table = 'year_book';
  static const _uuid = Uuid();

  late final OutboxRunner _outbox = OutboxRunner(
    send: (entry) => _remote.put(
      // Bản chờ gửi từ trước BF-20261030-001 chưa ghi gia đình.
      entry.args['familyId'] as String? ?? _serverFamilyId ?? '',
      entry.args['childId'] as String?,
      entry.args['year'] as int,
      Map<String, dynamic>.from(entry.args['body'] as Map),
    ),
    onState: (entry, state) {
      if (state == OutboxState.failed) {
        // Server từ chối (ký ức không còn xem được, hết quyền…): bỏ.
        _outbox.remove(entry.id);
      }
    },
  );

  final _last = <String, YearBookRecord>{};

  String? get _serverFamilyId =>
      sessionRepository.session()[kValueSessionKeyServerFamilyId] as String?;

  @override
  Future<YearBookRecord> book(String? childId, int year) async {
    final scope = _serverFamilyId;
    if (scope == null) {
      return super.book(childId, year);
    }
    await _outbox.load();
    final key = '${childId ?? 'family'}|$year';
    YearBookRecord server;
    try {
      server =
          await _remote.get(scope, childId, year) ??
          YearBookRecord(childId: childId, year: year);
      _last[key] = server;
      await _store(scope, key, server);
    } on DioException catch (error) {
      if (!OutboxRunner.isTransient(error)) {
        rethrow;
      }
      final cached = _last[key] ?? await _stored(scope, key);
      if (cached == null) {
        rethrow;
      }
      server = cached;
    }
    return _withPending(server);
  }

  @override
  Future<YearBookRecord> save(YearBookRecord book) async {
    final familyId = _serverFamilyId;
    if (familyId == null) {
      return super.save(book);
    }
    await _outbox.load();
    for (final pending in [..._outbox.entries]) {
      if (_sameBook(pending, book) && pending.id != _outbox.active) {
        await _outbox.remove(pending.id);
      }
    }
    final sent = await _outbox.submit(
      OutboxEntry(
        id: _uuid.v4(),
        kind: _kind,
        args: {
          'familyId': familyId,
          'childId': book.childId,
          'year': book.year,
          'body': book.saveBody(),
        },
        createdAt: now,
      ),
    );
    if (sent) {
      return this.book(book.childId, book.year);
    }
    return book.copyWith(saved: true, pending: true);
  }

  /// Danh sách đọc gần nhất (mất mạng: dùng lại).
  List<YearBookSummary>? _lastList;

  @override
  Future<List<YearBookSummary>> books() async {
    final scope = _serverFamilyId;
    if (scope == null) {
      return super.books();
    }
    try {
      return _lastList = await _remote.list(scope);
    } on DioException catch (error) {
      final cached = _lastList;
      if (!OutboxRunner.isTransient(error) || cached == null) {
        rethrow;
      }
      return cached;
    }
  }

  @override
  Future<Uint8List?> photo(YearBookPhoto photo) async {
    final url = photo.url;
    if (url == null) {
      return null;
    }
    try {
      return await _remote.download(url);
    } on Object catch (error) {
      Logger().w('Không tải được ảnh cho sách: $error');
      return null;
    }
  }

  @override
  Future<void> syncPending() => _outbox.syncAll();

  bool _sameBook(OutboxEntry entry, YearBookRecord book) =>
      entry.args['childId'] == book.childId && entry.args['year'] == book.year;

  YearBookRecord _withPending(YearBookRecord server) {
    for (final entry in _outbox.entries.toList().reversed) {
      if (_sameBook(entry, server)) {
        return server
            .withDraft(Map<String, dynamic>.from(entry.args['body'] as Map))
            .copyWith(pending: true);
      }
    }
    return server;
  }

  Future<void> _store(String scope, String key, YearBookRecord book) async {
    final db = localDb;
    if (db == null) {
      return;
    }
    try {
      await db.ensureSchema(kValueLocalDbSchemaVersion);
      await db.putRows(scope, _table, [
        {'id': key, ...book.toJson()},
      ]);
    } on Object catch (error) {
      Logger().w('Không lưu được sách trên máy: $error');
    }
  }

  Future<YearBookRecord?> _stored(String scope, String key) async {
    final db = localDb;
    if (db == null) {
      return null;
    }
    try {
      for (final row in await db.rows(scope, _table)) {
        if (row['id'] == key) {
          return YearBookRecord.fromJson(row);
        }
      }
    } on Object catch (error) {
      Logger().w('Không đọc được sách đã lưu trên máy: $error');
    }
    return null;
  }
}
