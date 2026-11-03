part of '../mobile/memory_detail_mobile_view.dart';

/// Khối “Papa kể” (`BVXxG`): nền `us-50`, viền `us-100`, bo 16, đệm 14,
/// cách 10; avatar 32 `secondary-500` chữ trắng; “Papa kể” 14/700 `us-700`,
/// “Góc nhìn thứ hai · 1 giờ trước” 11; huy hiệu “Cả hai cùng kể”; nội dung
/// 14 (1.5); ảnh 72 bo 10 cách 6.
class _PerspectiveBlock extends StatelessWidget {
  const _PerspectiveBlock({
    required this.perspective,
    required this.controller,
    this.onTap,
  });

  final MemoryPerspective perspective;
  final MemoryDetailController controller;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final author = controller.memberByUser(perspective.authorId);
    final callName = author?.callName ?? '';
    final accent = AppColors.resolve(context, kColorUs7006A549F);
    return Material(
      color: AppColors.resolve(context, kColorUs50F6F2FC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: AppColors.resolve(context, kColorUs100EAE2F8)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.resolve(
                        context,
                        kColorSecondary5006FAE8E,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      callName.characters.firstOrNull ?? '',
                      style: AppTypography.title16.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: kColorWhite,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.itemGap),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.memAuthorTells(callName),
                          style: AppTypography.text14.copyWith(
                            fontWeight: FontWeight.w700,
                            color: accent,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          l10n.memSecondPerspective(
                            memoryRelativeTime(
                              l10n,
                              perspective.createdAt,
                              controller.now,
                            ),
                          ),
                          style: AppTypography.adapt(
                            context,
                            AppTypography.tiny.copyWith(
                              color: kColorTextSecondary6B625B,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.itemGap),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s2,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.resolve(context, kColorUs100EAE2F8),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      l10n.memoriesTogether,
                      style: AppTypography.micro.copyWith(
                        fontWeight: FontWeight.w800,
                        color: accent,
                      ),
                    ),
                  ),
                ],
              ),
              if (perspective.body.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.itemGap),
                Text(
                  perspective.body,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.text14.copyWith(height: 1.5),
                  ),
                ),
              ],
              // MEM-24 ghi âm góc nhìn (BF-20261030-004).
              if (perspective.voiceUrl case final url?) ...[
                const SizedBox(height: AppSpacing.itemGap),
                PlayableVoiceCard(
                  title: l10n.memAuthorTells(callName),
                  duration: memoryDuration(perspective.voiceDurationSec ?? 0),
                  url: url,
                ),
              ],
              if (perspective.mediaAssets.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.itemGap),
                Wrap(
                  spacing: AppSpacing.compact,
                  runSpacing: AppSpacing.compact,
                  children: [
                    for (final (index, asset)
                        in perspective.mediaAssets.indexed)
                      GestureDetector(
                        key: ValueKey('perspective-media-$index'),
                        // MEM-08 cho ảnh/video của góc nhìn (BF-20261030-008).
                        onTap: () => context.router.push(
                          PhotoViewerRoute(
                            memoryId: perspective.memoryId,
                            index: index,
                            perspectiveId: perspective.id,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (isLocalVideo(asset))
                                Container(
                                  width: 72,
                                  height: 72,
                                  color: AppColors.resolve(
                                    context,
                                    kColorTextPrimary2E2A27,
                                  ),
                                )
                              else
                                Image(
                                  image: mediaImageProvider(asset),
                                  width: 72,
                                  height: 72,
                                  fit: BoxFit.cover,
                                ),
                              if (isLocalVideo(asset) ||
                                  (index < perspective.mediaVideos.length &&
                                      perspective.mediaVideos[index] != null))
                                const Icon(
                                  LucideIcons.circlePlay,
                                  color: kColorWhite,
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
