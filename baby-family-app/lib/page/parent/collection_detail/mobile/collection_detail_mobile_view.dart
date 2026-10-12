import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/page/parent/collection_detail/collection_detail_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_back_title_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:baby_family/utils/widget/memory_grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Chi tiết bộ sưu tập (không có trong Pencil — tài liệu 7.8.4): thanh tiêu
/// đề như MEM-20, số ký ức, lưới 3 cột (bo 14, cách 8) như lưới ảnh tháng.
class CollectionDetailMobileView extends HookConsumerWidget {
  const CollectionDetailMobileView({required this.code, super.key});

  final String code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(collectionDetailControllerProvider);
    useEffect(() {
      Future.microtask(() => controller.init(code));
      return null;
    }, const []);
    final l10n = context.l10n;
    final summary = controller.summary;
    final memories = controller.memories;
    return BaseScaffold(
      appBar: AppBackTitleBar(title: summary?.title ?? ''),
      body: !controller.loaded
          ? const Center(child: CircleLoadingProgress())
          : memories.isEmpty
          ? EmptyState(
              title: l10n.commonEmptyTitle,
              description: l10n.commonEmptyMessage,
            )
          : ListView(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.s1,
                AppSpacing.screen,
                AppSpacing.s5 + MediaQuery.paddingOf(context).bottom,
              ),
              children: [
                Text(
                  l10n.memoriesCount(memories.length),
                  style: AppTypography.adapt(context, AppTypography.caption),
                ),
                const SizedBox(height: AppSpacing.cardInset),
                GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: AppSpacing.s2,
                  crossAxisSpacing: AppSpacing.s2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    for (final memory in memories) _tile(context, memory),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _tile(BuildContext context, Memory memory) {
    final (color, icon) = switch (memory.kind) {
      MemoryKind.quote => (kColorPrimary100FFE3DC, LucideIcons.quote),
      MemoryKind.voice => (kColorSecondary100E4F2EA, LucideIcons.audioLines),
      MemoryKind.letter => (kColorAccent100FDF1D6, LucideIcons.mail),
      MemoryKind.keepsake => (kColorSurfaceVariantF7F1EC, LucideIcons.gem),
      _ => (kColorUs100EAE2F8, LucideIcons.heartHandshake),
    };
    return MemoryGridTile(
      asset: memory.mediaAssets.firstOrNull,
      icon: icon,
      color: color,
      label: memory.title ?? memory.body,
      radius: AppRadius.md,
      onTap: () => context.router.push(MemoryDetailRoute(memoryId: memory.id)),
    );
  }
}
