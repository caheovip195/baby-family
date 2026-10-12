import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Tiêu đề bước của luồng đăng nhập/onboarding (Pencil node “Heading”): tiêu
/// đề 26/800 Nunito `text-primary`, cách 8, dòng phụ 15 Be Vietnam Pro
/// (line-height 1.5) `text-secondary`. [center] cho màn căn giữa (ONB-08,
/// ONB-10, ONB-WAIT…); [titleSize] 24 ở ONB-WAIT.
class AppStepHeading extends StatelessWidget {
  const AppStepHeading({
    required this.title,
    this.subtitle,
    this.center = false,
    this.titleSize = 26,
    this.titleHeight,
    this.subtitleSize = 15,
    this.gap = AppSpacing.s2,
    super.key,
  });

  final String title;
  final String? subtitle;
  final bool center;
  final double titleSize;

  /// Line-height của tiêu đề (Pencil 1.3 ở ONB-01/ACT/CIR-WAIT).
  final double? titleHeight;
  final double subtitleSize;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final align = center ? TextAlign.center : TextAlign.start;
    return Column(
      crossAxisAlignment: center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          textAlign: align,
          style: AppTypography.adapt(
            context,
            AppTypography.h1.copyWith(
              fontSize: titleSize,
              height: titleHeight ?? 1.36,
            ),
          ),
        ),
        if (subtitle != null) ...[
          SizedBox(height: gap),
          Text(
            subtitle!,
            textAlign: align,
            style: AppTypography.adapt(
              context,
              AppTypography.body.copyWith(
                fontSize: subtitleSize,
                height: 1.5,
                color: kColorTextSecondary6B625B,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
