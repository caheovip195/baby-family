import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/us/couple_request.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/us.dart';
import 'package:baby_family/data/service/us.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// US-03 — Gửi lời nhờ (Pencil `HGWaE`): nhờ một việc (Cần nghỉ / Trông con /
/// Thư viện / Tự gõ) + chi tiết (bao lâu, khi nào, bé nào) + câu mẫu, hoặc
/// “Mình đang cần…” (NEED, không tính Hearts — BR-068).
final requestComposeControllerProvider =
    ChangeNotifierProvider.autoDispose<RequestComposeController>(
      RequestComposeController.new,
    );

class RequestComposeController extends BaseNotifier {
  RequestComposeController(super.ref) {
    load();
  }

  IUsService get usService => ref.read(usServiceProvider);

  /// Lựa chọn “Bao lâu?” theo Pencil (phút).
  static const durations = [15, 30, 60];

  Member? me;
  Member? partner;

  /// Bé đã sinh (thai kỳ không cần trông).
  List<Child> babies = const [];

  /// Số lời nhờ tôi đang mở (“đang mở 1/5” — BR-067).
  int openCount = 0;
  bool loaded = false;

  /// `rest` | `childcare` | `custom` (Tự gõ) — null khi chọn NEED.
  String? template = templateRest;
  CoupleNeed? need;
  int minutes = 30;
  String dueLabel = dueNow;
  DateTime? dueAt;

  /// null = tất cả bé (“Cả hai bé”).
  String? childId;

  /// Lời nhắn người dùng đã sửa (null → dùng câu mẫu).
  String? customMessage;

  static const templateRest = 'rest';
  static const templateChildcare = 'childcare';
  static const templateCustom = 'custom';
  static const dueNow = 'now';
  static const dueTonight = 'tonight';
  static const dueAtTime = 'at';

  bool get isTask => need == null;

  /// Giờ hiện tại của dữ liệu (“Chọn giờ” lấy ngày hôm nay).
  DateTime get now => ref.read(appClockProvider).now();

  /// Bé mặc định: bé nhỏ nhất (cần trông nhiều nhất) — Pencil: Haru.
  Child? get defaultChild => babies.isEmpty
      ? null
      : (babies.toList()..sort(
              (a, b) => (b.birthDate ?? DateTime(0)).compareTo(
                a.birthDate ?? DateTime(0),
              ),
            ))
            .first;

  Child? get selectedChild =>
      babies.where((child) => child.id == childId).firstOrNull;

  Future<void> load({String? prefillTitle}) async {
    final family = ref.read(familyServiceProvider);
    final results = await Future.wait<Object?>([
      family.me(),
      family.partner(),
      ref.read(childServiceProvider).children(),
      usService.requests(openOnly: true),
    ]);
    if (isDisposed) {
      return;
    }
    me = results[0] as Member?;
    partner = results[1] as Member?;
    babies = (results[2]! as List<Child>)
        .where((child) => !child.isPregnancy)
        .toList();
    openCount = (results[3]! as List<CoupleRequest>)
        .where((request) => request.senderId == me?.userId)
        .length;
    childId = defaultChild?.id;
    loaded = true;
    notifyListeners();
  }

  void prefill(String title) {
    template = templateCustom;
    need = null;
    customMessage = title;
    notifyListeners();
  }

  void selectTemplate(String value) {
    template = value;
    need = null;
    if (value != templateCustom) {
      customMessage = null;
    }
    notifyListeners();
  }

  void selectNeed(CoupleNeed value) {
    need = need == value ? null : value;
    template = need == null ? templateRest : null;
    customMessage = null;
    notifyListeners();
  }

  void selectMinutes(int value) {
    minutes = value;
    notifyListeners();
  }

  void selectDue(String label, {DateTime? at}) {
    dueLabel = label;
    dueAt = at;
    notifyListeners();
  }

  void selectChild(String? id) {
    childId = id;
    notifyListeners();
  }

  void editMessage(String value) {
    customMessage = value;
    notifyListeners();
  }

  /// Gửi lời nhờ, trả về lời nhờ mới (→ US-04 người gửi) hoặc null khi lỗi.
  Future<CoupleRequest?> send({
    required String title,
    required String? message,
  }) async {
    toLoading();
    try {
      return await usService.sendRequest(
        kind: isTask ? RequestKind.task : RequestKind.need,
        templateCode: isTask && template != templateCustom ? template : null,
        needCode: need,
        title: title,
        message: message,
        childIds: !isTask
            ? const []
            : childId == null
            ? [for (final child in babies) child.id]
            : [childId!],
        dueLabel: dueLabel,
        dueAt: dueAt,
        durationMin: isTask && template != templateCustom ? minutes : null,
      );
      // Mock: vượt giới hạn 5 lời nhờ (BR-067) → báo lỗi nhẹ, không gửi.
      // ignore: avoid_catching_errors
    } on StateError {
      return null;
    } finally {
      toIdle();
    }
  }
}
