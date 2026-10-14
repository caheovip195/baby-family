part of '../mobile/family_plan_mobile_view.dart';

/// Thẻ dung lượng SUB-03 (Pencil “Storage”): “3,2 GB” 22/800 + “đã dùng /
/// 200 GB”, thanh 10 bo 5 nền `surface-variant` chia đoạn theo loại (ảnh
/// `primary-500`, video `accent-500`, âm thanh `us-500`), chú thích 11.
class _StorageCard extends StatelessWidget {
  const _StorageCard({
    required this.usedMb,
    required this.quotaMb,
    required this.storage,
  });

  final int usedMb;
  final int quotaMb;
  final List<StorageUsage> storage;

  static Color colorOf(String kind) => switch (kind) {
    'photo' => kColorPrimary500EE7B67,
    'video' => kColorAccent500F4BF5C,
    'audio' => kColorUs5009B85D1,
    _ => kColorTextTertiary9C928A,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = context.localeName;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.resolve(context, kColorBorderEADFD6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                l10n.subPlanGb(storageGbText(usedMb, locale)),
                style: AppTypography.adapt(
                  context,
                  AppTypography.h2.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 30 / 22,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Text(
                  l10n.subPlanUsedOf(storageGbText(quotaMb, locale)),
                  textAlign: TextAlign.end,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.small.copyWith(height: 15 / 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.itemGap),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: 10,
              color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
              child: LayoutBuilder(
                builder: (context, constraints) => Row(
                  children: [
                    for (final item in storage)
                      Container(
                        width: quotaMb <= 0
                            ? 0
                            : constraints.maxWidth *
                                  (item.usedMb / quotaMb).clamp(0, 1),
                        color: AppColors.resolve(context, colorOf(item.kind)),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.itemGap),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: AppSpacing.itemGap,
            runSpacing: AppSpacing.s1,
            children: [
              for (final item in storage)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: AppSpacing.s2,
                      height: AppSpacing.s2,
                      decoration: BoxDecoration(
                        color: AppColors.resolve(context, colorOf(item.kind)),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.compact),
                    Text(
                      l10n.subPlanStorageKind(
                        item.kind,
                        storageGbText(item.usedMb, locale),
                      ),
                      style: AppTypography.adapt(
                        context,
                        AppTypography.tiny.copyWith(
                          color: kColorTextSecondary6B625B,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
