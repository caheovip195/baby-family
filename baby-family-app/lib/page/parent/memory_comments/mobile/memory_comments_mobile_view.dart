import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/model/memory/memory_comment.dart';
import 'package:baby_family/page/parent/memory_comments/memory_comments_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/memory_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_back_title_bar.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:baby_family/utils/widget/report_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/comment_action_menu.dart';
part '../widgets/comment_composer.dart';
part '../widgets/comment_context.dart';
part '../widgets/comment_item.dart';

/// MEM-10 Bình luận (Pencil `ba6Q1`): ngữ cảnh ký ức, luồng bình luận (trả
/// lời 1 cấp thụt 42), giữ lâu mở menu Sửa • Sao chép • Xoá, ô nhập đáy.
class MemoryCommentsMobileView extends HookConsumerWidget {
  const MemoryCommentsMobileView({required this.memoryId, super.key});

  final String memoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(memoryCommentsControllerProvider(memoryId));
    final memory = controller.memory;
    final l10n = context.l10n;
    if (!controller.loaded) {
      return const BaseScaffold(body: Center(child: CircleLoadingProgress()));
    }
    if (controller.hasError || memory == null) {
      return BaseScaffold(
        appBar: AppBar(),
        body: ErrorState(onRetry: controller.load),
      );
    }
    final threads = controller.threads;
    Widget item(MemoryComment comment, {required bool reply}) => _CommentItem(
      comment: comment,
      name: _name(controller, comment),
      age: _age(context, controller, comment),
      reply: reply,
      colors: _avatarColors(controller.memberByUser(comment.authorId), comment),
      onReply: reply ? null : () => controller.startReply(comment),
      onLongPress: (rect) => _openMenu(context, controller, comment, rect),
    );
    return BaseScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBackTitleBar(
            title: l10n.memCommentsCount(controller.comments.length),
          ),
          _CommentContext(
            memory: memory,
            author: controller.memberByUser(memory.authorId),
            onTap: () =>
                context.router.push(MemoryDetailRoute(memoryId: memory.id)),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.cardInset,
                AppSpacing.screen,
                AppSpacing.s3,
              ),
              itemCount: threads.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s3),
              itemBuilder: (_, index) {
                final thread = threads[index];
                final replies = controller.repliesOf(thread.id);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    item(thread, reply: false),
                    for (final reply in replies) ...[
                      const SizedBox(height: AppSpacing.itemGap),
                      Padding(
                        padding: const EdgeInsets.only(left: 42),
                        child: item(reply, reply: true),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
          _CommentComposer(
            controller: controller,
            replyingName: controller.replyTo == null
                ? null
                : _name(controller, controller.replyTo!),
            onEmoji: () => _pickEmoji(context, controller),
          ),
        ],
      ),
    );
  }

  static String _name(
    MemoryCommentsController controller,
    MemoryComment comment,
  ) {
    final member = controller.memberByUser(comment.authorId);
    return member == null ? comment.authorName : memberFullName(member);
  }

  /// “45 phút” • “2 giờ” • “Hôm qua” • “05/10”.
  static String _age(
    BuildContext context,
    MemoryCommentsController controller,
    MemoryComment comment,
  ) {
    final l10n = context.l10n;
    final now = controller.now;
    final diff = now.difference(comment.createdAt);
    if (diff.inMinutes < 1) {
      return l10n.memJustNow;
    }
    if (diff.inMinutes < 60) {
      return l10n.memCommentMinutes(diff.inMinutes);
    }
    if (comment.createdAt.isSameDay(now)) {
      return l10n.memCommentHours(diff.inHours);
    }
    return memoryRelativeTime(l10n, comment.createdAt, now);
  }

  /// Avatar chữ (Pencil): Mama `primary-500`, Papa `secondary-500` (chữ
  /// trắng); bà `accent-100`, ông `us-100`/`us-700`.
  static (Color, Color) _avatarColors(Member? member, MemoryComment comment) {
    final role = member?.role ?? comment.authorRole;
    return switch (role) {
      FamilyRole.mother => (kColorPrimary500EE7B67, kColorWhite),
      FamilyRole.father => (kColorSecondary5006FAE8E, kColorWhite),
      _ => switch (member?.relation) {
        RelativeRelation.grandpaPaternal || RelativeRelation.grandpaMaternal =>
          (kColorUs100EAE2F8, kColorUs7006A549F),
        _ => (kColorAccent100FDF1D6, kColorTextPrimary2E2A27),
      },
    };
  }

  Future<void> _openMenu(
    BuildContext context,
    MemoryCommentsController controller,
    MemoryComment comment,
    Rect anchor,
  ) async {
    HapticFeedback.selectionClick();
    final l10n = context.l10n;
    final action = await _showCommentActionMenu(
      context,
      anchor: anchor,
      canEdit: controller.canEdit(comment),
      canDelete: controller.isMine(comment),
      canReport: !controller.isMine(comment),
    );
    if (!context.mounted || action == null) {
      return;
    }
    switch (action) {
      case CommentAction.edit:
        controller.startEdit(comment);
      case CommentAction.copy:
        await Clipboard.setData(ClipboardData(text: comment.body));
        if (context.mounted) {
          showAppSnackBar(context, l10n.commonCopied);
        }
      case CommentAction.delete:
        await controller.delete(comment);
      case CommentAction.report:
        final reasons = await controller.reportReasons();
        if (!context.mounted) {
          return;
        }
        await showReportSheet(
          context,
          target: ReportTarget.comment,
          reasons: reasons,
          canRemove: controller.me?.role.isParent ?? false,
          onSubmit: (request) => controller.report(comment, request),
          onTrack: () => context.router.push(const HelpRoute()),
        );
    }
  }

  Future<void> _pickEmoji(
    BuildContext context,
    MemoryCommentsController controller,
  ) async {
    final emoji = await showAppBottomSheet<String>(
      context,
      builder: (sheetContext) => AppBottomSheet(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (final emoji in kValueCommentEmoji)
                InkResponse(
                  onTap: () => Navigator.of(sheetContext).pop(emoji),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.s2),
                    child: Text(emoji, style: const TextStyle(fontSize: 28)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
    if (emoji != null) {
      controller.insertEmoji(emoji);
    }
  }
}
