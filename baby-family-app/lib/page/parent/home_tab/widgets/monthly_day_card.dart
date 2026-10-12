part of '../mobile/home_tab_mobile_view.dart';

/// Ngày ảnh tháng (Pencil `lbTga`): nền `accent-100`, bo 16, đệm 14, cách 14;
/// ảnh 64×80 bo 14 viền `surface` 3; “NGÀY MAI” 11/800, tiêu đề 17/800, mô tả
/// 12, nút “Chụp ảnh tháng” 32 nền `text-primary`.
class _MonthlyDayCard extends StatelessWidget {
  const _MonthlyDayCard({required this.controller, required this.child});

  final HomeTabController controller;
  final Child child;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final month = controller.specialMonth;
    final days = controller.specialDaysLeft;
    final kicker = switch (days) {
      <= 0 => l10n.homeMonthlyToday,
      1 => l10n.homeTomorrow,
      _ => l10n.homeMonthlyInDays(days),
    };
    void openCamera() => context.router.push(
      MonthlyCameraRoute(childId: child.id, month: month),
    );
    final avatar = child.avatarAsset;
    return AppCard(
      color: kColorAccent100FDF1D6,
      borderColor: null,
      onTap: openCamera,
      child: Row(
        children: [
          if (avatar != null)
            Container(
              width: 64,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: AppColors.resolve(context, kColorSurfaceFFFFFF),
                  width: 3,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
              ),
              child: _Photo(
                asset: avatar,
                height: 80,
                radius: AppRadius.md - 3,
              ),
            ),
          const SizedBox(width: AppSpacing.cardInset),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kicker,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.tiny.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: kColorTextSecondary6B625B,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s1),
                Text(
                  l10n.homeMonthlyTurns(child.name, month),
                  style: AppTypography.adapt(context, AppTypography.title17),
                ),
                const SizedBox(height: AppSpacing.s1),
                Text(
                  l10n.homeMonthlyPrepare(controller.specialMonthlyDone, month),
                  style: AppTypography.adapt(context, AppTypography.small),
                ),
                const SizedBox(height: AppSpacing.s1),
                AppPillButton(
                  label: l10n.homeMonthlyPhoto,
                  icon: LucideIcons.camera,
                  iconSize: 14,
                  height: 32,
                  fontSize: 12,
                  horizontalPadding: AppSpacing.s3,
                  color: kColorTextPrimary2E2A27,
                  foreground: kColorBgFFFBF7,
                  onPressed: openCamera,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
