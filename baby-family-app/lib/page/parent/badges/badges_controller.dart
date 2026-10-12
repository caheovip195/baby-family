import 'package:baby_family/data/model/care/family_badge.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/provider/care.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/care.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// CARE-10 “Huy hiệu” (mục 9.7, Pencil `sCdEt`): lưới huy hiệu đã đạt (màu) /
/// chưa đạt (mờ + điều kiện + tiến độ); chạm → chi tiết + ngày đạt. Ghi nhận
/// cả nhà, không so sánh Bố – Mẹ (P2).
final badgesControllerProvider =
    ChangeNotifierProvider.autoDispose<BadgesController>(BadgesController.new);

class BadgesController extends BaseNotifier {
  BadgesController(super.ref) {
    ref.listen(mockRevisionProvider, (_, _) => load());
    load();
  }

  ICareService get careService => ref.read(careServiceProvider);

  bool loaded = false;
  bool hasError = false;
  List<FamilyBadge> badges = const [];
  List<Child> children = const [];

  List<FamilyBadge> get earned => [
    for (final badge in badges)
      if (badge.achieved) badge,
  ];

  List<FamilyBadge> get upcoming => [
    for (final badge in badges)
      if (!badge.achieved) badge,
  ];

  /// Huy hiệu đạt gần nhất.
  FamilyBadge? get latest {
    FamilyBadge? result;
    for (final badge in earned) {
      if (result == null || badge.achievedAt!.isAfter(result.achievedAt!)) {
        result = badge;
      }
    }
    return result;
  }

  String? childName(String? id) {
    for (final child in children) {
      if (child.id == id) {
        return child.name;
      }
    }
    return null;
  }

  Future<void> load() async {
    hasError = false;
    try {
      final loaded = await careService.badges();
      final loadedChildren = await ref.read(childServiceProvider).children();
      if (isDisposed) {
        return;
      }
      badges = loaded;
      children = loadedChildren;
    } on Object {
      hasError = true;
    }
    loaded = true;
    notifyListeners();
  }
}
