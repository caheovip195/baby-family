part of '../mobile/home_tab_mobile_view.dart';

/// Thẻ nhóm ảnh (Pencil `CbhWU`): avatar người đăng 32 + “Papa vừa thêm 6 ảnh
/// của Haru” 14/700 + dòng phụ 12; lưới 3 ảnh cao 96 bo 12 cách 6, ảnh cuối
/// phủ “+3”.
class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.controller, required this.memory});

  final HomeTabController controller;
  final Memory memory;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final author = controller.memberByUserId(memory.authorId);
    final callName = controller.callNameOf(memory.authorId);
    final names = memory.childIds
        .map((id) => controller.childById(id)?.name)
        .nonNulls
        .toList();
    final photos = memory.mediaAssets
        .take(HomeTabController.groupGridCount)
        .toList();
    final more = memory.mediaAssets.length - photos.length;
    final subtitle = [
      ?memory.title,
      relativeTimeText(
        l10n,
        memory.createdAt ?? memory.occurredAt,
        controller.now,
        locale: context.localeName,
      ),
    ].reduce(l10n.commonDotJoin);
    return AppCard(
      onTap: () => context.router.push(MemoryDetailRoute(memoryId: memory.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.resolve(
                    context,
                    author?.role == FamilyRole.mother
                        ? kColorPrimary500EE7B67
                        : kColorSecondary5006FAE8E,
                  ),
                ),
                child: Text(
                  callName.isEmpty ? '' : callName.characters.first,
                  style: AppTypography.h3.copyWith(
                    fontSize: 13,
                    height: 1,
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
                      l10n.homeFeedAddedPhotos(
                        callName,
                        memory.mediaAssets.length,
                        names.isEmpty ? '' : names.reduce(l10n.commonNamesAnd),
                      ),
                      style: AppTypography.adapt(
                        context,
                        AppTypography.text14.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      style: AppTypography.adapt(context, AppTypography.small),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.itemGap),
          Row(
            children: [
              for (var index = 0; index < photos.length; index++) ...[
                if (index > 0) const SizedBox(width: AppSpacing.compact),
                Expanded(
                  child: _Photo(
                    asset: photos[index],
                    height: 96,
                    radius: AppRadius.tile,
                    overlay: index == photos.length - 1 && more > 0
                        ? ColoredBox(
                            color: kColorOverlay2E2A27Alpha50,
                            child: Center(
                              child: Text(
                                l10n.homeMorePhotos(more),
                                style: AppTypography.title20.copyWith(
                                  color: kColorWhite,
                                ),
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
