part of '../mobile/home_tab_mobile_view.dart';

/// HOME-02 “Trang chủ của {bé}” (Pencil gfj2H): ảnh bìa, hồ sơ (avatar 84,
/// tên 30/800, tuổi, đếm ngược tròn tháng), 4 thao tác nhanh, hôm nay của bé,
/// chương hiện tại, những lần đầu, giọng nói mới, con lớn từng tháng, việc
/// cho bé hôm nay.
class _ChildHome extends StatelessWidget {
  const _ChildHome({required this.controller, required this.child});

  final HomeTabController controller;
  final Child child;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final router = context.router;
    final today = controller.today;
    final birth = child.birthDate;
    final stories = controller.storiesOf(child.id);
    final chapter = controller.currentChapter;
    final voice = controller.latestVoice;
    final mission = controller.childMission;
    void compose(MemoryKind kind) =>
        router.push(MemoryComposerRoute(kind: kind.name, childId: child.id));
    void openStory() => router.push(MemoryStoryRoute(childId: child.id));

    final blocks = <Widget>[
      _identity(context),
      _quickActions([
        _QuickActionTile(
          icon: LucideIcons.camera,
          label: l10n.navMemories,
          onTap: () => compose(MemoryKind.photo),
        ),
        _QuickActionTile(
          icon: LucideIcons.mic,
          label: l10n.memoriesVoices,
          onTap: () => compose(MemoryKind.voice),
        ),
        _QuickActionTile(
          icon: LucideIcons.star,
          label: l10n.commonMilestone,
          onTap: () => compose(MemoryKind.milestone),
        ),
        _QuickActionTile(
          icon: LucideIcons.mail,
          label: l10n.homeChildLetter,
          onTap: () => compose(MemoryKind.letter),
        ),
      ]),
      if (stories.isNotEmpty) ...[
        SectionHeader.medium(
          title: l10n.homeChildToday(child.name),
          actionLabel: l10n.homeStoryView,
          onAction: openStory,
        ),
        Row(
          children: [
            for (
              var index = 0;
              index < HomeTabController.todayStripCount;
              index++
            ) ...[
              if (index > 0) const SizedBox(width: AppSpacing.s2),
              Expanded(
                child: index < stories.length
                    ? GestureDetector(
                        onTap: openStory,
                        child: _Photo(
                          asset: stories[stories.length - 1 - index].asset,
                          height: 104,
                          radius: AppRadius.md,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ],
        ),
      ],
      if (chapter != null)
        _ChapterCard(controller: controller, child: child, chapter: chapter),
      if (controller.milestones.isNotEmpty) ...[
        SectionHeader.medium(
          title: l10n.homeFirstsRecent,
          actionLabel: l10n.commonAll,
          onAction: () => router.push(FirstsRoute(childId: child.id)),
        ),
        _FirstsRow(controller: controller, child: child),
      ],
      if (voice != null)
        VoiceCard(
          title: voice.title ?? voice.body ?? '',
          duration: _duration(voice.voiceDurationSec ?? 0),
          onPlay: () => router.push(MemoryDetailRoute(memoryId: voice.id)),
          onTap: () => router.push(MemoryDetailRoute(memoryId: voice.id)),
        ),
      if (birth != null) ...[
        SectionHeader.medium(
          title: l10n.homeMonthlyGrowth,
          actionLabel: l10n.homeMonthlyProgress(
            controller.monthlyDone,
            childMonthIndex(birth, today),
          ),
          onAction: () => router.push(MonthlyPhotosRoute(childId: child.id)),
        ),
        _MonthlyRow(controller: controller, child: child),
      ],
      if (mission != null) ...[
        SectionHeader.medium(
          title: l10n.homeChildMissions(child.name),
          actionLabel: l10n.navCare,
          onAction: () => _openTab(context, MainTab.care),
        ),
        MissionCard(
          title: mission.title,
          meta: missionMetaText(l10n, mission),
          done: mission.isDone,
          child: child,
          onToggle: mission.isDone
              ? null
              : () => controller.completeMission(mission),
          onTap: () => _openTab(context, MainTab.care),
        ),
      ],
    ];
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: RefreshIndicator(
        onRefresh: controller.load,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _ChildCover(controller: controller, child: child),
            Padding(
              padding: _contentPadding(context, top: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _spaced(blocks, _childBlockGap),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _identity(BuildContext context) {
    final l10n = context.l10n;
    final birth = child.birthDate;
    final today = controller.today;
    String? ageLine;
    int? daysLeft;
    var nextMonths = 0;
    if (birth != null) {
      final age = childAgeText(l10n, birth, today);
      final date = birth.toFormDate(context.localeName);
      final lunarDay = child.lunarBirthDay;
      final lunarMonth = child.lunarBirthMonth;
      ageLine = controller.showLunar && lunarDay != null && lunarMonth != null
          ? l10n.homeChildBornLunar(age, date, lunarDay, lunarMonth)
          : l10n.homeChildBorn(age, date);
      nextMonths = childAgeInMonths(birth, today) + 1;
      daysLeft = daysUntil(childMonthDate(birth, nextMonths), today);
    }
    final strong = AppColors.resolve(context, kColorSecondary7003F7A5C);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 84,
          height: 84,
          padding: const EdgeInsets.all(AppSpacing.s1),
          decoration: BoxDecoration(
            color: AppColors.resolve(context, kColorBgFFFBF7),
            shape: BoxShape.circle,
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: ChildAvatar.colorOf(child), width: 3),
            ),
            child: ChildAvatar(child: child, size: 70),
          ),
        ),
        const SizedBox(height: AppSpacing.compact),
        GestureDetector(
          onTap: () =>
              context.router.push(ChildProfileRoute(childId: child.id)),
          child: Text(
            child.name,
            style: AppTypography.adapt(
              context,
              AppTypography.display.copyWith(fontSize: 30, height: 38 / 30),
            ),
          ),
        ),
        if (ageLine != null) ...[
          const SizedBox(height: AppSpacing.compact),
          Text(
            ageLine,
            style: AppTypography.adapt(context, AppTypography.caption),
          ),
        ],
        if (daysLeft != null) ...[
          const SizedBox(height: AppSpacing.compact),
          Container(
            constraints: const BoxConstraints(minHeight: 30),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s3,
              vertical: AppSpacing.s1,
            ),
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSecondary100E4F2EA),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.partyPopper, size: 14, color: strong),
                const SizedBox(width: AppSpacing.compact),
                Flexible(
                  child: Text(
                    l10n.homeChildCountdown(daysLeft, nextMonths),
                    style: AppTypography.small.copyWith(
                      fontWeight: FontWeight.w700,
                      color: strong,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  static String _duration(int seconds) =>
      '${seconds ~/ Duration.secondsPerMinute}:'
      '${(seconds % Duration.secondsPerMinute).toString().padLeft(2, '0')}';
}
