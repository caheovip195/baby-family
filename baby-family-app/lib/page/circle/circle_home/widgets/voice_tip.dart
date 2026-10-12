part of '../mobile/circle_home_mobile_view.dart';

/// Gợi ý ghi âm (Pencil `znGZH`): nền `accent-100`, bo 16, đệm 16, `mic` 24,
/// chữ 16.
class _VoiceTip extends StatelessWidget {
  const _VoiceTip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorAccent100FDF1D6),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Icon(
            LucideIcons.mic,
            size: 24,
            color: AppColors.resolve(context, kColorTextPrimary2E2A27),
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Text(
              text,
              style: AppTypography.adapt(
                context,
                AppTypography.body.copyWith(fontSize: 16, height: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
