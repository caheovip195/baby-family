import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/skeleton_block.dart';
import 'package:flutter/material.dart';

/// Loading của danh sách ký ức/feed (Pencil STATE-01 `dBDaO`): thẻ đầu
/// (avatar 48 + 2 dòng), hàng 3 chip, 2 thẻ ảnh 180 + 2 dòng. Đệm 8/20/16/20,
/// cách 16.
class MemoryListSkeleton extends StatelessWidget {
  const MemoryListSkeleton({this.cards = 2, super.key});

  final int cards;

  @override
  Widget build(BuildContext context) {
    final surface = AppColors.resolve(context, kColorSurfaceFFFFFF);
    BoxDecoration card() => BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
    );
    return Semantics(
      label: MaterialLocalizations.of(context).refreshIndicatorSemanticLabel,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.s2,
          AppSpacing.screen,
          AppSpacing.s4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.cardInset),
              decoration: card(),
              child: const Row(
                children: [
                  SkeletonBlock(width: 48, height: 48, radius: AppRadius.full),
                  SizedBox(width: AppSpacing.s3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonBlock(width: 120),
                        SizedBox(height: AppSpacing.s2),
                        SkeletonBlock(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s4),
            const Row(
              children: [
                SkeletonBlock(width: 70, height: 32, radius: AppRadius.full),
                SizedBox(width: AppSpacing.s2),
                SkeletonBlock(width: 84, height: 32, radius: AppRadius.full),
                SizedBox(width: AppSpacing.s2),
                SkeletonBlock(width: 96, height: 32, radius: AppRadius.full),
              ],
            ),
            for (var index = 0; index < cards; index++) ...[
              const SizedBox(height: AppSpacing.s4),
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: card(),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBlock(height: 180, radius: 0),
                    Padding(
                      padding: EdgeInsets.all(AppSpacing.cardInset),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonBlock(),
                          SizedBox(height: AppSpacing.s2),
                          SkeletonBlock(width: 160, height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
