import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_switch.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Dòng “Tôi xác nhận lần cuối khi … tham gia” (Pencil ONB-07 `tIOQ7`,
/// FAM-02 `VGRgb` “Approval”): nền `secondary-100`, bo 14, đệm 12/14, icon
/// `shield-check` 20 `secondary-700`, chữ 14, công tắc bên phải.
class InviteApprovalRow extends StatelessWidget {
  const InviteApprovalRow({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardInset,
        vertical: AppSpacing.s3,
      ),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSecondary100E4F2EA),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Icon(
            LucideIcons.shieldCheck,
            size: 20,
            color: AppColors.resolve(context, kColorSecondary7003F7A5C),
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Text(
              label,
              style: AppTypography.adapt(context, AppTypography.text14),
            ),
          ),
          const SizedBox(width: AppSpacing.s3),
          AppSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
