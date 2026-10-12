import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/us/couple_request.dart';
import 'package:baby_family/page/parent/request_detail/request_detail_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/relative_time.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_initial_avatar.dart';
import 'package:baby_family/utils/widget/app_selectable_chip.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/request_card.dart';
part '../widgets/request_info_chip.dart';
part '../widgets/request_timeline.dart';

/// US-04 — Chi tiết lời nhờ: người nhận chờ trả lời (Pencil `jDPm9`), đã nhận
/// (`uFjwu`), người gửi (mục 9.8 — trạng thái, Huỷ, Cảm ơn khi xong).
class RequestDetailMobileView extends HookConsumerWidget {
  const RequestDetailMobileView({required this.requestId, super.key});

  final String requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(requestDetailControllerProvider(requestId));
    final request = controller.request;
    Widget body;
    if (!controller.loaded) {
      body = const SizedBox.shrink();
    } else if (request == null) {
      body = ErrorState(onRetry: controller.load);
    } else {
      body = CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: SafeArea(
              top: false,
              minimum: const EdgeInsets.only(bottom: AppSpacing.s6),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screen,
                ),
                child: _content(context, controller, request),
              ),
            ),
          ),
        ],
      );
    }
    return BaseScaffold(
      backgroundColor: kColorUs50F6F2FC,
      appBar: const AppTopBar(backgroundColor: kColorUs50F6F2FC),
      body: body,
    );
  }

  Widget _content(
    BuildContext context,
    RequestDetailController controller,
    CoupleRequest request,
  ) {
    final l10n = context.l10n;
    final status = request.status;
    final pending =
        status == RequestStatus.sent || status == RequestStatus.seen;
    final senderName = controller.sender?.callName ?? '';
    final String title;
    if (controller.isSender) {
      title = l10n.usRequestMineTitle;
    } else if (pending || status == RequestStatus.declined) {
      title = l10n.usRequestFrom(senderName);
    } else {
      title = l10n.usRequestAcceptedTitle;
    }
    final children = <Widget>[
      Text(title, style: AppTypography.adapt(context, AppTypography.h1)),
      _RequestCard(controller: controller, request: request),
      if (!controller.isSender && pending) ...[
        if (request.kind == RequestKind.task) _heartsHint(context),
        const Spacer(),
        ..._receiverPending(context, controller, request),
      ] else ...[
        _RequestTimeline(controller: controller, request: request),
        const Spacer(),
        ..._footer(context, controller, request),
      ],
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < children.length; index++) ...[
          if (index > 0 && children[index] is! Spacer)
            const SizedBox(height: AppSpacing.cardInset),
          children[index],
        ],
      ],
    );
  }

  Widget _heartsHint(BuildContext context) => Row(
    children: [
      Icon(
        LucideIcons.heart,
        size: 14,
        color: AppColors.resolve(context, kColorPrimary500EE7B67),
      ),
      const SizedBox(width: AppSpacing.s2),
      Expanded(
        child: Text(
          context.l10n.usRequestHearts(kValueRequestDoneHearts),
          style: AppTypography.adapt(context, AppTypography.small),
        ),
      ),
    ],
  );

  /// Người nhận, chưa trả lời: lý do nhanh + Nhận / Hôm nay không được.
  /// Lời nhờ NEED: Gửi 🤗 / Đã thấy.
  List<Widget> _receiverPending(
    BuildContext context,
    RequestDetailController controller,
    CoupleRequest request,
  ) {
    final l10n = context.l10n;
    final senderName = controller.sender?.callName ?? '';
    final router = context.router;
    if (request.kind == RequestKind.need) {
      return [
        AppButton.us(
          label: l10n.usRequestSendHug,
          isLoading: controller.isLoading,
          onPressed: () async {
            await controller.acknowledge();
            await router.maybePop();
          },
        ),
        AppButton.secondary(
          label: l10n.usSeen,
          color: kColorUs7006A549F,
          borderColor: kColorUs5009B85D1,
          onPressed: () async {
            await controller.acknowledge();
            await router.maybePop();
          },
        ),
      ];
    }
    final other = controller.otherChild;
    final reasons = [
      l10n.usRequestReasonMeeting,
      l10n.usRequestReasonLate,
      if (other != null) l10n.usRequestReasonBusyWith(other.name),
    ];
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.usRequestReasonHint,
            style: AppTypography.adapt(context, AppTypography.small),
          ),
          const SizedBox(height: AppSpacing.s2),
          Wrap(
            spacing: AppSpacing.s2,
            runSpacing: AppSpacing.s2,
            children: [
              for (final reason in reasons)
                AppSelectableChip(
                  label: reason,
                  selected: controller.reason == reason,
                  filledSelection: false,
                  outlined: true,
                  height: 32,
                  fontSize: 12,
                  padding: AppSpacing.itemGap,
                  onPressed: () => controller.selectReason(reason),
                ),
            ],
          ),
        ],
      ),
      AppButton.us(
        label: l10n.usRequestAccept,
        isLoading: controller.isLoading,
        onPressed: controller.accept,
      ),
      AppButton.secondary(
        label: l10n.usRequestDecline,
        color: kColorUs7006A549F,
        borderColor: kColorUs5009B85D1,
        onPressed: () async {
          await controller.decline();
          await router.maybePop();
        },
      ),
      Text(
        l10n.usRequestDeclineNote(senderName),
        textAlign: TextAlign.center,
        style: AppTypography.adapt(
          context,
          AppTypography.small.copyWith(color: kColorTextTertiary9C928A),
        ),
      ),
    ];
  }

  /// Sau khi trả lời: người nhận — Nhắc mình + Đã xong; người gửi — Huỷ /
  /// Gửi lời cảm ơn / Tự mình làm.
  List<Widget> _footer(
    BuildContext context,
    RequestDetailController controller,
    CoupleRequest request,
  ) {
    final l10n = context.l10n;
    final router = context.router;
    final status = request.status;
    if (!controller.isSender) {
      if (status != RequestStatus.accepted) {
        return const [];
      }
      final accent = AppColors.resolve(context, kColorUs7006A549F);
      return [
        Center(
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            onTap: () => _pickReminder(context, controller),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.bell, size: 16, color: accent),
                  const SizedBox(width: AppSpacing.compact),
                  Flexible(
                    child: Text(
                      l10n.usRequestReminder(
                        controller.reminderAt.toDisplayTime(context.localeName),
                      ),
                      style: AppTypography.text14.copyWith(
                        fontWeight: FontWeight.w600,
                        color: accent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AppButton.us(
          label: l10n.usRequestFinish,
          isLoading: controller.isLoading,
          onPressed: () async {
            await controller.markDone();
            await router.replace(ThanksComposeRoute());
          },
        ),
      ];
    }
    return switch (status) {
      RequestStatus.sent || RequestStatus.seen || RequestStatus.accepted => [
        AppButton.secondary(
          label: l10n.usRequestCancel,
          color: kColorUs7006A549F,
          borderColor: kColorUs5009B85D1,
          isLoading: controller.isLoading,
          onPressed: () async {
            await controller.cancel();
            await router.maybePop();
          },
        ),
      ],
      RequestStatus.done || RequestStatus.acknowledged => [
        AppButton.us(
          label: l10n.usRequestThank,
          onPressed: () => router.replace(ThanksComposeRoute()),
        ),
      ],
      RequestStatus.declined => [
        AppButton.us(
          label: l10n.usRequestDoMyself,
          isLoading: controller.isLoading,
          onPressed: () async {
            await controller.cancel();
            await router.maybePop();
          },
        ),
      ],
      _ => const [],
    };
  }

  Future<void> _pickReminder(
    BuildContext context,
    RequestDetailController controller,
  ) async {
    final current = controller.reminderAt;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );
    if (picked == null) {
      return;
    }
    await controller.setReminder(
      DateTime(
        current.year,
        current.month,
        current.day,
        picked.hour,
        picked.minute,
      ),
    );
  }
}
