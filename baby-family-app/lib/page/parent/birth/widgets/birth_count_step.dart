part of '../mobile/birth_mobile_view.dart';

/// B1 “Chúc mừng gia đình! Có mấy bé?” (mục 9.5, không có trong Pencil):
/// cùng bố cục với B2 — tiêu đề 24/800, chip 1–4 bé, nút “Tiếp tục”.
class _BirthCountStep extends StatelessWidget {
  const _BirthCountStep({required this.controller});

  final BirthController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        AppSpacing.s6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.pregBirthCountTitle,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.h1.copyWith(fontSize: 24, height: 1.25),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.cardInset),
                  Wrap(
                    spacing: AppSpacing.s2,
                    runSpacing: AppSpacing.s2,
                    children: [
                      for (
                        var count = 1;
                        count <= BirthController.maxBabies;
                        count++
                      )
                        AppChip(
                          label: l10n.pregBirthBabyCount(count),
                          selected: controller.babyCount == count,
                          onTap: () => controller.selectBabyCount(count),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          AppButton(label: l10n.commonContinue, onPressed: controller.next),
        ],
      ),
    );
  }
}
