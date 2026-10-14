import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// MEM-19 — Chờ duyệt (bố mẹ, gói Family): ảnh người thân đăng chờ duyệt.
/// Bài trong 7 ngày mở sẵn (ảnh, sửa bé gắn trước khi duyệt); bài cũ hơn thu
/// gọn kèm “Đã chờ N ngày”. Từ chối có lý do tuỳ chọn (“Ảnh này nhà mình
/// muốn giữ riêng”) gửi lời nhắn nhẹ nhàng cho người đăng.
final pendingReviewControllerProvider =
    ChangeNotifierProvider.autoDispose<PendingReviewController>(
      PendingReviewController.new,
    );

class PendingReviewController extends BaseNotifier {
  PendingReviewController(super.ref) {
    load();
  }

  /// Bài chờ quá số ngày này được thu gọn (Pencil “Đã chờ 8 ngày”).
  static const _openDays = 7;

  IMemoryService get memoryService => ref.read(memoryServiceProvider);

  List<Memory>? posts;
  List<Child> children = const [];
  List<String> rejectReasons = const [];
  List<Member> members = const [];
  String partnerName = '';
  bool hasError = false;

  final Set<String> _expanded = {};
  final Map<String, List<String>> _childEdits = {};
  String? rejectingId;
  String? rejectReason;

  DateTime get today => ref.read(todayProvider);

  int get familySize => members.length;

  Future<void> load() async {
    hasError = false;
    try {
      final family = ref.read(familyServiceProvider);
      final (loaded, kids, reasons, people, partner) = await (
        memoryService.pendingPosts(),
        ref.read(childServiceProvider).children(),
        memoryService.rejectReasons(),
        family.members(),
        family.partner(),
      ).wait;
      if (isDisposed) {
        return;
      }
      posts = loaded;
      children = kids.where((child) => !child.isPregnancy).toList();
      rejectReasons = reasons;
      members = people;
      partnerName = partner?.callName ?? '';
      for (final post in loaded) {
        if (waitedDays(post) < _openDays) {
          _expanded.add(post.id);
        }
      }
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    notifyListeners();
  }

  Member? authorOf(Memory post) =>
      members.where((member) => member.userId == post.authorId).firstOrNull;

  int waitedDays(Memory post) {
    final at = post.createdAt ?? post.occurredAt;
    return today.difference(DateTime(at.year, at.month, at.day)).inDays;
  }

  bool isExpanded(Memory post) => _expanded.contains(post.id);

  void expand(Memory post) {
    _expanded.add(post.id);
    notifyListeners();
  }

  List<String> childIdsOf(Memory post) => _childEdits[post.id] ?? post.childIds;

  /// Sửa bé gắn trước khi duyệt; luôn giữ ít nhất một bé.
  void toggleChild(Memory post, String childId) {
    final ids = [...childIdsOf(post)];
    if (ids.contains(childId)) {
      if (ids.length == 1) {
        return;
      }
      ids.remove(childId);
    } else {
      ids.add(childId);
    }
    _childEdits[post.id] = ids;
    notifyListeners();
  }

  void startReject(Memory post) {
    rejectingId = post.id;
    rejectReason = rejectReasons.firstOrNull;
    notifyListeners();
  }

  void cancelReject() {
    rejectingId = null;
    rejectReason = null;
    notifyListeners();
  }

  void selectReason(String reason) {
    rejectReason = rejectReason == reason ? null : reason;
    notifyListeners();
  }

  Future<void> approve(Memory post) async {
    await memoryService.approvePost(post.id, childIds: childIdsOf(post));
    _childEdits.remove(post.id);
    await load();
  }

  Future<void> reject(Memory post) async {
    await memoryService.rejectPost(post.id, reason: rejectReason);
    rejectingId = null;
    rejectReason = null;
    await load();
  }
}
