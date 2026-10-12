part of '../mobile/diary_editor_mobile_view.dart';

/// Dải gợi ý (`f3GiXM`): nền `primary-50`, đệm 10/20, cách 8; đầu dòng
/// `sparkles` 14 + “Gợi ý cho Hana · 2 tuổi 4 tháng” 12/700 `primary-700`,
/// “Gợi ý khác” (`refresh-cw` 13, 12/600); chip cao 32 nền `surface`, viền
/// `primary-100`, 12/500.
class _DiaryPrompts extends StatelessWidget {
  const _DiaryPrompts({
    required this.title,
    required this.prompts,
    required this.onPrompt,
    required this.onMore,
  });

  final String title;
  final List<String> prompts;
  final ValueChanged<String> onPrompt;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final secondary = AppColors.resolve(context, kColorTextSecondary6B625B);
    return Container(
      color: AppColors.resolve(context, kColorPrimary50FFF4F1),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screen,
        vertical: AppSpacing.itemGap,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.sparkles,
                size: 14,
                color: AppColors.resolve(context, kColorPrimary600C2513F),
              ),
              const SizedBox(width: AppSpacing.compact),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.small.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.resolve(context, kColorPrimary700A2402F),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onMore,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.refreshCw, size: 13, color: secondary),
                    const SizedBox(width: AppSpacing.s1),
                    Text(
                      context.l10n.homeOtherPrompt,
                      style: AppTypography.small.copyWith(
                        fontWeight: FontWeight.w600,
                        color: secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s2),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final prompt in prompts) ...[
                  if (prompt != prompts.first)
                    const SizedBox(width: AppSpacing.s2),
                  Material(
                    color: AppColors.resolve(context, kColorSurfaceFFFFFF),
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: AppColors.resolve(
                          context,
                          kColorPrimary100FFE3DC,
                        ),
                      ),
                    ),
                    child: InkWell(
                      onTap: () => onPrompt(prompt),
                      customBorder: const StadiumBorder(),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 32),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.s3,
                          ),
                          child: Center(
                            widthFactor: 1,
                            heightFactor: 1,
                            child: Text(
                              prompt,
                              style: AppTypography.adapt(
                                context,
                                AppTypography.small.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: kColorTextPrimary2E2A27,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
