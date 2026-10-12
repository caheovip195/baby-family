import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Thẻ câu nói của con (Pencil HOME-01 “Quote Card” `omRZp`): nền
/// `primary-100`, bo 16, đệm 18, cách 10; icon `quote` 26 `primary-500`;
/// câu nói 20/800 Nunito (1.3); meta: avatar bé 24 + chữ 12; dòng cảm xúc 12.
class QuoteCard extends StatelessWidget {
  const QuoteCard({
    required this.quote,
    required this.meta,
    this.avatar,
    this.reactions,
    this.onTap,
    super.key,
  });

  final String quote;

  /// “Hana · 2 tuổi 4 tháng · Papa ghi lại tối qua”.
  final String meta;

  /// Avatar bé 24 (thường là `ChildAvatar(size: 24)`).
  final Widget? avatar;

  /// “😂 🥹  Bà ngoại và 2 người khác”.
  final String? reactions;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.resolve(context, kColorPrimary100FFE3DC),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                LucideIcons.quote,
                size: 26,
                color: AppColors.resolve(context, kColorPrimary500EE7B67),
              ),
              const SizedBox(height: AppSpacing.itemGap),
              Text(
                quote,
                style: AppTypography.adapt(
                  context,
                  AppTypography.title20.copyWith(height: 1.3),
                ),
              ),
              const SizedBox(height: AppSpacing.itemGap),
              Row(
                children: [
                  if (avatar != null) ...[
                    SizedBox.square(dimension: 24, child: avatar),
                    const SizedBox(width: AppSpacing.s2),
                  ],
                  Expanded(
                    child: Text(
                      meta,
                      style: AppTypography.adapt(context, AppTypography.small),
                    ),
                  ),
                ],
              ),
              if (reactions != null) ...[
                const SizedBox(height: AppSpacing.itemGap),
                Text(
                  reactions!,
                  style: AppTypography.adapt(context, AppTypography.small),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
