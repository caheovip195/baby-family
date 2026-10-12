part of '../mobile/couple_tab_mobile_view.dart';

/// Ô cảm xúc US-02: nền `surface-variant` bo 14, đệm 10/2, emoji 24 + nhãn
/// 10/500; đang chọn nền `us-100` viền 2 `us-500`, nhãn `us-700` 700.
class _CheckinMoodTile extends StatelessWidget {
  const _CheckinMoodTile({
    required this.mood,
    required this.selected,
    required this.onTap,
  });

  final MoodCode mood;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: AppColors.resolve(
          context,
          selected ? kColorUs100EAE2F8 : kColorSurfaceVariantF7F1EC,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: selected
              ? BorderSide(
                  color: AppColors.resolve(context, kColorUs5009B85D1),
                  width: 2,
                )
              : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.itemGap,
              horizontal: 2,
            ),
            child: Column(
              children: [
                Text(
                  mood.emoji,
                  style: AppTypography.body.copyWith(fontSize: 24, height: 1.2),
                ),
                const SizedBox(height: AppSpacing.s1),
                Text(
                  context.l10n.usMoodLabel(mood.name),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: AppTypography.micro.copyWith(
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: AppColors.resolve(
                      context,
                      selected ? kColorUs7006A549F : kColorTextSecondary6B625B,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
