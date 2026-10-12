part of '../mobile/private_journal_mobile_view.dart';

/// Thẻ trang nhật ký (Pencil “Entry · Thứ Ba, 06/10 · 23:40”): nền `surface`
/// viền `us-100` bo 16 đệm 14 cách 8. Đầu: ngày 12/600 `text-tertiary` + nhãn
/// cảm xúc 24 (icon 12 + 11/700). Thân: tiêu đề 16/800 + đoạn đầu 13
/// `text-secondary`, ảnh 64 bo 12. Chân: “Chia sẻ đoạn này với bạn đời”
/// (kẻ trên `us-100`) hoặc viên “Đã chia sẻ 1 đoạn với …”.
class _JournalEntryCard extends StatelessWidget {
  const _JournalEntryCard({
    required this.entry,
    required this.partnerCallName,
    this.onShare,
  });

  final JournalEntry entry;
  final String partnerCallName;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final at = entry.createdAt;
    final day = l10n.calendarDayTitle(
      l10n.careWeekdayTitle(weekdayCode(at.weekday)),
      at.toDayMonth(l10n.localeName),
    );
    final (moodIcon, moodBackground, moodColor) = _moodStyle(entry.mood);
    final usDark = AppColors.resolve(context, kColorUs7006A549F);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardInset),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.resolve(context, kColorUs100EAE2F8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  entry.showTime
                      ? l10n.commonDotJoin(day, at.toDisplayTime())
                      : day,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.small.copyWith(
                      fontWeight: FontWeight.w600,
                      color: kColorTextTertiary9C928A,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s2),
              Container(
                height: 24,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s2),
                decoration: BoxDecoration(
                  color: AppColors.resolve(context, moodBackground),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      moodIcon,
                      size: 12,
                      color: AppColors.resolve(context, moodColor),
                    ),
                    const SizedBox(width: AppSpacing.s1),
                    Text(
                      l10n.usJournalMood(entry.mood.name),
                      style: AppTypography.adapt(
                        context,
                        AppTypography.tiny.copyWith(
                          fontWeight: FontWeight.w700,
                          color: moodColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.title16.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s1),
                    Text(
                      entry.body,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.caption.copyWith(height: 19 / 13),
                      ),
                    ),
                  ],
                ),
              ),
              if (entry.photoAsset != null) ...[
                const SizedBox(width: AppSpacing.s3),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.tile),
                  child: Image.asset(
                    entry.photoAsset!,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        const SizedBox.square(dimension: 64),
                  ),
                ),
              ],
            ],
          ),
          if (onShare != null) ...[
            const SizedBox(height: AppSpacing.s2),
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.resolve(context, kColorUs100EAE2F8),
                  ),
                ),
              ),
              child: InkWell(
                onTap: onShare,
                child: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.itemGap),
                  child: Row(
                    children: [
                      Icon(LucideIcons.quote, size: 14, color: usDark),
                      const SizedBox(width: AppSpacing.compact),
                      Expanded(
                        child: Text(
                          l10n.usJournalShareAction,
                          style: AppTypography.caption.copyWith(
                            height: 16 / 13,
                            fontWeight: FontWeight.w600,
                            color: usDark,
                          ),
                        ),
                      ),
                      Icon(LucideIcons.chevronRight, size: 16, color: usDark),
                    ],
                  ),
                ),
              ),
            ),
          ] else if (entry.sharedExcerpt) ...[
            const SizedBox(height: AppSpacing.s2),
            Container(
              height: 26,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.itemGap,
              ),
              decoration: BoxDecoration(
                color: AppColors.resolve(context, kColorUs50F6F2FC),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.send, size: 12, color: usDark),
                  const SizedBox(width: AppSpacing.compact),
                  Flexible(
                    child: Text(
                      l10n.usJournalShared(partnerCallName),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.tiny.copyWith(
                        fontWeight: FontWeight.w600,
                        color: usDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
