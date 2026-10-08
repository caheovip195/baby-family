import 'package:baby_family/data/dto/welcome_slide_data.dart';
import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:baby_family/page/general/welcome/welcome_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/language_picker_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/welcome_language_chip.dart';
part '../widgets/welcome_page_dots.dart';
part '../widgets/welcome_slide.dart';

List<WelcomeSlideData> _buildSlides(AppLocalizations l10n) => [
  WelcomeSlideData(
    icon: LucideIcons.images,
    title: l10n.welcomeSlide1Title,
    description: l10n.welcomeSlide1Description,
  ),
  WelcomeSlideData(
    icon: LucideIcons.handHeart,
    title: l10n.welcomeSlide2Title,
    description: l10n.welcomeSlide2Description,
  ),
  WelcomeSlideData(
    icon: LucideIcons.house,
    title: l10n.welcomeSlide3Title,
    description: l10n.welcomeSlide3Description,
  ),
];

class WelcomeMobileView extends HookWidget {
  const WelcomeMobileView({required this.controller, super.key});

  final WelcomeController controller;

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    final l10n = context.l10n;
    final slides = _buildSlides(l10n);
    return BaseScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: _WelcomeLanguageChip(
                  label: controller.language.nativeName,
                  onTap: () async {
                    final selected = await LanguagePickerSheet.show(
                      context,
                      selected: controller.language,
                    );
                    if (selected != null) {
                      await controller.changeLanguage(selected);
                    }
                  },
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: slides.length,
                  onPageChanged: controller.onPageChanged,
                  itemBuilder: (context, index) =>
                      _WelcomeSlide(data: slides[index]),
                ),
              ),
              _WelcomePageDots(
                count: slides.length,
                currentIndex: controller.currentIndex,
              ),
              const SizedBox(height: AppSpacing.s8),
              AppButton(
                label: controller.isLastSlide
                    ? l10n.commonStart
                    : l10n.commonContinue,
                onPressed: () {
                  if (!controller.isLastSlide) {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                    );
                    return;
                  }
                  // TODO(team): điều hướng AUTH-01 khi có màn đăng nhập.
                },
              ),
              const SizedBox(height: AppSpacing.s3),
              TextButton(
                // TODO(team): điều hướng INV-05 (nhập mã mời).
                onPressed: () {},
                child: Text(
                  l10n.welcomeHaveInviteCode,
                  style: AppTypography.label.copyWith(
                    color: kColorPrimary600C2513F,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s4),
            ],
          ),
        ),
      ),
    );
  }
}
