part of '../mobile/display_settings_mobile_view.dart';

/// Ô xem trước cỡ chữ (Pencil `mLM2C`): nền `surface`, viền `border`, bo 14,
/// đệm 14, chữ 15.
class _TextSizePreview extends StatelessWidget {
  const _TextSizePreview({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardInset),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.resolve(context, kColorBorderEADFD6),
        ),
      ),
      child: Text(
        text,
        style: AppTypography.adapt(context, AppTypography.body),
      ),
    );
  }
}
