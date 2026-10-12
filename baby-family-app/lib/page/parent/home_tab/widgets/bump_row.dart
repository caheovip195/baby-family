part of '../mobile/home_tab_mobile_view.dart';

/// “Bụng bầu theo tuần” (Pencil `DbZ0A`): 4 tuần gần nhất (ảnh cao 84 bo 12,
/// nhãn “T20”) + ô chụp tuần hiện tại (nền `us-50`, viền `us-500`, “Chụp”).
class _BumpRow extends StatelessWidget {
  const _BumpRow({required this.controller, required this.onTap});

  final HomeTabController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final us = AppColors.resolve(context, kColorUs7006A549F);
    return _photoRow([
      for (final photo in controller.recentBumps)
        _LabeledPhoto(
          label: l10n.homeWeekShort(photo.week),
          asset: photo.asset,
          height: 84,
          radius: AppRadius.tile,
          onTap: onTap,
        ),
      _LabeledPhoto(
        label: l10n.homeWeekShort(controller.currentPregnancyWeek),
        height: 84,
        radius: AppRadius.tile,
        accent: kColorUs7006A549F,
        emptyBorder: kColorUs5009B85D1,
        emptyColor: kColorUs50F6F2FC,
        empty: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.camera, size: 18, color: us),
            const SizedBox(height: 2),
            Text(
              l10n.homeCapture,
              style: AppTypography.micro.copyWith(
                fontWeight: FontWeight.w700,
                color: us,
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    ]);
  }
}
