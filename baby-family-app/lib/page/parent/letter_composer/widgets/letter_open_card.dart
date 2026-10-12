part of '../mobile/letter_composer_mobile_view.dart';

/// Thẻ ngày mở (`Jj0rQ`): nền `surface`, viền, bo 16, đệm 10/14, cách 12; ô
/// icon 36 `accent-100` (`cake`/`calendar` 18); “Sinh nhật 18 tuổi” 14/700 +
/// “Haru mở vào 08/04/2043” 12 `text-tertiary`; bộ đếm 88×30 bo tròn
/// `surface-variant` (−, N 14/800, +) khi chọn sinh nhật.
class _LetterOpenCard extends StatelessWidget {
  const _LetterOpenCard({
    required this.birthday,
    required this.title,
    required this.subtitle,
    required this.age,
    required this.onChange,
    this.onTap,
  });

  final bool birthday;
  final String title;
  final String subtitle;
  final int age;
  final ValueChanged<int> onChange;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final secondary = AppColors.resolve(context, kColorTextSecondary6B625B);
    Widget step(IconData icon, int delta, String label) => Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: () => onChange(delta),
        child: SizedBox.square(
          dimension: 30,
          child: Icon(icon, size: 14, color: secondary),
        ),
      ),
    );
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      side: BorderSide(color: AppColors.resolve(context, kColorBorderEADFD6)),
    );
    return Material(
      color: AppColors.resolve(context, kColorSurfaceFFFFFF),
      shape: shape,
      child: InkWell(
        onTap: onTap,
        customBorder: shape,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.cardInset,
            vertical: AppSpacing.itemGap,
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.resolve(context, kColorAccent100FDF1D6),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  birthday ? LucideIcons.cake : LucideIcons.calendar,
                  size: 18,
                  color: AppColors.resolve(context, kColorAccent600B7862B),
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.text14.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.small.copyWith(
                          color: kColorTextTertiary9C928A,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (birthday) ...[
                const SizedBox(width: AppSpacing.s3),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.resolve(
                      context,
                      kColorSurfaceVariantF7F1EC,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      step(LucideIcons.minus, -1, '−'),
                      SizedBox(
                        width: 28,
                        child: Text(
                          '$age',
                          textAlign: TextAlign.center,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.text14.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      step(LucideIcons.plus, 1, '+'),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
