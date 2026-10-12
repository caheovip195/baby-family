part of '../mobile/family_settings_mobile_view.dart';

/// Ảnh bìa (Pencil `rlg00`): cao 132, bo 16; viên “Đổi ảnh bìa” nền trắng
/// mờ, icon `camera` 14 + chữ 12/600 ở góc dưới trái (cách 12). Chưa có ảnh
/// → [AppFamilyCover].
class _CoverCard extends StatelessWidget {
  const _CoverCard({
    required this.name,
    required this.coverAsset,
    required this.onChange,
  });

  final String name;
  final String? coverAsset;
  final VoidCallback onChange;

  static const _height = 132.0;

  @override
  Widget build(BuildContext context) {
    final asset = coverAsset;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: SizedBox(
        height: _height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (asset == null)
              AppFamilyCover(name: name, height: _height)
            else
              Image.asset(asset, fit: BoxFit.cover),
            Positioned(
              left: AppSpacing.s3,
              bottom: AppSpacing.s4,
              child: Material(
                color: kColorWhiteAlpha80,
                shape: const StadiumBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: onChange,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s3,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.camera,
                          size: 14,
                          color: kColorTextPrimary2E2A27,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          context.l10n.famSettingsChangeCover,
                          style: AppTypography.small.copyWith(
                            fontWeight: FontWeight.w600,
                            color: kColorTextPrimary2E2A27,
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
      ),
    );
  }
}
