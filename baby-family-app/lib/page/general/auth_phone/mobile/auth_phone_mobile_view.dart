import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/general/auth_phone/auth_phone_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/phone_format.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_step_heading.dart';
import 'package:baby_family/utils/widget/app_step_scaffold.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/phone_field.dart';

/// AUTH-02 (Pencil XU4Sd): tiêu đề + dòng phụ; ô mã quốc gia 81 + ô số điện
/// thoại (viền 2 `primary-500`, chữ 17/500); gợi ý riêng tư có khiên; nút
/// “Gửi mã” ở đáy.
class AuthPhoneMobileView extends HookConsumerWidget {
  const AuthPhoneMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(authPhoneControllerProvider);
    final phone = useTextEditingController(text: controller.initialPhone);
    useEffect(() {
      if (controller.samplesLoaded && phone.text.isEmpty) {
        phone.text = controller.initialPhone;
      }
      return null;
    }, [controller.samplesLoaded]);
    final l10n = context.l10n;
    Future<void> send() async {
      final sent = await runWithErrorSnackBar(
        context,
        () => controller.sendCode(phone.text),
      );
      if (sent && context.mounted) {
        await context.router.push(const AuthOtpRoute());
      }
    }

    return AppStepScaffold(
      topBar: const AppTopBar(),
      actions: [
        AppButton(
          label: l10n.authSendCode,
          isLoading: controller.isLoading,
          onPressed: send,
        ),
      ],
      children: [
        AppStepHeading(
          title: l10n.authPhoneTitle,
          subtitle: l10n.authPhoneSubtitle,
        ),
        _PhoneField(controller: phone, onSubmitted: (_) => send()),
        Row(
          children: [
            Icon(
              LucideIcons.shieldCheck,
              size: 16,
              color: AppColors.resolve(context, kColorSecondary7003F7A5C),
            ),
            const SizedBox(width: AppSpacing.s2),
            Expanded(
              child: Text(
                l10n.authPhonePrivate,
                style: AppTypography.adapt(
                  context,
                  AppTypography.caption.copyWith(height: 16 / 13),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
