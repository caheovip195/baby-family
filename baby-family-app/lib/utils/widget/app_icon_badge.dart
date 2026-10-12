import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Small semantic icon surface shared by settings, family and notifications.
class AppIconBadge extends StatelessWidget {
  const AppIconBadge({
    required this.icon,
    this.size = 40,
    this.iconSize = 20,
    this.radius = AppRadius.sm,
    this.color = kColorSurfaceVariantF7F1EC,
    this.foreground = kColorTextSecondary6B625B,
    super.key,
  });
  final IconData icon;
  final double size;
  final double iconSize;
  final double radius;
  final Color color;
  final Color foreground;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: AppColors.resolve(context, color),
      borderRadius: BorderRadius.circular(radius),
    ),
    alignment: Alignment.center,
    child: Icon(
      icon,
      size: iconSize,
      color: AppColors.resolve(context, foreground),
    ),
  );
}
