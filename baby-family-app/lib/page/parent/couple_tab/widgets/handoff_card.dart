part of '../mobile/couple_tab_mobile_view.dart';

/// Thẻ bàn giao ca mới nhất (7.13.8): ai bàn giao lúc nào, các mốc ăn / ngủ /
/// dậy, ghi chú, bé; người nhận bấm “Đã nhận”, người gửi thấy trạng thái.
class _HandoffCard extends StatelessWidget {
  const _HandoffCard({
    required this.handoff,
    required this.controller,
    required this.partnerName,
  });

  final CareHandoff handoff;
  final CoupleTabController controller;
  final String partnerName;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = l10n.localeName;
    String time(DateTime value) => value.toLocal().toDisplayTime(locale);
    final secondary = AppColors.resolve(context, kColorTextSecondary6B625B);
    final names = [
      for (final id in handoff.childIds) ?controller.childById(id)?.name,
    ];
    final created = handoff.createdAt ?? controller.now;
    final lines = [
      if (handoff.fedAt case final at?) l10n.usHandoffFedAt(time(at)),
      if (handoff.sleptAt case final at?) l10n.usHandoffSleptAt(time(at)),
      if (handoff.wokeAt case final at?) l10n.usHandoffWokeAt(time(at)),
    ];
    final status = handoff.pending
        ? l10n.usHandoffPending
        : handoff.acknowledgedAt != null
        ? (handoff.received
              ? l10n.usHandoffAckedByMe
              : l10n.usHandoffAcked(partnerName))
        : handoff.received
        ? null
        : l10n.usHandoffWaiting(partnerName);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardInset),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorUs50F6F2FC),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.arrowRightLeft,
                size: 18,
                color: AppColors.resolve(context, kColorUs7006A549F),
              ),
              const SizedBox(width: AppSpacing.s2),
              Expanded(
                child: Text(
                  handoff.received
                      ? l10n.usHandoffFrom(partnerName, time(created))
                      : l10n.usHandoffMine(time(created)),
                  style: AppTypography.adapt(context, AppTypography.bodyStrong),
                ),
              ),
            ],
          ),
          if (names.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s1),
            Text(
              names.join(', '),
              style: AppTypography.adapt(
                context,
                AppTypography.small.copyWith(color: secondary),
              ),
            ),
          ],
          for (final line in lines) ...[
            const SizedBox(height: AppSpacing.s1),
            Text(line, style: AppTypography.adapt(context, AppTypography.body)),
          ],
          if (handoff.note case final note?) ...[
            const SizedBox(height: AppSpacing.s2),
            Text(
              note,
              style: AppTypography.adapt(
                context,
                AppTypography.body.copyWith(color: secondary),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.s3),
          if (handoff.received &&
              handoff.acknowledgedAt == null &&
              !handoff.pending)
            Align(
              alignment: Alignment.centerLeft,
              child: AppPillButton(
                label: l10n.usHandoffAck,
                onPressed: () async {
                  try {
                    await controller.acknowledgeHandoff(handoff.id);
                  } on Object catch (error) {
                    if (context.mounted) {
                      showAppSnackBar(context, actionErrorMessage(error));
                    }
                  }
                },
                height: 32,
                fontSize: 13,
                horizontalPadding: AppSpacing.s4,
                color: kColorUs7006A549F,
                foreground: kColorWhite,
              ),
            )
          else if (status != null)
            Text(
              status,
              style: AppTypography.adapt(
                context,
                AppTypography.small.copyWith(color: secondary),
              ),
            ),
        ],
      ),
    );
  }
}
