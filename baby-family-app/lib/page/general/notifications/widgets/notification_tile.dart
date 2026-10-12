part of '../mobile/notifications_mobile_view.dart';

/// Một thông báo (Pencil `X0DPU`): đệm 14, cách 12, bo 16; icon 20 trong ô 40
/// bo 12 tô theo loại; chữ 14 (chưa đọc 600, cao dòng 1.4) + giờ 12
/// `text-tertiary`. Chưa đọc: nền `surface` + viền + chấm `primary-500` 8;
/// đã đọc: nền `bg`, không viền.
class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.item,
    required this.time,
    required this.onTap,
  });

  final AppNotification item;
  final String time;
  final VoidCallback onTap;

  static (IconData, Color, Color) _style(NotificationKind kind) =>
      switch (kind) {
        NotificationKind.support => (
          LucideIcons.heartHandshake,
          kColorUs100EAE2F8,
          kColorUs7006A549F,
        ),
        NotificationKind.request || NotificationKind.mission => (
          LucideIcons.listChecks,
          kColorPrimary50FFF4F1,
          kColorPrimary700A2402F,
        ),
        NotificationKind.comment => (
          LucideIcons.messageCircle,
          kColorSecondary100E4F2EA,
          kColorSecondary7003F7A5C,
        ),
        NotificationKind.tree => (
          LucideIcons.trophy,
          kColorAccent100FDF1D6,
          kColorTextPrimary2E2A27,
        ),
        NotificationKind.trial => (
          LucideIcons.timer,
          kColorSurfaceVariantF7F1EC,
          kColorTextSecondary6B625B,
        ),
        NotificationKind.memory => (
          LucideIcons.images,
          kColorSecondary100E4F2EA,
          kColorSecondary7003F7A5C,
        ),
        NotificationKind.invite => (
          LucideIcons.userPlus,
          kColorPrimary50FFF4F1,
          kColorPrimary700A2402F,
        ),
        NotificationKind.system => (
          LucideIcons.bell,
          kColorSurfaceVariantF7F1EC,
          kColorTextSecondary6B625B,
        ),
      };

  @override
  Widget build(BuildContext context) {
    final (icon, background, foreground) = _style(item.kind);
    final unread = item.unread;
    return Material(
      color: AppColors.resolve(
        context,
        unread ? kColorSurfaceFFFFFF : kColorBgFFFBF7,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: unread
            ? BorderSide(color: AppColors.resolve(context, kColorBorderEADFD6))
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardInset),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppSpacing.s10,
                height: AppSpacing.s10,
                decoration: BoxDecoration(
                  color: AppColors.resolve(context, background),
                  borderRadius: BorderRadius.circular(AppRadius.tile),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: AppColors.resolve(context, foreground),
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.text,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.text14.copyWith(
                          height: 1.4,
                          fontWeight: unread ? FontWeight.w600 : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s1),
                    Text(
                      time,
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
              if (unread) ...[
                const SizedBox(width: AppSpacing.s3),
                Container(
                  width: AppSpacing.s2,
                  height: AppSpacing.s2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.resolve(context, kColorPrimary500EE7B67),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
