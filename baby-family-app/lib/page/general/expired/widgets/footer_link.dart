part of '../mobile/expired_mobile_view.dart';

/// Liên kết chữ 13/600 ở chân SUB-07 (“Khôi phục giao dịch · Hỗ trợ · Đăng
/// xuất”, “Xoá tài khoản” màu `error`).
class _FooterLink extends StatelessWidget {
  const _FooterLink({
    required this.label,
    required this.onTap,
    this.color = kColorTextSecondary6B625B,
  });

  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.xs),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s1),
          child: Text(
            label,
            style: AppTypography.adapt(
              context,
              AppTypography.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
