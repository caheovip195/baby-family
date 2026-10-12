import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Ô chọn giá trị (ngày/giờ) cùng dáng Pencil Input `Y4I0s8`: nhãn 13/600
/// `text-secondary`, cách 8, ô cao 52 bo 14 nền `surface-variant`, chữ 15;
/// chưa có [value] thì hiện [placeholder] màu `text-tertiary`. [highlighted]
/// = viền `primary-500` 2 (trường đang sửa — CHD-02 “Ngày sinh”).
/// Dùng ở CHD-02, CHD-04.
class AppPickerField extends StatelessWidget {
  const AppPickerField({
    required this.onTap,
    this.label,
    this.value,
    this.placeholder,
    this.icon,
    this.highlighted = false,
    super.key,
  });

  final String? label;
  final String? value;
  final String? placeholder;
  final IconData? icon;
  final bool highlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final field = Material(
      color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: highlighted
            ? BorderSide(
                color: AppColors.resolve(context, kColorPrimary500EE7B67),
                width: 2,
              )
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: AppSpacing.fieldHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value ?? placeholder ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.body.copyWith(
                      color: value == null
                          ? kColorTextTertiary9C928A
                          : kColorTextPrimary2E2A27,
                    ),
                  ),
                ),
              ),
              if (icon != null)
                Icon(
                  icon,
                  size: 20,
                  color: AppColors.resolve(context, kColorTextSecondary6B625B),
                ),
            ],
          ),
        ),
      ),
    );
    if (label == null) {
      return field;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label!,
          style: AppTypography.adapt(
            context,
            AppTypography.caption.copyWith(
              fontWeight: FontWeight.w600,
              height: 16 / 13,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s2),
        field,
      ],
    );
  }
}
