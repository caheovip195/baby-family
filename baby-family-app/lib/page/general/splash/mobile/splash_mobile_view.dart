import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/general/splash/splash_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/session_route.dart';
import 'package:baby_family/utils/widget/app_logo.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// SPL-01 (Pencil jwJat): nền primary-50, logo 112, “Baby Family” 34/800,
/// tagline 15, dòng “Đang chuẩn bị…” 13 cách đáy 40.
class SplashMobileView extends HookConsumerWidget {
  const SplashMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(splashControllerProvider);
    useEffect(() {
      controller.restore().then((session) {
        if (context.mounted) {
          context.router.replaceAll([routeForSession(session)]);
        }
      });
      return null;
    }, const []);
    return BaseScaffold(
      backgroundColor: kColorPrimary50FFF4F1,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s10,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppLogo(size: 112),
                      const SizedBox(height: AppSpacing.s5),
                      Text(
                        context.l10n.appName,
                        textAlign: TextAlign.center,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.display.copyWith(
                            fontSize: 34,
                            height: 46 / 34,
                            color: kColorPrimary700A2402F,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s5),
                      Text(
                        context.l10n.splashTagline,
                        textAlign: TextAlign.center,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.body.copyWith(
                            color: kColorTextSecondary6B625B,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                0,
                AppSpacing.screen,
                AppSpacing.s10,
              ),
              child: Text(
                context.l10n.splashPreparing,
                textAlign: TextAlign.center,
                style: AppTypography.adapt(context, AppTypography.caption)
                    .copyWith(
                      color: AppColors.resolve(
                        context,
                        kColorTextTertiary9C928A,
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
