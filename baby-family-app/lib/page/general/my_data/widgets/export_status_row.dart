part of '../mobile/my_data_mobile_view.dart';

/// Trạng thái một bản xuất (Pencil `tj9vm` đang chạy / `o4mTz` sẵn sàng).
/// Đang chạy: tên 14/600 + “Đang chuẩn bị · 45%” 12/600 `primary-600`, thanh
/// 8, “Bắt đầu 08:12 hôm nay…” 12. Sẵn sàng: ô 40 `secondary-100` +
/// `circle-check`, “Dữ liệu cá nhân · 214 MB”, hạn link, nút “Tải về”.
class _ExportStatusRow extends StatelessWidget {
  const _ExportStatusRow({required this.job, required this.onDownload});

  final DataExportJob job;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = context.localeName;
    final name = job.kind == DataExportKind.family
        ? l10n.setExportFamily
        : l10n.setExportPersonal;
    if (job.status == DataExportStatus.ready) {
      final expires = job.expiresAt;
      return AppSettingsRow(
        icon: LucideIcons.circleCheck,
        iconTile: 40,
        iconBackground: kColorSecondary100E4F2EA,
        iconColor: kColorSecondary7003F7A5C,
        title: l10n.setExportReadyTitle(name, job.sizeMb ?? 0),
        titleSize: 14,
        titleWeight: FontWeight.w600,
        subtitle: expires == null
            ? null
            : l10n.setExportExpires(expires.toFormDate(locale)),
        verticalPadding: AppSpacing.s4,
        showChevron: false,
        trailing: _SmallAction(label: l10n.setDownload, onPressed: onDownload),
      );
    }
    final started = job.startedAt;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.text14.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s2),
              Text(
                l10n.setExportPreparing(job.progress),
                style: AppTypography.adapt(
                  context,
                  AppTypography.small.copyWith(
                    fontWeight: FontWeight.w600,
                    color: kColorPrimary600C2513F,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s2),
          AppProgressBar(
            value: job.progress / 100,
            color: AppColors.resolve(context, kColorPrimary500EE7B67),
            trackColor: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
          ),
          if (started != null) ...[
            const SizedBox(height: AppSpacing.s2),
            Text(
              l10n.setExportStarted(started.toDisplayTime(locale)),
              style: AppTypography.adapt(context, AppTypography.small),
            ),
          ],
        ],
      ),
    );
  }
}
