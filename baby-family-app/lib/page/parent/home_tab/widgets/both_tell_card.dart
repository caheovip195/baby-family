part of '../mobile/home_tab_mobile_view.dart';

/// “Cả hai cùng kể” thai kỳ (Pencil `hdTaP`): nhãn 10/800 `us-700` +
/// `heart-handshake`, tiêu đề 17/800, mỗi người một dòng (avatar chữ 24 — Mama
/// `primary-500`, Papa `secondary-500` — và lời kể 13, cao dòng 1.4).
class _BothTellCard extends StatelessWidget {
  const _BothTellCard({required this.controller, required this.memory});

  final HomeTabController controller;
  final Memory memory;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final us = AppColors.resolve(context, kColorUs7006A549F);
    final week = memory.pregnancyWeek;
    final kicker = week == null
        ? l10n.memoriesTogether
        : l10n.homeBothTellWeek(week);
    final voices = <(String, String)>[
      (memory.authorId, memory.body ?? ''),
      for (final item in controller.bothTellPerspectives)
        (item.authorId, item.body),
    ];
    Widget voice(String userId, String text) {
      final member = controller.memberByUserId(userId);
      final name = controller.callNameOf(userId);
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.resolve(
                context,
                member?.role == FamilyRole.mother
                    ? kColorPrimary500EE7B67
                    : kColorSecondary5006FAE8E,
              ),
            ),
            child: Text(
              name.isEmpty ? '' : name.characters.first,
              style: AppTypography.micro.copyWith(
                fontWeight: FontWeight.w800,
                height: 1,
                color: kColorWhite,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s2),
          Expanded(
            child: Text(
              l10n.commonQuoted(text),
              style: AppTypography.adapt(
                context,
                AppTypography.caption.copyWith(height: 1.4),
              ),
            ),
          ),
        ],
      );
    }

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.s4),
      onTap: () => context.router.push(MemoryDetailRoute(memoryId: memory.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.heartHandshake, size: 14, color: us),
              const SizedBox(width: AppSpacing.compact),
              Flexible(
                child: Text(
                  kicker.toUpperCase(),
                  style: AppTypography.micro.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: us,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.itemGap),
          Text(
            memory.title ?? '',
            style: AppTypography.adapt(context, AppTypography.title17),
          ),
          for (final (userId, text) in voices) ...[
            const SizedBox(height: AppSpacing.itemGap),
            voice(userId, text),
          ],
        ],
      ),
    );
  }
}
