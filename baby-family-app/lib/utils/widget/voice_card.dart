import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Thẻ ghi âm (Pencil MEM-01 “Voice Card” `h8sX2p`): nền `secondary-100`,
/// bo 16, đệm 14, cách 12; nút tròn 44 `secondary-500` (`play` 20); tiêu đề
/// 13/700; sóng âm 18 vạch 3px (7 vạch đầu `secondary-700` = đã phát); thời
/// lượng 12/600 `secondary-700`.
class VoiceCard extends StatelessWidget {
  const VoiceCard({
    required this.title,
    required this.duration,
    this.playing = false,
    this.progress = 0.4,
    this.onPlay,
    this.onTap,
    super.key,
  });

  final String title;

  /// “0:12”.
  final String duration;
  final bool playing;

  /// Phần sóng đã phát (0…1) — tô `secondary-700`.
  final double progress;
  final VoidCallback? onPlay;
  final VoidCallback? onTap;

  static const _bars = [
    8.0, 14.0, 20.0, 12.0, 18.0, 22.0, 10.0, 16.0, 20.0, //
    8.0, 14.0, 18.0, 12.0, 6.0, 16.0, 20.0, 10.0, 14.0,
  ];

  @override
  Widget build(BuildContext context) {
    final strong = AppColors.resolve(context, kColorSecondary7003F7A5C);
    final light = AppColors.resolve(context, kColorSecondary5006FAE8E);
    final played = (_bars.length * progress.clamp(0, 1)).round();
    return Material(
      color: AppColors.resolve(context, kColorSecondary100E4F2EA),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardInset),
          child: Row(
            children: [
              Semantics(
                button: true,
                label: playing
                    ? context.l10n.commonPause
                    : context.l10n.commonPlay,
                child: InkResponse(
                  onTap: onPlay,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: light,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      playing ? LucideIcons.pause : LucideIcons.play,
                      size: 20,
                      color: AppColors.onPrimary(context),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: kColorTextPrimary2E2A27,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.compact),
                    SizedBox(
                      height: 22,
                      child: ClipRect(
                        child: Row(
                          children: [
                            for (var i = 0; i < _bars.length; i++) ...[
                              if (i > 0) const SizedBox(width: 3),
                              Container(
                                width: 3,
                                height: _bars[i],
                                decoration: BoxDecoration(
                                  color: i < played ? strong : light,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Text(
                duration,
                style: AppTypography.small.copyWith(
                  fontWeight: FontWeight.w600,
                  color: strong,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
