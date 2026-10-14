import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/us/bridge_share.dart';
import 'package:baby_family/page/parent/bridge_session/bridge_session_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/mission_text.dart';
import 'package:baby_family/utils/helper/parent_color.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_initial_avatar.dart';
import 'package:baby_family/utils/widget/app_text_input_sheet.dart';
import 'package:baby_family/utils/widget/app_value_pill.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:baby_family/utils/widget/us_private_label.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/session_app_bar.dart';
part '../widgets/session_share_column.dart';
part '../widgets/session_turn_card.dart';

/// US-11 — Phiên chung (Pencil `iFmGo`): nền `us-50`, thanh “Cầu nối” + khoá
/// + “Tạm dừng”, trạng thái “Đang diễn ra” + giờ bắt đầu, lời dẫn, hai cột
/// chia sẻ (của tôi `primary-50`, của bạn đời `secondary-100`), thẻ “Lượt của
/// bạn”, ghi chú có thể rời phiên.
class BridgeSessionMobileView extends HookConsumerWidget {
  const BridgeSessionMobileView({required this.sessionId, super.key});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(bridgeSessionControllerProvider(sessionId));
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
            _SessionAppBar(onPause: () => _pause(context, controller)),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }

  Future<void> _pause(
    BuildContext context,
    BridgeSessionController controller,
  ) async {
    final message = context.l10n.usBridgePaused;
    if (await controller.pause() && context.mounted) {
      showAppSnackBar(context, message);
      await context.router.maybePop();
    }
  }

  Future<void> _understand(
    BuildContext context,
    BridgeSessionController controller,
  ) async {
    if (await controller.understand() &&
        controller.bothUnderstood &&
        context.mounted) {
      await context.router.replace(BridgeNextStepRoute(sessionId: sessionId));
    }
  }

  Future<void> _clarify(
    BuildContext context,
    BridgeSessionController controller,
  ) async {
    final l10n = context.l10n;
    final partnerName = controller.partner?.callName ?? '';
    final text = await showAppTextInputSheet(
      context,
      title: l10n.usBridgeClarifyTitle(partnerName),
      actionLabel: l10n.memoriesSend,
      hint: l10n.usBridgeMessageHint(partnerName),
      initialValue: controller.myShare?.message,
    );
    if (text == null || text.trim().isEmpty) {
      return;
    }
    if (await controller.clarify(text) && context.mounted) {
      showAppSnackBar(context, l10n.usBridgeClarifySent(partnerName));
    }
  }

  Widget _content(BuildContext context, BridgeSessionController controller) {
    final l10n = context.l10n;
    final session = controller.session!;
    final me = controller.me;
    final partner = controller.partner;
    final started = session.startedAt;
    final usDark = AppColors.resolve(context, kColorUs7006A549F);
    final tertiary = AppColors.resolve(context, kColorTextTertiary9C928A);
    Widget column(Member? member, BridgeShare? share, {required bool mine}) {
      final name = member?.callName ?? '';
      return _SessionShareColumn(
        title: mine ? l10n.usBridgeYouName(name) : name,
        avatar: AppInitialAvatar(
          name: name,
          size: 28,
          color: parentAvatarColor(member?.role),
        ),
        feelsLabel: l10n.usBridgeFeels(name),
        needsLabel: l10n.usBridgeNeeds(name),
        feelings: controller.titles(
          controller.feelingOptions,
          share?.feelings ?? const [],
        ),
        needs: controller.titles(
          controller.needOptions,
          share?.needs ?? const [],
        ),
        message: share?.message,
        pillColor: mine ? kColorPrimary50FFF4F1 : kColorSecondary100E4F2EA,
        understood: share?.understood ?? false,
        status: share?.understood ?? false
            ? (mine
                  ? l10n.usBridgeYouUnderstood
                  : l10n.usBridgePartnerUnderstood(name))
            : (mine
                  ? l10n.usBridgeYouPending
                  : l10n.usBridgePartnerPending(name)),
      );
    }

    final items = <Widget>[
      Row(
        children: [
          Container(
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.itemGap),
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorUs100EAE2F8),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.resolve(context, kColorUs5009B85D1),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.compact),
                Text(
                  l10n.usBridgeLive,
                  style: AppTypography.tiny.copyWith(
                    fontWeight: FontWeight.w700,
                    color: usDark,
                  ),
                ),
              ],
            ),
          ),
          if (started != null) ...[
            const SizedBox(width: AppSpacing.s2),
            Flexible(
              child: Text(
                l10n.usBridgeStartedAt(
                  started.toDisplayTime(l10n.localeName),
                  l10n.calendarDayTitle(
                    l10n.careWeekdayTitle(weekdayCode(started.weekday)),
                    started.toDayMonth(l10n.localeName),
                  ),
                ),
                style: AppTypography.small.copyWith(color: tertiary),
              ),
            ),
          ],
        ],
      ),
      Text(
        l10n.usBridgeSessionIntro,
        style: AppTypography.adapt(
          context,
          AppTypography.caption.copyWith(height: 1.4),
        ),
      ),
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: column(me, controller.myShare, mine: true)),
            const SizedBox(width: AppSpacing.itemGap),
            Expanded(
              child: column(partner, controller.partnerShare, mine: false),
            ),
          ],
        ),
      ),
      _SessionTurnCard(
        partnerName: partner?.callName ?? '',
        partnerReadDone: controller.partnerShare?.readDone ?? false,
        understood: controller.myShare?.understood ?? false,
        busy: controller.busy,
        onClarify: () => _clarify(context, controller),
        onUnderstand: () => _understand(context, controller),
        onNext: controller.bothUnderstood
            ? () => context.router.replace(
                BridgeNextStepRoute(sessionId: sessionId),
              )
            : null,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.doorOpen, size: 13, color: tertiary),
          const SizedBox(width: AppSpacing.compact),
          Flexible(
            child: Text(
              l10n.usBridgeLeaveNote,
              textAlign: TextAlign.center,
              style: AppTypography.tiny.copyWith(color: tertiary),
            ),
          ),
        ],
      ),
    ];
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.s1,
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
