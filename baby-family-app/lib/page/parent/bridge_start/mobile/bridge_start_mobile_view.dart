import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/us/bridge_option.dart';
import 'package:baby_family/page/parent/bridge_start/bridge_start_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/lucide_icon.dart';
import 'package:baby_family/utils/helper/parent_color.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_choice_card.dart';
import 'package:baby_family/utils/widget/app_initial_avatar.dart';
import 'package:baby_family/utils/widget/app_selectable_chip.dart';
import 'package:baby_family/utils/widget/app_text_action.dart';
import 'package:baby_family/utils/widget/app_text_input_sheet.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/app_value_pill.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/bridge_share_card.dart';
import 'package:baby_family/utils/widget/bridge_value_table.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/bridge_chip_grid.dart';
part '../widgets/bridge_draft_box.dart';
part '../widgets/bridge_so_far_card.dart';
part '../widgets/bridge_text_link.dart';

/// US-08 — Cầu nối: bắt đầu (Pencil `Is4I7`, bước 3/5): nền `us-50`, thanh
/// trên 5 chấm `us-500`/`us-100` + “Dừng lại”, dải “Chỉ bạn thấy…”, nhãn bước,
/// tiêu đề 26/800, nội dung từng bước, nút “Tiếp tục” `us-700` và liên kết
/// “Mình cảm thấy không an toàn” (US-13).
class BridgeStartMobileView extends HookConsumerWidget {
  const BridgeStartMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(bridgeStartControllerProvider);
    final l10n = context.l10n;
    final Widget body;
    if (!controller.loaded) {
      body = const Center(child: CircleLoadingProgress());
    } else if (controller.hasError) {
      body = ErrorState(onRetry: controller.load);
    } else {
      body = _content(context, controller);
    }
    return BaseScaffold(
      backgroundColor: kColorUs50F6F2FC,
      appBar: AppTopBar(
        step: controller.step,
        stepCount: kValueBridgeWizardSteps,
        currentStepOnly: true,
        dotColor: kColorUs5009B85D1,
        dotTrackColor: kColorUs100EAE2F8,
        backgroundColor: kColorUs50F6F2FC,
        onBack: () {
          if (!controller.back()) {
            context.router.maybePop();
          }
        },
        trailing: AppTextAction(
          label: l10n.usBridgePause,
          onPressed: () async {
            await controller.keepPrivate();
            if (context.mounted) {
              await context.router.maybePop();
            }
          },
        ),
      ),
      body: body,
    );
  }

  Widget _content(BuildContext context, BridgeStartController controller) {
    final l10n = context.l10n;
    final partner = controller.partnerName;
    final step = controller.step;
    final (title, subtitle) = switch (step) {
      1 => (l10n.usBridgeEmotion, l10n.usBridgeFeelSub(partner)),
      2 => (l10n.usBridgeTopicTitle, l10n.usBridgeTopicSub(partner)),
      3 => (l10n.usBridgeNeedTitle, l10n.usBridgeNeedSub(partner)),
      4 => (l10n.usBridgeChoiceTitle, l10n.usBridgeChoiceSub(partner)),
      _ => (l10n.usBridgePreviewTitle(partner), l10n.usBridgePreviewSub),
    };
    final usDark = AppColors.resolve(context, kColorUs7006A549F);
    final items = <Widget>[
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardInset,
          vertical: AppSpacing.itemGap,
        ),
        decoration: BoxDecoration(
          color: AppColors.resolve(context, kColorUs100EAE2F8),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: [
            Icon(LucideIcons.lock, size: 16, color: usDark),
            const SizedBox(width: AppSpacing.itemGap),
            Expanded(
              child: Text(
                l10n.usBridgePrivate,
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: usDark,
                ),
              ),
            ),
          ],
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.usBridgeStepKicker(step, kValueBridgeWizardSteps),
            style: AppTypography.overline.copyWith(
              fontWeight: FontWeight.w700,
              color: usDark,
            ),
          ),
          const SizedBox(height: AppSpacing.s1),
          Text(title, style: AppTypography.adapt(context, AppTypography.h1)),
          const SizedBox(height: AppSpacing.s1),
          Text(
            subtitle,
            style: AppTypography.adapt(
              context,
              AppTypography.caption.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
      ..._stepBody(context, controller),
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

  List<Widget> _stepBody(BuildContext context, BridgeStartController c) {
    final l10n = context.l10n;
    Widget chip(BridgeOption option, Set<String> codes, VoidCallback onTap) {
      final selected = codes.contains(option.code);
      final icon = option.icon;
      return AppSelectableChip(
        label: option.title,
        selected: selected,
        outlined: true,
        padding: AppSpacing.itemGap,
        textColor: selected ? null : kColorUs7006A549F,
        onPressed: onTap,
        prefix: icon == null && !selected
            ? null
            : Icon(
                selected ? LucideIcons.check : lucideIconByName(icon),
                size: 14,
                color: selected
                    ? AppColors.onPrimary(context)
                    : AppColors.resolve(context, kColorUs7006A549F),
              ),
      );
    }

    final soFar = _BridgeSoFarCard(controller: c);
    final unsafe = Center(
      child: _BridgeTextLink(
        label: l10n.usBridgeUnsafe,
        icon: LucideIcons.shieldAlert,
        color: kColorTextSecondary6B625B,
        onTap: () => context.router.push(const SafetySupportRoute()),
      ),
    );
    Widget next({bool enabled = true}) => Padding(
      padding: const EdgeInsets.only(top: AppSpacing.compact),
      child: AppButton.us(
        label: l10n.commonContinue,
        onPressed: enabled ? c.next : null,
      ),
    );
    switch (c.step) {
      case 1:
        return [
          _BridgeChipGrid(
            children: [
              for (final option in c.feelingOptions)
                chip(option, c.feelings, () => c.toggleFeeling(option.code)),
            ],
          ),
          next(enabled: c.feelings.isNotEmpty),
          unsafe,
        ];
      case 2:
        return [
          soFar,
          _BridgeChipGrid(
            children: [
              for (final title in c.topicOptions)
                AppSelectableChip(
                  label: title,
                  selected: c.topic == title,
                  outlined: true,
                  textColor: c.topic == title ? null : kColorUs7006A549F,
                  onPressed: () => c.selectTopic(title),
                ),
            ],
          ),
          next(),
          unsafe,
        ];
      case 3:
        return [
          soFar,
          _BridgeChipGrid(
            children: [
              for (final option in c.needOptions)
                chip(option, c.needs, () => c.toggleNeed(option.code)),
            ],
          ),
          _BridgeDraftBox(
            initialValue: c.privateNote,
            onChanged: c.setPrivateNote,
          ),
          next(enabled: c.needs.isNotEmpty),
          unsafe,
        ];
      case 4:
        return [
          soFar,
          AppChoiceCard(
            title: l10n.usBridgeKeepPrivate,
            description: l10n.usBridgeKeepPrivateDesc,
            icon: LucideIcons.lock,
            selected: false,
            color: kColorUs7006A549F,
            iconBackground: kColorUs100EAE2F8,
            titleFontSize: 16,
            onTap: () async {
              await c.keepPrivate();
              if (context.mounted) {
                showAppSnackBar(context, l10n.usBridgeKeptPrivate);
                await context.router.maybePop();
              }
            },
          ),
          AppChoiceCard(
            title: l10n.usBridgeRewriteOption,
            description: l10n.usBridgeRewriteOptionDesc,
            icon: LucideIcons.sparkles,
            selected: false,
            color: kColorUs7006A549F,
            iconBackground: kColorUs100EAE2F8,
            titleFontSize: 16,
            onTap: () => _rewrite(context, c),
          ),
          AppChoiceCard(
            title: l10n.usBridgeShareOption,
            description: l10n.usBridgeShareOptionDesc(c.partnerName),
            icon: LucideIcons.send,
            selected: false,
            color: kColorUs7006A549F,
            iconBackground: kColorUs100EAE2F8,
            titleFontSize: 16,
            onTap: c.next,
          ),
          unsafe,
        ];
      default:
        return _preview(context, c);
    }
  }

  Future<void> _rewrite(BuildContext context, BridgeStartController c) async {
    final text = await context.router.push<String>(const BridgeRewriteRoute());
    if (text != null && text.trim().isNotEmpty) {
      c.useRewrite(text);
    }
  }

  List<Widget> _preview(BuildContext context, BridgeStartController c) {
    final l10n = context.l10n;
    final me = c.me;
    final name = me?.callName ?? '';
    Widget toggle(BridgeOption option, Set<String> shared) => AppSelectableChip(
      label: option.title,
      selected: shared.contains(option.code),
      filledSelection: false,
      outlined: true,
      height: 30,
      fontSize: 12,
      padding: AppSpacing.itemGap,
      onPressed: () => c.toggleShared(shared, option.code),
    );
    return [
      BridgeShareCard(
        avatar: AppInitialAvatar(
          name: name,
          size: 32,
          color: parentAvatarColor(me?.role),
        ),
        title: l10n.usBridgeInviteShared(name),
        subtitle: l10n.usBridgeInviteSharedSub(name),
        rows: [
          (
            l10n.usBridgeFeelShort,
            [
              for (final option in c.selected(c.feelingOptions, c.feelings))
                toggle(option, c.sharedFeelings),
            ],
          ),
          (
            l10n.usBridgeNeedShort,
            [
              for (final option in c.selected(c.needOptions, c.needs))
                toggle(option, c.sharedNeeds),
            ],
          ),
        ],
        message: c.message,
      ),
      Wrap(
        spacing: AppSpacing.s4,
        runSpacing: AppSpacing.s1,
        children: [
          _BridgeTextLink(
            label: l10n.usBridgeMessageLabel,
            icon: LucideIcons.pencil,
            onTap: () async {
              final value = await showAppTextInputSheet(
                context,
                title: l10n.usBridgeMessageLabel,
                actionLabel: l10n.commonSave,
                hint: l10n.usBridgeMessageHint(c.partnerName),
                initialValue: c.message,
              );
              if (value != null) {
                c.setMessage(value);
              }
            },
          ),
          _BridgeTextLink(
            label: l10n.usBridgeRewriteTitle,
            icon: LucideIcons.sparkles,
            onTap: () => _rewrite(context, c),
          ),
        ],
      ),
      AppButton.us(
        label: l10n.usBridgeSendInvite,
        isLoading: c.sending,
        onPressed: () async {
          final sessionId = await c.send();
          if (sessionId == null || !context.mounted) {
            return;
          }
          showAppSnackBar(context, l10n.usBridgeInviteSent(c.partnerName));
          await context.router.replace(
            BridgeSessionRoute(sessionId: sessionId),
          );
        },
      ),
    ];
  }
}
