import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Ô nhập theo Pencil Input `Y4I0s8`: nhãn 13/600 `text-secondary`, cách 8,
/// ô cao 52, bo 14, nền `surface-variant`, đệm ngang 16, chữ 15
/// (placeholder `text-tertiary`). Dùng ở AUTH-02/04, ONB-05/06, CARE-03…
class AppTextField extends StatelessWidget {
  const AppTextField({
    this.label,
    this.hint,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.prefix,
    this.suffix,
    this.errorText,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
    this.textAlign = TextAlign.start,
    super.key,
  });

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  /// Phần đầu ô (mã quốc gia, icon).
  final Widget? prefix;
  final Widget? suffix;
  final String? errorText;
  final int maxLines;
  final int? maxLength;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: color == kColorTransparent
              ? BorderSide.none
              : BorderSide(
                  color: AppColors.resolve(context, color),
                  width: width,
                ),
        );
    final field = TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      minLines: 1,
      maxLength: maxLength,
      enabled: enabled,
      autofocus: autofocus,
      focusNode: focusNode,
      textAlign: textAlign,
      style: AppTypography.adapt(context, AppTypography.body),
      cursorColor: AppColors.resolve(context, kColorPrimary600C2513F),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.body.copyWith(
          color: AppColors.resolve(context, kColorTextTertiary9C928A),
        ),
        errorText: errorText,
        counterText: '',
        filled: true,
        fillColor: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
        isDense: true,
        constraints: const BoxConstraints(minHeight: AppSpacing.fieldHeight),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.s4,
          vertical: maxLines > 1 ? AppSpacing.cardInset : 15,
        ),
        prefixIcon: prefix == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.s4,
                  right: AppSpacing.itemGap,
                ),
                child: prefix,
              ),
        prefixIconConstraints: const BoxConstraints(),
        suffixIcon: suffix == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(right: AppSpacing.s3),
                child: suffix,
              ),
        suffixIconConstraints: const BoxConstraints(),
        border: border(kColorTransparent),
        enabledBorder: border(kColorTransparent),
        disabledBorder: border(kColorTransparent),
        focusedBorder: border(kColorPrimary500EE7B67, 2),
        errorBorder: border(kColorErrorD14B4B),
        focusedErrorBorder: border(kColorErrorD14B4B, 2),
      ),
    );
    if (label == null) {
      return field;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label!,
          style: AppTypography.adapt(
            context,
            AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: AppSpacing.s2),
        field,
      ],
    );
  }
}
