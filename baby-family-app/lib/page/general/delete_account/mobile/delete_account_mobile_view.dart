import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/settings/delete_account_info.dart';
import 'package:baby_family/page/general/delete_account/delete_account_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/relative_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/router/session_route.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_card.dart';
import 'package:baby_family/utils/widget/app_choice_card.dart';
import 'package:baby_family/utils/widget/app_icon_badge.dart';
import 'package:baby_family/utils/widget/app_info_note.dart';
import 'package:baby_family/utils/widget/app_initial_avatar.dart';
import 'package:baby_family/utils/widget/app_radio_mark.dart';
import 'package:baby_family/utils/widget/app_text_field.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/bullet_list.dart';
part '../widgets/card_head.dart';
part '../widgets/confirm_step.dart';
part '../widgets/family_step.dart';
part '../widgets/impact_step.dart';
part '../widgets/keep_option.dart';
part '../widgets/step_heading.dart';

/// SET-09 / 09b / 09c — Xoá tài khoản (Pencil `fU1MN`, `mCafo`, `sA3Ch`,
/// `sOUEE`). Nút back của thanh trên lùi từng bước; “Giữ tài khoản” đóng
/// luồng; “Xoá tài khoản” đặt lại phiên → Welcome.
class DeleteAccountMobileView extends HookConsumerWidget {
  const DeleteAccountMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(deleteAccountControllerProvider);
    final info = controller.info;

    void back() {
      if (!controller.back()) {
        context.router.maybePop();
      }
    }

    Future<void> delete() async {
      final done = await runWithErrorSnackBar(
        context,
        controller.deleteAccount,
      );
      if (!done || !context.mounted) {
        return;
      }
      await context.router.replaceAll([routeForSession(controller.session)]);
    }

    Future<void> sendOtp() => runWithErrorSnackBar(context, controller.sendOtp);

    Future<void> verifyOtp() =>
        runWithErrorSnackBar(context, controller.verifyOtp);

    Widget body;
    if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else if (info == null) {
      body = const SizedBox.shrink();
    } else {
      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          AppSpacing.s8 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          switch (controller.screen) {
            1 => _ImpactStep(controller: controller, info: info),
            2 => _FamilyStep(controller: controller, info: info, onBack: back),
            _ => _ConfirmStep(
              controller: controller,
              info: info,
              onDelete: delete,
              onSendOtp: sendOtp,
              onVerifyOtp: verifyOtp,
            ),
          },
        ],
      );
    }
    return BaseScaffold(
      isLoading: controller.isLoading,
      appBar: AppTopBar(
        step: controller.screen == DeleteAccountController.lastScreen
            ? DeleteAccountController.stepCount
            : controller.screen,
        stepCount: DeleteAccountController.stepCount,
        currentStepOnly: true,
        onBack: back,
      ),
      body: body,
    );
  }
}
