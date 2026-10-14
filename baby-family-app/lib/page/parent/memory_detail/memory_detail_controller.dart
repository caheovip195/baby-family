import 'package:baby_family/data/dto/report_request.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/model/memory/memory_comment.dart';
import 'package:baby_family/data/model/memory/memory_perspective.dart';
import 'package:baby_family/data/model/memory/report_reason.dart';
import 'package:baby_family/data/model/memory/report_receipt.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/child.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/legacy.dart';

/// MEM-07 Chi tiết ký ức: media, người đăng, chú thích, thẻ, “Papa kể”
/// (góc nhìn thứ hai), cảm xúc, bình luận.
final memoryDetailControllerProvider = ChangeNotifierProvider.autoDispose
    .family<MemoryDetailController, String>(MemoryDetailController.new);

class MemoryDetailController extends BaseNotifier {
  MemoryDetailController(super.ref, this.memoryId) {
    ref
      ..listen(mockRevisionProvider, (_, _) => load())
      ..listen(appLanguageProvider, (_, _) => load());
    load();
  }

  final String memoryId;

  IMemoryService get memoryService => ref.read(memoryServiceProvider);
  IChildService get childService => ref.read(childServiceProvider);
  IFamilyService get familyService => ref.read(familyServiceProvider);

  final comment = TextEditingController();

  bool loaded = false;
  bool hasError = false;
  Memory? memory;
  List<MemoryPerspective> perspectives = const [];
  List<MemoryComment> comments = const [];
  List<Child> children = const [];
  Map<String, Member> _membersByUser = const {};
  Member? me;
  int page = 0;

  /// Cảm xúc người xem vừa thả trong phiên (tô nổi bật).
  final Set<String> myReactions = {};

  DateTime get today => childService.today;
  DateTime get now => ref.read(appClockProvider).now();

  Child? childById(String id) =>
      children.where((child) => child.id == id).firstOrNull;
  Member? memberByUser(String? userId) => _membersByUser[userId];

  /// Bình luận gốc hiện ngay trên MEM-07 (Pencil vẽ 2) — đủ ở MEM-10.
  List<MemoryComment> get previewComments => comments
      .where((comment) => comment.parentId == null)
      .take(kValueCommentPreviewCount)
      .toList();

  bool get isAuthor => memory != null && memory!.authorId == me?.userId;

  MemoryPerspective? get myPerspective => perspectives
      .where((perspective) => perspective.authorId == me?.userId)
      .firstOrNull;

  /// Bạn đời (Parent, không phải người đăng) chưa kể → hiện nút MEM-24.
  bool get canAddPerspective =>
      memory != null &&
      !isAuthor &&
      (me?.role.isParent ?? false) &&
      myPerspective == null;

  /// Bố mẹ xoá được mọi ký ức (vào Thùng rác MEM-17); người thân chỉ của mình.
  bool get canDelete =>
      memory != null && ((me?.role.isParent ?? false) || isAuthor);

  int get trashDays => memoryService.trashDays;

  Future<void> moveToTrash() => memoryService.moveToTrash(memoryId);

  Future<List<ReportReason>> reportReasons() => memoryService.reportReasons();

  Future<ReportReceipt?> report(ReportRequest request) =>
      memoryService.submitReport(
        targetId: memoryId,
        reasonCode: request.reasonCode,
        note: request.note,
        hideForMe: request.hideForMe,
        removeFromFamily: request.removeFromFamily,
      );

  Future<void> load() async {
    hasError = false;
    try {
      final (value, views, notes, kids, members, current) = await (
        memoryService.memory(memoryId),
        memoryService.perspectives(memoryId),
        memoryService.comments(memoryId),
        childService.children(),
        familyService.members(),
        familyService.me(),
      ).wait;
      if (isDisposed) {
        return;
      }
      memory = value;
      perspectives = views;
      comments = notes;
      children = kids;
      _membersByUser = {
        for (final member in members)
          if (member.userId != null) member.userId!: member,
      };
      me = current;
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    loaded = true;
    notifyListeners();
  }

  void setPage(int value) {
    page = value;
    notifyListeners();
  }

  Future<void> react(String emoji) async {
    myReactions.add(emoji);
    notifyListeners();
    await memoryService.react(memoryId, emoji);
  }

  Future<void> toggleFavorite() => memoryService.toggleFavorite(memoryId);

  Future<void> sendComment() async {
    final text = comment.text.trim();
    if (text.isEmpty) {
      return;
    }
    comment.clear();
    await memoryService.addComment(memoryId, text);
    await load();
  }

  @override
  void dispose() {
    comment.dispose();
    super.dispose();
  }
}
