import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Ảnh bìa gia đình mặc định (Pencil ONB-06 “Cover Preview”, INV-01 “Cover”):
/// nền chuyển `primary-100` → `accent-100` (xoay 200°), đệm 16, tên gia đình
/// 24/800 Nunito `primary-700` sát đáy, dòng phụ 13 `text-secondary` (cách 4);
/// nút đổi ảnh 40 tròn nền trắng 80% (icon `image-plus` 20) ở góc trên phải.
/// [roundBottom] = false khi nằm trên đầu một thẻ (INV-01).
class AppFamilyCover extends StatelessWidget {
  const AppFamilyCover({
    required this.name,
    this.height = 168,
    this.subtitle,
    this.onEdit,
    this.editLabel,
    this.roundBottom = true,
    super.key,
  });

  final String name;
  final double height;
  final String? subtitle;
  final VoidCallback? onEdit;

  /// Nhãn trợ năng của nút đổi ảnh bìa.
  final String? editLabel;
  final bool roundBottom;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: roundBottom
          ? BorderRadius.circular(AppRadius.xl)
          : const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      gradient: LinearGradient(
        begin: const Alignment(-0.36, -1),
        end: const Alignment(0.36, 1),
        colors: [
          AppColors.resolve(context, kColorPrimary100FFE3DC),
          AppColors.resolve(context, kColorAccent100FDF1D6),
        ],
      ),
    ),
    child: Stack(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.s4,
            onEdit == null ? AppSpacing.s4 : AppSpacing.s10 + AppSpacing.s3,
            AppSpacing.s4,
            AppSpacing.s4,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  height -
                  AppSpacing.s4 -
                  (onEdit == null
                      ? AppSpacing.s4
                      : AppSpacing.s10 + AppSpacing.s3),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.h1.copyWith(
                      fontSize: 24,
                      height: 33 / 24,
                      color: kColorPrimary700A2402F,
                    ),
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.s1),
                  Text(
                    subtitle!,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.caption.copyWith(height: 16 / 13),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (onEdit != null)
          Positioned(
            top: AppSpacing.s3,
            right: AppSpacing.s3,
            child: Semantics(
              button: true,
              label: editLabel,
              child: Material(
                color: kColorWhiteAlpha80,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: onEdit,
                  child: const SizedBox.square(
                    dimension: AppSpacing.s10,
                    child: Icon(
                      LucideIcons.imagePlus,
                      size: 20,
                      color: kColorTextPrimary2E2A27,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
