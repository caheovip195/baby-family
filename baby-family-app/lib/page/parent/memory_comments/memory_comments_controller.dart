import 'package:baby_family/data/dto/report_request.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/model/memory/memory_comment.dart';
import 'package:baby_family/data/model/memory/report_reason.dart';
import 'package:baby_family/data/model/memory/report_receipt.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/legacy.dart';

/// MEM-10 Bình luận: danh sách đầy đủ, trả lời 1 cấp, giữ lâu Sửa (≤ 15
/// phút) / Sao chép / Xoá, ô nhập có emoji.
final memoryCommentsControllerProvider = ChangeNotifierProvider.autoDispose
    .family<MemoryCommentsController, String>(MemoryCommentsController.new);

class MemoryCommentsController extends BaseNotifier {
  MemoryCommentsController(super.ref, this.memoryId) {
    ref
      ..listen(mockRevisionProvider, (_, _) => load())
      ..listen(appLanguageProvider, (_, _) => load());
    load();
  }

  final String memoryId;

  IMemoryService get memoryService => ref.read(memoryServiceProvider);
  IFamilyService get familyService => ref.read(familyServiceProvider);

  final input = TextEditingController();
  final focus = FocusNode();

  bool loaded = false;
  bool hasError = false;
  Memory? memory;
  List<MemoryComment> comments = const [];
  Map<String, Member> _membersByUser = const {};
  Member? me;

  /// Bình luận gốc đang được trả lời (thanh “Đang trả lời …”).
  MemoryComment? replyTo;

  /// Bình luận của mình đang sửa.
  MemoryComment? editing;

  DateTime get now => ref.read(appClockProvider).now();

  Member? memberByUser(String? userId) => _membersByUser[userId];

  /// Bình luận gốc (cũ trước) — mỗi luồng kèm các trả lời của nó.
  List<MemoryComment> get threads =>
      comments.where((comment) => comment.parentId == null).toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  List<MemoryComment> repliesOf(String id) =>
      comments.where((comment) => comment.parentId == id).toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  bool isMine(MemoryComment comment) =>
      comment.authorId != null && comment.authorId == me?.userId;

  Future<List<ReportReason>> reportReasons() => memoryService.reportReasons();

  /// Long-press “Báo cáo” → RPT-01 cho bình luận.
  Future<ReportReceipt?> report(MemoryComment comment, ReportRequest request) =>
      memoryService.submitReport(
        targetId: comment.id,
        target: ReportTarget.comment,
        reasonCode: request.reasonCode,
        note: request.note,
        hideForMe: request.hideForMe,
      );

  bool canEdit(MemoryComment comment) =>
      isMine(comment) &&
      now.difference(comment.createdAt) <= kValueCommentEditWindow;

  Future<void> load() async {
    hasError = false;
    try {
      final (value, notes, members, current) = await (
        memoryService.refreshMemory(memoryId),
        memoryService.comments(memoryId),
        familyService.members(),
        familyService.me(),
      ).wait;
      if (isDisposed) {
        return;
      }
      memory = value;
      comments = notes;
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

  /// “Trả lời” — trả lời 1 cấp: luôn gắn vào bình luận gốc của luồng.
  void startReply(MemoryComment comment) {
    final root = comment.parentId == null
        ? comment
        : comments.where((item) => item.id == comment.parentId).firstOrNull;
    replyTo = root ?? comment;
    editing = null;
    focus.requestFocus();
    notifyListeners();
  }

  void startEdit(MemoryComment comment) {
    editing = comment;
    replyTo = null;
    input
      ..text = comment.body
      ..selection = TextSelection.collapsed(offset: comment.body.length);
    focus.requestFocus();
    notifyListeners();
  }

  void cancelComposerMode() {
    if (editing != null) {
      input.clear();
    }
    replyTo = null;
    editing = null;
    notifyListeners();
  }

  void insertEmoji(String emoji) {
    final value = input.value;
    final start = value.selection.isValid
        ? value.selection.start
        : value.text.length;
    final end = value.selection.isValid ? value.selection.end : start;
    final text = value.text.replaceRange(start, end, emoji);
    input.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: start + emoji.length),
    );
  }

  Future<void> send() async {
    final text = input.text.trim();
    if (text.isEmpty) {
      return;
    }
    final target = editing;
    final parent = replyTo;
    input.clear();
    replyTo = null;
    editing = null;
    notifyListeners();
    if (target != null) {
      await callFuture(memoryService.editComment(target.id, text));
    } else {
      await callFuture(
        memoryService.addComment(memoryId, text, parentId: parent?.id),
      );
    }
    await load();
  }

  Future<void> delete(MemoryComment comment) async {
    await callFuture(memoryService.deleteComment(comment.id));
    await load();
  }

  @override
  void dispose() {
    input.dispose();
    focus.dispose();
    super.dispose();
  }
}
