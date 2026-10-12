part of '../mobile/couple_tab_mobile_view.dart';

/// Thanh tiêu đề US-01: “Papa & Mama” 26/800 + khoá “Chỉ hai bạn nhìn thấy”
/// (`us-700`), nút cài đặt 40×40 (US-15 — chưa có màn).
class _CoupleHeader extends StatelessWidget {
  const _CoupleHeader({this.onSettings});

  final VoidCallback? onSettings;

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
                Row(
                  children: [
                    Icon(LucideIcons.lock, size: 13, color: accent),
                    const SizedBox(width: AppSpacing.compact),
                    Flexible(
                      child: Text(
                        l10n.usOnlyTwo,
                        style: AppTypography.small.copyWith(
                          fontWeight: FontWeight.w600,
                          color: accent,
                        ),
                      ),
                    ),
                  ],
                ),
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
