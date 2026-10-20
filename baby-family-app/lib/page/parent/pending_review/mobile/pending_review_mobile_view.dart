import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/page/parent/pending_review/pending_review_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/media_image.dart';
import 'package:baby_family/utils/helper/memory_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_relative_avatar.dart';
import 'package:baby_family/utils/widget/app_tag_pill.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/memory_list_skeleton.dart';
import 'package:baby_family/utils/widget/memory_thumb.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/child_edit_panel.dart';
part '../widgets/pending_author_row.dart';
part '../widgets/pending_card.dart';
part '../widgets/pending_collapsed_row.dart';
part '../widgets/pending_photos.dart';
part '../widgets/reject_panel.dart';

/// MEM-19 — Chờ duyệt (Pencil `FCHTr`).
class PendingReviewMobileView extends HookConsumerWidget {
  const PendingReviewMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(pendingReviewControllerProvider);
    final l10n = context.l10n;
    final posts = controller.posts;

    Future<void> approve(Memory post) async {
      await controller.approve(post);
      if (context.mounted) {
        showAppSnackBar(context, l10n.memPendingApproved);
      }
    }

    Future<void> reject(Memory post) async {
      await controller.reject(post);
      if (context.mounted) {
        showAppSnackBar(context, l10n.memPendingRejected);
      }
    }

    Widget body;
    if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else if (posts == null) {
      body = const Padding(
        padding: EdgeInsets.all(AppSpacing.screen),
        child: MemoryListSkeleton(),
      );
    } else {
      const gap = SizedBox(height: AppSpacing.cardInset);
      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          AppSpacing.s8 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  l10n.memPendingTitle,
                  style: AppTypography.adapt(context, AppTypography.h1),
                ),
              ),
              if (posts.isNotEmpty) ...[
                const SizedBox(width: AppSpacing.itemGap),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.resolve(context, kColorPrimary500EE7B67),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    '${posts.length}',
                    style: AppTypography.adapt(
                      context,
                      AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: kColorWhite,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.compact),
          Text(
            l10n.memPendingSubtitle(controller.partnerName),
            style: AppTypography.adapt(
              context,
              AppTypography.caption.copyWith(
                height: 19 / 13,
                color: kColorTextSecondary6B625B,
              ),
            ),
          ),
          if (posts.isEmpty) ...[
            const SizedBox(height: AppSpacing.s8),
            EmptyState(
              title: l10n.memPendingEmpty,
              description: l10n.memPendingEmptyHint,
            ),
          ],
          for (final post in posts) ...[
            gap,
            if (controller.isExpanded(post))
              _PendingCard(
                post: post,
                controller: controller,
                onApprove: () => approve(post),
                onReject: () => reject(post),
              )
            else
              _PendingCollapsedRow(
                post: post,
                controller: controller,
                onTap: () => controller.expand(post),
              ),
          ],
        ],
      );
    }
    return BaseScaffold(appBar: const AppTopBar(), body: body);
  }
}
