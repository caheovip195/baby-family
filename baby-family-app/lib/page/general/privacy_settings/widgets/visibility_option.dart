part of '../mobile/privacy_settings_mobile_view.dart';

/// Lựa chọn mặc định người xem (Pencil `Y80rek`/`YF33X`): đệm [12,16], ô icon
/// 32, tiêu đề 15 + mô tả 12, vòng chọn 22. Đang chọn: nền `primary-50`, ô
/// icon `surface` + icon `primary-600`, tiêu đề 15/700.
class _VisibilityOption extends StatelessWidget {
  const _VisibilityOption({
    required this.icon,
    required this.title,
    required this.hint,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String hint;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      child: ColoredBox(
        color: selected
            ? AppColors.resolve(context, kColorPrimary50FFF4F1)
            : kColorTransparent,
        child: AppSettingsRow(
          icon: icon,
          iconBackground: selected
              ? kColorSurfaceFFFFFF
              : kColorSurfaceVariantF7F1EC,
          iconColor: selected
              ? kColorPrimary600C2513F
              : kColorTextSecondary6B625B,
          title: title,
          titleWeight: selected ? FontWeight.w700 : FontWeight.w500,
          subtitle: hint,
          showChevron: false,
          trailing: AppRadioMark(selected: selected, size: 22),
          onTap: onTap,
        ),
      ),
    );
  }
}
