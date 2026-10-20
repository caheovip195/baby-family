part of '../mobile/profile_settings_mobile_view.dart';

/// Ảnh đại diện (Pencil `C7xdWm`): avatar chữ 88 (Mama `primary-500`, Papa
/// `secondary-500`) + nút máy ảnh 32 viền `border` ở góc dưới phải, dưới là
/// “Đổi ảnh đại diện” 13/600 `primary-600`.
class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({
    required this.callName,
    required this.isMother,
    required this.onChange,
    this.asset,
  });

  final String callName;

  /// Ảnh đại diện (URL server / file vừa chọn); null = avatar chữ.
  final String? asset;
  final bool isMother;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s1),
      child: Column(
        children: [
          InkWell(
            onTap: onChange,
            customBorder: const CircleBorder(),
            child: SizedBox.square(
              dimension: 92,
              child: Stack(
                children: [
                  if (asset case final source?)
                    ClipOval(
                      child: Image(
                        image: mediaImageProvider(source),
                        width: 88,
                        height: 88,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    AppInitialAvatar(
                      name: callName,
                      size: 88,
                      color: isMother
                          ? kColorPrimary500EE7B67
                          : kColorSecondary5006FAE8E,
                    ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.resolve(context, kColorBorderEADFD6),
                        ),
                      ),
                      child: Icon(
                        LucideIcons.camera,
                        size: 16,
                        color: AppColors.resolve(
                          context,
                          kColorTextSecondary6B625B,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s2),
          InkWell(
            onTap: onChange,
            child: Text(
              context.l10n.setProfileChangeAvatar,
              style: AppTypography.adapt(
                context,
                AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: kColorPrimary600C2513F,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
