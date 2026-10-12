part of '../mobile/pregnancy_journey_mobile_view.dart';

/// “Sửa thai kỳ”: tên ở nhà + ngày dự sinh (dd/MM/yyyy).
class _EditPregnancySheet extends HookWidget {
  const _EditPregnancySheet({required this.controller});

  final PregnancyJourneyController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final child = controller.child;
    final name = useTextEditingController(text: child?.name ?? '');
    final due = useTextEditingController(
      text: child?.dueDate?.toFormDate(context.localeName) ?? '',
    );
    return AppBottomSheet(
      title: l10n.pregMenuEdit,
      children: [
        AppTextField(label: l10n.pregnancyNickname, controller: name),
        AppTextField(
          label: l10n.onboardingDueDate,
          controller: due,
          keyboardType: TextInputType.datetime,
        ),
        AppButton(
          label: l10n.commonSave,
          onPressed: () async {
            final navigator = Navigator.of(context);
            await controller.saveEdit(
              name: name.text,
              dueDate: _parseDate(due.text),
            );
            navigator.pop();
          },
        ),
      ],
    );
  }
}

/// `dd/MM/yyyy` → ngày; sai định dạng → null (giữ giá trị cũ).
DateTime? _parseDate(String text) {
  final parts = text.trim().split(RegExp(r'[/.\-]'));
  if (parts.length != 3) {
    return null;
  }
  final day = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final year = int.tryParse(parts[2]);
  if (day == null || month == null || year == null) {
    return null;
  }
  return DateTime(year, month, day);
}
