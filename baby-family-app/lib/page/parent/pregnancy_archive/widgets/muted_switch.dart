part of '../mobile/pregnancy_archive_mobile_view.dart';

/// Công tắc bảng màu trầm của PREG-06 (Pencil `YEzfS`): 44×26, đệm 3, bật
/// nền `text-secondary` (thay `secondary-500` của `AppSwitch`), núm trắng 20.
class _MutedSwitch extends StatelessWidget {
  const _MutedSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(!value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11),
          child: Container(
            width: 44,
            height: 26,
            padding: const EdgeInsets.all(3),
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            decoration: BoxDecoration(
              color: AppColors.resolve(
                context,
                value ? kColorTextSecondary6B625B : kColorBorderEADFD6,
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
