part of '../mobile/diary_editor_mobile_view.dart';

/// Thanh trên MEM-13 (`NThMs`): cao 52, đệm ngang 16; nút đóng `x` 22; giữa
/// “Nhật ký” 17/800 + “Đã lưu nháp · 21:14” (`cloud-check` 12 `success`, 11
/// `text-tertiary`); nút “Lưu” cao 36 `primary-600` bo tròn, 14/700 trắng.
class _DiaryTopBar extends StatelessWidget {
  const _DiaryTopBar({required this.savedLabel, required this.onSave});

  final String? savedLabel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SizedBox(
      height: 52,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
        child: Row(
          children: [
            Semantics(
              button: true,
              label: l10n.commonClose,
              excludeSemantics: true,
              child: InkResponse(
                onTap: () => context.router.maybePop(),
                radius: 24,
                child: SizedBox.square(
                  dimension: 40,
                  child: Icon(
                    LucideIcons.x,
                    size: 22,
                    color: AppColors.resolve(context, kColorTextPrimary2E2A27),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.commonDiary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.adapt(context, AppTypography.title17),
                  ),
                  if (savedLabel != null) ...[
                    const SizedBox(height: 1),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.cloudCheck,
                          size: 12,
                          color: AppColors.resolve(
                            context,
                            kColorSuccess3E9B6E,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s1),
                        Flexible(
                          child: Text(
                            savedLabel!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.adapt(
                              context,
                              AppTypography.tiny,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Material(
              color: AppColors.resolve(context, kColorPrimary600C2513F),
              shape: const StadiumBorder(),
              child: InkWell(
                onTap: onSave,
                customBorder: const StadiumBorder(),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 36),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s4,
                    ),
                    child: Center(
                      widthFactor: 1,
                      heightFactor: 1,
                      child: Text(
                        l10n.commonSave,
                        style: AppTypography.text14.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.onPrimary(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
