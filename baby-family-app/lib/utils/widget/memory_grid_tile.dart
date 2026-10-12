import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Ô vuông của lưới ký ức (MEM-02 “Ảnh”, chi tiết bộ sưu tập): ảnh phủ kín,
/// bo [radius]; ký ức không có ảnh → nền [color] + icon 24 + [label] 2 dòng.
/// [badgeIcon] (video, nhiều ảnh) hiển thị góc phải trên.
class MemoryGridTile extends StatelessWidget {
  const MemoryGridTile({
    this.asset,
    this.icon,
    this.label,
    this.color = kColorSurfaceVariantF7F1EC,
    this.badgeIcon,
    this.radius = AppRadius.xs,
    this.onTap,
    super.key,
  });

  final String? asset;
  final IconData? icon;
  final String? label;
  final Color color;
  final IconData? badgeIcon;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final photo = asset;
    return Semantics(
      button: onTap != null,
      label: label,
      child: Material(
        color: AppColors.resolve(context, color),
        borderRadius: BorderRadius.circular(radius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (photo != null)
                Image.asset(
                  photo,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                )
              else
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.s2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null)
                        Icon(
                          icon,
                          size: 24,
                          color: AppColors.resolve(
                            context,
                            kColorTextPrimary2E2A27,
                          ),
                        ),
                      if (label != null) ...[
                        const SizedBox(height: AppSpacing.s1),
                        Text(
                          label!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.micro.copyWith(
                              fontWeight: FontWeight.w600,
                              color: kColorTextPrimary2E2A27,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              if (badgeIcon != null)
                Positioned(
                  top: AppSpacing.s1,
                  right: AppSpacing.s1,
                  child: Icon(badgeIcon, size: 16, color: kColorWhite),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
