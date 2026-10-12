import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Công tắc (Pencil SET-06 `KLf24`/`wQMa5`): 44×26, đệm 3, bo tròn; bật nền
/// `secondary-500`, tắt nền `border`; núm trắng 20.
/// [activeColor] = `us-500` ở vùng Papa & Mama (US-07, US-15).
class AppSwitch extends StatelessWidget {
  const AppSwitch({
    required this.value,
    required this.onChanged,
    this.activeColor = kColorSecondary5006FAE8E,
    super.key,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      enabled: onChanged != null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onChanged == null ? null : () => onChanged!(!value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 44,
            height: 26,
            padding: const EdgeInsets.all(3),
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            decoration: BoxDecoration(
              color: AppColors.resolve(
                context,
                value ? activeColor : kColorBorderEADFD6,
              ),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: kColorWhite,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
