part of '../mobile/home_tab_mobile_view.dart';

/// HOME-01 “Cả nhà” (Pencil ClpJ6 / cuộn đầy đủ uEPMP; banner gói SUB-06
/// `Fxgro` khi gia hạn chưa thành công): lời chào, story các
/// con, ngày ảnh tháng, Papa & Mama, nhiệm vụ hôm nay, gợi ý ghi lại, Mới
/// trong nhà (nhóm ảnh, câu nói, ký ức), tuần này, cây gia đình.
class _FamilyHome extends StatelessWidget {
  const _FamilyHome({required this.controller, required this.offline});

  final HomeTabController controller;
  final bool offline;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final me = controller.me;
    final hour = controller.now.hour;
    final (greeting, emoji) = switch (hour) {
      < 11 => (l10n.homeMorning, '☀️'),
      < 18 => (l10n.homeAfternoon, '🌤️'),
      _ => (l10n.homeEvening, '🌙'),
    };
    final special = controller.specialChild;
    final couple = controller.couple;
    final group = controller.feedGroup;
    final quote = controller.feedQuote;
    final memory = controller.feedMemory;
    final week = controller.week;
    final tree = controller.tree;
    final blocks = <Widget>[
      if (me != null)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: AppTypography.adapt(
                context,
                AppTypography.text14.copyWith(color: kColorTextSecondary6B625B),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              l10n.homeGreetingName(me.callName, me.displayName, emoji),
              style: AppTypography.adapt(context, AppTypography.h1),
            ),
          ],
        ),
      if (controller.showPaymentIssue)
        PlanStatusBanner(
          title: l10n.subIssueTitle,
          message: l10n.subIssueBody(
            planTitle(l10n, controller.planState ?? PlanState.family),
          ),
          actionLabel: l10n.subIssueAction,
          onAction: () => context.router.push(const FamilyPlanRoute()),
          onClose: controller.dismissPaymentIssue,
        ),
      _StoryRow(controller: controller),
      if (special != null)
        _MonthlyDayCard(controller: controller, child: special),
      if (couple?.partnerCheckin != null)
        _CoupleCard(controller: controller, checkin: couple!.partnerCheckin!),
      if (controller.board != null && !controller.board!.isEmpty) ...[
        SectionHeader(
          title: l10n.homeMissions,
          actionLabel: l10n.commonSeeAll,
          onAction: () => _openTab(context, MainTab.care),
        ),
        _TodayMissionsCard(controller: controller),
      ],
      if (controller.prompt != null) _PromptCard(controller: controller),
      if (group != null || quote != null || memory != null)
        SectionHeader.large(
          title: l10n.homeRecent,
          actionLabel: l10n.navMemories,
          onAction: () => _openTab(context, MainTab.memories),
        ),
      if (group != null) _GroupCard(controller: controller, memory: group),
      if (quote != null) _quoteCard(context, quote),
      if (memory != null) _memoryCard(context, memory),
      if (week != null) _WeekCard(week: week),
      if (tree != null) _TreeMiniCard(tree: tree),
    ];
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          _HomeAppBar(controller: controller),
          if (offline)
            OfflineBanner(
              pendingUploads: controller.pendingSync,
              onRetry: controller.load,
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.load,
              child: ListView(
                padding: _contentPadding(context),
                children: _spaced(blocks, _blockGap),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quoteCard(BuildContext context, Memory quote) {
    final l10n = context.l10n;
    final child = controller.childById(quote.childIds.firstOrNull);
    final birth = child?.birthDate;
    final recorded = l10n.homeRecordedBy(
      controller.callNameOf(quote.authorId),
      relativeTimeText(
        l10n,
        quote.occurredAt,
        controller.now,
        locale: context.localeName,
      ),
    );
    final meta = [
      ?child?.name,
      if (birth != null) childAgeText(l10n, birth, controller.today),
      recorded,
    ].reduce(l10n.commonDotJoin);
    final reactors = quote.reactorNames;
    final emojis = quote.reactions.keys.join(' ');
    return QuoteCard(
      quote: quote.body ?? '',
      meta: meta,
      avatar: child == null ? null : ChildAvatar(child: child, size: 24),
      reactions: reactors.isEmpty
          ? null
          : '$emojis  ${l10n.homeReactedBy(reactors.first, reactors.length - 1)}',
      onTap: () => context.router.push(MemoryDetailRoute(memoryId: quote.id)),
    );
  }

  Widget _memoryCard(BuildContext context, Memory memory) {
    final l10n = context.l10n;
    final names = memory.childIds
        .map((id) => controller.childById(id)?.name)
        .nonNulls
        .toList();
    final meta = [
      if (names.isNotEmpty) names.reduce(l10n.commonNamesAnd),
      l10n.homePostedBy(controller.callNameOf(memory.authorId)),
      relativeTimeText(
        l10n,
        memory.createdAt ?? memory.occurredAt,
        controller.now,
        locale: context.localeName,
      ),
    ].reduce(l10n.commonDotJoin);
    final preview = memory.perspectivePreview;
    final author = controller.callNameOf(memory.authorId);
    final teller = controller.callNameOf(memory.perspectiveAuthorId);
    String initial(String name) =>
        name.isEmpty ? '' : name.characters.first.toUpperCase();
    final total = memory.reactions.values.fold<int>(0, (a, b) => a + b);
    return MemoryCard(
      caption: memory.title ?? memory.body ?? '',
      meta: meta,
      photoAsset: memory.mediaAssets.firstOrNull,
      bothTellPreview: preview == null
          ? null
          : l10n.homePerspectiveQuote(teller, _ellipsize(preview)),
      bothTellInitials: (initial(author), initial(teller)),
      reactionEmojis: memory.reactions.isEmpty
          ? null
          : memory.reactions.keys.join(),
      reactionCount: total,
      onTap: () => context.router.push(MemoryDetailRoute(memoryId: memory.id)),
    );
  }

  /// Trích câu đầu của góc nhìn (“Anh đứng sau cầm máy mà run tay…”).
  static String _ellipsize(String text) {
    final end = text.indexOf(RegExp('[.!?]'));
    return end < 0 ? text : '${text.substring(0, end)}…';
  }
}
