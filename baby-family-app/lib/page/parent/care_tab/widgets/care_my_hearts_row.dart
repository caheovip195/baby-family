part of '../mobile/care_tab_mobile_view.dart';

/// “Hearts của tôi hôm nay: 5” + “🔒 Chỉ bạn thấy” (Pencil `m1ogPZ`) — chỉ ở
/// tab Của tôi (BR-018).
class _CareMyHeartsRow extends StatelessWidget {
  const _CareMyHeartsRow({required this.hearts});

  final int hearts;

  @override
  Widget build(BuildContext context) {
    final tertiary = AppColors.resolve(context, kColorTextTertiary9C928A);
    return Row(
      children: [
        Icon(
          LucideIcons.heart,
          size: 16,
          color: AppColors.resolve(context, kColorPrimary500EE7B67),
        ),
        const SizedBox(width: AppSpacing.compact),
        Expanded(
          child: Text(
            context.l10n.careMyHeartsToday(hearts),
            style: AppTypography.adapt(
              context,
              AppTypography.text14.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s2),
        Icon(LucideIcons.lock, size: 12, color: tertiary),
        const SizedBox(width: AppSpacing.s1),
        Text(
          context.l10n.carePrivateHearts,
          style: AppTypography.adapt(context, AppTypography.tiny),
        ),
      ],
    );
  }
}
