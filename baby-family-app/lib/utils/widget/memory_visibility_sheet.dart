import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/memory_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Sheet “Ai thấy” (mục 7.6) dùng ở MEM-05, MEM-09 và MEM-23: 3 lựa chọn Cả nhà
/// / Chỉ Papa & Mama / Chỉ mình tôi ([options] thu hẹp — MEM-09 khi không phải
/// tác giả bỏ “Chỉ mình tôi”). Trả về lựa chọn mới hoặc null khi đóng.
Future<MemoryVisibility?> showMemoryVisibilitySheet(
  BuildContext context, {
  required MemoryVisibility current,
  Iterable<MemoryVisibility> options = MemoryVisibility.values,
}) => showAppBottomSheet<MemoryVisibility>(
  context,
  builder: (context) => AppBottomSheet(
    title: context.l10n.memoriesVisibility,
    gap: AppSpacing.s2,
    children: [
      for (final value in options)
        _VisibilityOption(
          value: value,
          selected: value == current,
          onTap: () => Navigator.of(context).pop(value),
        ),
    ],
  ),
);

class _VisibilityOption extends StatelessWidget {
  const _VisibilityOption({
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final MemoryVisibility value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final icon = switch (value) {
      MemoryVisibility.family => LucideIcons.users,
      MemoryVisibility.parents => LucideIcons.heartHandshake,
      MemoryVisibility.onlyMe => LucideIcons.lock,
    };
    return Material(
      color: AppColors.resolve(
        context,
        selected ? kColorPrimary50FFF4F1 : kColorSurfaceVariantF7F1EC,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: selected
            ? BorderSide(
                color: AppColors.resolve(context, kColorPrimary500EE7B67),
              )
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSpacing.fieldHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.cardInset,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: AppColors.resolve(context, kColorTextSecondary6B625B),
                ),
                const SizedBox(width: AppSpacing.s3),
                Expanded(
                  child: Text(
                    memoryVisibilityLabel(context.l10n, value),
                    style: AppTypography.adapt(context, AppTypography.body),
                  ),
                ),
                if (selected)
                  Icon(
                    LucideIcons.check,
                    size: 18,
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
