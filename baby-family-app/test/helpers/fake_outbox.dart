import 'package:baby_family/data/model/sync/outbox_entry.dart';
import 'package:baby_family/data/repository/outbox.dart';

/// Outbox lưu "trên máy" giả: giữ qua nhiều instance service (mô phỏng tắt /
/// mở lại app).
class FakeOutbox implements IOutboxRepository {
  List<OutboxEntry> entries = [];
  final discarded = <String>[];
  final cursors = <String, String>{};

  @override
  Future<List<OutboxEntry>> load() async => entries;

  @override
  Future<void> save(List<OutboxEntry> entries) async =>
      this.entries = [...entries];

  @override
  Future<List<String>> keepFiles(String entryId, List<String> paths) async =>
      paths;

  @override
  Future<void> discardFiles(String entryId) async => discarded.add(entryId);

  @override
  Future<void> pruneFiles(Set<String> keep) async {}

  @override
  Future<String?> cursor(String scope) async => cursors[scope];

  @override
  Future<void> saveCursor(String scope, String? cursor) async {
    if (cursor == null) {
      cursors.remove(scope);
    } else {
      cursors[scope] = cursor;
    }
  }
}
