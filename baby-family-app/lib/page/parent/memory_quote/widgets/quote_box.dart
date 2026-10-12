part of '../mobile/memory_quote_mobile_view.dart';

/// Ô trích dẫn (`oupXB`): nền `primary-100` bo 20, đệm 18, cách 8; icon
/// `quote` 24 `primary-500`; câu nói 22/800 Nunito (1.3); “— Hana, 2 tuổi
/// 4 tháng · hôm nay” 13/600 `primary-700`.
class _QuoteBox extends StatelessWidget {
  const _QuoteBox({required this.controller});

  final MemoryQuoteController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final child = controller.child;
    final birth = child?.birthDate;
    final style = AppTypography.adapt(
      context,
      AppTypography.h2.copyWith(fontWeight: FontWeight.w800, height: 1.3),
    );
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorPrimary100FFE3DC),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            LucideIcons.quote,
            size: 24,
            color: AppColors.resolve(context, kColorPrimary500EE7B67),
          ),
          const SizedBox(height: AppSpacing.s2),
          TextField(
            controller: controller.quote,
            maxLines: null,
            style: style,
            decoration: InputDecoration(
              hintText: l10n.memoriesQuoteHint,
              hintStyle: style.copyWith(
                color: AppColors.resolve(context, kColorTextTertiary9C928A),
              ),
              filled: false,
              isDense: true,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          if (child != null) ...[
            const SizedBox(height: AppSpacing.s2),
            Text(
              l10n.memQuoteAge(
                child.name,
                birth == null
                    ? ''
                    : childAgeText(l10n, birth, controller.today),
                l10n.memTodayLower,
              ),
              style: AppTypography.adapt(
                context,
                AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 16 / 13,
                  color: kColorPrimary700A2402F,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
