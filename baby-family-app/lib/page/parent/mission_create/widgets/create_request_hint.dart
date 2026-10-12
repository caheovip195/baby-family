part of '../mobile/mission_create_mobile_view.dart';

/// “Muốn nhờ Papa một việc? Gửi lời nhờ →” (Pencil `U9Wii`): nền `us-50` bo
/// 12, đệm 10/12, `hand-heart` 16 + 13/600 `us-700`. Mở US-03 (BR-020).
class _CreateRequestHint extends StatelessWidget {
  const _CreateRequestHint({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.resolve(context, kColorUs7006A549F);
    return Material(
      color: AppColors.resolve(context, kColorUs50F6F2FC),
      borderRadius: BorderRadius.circular(AppRadius.tile),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s3,
            vertical: AppSpacing.itemGap,
          ),
          child: Row(
            children: [
              Icon(LucideIcons.handHeart, size: 16, color: color),
              const SizedBox(width: AppSpacing.s2),
              Expanded(
                child: Text(
                  text,
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
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
