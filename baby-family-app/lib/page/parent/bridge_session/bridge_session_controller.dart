import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/us/bridge_option.dart';
import 'package:baby_family/data/model/us/bridge_session.dart';
import 'package:baby_family/data/model/us/bridge_share.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/us.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/data/service/us.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// US-11 — Phiên chung (Pencil `iFmGo`, mục 7.17.1 giai đoạn 3): hai cột
/// “{tên} cảm thấy… cần…” chỉ gồm những ý mỗi người đã chọn chia sẻ, trạng
/// thái hai bên, “Mình hiểu” / “Mình cần nói rõ hơn” (thêm 1 lượt gửi ý), nút
/// Tạm dừng. Khi cả hai đã hiểu → US-12.
final bridgeSessionControllerProvider = ChangeNotifierProvider.autoDispose
    .family<BridgeSessionController, String>(BridgeSessionController.new);

class BridgeSessionController extends BaseNotifier {
  BridgeSessionController(super.ref, this.sessionId) {
    ref
      ..listen(mockRevisionProvider, (_, _) => load())
      ..listen(appLanguageProvider, (_, _) => load());
    load();
  }

  final String sessionId;

  IUsService get usService => ref.read(usServiceProvider);
  IFamilyService get familyService => ref.read(familyServiceProvider);

  bool loaded = false;
  bool hasError = false;
  bool busy = false;
  BridgeSession? session;
  Member? me;
  Member? partner;
  List<BridgeOption> feelingOptions = const [];
  List<BridgeOption> needOptions = const [];

  BridgeShare? shareOf(String? userId) =>
      session?.shares.where((share) => share.userId == userId).firstOrNull;

  BridgeShare? get myShare => shareOf(me?.userId);
  BridgeShare? get partnerShare => shareOf(partner?.userId);

  /// Hai bạn đều đã bấm “Mình hiểu” → chọn bước tiếp theo (US-12).
  bool get bothUnderstood =>
      session?.status == BridgeStatus.nextStep ||
      ((myShare?.understood ?? false) && (partnerShare?.understood ?? false));

  List<String> titles(List<BridgeOption> options, List<String> codes) => [
    for (final code in codes)
      options.where((option) => option.code == code).firstOrNull?.title ?? code,
  ];

  Future<void> load() async {
    hasError = false;
    try {
      final (value, mine, other, feels, wants) = await (
        usService.bridgeSession(sessionId),
        familyService.me(),
        familyService.partner(),
        usService.bridgeOptions('feelings'),
        usService.bridgeOptions('needs'),
      ).wait;
      if (isDisposed) {
        return;
      }
      session = value;
      me = mine;
      partner = other;
      feelingOptions = feels;
      needOptions = wants;
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    loaded = true;
    notifyListeners();
  }

  Future<bool> _run(Future<void> Function() action) async {
    if (busy) {
      return false;
    }
    busy = true;
    notifyListeners();
    try {
      await action();
      await load();
      return true;
    } catch (_) {
      return false;
    } finally {
      if (!isDisposed) {
        busy = false;
        notifyListeners();
      }
    }
  }

  Future<bool> understand() =>
      _run(() => usService.markBridgeUnderstood(sessionId));

  Future<bool> clarify(String message) =>
      _run(() => usService.clarifyBridgeShare(sessionId, message.trim()));

  Future<bool> pause() => _run(() => usService.pauseBridge(sessionId));
}
