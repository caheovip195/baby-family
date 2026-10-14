part of '../mobile/day_story_mobile_view.dart';

/// Thẻ đoạn văn (`ZUKme`): `surface` viền bo 16, đệm 14, cách 10; nhãn “✨
/// Gợi ý bởi AI” (cao 26, `primary-50`, `sparkles` 13 + 11/700
/// `primary-700`), “Viết lại” 12/700 `primary-600` · “Tự viết” 12/700
/// `text-secondary`; đoạn văn 14 (dòng 1.55); “Báo cáo nội dung AI” 11.
class _DayStoryCard extends StatelessWidget {
  const _DayStoryCard({
    required this.body,
    required this.aiGenerated,
    required this.manual,
    required this.onRewrite,
    required this.onManual,
    required this.onChanged,
    required this.onReport,
  });

  final String body;
  final bool aiGenerated;
  final bool manual;
  final VoidCallback onRewrite;
  final VoidCallback onManual;
  final ValueChanged<String> onChanged;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tertiary = AppColors.resolve(context, kColorTextTertiary9C928A);
    final bodyStyle = AppTypography.adapt(
      context,
      AppTypography.text14.copyWith(height: 1.55),
    );
    Widget link(String label, Color color, VoidCallback onTap) => InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.xs),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s1),
        child: Text(
          label,
          style: AppTypography.small.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.resolve(context, color),
          ),
        ),
      ),
    );
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardInset),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.resolve(context, kColorBorderEADFD6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (aiGenerated && !manual)
                Container(
                  height: 26,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.itemGap,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.resolve(context, kColorPrimary50FFF4F1),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.sparkles,
                        size: 13,
                        color: AppColors.resolve(
                          context,
                          kColorPrimary600C2513F,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.compact),
                      Text(
                        l10n.commonAiSuggested,
                        style: AppTypography.tiny.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.resolve(
                            context,
                            kColorPrimary700A2402F,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              link(l10n.recapDayRewrite, kColorPrimary600C2513F, onRewrite),
              const SizedBox(width: AppSpacing.s3),
              link(l10n.recapDayManual, kColorTextSecondary6B625B, onManual),
            ],
          ),
          const SizedBox(height: AppSpacing.itemGap),
          if (manual)
            TextFormField(
              key: const ValueKey('day-story-body'),
              initialValue: body,
              autofocus: true,
              maxLines: null,
              onChanged: onChanged,
              style: bodyStyle,
              decoration: const InputDecoration.collapsed(hintText: null),
            )
          else
            Text(body, style: bodyStyle),
          if (aiGenerated && !manual) ...[
            const SizedBox(height: AppSpacing.itemGap),
            InkWell(
              onTap: onReport,
              borderRadius: BorderRadius.circular(AppRadius.xs),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.flag, size: 12, color: tertiary),
                  const SizedBox(width: AppSpacing.s1),
                  Text(
                    l10n.commonAiReport,
                    style: AppTypography.tiny.copyWith(color: tertiary),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
