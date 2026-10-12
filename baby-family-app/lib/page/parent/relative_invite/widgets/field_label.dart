part of '../mobile/relative_invite_mobile_view.dart';

/// Nhãn nhóm của form (Pencil “Người này là…”, “Được theo dõi”): 14/600.
class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.adapt(
        context,
        AppTypography.text14.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
