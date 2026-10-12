part of '../mobile/private_journal_mobile_view.dart';

/// Sheet “Trang mới” (cùng ngôn ngữ US-02/US-07): chọn cảm xúc (chip tím),
/// tiêu đề, nội dung, nút “Lưu trang” `us-700`. Không chặn — lưu luôn.
class _JournalEditorSheet extends HookWidget {
  const _JournalEditorSheet({required this.controller});

  final PrivateJournalController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final mood = useState(JournalMood.calm);
    final title = useTextEditingController();
    final body = useTextEditingController();
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: AppBottomSheet(
        title: l10n.usJournalNewPage,
        children: [
          Text(
            l10n.usJournalMoodLabel,
            style: AppTypography.adapt(
              context,
              AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Wrap(
            spacing: AppSpacing.s2,
            runSpacing: AppSpacing.s2,
            children: [
              for (final option in JournalMood.values)
                AppSelectableChip(
                  label: l10n.usJournalMood(option.name),
                  selected: mood.value == option,
                  outlined: true,
                  prefix: Icon(
                    _moodStyle(option).$1,
                    size: 14,
                    color: mood.value == option
                        ? AppColors.onPrimary(context)
                        : AppColors.resolve(context, kColorUs7006A549F),
                  ),
                  onPressed: () => mood.value = option,
                ),
            ],
          ),
          AppTextField(label: l10n.usJournalTitleLabel, controller: title),
          AppTextField(
            label: l10n.usJournalBodyLabel,
            hint: l10n.usJournalHint,
            controller: body,
            maxLines: 5,
          ),
          AppButton.us(
            label: l10n.usJournalSave,
            isLoading: controller.isLoading,
            onPressed: () async {
              final navigator = Navigator.of(context);
              await controller.addEntry(
                mood: mood.value,
                title: title.text.trim(),
                body: body.text.trim(),
              );
              navigator.pop();
            },
          ),
        ],
      ),
    );
  }
}
