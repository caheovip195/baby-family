part of '../mobile/couple_tab_mobile_view.dart';

/// “Chia sẻ với {bạn đời} / Chỉ mình tôi” (Pencil `g3HPH`): nền
/// `surface-variant` cao 44 bo tròn đệm 4; ô đang chọn nền `surface` có bóng,
/// icon 14 + chữ 13/700 `us-700`; ô còn lại `text-secondary` 13/500.
class _CheckinShareToggle extends StatelessWidget {
  const _CheckinShareToggle({
    required this.shared,
    required this.sharedLabel,
    required this.privateLabel,
    required this.onChanged,
  });

  final bool shared;
  final String sharedLabel;
  final String privateLabel;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget option(bool value, IconData icon, String label) {
      final selected = shared == value;
      final color = AppColors.resolve(
        context,
        selected ? kColorUs7006A549F : kColorTextSecondary6B625B,
      );
      return Expanded(
        child: Semantics(
          selected: selected,
          button: true,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onChanged(value),
            child: Container(
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.resolve(context, kColorSurfaceFFFFFF)
                    : null,
                borderRadius: BorderRadius.circular(AppRadius.full),
                boxShadow: selected ? AppShadows.segment : null,
              ),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 14, color: color),
                  const SizedBox(width: AppSpacing.compact),
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption.copyWith(
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: color,
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

    return Container(
      constraints: const BoxConstraints(minHeight: 44),
      padding: const EdgeInsets.all(AppSpacing.s1),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            option(true, LucideIcons.heartHandshake, sharedLabel),
            const SizedBox(width: AppSpacing.s1),
            option(false, LucideIcons.lock, privateLabel),
          ],
        ),
      ),
    );
  }
}
