import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/circle/circle_post_draft.dart';
import 'package:baby_family/page/circle/circle_post/circle_post_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/input_decoration.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/post_app_bar.dart';
part '../widgets/post_kid_chip.dart';
part '../widgets/post_photo_grid.dart';
part '../widgets/post_sent.dart';

/// CIR-04 — Đăng ảnh cho cháu (Pencil `rrk4E`), đã gửi CIR-04b (`VlK9Y`).
/// Tab “Đăng ảnh” của Circle shell: nút ✕ về tab Cháu yêu.
class CirclePostMobileView extends HookConsumerWidget {
  const CirclePostMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(circlePostControllerProvider);
    final l10n = context.l10n;
    void home() =>
        AutoTabsRouter.of(context).setActiveIndex(CircleTab.home.index);

    final sent = controller.sent;
    if (sent != null) {
      return BaseScaffold(
        body: SafeArea(
          bottom: false,
          child: _PostSent(
            post: sent,
            children: controller.selectedChildren,
            onClose: home,
            onHome: () {
              home();
              controller.load();
            },
            onMore: controller.load,
          ),
        ),
      );
    }

    Widget body;
    if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else if (!controller.loaded) {
      body = const SizedBox.shrink();
    } else if (controller.children.isEmpty) {
      body = Center(child: EmptyState(title: l10n.cirPostNoKid));
    } else {
      final section = AppTypography.adapt(
        context,
        AppTypography.title20.copyWith(fontSize: 19, height: 26 / 19),
      );
      const gap = SizedBox(height: AppSpacing.s5);
      const titleGap = SizedBox(height: AppSpacing.s3);
      final takenAt = controller.takenAt ?? controller.today;
      final locale = l10n.localeName;
      final dateLabel = takenAt.isSameDay(controller.today)
          ? l10n.memTodayAt(takenAt.toFormDate(locale))
          : takenAt.toFormDate(locale);
      final kids = controller.children;
      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.s1,
          AppSpacing.screen,
          28 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Text(l10n.cirPostSelected(controller.assets.length), style: section),
          titleGap,
          _PostPhotoGrid(controller: controller),
          gap,
          Text(l10n.cirPostWhichKid, style: section),
          titleGap,
          for (var index = 0; index < kids.length; index += 2) ...[
            if (index > 0) const SizedBox(height: AppSpacing.itemGap),
            Row(
              children: [
                Expanded(
                  child: _PostKidChip(
                    child: kids[index],
                    selected: controller.childIds.contains(kids[index].id),
                    onTap: () => controller.toggleChild(kids[index].id),
                  ),
                ),
                const SizedBox(width: AppSpacing.itemGap),
                Expanded(
                  child: index + 1 < kids.length
                      ? _PostKidChip(
                          child: kids[index + 1],
                          selected: controller.childIds.contains(
                            kids[index + 1].id,
                          ),
                          onTap: () =>
                              controller.toggleChild(kids[index + 1].id),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ],
          gap,
          Text(l10n.cirPostDate, style: section),
          titleGap,
          Material(
            color: AppColors.resolve(context, kColorSurfaceFFFFFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              side: BorderSide(
                color: AppColors.resolve(context, kColorBorderEADFD6),
              ),
            ),
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: takenAt,
                  firstDate: DateTime(controller.today.year - 20),
                  lastDate: controller.today,
                );
                if (picked != null) {
                  controller.setDate(picked);
                }
              },
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 60),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s4,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.calendar,
                        size: 22,
                        color: AppColors.resolve(
                          context,
                          kColorTextSecondary6B625B,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s3),
                      Expanded(
                        child: Text(
                          dateLabel,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.bodyLarge.copyWith(height: 22 / 17),
                          ),
                        ),
                      ),
                      Icon(
                        LucideIcons.chevronRight,
                        size: 20,
                        color: AppColors.resolve(
                          context,
                          kColorTextTertiary9C928A,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          gap,
          Text(l10n.cirPostMessage, style: section),
          titleGap,
          Container(
            padding: const EdgeInsets.all(AppSpacing.s4),
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSurfaceFFFFFF),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: AppColors.resolve(context, kColorPrimary500EE7B67),
              ),
            ),
            child: TextField(
              controller: controller.message,
              minLines: 2,
              maxLines: 5,
              style: AppTypography.adapt(context, AppTypography.bodyLarge),
              decoration: bareInputDecoration(
                hint: l10n.cirPostMessageHint,
                hintStyle: AppTypography.adapt(
                  context,
                  AppTypography.bodyLarge.copyWith(
                    color: kColorTextTertiary9C928A,
                  ),
                ),
              ),
            ),
          ),
          gap,
          Container(
            padding: const EdgeInsets.all(AppSpacing.s4),
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSecondary100E4F2EA),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  LucideIcons.shieldCheck,
                  size: 26,
                  color: AppColors.resolve(context, kColorSecondary7003F7A5C),
                ),
                const SizedBox(width: AppSpacing.s3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.cirPostApprovalTitle,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.bodyLarge.copyWith(
                            height: 22 / 17,
                            fontWeight: FontWeight.w700,
                            color: kColorSecondary7003F7A5C,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s1),
                      Text(
                        l10n.cirPostApprovalBody,
                        style: AppTypography.adapt(context, AppTypography.body),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          gap,
          AppButton(
            label: l10n.cirPostSend,
            height: 60,
            fontSize: 18,
            isLoading: controller.isLoading,
            onPressed: controller.canSend ? controller.submit : null,
          ),
        ],
      );
    }
    return BaseScaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _PostAppBar(title: l10n.circlePostTitle, onClose: home),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
