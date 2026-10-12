import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Ô nhập mã dạng từng ký tự — một `TextField` ẩn (hỗ trợ dán, tự điền OTP)
/// vẽ thành các ô theo Pencil:
/// - [numeric] (AUTH-03 OTP, 6 ô): cao 56, cách 10, bo 14, số 24/800 Nunito;
///   ô đang nhập có vạch nháy 2×24 `primary-500`.
/// - Mã mời (INV-05, 8 ô): cao 52, cách 6, bo 12, chữ 20/800, dấu “·”
///   `text-tertiary` giữa ô 4 và 5.
///
/// Ô đã nhập: nền `surface` viền 1 `border`; ô kế tiếp: nền `surface-variant`
/// viền 2 `primary-500`; ô trống: nền `surface-variant`.
class AppCodeInput extends HookWidget {
  const AppCodeInput({
    required this.controller,
    required this.length,
    required this.label,
    this.numeric = false,
    this.errorText,
    this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final int length;

  /// Nhãn trợ năng của ô nhập.
  final String label;
  final bool numeric;
  final String? errorText;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final focus = useFocusNode();
    useListenable(controller);
    final text = controller.text;
    final cellHeight = numeric ? 56.0 : AppSpacing.buttonHeight;
    final cellGap = numeric ? AppSpacing.itemGap : AppSpacing.compact;
    final radius = numeric ? AppRadius.md : AppRadius.tile;
    Widget cell(int index) {
      final filled = index < text.length;
      final active = index == text.length;
      return Expanded(
        child: Container(
          height: cellHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.resolve(
              context,
              filled ? kColorSurfaceFFFFFF : kColorSurfaceVariantF7F1EC,
            ),
            borderRadius: BorderRadius.circular(radius),
            border: filled || active
                ? Border.all(
                    color: AppColors.resolve(
                      context,
                      active ? kColorPrimary500EE7B67 : kColorBorderEADFD6,
                    ),
                    width: active ? 2 : 1,
                  )
                : null,
          ),
          child: filled
              ? FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    text[index].toUpperCase(),
                    style: AppTypography.adapt(
                      context,
                      AppTypography.h1.copyWith(
                        fontSize: numeric ? 24 : 20,
                        height: 1.36,
                      ),
                    ),
                  ),
                )
              : active && numeric
              ? Container(
                  width: 2,
                  height: AppSpacing.s6,
                  color: AppColors.resolve(context, kColorPrimary500EE7B67),
                )
              : null,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: cellHeight,
          child: Stack(
            children: [
              Positioned.fill(
                child: ExcludeSemantics(
                  child: Row(
                    children: [
                      for (var i = 0; i < length; i++) ...[
                        if (i > 0) SizedBox(width: cellGap),
                        if (!numeric && i == length ~/ 2) ...[
                          Text(
                            '·',
                            style: AppTypography.adapt(
                              context,
                              AppTypography.h1.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: kColorTextTertiary9C928A,
                              ),
                            ),
                          ),
                          SizedBox(width: cellGap),
                        ],
                        cell(i),
                      ],
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: Semantics(
                  label: label,
                  child: Opacity(
                    opacity: 0,
                    child: TextField(
                      controller: controller,
                      focusNode: focus,
                      autofillHints: numeric
                          ? const [AutofillHints.oneTimeCode]
                          : null,
                      keyboardType: numeric
                          ? TextInputType.number
                          : TextInputType.visiblePassword,
                      textCapitalization: TextCapitalization.characters,
                      maxLength: length,
                      showCursor: false,
                      enableInteractiveSelection: false,
                      onSubmitted: onSubmitted,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          numeric ? RegExp('[0-9]') : RegExp('[a-zA-Z0-9]'),
                        ),
                      ],
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: AppSpacing.s2),
          Text(
            errorText!,
            style: AppTypography.adapt(
              context,
              AppTypography.caption.copyWith(color: kColorErrorD14B4B),
            ),
          ),
        ],
      ],
    );
  }
}
