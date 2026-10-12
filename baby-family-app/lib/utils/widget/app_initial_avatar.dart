import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Initial avatar for parent profiles and authored activities.
class AppInitialAvatar extends StatelessWidget {
  const AppInitialAvatar({
    required this.name,
    this.color = kColorSecondary5006FAE8E,
    this.size = 44,
    this.foreground = kColorWhite,
    super.key,
  });
  final String name;
  final Color color;
  final double size;
  final Color foreground;
  @override
  Widget build(BuildContext context) => Semantics(
    label: name,
    image: true,
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.resolve(context, color),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        name.isEmpty ? '' : name.characters.first,
        style: AppTypography.h3.copyWith(
          fontSize: size * .4,
          fontWeight: FontWeight.w800,
          color: AppColors.resolve(context, foreground),
        ),
      ),
    ),
  );
}
