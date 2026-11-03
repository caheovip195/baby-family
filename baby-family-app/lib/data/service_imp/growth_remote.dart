import 'package:baby_family/data/model/growth/growth_entry.dart';
import 'package:baby_family/data/model/sync/outbox_entry.dart';
import 'package:baby_family/data/repository/growth_remote.dart';
import 'package:baby_family/data/repository/local_db.dart';
import 'package:baby_family/data/repository/outbox.dart';
import 'package:baby_family/data/service_imp/growth.dart';
import 'package:baby_family/data/service_imp/outbox_runner.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

/// CHD-06 qua server (BF-20261028-004), offline-first: lần đo lưu trên máy
/// trước rồi gửi qua outbox (`PUT` theo ngày nên gửi lại an toàn); danh sách
/// đọc gần nhất lưu ở local DB để mở được khi mất mạng.
class GrowthRemoteServiceImp extends GrowthServiceImp {
  GrowthRemoteServiceImp(super.sessionRepository, super.clock, this._remote);

  final IGrowthRemoteRepository _remote;

  IOutboxRepository? get outbox => _outbox.store;
  set outbox(IOutboxRepository? store) => _outbox.store = store;

  /// null (test) = chỉ trong RAM.
  ILocalDb? localDb;

  static const _putKind = 'growth.put';
  static const _deleteKind = 'growth.delete';
  static const _table = 'growth';
  static const _uuid = Uuid();

  late final OutboxRunner _outbox = OutboxRunner(
    send: _send,
    onState: (entry, state) {
      if (state == OutboxState.failed) {
        // Server từ chối (ngày không hợp lệ, không còn quyền…): bỏ.
        _outbox.remove(entry.id);
      }
    },
  );

  /// Bản đọc gần nhất trong phiên theo bé.
  final _last = <String, List<GrowthEntry>>{};

  String? get _serverFamilyId =>
      sessionRepository.session()[kValueSessionKeyServerFamilyId] as String?;

  Future<void> _send(OutboxEntry entry) async {
    final childId = entry.args['childId'] as String;
    final date = entry.args['date'] as String;
    if (entry.kind == _deleteKind) {
      await _remote.delete(childId, date);
      return;
    }
    await _remote.put(
      childId,
      date,
      Map<String, dynamic>.from(entry.args['body'] as Map),
    );
  }

  @override
  Future<List<GrowthEntry>> entries(String childId) async {
    final scope = _serverFamilyId;
    if (scope == null) {
      return super.entries(childId);
    }
    await _outbox.load();
    List<GrowthEntry> server;
    try {
      server = (await _remote.list(childId))?.items ?? const [];
      _last[childId] = server;
      await _save(scope, childId, server);
    } on DioException catch (error) {
      if (!OutboxRunner.isTransient(error)) {
        rethrow;
      }
      server = _last[childId] ?? await _saved(scope, childId);
    }
    return _withPending(childId, server);
  }

  @override
  Future<GrowthEntry> save(
    String childId, {
    required DateTime day,
    int? weightGrams,
    int? heightMm,
    String? note,
  }) async {
    if (_serverFamilyId == null) {
      return super.save(
        childId,
        day: day,
        weightGrams: weightGrams,
        heightMm: heightMm,
        note: note,
      );
    }
    final entry = GrowthServiceImp.entryOf(day, weightGrams, heightMm, note);
    final sent = await _queue(_putKind, childId, entry.measuredOn, {
      'weightGrams': entry.weightGrams,
      'heightMm': entry.heightMm,
      'note': entry.note,
    });
    return entry.copyWith(pending: !sent);
  }

  @override
  Future<void> remove(String childId, DateTime day) async {
    if (_serverFamilyId == null) {
      return super.remove(childId, day);
    }
    await _queue(_deleteKind, childId, GrowthServiceImp.day.format(day), {});
  }

  @override
  Future<void> syncPending() => _outbox.syncAll();

  /// Thao tác mới thay thao tác chưa gửi của cùng bé + ngày.
  Future<bool> _queue(
    String kind,
    String childId,
    String date,
    Map<String, dynamic> body,
  ) async {
    await _outbox.load();
    for (final pending in [..._outbox.entries]) {
      if (pending.args['childId'] == childId &&
          pending.args['date'] == date &&
          pending.id != _outbox.active) {
        await _outbox.remove(pending.id);
      }
    }
    return _outbox.submit(
      OutboxEntry(
        id: _uuid.v4(),
        kind: kind,
        args: {'childId': childId, 'date': date, 'body': body},
        createdAt: now,
      ),
    );
  }

  List<GrowthEntry> _withPending(String childId, List<GrowthEntry> server) {
    final byDay = {for (final item in server) item.measuredOn: item};
    for (final entry in _outbox.entries) {
      if (entry.args['childId'] != childId) {
        continue;
      }
      final date = entry.args['date'] as String;
      if (entry.kind == _deleteKind) {
        byDay.remove(date);
      } else {
        final body = Map<String, dynamic>.from(entry.args['body'] as Map);
        byDay[date] = GrowthEntry.fromJson({
          ...body,
          'measuredOn': date,
          'pending': true,
        });
      }
    }
    return GrowthServiceImp.sorted(byDay.values);
  }

  Future<void> _save(
    String scope,
    String childId,
    List<GrowthEntry> items,
  ) async {
    final db = localDb;
    if (db == null) {
      return;
    }
    try {
      await db.ensureSchema(kValueLocalDbSchemaVersion);
      final rows = await db.rows(scope, _table);
      await db.deleteRows(scope, _table, [
        for (final row in rows)
          if (row['childId'] == childId) row['id'] as String,
      ]);
      await db.putRows(scope, _table, [
        for (final item in items)
          {
            'id': '$childId|${item.measuredOn}',
            'childId': childId,
            ...item.toJson(),
          },
      ]);
    } on Object catch (error) {
      Logger().w('Không lưu được lần đo trên máy: $error');
    }
  }

  Future<List<GrowthEntry>> _saved(String scope, String childId) async {
    final db = localDb;
    if (db == null) {
      return const [];
    }
    try {
      await db.ensureSchema(kValueLocalDbSchemaVersion);
      final items = <GrowthEntry>[];
      for (final row in await db.rows(scope, _table)) {
        if (row['childId'] != childId) {
          continue;
        }
        try {
          items.add(GrowthEntry.fromJson(row));
        } on Object catch (error) {
          // Bản lưu từ phiên bản app khác không đọc được: bỏ dòng đó.
          Logger().w('Bỏ lần đo lưu trên máy: $error');
        }
      }
      return GrowthServiceImp.sorted(items);
    } on Object catch (error) {
      Logger().w('Không đọc được lần đo trên máy: $error');
      return const [];
    }
  }
}
