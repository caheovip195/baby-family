part of '../mobile/bridge_start_mobile_view.dart';

/// Liên kết chữ trong nội dung US-08: “Mình cảm thấy không an toàn”
/// (`shield-alert` 14 + 13/600 `text-secondary`, `uREXD`), “Lời nhắn” /
/// “Viết lại nhẹ nhàng” (13/600 `us-700`) ở bước 5.
class _BridgeTextLink extends StatelessWidget {
  const _BridgeTextLink({
    required this.label,
    required this.onTap,
    required this.icon,
    this.color = kColorUs7006A549F,
  });

  final String label;
  final VoidCallback onTap;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final foreground = AppColors.resolve(context, color);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSpacing.iconButton),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: foreground),
              const SizedBox(width: AppSpacing.compact),
              Flexible(
                child: Text(
                  label,
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: foreground,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
