import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Bottom sheet chọn ngôn ngữ (ONB-01, SET-06). Trả về ngôn ngữ được chọn
/// hoặc `null` nếu đóng sheet.
class LanguagePickerSheet extends StatelessWidget {
  const LanguagePickerSheet({required this.selected, super.key});

  final AppLanguage selected;

  static Future<AppLanguage?> show(
    BuildContext context, {
    required AppLanguage selected,
  }) {
    return showModalBottomSheet<AppLanguage>(
      context: context,
      showDragHandle: true,
      builder: (_) => LanguagePickerSheet(selected: selected),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          AppSpacing.s4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.languagePickerTitle,
              style: AppTypography.adapt(context, AppTypography.h3),
            ),
            const SizedBox(height: AppSpacing.s3),
            for (final language in AppLanguage.values)
              ListTile(
                contentPadding: EdgeInsets.zero,
                minTileHeight: AppSpacing.minTouchTarget,
                title: Text(
                  language.nativeName,
                  style: AppTypography.adapt(context, AppTypography.body),
                ),
                trailing: language == selected
                    ? Icon(
                        LucideIcons.check,
                        color: AppColors.resolve(
                          context,
                          kColorPrimary600C2513F,
                        ),
                        size: 20,
                      )
                    : null,
                onTap: () => Navigator.of(context).pop(language),
              ),
          ],
        ),
      ),
    );
  }
}
