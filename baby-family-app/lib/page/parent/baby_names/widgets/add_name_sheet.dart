part of '../mobile/baby_names_mobile_view.dart';

/// “Thêm tên dự định”: tên + ý nghĩa.
class _AddNameSheet extends HookWidget {
  const _AddNameSheet({required this.controller});

  final BabyNamesController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final name = useTextEditingController();
    final meaning = useTextEditingController();
    return AppBottomSheet(
      title: l10n.pregnancyAddName,
      children: [
        AppTextField(
          label: l10n.pregnancyNameHint,
          controller: name,
          autofocus: true,
        ),
        AppTextField(label: l10n.pregnancyMeaning, controller: meaning),
        AppButton.us(
          label: l10n.commonAdd,
          onPressed: () async {
            final navigator = Navigator.of(context);
            await controller.addName(name.text, meaning.text);
            navigator.pop();
          },
        ),
      ],
    );
  }
}
