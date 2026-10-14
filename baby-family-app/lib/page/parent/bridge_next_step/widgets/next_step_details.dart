part of '../mobile/bridge_next_step_mobile_view.dart';

/// Chi tiết bước (`hiBHf`): `surface` bo 16, đệm 14, cách 12; “Khi nào?”
/// (`alarm-clock` 16 + 13/600; viên `us-100` cao 30 “Tối nay · 21:30” 12/700
/// + `chevron-down` 14); “Trông bé nào?” (`baby` 16; tên 13/700 `us-700`);
/// kẻ; “Tạo nhắc cho cả hai” + “Nhắc lúc 21:25 — chỉ hai bạn thấy” 11 + công
/// tắc `us-700`.
class _NextStepDetails extends StatelessWidget {
  const _NextStepDetails({
    required this.whenLabel,
    required this.childNames,
    required this.reminder,
    required this.reminderAt,
    required this.onReminder,
  });

  final String? whenLabel;
  final List<String> childNames;
  final bool reminder;
  final String? reminderAt;
  final ValueChanged<bool> onReminder;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final usDark = AppColors.resolve(context, kColorUs7006A549F);
    final labelStyle = AppTypography.adapt(
      context,
      AppTypography.caption.copyWith(
        fontWeight: FontWeight.w600,
        color: kColorTextPrimary2E2A27,
      ),
    );
    Widget label(IconData icon, String text) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: usDark),
        const SizedBox(width: AppSpacing.s2),
        Flexible(child: Text(text, style: labelStyle)),
      ],
    );
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardInset),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (whenLabel != null) ...[
            Row(
              children: [
                Expanded(
                  child: label(LucideIcons.alarmClock, l10n.usBridgeWhen),
                ),
                Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.resolve(context, kColorUs100EAE2F8),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        whenLabel!,
                        style: AppTypography.small.copyWith(
                          fontWeight: FontWeight.w700,
                          color: usDark,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s1),
                      Icon(LucideIcons.chevronDown, size: 14, color: usDark),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s3),
          ],
          if (childNames.isNotEmpty) ...[
            Row(
              children: [
                Expanded(
                  child: label(LucideIcons.baby, l10n.usBridgeWhichChild),
                ),
                Text(
                  childNames.join(', '),
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: usDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s3),
          ],
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.resolve(context, kColorBorderEADFD6),
          ),
          const SizedBox(height: AppSpacing.s3),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.usBridgeReminder, style: labelStyle),
                    if (reminderAt != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        l10n.usBridgeReminderSub(reminderAt!),
                        style: AppTypography.adapt(context, AppTypography.tiny),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.itemGap),
              AppSwitch(
                value: reminder,
                activeColor: kColorUs7006A549F,
                onChanged: onReminder,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
