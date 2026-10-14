part of '../mobile/couple_tab_mobile_view.dart';

/// Thanh tiêu đề US-01: “Papa & Mama” 26/800 + khoá [privacy] (`us-700`,
/// mặc định “Chỉ hai bạn nhìn thấy”; US-00 “Chỉ dành cho Papa & Mama”), nút
/// cài đặt 40×40 (US-15) khi có [onSettings].
class _CoupleHeader extends StatelessWidget {
  const _CoupleHeader({this.onSettings, this.privacy});

  final VoidCallback? onSettings;
  final String? privacy;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final accent = AppColors.resolve(context, kColorUs7006A549F);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.s1,
        AppSpacing.screen,
        AppSpacing.s2,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.usTitle,
                  style: AppTypography.adapt(context, AppTypography.h1),
                ),
                const SizedBox(height: 2),
                UsPrivateLabel(privacy ?? l10n.usOnlyTwo),
              ],
            ),
          ),
          if (onSettings != null)
            SizedBox.square(
              dimension: AppSpacing.s10,
              child: IconButton(
                padding: EdgeInsets.zero,
                tooltip: l10n.usSettingsTooltip,
                onPressed: onSettings,
                icon: Icon(LucideIcons.settings, size: 22, color: accent),
              ),
            ),
        ],
      ),
    );
  }
}
