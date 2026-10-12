import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/general/invite_code/invite_code_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_code_input.dart';
import 'package:baby_family/utils/widget/app_step_heading.dart';
import 'package:baby_family/utils/widget/app_step_scaffold.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// INV-05 (Pencil L1k7G): 8 ô mã (nhóm 4 · 4), “hoặc”, nút “Quét mã QR”, nút
/// “Xem lời mời” → INV-01.
class InviteCodeMobileView extends HookConsumerWidget {
  const InviteCodeMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(inviteCodeControllerProvider);
    final code = useTextEditingController(text: controller.initialCode);
    useEffect(() {
      if (controller.samplesLoaded && code.text.isEmpty) {
        code.text = controller.initialCode;
      }
      return null;
    }, [controller.samplesLoaded]);
    final l10n = context.l10n;
    void open(String value) =>
        context.router.push(InvitePreviewRoute(code: value));
    final divider = Expanded(
      child: Container(
        height: 1,
        color: AppColors.resolve(context, kColorBorderEADFD6),
      ),
    );
    return AppStepScaffold(
      topBar: const AppTopBar(),
      actions: [
        AppButton(
          label: l10n.inviteView,
          onPressed: () => open(controller.resolve(code.text)),
        ),
      ],
      children: [
        AppStepHeading(title: l10n.inviteTitle, subtitle: l10n.inviteSubtitle),
        AppCodeInput(
          controller: code,
          length: kValueInviteCodeLength,
          label: l10n.inviteTitle,
          onSubmitted: (value) => open(controller.resolve(value)),
        ),
        Row(
          children: [
            divider,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
              child: Text(
                l10n.commonOr,
                style: AppTypography.adapt(
                  context,
                  AppTypography.caption.copyWith(
                    height: 16 / 13,
                    color: kColorTextTertiary9C928A,
                  ),
                ),
              ),
            ),
            divider,
          ],
        ),
        AppButton.social(
          label: l10n.inviteScanQr,
          icon: LucideIcons.scanLine,
          onPressed: () => open(controller.sampleCode),
        ),
      ],
    );
  }
}
