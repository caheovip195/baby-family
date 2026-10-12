part of '../mobile/weekly_recap_mobile_view.dart';

/// Dòng điểm nhấn (`h1eut`): cao 64 (đệm dọc 10), cách 12, kẻ dưới (trừ dòng
/// cuối); ảnh 44 bo 12 (câu nói: nền `primary-100` + `quote` 18); tiêu đề
/// 14/700 + meta 12 `text-tertiary`; nhãn “Lần đầu” `accent-100` 11/700.
class _RecapHighlightRow extends StatelessWidget {
  const _RecapHighlightRow({
    required this.title,
    required this.meta,
    required this.asset,
    required this.badge,
    required this.last,
    required this.onTap,
  });

  final String title;
  final String meta;
  final String? asset;
  final String? badge;
  final bool last;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.itemGap),
        decoration: BoxDecoration(
          border: last
              ? null
              : Border(
                  bottom: BorderSide(
                    color: AppColors.resolve(context, kColorBorderEADFD6),
                  ),
                ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.tile),
              child: SizedBox.square(
                dimension: 44,
                child: asset != null
                    ? Image.asset(asset!, fit: BoxFit.cover)
                    : ColoredBox(
                        color: AppColors.resolve(
                          context,
                          kColorPrimary100FFE3DC,
                        ),
                        child: Icon(
                          LucideIcons.quote,
                          size: 18,
                          color: AppColors.resolve(
                            context,
                            kColorPrimary600C2513F,
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.text14.copyWith(
                        fontWeight: FontWeight.w700,
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
            if (badge != null) ...[
              const SizedBox(width: AppSpacing.s3),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s2,
                  vertical: AppSpacing.s1,
                ),
                decoration: BoxDecoration(
                  color: AppColors.resolve(context, kColorAccent100FDF1D6),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  badge!,
                  style: AppTypography.tiny.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.resolve(context, kColorAccent7009A6A12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
