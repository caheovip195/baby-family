import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Dialog chuẩn: bo 24, tối đa 2 nút (Design System mục 10.8).
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    this.icon,
    this.actions = const [],
  });

  final String title;
  final String content;
  final Widget? icon;
  final List<Widget> actions;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String content,
    Widget? icon,
    List<Widget>? actions,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: kColorOverlay2E2A27Alpha48,
      builder: (context) => AppDialog(
        title: title,
        content: content,
        icon: icon,
        actions: actions ?? const [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: kColorSurfaceFFFFFF,
      surfaceTintColor: kColorTransparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.dialog),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s6,
          AppSpacing.s8,
          AppSpacing.s6,
          AppSpacing.s6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[icon!, const SizedBox(height: AppSpacing.s4)],
            Text(title, textAlign: TextAlign.center, style: AppTypography.h3),
            const SizedBox(height: AppSpacing.s3),
            Text(
              content,
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(
                color: kColorTextSecondary6B625B,
              ),
            ),
            if (actions.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.s6),
              Row(
                children: [
                  for (int i = 0; i < actions.length; i++) ...[
                    if (i > 0) const SizedBox(width: AppSpacing.s3),
                    Expanded(child: actions[i]),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
