import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/us/bridge_next_step.dart';
import 'package:baby_family/data/model/us/bridge_option.dart';
import 'package:baby_family/data/model/us/bridge_session.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/us.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/data/service/us.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// US-12 — Bước tiếp theo (Pencil `b0kyKY`, mục 7.17.1 giai đoạn 3 bước 4–6):
/// chọn một bước nhỏ, khi nào / trông bé nào / nhắc cho cả hai, xác nhận của
/// hai người; sau khi xác nhận → US-12b “Đóng phiên?” (đóng khi cả hai đồng ý,
/// lời cảm ơn tuỳ chọn).
final bridgeNextStepControllerProvider = ChangeNotifierProvider.autoDispose
    .family<BridgeNextStepController, String>(BridgeNextStepController.new);

class BridgeNextStepController extends BaseNotifier {
  BridgeNextStepController(super.ref, this.sessionId) {
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
  List<BridgeOption> options = const [];
  List<Child> children = const [];

  DateTime get now => ref.read(appClockProvider).now();

  BridgeNextStep? get step => session?.nextStep;

  BridgeOption? get selectedOption =>
      options.where((option) => option.code == step?.code).firstOrNull;

  bool agreed(String? userId) =>
      userId != null && (step?.agreedUserIds.contains(userId) ?? false);

  bool get iAgreed => agreed(me?.userId);

  bool get partnerAgreedClose =>
      session?.closeAgreedUserIds.contains(partner?.userId) ?? false;

  List<Child> get stepChildren => [
    for (final id in step?.childIds ?? const <String>[])
      ?children.where((child) => child.id == id).firstOrNull,
  ];

  Future<void> load() async {
    hasError = false;
    try {
      final (value, mine, other, steps, kids) = await (
        usService.bridgeSession(sessionId),
        familyService.me(),
        familyService.partner(),
        usService.bridgeOptions('nextSteps'),
        ref.read(childServiceProvider).children(),
      ).wait;
      if (isDisposed) {
        return;
      }
      session = value;
      me = mine;
      partner = other;
      options = steps;
      children = kids;
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

  /// Đổi lựa chọn → hai bên cần xác nhận lại bước mới.
  Future<bool> choose(String code) {
    final current = step ?? BridgeNextStep(code: code);
    if (current.code == code && step != null) {
      return Future.value(false);
    }
    return _run(
      () => usService.chooseNextStep(
        sessionId,
        current.copyWith(code: code, agreedUserIds: const []),
      ),
    );
  }

  Future<bool> toggleReminder(bool value) {
    final current = step;
    if (current == null) {
      return Future.value(false);
    }
    return _run(
      () => usService.chooseNextStep(
        sessionId,
        current.copyWith(reminder: value),
      ),
    );
  }

  Future<bool> confirm() => _run(() => usService.confirmNextStep(sessionId));

  /// US-12b “Đóng phiên” (+ lời cảm ơn tuỳ chọn gửi cho bạn đời).
  Future<bool> close({String? thanks}) => _run(() async {
    await usService.closeBridge(sessionId);
    if (thanks != null && thanks.isNotEmpty) {
      await usService.sendThanks(body: thanks);
    }
  });
}
