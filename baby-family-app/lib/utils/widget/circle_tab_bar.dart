import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Thanh tab của Circle shell người thân (Pencil `LXpog`): cao 84 (đệm
/// 8/12/20/12), nền `surface`, bo trên 24, bóng `#2E2A271F` y −4 blur 24,
/// 4 tab rộng 80 chia đều (space-around): icon 26, nhãn 13 — đang chọn
/// `primary-600` chữ 700, còn lại `text-tertiary` chữ 500. Không có FAB.
class CircleTabBar extends StatelessWidget {
  const CircleTabBar({
    required this.current,
    required this.onSelected,
    super.key,
  });

  final CircleTab current;
  final ValueChanged<CircleTab> onSelected;

  static IconData iconOf(CircleTab tab) => switch (tab) {
    CircleTab.home => LucideIcons.house,
    CircleTab.memories => LucideIcons.images,
    CircleTab.post => LucideIcons.imagePlus,
    CircleTab.me => LucideIcons.user,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    String label(CircleTab tab) => switch (tab) {
      CircleTab.home => l10n.circleTabHome,
      CircleTab.memories => l10n.circleTabMemories,
      CircleTab.post => l10n.circleTabPost,
      CircleTab.me => l10n.circleTabMe,
    };
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.tabBar),
        ),
        boxShadow: AppShadows.tabBar,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.s3,
            AppSpacing.s2,
            AppSpacing.s3,
            bottomInset > AppSpacing.s5 ? bottomInset : AppSpacing.s5,
          ),
          child: SizedBox(
            height: AppSpacing.tabBarHeight - AppSpacing.s2 - AppSpacing.s5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (final tab in CircleTab.values)
                  Flexible(
                    child: _CircleTabItem(
                      icon: iconOf(tab),
                      label: label(tab),
                      selected: tab == current,
                      onTap: () => onSelected(tab),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CircleTabItem extends StatelessWidget {
  const _CircleTabItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.resolve(
      context,
      selected ? kColorPrimary600C2513F : kColorTextTertiary9C928A,
    );
    return Semantics(
      selected: selected,
      button: true,
      label: label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        radius: AppSpacing.circleTabItemWidth / 2,
        child: SizedBox(
          width: AppSpacing.circleTabItemWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 26, color: color),
              const SizedBox(height: AppSpacing.s1),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTypography.caption.copyWith(
                  color: color,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
