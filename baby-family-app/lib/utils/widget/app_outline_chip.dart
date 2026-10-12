import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Chip viền (Pencil CAL-02 “Loại sự kiện”/“Nhắc”, CHD-02 “Ai đặt”, CHD-04
/// “Giới tính”, CARE-08 bộ lọc): cao [height] (36), bo tròn.
/// - Thường: nền `surface`, viền `border` 1, chữ 13/500 `text-primary`.
/// - Đã chọn: nền `primary-50`, viền `primary-500` [selectedStrokeWidth], chữ
///   13/700 `primary-700`.
/// [leading] (chấm màu, avatar 30–32, icon check) và [trailing] tuỳ chọn;
/// [fontSize]/[selectedWeight] cho chip có avatar (14/600).
class AppOutlineChip extends StatelessWidget {
  const AppOutlineChip({
    required this.label,
    required this.onTap,
    this.selected = false,
    this.leading,
    this.trailing,
    this.height = AppSpacing.chipHeight,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
    this.gap = AppSpacing.compact,
    this.selectedStrokeWidth = 1.5,
    this.fontSize = 13,
    this.selectedWeight = FontWeight.w700,
    this.selectedTextColor = kColorPrimary700A2402F,
    this.background,
    super.key,
  });

  final String label;
  final VoidCallback? onTap;
  final bool selected;
  final Widget? leading;
  final Widget? trailing;
  final double height;
  final EdgeInsetsGeometry padding;
  final double gap;
  final double selectedStrokeWidth;
  final double fontSize;
  final FontWeight selectedWeight;
  final Color selectedTextColor;

  /// Nền khi chưa chọn (mặc định `surface` + viền; truyền `surface-variant`
  /// để bỏ viền như chip thai kỳ CAL-02).
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final plain = background != null && !selected;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: AppColors.resolve(
          context,
          selected ? kColorPrimary50FFF4F1 : background ?? kColorSurfaceFFFFFF,
        ),
        shape: StadiumBorder(
          side: plain
              ? BorderSide.none
              : BorderSide(
                  color: AppColors.resolve(
                    context,
                    selected ? kColorPrimary500EE7B67 : kColorBorderEADFD6,
                  ),
                  width: selected ? selectedStrokeWidth : 1,
                ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: height),
            child: Padding(
              padding: padding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leading != null) ...[leading!, SizedBox(width: gap)],
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.text14.copyWith(
                          fontSize: fontSize,
                          height: 16 / 13,
                          fontWeight: selected
                              ? selectedWeight
                              : FontWeight.w500,
                          color: selected
                              ? selectedTextColor
                              : kColorTextPrimary2E2A27,
                        ),
                      ),
                    ),
                  ),
                  if (trailing != null) ...[SizedBox(width: gap), trailing!],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
