part of '../mobile/pregnancy_archive_mobile_view.dart';

/// Lựa chọn lưu trữ (Pencil `htsvr`/`DZeXX`): đệm 16, cách 12, `surface`, bo
/// 16 — chưa chọn viền 1 `border` + radio viền 2 `border`; đã chọn viền 2
/// `text-secondary` + radio viền 2 `text-primary` chấm 11.
class _ArchiveOptionCard extends StatelessWidget {
  const _ArchiveOptionCard({
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.resolve(context, kColorTextPrimary2E2A27);
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(
            color: AppColors.resolve(
              context,
              selected ? kColorTextSecondary6B625B : kColorBorderEADFD6,
            ),
            width: selected ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s4),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.bodyStrong.copyWith(
                            fontWeight: FontWeight.w700,
                            height: 19 / 15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        description,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.small.copyWith(height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.s3),
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected
                          ? primary
                          : AppColors.resolve(context, kColorBorderEADFD6),
                      width: 2,
                    ),
                  ),
                  child: selected
                      ? Container(
                          width: 11,
                          height: 11,
                          decoration: BoxDecoration(
                            color: primary,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
