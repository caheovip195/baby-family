part of '../mobile/my_data_mobile_view.dart';

/// Lựa chọn xuất (Pencil `m4CYS`): đệm 16, cách 10 — ô icon 40 bo 12, tên
/// 15/600 + đối tượng 12 `text-tertiary`, nút “Xuất”/“Đang xuất…”; mô tả 12
/// (dòng 1.45).
class _ExportOption extends StatelessWidget {
  const _ExportOption({
    required this.icon,
    required this.title,
    required this.audience,
    required this.description,
    required this.preparing,
    required this.onExport,
    this.iconBackground = kColorSurfaceVariantF7F1EC,
    this.iconColor = kColorTextSecondary6B625B,
  });

  final IconData icon;
  final String title;
  final String audience;
  final String description;
  final bool preparing;
  final VoidCallback onExport;
  final Color iconBackground;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppIconBadge(
                icon: icon,
                radius: AppRadius.tile,
                color: iconBackground,
                foreground: iconColor,
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.bodyStrong.copyWith(height: 19 / 15),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      audience,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.small.copyWith(
                          color: kColorTextTertiary9C928A,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              _SmallAction(
                label: preparing ? l10n.setExporting : l10n.setExport,
                busy: preparing,
                onPressed: onExport,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.itemGap),
          Text(
            description,
            style: AppTypography.adapt(
              context,
              AppTypography.small.copyWith(height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}
