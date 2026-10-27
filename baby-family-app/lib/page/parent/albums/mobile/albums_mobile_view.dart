import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/memory/album.dart';
import 'package:baby_family/page/parent/albums/albums_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/media_image.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_back_title_bar.dart';
import 'package:baby_family/utils/widget/app_chip.dart';
import 'package:baby_family/utils/widget/app_square_icon_button.dart';
import 'package:baby_family/utils/widget/app_text_input_sheet.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/auto_album_tile.dart';
part '../widgets/family_album_card.dart';
part '../widgets/new_album_button.dart';

/// Tiêu đề mục 18/800 Nunito (Pencil MEM-03 “Album tự động”).
const _sectionStyle = TextStyle(
  fontFamily: AppTypography.headingFamily,
  fontSize: 18,
  height: 25 / 18,
  fontWeight: FontWeight.w800,
  color: kColorTextPrimary2E2A27,
);

/// MEM-03 Album (Pencil `hZoVW`).
class AlbumsMobileView extends HookConsumerWidget {
  const AlbumsMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(albumsControllerProvider);
    final l10n = context.l10n;
    final Widget body;
    if (!controller.loaded) {
      body = const Center(child: CircleLoadingProgress());
    } else if (controller.hasError) {
      body = ErrorState(onRetry: controller.load);
    } else {
      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.s1,
          AppSpacing.screen,
          AppSpacing.s6 + MediaQuery.paddingOf(context).bottom,
        ),
        children: _content(context, controller),
      );
    }
    return BaseScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBackTitleBar(
            title: l10n.memoriesAlbum,
            trailing: AppSquareIconButton(
              icon: LucideIcons.search,
              tooltip: l10n.memSearch,
              onPressed: () => context.router.push(const MemorySearchRoute()),
            ),
          ),
          Expanded(child: body),
        ],
      ),
    );
  }

  List<Widget> _content(BuildContext context, AlbumsController controller) {
    final l10n = context.l10n;
    final auto = controller.autoAlbums;
    final half = (auto.length + 1) ~/ 2;
    Widget autoRow(List<Album> items) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          if (index > 0) const SizedBox(width: AppSpacing.itemGap),
          _AutoAlbumTile(
            album: items[index],
            meta: _autoMeta(context, controller, items[index]),
            onTap: () =>
                context.router.push(AlbumDetailRoute(albumId: items[index].id)),
          ),
        ],
      ],
    );
    final family = controller.familyAlbums;
    final items = <Widget>[
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            AppChip(
              label: l10n.commonAllFamily,
              selected: controller.childId == null,
              onTap: () => controller.selectChild(null),
            ),
            for (final child in controller.children) ...[
              const SizedBox(width: AppSpacing.s2),
              AppChip(
                label: child.name,
                selected: controller.childId == child.id,
                onTap: () => controller.selectChild(child.id),
              ),
            ],
          ],
        ),
      ),
      // Không có album tự động (gia đình mới): ẩn cả tiêu đề (BF-20261026-003).
      if (auto.isNotEmpty)
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                l10n.memAlbumsAuto,
                style: AppTypography.adapt(context, _sectionStyle),
              ),
            ),
            Text(
              l10n.memAlbumsAutoHint,
              style: AppTypography.adapt(context, AppTypography.small).copyWith(
                color: AppColors.resolve(context, kColorTextTertiary9C928A),
              ),
            ),
          ],
        ),
      if (auto.isNotEmpty)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              autoRow(auto.take(half).toList()),
              const SizedBox(height: AppSpacing.cardInset),
              autoRow(auto.skip(half).toList()),
            ],
          ),
        ),
      Row(
        children: [
          Expanded(
            child: Text(
              l10n.memAlbumsFamily,
              style: AppTypography.adapt(context, _sectionStyle),
            ),
          ),
          const SizedBox(width: AppSpacing.s2),
          _NewAlbumButton(onTap: () => _createAlbum(context, controller)),
        ],
      ),
      if (family.isEmpty)
        EmptyState(
          title: l10n.memAlbumsEmpty,
          description: l10n.memAlbumsEmptyDescription,
        ),
      for (var index = 0; index < family.length; index += 2)
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _familyCard(context, family[index])),
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                child: index + 1 < family.length
                    ? _familyCard(context, family[index + 1])
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
    ];
    return [
      for (var index = 0; index < items.length; index++) ...[
        if (index > 0) const SizedBox(height: AppSpacing.cardInset),
        items[index],
      ],
    ];
  }

  Widget _familyCard(BuildContext context, Album album) {
    final l10n = context.l10n;
    return _FamilyAlbumCard(
      album: album,
      meta: album.visibility == MemoryVisibility.parents
          ? l10n.memAlbumParentsMeta(album.memoryCount)
          : l10n.memoriesCount(album.memoryCount),
      onTap: () => context.router.push(AlbumDetailRoute(albumId: album.id)),
    );
  }

  String _autoMeta(
    BuildContext context,
    AlbumsController controller,
    Album album,
  ) {
    final l10n = context.l10n;
    final count = album.memoryCount;
    return switch (album.autoCode) {
      'monthly' => l10n.memAlbumMonthlyMeta(
        controller.childById(album.childIds.firstOrNull)?.name ?? '',
        count,
      ),
      'firsts' => l10n.memAlbumFirstsMeta(count),
      'videos' => l10n.memAlbumVideosMeta(count),
      'quotes' => l10n.memAlbumQuotesMeta(count),
      'voices' => l10n.memAlbumVoicesMeta(count),
      _ => l10n.memoriesCount(count),
    };
  }

  Future<void> _createAlbum(
    BuildContext context,
    AlbumsController controller,
  ) async {
    final l10n = context.l10n;
    final router = context.router;
    final title = await showAppTextInputSheet(
      context,
      title: l10n.memAlbumNew,
      hint: l10n.memAlbumNameHint,
      actionLabel: l10n.memAlbumCreate,
    );
    if (title == null) {
      return;
    }
    final album = await controller.createAlbum(title);
    if (album != null) {
      await router.push(AlbumDetailRoute(albumId: album.id));
    }
  }
}
