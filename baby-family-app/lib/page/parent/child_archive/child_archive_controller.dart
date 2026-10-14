import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/child/child_archive_info.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/child.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// CHD-05 — Lưu trữ / Xoá bé: giải thích tác động (ký ức riêng ẩn theo, ký
/// ức chung còn ở anh/chị/em), Lưu trữ; Xoá vĩnh viễn (CHD-05b) chỉ khi đã
/// lưu trữ ≥ 7 ngày, xác nhận 2 lần (đánh dấu + gõ đúng tên bé).
final childArchiveControllerProvider = ChangeNotifierProvider.autoDispose
    .family<ChildArchiveController, String>(ChildArchiveController.new);

class ChildArchiveController extends BaseNotifier {
  ChildArchiveController(super.ref, this.childId) {
    load();
  }

  final String childId;

  IChildService get childService => ref.read(childServiceProvider);

  Child? child;
  ChildArchiveInfo? info;
  bool hasError = false;
  Map<String, String> _childNames = const {};
  Map<String, String> _callNames = const {};

  /// CHD-05b xác nhận 1/2.
  bool understood = false;

  /// CHD-05b xác nhận 2/2 — tên bé người dùng gõ.
  String typedName = '';

  DateTime get now => ref.read(appClockProvider).now();

  DateTime get today => ref.read(todayProvider);

  bool get isArchived => info?.archivedAt != null;

  bool get canDelete => isArchived && (info?.canDeleteAt(now) ?? false);

  /// Số ngày đã lưu trữ (CHD-05b “Lưu trữ 9 ngày”).
  int get archivedDays {
    final at = info?.archivedAt;
    if (at == null) {
      return 0;
    }
    return today.difference(DateTime(at.year, at.month, at.day)).inDays;
  }

  /// Ngày còn lại trước khi được xoá.
  int get daysUntilDelete {
    final from = info?.deletableFrom;
    return from == null ? 0 : from.difference(today).inDays.clamp(0, 1 << 10);
  }

  bool get nameMatches => typedName.trim() == (child?.name ?? '').trim();

  bool get canConfirmDelete => canDelete && understood && nameMatches;

  String? get addedByName => _callNames[info?.addedByUserId];

  String? get duplicateName => _childNames[info?.duplicateOfChildId];

  String get sharedWithNames => [
    for (final id in info?.sharedWithChildIds ?? const <String>[])
      ?_childNames[id],
  ].join(', ');

  Future<void> load() async {
    hasError = false;
    try {
      final (loaded, archive, children, members) = await (
        childService.child(childId),
        childService.archiveInfo(childId),
        childService.children(includeArchived: true),
        ref.read(familyServiceProvider).members(),
      ).wait;
      if (isDisposed) {
        return;
      }
      child = loaded;
      info = archive;
      _childNames = {for (final kid in children) kid.id: kid.name};
      _callNames = {
        for (final member in members)
          if (member.userId != null) member.userId!: member.callName,
      };
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    notifyListeners();
  }

  void toggleUnderstood() {
    understood = !understood;
    notifyListeners();
  }

  void typeName(String value) {
    typedName = value;
    notifyListeners();
  }

  Future<void> archive() async {
    await childService.archiveChild(childId);
    await load();
  }

  Future<void> restore() async {
    await childService.restoreChild(childId);
    await load();
  }

  Future<void> delete() => childService.deleteChild(childId);
}
