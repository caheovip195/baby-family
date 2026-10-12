import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_setting_row.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Sheet “⋯” của khu Chăm con: Lịch sử nhiệm vụ (CARE-08), Huy hiệu (CARE-10),
/// Cài đặt nhiệm vụ (CARE-12). Dùng ở CARE-01 (nút ⋯ cạnh nút lịch) và CARE-09
/// (thanh tiêu đề). Sheet tự đóng rồi gọi callback — màn gọi tự điều hướng.
class CareMoreSheet extends StatelessWidget {
  const CareMoreSheet({
    required this.onHistory,
    required this.onBadges,
    required this.onSettings,
    super.key,
  });

  final VoidCallback onHistory;
  final VoidCallback onBadges;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    void select(VoidCallback action) {
      Navigator.of(context).pop();
      action();
    }

    const padding = EdgeInsets.symmetric(vertical: AppSpacing.cardInset);
    return AppBottomSheet(
      gap: 0,
      children: [
        AppSettingRow(
          icon: LucideIcons.history,
          title: l10n.careMenuHistory,
          padding: padding,
          divider: true,
          onTap: () => select(onHistory),
        ),
        AppSettingRow(
          icon: LucideIcons.award,
          title: l10n.careBadgesTitle,
          padding: padding,
          divider: true,
          onTap: () => select(onBadges),
        ),
        AppSettingRow(
          icon: LucideIcons.settings,
          title: l10n.careSettingsTitle,
          padding: padding,
          onTap: () => select(onSettings),
        ),
      ],
    );
  }
}

/// Mở [CareMoreSheet] bằng bottom sheet chuẩn.
Future<void> showCareMoreSheet(
  BuildContext context, {
  required VoidCallback onHistory,
  required VoidCallback onBadges,
  required VoidCallback onSettings,
}) => showAppBottomSheet<void>(
  context,
  builder: (_) => CareMoreSheet(
    onHistory: onHistory,
    onBadges: onBadges,
    onSettings: onSettings,
  ),
);
