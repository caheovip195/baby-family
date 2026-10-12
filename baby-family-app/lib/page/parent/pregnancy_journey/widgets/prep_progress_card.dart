part of '../mobile/pregnancy_journey_mobile_view.dart';

/// “Đã chuẩn bị 12/30 · còn 109 ngày” (Pencil `KpMV3`): đệm 16, cách 8, nền
/// `secondary-100`, bo 16; thanh cao 10 bo 5 nền `surface`.
class _PrepProgressCard extends StatelessWidget {
  const _PrepProgressCard({
    required this.done,
    required this.total,
    this.daysLeft,
  });

  final int done;
  final int total;
  final int? daysLeft;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSecondary100E4F2EA),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  l10n.pregnancyPrepareProgress(done, total),
                  style: AppTypography.adapt(
                    context,
                    AppTypography.title17.copyWith(
                      color: kColorSecondary7003F7A5C,
                    ),
                  ),
                ),
              ),
              if (daysLeft != null)
                Text(
                  l10n.pregDaysLeft(daysLeft!),
                  style: AppTypography.adapt(
                    context,
                    AppTypography.small.copyWith(
                      color: kColorSecondary7003F7A5C,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.s2),
          AppProgressBar(
            value: total == 0 ? 0 : done / total,
            height: 10,
            trackColor: kColorSurfaceFFFFFF,
          ),
        ],
      ),
    );
  }
}
