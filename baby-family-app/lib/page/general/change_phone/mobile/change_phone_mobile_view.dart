import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/general/change_phone/change_phone_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/phone_format.dart';
import 'package:baby_family/utils/helper/server_error_message.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_card.dart';
import 'package:baby_family/utils/widget/app_text_field.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Đổi số điện thoại: 3 bước trong một thẻ; lỗi (mã sai, số đã dùng…) báo
/// bằng snack bar theo mã lỗi server.
class ChangePhoneMobileView extends HookConsumerWidget {
  const ChangePhoneMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(changePhoneControllerProvider);
    final l10n = context.l10n;

    Future<void> run(Future<void> Function() action) async {
      try {
        await action();
      } on Object catch (error) {
        if (context.mounted) {
          showAppSnackBar(context, actionErrorMessage(error));
        }
      }
    }

    Widget codeField() => AppTextField(
      key: ValueKey(controller.step),
      label: l10n.authOtpTitle,
      keyboardType: TextInputType.number,
      maxLength: ChangePhoneController.otpLength,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      autofocus: true,
      onChanged: controller.setCode,
    );

    final step = switch (controller.step) {
      ChangePhoneStep.reauth => [
        Text(l10n.phoneChangeReauthHint, style: _hint(context)),
        const SizedBox(height: AppSpacing.itemGap),
        if (!controller.reauthSent)
          AppButton.secondary(
            label: l10n.famDelSendOtp,
            height: 44,
            isLoading: controller.isLoading,
            onPressed: () => run(controller.sendReauth),
          )
        else ...[
          codeField(),
          const SizedBox(height: AppSpacing.itemGap),
          AppButton(
            label: l10n.commonContinue,
            height: 44,
            isLoading: controller.isLoading,
            onPressed: controller.canSubmitCode
                ? () => run(controller.verifyReauth)
                : null,
          ),
        ],
      ],
      ChangePhoneStep.newPhone => [
        Text(l10n.phoneChangeNewHint, style: _hint(context)),
        const SizedBox(height: AppSpacing.itemGap),
        AppTextField(
          label: l10n.authPhoneLabel,
          keyboardType: TextInputType.phone,
          inputFormatters: const [PhoneGroupFormatter()],
          autofocus: true,
          onChanged: controller.setPhone,
        ),
        const SizedBox(height: AppSpacing.itemGap),
        AppButton(
          label: l10n.famDelSendOtp,
          height: 44,
          isLoading: controller.isLoading,
          onPressed: controller.canSendNewPhone
              ? () => run(controller.sendNewPhoneCode)
              : null,
        ),
      ],
      ChangePhoneStep.verify => [
        Text(
          l10n.phoneChangeCodeSent(formatLocalPhone(controller.phoneInput)),
          style: _hint(context),
        ),
        const SizedBox(height: AppSpacing.itemGap),
        codeField(),
        const SizedBox(height: AppSpacing.itemGap),
        AppButton(
          label: l10n.commonConfirm,
          height: 44,
          isLoading: controller.isLoading,
          onPressed: controller.canSubmitCode
              ? () => run(controller.confirm)
              : null,
        ),
      ],
      ChangePhoneStep.done => [
        Text(l10n.phoneChangeDone, style: _hint(context)),
        const SizedBox(height: AppSpacing.itemGap),
        AppButton(
          label: l10n.commonDone,
          height: 44,
          onPressed: () => context.router.maybePop(true),
        ),
      ],
    };
    return BaseScaffold(
      appBar: const AppTopBar(),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          28 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Text(
            l10n.phoneChangeTitle,
            style: AppTypography.adapt(context, AppTypography.h1),
          ),
          const SizedBox(height: AppSpacing.cardInset),
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.s4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: step,
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _hint(BuildContext context) => AppTypography.adapt(
    context,
    AppTypography.text14.copyWith(
      height: 1.45,
      color: kColorTextSecondary6B625B,
    ),
  );
}
