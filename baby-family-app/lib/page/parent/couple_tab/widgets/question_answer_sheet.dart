part of '../mobile/couple_tab_mobile_view.dart';

/// Trả lời câu hỏi hôm nay (mục 9.8 US-01 khối 3): câu hỏi + ô nhập + Lưu.
class _QuestionAnswerSheet extends HookWidget {
  const _QuestionAnswerSheet({required this.question, required this.onSave});

  final DailyQuestion question;
  final Future<void> Function(String answer) onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = useTextEditingController(text: question.myAnswer ?? '');
    final saving = useState(false);
    return AppBottomSheet(
      title: question.text,
      children: [
        AppTextField(
          controller: text,
          hint: l10n.usDailyQuestionYourAnswer,
          maxLines: 3,
          autofocus: true,
        ),
        AppButton.us(
          label: l10n.commonSave,
          isLoading: saving.value,
          onPressed: () async {
            saving.value = true;
            await onSave(text.text);
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
