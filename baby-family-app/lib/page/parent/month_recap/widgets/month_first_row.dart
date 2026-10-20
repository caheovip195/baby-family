part of '../mobile/month_recap_mobile_view.dart';

/// Một lần đầu trong tháng (`RF90h`): đệm dọc 10, cách 12; ảnh 44 bo 12; tên
/// 14/700 (dòng 1.4) + “17 tháng 12 ngày · 20/09” 12 `text-tertiary`; nhãn
/// “Lần đầu” 11/700 `accent-700` nền `accent-100`. [divider]: kẻ dưới.
class _MonthFirstRow extends StatelessWidget {
  const _MonthFirstRow({
    required this.title,
    required this.meta,
    required this.asset,
    required this.divider,
  });

  final String title;
  final String meta;
  final String? asset;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.itemGap),
      decoration: divider
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.resolve(context, kColorBorderEADFD6),
                ),
              ),
            )
          : null,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.tile),
            child: asset == null
                ? Container(
                    width: 44,
                    height: 44,
                    color: AppColors.resolve(context, kColorAccent100FDF1D6),
                  )
                : Image(
                    image: mediaImageProvider(asset!),
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
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
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  meta,
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
          const SizedBox(width: AppSpacing.s3),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s2,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorAccent100FDF1D6),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              context.l10n.memoriesFirsts,
              style: AppTypography.tiny.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.resolve(context, kColorAccent7009A6A12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
