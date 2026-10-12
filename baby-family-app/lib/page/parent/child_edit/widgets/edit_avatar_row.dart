part of '../mobile/child_edit_mobile_view.dart';

/// Hàng ảnh (Pencil `FlFcV`): avatar 84 viền màu bé 3 + huy hiệu camera 28
/// `primary-600` (viền `bg` 2); “Đổi ảnh đại diện” 14/600 `primary-600`, “Đổi
/// ảnh bìa timeline” 13/500 `text-secondary` (icon `image` 14).
class _EditAvatarRow extends StatelessWidget {
  const _EditAvatarRow({required this.child, required this.onTap});

  final Child child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final secondary = AppColors.resolve(context, kColorTextSecondary6B625B);
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          SizedBox.square(
            dimension: 84,
            child: Stack(
              children: [
                ChildAvatar(
                  child: child,
                  size: 78,
                  borderColor: ChildAvatar.colorOf(child),
                  borderWidth: 3,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.resolve(context, kColorPrimary600C2513F),
                      border: Border.all(
                        color: AppColors.resolve(context, kColorBgFFFBF7),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      LucideIcons.camera,
                      size: 14,
                      color: AppColors.onPrimary(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.childChangeAvatar,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.text14.copyWith(
                      fontWeight: FontWeight.w600,
                      color: kColorPrimary600C2513F,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.compact),
                Row(
                  children: [
                    Icon(LucideIcons.image, size: 14, color: secondary),
                    const SizedBox(width: AppSpacing.compact),
                    Flexible(
                      child: Text(
                        l10n.childChangeTimelineCover,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.caption.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
