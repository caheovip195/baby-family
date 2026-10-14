import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/us/rewrite_option.dart';
import 'package:baby_family/page/parent/bridge_rewrite/bridge_rewrite_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_text_action.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/rewrite_edit_box.dart';
part '../widgets/rewrite_version_card.dart';

/// US-09 — Viết lại nhẹ nhàng (Pencil `cRWCh`): nền `us-50`, “Dừng lại”, câu
/// gốc (`surface-variant`), nhãn “✨ Gợi ý bởi AI” + “Báo cáo nội dung AI”, 3
/// thẻ phiên bản (chọn: viền `us-500` + radio `us-700`), ô sửa, “Giữ câu gốc”
/// / “Dùng câu này”, ghi chú dữ liệu AI.
class BridgeRewriteMobileView extends HookConsumerWidget {
  const BridgeRewriteMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(bridgeRewriteControllerProvider);
    final l10n = context.l10n;
    final Widget body;
    if (!controller.loaded) {
      body = const Center(child: CircleLoadingProgress());
    } else if (controller.hasError) {
      body = ErrorState(onRetry: controller.load);
    } else if (controller.suggestion == null) {
      body = EmptyState(title: l10n.usBridgeRewriteTitle);
    } else {
      body = _content(context, controller);
    }
    return BaseScaffold(
      backgroundColor: kColorUs50F6F2FC,
      appBar: AppTopBar(
        backgroundColor: kColorUs50F6F2FC,
        trailing: AppTextAction(
          label: l10n.usBridgePause,
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: body,
    );
  }

  Widget _content(BuildContext context, BridgeRewriteController controller) {
    final l10n = context.l10n;
    final suggestion = controller.suggestion!;
    final usDark = AppColors.resolve(context, kColorUs7006A549F);
    final tertiary = AppColors.resolve(context, kColorTextTertiary9C928A);
    final items = <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.usBridgeRewriteTitle,
            style: AppTypography.adapt(context, AppTypography.h1),
          ),
          const SizedBox(height: AppSpacing.s1),
          Text(
            l10n.usBridgeRewriteSub,
            style: AppTypography.adapt(
              context,
              AppTypography.caption.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
      Container(
        padding: const EdgeInsets.all(AppSpacing.cardInset),
        decoration: BoxDecoration(
          color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.usBridgeRewriteOriginal,
              style: AppTypography.adapt(
                context,
                AppTypography.tiny.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: AppSpacing.compact),
            Text(
              l10n.commonQuoted(suggestion.original),
              style: AppTypography.adapt(
                context,
                AppTypography.text14.copyWith(
                  height: 1.4,
                  color: kColorTextSecondary6B625B,
                ),
              ),
            ),
          ],
        ),
      ),
      Row(
        children: [
          Container(
            height: 28,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.itemGap),
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorUs100EAE2F8),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.sparkles, size: 14, color: usDark),
                const SizedBox(width: AppSpacing.compact),
                Text(
                  l10n.commonAiSuggested,
                  style: AppTypography.small.copyWith(
                    fontWeight: FontWeight.w700,
                    color: usDark,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () => showAppSnackBar(context, l10n.commonAiReported),
            borderRadius: BorderRadius.circular(AppRadius.xs),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s1),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.flag, size: 13, color: tertiary),
                  const SizedBox(width: AppSpacing.s1),
                  Text(
                    l10n.commonAiReport,
                    style: AppTypography.small.copyWith(color: tertiary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      for (final RewriteOption option in suggestion.options)
        _RewriteVersionCard(
          option: option,
          selected: option.tone == controller.tone,
          onTap: () => controller.select(option.tone),
        ),
      _RewriteEditBox(
        key: ValueKey(controller.revision),
        initialValue: controller.edited,
        onChanged: controller.edit,
      ),
      Padding(
        padding: const EdgeInsets.only(top: AppSpacing.s1),
        child: Row(
          children: [
            Expanded(
              child: AppButton.secondary(
                label: l10n.usBridgeRewriteKeep,
                color: kColorUs7006A549F,
                onPressed: () =>
                    context.router.maybePop<String>(suggestion.original),
              ),
            ),
            const SizedBox(width: AppSpacing.itemGap),
            Expanded(
              child: AppButton.us(
                label: l10n.usBridgeRewriteUse,
                onPressed: () =>
                    context.router.maybePop<String>(controller.edited.trim()),
              ),
            ),
          ],
        ),
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(LucideIcons.info, size: 14, color: tertiary),
          ),
          const SizedBox(width: AppSpacing.compact),
          Expanded(
            child: Text(
              l10n.usBridgeRewriteDataNote,
              style: AppTypography.tiny.copyWith(height: 1.4, color: tertiary),
            ),
          ),
        ],
      ),
    ];
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        AppSpacing.s6 + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        for (var index = 0; index < items.length; index++) ...[
          if (index > 0) const SizedBox(height: AppSpacing.cardInset),
          items[index],
        ],
      ],
    );
  }
}
