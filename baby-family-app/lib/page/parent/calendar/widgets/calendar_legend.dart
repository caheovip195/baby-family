part of '../mobile/calendar_mobile_view.dart';

/// Chú thích chấm + công tắc âm lịch (Pencil `YF7Mj`): đệm 2/20/10/20, cách
/// 12; chấm 7 + nhãn 12 `text-secondary`; “Âm lịch” 12/600 + công tắc nhỏ.
class _CalendarLegend extends StatelessWidget {
  const _CalendarLegend({required this.controller});

  final CalendarController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final style = AppTypography.adapt(context, AppTypography.small);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        2,
        AppSpacing.screen,
        AppSpacing.s1,
      ),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: AppSpacing.s3,
              runSpacing: AppSpacing.s1,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final (dot, label) in [
                  (CalendarDot.mission, l10n.calendarLegendMission),
                  (CalendarDot.event, l10n.calendarLegendEvent),
                  (CalendarDot.couple, l10n.calendarLegendCouple),
                ])
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.resolve(context, _dotColor(dot)),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(label, style: style),
                    ],
                  ),
              ],
            ),
          ),
          MergeSemantics(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.calendarLunar,
                  style: style.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: AppSpacing.compact),
                SizedBox(
                  width: 36,
                  height: AppSpacing.s10,
                  child: FittedBox(
                    child: AppSwitch(
                      value: controller.showLunar,
                      onChanged: controller.setLunar,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
