part of '../mobile/bridge_invite_mobile_view.dart';

/// “Để sau — nhắc mình lúc” (`mw4Sw`): nhãn 12/600 `text-secondary`; 3 viên
/// cao 40 giãn đều (`surface` viền `us-100`, icon 14 + 13/600 `us-700`):
/// Tối nay · Ngày mai · Tự chọn.
class _InviteLaterOptions extends StatelessWidget {
  const _InviteLaterOptions({required this.onSelect});

  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final usDark = AppColors.resolve(context, kColorUs7006A549F);
    final options = [
      (LucideIcons.moon, l10n.usRequestTonight),
      (LucideIcons.sun, l10n.careTomorrow),
      (LucideIcons.calendar, l10n.usBridgeLaterCustom),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.usBridgeLaterLabel,
          style: AppTypography.adapt(
            context,
            AppTypography.small.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: AppSpacing.s2),
        Row(
          children: [
            for (final (index, (icon, label)) in options.indexed) ...[
              if (index > 0) const SizedBox(width: AppSpacing.s2),
              Expanded(
                child: AppSelectableChip(
                  label: label,
                  height: 40,
                  outlined: true,
                  padding: AppSpacing.s2,
                  textColor: kColorUs7006A549F,
                  prefix: Icon(icon, size: 14, color: usDark),
                  onPressed: onSelect,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
