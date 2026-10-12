part of '../mobile/pregnancy_journey_mobile_view.dart';

/// Tab gạch chân của thai kỳ (Pencil `SF8MX`): đệm ngang 20, cách 12, viền
/// dưới `border`; mỗi tab đệm trên 10, chữ 14, cách 8, gạch 3 bo 2 — chọn:
/// 700 `us-700` + gạch `us-500`; chưa chọn: 500 `text-secondary`.
class _JourneyTabs extends StatelessWidget {
  const _JourneyTabs({required this.selected, required this.onSelected});

  final PregnancyTab selected;
  final ValueChanged<PregnancyTab> onSelected;

  String _label(BuildContext context, PregnancyTab tab) => switch (tab) {
    PregnancyTab.timeline => context.l10n.memoriesTimeline,
    PregnancyTab.bump => context.l10n.pregnancyBump,
    PregnancyTab.ultrasound => context.l10n.pregnancyUltrasound,
    PregnancyTab.prep => context.l10n.pregnancyPreparations,
  };

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.resolve(context, kColorBorderEADFD6),
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
        child: Row(
          children: [
            for (final tab in PregnancyTab.values) ...[
              if (tab.index > 0) const SizedBox(width: AppSpacing.s3),
              _item(context, tab),
            ],
          ],
        ),
      ),
    );
  }

  Widget _item(BuildContext context, PregnancyTab tab) {
    final isSelected = tab == selected;
    return Semantics(
      button: true,
      selected: isSelected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onSelected(tab),
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.itemGap),
              Text(
                _label(context, tab),
                textAlign: TextAlign.center,
                style: AppTypography.adapt(
                  context,
                  AppTypography.text14.copyWith(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? kColorUs7006A549F
                        : kColorTextSecondary6B625B,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s2),
              Container(
                height: 3,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.resolve(context, kColorUs5009B85D1)
                      : kColorTransparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
