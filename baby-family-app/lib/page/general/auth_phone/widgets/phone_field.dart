part of '../mobile/auth_phone_mobile_view.dart';

/// Hàng “+84 ▾” (81, nền `surface-variant`) + ô số (nền `surface`, viền 2
/// `primary-500` khi đang nhập), cao 52, bo 14, cách 10.
class _PhoneField extends HookWidget {
  const _PhoneField({required this.controller, required this.onSubmitted});

  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final focus = useFocusNode();
    useListenable(focus);
    final textColor = AppColors.resolve(context, kColorTextPrimary2E2A27);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label: context.l10n.authCountryCodeSemantics(kValueDefaultDialCode),
          child: Container(
            height: AppSpacing.fieldHeight,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.cardInset,
            ),
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  kValueDefaultDialCode,
                  style: AppTypography.label.copyWith(color: textColor),
                ),
                const SizedBox(width: AppSpacing.compact),
                Icon(
                  LucideIcons.chevronDown,
                  size: 16,
                  color: AppColors.resolve(context, kColorTextSecondary6B625B),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.itemGap),
        Expanded(
          child: TextField(
            controller: controller,
            focusNode: focus,
            autofocus: true,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.telephoneNumberNational],
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
              const PhoneGroupFormatter(),
            ],
            onSubmitted: onSubmitted,
            cursorColor: AppColors.resolve(context, kColorPrimary600C2513F),
            style: AppTypography.bodyLarge.copyWith(
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              height: 22 / 17,
              color: textColor,
            ),
            decoration: InputDecoration(
              semanticCounterText: '',
              labelText: null,
              hintText: context.l10n.authPhoneLabel,
              hintStyle: AppTypography.body.copyWith(
                color: AppColors.resolve(context, kColorTextTertiary9C928A),
              ),
              filled: true,
              fillColor: AppColors.resolve(context, kColorSurfaceFFFFFF),
              isDense: true,
              constraints: const BoxConstraints(
                minHeight: AppSpacing.fieldHeight,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s4,
                vertical: 15,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(
                  color: AppColors.resolve(context, kColorBorderEADFD6),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(
                  color: AppColors.resolve(context, kColorPrimary500EE7B67),
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
