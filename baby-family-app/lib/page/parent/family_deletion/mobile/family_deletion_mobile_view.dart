import 'package:baby_family/data/dto/family_deletion_info.dart';
import 'package:baby_family/page/parent/family_deletion/family_deletion_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/server_error_message.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_card.dart';
import 'package:baby_family/utils/widget/app_info_note.dart';
import 'package:baby_family/utils/widget/app_text_field.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// FAM-07 “Xoá gia đình”: giải thích hậu quả → xác thực lại (OTP) → chờ
/// Bố/Mẹ còn lại đồng ý → hẹn xoá (huỷ được trong thời gian chờ).
class FamilyDeletionMobileView extends HookConsumerWidget {
  const FamilyDeletionMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(familyDeletionControllerProvider);
    final info = controller.info;
    Widget body;
    if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else if (info == null) {
      body = const SizedBox.shrink();
    } else {
      body = _content(context, controller, info);
    }
    return BaseScaffold(appBar: const AppTopBar(), body: body);
  }

  Widget _content(
    BuildContext context,
    FamilyDeletionController controller,
    FamilyDeletionInfo info,
  ) {
    final l10n = context.l10n;
    const gap = SizedBox(height: AppSpacing.cardInset);

    Future<void> run(Future<void> Function() action, String done) async {
      try {
        await action();
        if (context.mounted) {
          showAppSnackBar(context, done);
        }
      } on Object catch (error) {
        if (context.mounted) {
          showAppSnackBar(context, actionErrorMessage(error));
        }
      }
    }

    final status = switch (info.status) {
      FamilyDeletionStatus.none => l10n.famDelBody(info.graceDays),
      FamilyDeletionStatus.awaitingPartner when info.requestedByMe =>
        l10n.famDelWaitingPartner,
      FamilyDeletionStatus.awaitingPartner => l10n.famDelPartnerAsked,
      FamilyDeletionStatus.scheduled => l10n.famDelScheduled(
        info.scheduledFor?.toFormDate(l10n.localeName) ?? '',
      ),
    };
    final canVerify =
        info.status == FamilyDeletionStatus.none || controller.needsMyApproval;
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        28 + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        Text(
          l10n.famDeleteFamily,
          style: AppTypography.adapt(context, AppTypography.h1),
        ),
        const SizedBox(height: AppSpacing.compact),
        Text(
          status,
          style: AppTypography.adapt(
            context,
            AppTypography.text14.copyWith(
              height: 1.45,
              color: kColorTextSecondary6B625B,
            ),
          ),
        ),
        gap,
        if (info.status == FamilyDeletionStatus.none) ...[
          AppInfoNote(icon: LucideIcons.download, text: l10n.famDelExportHint),
          gap,
        ],
        if (canVerify)
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.s4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.famDelVerifyHint,
                  style: AppTypography.adapt(context, AppTypography.caption),
                ),
                const SizedBox(height: AppSpacing.itemGap),
                if (!controller.otpSent)
                  AppButton.secondary(
                    label: l10n.famDelSendOtp,
                    height: 44,
                    isLoading: controller.isLoading,
                    onPressed: () =>
                        run(controller.sendOtp, l10n.famDelOtpSent),
                  )
                else ...[
                  AppTextField(
                    label: l10n.authOtpTitle,
                    keyboardType: TextInputType.number,
                    maxLength: FamilyDeletionController.otpLength,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    autofocus: true,
                    onChanged: controller.setOtpCode,
                  ),
                  const SizedBox(height: AppSpacing.itemGap),
                  AppButton(
                    label: controller.needsMyApproval
                        ? l10n.famDelAgree
                        : l10n.famDelStart,
                    height: 44,
                    color: kColorErrorD14B4B,
                    isLoading: controller.isLoading,
                    onPressed: controller.canVerify
                        ? () => run(
                            controller.verifyAndSubmit,
                            l10n.famDelRequested,
                          )
                        : null,
                  ),
                ],
              ],
            ),
          ),
        if (info.status != FamilyDeletionStatus.none) ...[
          gap,
          AppButton.secondary(
            label: l10n.famDelCancel,
            isLoading: controller.isLoading,
            onPressed: () => run(controller.cancel, l10n.famDelCancelled),
          ),
        ],
      ],
    );
  }
}
