part of '../mobile/child_profile_mobile_view.dart';

/// Phần nội dung dưới đầu trang (Pencil `i1YvnP`, cách 16).
class _ProfileBody extends StatelessWidget {
  const _ProfileBody({
    required this.child,
    required this.profile,
    required this.today,
    required this.onArchive,
  });

  final Child child;
  final ChildProfile profile;
  final DateTime today;
  final VoidCallback onArchive;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const gap = SizedBox(height: AppSpacing.s4);
    const rowPadding = EdgeInsets.symmetric(
      horizontal: AppSpacing.s4,
      vertical: AppSpacing.s3,
    );
    final birth = child.birthDate;
    final due = child.dueDate;
    final age = child.isPregnancy
        ? (due == null ? null : pregnancyWeekText(l10n, due, today))
        : (birth == null ? null : childAgeText(l10n, birth, today));
    final fullLine = [?profile.fullName, ?age];
    String dayTitle(DateTime date) => l10n.calendarDayTitle(
      l10n.careWeekdayTitle(weekdayCode(date.weekday)),
      date.toFormDate(l10n.localeName),
    );
    final date = child.isPregnancy ? due : birth;
    final infoRows = <Widget>[
      if (date != null)
        AppSettingRow(
          icon: LucideIcons.cake,
          iconSize: 18,
          iconColor: kColorTextTertiary9C928A,
          label: child.isPregnancy ? l10n.childDueDate : l10n.childBirthDate,
          title: dayTitle(date),
          subtitle: l10n.childLunarBirth(lunarDateWithYearText(l10n, date)),
          padding: rowPadding,
        ),
      if (child.birthTime != null)
        AppSettingRow(
          icon: LucideIcons.alarmClock,
          iconSize: 18,
          iconColor: kColorTextTertiary9C928A,
          label: l10n.childBirthTime,
          title: child.birthTime!,
          subtitle: profile.showBirthTimeToRelatives
              ? l10n.childBirthTimeShown
              : l10n.childBirthTimeHidden,
          padding: rowPadding,
        ),
      if (profile.gestationWeeks != null)
        AppSettingRow(
          icon: LucideIcons.sprout,
          iconSize: 18,
          iconColor: kColorTextTertiary9C928A,
          label: l10n.childOriginPregnancy,
          title: l10n.childOriginPregnancyValue(profile.gestationWeeks!),
          padding: rowPadding,
        ),
    ];
    final likes = [
      (LucideIcons.utensils, l10n.childFavFood, profile.favoriteFood),
      (LucideIcons.rabbit, l10n.childFavToy, profile.favoriteToy),
      (
        LucideIcons.music,
        l10n.childFavSong,
        profile.favoriteSong == null
            ? null
            : l10n.childQuoted(profile.favoriteSong!),
      ),
    ].where((item) => item.$3 != null).toList();
    Widget card(List<Widget> rows) => AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (final (index, row) in rows.indexed)
            DecoratedBox(
              decoration: BoxDecoration(
                border: index < rows.length - 1
                    ? Border(
                        bottom: BorderSide(
                          color: AppColors.resolve(context, kColorBorderEADFD6),
                        ),
                      )
                    : null,
              ),
              child: row,
            ),
        ],
      ),
    );
    final story = profile.nameStory;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: AppSpacing.s2,
          runSpacing: AppSpacing.s1,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              child.name,
              style: AppTypography.adapt(
                context,
                AppTypography.display.copyWith(fontSize: 28, height: 38 / 28),
              ),
            ),
            Container(
              height: 22,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s2),
              decoration: BoxDecoration(
                color: AppColors.resolve(context, kColorSecondary100E4F2EA),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ChildAvatar.colorOf(child),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s1),
                  Text(
                    l10n.childColorName('${child.colorIndex}'),
                    style: AppTypography.adapt(
                      context,
                      AppTypography.tiny.copyWith(
                        fontWeight: FontWeight.w700,
                        color: kColorSecondary7003F7A5C,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (fullLine.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.s1),
          Text(
            fullLine.reduce(l10n.commonDotJoin),
            style: AppTypography.adapt(
              context,
              AppTypography.text14.copyWith(
                fontWeight: FontWeight.w500,
                color: kColorTextSecondary6B625B,
              ),
            ),
          ),
        ],
        gap,
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (index, (icon, value, label)) in [
                (
                  LucideIcons.images,
                  profile.memoryCount,
                  l10n.childStatMemories,
                ),
                (
                  LucideIcons.flag,
                  profile.milestoneCount,
                  l10n.childStatMilestones,
                ),
                (LucideIcons.mail, profile.letterCount, l10n.childStatLetters),
              ].indexed) ...[
                if (index > 0) const SizedBox(width: AppSpacing.itemGap),
                Expanded(
                  child: _ProfileStatTile(
                    icon: icon,
                    value: value,
                    label: label,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (infoRows.isNotEmpty) ...[gap, card(infoRows)],
        if (story != null) ...[
          gap,
          AppCapsLabel(l10n.childNameStory),
          gap,
          Container(
            padding: const EdgeInsets.all(AppSpacing.s4),
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSecondary100E4F2EA),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  LucideIcons.quote,
                  size: 18,
                  color: AppColors.resolve(context, kColorSecondary7003F7A5C),
                ),
                const SizedBox(height: AppSpacing.s2),
                Text(
                  story,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.text14.copyWith(height: 1.5),
                  ),
                ),
                if (profile.nameGivenBy.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.s2),
                  Text(
                    l10n.childNameGivenBy(
                      profile.nameGivenBy.reduce(l10n.childNamesAnd),
                    ),
                    style: AppTypography.adapt(
                      context,
                      AppTypography.small.copyWith(
                        fontWeight: FontWeight.w600,
                        color: kColorSecondary7003F7A5C,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
        if (likes.isNotEmpty) ...[
          gap,
          AppCapsLabel(l10n.childLikes(child.name)),
          gap,
          card([
            for (final (icon, label, value) in likes)
              AppSettingRow(
                icon: icon,
                iconSize: 18,
                iconColor: kColorTextTertiary9C928A,
                label: label,
                title: value!,
                padding: rowPadding,
              ),
          ]),
        ],
        gap,
        AppCapsLabel(l10n.childRelativesSee(child.name)),
        gap,
        _ProfileRelativesRow(
          names: profile.relativeViewerNames,
          onTap: () => context.router.push(const FamilyRoute()),
        ),
        gap,
        Center(
          child: TextButton.icon(
            onPressed: onArchive,
            icon: Icon(
              LucideIcons.archive,
              size: 16,
              color: AppColors.resolve(context, kColorTextSecondary6B625B),
            ),
            label: Text(
              l10n.childArchiveAction,
              style: AppTypography.adapt(
                context,
                AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
