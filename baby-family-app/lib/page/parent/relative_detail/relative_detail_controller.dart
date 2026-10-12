import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// FAM-04 — Chi tiết người thân: thông tin, quyền theo từng bé, tuỳ chọn,
/// tạm dừng / gỡ khỏi gia đình (FAM-06). Mọi thay đổi lưu ngay (mock).
final relativeDetailControllerProvider = ChangeNotifierProvider.autoDispose
    .family<RelativeDetailController, String>(RelativeDetailController.new);

class RelativeDetailController extends BaseNotifier {
  RelativeDetailController(super.ref, this.memberId) {
    load();
  }

  final String memberId;

  IFamilyService get familyService => ref.read(familyServiceProvider);

  Member? member;
  List<Child> children = const [];
  bool hasError = false;

  DateTime get today => ref.read(todayProvider);

  DateTime get now => ref.read(appClockProvider).now();

  Future<void> load() async {
    hasError = false;
    try {
      final results = await Future.wait([
        familyService.member(memberId),
        ref.read(childServiceProvider).children(),
      ]);
      if (isDisposed) {
        return;
      }
      member = results[0] as Member?;
      children = results[1]! as List<Child>;
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    notifyListeners();
  }

  /// Quyền hiện tại với bé [childId]; null = chưa chia sẻ.
  RelativePermission? permissionOf(String childId) =>
      member?.childPermissions[childId];

  Future<void> setPermission(
    String childId,
    RelativePermission? permission,
  ) async {
    await familyService.setChildPermission(memberId, childId, permission);
    await load();
  }

  Future<void> setAllowDownload(bool value) async {
    await familyService.updateRelative(memberId, allowDownload: value);
    await load();
  }

  Future<void> setMuted(bool value) async {
    await familyService.updateRelative(memberId, notificationsMuted: value);
    await load();
  }

  Future<void> togglePaused() async {
    await familyService.updateRelative(
      memberId,
      paused: !(member?.paused ?? false),
    );
    await load();
  }

  /// FAM-06: gỡ người thân (mock giữ ký ức họ đã đăng trong cả hai lựa chọn).
  Future<void> remove() async {
    await whileLoading(() => familyService.removeRelative(memberId));
  }
}
