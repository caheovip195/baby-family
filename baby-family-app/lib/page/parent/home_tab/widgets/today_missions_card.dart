part of '../mobile/home_tab_mobile_view.dart';

/// “Nhiệm vụ hôm nay” (Pencil `sTAZh`): tiến độ cả nhà + Hearts của tôi, thanh
/// 8, thẻ nhiệm vụ đầu tiên chưa xong của tôi, “+ n việc nữa của tôi”.
class _TodayMissionsCard extends StatelessWidget {
  const _TodayMissionsCard({required this.controller});

  final HomeTabController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final board = controller.board!;
    final pending = controller.myPending;
    final first = pending.firstOrNull;
    final total = board.totalCount;
    void openCare() => _openTab(context, MainTab.care);
    return AppCard(
      onTap: openCare,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.homeFamilyProgress(board.doneCount, total),
                  style: AppTypography.adapt(
                    context,
                    AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Text(
                l10n.homeYourHearts(board.heartsToday),
                style: AppTypography.adapt(
                  context,
                  AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: kColorPrimary600C2513F,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s2),
          AppProgressBar(value: total == 0 ? 0 : board.doneCount / total),
          if (first != null) ...[
            const SizedBox(height: AppSpacing.s3),
            MissionCard(
              title: first.title,
              meta: missionMetaText(l10n, first),
              child: controller.childById(first.childIds.firstOrNull),
              onToggle: () => controller.completeMission(first),
              onTap: openCare,
            ),
          ],
          if (pending.length > 1) ...[
            const SizedBox(height: AppSpacing.s3),
            Text(
              l10n.homeMoreMissions(pending.length - 1),
              style: AppTypography.adapt(
                context,
                AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
