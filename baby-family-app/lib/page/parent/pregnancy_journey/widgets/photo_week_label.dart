part of '../mobile/pregnancy_journey_mobile_view.dart';

/// Nhãn tuần trên ảnh (Pencil “Label”/“L”): nền `#2E2A2799` bo tròn, chữ
/// trắng 700 — lớn (đệm 3/8, 11) ở so sánh, nhỏ (đệm 2/6, 10) ở lưới.
class _PhotoWeekLabel extends StatelessWidget {
  const _PhotoWeekLabel({required this.text, this.small = false});

  final String text;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: small
          ? const EdgeInsets.symmetric(
              horizontal: AppSpacing.compact,
              vertical: 2,
            )
          : const EdgeInsets.symmetric(horizontal: AppSpacing.s2, vertical: 3),
      decoration: BoxDecoration(
        color: kColorSheetScrim2E2A27Alpha60,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        text,
        maxLines: 1,
        style: (small ? AppTypography.micro : AppTypography.tiny).copyWith(
          fontWeight: FontWeight.w700,
          color: kColorWhite,
        ),
      ),
    );
  }
}
