part of '../mobile/relative_detail_mobile_view.dart';

/// FAM-06 — Xác nhận gỡ người thân (đặc tả mục 9: tóm tắt nội dung họ đã
/// đăng; lựa chọn giữ/gỡ; xác nhận). Không có frame Pencil: dựng bằng
/// [AppBottomSheet] + [AppRadioMark] + [AppButton]. Trả `true` khi xác nhận.
class _RemoveRelativeSheet extends HookWidget {
  const _RemoveRelativeSheet({required this.member});

  final Member member;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final keepPosts = useState(true);

    Widget option(bool keep, String title, String? hint) => InkWell(
      onTap: () => keepPosts.value = keep,
      borderRadius: BorderRadius.circular(AppRadius.tile),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s3),
        decoration: BoxDecoration(
          color: keepPosts.value == keep
              ? AppColors.resolve(context, kColorPrimary50FFF4F1)
              : null,
          borderRadius: BorderRadius.circular(AppRadius.tile),
          border: Border.all(
            color: AppColors.resolve(
              context,
              keepPosts.value == keep
                  ? kColorPrimary300F7A796
                  : kColorBorderEADFD6,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.text14.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (hint != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      hint,
                      style: AppTypography.adapt(context, AppTypography.small),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s3),
            AppRadioMark(selected: keepPosts.value == keep, size: 22),
          ],
        ),
      ),
    );

    return AppBottomSheet(
      title: l10n.famRemoveTitle(member.callName),
      gap: AppSpacing.s3,
      children: [
        Text(
          l10n.famRemoveSummary(member.callName, member.postedCount),
          style: AppTypography.adapt(
            context,
            AppTypography.text14.copyWith(
              height: 1.45,
              color: kColorTextSecondary6B625B,
            ),
          ),
        ),
        option(true, l10n.famRemoveKeepPosts, l10n.famRemoveKeepPostsHint),
        option(false, l10n.famRemoveDeletePosts, null),
        const SizedBox(height: AppSpacing.s1),
        AppButton(
          label: l10n.famRemoveRelative,
          icon: LucideIcons.userMinus,
          onPressed: () => Navigator.of(context).pop(true),
        ),
        AppButton.text(
          label: l10n.commonCancel,
          color: kColorTextSecondary6B625B,
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ],
    );
  }
}
