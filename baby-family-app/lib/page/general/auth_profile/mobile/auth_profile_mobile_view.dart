import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/general/auth_profile/auth_profile_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/router/session_route.dart';
import 'package:baby_family/utils/widget/app_avatar_picker.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_step_heading.dart';
import 'package:baby_family/utils/widget/app_step_scaffold.dart';
import 'package:baby_family/utils/widget/app_text_field.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/consent_row.dart';

/// AUTH-04 (Pencil G3AHA): avatar 104 + huy hiệu “+”; ô “Tên của bạn”; 2 ô
/// đồng ý (điều khoản, xử lý dữ liệu); nút “Tiếp tục”.
class AuthProfileMobileView extends HookConsumerWidget {
  const AuthProfileMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(authProfileControllerProvider);
    final name = useTextEditingController(text: controller.initialName);
    useEffect(() {
      if (controller.samplesLoaded && name.text.isEmpty) {
        name.text = controller.initialName;
      }
      return null;
    }, [controller.samplesLoaded]);
    final l10n = context.l10n;
    return AppStepScaffold(
      topBar: const AppTopBar(),
      actions: [
        AppButton(
          label: l10n.commonContinue,
          isLoading: controller.isLoading,
          onPressed: () async {
            final saved = await runWithErrorSnackBar(
              context,
              () => controller.save(name.text),
            );
            if (!saved || !context.mounted) {
              return;
            }
            final session = controller.session;
            if (session.state == SessionState.needsRole) {
              await context.router.push(const OnboardingRoleRoute());
            } else {
              await context.router.replaceAll([routeForSession(session)]);
            }
          },
        ),
      ],
      children: [
        AppStepHeading(
          title: l10n.authProfileTitle,
          subtitle: l10n.authProfileSubtitle,
        ),
        Center(
          child: AppAvatarPicker(
            showAddBadge: true,
            semanticLabel: l10n.authChangeAvatar,
            onTap: () {},
          ),
        ),
        AppTextField(
          label: l10n.authNameLabel,
          hint: l10n.authNameHint,
          controller: name,
          textInputAction: TextInputAction.done,
        ),
        Column(
          children: [
            _ConsentRow(
              label: l10n.authTermsConsent,
              checked: controller.acceptTerms,
              onTap: controller.toggleTerms,
            ),
            const SizedBox(height: AppSpacing.cardInset),
            _ConsentRow(
              label: l10n.authDataConsent,
              checked: controller.acceptData,
              onTap: controller.toggleData,
            ),
          ],
        ),
      ],
    );
  }
}
