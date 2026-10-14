part of '../mobile/upgrade_plan_mobile_view.dart';

/// Bảng so sánh House / Family (Pencil “Compare”): nền `surface`, viền
/// `border`, bo 16; đầu bảng nền `surface-variant` (cột Family là viên
/// `primary-100`); mỗi dòng đệm 11/16, kẻ `border` ở đáy, cột 84 căn giữa.
class _CompareTable extends StatelessWidget {
  const _CompareTable({required this.house, required this.family});

  final PlanOffer house;
  final PlanOffer family;

  static const _column = 84.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final none = l10n.subCmpNone;
    String minutes(int? value) =>
        value == null ? none : l10n.subCmpMaxMinutes(value);
    String count(int? value) => value == null ? none : '$value';
    String yes(bool value) => value ? l10n.subCmpYes : none;
    String gb(int value) => l10n.subPlanGb('$value');
    final rows = [
      (
        l10n.subCmpRelatives,
        house.relativeSlots > 0 ? l10n.subCmpUpTo(house.relativeSlots) : none,
        family.relativeSlots > 0 ? l10n.subCmpUpTo(family.relativeSlots) : none,
      ),
      (l10n.familyStorageLabel, gb(house.storageGb), gb(family.storageGb)),
      (
        l10n.subCmpPhotos,
        count(house.photosPerMemory),
        count(family.photosPerMemory),
      ),
      (
        l10n.subCmpVideo,
        minutes(house.videoMinutes),
        minutes(family.videoMinutes),
      ),
      (
        l10n.subCmpVoice,
        minutes(house.voiceMinutes),
        minutes(family.voiceMinutes),
      ),
      (
        l10n.subCmpOriginal,
        yes(house.originalQuality),
        yes(family.originalQuality),
      ),
      (l10n.subCmpAi, count(house.aiPerMonth), count(family.aiPerMonth)),
      (
        l10n.subCmpDigest,
        yes(house.digestAndReview),
        yes(family.digestAndReview),
      ),
    ];
    final border = AppColors.resolve(context, kColorBorderEADFD6);
    final heading = AppTypography.title16.copyWith(
      fontSize: 15,
      height: 20 / 15,
      fontWeight: FontWeight.w800,
    );
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Container(
            color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s4,
              vertical: AppSpacing.s3,
            ),
            child: Row(
              children: [
                const Spacer(),
                SizedBox(
                  width: _column,
                  child: Text(
                    l10n.billingHouse,
                    textAlign: TextAlign.center,
                    style: AppTypography.adapt(
                      context,
                      heading.copyWith(color: kColorTextSecondary6B625B),
                    ),
                  ),
                ),
                Container(
                  width: _column,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.s1),
                  decoration: BoxDecoration(
                    color: AppColors.resolve(context, kColorPrimary100FFE3DC),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    l10n.billingFamily,
                    textAlign: TextAlign.center,
                    style: AppTypography.adapt(
                      context,
                      heading.copyWith(color: kColorPrimary700A2402F),
                    ),
                  ),
                ),
              ],
            ),
          ),
          for (final (index, (label, houseValue, familyValue)) in rows.indexed)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s4,
                vertical: 11,
              ),
              decoration: BoxDecoration(
                border: index < rows.length - 1
                    ? Border(bottom: BorderSide(color: border))
                    : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.caption.copyWith(
                          height: 16 / 13,
                          color: kColorTextPrimary2E2A27,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: _column,
                    child: Text(
                      houseValue,
                      textAlign: TextAlign.center,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.caption.copyWith(
                          height: 16 / 13,
                          color: kColorTextTertiary9C928A,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: _column,
                    child: Text(
                      familyValue,
                      textAlign: TextAlign.center,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.caption.copyWith(
                          height: 16 / 13,
                          fontWeight: FontWeight.w700,
                          color: kColorPrimary700A2402F,
                        ),
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
}
