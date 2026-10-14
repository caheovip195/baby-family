part of '../mobile/circle_memory_detail_mobile_view.dart';

/// Nút tròn 48 trên ảnh (Pencil “Back” nền `#2E2A2766` icon trắng, “More”
/// nền trắng icon `text-primary`), icon 24.
class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.foreground,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final Color color;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: tooltip,
    excludeSemantics: true,
    child: Material(
      color: color,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox.square(
          dimension: AppSpacing.s12,
          child: Icon(icon, size: 24, color: foreground),
        ),
      ),
    ),
  );
}
