part of '../mobile/calendar_mobile_view.dart';

/// Dòng mục trong ngày (Pencil “Bà nội lên chơi…”): cột giờ 54 (12/600
/// `text-secondary`), cách 12, thẻ `surface` viền `border` bo 14 đệm 10/12:
/// vạch màu 4×36, tiêu đề 14/600 + dòng phụ 12, icon tròn 30 (icon 15).
class _CalendarEventRow extends StatelessWidget {
  const _CalendarEventRow({
    required this.event,
    required this.controller,
    this.onTap,
  });

  final CalendarEvent event;
  final CalendarController controller;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (bar, iconBackground, iconColor) = switch (event.kind) {
      CalendarEventKind.mission => (
        kColorPrimary500EE7B67,
        kColorPrimary50FFF4F1,
        kColorPrimary600C2513F,
      ),
      CalendarEventKind.couple => (
        kColorUs5009B85D1,
        kColorUs50F6F2FC,
        kColorUs7006A549F,
      ),
      _ => (
        kColorAccent500F4BF5C,
        kColorAccent100FDF1D6,
        kColorAccent7009A6A12,
      ),
    };
    final names = [
      for (final id in event.childIds) ?controller.child(id)?.name,
    ];
    final parts = <String>[
      l10n.calendarKindLabel(event.kind.name),
      if (names.isNotEmpty)
        names.join(', ')
      else if (event.allDay)
        l10n.calendarAllDay,
      if (event.kind == CalendarEventKind.mission)
        l10n.calendarOwnerLabel(
          (event.ownerKind ?? MissionOwnerKind.me).name,
          controller.partnerCallName,
        ),
      if (event.kind == CalendarEventKind.couple) l10n.calendarCoupleOnly,
    ];
    return Row(
      children: [
        SizedBox(
          width: 54,
          child: Text(
            event.allDay ? l10n.calendarAllDay : event.time ?? '',
            style: AppTypography.adapt(
              context,
              AppTypography.small.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s3),
        Expanded(
          child: Material(
            color: AppColors.resolve(context, kColorSurfaceFFFFFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              side: BorderSide(
                color: AppColors.resolve(context, kColorBorderEADFD6),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s3,
                  vertical: AppSpacing.itemGap,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.resolve(context, bar),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.itemGap),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.adapt(
                              context,
                              AppTypography.text14.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            parts.reduce(l10n.commonDotJoin),
                            style: AppTypography.adapt(
                              context,
                              AppTypography.small,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.itemGap),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.resolve(context, iconBackground),
                      ),
                      child: Icon(
                        lucideIconByName(event.icon),
                        size: 15,
                        color: AppColors.resolve(context, iconColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
