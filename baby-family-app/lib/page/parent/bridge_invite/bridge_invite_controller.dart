import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/us/bridge_option.dart';
import 'package:baby_family/data/model/us/bridge_session.dart';
import 'package:baby_family/data/model/us/bridge_share.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/us.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/data/service/us.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// US-10 — Lời mời Cầu nối, góc nhìn người nhận (Pencil `ZM8Ho`, mục 7.17.1
/// giai đoạn 2): “{người mời} muốn trò chuyện bình tĩnh khi bạn sẵn sàng” +
/// chỉ những ý người mời đã chọn chia sẻ (không bao giờ có nháp riêng) →
/// Tham gia ngay / Để sau (tối nay · ngày mai · tự chọn) / Chưa sẵn sàng
/// (tạm dừng, không thông báo tiêu cực).
final bridgeInviteControllerProvider = ChangeNotifierProvider.autoDispose
    .family<BridgeInviteController, String>(BridgeInviteController.new);

class BridgeInviteController extends BaseNotifier {
  BridgeInviteController(super.ref, this.sessionId) {
    ref.listen(appLanguageProvider, (_, _) => load());
    load();
  }

  final String sessionId;

  IUsService get usService => ref.read(usServiceProvider);
  IFamilyService get familyService => ref.read(familyServiceProvider);

  bool loaded = false;
  bool hasError = false;
  bool busy = false;
  BridgeSession? session;
  List<Member> members = const [];
  List<BridgeOption> feelingOptions = const [];
  List<BridgeOption> needOptions = const [];

  Member? get inviter => members
      .where((member) => member.userId == session?.initiatorUserId)
      .firstOrNull;

  /// Những gì người mời đã chọn chia sẻ.
  BridgeShare? get inviterShare => session?.shares
      .where((share) => share.userId == session?.initiatorUserId)
      .firstOrNull;

  List<String> titles(List<BridgeOption> options, List<String> codes) => [
    for (final code in codes)
      options.where((option) => option.code == code).firstOrNull?.title ?? code,
  ];

  Future<void> load() async {
    hasError = false;
    try {
      final (value, people, feels, wants) = await (
        usService.bridgeSession(sessionId),
        familyService.members(),
        usService.bridgeOptions('feelings'),
        usService.bridgeOptions('needs'),
      ).wait;
      if (isDisposed) {
        return;
      }
      session = value;
      members = people;
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

  Future<bool> join() => _run(() => usService.joinBridge(sessionId));

  /// “Để sau” / “Mình chưa sẵn sàng”: tạm dừng lời mời (không báo gì tiêu cực).
  Future<bool> pause() => _run(() => usService.pauseBridge(sessionId));
}
