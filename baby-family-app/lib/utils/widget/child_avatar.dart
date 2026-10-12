import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Avatar bé dùng chung (HOME, MEM, CARE, FAM, SW-01, CIR):
/// - ảnh (`avatarAsset`) hoặc chữ cái đầu trên nền màu bé (`kChildPalette`),
/// - thai kỳ: nền `us-100` + icon `sprout` `us-700`,
/// - [child] = null: “Cả nhà” — nền `primary-100` + icon `house` `primary-600`.
///
/// [ringColor]/[ringWidth]: viền ngoài (story ring dùng màu bé). [borderColor]:
/// viền trong sát ảnh (Pencil: `surface` 2px trên thẻ nhiệm vụ, SW-01).
class ChildAvatar extends StatelessWidget {
  const ChildAvatar({
    this.child,
    this.size = 44,
    this.borderColor,
    this.borderWidth = 2,
    this.iconSize,
    super.key,
  });

  final Child? child;
  final double size;
  final Color? borderColor;
  final double borderWidth;

  /// Mặc định ≈ 45% [size] (Pencil: 20 trên 44, 16 trên 32).
  final double? iconSize;

  /// Màu nhận diện của bé (luôn kèm tên/avatar — Skill 8).
  static Color colorOf(Child child) =>
      kChildPalette[child.colorIndex % kChildPalette.length];

  @override
  Widget build(BuildContext context) {
    final value = child;
    final glyph = iconSize ?? (size * 0.45).roundToDouble();
    Widget content;
    Color background;
    if (value == null) {
      background = kColorPrimary100FFE3DC;
      content = Icon(
        LucideIcons.house,
        size: glyph,
        color: AppColors.resolve(context, kColorPrimary600C2513F),
      );
    } else if (value.isPregnancy) {
      background = kColorUs100EAE2F8;
      content = Icon(
        LucideIcons.sprout,
        size: glyph,
        color: AppColors.resolve(context, kColorUs7006A549F),
      );
    } else {
      background = colorOf(value);
      final initial = value.name.isEmpty ? '' : value.name.characters.first;
      content = value.avatarAsset == null
          ? Text(
              initial,
              style: AppTypography.h3.copyWith(
                fontSize: size * 0.34,
                height: 1,
                fontWeight: FontWeight.w800,
                color: kColorTextPrimary2E2A27,
              ),
            )
          : Image.asset(
              value.avatarAsset!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            );
    }
    return Semantics(
      label: value?.name,
      image: true,
      child: Container(
        width: size,
        height: size,
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: value == null || value.isPregnancy
              ? AppColors.resolve(context, background)
              : background,
          border: borderColor == null
              ? null
              : Border.all(
                  color: AppColors.resolve(context, borderColor!),
                  width: borderWidth,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
        ),
        child: content,
      ),
    );
  }
}
