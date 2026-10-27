import 'dart:io';

import 'package:baby_family/data/model/sync/outbox_entry.dart';
import 'package:baby_family/data/repository/outbox.dart';
import 'package:baby_family/data/repository_imp/base.dart';
import 'package:baby_family/utils/helper/application_directory.dart';
import 'package:baby_family/utils/helper/lenient_json.dart';
import 'package:baby_family/utils/helper/local_store.dart';
import 'package:path/path.dart' as p;

/// [name] tách hàng đợi theo service (`memory`, `care`).
class OutboxRepositoryImp extends BaseRepositoryImp
    implements IOutboxRepository {
  OutboxRepositoryImp(this.name);

  final String name;

  String get _entriesKey => '${name}_outbox';
  String get _cursorsKey => '${name}_sync_cursors';

  @override
  Future<List<OutboxEntry>> load() async => lenientList(
    await LocalStore().getOutbox(_entriesKey),
    OutboxEntry.fromJson,
    label: 'thao tác chờ đồng bộ',
  );

  @override
  Future<void> save(List<OutboxEntry> entries) => LocalStore().saveOutbox(
    _entriesKey,
    [for (final e in entries) e.toJson()],
  );

  @override
  Future<String?> cursor(String scope) async =>
      ((await LocalStore().getOutbox(_cursorsKey) as Map?) ?? const {})[scope]
          as String?;

  @override
  Future<void> saveCursor(String scope, String? cursor) async {
    final cursors = Map<String, dynamic>.from(
      (await LocalStore().getOutbox(_cursorsKey) as Map?) ?? const {},
    );
    if (cursor == null) {
      cursors.remove(scope);
    } else {
      cursors[scope] = cursor;
    }
    await LocalStore().saveOutbox(_cursorsKey, cursors);
  }

  Directory _folder(String entryId) => Directory(
    p.join(ApplicationDirectory().applicationUploadFolder, 'outbox', entryId),
  );

  @override
  Future<List<String>> keepFiles(String entryId, List<String> paths) async {
    final folder = _folder(entryId);
    await folder.create(recursive: true);
    final kept = <String>[];
    for (final (index, path) in paths.indexed) {
      final target = p.join(folder.path, '$index-${p.basename(path)}');
      if (path == target || !File(path).existsSync()) {
        kept.add(path);
        continue;
      }
      await File(path).copy(target);
      kept.add(target);
    }
    return kept;
  }

  @override
  Future<void> discardFiles(String entryId) async {
    final folder = _folder(entryId);
    if (folder.existsSync()) {
      await folder.delete(recursive: true);
    }
  }

  @override
  Future<void> pruneFiles(Set<String> keep) async {
    final root = Directory(
      p.join(ApplicationDirectory().applicationUploadFolder, 'outbox'),
    );
    if (!root.existsSync()) {
      return;
    }
    for (final folder in root.listSync().whereType<Directory>()) {
      if (!keep.contains(p.basename(folder.path))) {
        await folder.delete(recursive: true);
      }
    }
  }
}
