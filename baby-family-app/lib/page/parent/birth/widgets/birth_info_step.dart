part of '../mobile/birth_mobile_view.dart';

/// B2 thông tin bé (Pencil wpICu): nội dung đệm 0/20/24/20, cách 14 — tiêu đề
/// 24/800, phụ 13, ảnh đầu tiên, tên, ngày + giờ sinh (130), giới tính, cân
/// nặng + chiều dài; nút “Xem thẻ chào mừng”. Điền sẵn từ tên đã chọn và bản
/// nháp; không chặn khi thiếu dữ liệu.
class _BirthInfoStep extends HookWidget {
  const _BirthInfoStep({required this.controller, super.key});

  final BirthController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = context.localeName;
    final baby = controller.currentBaby;
    final nickname = baby.nickname ?? '';
    final name = useTextEditingController(
      text: baby.name.isNotEmpty && nickname.isNotEmpty
          ? l10n.pregBirthNameValue(baby.name, nickname)
          : (baby.name.isNotEmpty ? baby.name : nickname),
    );
    final date = useTextEditingController(
      text: baby.birthDate?.toFormDate(locale) ?? '',
    );
    final time = useTextEditingController(text: baby.birthTime ?? '');
    final weight = useTextEditingController(
      text: baby.weightKg == null
          ? ''
          : l10n.pregKg(_formatMeasure(context, baby.weightKg!)),
    );
    final height = useTextEditingController(
      text: baby.heightCm == null
          ? ''
          : l10n.pregCm(_formatMeasure(context, baby.heightCm!)),
    );

    void save() {
      final match = RegExp(r'^(.*?)\s*[(（](.+)[)）]\s*$').firstMatch(name.text);
      controller.updateBaby(
        baby.copyWith(
          name: (match?.group(1) ?? name.text).trim(),
          nickname: match?.group(2)?.trim(),
          birthDate: _parseDate(date.text),
          birthTime: time.text.trim().isEmpty ? null : time.text.trim(),
          weightKg: _parseMeasure(weight.text),
          heightCm: _parseMeasure(height.text),
        ),
      );
    }

    final last = controller.babyIndex == controller.babyCount - 1;
    const gap = SizedBox(height: AppSpacing.cardInset);
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
                    l10n.pregBirthWelcomeTitle,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.h1.copyWith(fontSize: 24, height: 1.25),
                    ),
                  ),
                  gap,
                  Text(
                    l10n.pregBirthBabyIndex(
                      controller.babyIndex + 1,
                      controller.babyCount,
                    ),
                    style: AppTypography.adapt(context, AppTypography.caption),
                  ),
                  gap,
                  _FirstPhotoPicker(
                    photoAsset: baby.photoAsset,
                    onTap: () {
                      save();
                      controller.pickFirstPhoto();
                    },
                  ),
                  gap,
                  AppTextField(
                    label: l10n.pregnancyBabyName,
                    controller: name,
                    onChanged: (_) => save(),
                  ),
                  gap,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: l10n.pregnancyBirthDate,
                          controller: date,
                          keyboardType: TextInputType.datetime,
                          onChanged: (_) => save(),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.itemGap),
                      SizedBox(
                        width: 130,
                        child: AppTextField(
                          label: l10n.pregnancyBirthTime,
                          controller: time,
                          keyboardType: TextInputType.datetime,
                          onChanged: (_) => save(),
                        ),
                      ),
                    ],
                  ),
                  gap,
                  Text(
                    l10n.pregnancyBirthGender,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  gap,
                  Wrap(
                    spacing: AppSpacing.s2,
                    runSpacing: AppSpacing.s2,
                    children: [
                      for (final (gender, label) in [
                        (ChildGender.boy, l10n.pregnancyBabyBoy),
                        (ChildGender.girl, l10n.pregnancyBabyGirl),
                        (ChildGender.unknown, l10n.pregnancyLater),
                      ])
                        AppChip(
                          label: label,
                          selected: baby.gender == gender,
                          onTap: () {
                            save();
                            controller.updateBaby(
                              controller.currentBaby.copyWith(gender: gender),
                            );
                          },
                        ),
                    ],
                  ),
                  gap,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: l10n.pregBirthWeightLabel,
                          controller: weight,
                          keyboardType: TextInputType.text,
                          onChanged: (_) => save(),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.itemGap),
                      Expanded(
                        child: AppTextField(
                          label: l10n.pregnancyHeight,
                          controller: height,
                          keyboardType: TextInputType.text,
                          onChanged: (_) => save(),
                        ),
                      ),
                    ],
                  ),
                  gap,
                ],
              ),
            ),
          ),
          AppButton(
            label: last ? l10n.pregnancyBirthPreview : l10n.commonContinue,
            onPressed: () {
              save();
              controller.next();
            },
          ),
        ],
      ),
    );
  }
}
