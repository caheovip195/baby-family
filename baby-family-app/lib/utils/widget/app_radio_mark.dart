import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Vòng chọn (Pencil SUB-01 “Radio” 24/chấm 12, SET-06 22/chấm 11): viền 2
/// `primary-600` + chấm khi chọn, viền `border` khi chưa chọn.
class AppRadioMark extends StatelessWidget {
  const AppRadioMark({required this.selected, this.size = 24, super.key});

  final bool selected;
  final double size;

  @override
  Widget build(BuildContext context) {
    final active = AppColors.resolve(context, kColorPrimary600C2513F);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected
              ? active
              : AppColors.resolve(context, kColorBorderEADFD6),
          width: 2,
        ),
      ),
      child: selected
          ? Container(
              width: size / 2,
              height: size / 2,
              decoration: BoxDecoration(color: active, shape: BoxShape.circle),
            )
          : null,
    );
  }
}
