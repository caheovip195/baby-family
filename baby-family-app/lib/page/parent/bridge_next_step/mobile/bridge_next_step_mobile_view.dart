import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/us/bridge_option.dart';
import 'package:baby_family/page/parent/bridge_next_step/bridge_next_step_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/lucide_icon.dart';
import 'package:baby_family/utils/helper/parent_color.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_initial_avatar.dart';
import 'package:baby_family/utils/widget/app_selectable_chip.dart';
import 'package:baby_family/utils/widget/app_switch.dart';
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

part '../widgets/close_session_sheet.dart';
part '../widgets/next_step_chip.dart';
part '../widgets/next_step_confirmation.dart';
part '../widgets/next_step_details.dart';

/// US-12 — Bước tiếp theo (Pencil `b0kyKY`): nền `us-50`, “Tạm dừng”, nhãn
/// “Hai bạn đều đã hiểu”, các chip bước nhỏ (chọn: `us-700`), chi tiết (khi
/// nào, trông bé nào, nhắc cho cả hai), xác nhận của hai người, “Xác nhận bước
/// này” → sheet US-12b `EjpK0` → về Papa & Mama.
class BridgeNextStepMobileView extends HookConsumerWidget {
  const BridgeNextStepMobileView({required this.sessionId, super.key});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(bridgeNextStepControllerProvider(sessionId));
    final l10n = context.l10n;
    final Widget body;
    if (!controller.loaded) {
      body = const Center(child: CircleLoadingProgress());
    } else if (controller.hasError) {
      body = ErrorState(onRetry: controller.load);
    } else if (controller.session == null) {
      body = EmptyState(title: l10n.usBridgeShort);
    } else {
      body = _content(context, controller);
    }
    return BaseScaffold(
      backgroundColor: kColorUs50F6F2FC,
      appBar: AppTopBar(
        backgroundColor: kColorUs50F6F2FC,
        trailing: AppTextAction(
          label: l10n.commonPause,
          onPressed: () async {
            await controller.usService.pauseBridge(sessionId);
            if (context.mounted) {
              showAppSnackBar(context, l10n.usBridgePaused);
              _backToCouple(context);
            }
          },
        ),
      ),
      body: body,
    );
  }

  void _backToCouple(BuildContext context) => context.router.navigate(
    const MainShellRoute(children: [CoupleTabRoute()]),
  );

  Future<void> _confirm(
    BuildContext context,
    BridgeNextStepController controller,
  ) async {
    if (!controller.iAgreed && !await controller.confirm()) {
      return;
    }
    if (!context.mounted) {
      return;
    }
    final closed = await showCloseSessionSheet(context, controller: controller);
    if (!context.mounted || closed == null) {
      return;
    }
    if (closed) {
      showAppSnackBar(context, context.l10n.usBridgeClosed);
    }
    _backToCouple(context);
  }

  Widget _content(BuildContext context, BridgeNextStepController controller) {
    final l10n = context.l10n;
    final me = controller.me;
    final partner = controller.partner;
    final step = controller.step;
    final usDark = AppColors.resolve(context, kColorUs7006A549F);
    final items = <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.usBridgeNextKicker,
            style: AppTypography.overline.copyWith(
              fontWeight: FontWeight.w700,
              color: usDark,
            ),
          ),
          const SizedBox(height: AppSpacing.s1),
          Text(
            l10n.usBridgeNextStepTitle,
            style: AppTypography.adapt(context, AppTypography.h1),
          ),
          const SizedBox(height: AppSpacing.s1),
          Text(
            l10n.usBridgeNextSub,
            style: AppTypography.adapt(
              context,
              AppTypography.caption.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
      Wrap(
        spacing: AppSpacing.s2,
        runSpacing: AppSpacing.s2,
        children: [
          for (final BridgeOption option in controller.options)
            _NextStepChip(
              option: option,
              selected: option.code == step?.code,
              onTap: () => controller.choose(option.code),
            ),
        ],
      ),
      if (step != null)
        _NextStepDetails(
          whenLabel: step.whenLabel,
          childNames: [for (final child in controller.stepChildren) child.name],
          reminder: step.reminder,
          reminderAt: step.reminderAt?.toDisplayTime(l10n.localeName),
          onReminder: controller.toggleReminder,
        ),
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _NextStepConfirmation(
                member: me,
                name: l10n.usYou,
                agreed: controller.iAgreed,
              ),
            ),
            const SizedBox(width: AppSpacing.itemGap),
            Expanded(
              child: _NextStepConfirmation(
                member: partner,
                name: partner?.callName ?? '',
                agreed: controller.agreed(partner?.userId),
              ),
            ),
          ],
        ),
      ),
      AppButton.us(
        label: l10n.usBridgeConfirmStep,
        isLoading: controller.busy,
        onPressed: step == null ? null : () => _confirm(context, controller),
      ),
      Text(
        l10n.usBridgeConfirmNote,
        textAlign: TextAlign.center,
        style: AppTypography.adapt(
          context,
          AppTypography.small.copyWith(
            height: 1.4,
            color: kColorTextTertiary9C928A,
          ),
        ),
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
