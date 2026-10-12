import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// QC-01 “Tạo mới” (Pencil `IWfKB`): 3 hàng × 3 ô (cách 10). Ô: nền
/// `primary-50` (Papa & Mama: `us-50`), bo 16, đệm 14/4, ô icon 44 `surface`
/// bo 14 + icon 22 `primary-600` (`us-700`), nhãn 13/600. Trước hàng Papa &
/// Mama là nhãn khoá “Papa & Mama · chỉ hai bạn”.
///
/// Mở bằng [showQuickCreateSheet]; trả về mục đã chọn.
class QuickCreateSheet extends StatelessWidget {
  const QuickCreateSheet({required this.onSelected, super.key});

  final ValueChanged<QuickCreateAction> onSelected;

  static IconData iconOf(QuickCreateAction action) => switch (action) {
    QuickCreateAction.memory => LucideIcons.camera,
    QuickCreateAction.diary => LucideIcons.notebookPen,
    QuickCreateAction.milestone => LucideIcons.star,
    QuickCreateAction.letter => LucideIcons.mail,
    QuickCreateAction.mission => LucideIcons.listChecks,
    QuickCreateAction.event => LucideIcons.calendarPlus,
    QuickCreateAction.checkin => LucideIcons.smile,
    QuickCreateAction.request => LucideIcons.handHelping,
    QuickCreateAction.thanks => LucideIcons.flower2,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    String label(QuickCreateAction action) => switch (action) {
      QuickCreateAction.memory => l10n.commonMemory,
      QuickCreateAction.diary => l10n.commonDiary,
      QuickCreateAction.milestone => l10n.commonMilestone,
      QuickCreateAction.letter => l10n.commonLetter,
      QuickCreateAction.mission => l10n.commonMission,
      QuickCreateAction.event => l10n.commonEvent,
      QuickCreateAction.checkin => l10n.quickCheckin,
      QuickCreateAction.request => l10n.commonRequest,
      QuickCreateAction.thanks => l10n.quickThanks,
    };
    Widget row(List<QuickCreateAction> actions) => IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < actions.length; index++) ...[
            if (index > 0) const SizedBox(width: AppSpacing.itemGap),
            Expanded(
              child: _Tile(
                icon: iconOf(actions[index]),
                label: label(actions[index]),
                couple: actions[index].isCouple,
                onTap: () => onSelected(actions[index]),
              ),
            ),
          ],
        ],
      ),
    );
    const values = QuickCreateAction.values;
    final usColor = AppColors.resolve(context, kColorUs7006A549F);
    return AppBottomSheet(
      title: l10n.commonCreateNew,
      children: [
        row(values.sublist(0, 3)),
        row(values.sublist(3, 6)),
        Row(
          children: [
            Icon(LucideIcons.lock, size: 14, color: usColor),
            const SizedBox(width: AppSpacing.compact),
            Flexible(
              child: Text(
                l10n.homeParentsPrivacy,
                style: AppTypography.small.copyWith(
                  fontWeight: FontWeight.w600,
                  color: usColor,
                ),
              ),
            ),
          ],
        ),
        row(values.sublist(6, 9)),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.label,
    required this.couple,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool couple;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: AppColors.resolve(
          context,
          couple ? kColorUs50F6F2FC : kColorPrimary50FFF4F1,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.cardInset,
              horizontal: AppSpacing.s1,
            ),
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.resolve(context, kColorSurfaceFFFFFF),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: AppColors.resolve(
                      context,
                      couple ? kColorUs7006A549F : kColorPrimary600C2513F,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s2),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: kColorTextPrimary2E2A27,
                    ),
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

/// Mở QC-01 (nền mờ `#2E2A277A`). Trả về mục đã chọn hoặc null.
Future<QuickCreateAction?> showQuickCreateSheet(BuildContext context) {
  return showAppBottomSheet<QuickCreateAction>(
    context,
    builder: (sheetContext) => QuickCreateSheet(
      onSelected: (action) => Navigator.of(sheetContext).pop(action),
    ),
  );
}
