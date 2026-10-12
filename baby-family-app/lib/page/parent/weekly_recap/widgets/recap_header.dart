part of '../mobile/weekly_recap_mobile_view.dart';

/// Đầu trang REC-02: thanh tiến độ story (đoạn cao 3 bo 2, cách 4, đệm
/// 4/16 — đoạn đầu `primary-600`, còn lại `#2E2A271F`); tiêu đề 24/800 +
/// phụ đề 13/500 `text-secondary`; nút đóng 40 tròn `#FFFFFFB3` (`x` 20).
class _RecapHeader extends StatelessWidget {
  const _RecapHeader({required this.pages, required this.subtitle});

  final int pages;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s4,
            AppSpacing.s1,
            AppSpacing.s4,
            0,
          ),
          child: Row(
            children: [
              for (var index = 0; index < pages; index++) ...[
                if (index > 0) const SizedBox(width: AppSpacing.s1),
                Expanded(
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: index == 0
                          ? AppColors.resolve(context, kColorPrimary600C2513F)
                          : kColorShadow2E2A27Alpha12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.itemGap,
            AppSpacing.s4,
            0,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.recapWeekTitle,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.h1.copyWith(
                          fontSize: 24,
                          height: 33 / 24,
                        ),
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.caption.copyWith(
                            fontWeight: FontWeight.w500,
                            height: 16 / 13,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Semantics(
                button: true,
                label: l10n.commonClose,
                excludeSemantics: true,
                child: InkResponse(
                  onTap: () => context.router.maybePop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.isDark(context)
                          ? AppColors.resolve(context, kColorSurfaceFFFFFF)
                          : kColorWhiteAlpha70,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.x,
                      size: 20,
                      color: AppColors.resolve(
                        context,
                        kColorTextPrimary2E2A27,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
