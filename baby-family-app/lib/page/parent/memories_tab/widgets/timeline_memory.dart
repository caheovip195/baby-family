part of '../mobile/memories_tab_mobile_view.dart';

/// Một ký ức trên dòng thời gian — chọn thẻ theo loại: ảnh (MemoryCard),
/// ghi âm (VoiceCard), câu nói (QuoteCard), kỷ vật/thư/nhật ký
/// ([_TaggedMemoryCard]), cột mốc ([_MilestoneMemoryCard]).
class _TimelineMemory extends StatelessWidget {
  const _TimelineMemory({required this.memory, required this.controller});

  final Memory memory;
  final MemoriesTabController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    void open() => context.router.push(MemoryDetailRoute(memoryId: memory.id));
    final author = controller.memberByUser(memory.authorId)?.callName ?? '';
    final time = memoryRelativeTime(
      l10n,
      memory.createdAt ?? memory.occurredAt,
      controller.now,
    );
    final photo = memory.mediaAssets.firstOrNull;
    final caption = memory.title ?? memory.body ?? '';
    switch (memory.kind) {
      case MemoryKind.voice:
        return VoiceCard(
          title: caption,
          duration: memoryDuration(memory.voiceDurationSec ?? 0),
          onTap: open,
        );
      case MemoryKind.quote:
        final child = controller.childById(memory.childIds.firstOrNull);
        final birth = child?.birthDate;
        return QuoteCard(
          quote: memory.body ?? '',
          avatar: child == null ? null : ChildAvatar(child: child, size: 24),
          meta: l10n.memQuoteMeta(
            child?.name ?? '',
            birth == null ? '' : childAgeText(l10n, birth, memory.occurredAt),
            author,
            time.toLowerCase(),
          ),
          onTap: open,
        );
      case MemoryKind.keepsake:
        return _TaggedMemoryCard(
          icon: LucideIcons.gem,
          tag: l10n.memoriesKeepsakes,
          title: caption,
          subtitle: memory.body == null
              ? author
              : l10n.memQuotedBy(memory.body!, author),
          photo: photo,
          onTap: open,
        );
      case MemoryKind.letter:
        final sealed = memory.sealedUntil;
        return _TaggedMemoryCard(
          icon: LucideIcons.mail,
          tag: l10n.commonLetter,
          title: caption,
          subtitle: sealed != null && sealed.isAfter(controller.now)
              ? l10n.memLetterSealed(sealed.toFormDate(context.localeName))
              : (memory.body ?? '').firstSentence,
          photo: photo,
          onTap: open,
        );
      case MemoryKind.diary when photo == null:
        return _TaggedMemoryCard(
          icon: LucideIcons.notebookPen,
          tag: l10n.commonDiary,
          title: caption,
          subtitle: (memory.body ?? '').firstSentence,
          onTap: open,
        );
      case MemoryKind.milestone:
        return _MilestoneMemoryCard(
          memory: memory,
          controller: controller,
          onTap: open,
        );
      default:
        final children = memory.childIds
            .map((id) => controller.childById(id)?.name)
            .nonNulls
            .join(' & ');
        final partner = controller.memberByUser(memory.perspectiveAuthorId);
        final preview = memory.perspectivePreview;
        final reactions = memory.reactions.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        return MemoryCard(
          caption: caption,
          photoAsset: photo,
          meta: l10n.memCardMeta(children, author, time),
          bothTellPreview: memory.bothTell && preview != null
              ? l10n.memBothTellPreview(
                  partner?.callName ?? '',
                  preview.firstSentenceExcerpt,
                )
              : null,
          bothTellInitials: (
            author.characters.firstOrNull ?? '',
            partner?.callName.characters.firstOrNull ?? '',
          ),
          reactionEmojis: reactions.isEmpty
              ? null
              : reactions.map((entry) => entry.key).join(),
          reactionCount: memory.reactionTotal,
          onTap: open,
        );
    }
  }
}
