part of '../mobile/home_tab_mobile_view.dart';

/// Thẻ Papa & Mama (Pencil `FjGIO`): nền `us-50`, viền `us-100`, bo 20, đệm
/// 16, cách 12; nhãn khoá; tâm trạng bạn đời (emoji 22 trên nền đào 44, tiêu
/// đề 16/700, nhu cầu 13); 3 nút trả lời nhanh 36 (“Để mình lo” nền `us-700`).
class _CoupleCard extends StatelessWidget {
  const _CoupleCard({required this.controller, required this.checkin});

  final HomeTabController controller;
  final MoodCheckin checkin;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final usColor = AppColors.resolve(context, kColorUs7006A549F);
    final need = checkin.needs.firstOrNull;
    final minutes = checkin.needMinutes;
    final needText = need == null
        ? null
        : minutes == null
        ? l10n.homeNeedLabel(need.name)
        : l10n.homeNeedMinutes(l10n.homeNeedLabel(need.name), minutes);
    void openUs() => _openTab(context, MainTab.us);
    Widget reply(String label, {bool primary = false}) => AppPillButton(
      label: label,
      color: primary ? kColorUs7006A549F : kColorSurfaceFFFFFF,
      foreground: primary ? kColorBgFFFBF7 : kColorUs7006A549F,
      outlined: !primary,
      borderColor: kColorUs100EAE2F8,
      onPressed: openUs,
    );
    return AppCard(
      color: kColorUs50F6F2FC,
      borderColor: kColorUs100EAE2F8,
      radius: AppRadius.xl,
      padding: const EdgeInsets.all(AppSpacing.s4),
      onTap: openUs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.lock, size: 14, color: usColor),
              const SizedBox(width: AppSpacing.compact),
              Flexible(
                child: Text(
                  l10n.homeParentsPrivacy,
                  style: AppTypography.small.copyWith(
                    fontWeight: FontWeight.w600,
                    color: usColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s3),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: kColorChildPeachFFB59E,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.resolve(context, kColorSurfaceFFFFFF),
                    width: 2,
                  ),
                ),
                child: Text(
                  checkin.mood.emoji,
                  style: const TextStyle(fontSize: 22, height: 1),
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.homeMoodTitle(
                        controller.callNameOf(checkin.userId),
                        checkin.mood.name,
                      ),
                      style: AppTypography.adapt(
                        context,
                        AppTypography.title16,
                      ),
                    ),
                    if (needText != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        needText,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.caption,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s3),
          Wrap(
            spacing: AppSpacing.s2,
            runSpacing: AppSpacing.s2,
            children: [
              reply(l10n.usTakeOver, primary: true),
              reply(l10n.homeHug),
              reply(l10n.usSeen),
            ],
          ),
        ],
      ),
    );
  }
}
