part of '../mobile/care_tab_mobile_view.dart';

/// Dải ngày (Pencil `bVndP`): 7 ô cách 6, đệm 4/20/8/20. Ô thường: nền
/// `surface` viền `border` bo 14, thứ 11 `text-tertiary`, số 16/800; chấm 5
/// `secondary-500` khi ngày có nhiệm vụ. Ô đang chọn: nền `primary-600`.
class _CareWeekStrip extends StatelessWidget {
  const _CareWeekStrip({required this.controller});

  final CareTabController controller;

  @override
  Widget build(BuildContext context) {
    final days = controller.stripDays;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.s1,
        AppSpacing.screen,
        AppSpacing.s2,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var index = 0; index < days.length; index++) ...[
            if (index > 0) const SizedBox(width: AppSpacing.compact),
            Expanded(
              child: _day(
                context,
                days[index],
                weekdayCode(days[index].weekday),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _day(BuildContext context, DateTime day, String code) {
    final selected = DateUtils.isSameDay(day, controller.selectedDate);
    final dot = !selected && controller.hasMissionsOn(day);
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: AppColors.resolve(
          context,
          selected ? kColorPrimary600C2513F : kColorSurfaceFFFFFF,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: selected
              ? BorderSide.none
              : BorderSide(
                  color: AppColors.resolve(context, kColorBorderEADFD6),
                ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => controller.selectDate(day),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s2),
            child: Column(
              children: [
                Text(
                  context.l10n.careWeekday(code),
                  maxLines: 1,
                  style: selected
                      ? AppTypography.tiny.copyWith(color: kColorWhiteAlpha80)
                      : AppTypography.adapt(context, AppTypography.tiny),
                ),
                const SizedBox(height: AppSpacing.s1),
                Text(
                  '${day.day}',
                  maxLines: 1,
                  style: AppTypography.title16.copyWith(
                    fontWeight: FontWeight.w800,
                    color: selected
                        ? AppColors.onPrimary(context)
                        : AppColors.resolve(context, kColorTextPrimary2E2A27),
                  ),
                ),
                if (dot) ...[
                  const SizedBox(height: AppSpacing.s1),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.resolve(
                        context,
                        kColorSecondary5006FAE8E,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
