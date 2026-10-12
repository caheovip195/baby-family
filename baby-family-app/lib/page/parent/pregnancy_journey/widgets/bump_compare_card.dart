part of '../mobile/pregnancy_journey_mobile_view.dart';

/// “So sánh · Tuần 16 → Tuần 23” (Pencil `XDPvn`): đệm 12, cách 8, nền
/// `us-50`, bo 16; tiêu đề 13/700 `us-700`; 2 ảnh cao 170 bo 12 cách 8.
class _BumpCompareCard extends StatelessWidget {
  const _BumpCompareCard({required this.from, required this.to});

  final BumpPhoto from;
  final BumpPhoto to;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget photo(BumpPhoto item) => Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.tile),
        child: SizedBox(
          height: 170,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (item.asset != null)
                Image.asset(
                  item.asset!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              Positioned(
                left: AppSpacing.compact,
                bottom: AppSpacing.compact,
                child: _PhotoWeekLabel(
                  text: l10n.commonPregnancyWeekOnly(item.week),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s3),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorUs50F6F2FC),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.pregBumpCompare(from.week, to.week),
            style: AppTypography.adapt(
              context,
              AppTypography.caption.copyWith(
                fontWeight: FontWeight.w700,
                color: kColorUs7006A549F,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s2),
          Row(
            children: [
              photo(from),
              const SizedBox(width: AppSpacing.s2),
              photo(to),
            ],
          ),
        ],
      ),
    );
  }
}
