part of '../mobile/home_tab_mobile_view.dart';

/// Gợi ý ghi lại (Pencil `icv6p`): nền `primary-50`, viền `primary-100`, bo 16,
/// đệm 16, cách 10; nhãn 11/800 `primary-700`; câu hỏi 18/800 (1.3); nút
/// “Ghi câu nói” 36 `primary-600` + “Gợi ý khác”.
class _PromptCard extends StatelessWidget {
  const _PromptCard({required this.controller});

  final HomeTabController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final prompt = controller.prompt!;
    final child = controller.childById(prompt.childId);
    final birth = child?.birthDate;
    final age = birth == null
        ? null
        : childAgeParts(birth, controller.today).years > 0
        ? l10n.commonAgeYears(childAgeParts(birth, controller.today).years)
        : childAgeText(l10n, birth, controller.today);
    final kicker = child == null
        ? l10n.homePrompt
        : l10n.homePromptKicker(child.name, age ?? '');
    void record() =>
        context.router.push(MemoryQuoteRoute(childId: prompt.childId));
    return AppCard(
      color: kColorPrimary50FFF4F1,
      borderColor: kColorPrimary100FFE3DC,
      padding: const EdgeInsets.all(AppSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.sparkles,
                size: 14,
                color: AppColors.resolve(context, kColorPrimary600C2513F),
              ),
              const SizedBox(width: AppSpacing.compact),
              Flexible(
                child: Text(
                  kicker.toUpperCase(),
                  style: AppTypography.adapt(
                    context,
                    AppTypography.tiny.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                      color: kColorPrimary700A2402F,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.itemGap),
          Text(
            prompt.text,
            style: AppTypography.adapt(
              context,
              AppTypography.h3.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.itemGap),
          Wrap(
            spacing: AppSpacing.itemGap,
            runSpacing: AppSpacing.s2,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppPillButton(
                label: l10n.homeRecordQuote,
                icon: LucideIcons.quote,
                iconSize: 14,
                color: kColorPrimary600C2513F,
                foreground: kColorBgFFFBF7,
                onPressed: record,
              ),
              TextButton(
                onPressed: controller.dismissPrompt,
                style: TextButton.styleFrom(
                  minimumSize: const Size(0, AppSpacing.chipHeight),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s1,
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  l10n.homeOtherPrompt,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
