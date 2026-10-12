part of '../mobile/weekly_recap_mobile_view.dart';

/// Hành động REC-02 (`a48v6`): nút chính 52 `primary-600` bo 16 (`send` 18 +
/// “Chia sẻ với người thân” 15/700 + nhãn gói “Family” `#FFFFFF33`); hai nút
/// phụ 46 nền `surface` viền bo 14 (icon 16 + 13/600); ghi chú `eye` 13 + 11
/// `text-tertiary`.
class _RecapActions extends StatelessWidget {
  const _RecapActions({
    required this.onShare,
    required this.onSave,
    required this.onDownload,
  });

  final VoidCallback onShare;
  final VoidCallback onSave;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final onPrimary = AppColors.onPrimary(context);
    Widget secondary(IconData icon, String label, VoidCallback onTap) {
      final shape = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: AppColors.resolve(context, kColorBorderEADFD6)),
      );
      return Material(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        shape: shape,
        child: InkWell(
          onTap: onTap,
          customBorder: shape,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 46),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 16,
                    color: AppColors.resolve(
                      context,
                      kColorTextSecondary6B625B,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.compact),
                  Flexible(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 16 / 13,
                          color: kColorTextPrimary2E2A27,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.s1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: AppColors.resolve(context, kColorPrimary600C2513F),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: InkWell(
              onTap: onShare,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 52),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.send, size: 18, color: onPrimary),
                      const SizedBox(width: AppSpacing.s2),
                      Flexible(
                        child: Text(
                          l10n.recapShareFamily,
                          style: AppTypography.label.copyWith(
                            fontWeight: FontWeight.w700,
                            height: 19 / 15,
                            color: onPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: kColorWhiteAlpha20,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(
                          l10n.recapFamilyBadge,
                          style: AppTypography.micro.copyWith(
                            fontWeight: FontWeight.w800,
                            color: onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.itemGap),
          Row(
            children: [
              Expanded(
                child: secondary(
                  LucideIcons.bookmarkPlus,
                  l10n.recapSaveTimeline,
                  onSave,
                ),
              ),
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                child: secondary(
                  LucideIcons.download,
                  l10n.recapDownload,
                  onDownload,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.itemGap),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s1,
              vertical: 2,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Icon(
                    LucideIcons.eye,
                    size: 13,
                    color: AppColors.resolve(context, kColorTextTertiary9C928A),
                  ),
                ),
                const SizedBox(width: AppSpacing.compact),
                Expanded(
                  child: Text(
                    l10n.recapNote,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.tiny.copyWith(height: 1.4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
