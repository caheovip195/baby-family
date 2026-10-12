part of '../mobile/request_detail_mobile_view.dart';

/// Dòng thời gian lời nhờ (Pencil `gu3Lt`): nền `surface` bo 16 đệm 14; mỗi
/// bước chấm 22 (xong: nền `us-700` + check 12; chưa: viền 2 `border`), chữ
/// 14/600 (chưa: 14/500 `text-tertiary`), giờ 12 `text-tertiary`.
class _RequestTimeline extends StatelessWidget {
  const _RequestTimeline({required this.controller, required this.request});

  final RequestDetailController controller;
  final CoupleRequest request;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final partnerName = controller.partner?.callName ?? '';
    final senderName = controller.sender?.callName ?? '';
    final mine = controller.isSender;
    final declined = request.status == RequestStatus.declined;
    final steps = <(String, DateTime?)>[
      (
        mine ? l10n.usRequestYouSent : l10n.usRequestSent(senderName),
        request.sentAt,
      ),
      (
        mine ? l10n.usRequestPartnerViewed(partnerName) : l10n.usRequestViewed,
        request.seenAt,
      ),
      if (declined)
        (l10n.usRequestDecline, request.declinedAt)
      else ...[
        (
          mine
              ? l10n.usRequestPartnerAccepted(partnerName)
              : l10n.usRequestAcceptedShort,
          request.acceptedAt,
        ),
        (l10n.usRequestFinished, request.doneAt),
      ],
    ];
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardInset),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          for (var index = 0; index < steps.length; index++) ...[
            if (index > 0) const SizedBox(height: AppSpacing.itemGap),
            _step(context, steps[index].$1, steps[index].$2),
          ],
        ],
      ),
    );
  }

  Widget _step(BuildContext context, String label, DateTime? at) {
    final done = at != null;
    final tertiary = AppColors.resolve(context, kColorTextTertiary9C928A);
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done ? AppColors.resolve(context, kColorUs7006A549F) : null,
            border: done
                ? null
                : Border.all(
                    color: AppColors.resolve(context, kColorBorderEADFD6),
                    width: 2,
                  ),
          ),
          child: done
              ? Icon(
                  LucideIcons.check,
                  size: 12,
                  color: AppColors.onPrimary(context),
                )
              : null,
        ),
        const SizedBox(width: AppSpacing.itemGap),
        Expanded(
          child: Text(
            label,
            style: done
                ? AppTypography.adapt(
                    context,
                    AppTypography.text14.copyWith(fontWeight: FontWeight.w600),
                  )
                : AppTypography.text14.copyWith(
                    fontWeight: FontWeight.w500,
                    color: tertiary,
                  ),
          ),
        ),
        const SizedBox(width: AppSpacing.itemGap),
        Text(
          done ? at.toDisplayTime(context.localeName) : '—',
          style: AppTypography.small.copyWith(color: tertiary),
        ),
      ],
    );
  }
}
