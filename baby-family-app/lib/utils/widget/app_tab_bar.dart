import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Thanh tab dưới của Main shell (Pencil TabBar `luKhc`): cao 84 (đệm
/// 8/12/20/12), nền `surface`, bo trên 24, bóng `#2E2A271F` y −4 blur 24.
/// 4 tab rộng 76 (icon 24, nhãn 11/500 `text-tertiary`, cách 4) + FAB 60
/// `primary-500` ở giữa (icon `plus` 28, bóng `#EE7B6766` y 6 blur 16).
/// Tab đang chọn: `primary-600` + chữ 700; riêng Papa & Mama dùng `us-700`.
class AppTabBar extends StatelessWidget {
  const AppTabBar({
    required this.current,
    required this.onSelected,
    required this.onCreate,
    super.key,
  });

  final MainTab current;
  final ValueChanged<MainTab> onSelected;

  /// FAB → sheet tạo nhanh QC-01.
  final VoidCallback onCreate;

  static IconData _icon(MainTab tab) => switch (tab) {
    MainTab.home => LucideIcons.house,
    MainTab.memories => LucideIcons.images,
    MainTab.care => LucideIcons.listChecks,
    MainTab.us => LucideIcons.heartHandshake,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    String label(MainTab tab) => switch (tab) {
      MainTab.home => l10n.navHome,
      MainTab.memories => l10n.navMemories,
      MainTab.care => l10n.navCare,
      MainTab.us => l10n.navUs,
    };
    // Tabs share the width left by the FAB (76 each on a 390 phone, narrower
    // on 360 so nothing overflows).
    Widget item(MainTab tab) => Expanded(
      child: _TabItem(
        icon: _icon(tab),
        label: label(tab),
        selected: tab == current,
        activeColor: tab == MainTab.us
            ? kColorUs7006A549F
            : kColorPrimary600C2513F,
        onTap: () => onSelected(tab),
      ),
    );
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
              children: [
                item(MainTab.home),
                item(MainTab.memories),
                // FAB 60 cao hơn hàng tab 56 — tràn đều trên/dưới như Pencil.
                SizedBox(
                  width: AppSpacing.fabSize,
                  child: OverflowBox(
                    maxHeight: AppSpacing.fabSize,
                    child: _CreateButton(
                      label: l10n.commonCreateNew,
                      onTap: onCreate,
                    ),
                  ),
                ),
                item(MainTab.care),
                item(MainTab.us),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.activeColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.resolve(
      context,
      selected ? activeColor : kColorTextTertiary9C928A,
    );
    return Semantics(
      selected: selected,
      button: true,
      label: label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        radius: AppSpacing.tabItemWidth / 2,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.tabItemWidth),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24, color: color),
              const SizedBox(height: AppSpacing.s1),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTypography.tiny.copyWith(
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

class _CreateButton extends StatelessWidget {
  const _CreateButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Container(
        width: AppSpacing.fabSize,
        height: AppSpacing.fabSize,
        decoration: BoxDecoration(
          color: AppColors.resolve(context, kColorPrimary500EE7B67),
          shape: BoxShape.circle,
          boxShadow: AppShadows.fab,
        ),
        child: Material(
          color: kColorTransparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Icon(
              LucideIcons.plus,
              size: 28,
              color: AppColors.onPrimary(context),
            ),
          ),
        ),
      ),
    );
  }
}
