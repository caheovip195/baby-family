import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/parent/bridge_invite/bridge_invite_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/parent_color.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_initial_avatar.dart';
import 'package:baby_family/utils/widget/app_selectable_chip.dart';
import 'package:baby_family/utils/widget/app_value_pill.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/bridge_share_card.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:baby_family/utils/widget/us_private_label.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/invite_later_options.dart';

/// US-10 — Lời mời Cầu nối (góc nhìn người nhận, Pencil `ZM8Ho`): nền
/// `us-50`, dòng khoá “Chỉ hai bạn nhìn thấy” + nút đóng, vòng 84
/// `heart-handshake`, tiêu đề 22/800 giữa, thẻ “đã chọn chia sẻ”, ghi chú
/// bước riêng tư, “Tham gia ngay”, “Để sau — nhắc mình lúc”, “Mình chưa sẵn
/// sàng”.
class BridgeInviteMobileView extends HookConsumerWidget {
  const BridgeInviteMobileView({required this.sessionId, super.key});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(bridgeInviteControllerProvider(sessionId));
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
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.s1,
                AppSpacing.s3,
                0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: UsPrivateLabel(l10n.usOnlyTwo),
                    ),
                  ),
                  SizedBox.square(
                    dimension: AppSpacing.iconButton,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      tooltip: l10n.commonClose,
                      onPressed: () => context.router.maybePop(),
                      icon: Icon(
                        LucideIcons.x,
                        size: 22,
                        color: AppColors.resolve(
                          context,
                          kColorTextPrimary2E2A27,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }

  Future<void> _pause(
    BuildContext context,
    BridgeInviteController controller,
    String message,
  ) async {
    if (await controller.pause() && context.mounted) {
      showAppSnackBar(context, message);
      await context.router.maybePop();
    }
  }

  Widget _content(BuildContext context, BridgeInviteController controller) {
    final l10n = context.l10n;
    final inviter = controller.inviter;
    final name = inviter?.callName ?? '';
    final share = controller.inviterShare;
    final usDark = AppColors.resolve(context, kColorUs7006A549F);
    final secondary = AppColors.resolve(context, kColorTextSecondary6B625B);
    final items = <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: AppSpacing.s2),
        child: Column(
          children: [
            Container(
              width: 84,
              height: 84,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.resolve(context, kColorUs100EAE2F8),
                shape: BoxShape.circle,
              ),
              child: Icon(LucideIcons.heartHandshake, size: 40, color: usDark),
            ),
            const SizedBox(height: AppSpacing.s3),
            Text(
              l10n.usBridgeInviteTitle(name),
              textAlign: TextAlign.center,
              style: AppTypography.adapt(
                context,
                AppTypography.h2.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s3),
            Text(
              l10n.usBridgeInviteSub,
              textAlign: TextAlign.center,
              style: AppTypography.adapt(
                context,
                AppTypography.caption.copyWith(height: 1.4),
              ),
            ),
          ],
        ),
      ),
      if (share != null)
        BridgeShareCard(
          avatar: AppInitialAvatar(
            name: name,
            size: 32,
            color: parentAvatarColor(inviter?.role),
          ),
          title: l10n.usBridgeInviteShared(name),
          subtitle: l10n.usBridgeInviteSharedSub(name),
          rows: [
            (
              l10n.usBridgeFeelShort,
              [
                for (final title in controller.titles(
                  controller.feelingOptions,
                  share.feelings,
                ))
                  AppValuePill(label: title),
              ],
            ),
            (
              l10n.usBridgeNeedShort,
              [
                for (final title in controller.titles(
                  controller.needOptions,
                  share.needs,
                ))
                  AppValuePill(label: title),
              ],
            ),
          ],
          message: share.message,
        ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(LucideIcons.lock, size: 14, color: usDark),
          ),
          const SizedBox(width: AppSpacing.s2),
          Expanded(
            child: Text(
              l10n.usBridgeInviteNote,
              style: AppTypography.small.copyWith(height: 1.4, color: usDark),
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(top: AppSpacing.s1),
        child: AppButton.us(
          label: l10n.usBridgeJoinNow,
          isLoading: controller.busy,
          onPressed: () async {
            if (await controller.join() && context.mounted) {
              await context.router.replace(
                BridgeSessionRoute(sessionId: sessionId),
              );
            }
          },
        ),
      ),
      _InviteLaterOptions(
        onSelect: () => _pause(context, controller, l10n.usBridgeRemindSet),
      ),
      InkWell(
        onTap: () => _pause(context, controller, l10n.usBridgePaused),
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.compact,
            bottom: AppSpacing.s1,
          ),
          child: Column(
            children: [
              Text(
                l10n.usBridgeNotReady,
                textAlign: TextAlign.center,
                style: AppTypography.text14.copyWith(
                  fontWeight: FontWeight.w700,
                  color: secondary,
                ),
              ),
              const SizedBox(height: AppSpacing.s1),
              Text(
                l10n.usBridgeNotReadySub,
                textAlign: TextAlign.center,
                style: AppTypography.adapt(context, AppTypography.tiny),
              ),
            ],
          ),
        ),
      ),
    ];
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.s2,
        AppSpacing.screen,
        AppSpacing.s6 + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        for (var index = 0; index < items.length; index++) ...[
          if (index > 0)
            SizedBox(height: index >= 4 ? AppSpacing.s3 : AppSpacing.s4),
          items[index],
        ],
      ],
    );
  }
}
