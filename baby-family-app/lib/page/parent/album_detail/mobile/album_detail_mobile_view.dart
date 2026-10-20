import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/memory/album.dart';
import 'package:baby_family/data/model/memory/album_item.dart';
import 'package:baby_family/page/parent/album_detail/album_detail_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/media_image.dart';
import 'package:baby_family/utils/helper/memory_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_dialog.dart';
import 'package:baby_family/utils/widget/app_text_input_sheet.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/album_cover.dart';
part '../widgets/album_menu_item.dart';
part '../widgets/album_meta_chip.dart';
part '../widgets/album_tile.dart';

/// MEM-03a Chi tiết album (Pencil `OloCj`); menu ⋯ mở dạng bottom sheet.
class AlbumDetailMobileView extends HookConsumerWidget {
  const AlbumDetailMobileView({required this.albumId, super.key});

  final String albumId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(albumDetailControllerProvider(albumId));
    final album = controller.album;
    if (!controller.loaded) {
      return const BaseScaffold(body: Center(child: CircleLoadingProgress()));
    }
    if (controller.hasError || album == null) {
      return BaseScaffold(
        appBar: AppBar(),
        body: ErrorState(onRetry: controller.load),
      );
    }
    final l10n = context.l10n;
    final items = album.items;
    return BaseScaffold(
      body: ListView(
        padding: EdgeInsets.only(
          bottom: AppSpacing.s5 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          _AlbumCover(
            album: album,
            meta: l10n.memAlbumDetailMeta(
              album.memoryCount,
              _range(l10n.localeName, album),
            ),
            onAdd: () => _addMemory(context, controller),
            onMore: () => _openMenu(context, controller),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.cardInset,
              AppSpacing.screen,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: AppSpacing.s2,
                  runSpacing: AppSpacing.s2,
                  children: [
                    for (final child in controller.albumChildren)
                      _childChip(child),
                    if (controller.creator case final creator?)
                      _AlbumMetaChip(
                        icon: LucideIcons.user,
                        label: l10n.memAlbumCreatedBy(creator.callName),
                        background: kColorSurfaceVariantF7F1EC,
                        foreground: kColorTextSecondary6B625B,
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s3),
                Text(
                  l10n.memAlbumPermissionNote,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.small.copyWith(
                      color: kColorTextTertiary9C928A,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s3),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: AppSpacing.s3,
                    crossAxisSpacing: AppSpacing.s1,
                    childAspectRatio: 114 / 112,
                  ),
                  itemBuilder: (_, index) => _AlbumTile(
                    item: items[index],
                    first: index == 0,
                    onTap: items[index].memoryId == null
                        ? null
                        : () => context.router.push(
                            PhotoViewerRoute(memoryId: items[index].memoryId!),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Chip bé theo màu bé (Pencil: Hana `primary`, Haru `secondary`).
  Widget _childChip(Child child) {
    final (background, foreground) = switch (child.colorIndex % 3) {
      0 => (kColorPrimary50FFF4F1, kColorPrimary700A2402F),
      1 => (kColorSecondary100E4F2EA, kColorSecondary7003F7A5C),
      _ => (kColorUs50F6F2FC, kColorUs7006A549F),
    };
    return _AlbumMetaChip(
      icon: LucideIcons.baby,
      label: child.name,
      background: background,
      foreground: foreground,
    );
  }

  static String _range(String locale, Album album) {
    final start = album.startDate;
    final end = album.endDate ?? start;
    return start == null || end == null ? '' : start.toRangeLabel(end, locale);
  }

  Future<void> _addMemory(
    BuildContext context,
    AlbumDetailController controller,
  ) => context.router.push(
    MemoryComposerRoute(
      kind: MemoryKind.photo.name,
      childId: controller.album?.childIds.firstOrNull,
    ),
  );

  Future<void> _openMenu(
    BuildContext context,
    AlbumDetailController controller,
  ) async {
    final album = controller.album;
    if (album == null) {
      return;
    }
    final l10n = context.l10n;
    final action = await showAppBottomSheet<int>(
      context,
      builder: (sheetContext) => AppBottomSheet(
        gap: 0,
        children: [
          _AlbumMenuItem(
            icon: LucideIcons.pencil,
            label: l10n.memAlbumRename,
            onTap: () => Navigator.of(sheetContext).pop(0),
          ),
          _AlbumMenuItem(
            icon: LucideIcons.image,
            label: l10n.memAlbumChangeCover,
            onTap: () => Navigator.of(sheetContext).pop(1),
          ),
          _AlbumMenuItem(
            icon: LucideIcons.imagePlus,
            label: l10n.stateAddMemory,
            onTap: () => Navigator.of(sheetContext).pop(2),
          ),
          _AlbumMenuItem(
            icon: LucideIcons.trash2,
            label: l10n.memAlbumDelete,
            note: l10n.memAlbumDeleteNote,
            destructive: true,
            onTap: () => Navigator.of(sheetContext).pop(3),
          ),
        ],
      ),
    );
    if (!context.mounted || action == null) {
      return;
    }
    switch (action) {
      case 0:
        final title = await showAppTextInputSheet(
          context,
          title: l10n.memAlbumRename,
          hint: l10n.memAlbumNameHint,
          initialValue: album.title,
          actionLabel: l10n.commonSave,
        );
        if (title != null) {
          await controller.rename(title);
        }
      case 1:
        await _pickCover(context, controller, album);
      case 2:
        await _addMemory(context, controller);
      default:
        await _confirmDelete(context, controller, album);
    }
  }

  Future<void> _pickCover(
    BuildContext context,
    AlbumDetailController controller,
    Album album,
  ) async {
    final asset = await showAppBottomSheet<String>(
      context,
      builder: (sheetContext) => AppBottomSheet(
        title: sheetContext.l10n.memAlbumChangeCover,
        children: [
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.s1,
            crossAxisSpacing: AppSpacing.s1,
            children: [
              for (final item in album.items)
                _AlbumTile(
                  item: item,
                  first: false,
                  selected: item.asset == album.coverAsset,
                  onTap: () => Navigator.of(sheetContext).pop(item.asset),
                ),
            ],
          ),
        ],
      ),
    );
    if (asset != null) {
      await controller.changeCover(asset);
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    AlbumDetailController controller,
    Album album,
  ) async {
    final l10n = context.l10n;
    final router = context.router;
    final confirmed = await AppDialog.show<bool>(
      context: context,
      title: l10n.memAlbumDeleteConfirm(album.title),
      content: l10n.memAlbumDeleteNote,
      actions: [
        Builder(
          builder: (dialogContext) => TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              l10n.memAlbumDelete,
              style: AppTypography.label.copyWith(
                color: AppColors.resolve(context, kColorErrorD14B4B),
              ),
            ),
          ),
        ),
        Builder(
          builder: (dialogContext) => TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
        ),
      ],
    );
    if (confirmed ?? false) {
      if (await controller.delete()) {
        await router.maybePop();
      }
    }
  }
}
