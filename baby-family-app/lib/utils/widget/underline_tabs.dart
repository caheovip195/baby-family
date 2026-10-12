import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Tab gạch chân (Pencil MEM-01 Sub Tabs `S7rHlP`): cách 20, đệm ngang 20,
/// viền dưới 1 `border`; mỗi tab đệm trên 10, chữ 14 — chọn: 700
/// `primary-700` + gạch 3 `primary-600` rộng bằng chữ + 4 mỗi bên; chưa chọn: 500
/// `text-secondary`. Dùng ở MEM-01 (Dòng thời gian/Ảnh/Bộ sưu tập), PREG-01.
class UnderlineTabs extends StatelessWidget {
  const UnderlineTabs({
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
    super.key,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.resolve(context, kColorBorderEADFD6),
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var index = 0; index < labels.length; index++) ...[
              if (index > 0) const SizedBox(width: AppSpacing.s5),
              _tab(context, index),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tab(BuildContext context, int index) {
    final selected = index == selectedIndex;
    return Semantics(
      selected: selected,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(index),
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.itemGap),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s1),
                child: Text(
                  labels[index],
                  textAlign: TextAlign.center,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.text14.copyWith(
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected
                          ? kColorPrimary700A2402F
                          : kColorTextSecondary6B625B,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s2),
              Container(
                height: 3,
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.resolve(context, kColorPrimary600C2513F)
                      : kColorTransparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
