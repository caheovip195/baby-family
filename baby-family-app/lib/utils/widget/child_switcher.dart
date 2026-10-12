import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Kết quả chọn ở SW-01: [childId] = null nghĩa là “Cả nhà”.
typedef ChildSelection = ({String? childId});

/// Nút chọn chủ thể (Pencil ChildSwitcher `SjvF6`): cao 40, đệm 4/12/4/4,
/// nền `surface`, viền `border`, bo tròn; avatar 32 + nhãn 14/600 +
/// `chevron-down` 16. Chạm → [showChildSwitcherSheet] (SW-01). Dùng ở HOME,
/// MEM, CARE (chủ thể chung `selectedSubjectProvider`).
class ChildSwitcher extends StatelessWidget {
  const ChildSwitcher({
    required this.children,
    required this.today,
    required this.onChanged,
    this.selectedId,
    this.onManage,
    super.key,
  });

  final List<Child> children;
  final String? selectedId;
  final DateTime today;
  final ValueChanged<String?> onChanged;

  /// “Quản lý các con” trong sheet.
  final VoidCallback? onManage;

  @override
  Widget build(BuildContext context) {
    final selected = children.where((c) => c.id == selectedId).firstOrNull;
    final l10n = context.l10n;
    final due = selected?.isPregnancy == true ? selected?.dueDate : null;
    // Thai kỳ: “Bơ · Tuần 24” (Pencil HOME-03 l2ePul).
    final label = selected == null
        ? l10n.commonAllFamily
        : due == null
        ? selected.name
        : l10n.switcherPregnancyLabel(
            selected.name,
            pregnancyWeek(due, today).week,
          );
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        shape: StadiumBorder(
          side: BorderSide(
            color: AppColors.resolve(context, kColorBorderEADFD6),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () async {
            final result = await showChildSwitcherSheet(
              context,
              children: children,
              selectedId: selectedId,
              today: today,
              onManage: onManage,
            );
            if (result != null) {
              onChanged(result.childId);
            }
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s1,
              AppSpacing.s1,
              AppSpacing.s3,
              AppSpacing.s1,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ChildAvatar(child: selected, size: 32, iconSize: 16),
                const SizedBox(width: AppSpacing.s2),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.text14.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.s2),
                Icon(
                  LucideIcons.chevronDown,
                  size: 16,
                  color: AppColors.resolve(context, kColorTextSecondary6B625B),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// SW-01 “Xem theo” (Pencil `PfRgF`). Trả về lựa chọn hoặc null khi đóng.
Future<ChildSelection?> showChildSwitcherSheet(
  BuildContext context, {
  required List<Child> children,
  required DateTime today,
  String? selectedId,
  VoidCallback? onManage,
}) {
  return showAppBottomSheet<ChildSelection>(
    context,
    builder: (sheetContext) {
      final l10n = sheetContext.l10n;
      String description(Child child) {
        if (child.isPregnancy && child.dueDate != null) {
          return pregnancyWeekText(l10n, child.dueDate!, today);
        }
        final birth = child.birthDate;
        return birth == null ? '' : childAgeText(l10n, birth, today);
      }

      String name(Child child) => child.isPregnancy
          ? l10n.switcherPregnancy(child.pregnancyOrder ?? 1, child.name)
          : child.name;

      return AppBottomSheet(
        title: l10n.switcherViewBy,
        children: [
          // Pencil PfRgF: mỗi hàng là một khối của sheet (cách 16).
          _SubjectRow(
            avatar: const ChildAvatar(size: 44, iconSize: 20),
            name: l10n.commonAllFamily,
            description: l10n.switcherAllDescription,
            selected: selectedId == null,
            onTap: () => Navigator.of(sheetContext).pop((childId: null)),
          ),
          for (final child in children)
            _SubjectRow(
              avatar: ChildAvatar(
                child: child,
                size: 44,
                iconSize: 20,
                borderColor: child.avatarAsset == null
                    ? null
                    : kColorSurfaceFFFFFF,
              ),
              name: name(child),
              description: description(child),
              selected: selectedId == child.id,
              onTap: () => Navigator.of(sheetContext).pop((childId: child.id)),
            ),
          if (onManage != null)
            _ManageButton(
              label: l10n.familyManageChildren,
              onTap: () {
                Navigator.of(sheetContext).pop();
                onManage();
              },
            ),
        ],
      );
    },
  );
}

class _SubjectRow extends StatelessWidget {
  const _SubjectRow({
    required this.avatar,
    required this.name,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final Widget avatar;
  final String name;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected
            ? AppColors.resolve(context, kColorPrimary50FFF4F1)
            : kColorTransparent,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s3,
              vertical: AppSpacing.itemGap,
            ),
            child: Row(
              children: [
                avatar,
                const SizedBox(width: AppSpacing.s3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.title16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        description,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.caption,
                        ),
                      ),
                    ],
                  ),
                ),
                if (selected)
                  Icon(
                    LucideIcons.check,
                    size: 22,
                    color: AppColors.resolve(context, kColorPrimary600C2513F),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ManageButton extends StatelessWidget {
  const _ManageButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.resolve(context, kColorTextSecondary6B625B);
    return Material(
      color: kColorTransparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(
          color: AppColors.resolve(context, kColorBorderEADFD6),
          width: 1.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: AppSpacing.minTouchTarget,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.settings2, size: 18, color: color),
              const SizedBox(width: AppSpacing.s2),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.label.copyWith(color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
