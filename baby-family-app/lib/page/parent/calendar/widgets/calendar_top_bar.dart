part of '../mobile/calendar_mobile_view.dart';

/// Thanh trên CARE-07 (Pencil `tMGvY`): cao 56, đệm 4/12/8/8; nút back 44
/// (`chevron-left` 24), “Lịch” 26/800, bộ chuyển bé bên phải.
class _CalendarTopBar extends StatelessWidget {
  const _CalendarTopBar({required this.controller});

  final CalendarController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s2,
        AppSpacing.s1,
        AppSpacing.s3,
        AppSpacing.s2,
      ),
      child: Row(
        children: [
          SizedBox.square(
            dimension: AppSpacing.iconButton,
            child: IconButton(
              padding: EdgeInsets.zero,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () => context.router.maybePop(),
              icon: Icon(
                LucideIcons.chevronLeft,
                size: 24,
                color: AppColors.resolve(context, kColorTextPrimary2E2A27),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s1),
          Expanded(
            child: Text(
              context.l10n.calendarTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.adapt(context, AppTypography.h1),
            ),
          ),
          Flexible(
            child: ChildSwitcher(
              children: controller.children,
              selectedId: controller.subjectId,
              today: controller.today,
              onChanged: controller.selectSubject,
              onManage: () => context.router.push(const ChildrenRoute()),
            ),
          ),
        ],
      ),
    );
  }
}
