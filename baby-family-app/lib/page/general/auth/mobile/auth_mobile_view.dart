import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/general/auth/auth_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/router/session_route.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_language_chip.dart';
import 'package:baby_family/utils/widget/app_logo.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/language_picker_sheet.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/auth_trust_chip.dart';

/// AUTH-01 (Pencil GeFXP): chip ngôn ngữ; logo 112 + “Chào mừng đến Baby
/// Family” + dòng phụ + 3 chip tin cậy ở giữa; 3 nút Apple (nền tối) /
/// Google / Số điện thoại; dòng pháp lý 12 ở đáy.
class AuthMobileView extends HookConsumerWidget {
  const AuthMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(authControllerProvider);
    final l10n = context.l10n;
    Future<void> afterSignIn() async {
      if (!context.mounted) {
        return;
      }
      await context.router.push(routeForSession(controller.session));
    }

    return BaseScaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.s2,
                AppSpacing.screen,
                AppSpacing.s6,
              ),
              sliver: SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
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
                    const SizedBox(height: AppSpacing.s6),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AppLogo(),
                            const SizedBox(height: AppSpacing.s4),
                            Text(
                              l10n.authTitle,
                              textAlign: TextAlign.center,
                              style: AppTypography.adapt(
                                context,
                                AppTypography.h1.copyWith(height: 1.36),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.s4),
                            Text(
                              l10n.authSubtitle,
                              textAlign: TextAlign.center,
                              style: AppTypography.adapt(
                                context,
                                AppTypography.body.copyWith(
                                  height: 1.5,
                                  color: kColorTextSecondary6B625B,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.s4),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: AppSpacing.s2,
                              runSpacing: AppSpacing.s2,
                              children: [
                                _AuthTrustChip(
                                  icon: LucideIcons.lock,
                                  label: l10n.authPrivate,
                                ),
                                _AuthTrustChip(
                                  icon: LucideIcons.gift,
                                  label: l10n.authTrial(controller.trialDays),
                                ),
                                _AuthTrustChip(
                                  icon: LucideIcons.users,
                                  label: l10n.authFamily,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s6),
                    AppButton.social(
                      label: l10n.authApple,
                      icon: LucideIcons.apple,
                      inverted: true,
                      isLoading: controller.isLoading,
                      onPressed: () async {
                        await controller.signInApple();
                        await afterSignIn();
                      },
                    ),
                    const SizedBox(height: AppSpacing.s3),
                    AppButton.social(
                      label: l10n.authGoogle,
                      icon: LucideIcons.circleQuestionMark,
                      onPressed: controller.isLoading
                          ? null
                          : () async {
                              await controller.signInGoogle();
                              await afterSignIn();
                            },
                    ),
                    const SizedBox(height: AppSpacing.s3),
                    AppButton.social(
                      label: l10n.authPhone,
                      icon: LucideIcons.smartphone,
                      onPressed: () =>
                          context.router.push(const AuthPhoneRoute()),
                    ),
                    const SizedBox(height: AppSpacing.s6),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s3,
                      ),
                      child: Text(
                        l10n.authLegal,
                        textAlign: TextAlign.center,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.small.copyWith(
                            height: 1.5,
                            color: kColorTextTertiary9C928A,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
