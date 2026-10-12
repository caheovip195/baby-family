part of '../mobile/pregnancy_journey_mobile_view.dart';

/// Thẻ siêu âm (Pencil `IQrrU`): đệm 12, cách 12, `surface`, viền `border`,
/// bo 16; ảnh 96 bo 12; nhãn 10/800 `us-700`, trích 13 (lh 1.4), meta 11.
class _UltrasoundCard extends StatelessWidget {
  const _UltrasoundCard({
    required this.memory,
    required this.onTap,
    this.author,
  });

  final Memory memory;
  final String? author;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final photo = memory.mediaAssets.firstOrNull;
    final text = memory.body ?? memory.title;
    final meta = [
      ?author,
      DateFormat('dd/MM', context.localeName).format(memory.occurredAt),
    ].join(' · ');
    return Material(
      color: AppColors.resolve(context, kColorSurfaceFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: AppColors.resolve(context, kColorBorderEADFD6)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s3),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.tile),
                child: photo == null
                    ? const SizedBox.square(dimension: 96)
                    : Image.asset(
                        photo,
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            const SizedBox.square(dimension: 96),
                      ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          LucideIcons.scanHeart,
                          size: 12,
                          color: AppColors.resolve(context, kColorUs7006A549F),
                        ),
                        const SizedBox(width: AppSpacing.s1),
                        Flexible(
                          child: Text(
                            l10n.pregUltrasoundWeek(memory.pregnancyWeek ?? 0),
                            style: AppTypography.adapt(
                              context,
                              AppTypography.micro.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                                color: kColorUs7006A549F,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (text != null) ...[
                      const SizedBox(height: AppSpacing.s1),
                      Text(
                        l10n.pregQuoted(text),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.caption.copyWith(
                            height: 1.4,
                            color: kColorTextPrimary2E2A27,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.s1),
                    Text(
                      meta,
                      style: AppTypography.adapt(context, AppTypography.tiny),
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
