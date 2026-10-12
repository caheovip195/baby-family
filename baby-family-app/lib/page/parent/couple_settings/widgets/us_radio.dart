part of '../mobile/couple_settings_mobile_view.dart';

/// Vòng chọn tím (Pencil US-15 “Radio”): 22, viền 2 `us-700` + chấm 10 khi
/// chọn; viền `border` khi chưa chọn.
class _UsRadio extends StatelessWidget {
  const _UsRadio({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.resolve(
      context,
      selected ? kColorUs7006A549F : kColorBorderEADFD6,
    );
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: selected
          ? Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            )
          : null,
    );
  }
}
