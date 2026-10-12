import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/general/auth_otp/auth_otp_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/session_route.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_code_input.dart';
import 'package:baby_family/utils/widget/app_step_heading.dart';
import 'package:baby_family/utils/widget/app_step_scaffold.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// AUTH-03 (Pencil s9bOo): 6 ô OTP (cao 56, cách 10); “Gửi lại mã sau m:ss”;
/// link “Gửi qua SMS” · “Đổi số điện thoại”; nút “Xác nhận” ở đáy.
class AuthOtpMobileView extends HookConsumerWidget {
  const AuthOtpMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(authOtpControllerProvider);
    final code = useTextEditingController(text: controller.initialCode);
    useEffect(() {
      if (controller.samplesLoaded && code.text.isEmpty) {
        code.text = controller.initialCode;
      }
      return null;
    }, [controller.samplesLoaded]);
    final seconds = useState(kValueOtpResendSeconds);
    final restart = useState(0);
    useEffect(() {
      seconds.value = kValueOtpResendSeconds;
      final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (seconds.value <= 0) {
          timer.cancel();
          return;
        }
        seconds.value--;
      });
      return timer.cancel;
    }, [restart.value]);
    final l10n = context.l10n;
    Future<void> resend() async {
      await controller.resend();
      restart.value++;
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.authCodeResent)));
      }
    }

    Future<void> verify() async {
      await controller.verify(code.text);
      if (context.mounted) {
        await context.router.push(routeForSession(controller.session));
      }
    }

    final linkStyle = AppTypography.adapt(
      context,
      AppTypography.text14.copyWith(
        fontWeight: FontWeight.w600,
        color: kColorPrimary600C2513F,
      ),
    );
    final time =
        '${seconds.value ~/ 60}:${(seconds.value % 60).toString().padLeft(2, '0')}';
    return AppStepScaffold(
      topBar: const AppTopBar(),
      gap: 28,
      actions: [
        AppButton(
          label: l10n.commonConfirm,
          isLoading: controller.isLoading,
          onPressed: verify,
        ),
      ],
      children: [
        AppStepHeading(
          title: l10n.authOtpTitle,
          subtitle: l10n.authOtpSubtitle(controller.displayPhone),
        ),
        AppCodeInput(
          controller: code,
          length: kValueOtpLength,
          numeric: true,
          label: l10n.authOtpTitle,
          onSubmitted: (_) => verify(),
        ),
        Column(
          children: [
            if (seconds.value > 0)
              Text(
                l10n.authResendIn(time),
                textAlign: TextAlign.center,
                style: AppTypography.adapt(
                  context,
                  AppTypography.text14.copyWith(
                    color: kColorTextSecondary6B625B,
                  ),
                ),
              )
            else
              InkWell(
                onTap: resend,
                child: Text(l10n.authResend, style: linkStyle),
              ),
            const SizedBox(height: AppSpacing.s3),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: AppSpacing.s4,
              runSpacing: AppSpacing.s2,
              children: [
                InkWell(
                  onTap: resend,
                  child: Text(l10n.authSendSms, style: linkStyle),
                ),
                InkWell(
                  onTap: () => context.router.maybePop(),
                  child: Text(l10n.authChangePhone, style: linkStyle),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
