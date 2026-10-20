part of '../mobile/album_detail_mobile_view.dart';

/// Bìa album (`cZ61e`): ảnh cao 260; nút tròn 40 (`#2E2A2766`, icon trắng
/// 22) back • + • ⋯; lớp phủ đáy 110 (trong suốt → `#2E2A27B3`) chứa tên
/// 24/800 trắng + meta 13/500 `#FFFFFFDD`, đệm 0/20/16/20, cách 4.
class _AlbumCover extends StatelessWidget {
  const _AlbumCover({
    required this.album,
    required this.meta,
    required this.onAdd,
    required this.onMore,
  });

  final Album album;
  final String meta;
  final VoidCallback onAdd;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final top = MediaQuery.paddingOf(context).top;
    final asset = album.coverAsset;
    Widget circle(IconData icon, String label, VoidCallback onTap) => Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: kColorOverlay2E2A27Alpha40,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 22, color: kColorWhite),
        ),
      ),
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: SizedBox(
        height: 260,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (asset != null)
              Image(image: mediaImageProvider(asset), fit: BoxFit.cover)
            else
              ColoredBox(
                color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                constraints: const BoxConstraints(minHeight: 110),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.s4,
                  AppSpacing.screen,
                  AppSpacing.s4,
                ),
                alignment: Alignment.bottomLeft,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      kColorCoverScrim2E2A27Alpha00,
                      kColorCoverScrim2E2A27Alpha70,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      album.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.h1.copyWith(
                        fontSize: 24,
                        height: 33 / 24,
                        color: kColorWhite,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s1),
                    Text(
                      meta,
                      style: AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w500,
                        height: 16 / 13,
                        color: kColorWhiteAlpha87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: top + AppSpacing.s6,
              left: AppSpacing.s4,
              right: AppSpacing.s4,
              child: Row(
                children: [
                  circle(
                    LucideIcons.chevronLeft,
                    l10n.commonBack,
                    () => context.router.maybePop(),
                  ),
                  const Spacer(),
                  circle(LucideIcons.plus, l10n.stateAddMemory, onAdd),
                  const SizedBox(width: AppSpacing.itemGap),
                  circle(LucideIcons.ellipsis, l10n.memMoreActions, onMore),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
