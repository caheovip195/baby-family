import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/notification/app_notification.dart';
import 'package:baby_family/page/general/notifications/notifications_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/relative_time.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_chip.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/skeleton_block.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/notification_tile.dart';

/// NOTI-01 (Pencil VljHC): tiêu đề 26/800 + “Đã đọc hết”, 3 chip lọc, nhóm
/// “HÔM NAY”/“HÔM QUA”; thông báo chưa đọc là thẻ viền có chấm cam.
class NotificationsMobileView extends HookConsumerWidget {
  const NotificationsMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(notificationsControllerProvider);
    final l10n = context.l10n;
    final yesterday = controller.now.dateOnly.subtract(const Duration(days: 1));
    String dayLabel(DateTime day) {
      if (day == controller.now.dateOnly) {
        return l10n.notificationsToday;
      }
      if (day == yesterday) {
        return l10n.notificationsYesterday;
      }
      return day.toDisplayDate(context.localeName);
    }

    String timeLabel(AppNotification item) =>
        item.createdAt.isSameDay(controller.now)
        ? relativeTimeText(
            l10n,
            item.createdAt,
            controller.now,
            locale: context.localeName,
          )
        : item.createdAt.toDisplayTime(context.localeName);

    Future<void> open(AppNotification item) async {
      await controller.open(item);
      final route = item.route;
      if (route == null || !context.mounted) {
        return;
      }
      if (route.startsWith('/main')) {
        await context.router.navigatePath(route);
      } else {
        await context.router.pushPath(route);
      }
    }

    final filters = {
      NotificationGroup.all: l10n.notificationsAll,
      NotificationGroup.us: l10n.notificationsPrivate,
      NotificationGroup.family: l10n.notificationsFamily,
    };
    final children = <Widget>[
      Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                l10n.notificationsTitle,
                style: AppTypography.adapt(context, AppTypography.h1),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: controller.markAllRead,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.resolve(
                context,
                kColorPrimary700A2402F,
              ),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s1),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: const Icon(LucideIcons.checkCheck, size: 16),
            label: Text(
              l10n.notificationsReadAll,
              style: AppTypography.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.resolve(context, kColorPrimary700A2402F),
              ),
            ),
          ),
        ],
      ),
      Wrap(
        spacing: AppSpacing.s2,
        runSpacing: AppSpacing.s2,
        children: [
          for (final entry in filters.entries)
            AppChip(
              label: entry.value,
              selected: controller.group == entry.key,
              onTap: () => controller.selectGroup(entry.key),
            ),
        ],
      ),
      if (!controller.loaded && controller.hasError)
        ErrorState(onRetry: controller.load)
      else if (!controller.loaded)
        for (var index = 0; index < 3; index++)
          const SkeletonBlock(height: 72, radius: AppRadius.lg)
      else if (controller.days.isEmpty)
        // Danh sách rỗng có empty state (Skill 8) — trước đây trang trắng
        // (BF-20261026-003).
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.s8),
          child: EmptyState(
            title: l10n.notificationsEmpty,
            description: l10n.notificationsEmptyDescription,
          ),
        )
      else
        for (final (day, items) in controller.days) ...[
          Text(
            dayLabel(day).toUpperCase(),
            style: AppTypography.adapt(
              context,
              AppTypography.caption.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
          ),
          for (final item in items)
            _NotificationTile(
              item: item,
              time: timeLabel(item),
              onTap: () => open(item),
            ),
        ],
    ];
    return BaseScaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.load,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.s2,
              AppSpacing.screen,
              AppSpacing.s8,
            ),
            itemCount: children.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppSpacing.cardInset),
            itemBuilder: (_, index) => children[index],
          ),
        ),
      ),
    );
  }
}
