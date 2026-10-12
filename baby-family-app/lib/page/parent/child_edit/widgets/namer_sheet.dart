part of '../mobile/child_edit_mobile_view.dart';

/// Sheet “+ Khác”: nhập tên người đặt tên khác (vd. “Bà ngoại”).
class _NamerSheet extends HookWidget {
  const _NamerSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final name = useTextEditingController();
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: AppBottomSheet(
        title: l10n.childNameGivenByLabel,
        children: [
          AppTextField(controller: name, autofocus: true),
          AppButton(
            label: l10n.commonAdd,
            onPressed: () => Navigator.of(context).pop(name.text),
          ),
        ],
      ),
    );
  }
}
