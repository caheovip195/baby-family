part of '../mobile/event_create_mobile_view.dart';

/// Nhóm trường CAL-02: nhãn 13/700 `text-secondary`, các khối cách 10.
class _EventSection extends StatelessWidget {
  const _EventSection({required this.label, required this.children});

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTypography.adapt(
            context,
            AppTypography.caption.copyWith(
              fontWeight: FontWeight.w700,
              height: 16 / 13,
            ),
          ),
        ),
        for (final child in children) ...[
          const SizedBox(height: AppSpacing.itemGap),
          child,
        ],
      ],
    );
  }
}
