part of '../mobile/couple_week_mobile_view.dart';

/// “Hai ta đã cùng nhau” (`DIjxl`): nền `surface` bo 16, đệm 14, cách 10;
/// mỗi dòng `circle-check` 18 `us-700` + tiêu đề 13 (dòng 1.4) + ngày 11.
class _WeekTogetherCard extends StatelessWidget {
  const _WeekTogetherCard({required this.rows});

  /// (tiêu đề, “Thứ Ba, 29/09”).
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final usDark = AppColors.resolve(context, kColorUs7006A549F);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardInset),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.usCoupleWeekTogetherLabel,
            style: AppTypography.adapt(
              context,
              AppTypography.caption.copyWith(
                fontWeight: FontWeight.w700,
                color: kColorTextPrimary2E2A27,
              ),
            ),
          ),
          for (final (title, date) in rows) ...[
            const SizedBox(height: AppSpacing.itemGap),
            Row(
              children: [
                Icon(LucideIcons.circleCheck, size: 18, color: usDark),
                const SizedBox(width: AppSpacing.itemGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.caption.copyWith(
                            height: 1.4,
                            color: kColorTextPrimary2E2A27,
                          ),
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        date,
                        style: AppTypography.adapt(context, AppTypography.tiny),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
