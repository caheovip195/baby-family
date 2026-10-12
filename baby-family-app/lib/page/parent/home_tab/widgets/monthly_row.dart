part of '../mobile/home_tab_mobile_view.dart';

/// “Con lớn từng tháng” (Pencil `pAdG6`): 6 tháng gần nhất, ảnh cao 72 bo 10,
/// nhãn “1 th”; tháng hiện tại chưa chụp là ô viền `secondary-500` + “+”.
class _MonthlyRow extends StatelessWidget {
  const _MonthlyRow({required this.controller, required this.child});

  final HomeTabController controller;
  final Child child;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final router = context.router;
    final current = childMonthIndex(child.birthDate!, controller.today);
    final first = current > HomeTabController.monthlyRowCount
        ? current - HomeTabController.monthlyRowCount + 1
        : 1;
    String? assetOf(int month) => controller.monthlyPhotos
        .where((photo) => photo.monthIndex == month)
        .firstOrNull
        ?.asset;
    return _photoRow([
      for (var month = first; month <= current; month++)
        _LabeledPhoto(
          label: l10n.homeMonthShort(month),
          asset: assetOf(month),
          height: 72,
          radius: AppRadius.sm,
          empty: Icon(
            LucideIcons.plus,
            size: 18,
            color: AppColors.resolve(context, kColorSecondary7003F7A5C),
          ),
          onTap: assetOf(month) == null
              ? () => router.push(
                  MonthlyCameraRoute(childId: child.id, month: month),
                )
              : () => router.push(MonthlyPhotosRoute(childId: child.id)),
        ),
    ]);
  }
}
