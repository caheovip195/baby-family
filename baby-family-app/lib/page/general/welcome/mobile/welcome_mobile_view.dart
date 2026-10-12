import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/dto/welcome_slide_data.dart';
import 'package:baby_family/gen/assets.gen.dart';
import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:baby_family/page/general/welcome/welcome_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_language_chip.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/language_picker_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part '../widgets/welcome_page_dots.dart';
part '../widgets/welcome_slide.dart';

List<WelcomeSlideData> _slides(AppLocalizations l10n) => [
  WelcomeSlideData(
    title: l10n.welcomeSlide1Title,
    description: l10n.welcomeSlide1Description,
    imageAsset: Assets.images.generated1791380679668.path,
  ),
  WelcomeSlideData(
    title: l10n.welcomeSlide2Title,
    description: l10n.welcomeSlide2Description,
    imageAsset: Assets.images.generated1791380690709.path,
  ),
  WelcomeSlideData(
    title: l10n.welcomeSlide3Title,
    description: l10n.welcomeSlide3Description,
    imageAsset: Assets.images.generated1791380691593.path,
  ),
];

/// ONB-01 (Pencil K5UMY · w8tfLj · MOZNu): hàng trên “Bỏ qua” (slide 1–2) +
/// chip ngôn ngữ; ảnh minh hoạ 340 bo 28; tiêu đề 26/800 + mô tả 16; chấm
/// trang; nút “Tiếp tục”/“Bắt đầu” và link “Tôi đã có mã mời” cố định ở đáy
/// (không đổi vị trí giữa các slide).
class WelcomeMobileView extends HookConsumerWidget {
  const WelcomeMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(welcomeControllerProvider);
    final pageController = usePageController();
    final l10n = context.l10n;
    final slides = _slides(l10n);
    void toAuth() => context.router.push(const AuthRoute());
    void advance() {
      if (controller.isLastSlide) {
        toAuth();
        return;
      }
      pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
      );
    }

    final skipStyle = AppTypography.adapt(
      context,
      AppTypography.label.copyWith(color: kColorTextSecondary6B625B),
    );
    return BaseScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.s2,
            AppSpacing.screen,
            AppSpacing.s8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: AppSpacing.s10,
                child: Row(
                  children: [
                    if (!controller.isLastSlide)
                      Semantics(
                        button: true,
                        child: InkWell(
                          onTap: toAuth,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              minHeight: AppSpacing.s10,
                            ),
                            child: Center(
                              child: Text(l10n.commonSkip, style: skipStyle),
                            ),
                          ),
                        ),
                      ),
                    const Spacer(),
                    Flexible(
                      child: AppLanguageChip(
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
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s6),
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: slides.length,
                  onPageChanged: controller.onPageChanged,
                  itemBuilder: (context, index) =>
                      _WelcomeSlide(data: slides[index]),
                ),
              ),
              const SizedBox(height: AppSpacing.s6),
              _WelcomePageDots(
                count: slides.length,
                currentIndex: controller.currentIndex,
              ),
              const SizedBox(height: AppSpacing.s6),
              AppButton(
                label: controller.isLastSlide
                    ? l10n.commonStart
                    : l10n.commonContinue,
                onPressed: advance,
              ),
              const SizedBox(height: AppSpacing.s2),
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size(0, 44),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s3,
                    ),
                  ),
                  onPressed: () => context.router.push(const InviteCodeRoute()),
                  child: Text(
                    l10n.welcomeHaveInviteCode,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.label.copyWith(
                        color: kColorPrimary600C2513F,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
