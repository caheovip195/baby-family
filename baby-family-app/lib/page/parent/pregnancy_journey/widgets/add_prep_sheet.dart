part of '../mobile/pregnancy_journey_mobile_view.dart';

/// “Thêm mục” chuẩn bị: tên + nhóm.
class _AddPrepSheet extends HookWidget {
  const _AddPrepSheet({required this.controller});

  final PregnancyJourneyController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final title = useTextEditingController();
    final group = useState(PrepGroup.bag);
    return AppBottomSheet(
      title: l10n.pregnancyAddPreparation,
      children: [
        AppTextField(
          hint: l10n.pregnancyPreparationHint,
          controller: title,
          autofocus: true,
        ),
        Wrap(
          spacing: AppSpacing.s2,
          runSpacing: AppSpacing.s2,
          children: [
            for (final value in PrepGroup.values)
              AppChip(
                label: _prepGroupLabel(context, value),
                selected: group.value == value,
                onTap: () => group.value = value,
              ),
          ],
        ),
        AppButton(
          label: l10n.commonAdd,
          onPressed: () async {
            final navigator = Navigator.of(context);
            await controller.addPrep(title.text, group.value);
            navigator.pop();
          },
        ),
      ],
    );
  }
}
