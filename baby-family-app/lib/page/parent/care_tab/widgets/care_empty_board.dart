part of '../mobile/care_tab_mobile_view.dart';

/// STATE-03 “Hôm nay chưa có việc nào” (Pencil `ghZZx`): minh hoạ 150 + tiêu
/// đề + mô tả, rồi “GỢI Ý CHO HARU · 17 THÁNG” và các mẫu có nút “+” 36.
class _CareEmptyBoard extends StatelessWidget {
  const _CareEmptyBoard({required this.controller, required this.bottomInset});

  final CareTabController controller;
  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final child = controller.suggestionChild;
    final birth = child?.birthDate;
    String section;
    if (child == null) {
      section = l10n.careSuggestToday;
    } else if (child.isPregnancy && child.dueDate != null) {
      section = l10n.careSuggestFor(
        child.name,
        pregnancyWeekText(l10n, child.dueDate!, controller.today),
      );
    } else if (birth != null) {
      final months = childAgeInMonths(birth, controller.today);
      section = l10n.careSuggestFor(
        child.name,
        months < 24
            ? l10n.commonAgeMonths(months)
            : childAgeText(l10n, birth, controller.today),
      );
    } else {
      section = l10n.careSuggestToday;
    }
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.s2,
        AppSpacing.screen,
        AppSpacing.s4 + bottomInset,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s2),
          child: EmptyState(
            title: l10n.stateEmptyCare,
            description: l10n.stateEmptyCareDescription,
            illustration: Assets.images.j0ynDJ.path,
            illustrationSize: 150,
          ),
        ),
        if (controller.suggestions.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.cardInset),
          Text(
            section.toUpperCase(),
            style: AppTypography.adapt(
              context,
              AppTypography.small.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          for (final template in controller.suggestions) ...[
            const SizedBox(height: AppSpacing.cardInset),
            MissionTemplateTile(
              icon: missionIcon(template.icon),
              title: template.title,
              meta: template.hint ?? missionTemplateMeta(l10n, template),
              iconBackground: kColorPrimary50FFF4F1,
              onTap: () => controller.addSuggestion(template),
              trailing: _addButton(context, template),
            ),
          ],
        ],
      ],
    );
  }

  Widget _addButton(BuildContext context, MissionTemplate template) =>
      Semantics(
        button: true,
        label: context.l10n.commonAdd,
        child: Material(
          color: AppColors.resolve(context, kColorPrimary600C2513F),
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => controller.addSuggestion(template),
            child: SizedBox.square(
              dimension: 36,
              child: Icon(
                LucideIcons.plus,
                size: 18,
                color: AppColors.onPrimary(context),
              ),
            ),
          ),
        ),
      );
}
