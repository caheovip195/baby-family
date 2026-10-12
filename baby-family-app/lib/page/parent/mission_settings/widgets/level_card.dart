part of '../mobile/mission_settings_mobile_view.dart';

/// Thẻ mức (Pencil “Nhẹ/Vừa/Nhiều”): đệm 12/8, cách 2, căn giữa, bo 16. Thường
/// nền `surface` viền `border`; chọn nền `primary-50` viền `primary-500` 2,
/// tên + số `primary-700`. Tên 13/700, số 26/800, “việc / người” 11, “… việc
/// cùng nhau” 10 `text-tertiary`; mức Vừa có nhãn “Mặc định”.
class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.level,
    required this.selected,
    required this.onTap,
  });

  final MissionLoadLevel level;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final accent = selected ? kColorPrimary700A2402F : null;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: AppColors.resolve(
          context,
          selected ? kColorPrimary50FFF4F1 : kColorSurfaceFFFFFF,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(
            color: AppColors.resolve(
              context,
              selected ? kColorPrimary500EE7B67 : kColorBorderEADFD6,
            ),
            width: selected ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s2,
              vertical: AppSpacing.s3,
            ),
            child: Column(
              children: [
                Text(
                  l10n.careSettingsLevel(level.name),
                  style: AppTypography.adapt(
                    context,
                    AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 16 / 13,
                      color: accent ?? kColorTextSecondary6B625B,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${level.perPerson}',
                  style: AppTypography.adapt(
                    context,
                    AppTypography.h1.copyWith(
                      color: accent ?? kColorTextPrimary2E2A27,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.careSettingsPerPerson,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.tiny.copyWith(
                      color: kColorTextSecondary6B625B,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.careSettingsTogether(level.name),
                  textAlign: TextAlign.center,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.micro.copyWith(
                      color: kColorTextTertiary9C928A,
                    ),
                  ),
                ),
                if (level == MissionLoadLevel.medium) ...[
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.compact,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.resolve(context, kColorPrimary100FFE3DC),
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                    ),
                    child: Text(
                      l10n.careSettingsDefault,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.micro.copyWith(
                          fontWeight: FontWeight.w700,
                          color: kColorPrimary700A2402F,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
