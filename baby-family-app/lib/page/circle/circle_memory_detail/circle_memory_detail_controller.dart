import 'package:baby_family/data/dto/report_request.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/model/memory/memory_comment.dart';
import 'package:baby_family/data/model/memory/report_reason.dart';
import 'package:baby_family/data/model/memory/report_receipt.dart';
import 'package:baby_family/data/provider/circle.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/circle.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:hooks_riverpod/legacy.dart';

/// CIR-03 — Chi tiết ký ức (người thân): như MEM-07 rút gọn — thả tim, lời
/// chúc (của mình sửa/xoá được), menu chỉ “Báo cáo” (+ “Tải về” khi bố mẹ
/// bật quyền tải cho người thân).
final circleMemoryDetailControllerProvider = ChangeNotifierProvider.autoDispose
    .family<CircleMemoryDetailController, String>(
      CircleMemoryDetailController.new,
    );

class CircleMemoryDetailController extends BaseNotifier {
  CircleMemoryDetailController(super.ref, this.memoryId) {
    Future.microtask(load);
  }

  final String memoryId;

  ICircleService get circleService => ref.read(circleServiceProvider);

  Memory? memory;
  Member? viewer;
  List<MemoryComment> wishes = const [];
  List<Child> children = const [];
  List<Member> members = const [];
  bool hasError = false;
  bool loaded = false;

  DateTime get now => ref.read(appClockProvider).now();

  bool get liked =>
      memory?.reactorNames.contains(viewer?.callName ?? '') ?? false;

  bool get canDownload => viewer?.allowDownload ?? false;

  bool get canComment => viewer?.canComment ?? false;

  Member? memberOf(String? userId) =>
      members.where((member) => member.userId == userId).firstOrNull;

  bool isMine(MemoryComment wish) =>
      wish.authorId != null && wish.authorId == viewer?.userId;

  Future<void> load() async {
    hasError = false;
    try {
      final (loadedMemory, loadedWishes, view, people) = await (
        circleService.memory(memoryId),
        circleService.wishes(memoryId),
        circleService.view(),
        ref.read(familyServiceProvider).members(),
      ).wait;
      if (isDisposed) {
        return;
      }
      // Chỉ ký ức được chia sẻ cho người thân này.
      final visible =
          view?.memories.any((item) => item.id == memoryId) ?? false;
      memory = visible ? loadedMemory : null;
      wishes = loadedWishes;
      viewer = view?.viewer;
      children = view?.children ?? const [];
      members = people;
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    loaded = true;
    notifyListeners();
  }

  Future<void> toggleHeart() async {
    await circleService.toggleHeart(memoryId);
    await load();
  }

  Future<bool> sendWish(String body) async {
    if (body.trim().isEmpty) {
      return false;
    }
    await circleService.sendWish(memoryId, body);
    await load();
    return true;
  }

  Future<void> editWish(MemoryComment wish, String body) async {
    await ref.read(memoryServiceProvider).editComment(wish.id, body);
    await load();
  }

  Future<void> deleteWish(MemoryComment wish) async {
    await ref.read(memoryServiceProvider).deleteComment(wish.id);
    await load();
  }

  Future<List<ReportReason>> reportReasons() =>
      ref.read(memoryServiceProvider).reportReasons();

  Future<ReportReceipt?> report(ReportRequest request) => ref
      .read(memoryServiceProvider)
      .submitReport(
        targetId: memoryId,
        reasonCode: request.reasonCode,
        note: request.note,
        hideForMe: request.hideForMe,
      );

  /// Số ❤️ hiện tại.
  int get hearts => memory?.reactions[kValueHeartReaction] ?? 0;
}
