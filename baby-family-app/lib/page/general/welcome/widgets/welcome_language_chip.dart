part of '../mobile/welcome_mobile_view.dart';

class _WelcomeLanguageChip extends StatelessWidget {
  const _WelcomeLanguageChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kColorSurfaceVariantF7F1EC,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.full),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.minTouchTarget - AppSpacing.s2,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  LucideIcons.globe,
                  size: 18,
                  color: kColorTextSecondary6B625B,
                ),
                const SizedBox(width: AppSpacing.s2),
                Text(label, style: AppTypography.caption),
                const SizedBox(width: AppSpacing.s1),
                const Icon(
                  LucideIcons.chevronDown,
                  size: 16,
                  color: kColorTextSecondary6B625B,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
