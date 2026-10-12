part of '../mobile/couple_tab_mobile_view.dart';

/// Phản hồi nhanh dưới ô bạn đời (Pencil `QhKW4`): 3 nút cao 42, cách 8 —
/// “Để mình lo” nền `us-700`, “Ôm”/“Đã thấy” nền `surface` viền `us-100`.
class _QuickReplies extends StatelessWidget {
  const _QuickReplies({required this.onReply});

  final VoidCallback onReply;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget outlined(String label, IconData icon) => Expanded(
      child: AppPillButton(
        label: label,
        icon: icon,
        height: 42,
        horizontalPadding: AppSpacing.s1,
        outlined: true,
        borderColor: kColorUs100EAE2F8,
        onPressed: onReply,
      ),
    );
    return Row(
      children: [
        Expanded(
          child: AppPillButton(
            label: l10n.usTakeOver,
            icon: LucideIcons.handHeart,
            height: 42,
            horizontalPadding: AppSpacing.s1,
            color: kColorUs7006A549F,
            foreground: AppColors.onPrimary(context),
            onPressed: onReply,
          ),
        ),
        const SizedBox(width: AppSpacing.s2),
        outlined(l10n.usHugShort, LucideIcons.heart),
        const SizedBox(width: AppSpacing.s2),
        outlined(l10n.usSeen, LucideIcons.eye),
      ],
    );
  }
}
