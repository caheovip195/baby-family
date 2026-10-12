part of '../mobile/milestone_picker_mobile_view.dart';

/// “✏️ Cột mốc riêng của nhà mình” (`NiWS3`): cao 52, nền `primary-50`, viền
/// `primary-300`, bo 14; chữ 14/700 `primary-700` giữa.
class _CustomMilestoneButton extends StatelessWidget {
  const _CustomMilestoneButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      side: BorderSide(
        color: AppColors.resolve(context, kColorPrimary300F7A796),
      ),
    );
    return Semantics(
      button: true,
      child: Material(
        color: AppColors.resolve(context, kColorPrimary50FFF4F1),
        shape: shape,
        child: InkWell(
          onTap: onTap,
          customBorder: shape,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 52),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
                child: Text(
                  context.l10n.memMilestoneCustom,
                  textAlign: TextAlign.center,
                  style: AppTypography.text14.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.resolve(context, kColorPrimary700A2402F),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
