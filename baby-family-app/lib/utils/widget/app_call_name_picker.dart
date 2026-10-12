import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_chip.dart';
import 'package:baby_family/utils/widget/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// “Các con gọi bạn là” (Pencil ONB-03 `Nzuyk`, INV-01 `GlVRP`): nhãn 13/600
/// `text-secondary`, cách 10, hàng chip `AppChip` cách 8 — Papa/Bố/Ba/Khác…
/// hoặc Mama/Mẹ/Má/Khác…; chọn “Khác…” hiện ô nhập tên gọi riêng.
class AppCallNamePicker extends HookWidget {
  const AppCallNamePicker({
    required this.father,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool father;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labels = father
        ? [
            kValueDefaultCallNameFather,
            l10n.onboardingFatherCallName,
            l10n.onboardingFatherCallNameAlt,
          ]
        : [
            kValueDefaultCallNameMother,
            l10n.onboardingMotherCallName,
            l10n.onboardingMotherCallNameAlt,
          ];
    final custom = useState(value.isNotEmpty && !labels.contains(value));
    final input = useTextEditingController(text: custom.value ? value : '');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.onboardingCallName,
          style: AppTypography.adapt(
            context,
            AppTypography.caption.copyWith(
              fontWeight: FontWeight.w600,
              height: 16 / 13,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.itemGap),
        Wrap(
          spacing: AppSpacing.s2,
          runSpacing: AppSpacing.s2,
          children: [
            for (final label in labels)
              AppChip(
                label: label,
                selected: !custom.value && value == label,
                onTap: () {
                  custom.value = false;
                  onChanged(label);
                },
              ),
            AppChip(
              label: l10n.onboardingOtherCallName,
              selected: custom.value,
              onTap: () {
                custom.value = true;
                if (input.text.trim().isNotEmpty) {
                  onChanged(input.text.trim());
                }
              },
            ),
          ],
        ),
        if (custom.value) ...[
          const SizedBox(height: AppSpacing.s3),
          AppTextField(
            controller: input,
            autofocus: true,
            hint: l10n.onboardingOtherCallName,
            textInputAction: TextInputAction.done,
            onChanged: (text) => onChanged(text.trim()),
          ),
        ],
      ],
    );
  }
}
