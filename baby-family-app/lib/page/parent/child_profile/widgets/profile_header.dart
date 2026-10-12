part of '../mobile/child_profile_mobile_view.dart';

/// Đầu trang (Pencil `O2ntIM`, cao 262 tính cả thanh trạng thái 62): ảnh bìa 210 + lớp tối trên cùng
/// (`#00000059` → trong suốt, 110); nút back và đổi bìa tròn 40 nền trắng 90%
/// (cách mép 12, dưới thanh trạng thái 4); avatar 96 viền trắng 3 trong vòng
/// màu bé 104 (trái 20, đỉnh 150); nút “Sửa hồ sơ” cao 38 (phải 20, đỉnh 214).
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.child, required this.onEdit});

  final Child child;
  final VoidCallback onEdit;

  /// Kích thước Pencil trừ thanh trạng thái 62 (thay bằng safe area thật).
  static const _coverHeight = 148.0;
  static const _scrimHeight = 48.0;
  static const _height = 200.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final top = MediaQuery.paddingOf(context).top;
    Widget round(
      IconData icon,
      double size,
      String tooltip,
      VoidCallback onTap,
    ) => Material(
      color: kColorWhiteAlpha90,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Tooltip(
          message: tooltip,
          child: SizedBox.square(
            dimension: AppSpacing.s10,
            child: Icon(icon, size: size, color: kColorTextPrimary2E2A27),
          ),
        ),
      ),
    );
    final cover = child.coverAsset ?? child.avatarAsset;
    return SizedBox(
      height: _height + top,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: _coverHeight + top,
            child: cover == null
                ? ColoredBox(color: ChildAvatar.colorOf(child))
                : Image.asset(
                    cover,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        ColoredBox(color: ChildAvatar.colorOf(child)),
                  ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: _scrimHeight + top,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kColorBlackAlpha35, kColorBlackAlpha00],
                ),
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.s3,
            top: top + AppSpacing.s1,
            child: round(
              LucideIcons.chevronLeft,
              22,
              MaterialLocalizations.of(context).backButtonTooltip,
              () => context.router.maybePop(),
            ),
          ),
          Positioned(
            right: AppSpacing.s3,
            top: top + AppSpacing.s1,
            child: round(LucideIcons.image, 18, l10n.childChangeCover, onEdit),
          ),
          Positioned(
            left: AppSpacing.screen,
            top: top + 88,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.s1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ChildAvatar.colorOf(child),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kColorWhite, width: 3),
                ),
                child: ChildAvatar(child: child, size: 90),
              ),
            ),
          ),
          Positioned(
            right: AppSpacing.screen,
            top: top + 152,
            child: Material(
              color: AppColors.resolve(context, kColorSurfaceFFFFFF),
              shape: StadiumBorder(
                side: BorderSide(
                  color: AppColors.resolve(context, kColorBorderEADFD6),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onEdit,
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.cardInset,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.pencil,
                        size: 15,
                        color: AppColors.resolve(
                          context,
                          kColorTextPrimary2E2A27,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.compact),
                      Text(
                        l10n.childEditProfile,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.caption.copyWith(
                            fontWeight: FontWeight.w700,
                            color: kColorTextPrimary2E2A27,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
