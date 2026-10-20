import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/helper/media_image.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Ảnh nhỏ của một ký ức / bản nháp (Pencil MEM-17 “Thumb” 64, MEM-18 60,
/// MEM-19 52–56): ảnh phủ kín bo [radius]; không có ảnh → ô màu theo loại
/// (nhật ký `notebook-pen` / thư `mail` trên `us-50`, giọng nói `mic` trên
/// `secondary-100`, câu nói `quote` trên `accent-100`) với icon 24.
/// [extraCount] > 0 → nhãn “+3” (10/700 trắng trên `#2E2A2799`) góc dưới phải.
class MemoryThumb extends StatelessWidget {
  const MemoryThumb({
    required this.kind,
    this.asset,
    this.size = 64,
    this.radius = AppRadius.tile,
    this.extraCount = 0,
    super.key,
  });

  final MemoryKind kind;
  final String? asset;
  final double size;
  final double radius;
  final int extraCount;

  static (IconData, Color, Color) styleOf(MemoryKind kind) => switch (kind) {
    MemoryKind.diary => (
      LucideIcons.notebookPen,
      kColorUs50F6F2FC,
      kColorUs7006A549F,
    ),
    MemoryKind.letter => (
      LucideIcons.mail,
      kColorUs50F6F2FC,
      kColorUs7006A549F,
    ),
    MemoryKind.voice => (
      LucideIcons.mic,
      kColorSecondary100E4F2EA,
      kColorSecondary7003F7A5C,
    ),
    MemoryKind.quote => (
      LucideIcons.quote,
      kColorAccent100FDF1D6,
      kColorAccent7009A6A12,
    ),
    _ => (LucideIcons.image, kColorPrimary50FFF4F1, kColorPrimary700A2402F),
  };

  @override
  Widget build(BuildContext context) {
    final image = asset;
    Widget child;
    if (image != null) {
      child = Stack(
        fit: StackFit.expand,
        children: [
          Image(image: mediaImageProvider(image), fit: BoxFit.cover),
          if (extraCount > 0)
            Positioned(
              right: AppSpacing.s1,
              bottom: AppSpacing.s1,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.compact,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.resolve(
                    context,
                    kColorSheetScrim2E2A27Alpha60,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  '+$extraCount',
                  style: AppTypography.micro.copyWith(
                    fontWeight: FontWeight.w700,
                    color: kColorWhite,
                  ),
                ),
              ),
            ),
        ],
      );
    } else {
      final (icon, background, foreground) = styleOf(kind);
      child = ColoredBox(
        color: AppColors.resolve(context, background),
        child: Center(
          child: Icon(
            icon,
            size: 24,
            color: AppColors.resolve(context, foreground),
          ),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox.square(dimension: size, child: child),
    );
  }
}
