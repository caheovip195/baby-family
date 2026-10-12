part of '../mobile/circle_home_mobile_view.dart';

/// Ký ức mới nhất của cháu (Pencil `MipJy`): ảnh 240, thân đệm 18 — “Haru ·
/// 5 tháng 6 ngày” 22/800 và chú thích 17 ““…” — Mama, 2 giờ trước”.
class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.child,
    required this.memory,
    required this.author,
    required this.today,
  });

  final Child child;
  final Memory memory;
  final String author;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final birth = child.birthDate;
    final due = child.dueDate;
    final age = birth != null
        ? childAgeText(l10n, birth, today)
        : due != null
        ? pregnancyWeekText(l10n, due, today)
        : null;
    final text = memory.body ?? memory.title;
    final photo = memory.mediaAssets.firstOrNull;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: AppColors.resolve(context, kColorBorderEADFD6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (photo != null)
            Image.asset(
              photo,
              height: 240,
              fit: BoxFit.cover,
              semanticLabel: child.name,
            ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sectionGap),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  age == null
                      ? child.name
                      : l10n.commonChildNameAge(child.name, age),
                  style: AppTypography.adapt(
                    context,
                    AppTypography.h2.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                if (text != null && text.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.compact),
                  Text(
                    l10n.cirHeroCaption(
                      text,
                      author,
                      relativeTimeText(
                        l10n,
                        memory.occurredAt,
                        today,
                        locale: context.localeName,
                      ),
                    ),
                    style: AppTypography.adapt(
                      context,
                      AppTypography.bodyLarge.copyWith(
                        height: 1.45,
                        color: kColorTextSecondary6B625B,
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
