import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Dòng khoá riêng tư của vùng Papa & Mama (Pencil US-01 “Private”, US-10
/// `TfYft`, US-11 `G4vTnB`, US-14 `hDzoI`): icon `lock` + chữ 600 `us-700`,
/// cách 6. Mặc định icon 13 / chữ 12; US-11 dùng 12 / 11.
class UsPrivateLabel extends StatelessWidget {
  const UsPrivateLabel(
    this.text, {
    this.iconSize = 13,
    this.fontSize = 12,
    super.key,
  });

  final String text;
  final double iconSize;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.resolve(context, kColorUs7006A549F);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(LucideIcons.lock, size: iconSize, color: accent),
        const SizedBox(width: AppSpacing.compact),
        Flexible(
          child: Text(
            text,
            style: AppTypography.small.copyWith(
              fontSize: fontSize,
              height: 1.3,
              fontWeight: FontWeight.w600,
              color: accent,
            ),
          ),
        ),
      ],
    );
  }
}
