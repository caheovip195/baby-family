part of '../mobile/memories_tab_mobile_view.dart';

/// Thẻ kỷ vật / thư / nhật ký (`l13M16` “Keepsake Card”): nền `surface`,
/// viền, bo 16, đệm 12, cách 12; ảnh 84 bo 14 (không ảnh → ô icon);
/// nhãn 10/800 `us-700` viết hoa + icon 12, tiêu đề 15/700, phụ 12 (1.4).
class _TaggedMemoryCard extends StatelessWidget {
  const _TaggedMemoryCard({
    required this.icon,
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.photo,
  });

  final IconData icon;
  final String tag;
  final String title;
  final String subtitle;
  final String? photo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.resolve(context, kColorUs7006A549F);
    return Material(
      color: AppColors.resolve(context, kColorSurfaceFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: AppColors.resolve(context, kColorBorderEADFD6)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s3),
          child: Row(
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: AppColors.resolve(context, kColorUs50F6F2FC),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                clipBehavior: Clip.antiAlias,
                child: photo == null
                    ? Icon(icon, size: 28, color: accent)
                    : Image(
                        image: mediaImageProvider(photo!),
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(icon, size: 12, color: accent),
                        const SizedBox(width: AppSpacing.s1),
                        Flexible(
                          child: Text(
                            tag.toUpperCase(),
                            style: AppTypography.micro.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              color: accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s1),
                    Text(
                      title,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.body.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 19 / 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s1),
                    Text(
                      subtitle,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.small.copyWith(height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
