part of '../mobile/request_compose_mobile_view.dart';

/// Thẻ “Nhờ một việc” (Pencil `Vg5gd`): nền `surface` bo 16, đệm 12/8, ô icon
/// 36 `us-100` bo 12 + icon 18 `us-700`, tên 13/700, mô tả 10. Đang chọn viền
/// 2 `us-500`, còn lại viền 1 `us-100`.
class _RequestTaskCard extends StatelessWidget {
  const _RequestTaskCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
              selected ? kColorUs5009B85D1 : kColorUs100EAE2F8,
            ),
            width: selected ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.s3,
              horizontal: AppSpacing.s2,
            ),
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.resolve(context, kColorUs100EAE2F8),
                    borderRadius: BorderRadius.circular(AppRadius.tile),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: AppColors.resolve(context, kColorUs7006A549F),
                  ),
                ),
                const SizedBox(height: AppSpacing.compact),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: kColorTextPrimary2E2A27,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.compact),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    description,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: AppTypography.adapt(context, AppTypography.micro),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
