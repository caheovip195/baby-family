part of '../mobile/my_data_mobile_view.dart';

/// Nút viên nhỏ của SET-08 (Pencil “Xuất”, “Tải về”, “Xoá cache”): cao 30,
/// đệm ngang 14, viền `border`, chữ 13/600; [busy]: nền `surface-variant`,
/// chữ `text-tertiary`, không bấm được (“Đang xuất…”).
class _SmallAction extends StatelessWidget {
  const _SmallAction({
    required this.label,
    required this.onPressed,
    this.busy = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return AppPillButton(
      label: label,
      onPressed: busy ? null : onPressed,
      outlined: true,
      height: 30,
      horizontalPadding: AppSpacing.cardInset,
      color: busy ? kColorSurfaceVariantF7F1EC : kColorSurfaceFFFFFF,
      foreground: busy ? kColorTextTertiary9C928A : kColorTextPrimary2E2A27,
    );
  }
}
