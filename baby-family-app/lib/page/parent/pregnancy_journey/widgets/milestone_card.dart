part of '../mobile/pregnancy_journey_mobile_view.dart';

/// Thẻ cột mốc “Lần đầu” (Pencil `WTnlI`): đệm 14, cách 12, nền
/// `accent-100`, bo 16; huy hiệu 40 `surface` + sao 20 `accent-500`.
class _MilestoneCard extends StatelessWidget {
  const _MilestoneCard({required this.memory, required this.onTap});

  final Memory memory;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Material(
      color: AppColors.resolve(context, kColorAccent100FDF1D6),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardInset),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.resolve(context, kColorSurfaceFFFFFF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.star,
                  size: 20,
                  color: AppColors.resolve(context, kColorAccent500F4BF5C),
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.pregFirstLabel,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.micro.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      memory.title ?? memory.milestoneTitle ?? '',
                      style: AppTypography.adapt(
                        context,
                        AppTypography.title16.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.pregMilestoneLater,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.tiny.copyWith(
                          color: kColorTextSecondary6B625B,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
