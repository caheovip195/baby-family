import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/settings/privacy_settings.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/settings.dart';
import 'package:baby_family/data/service/settings.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// SET-04 — Quyền riêng tư: mặc định “Ai thấy ký ức mới” + bảng điều khiển
/// quyền (7.23.4). “Ai đang thấy bé nào”, “Được tải ảnh về”, “Được đăng ảnh”
/// tính từ quyền thật của người thân (cùng nguồn với FAM-01/FAM-04).
final privacySettingsControllerProvider =
    ChangeNotifierProvider.autoDispose<PrivacySettingsController>(
      PrivacySettingsController.new,
    );

class PrivacySettingsController extends BaseNotifier {
  PrivacySettingsController(super.ref) {
    ref.listen(mockRevisionProvider, (_, _) => load());
    load();
  }

  ISettingsService get settingsService => ref.read(settingsServiceProvider);

  PrivacySettings? settings;
  List<Child> children = const [];
  List<Member> relatives = const [];
  bool hasError = false;

  Future<void> load() async {
    hasError = false;
    try {
      final results = await Future.wait([
        settingsService.privacySettings(),
        ref.read(childServiceProvider).children(),
        ref.read(familyServiceProvider).members(),
      ]);
      if (isDisposed) {
        return;
      }
      settings = results[0] as PrivacySettings;
      children = results[1] as List<Child>;
      relatives = (results[2] as List<Member>)
          .where((m) => !m.role.isParent && m.status == MemberStatus.active)
          .toList();
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    notifyListeners();
  }

  /// Số người thân đang được chia sẻ bé [childId] (không tính bé tạm ẩn).
  int relativeCountOf(String childId) => relatives.where((m) {
    final permission = m.childPermissions[childId];
    return permission != null &&
        permission != RelativePermission.hidden &&
        !m.paused;
  }).length;

  List<String> get downloadNames => [
    for (final m in relatives)
      if (m.allowDownload) m.callName,
  ];

  List<String> get postNames => [
    for (final m in relatives)
      if (m.childPermissions.containsValue(RelativePermission.contribute))
        m.callName,
  ];

  Future<void> setDefaultVisibility(MemoryVisibility value) async {
    final current = settings;
    if (current == null) {
      return;
    }
    settings = current.copyWith(defaultVisibility: value);
    notifyListeners();
    await settingsService.savePrivacySettings(settings!);
  }
}
