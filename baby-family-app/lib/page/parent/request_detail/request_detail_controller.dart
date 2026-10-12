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

/// US-04 — Chi tiết lời nhờ (Pencil `jDPm9` người nhận, `uFjwu` đã nhận;
/// người gửi theo mục 9.8). Trạng thái hiển thị suy ra từ `status` và việc
/// tôi là người gửi hay người nhận.
final requestDetailControllerProvider = ChangeNotifierProvider.autoDispose
    .family<RequestDetailController, String>(RequestDetailController.new);

class RequestDetailController extends BaseNotifier {
  RequestDetailController(super.ref, this.requestId) {
    ref.listen(mockRevisionProvider, (_, _) => load());
    load(markSeen: true);
  }

  final String requestId;

  IUsService get usService => ref.read(usServiceProvider);

  CoupleRequest? request;
  Member? me;
  Member? partner;
  List<Child> children = const [];
  bool loaded = false;

  /// Lý do nhanh khi “Hôm nay không được” (tuỳ chọn).
  String? reason;
  int _revision = 0;

  DateTime get now => ref.read(appClockProvider).now();

  bool get isSender =>
      request != null && me != null && request!.senderId == me!.userId;

  Member? get sender => isSender ? me : partner;

  List<Child> get requestChildren => [
    for (final id in request?.childIds ?? const <String>[])
      ?children.where((child) => child.id == id).firstOrNull,
  ];

  /// Bé khác (đã sinh) không nằm trong lời nhờ — lý do “Đang trông Hana”.
  Child? get otherChild => children
      .where(
        (child) =>
            !child.isPregnancy &&
            !(request?.childIds.contains(child.id) ?? false),
      )
      .firstOrNull;

  /// Giờ nhắc mặc định: giờ đã đặt, nếu chưa thì 30 phút tới (làm tròn).
  DateTime get reminderAt {
    final remind = request?.remindAt;
    if (remind != null) {
      return remind;
    }
    final current = now;
    final next = current.minute < 30
        ? DateTime(current.year, current.month, current.day, current.hour, 30)
        : DateTime(current.year, current.month, current.day, current.hour + 1);
    return next;
  }

  Future<void> load({bool markSeen = false}) async {
    final revision = ++_revision;
    final family = ref.read(familyServiceProvider);
    final results = await Future.wait<Object?>([
      usService.request(requestId),
      family.me(),
      family.partner(),
      ref.read(childServiceProvider).children(),
    ]);
    if (isDisposed || revision != _revision) {
      return;
    }
    request = results[0] as CoupleRequest?;
    me = results[1] as Member?;
    partner = results[2] as Member?;
    children = results[3]! as List<Child>;
    loaded = true;
    notifyListeners();
    if (markSeen &&
        !isSender &&
        request?.status == RequestStatus.sent &&
        request != null) {
      await usService.markSeen(requestId);
    }
  }

  void selectReason(String value) {
    reason = reason == value ? null : value;
    notifyListeners();
  }

  Future<void> accept() => whileLoading(() => usService.accept(requestId));

  Future<void> decline() =>
      whileLoading(() => usService.decline(requestId, reason: reason));

  Future<void> markDone() => whileLoading(() => usService.markDone(requestId));

  Future<void> acknowledge() =>
      whileLoading(() => usService.acknowledge(requestId));

  Future<void> cancel() => whileLoading(() => usService.cancel(requestId));

  Future<void> setReminder(DateTime at) => usService.setReminder(requestId, at);
}
