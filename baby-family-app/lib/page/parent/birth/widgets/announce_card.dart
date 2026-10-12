part of '../mobile/birth_mobile_view.dart';

/// “Báo tin cho người thân?” (Pencil `qsLUp`): đệm 16, cách 10, `surface`,
/// bo 16; mỗi người: tên 14 + ô tick 22 bo 7 `us-700`; ghi chú 11.
class _AnnounceCard extends StatelessWidget {
  const _AnnounceCard({
    required this.relatives,
    required this.selected,
    required this.childName,
    required this.onToggle,
  });

  final List<Member> relatives;
  final Set<String> selected;
  final String childName;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final children = <Widget>[
      Text(
        l10n.pregnancyAnnounce,
        style: AppTypography.adapt(
          context,
          AppTypography.bodyStrong.copyWith(
            fontWeight: FontWeight.w700,
            height: 19 / 15,
          ),
        ),
      ),
      for (final member in relatives) _row(context, member),
      Text(
        l10n.pregBirthAnnounceNote(childName),
        style: AppTypography.adapt(
          context,
          AppTypography.tiny.copyWith(height: 1.4),
        ),
      ),
    ];
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var index = 0; index < children.length; index++) ...[
            if (index > 0) const SizedBox(height: AppSpacing.itemGap),
            children[index],
          ],
        ],
      ),
    );
  }

  Widget _row(BuildContext context, Member member) {
    final checked = selected.contains(member.id);
    return Semantics(
      checked: checked,
      child: InkWell(
        onTap: () => onToggle(member.id),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                member.callName.isEmpty ? member.displayName : member.callName,
                style: AppTypography.adapt(context, AppTypography.text14),
              ),
            ),
            const SizedBox(width: AppSpacing.itemGap),
            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: checked
                    ? AppColors.resolve(context, kColorUs7006A549F)
                    : null,
                borderRadius: BorderRadius.circular(7),
                border: checked
                    ? null
                    : Border.all(
                        color: AppColors.resolve(context, kColorBorderEADFD6),
                        width: 2,
                      ),
              ),
              child: checked
                  ? Icon(
                      LucideIcons.check,
                      size: 14,
                      color: AppColors.onPrimary(context),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
