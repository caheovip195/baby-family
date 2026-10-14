part of '../mobile/bridge_next_step_mobile_view.dart';

/// Chip bước nhỏ (`oaQyt`): cao 40, đệm 14, cách 6, `surface` viền `us-100`
/// bo tròn; icon 15 `us-700` + 13/600 `text-primary`; nhãn phụ (“Lời nhờ”
/// 10/700 trên `us-100`). Đã chọn: nền `us-700`, `check` + chữ trắng.
class _NextStepChip extends StatelessWidget {
  const _NextStepChip({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final BridgeOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final onUs = AppColors.onPrimary(context);
    final usDark = AppColors.resolve(context, kColorUs7006A549F);
    return AppSelectableChip(
      label: option.title,
      selected: selected,
      outlined: true,
      height: 40,
      textColor: selected ? null : kColorTextPrimary2E2A27,
      prefix: Icon(
        selected ? LucideIcons.check : lucideIconByName(option.icon),
        size: 15,
        color: selected ? onUs : usDark,
      ),
      suffix: option.tag == null
          ? null
          : Container(
              height: 20,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s2),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.resolve(context, kColorUs100EAE2F8),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(
                option.tag!,
                style: AppTypography.micro.copyWith(
                  fontWeight: FontWeight.w700,
                  color: usDark,
                ),
              ),
            ),
      onPressed: onTap,
    );
  }
}
