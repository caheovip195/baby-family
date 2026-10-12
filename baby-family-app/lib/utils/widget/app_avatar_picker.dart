import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Ô chọn ảnh đại diện tròn (tuỳ chọn):
/// - AUTH-04 (Pencil `gIM6S`): 104, nền `primary-100`, icon `camera` 32
///   `primary-600`, huy hiệu “+” 32 nền `primary-600` viền 3 `bg`.
/// - ONB-05b (Pencil `I9FHqI`): 64, nền `secondary-100`, viền 3 màu bé, icon 24
///   `secondary-700` — truyền [background], [iconColor], [borderColor], [iconSize].
class AppAvatarPicker extends StatelessWidget {
  const AppAvatarPicker({
    required this.onTap,
    this.asset,
    this.size = 104,
    this.showAddBadge = false,
    this.background = kColorPrimary100FFE3DC,
    this.iconColor = kColorPrimary600C2513F,
    this.borderColor,
    this.iconSize = 32,
    this.semanticLabel,
    super.key,
  });

  final VoidCallback onTap;
  final String? asset;
  final double size;
  final bool showAddBadge;
  final Color background;
  final Color iconColor;

  /// Viền 3 quanh ảnh (màu bé ở ONB-05b); null = không viền.
  final Color? borderColor;
  final double iconSize;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: semanticLabel ?? context.l10n.commonChoosePhoto,
    child: GestureDetector(
      onTap: onTap,
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: size,
              height: size,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.resolve(context, background),
                shape: BoxShape.circle,
                border: borderColor == null
                    ? null
                    : Border.all(color: borderColor!, width: 3),
              ),
              child: asset == null || asset!.isEmpty
                  ? Icon(
                      LucideIcons.camera,
                      color: AppColors.resolve(context, iconColor),
                      size: iconSize,
                    )
                  : Image.asset(asset!, fit: BoxFit.cover),
            ),
            if (showAddBadge)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: AppSpacing.s8,
                  height: AppSpacing.s8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.resolve(context, kColorPrimary600C2513F),
                    border: Border.all(
                      color: AppColors.resolve(context, kColorBgFFFBF7),
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    LucideIcons.plus,
                    size: AppSpacing.s4,
                    color: AppColors.onPrimary(context),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
