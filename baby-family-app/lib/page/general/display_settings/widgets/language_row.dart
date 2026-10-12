part of '../mobile/display_settings_mobile_view.dart';

/// Dòng ngôn ngữ (Pencil `bCxSa`): đệm 14/16, tên ngôn ngữ viết bằng chính
/// ngôn ngữ đó 15 (chọn: 700, khác: 500), vòng chọn 22.
class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.language,
    required this.selected,
    required this.onTap,
  });

  final AppLanguage language;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: true,
      button: true,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s4,
            vertical: AppSpacing.cardInset,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  language.nativeName,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.body.copyWith(
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              AppRadioMark(selected: selected, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
