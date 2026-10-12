part of '../mobile/home_tab_mobile_view.dart';

/// Hero thai kỳ (Pencil `srtP7`): nền `us-50`, viền `us-100`, bo 24, đệm 18,
/// cách 14; minh hoạ 110 + tam cá nguyệt 10/800, “Tuần 24 + 3 ngày” 21/800,
/// “Còn 109 ngày gặp Bơ 💜” 14/600, dự sinh 11; thanh 40 tuần 3 đoạn (13/14/13
/// tuần); thẻ kích thước bé tuần này.
class _PregnancyHero extends StatelessWidget {
  const _PregnancyHero({
    required this.controller,
    required this.pregnancy,
    required this.onTap,
  });

  final HomeTabController controller;
  final Child pregnancy;
  final VoidCallback onTap;

  /// Ranh giới tam cá nguyệt (tuần) và độ dài thai kỳ.
  static const _segments = [(0, 13), (13, 27), (27, 40)];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final due = pregnancy.dueDate;
    final today = controller.today;
    final week = due == null ? null : pregnancyWeek(due, today);
    final progress = week == null ? 0.0 : week.week + week.day / 7;
    final us = AppColors.resolve(context, kColorUs7006A549F);
    final size = controller.fetalSize;
    final weekLabel = AppTypography.adapt(
      context,
      AppTypography.micro.copyWith(color: kColorTextTertiary9C928A),
    );
    return AppCard(
      color: kColorUs50F6F2FC,
      borderColor: kColorUs100EAE2F8,
      radius: AppRadius.dialog,
      padding: const EdgeInsets.all(18),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Assets.images.r8Z6hl.image(
                width: 110,
                height: 110,
                excludeFromSemantics: true,
              ),
              const SizedBox(width: AppSpacing.cardInset),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (week != null)
                      Text(
                        l10n
                            .homeTrimester(trimesterOf(week.week).index + 1)
                            .toUpperCase(),
                        style: AppTypography.micro.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: us,
                        ),
                      ),
                    if (due != null) ...[
                      const SizedBox(height: AppSpacing.s1),
                      Text(
                        pregnancyWeekText(l10n, due, today),
                        style: AppTypography.adapt(
                          context,
                          AppTypography.h2.copyWith(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s1),
                      Text(
                        l10n.homeDaysToMeet(
                          daysUntil(due, today),
                          pregnancy.name,
                        ),
                        style: AppTypography.text14.copyWith(
                          fontWeight: FontWeight.w600,
                          color: us,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s1),
                      Text(
                        l10n.homeDueDate(due.toFormDate(context.localeName)),
                        style: AppTypography.adapt(
                          context,
                          AppTypography.tiny.copyWith(
                            color: kColorTextSecondary6B625B,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.cardInset),
          Row(
            children: [
              for (var index = 0; index < _segments.length; index++) ...[
                if (index > 0) const SizedBox(width: 3),
                Expanded(
                  flex: _segments[index].$2 - _segments[index].$1,
                  child: AppProgressBar(
                    height: AppSpacing.itemGap,
                    value:
                        ((progress - _segments[index].$1) /
                                (_segments[index].$2 - _segments[index].$1))
                            .clamp(0, 1)
                            .toDouble(),
                    color: kColorUs5009B85D1,
                    trackColor: kColorUs100EAE2F8,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.compact),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final label in [1, 13, 27, 40])
                Text(l10n.commonPregnancyWeekOnly(label), style: weekLabel),
            ],
          ),
          if (size != null) ...[
            const SizedBox(height: AppSpacing.cardInset),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s3,
                vertical: AppSpacing.itemGap,
              ),
              decoration: BoxDecoration(
                color: AppColors.resolve(context, kColorSurfaceFFFFFF),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                children: [
                  Text(size.emoji, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: AppSpacing.itemGap),
                  Expanded(
                    child: Text(
                      l10n.homeFetalSize(
                        pregnancy.name,
                        size.fruit,
                        size.lengthCm,
                      ),
                      style: AppTypography.adapt(
                        context,
                        AppTypography.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          color: kColorTextPrimary2E2A27,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.itemGap),
                  Text(l10n.homeReference, style: weekLabel),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
