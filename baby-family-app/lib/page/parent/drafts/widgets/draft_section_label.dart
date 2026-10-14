part of '../mobile/drafts_mobile_view.dart';

/// Nhãn nhóm nháp (Pencil “TRÊN MÁY NÀY” / “ĐÃ LƯU TRÊN TÀI KHOẢN”): icon
/// 14 + chữ hoa 13/700 `text-secondary`, đệm trên 6.
class _DraftSectionLabel extends StatelessWidget {
  const _DraftSectionLabel({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.resolve(context, kColorTextSecondary6B625B);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.compact),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: AppSpacing.compact),
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: AppTypography.adapt(
                context,
                AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                  color: kColorTextSecondary6B625B,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
