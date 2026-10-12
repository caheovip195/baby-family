part of '../mobile/onboarding_waiting_mobile_view.dart';

/// Dòng trạng thái lời mời: icon 18 (`secondary-700`, hoặc `text-tertiary`
/// khi [muted]) + chữ 14; các dòng cách nhau 12.
class _InviteStatusRow extends StatelessWidget {
  const _InviteStatusRow({
    required this.icon,
    required this.label,
    this.muted = false,
  });

  final IconData icon;
  final String label;
  final bool muted;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.compact),
    child: Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.resolve(
            context,
            muted ? kColorTextTertiary9C928A : kColorSecondary7003F7A5C,
          ),
        ),
        const SizedBox(width: AppSpacing.itemGap),
        Expanded(
          child: Text(
            label,
            style: AppTypography.adapt(
              context,
              AppTypography.text14.copyWith(
                color: muted
                    ? kColorTextSecondary6B625B
                    : kColorTextPrimary2E2A27,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
