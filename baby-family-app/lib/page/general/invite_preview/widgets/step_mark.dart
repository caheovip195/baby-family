part of '../mobile/invite_preview_mobile_view.dart';

/// Dòng bước của INV-04 (Pencil “Steps”): dấu tròn 28 (xong: `secondary-500`
/// + check trắng; đang chờ: `primary-50` viền `primary-500` + đồng hồ cát;
/// sắp tới: viền `border`), tiêu đề 14/600 (sắp tới 14/500 `text-secondary`)
/// và dòng phụ 12 `text-tertiary`.
class _StepMark extends StatelessWidget {
  const _StepMark({required this.title, required this.state, this.subtitle});

  final String title;
  final String? subtitle;

  /// 0 = xong, 1 = đang chờ, 2 = sắp tới.
  final int state;

  @override
  Widget build(BuildContext context) {
    final done = state == 0;
    final waiting = state == 1;
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done
                ? AppColors.resolve(context, kColorSecondary5006FAE8E)
                : waiting
                ? AppColors.resolve(context, kColorPrimary50FFF4F1)
                : null,
            border: done
                ? null
                : Border.all(
                    color: AppColors.resolve(
                      context,
                      waiting ? kColorPrimary500EE7B67 : kColorBorderEADFD6,
                    ),
                  ),
          ),
          child: done
              ? const Icon(LucideIcons.check, size: 14, color: kColorWhite)
              : waiting
              ? Icon(
                  LucideIcons.hourglass,
                  size: 13,
                  color: AppColors.resolve(context, kColorPrimary600C2513F),
                )
              : null,
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
                    fontWeight: state == 2 ? FontWeight.w500 : FontWeight.w600,
                    color: state == 2
                        ? kColorTextSecondary6B625B
                        : kColorTextPrimary2E2A27,
                  ),
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.small.copyWith(
                      color: kColorTextTertiary9C928A,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
