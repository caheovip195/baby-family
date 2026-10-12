part of '../mobile/mission_detail_mobile_view.dart';

/// Một dòng thông tin CARE-02: icon 16 `text-secondary`, nhãn 14, giá trị
/// 14/600 bên phải.
class _DetailInfoRow extends StatelessWidget {
  const _DetailInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s2),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.resolve(context, kColorTextSecondary6B625B),
          ),
          const SizedBox(width: AppSpacing.s2),
          Expanded(
            child: Text(
              label,
              style: AppTypography.adapt(
                context,
                AppTypography.text14.copyWith(color: kColorTextSecondary6B625B),
              ),
            ),
          ),
          if (value.isNotEmpty) ...[
            const SizedBox(width: AppSpacing.s3),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: AppTypography.adapt(
                  context,
                  AppTypography.text14.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
