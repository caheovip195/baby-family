part of '../mobile/chat_conversation_mobile_view.dart';

/// Ngăn cách ngày CHAT-02: viên `surface-variant` bo full, đệm 4/12, chữ 13
/// `text-secondary`, căn giữa.
class _DaySeparator extends StatelessWidget {
  const _DaySeparator({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s3),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s3,
            vertical: AppSpacing.s1,
          ),
          decoration: BoxDecoration(
            color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Text(
            label,
            style: AppTypography.adapt(
              context,
              AppTypography.caption.copyWith(
                color: AppColors.resolve(context, kColorTextSecondary6B625B),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
