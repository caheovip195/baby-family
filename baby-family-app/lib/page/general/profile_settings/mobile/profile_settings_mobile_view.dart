import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/settings/profile_settings.dart';
import 'package:baby_family/data/model/settings/sign_in_method.dart';
import 'package:baby_family/page/general/profile_settings/profile_settings_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/media_image.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_caps_label.dart';
import 'package:baby_family/utils/widget/app_grouped_list.dart';
import 'package:baby_family/utils/widget/app_initial_avatar.dart';
import 'package:baby_family/utils/widget/app_pill_button.dart';
import 'package:baby_family/utils/widget/app_settings_row.dart';
import 'package:baby_family/utils/widget/app_text_field.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/profile_avatar.dart';
part '../widgets/sign_in_row.dart';

/// SET-02 — Hồ sơ (Pencil `wtfze`). “Lưu thay đổi” lưu rồi quay lại SET-01.
class ProfileSettingsMobileView extends HookConsumerWidget {
  const ProfileSettingsMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(profileSettingsControllerProvider);
    final l10n = context.l10n;
    final profile = controller.profile;

    Future<void> save() async {
      await controller.save();
      if (!context.mounted) {
        return;
      }
      showAppSnackBar(context, l10n.setChangesSaved);
      await context.router.maybePop();
    }

    Widget body;
    if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else if (profile == null) {
      body = const SizedBox.shrink();
    } else {
      body = _content(context, controller, profile, save);
    }
    return BaseScaffold(appBar: const AppTopBar(), body: body);
  }

  Widget _content(
    BuildContext context,
    ProfileSettingsController controller,
    ProfileSettings profile,
    VoidCallback save,
  ) {
    final l10n = context.l10n;
    const gap = SizedBox(height: AppSpacing.cardInset);
    final hintStyle = AppTypography.adapt(
      context,
      AppTypography.small.copyWith(
        height: 1.45,
        color: kColorTextTertiary9C928A,
      ),
    );
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        AppSpacing.s8 + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        Text(
          l10n.settingsProfileTitle,
          style: AppTypography.adapt(context, AppTypography.h1),
        ),
        gap,
        _ProfileAvatar(
          callName: profile.callName,
          asset: profile.avatarAsset,
          isMother: controller.role != FamilyRole.father,
          onChange: kValueUseRemoteSession
              ? () => _pickAvatar(controller)
              : () => showComingSoonSnackBar(context),
        ),
        gap,
        AppTextField(
          label: l10n.setProfileName,
          initialValue: profile.name,
          onChanged: controller.setName,
        ),
        gap,
        AppTextField(
          label: l10n.setProfileCallName,
          initialValue: profile.callName,
          onChanged: controller.setCallName,
        ),
        gap,
        Text(l10n.setProfileCallNameHint(profile.callName), style: hintStyle),
        gap,
        AppCapsLabel(l10n.setSignInSection),
        gap,
        AppGroupedList(
          children: [
            for (final method in controller.methods)
              _SignInRow(
                method: method,
                // Bản server: số điện thoại → màn đổi số (OTP số cũ + số mới).
                linkedAction:
                    kValueUseRemoteSession && method.method == AuthMethod.phone
                    ? l10n.setChangePhone
                    : null,
                onToggle:
                    kValueUseRemoteSession && method.method == AuthMethod.phone
                    ? () => context.router.push(const ChangePhoneRoute())
                    : () => controller.toggleLink(method.method),
              ),
          ],
        ),
        gap,
        Text(l10n.setSignInHint, style: hintStyle),
        gap,
        AppCapsLabel(l10n.setTimezoneSection),
        gap,
        AppGroupedList(
          children: [
            AppSettingsRow.toggle(
              title: l10n.setAutoTimezone,
              subtitle: l10n.setAutoTimezoneHint,
              value: profile.autoTimezone,
              onChanged: controller.setAutoTimezone,
            ),
            AppSettingsRow(
              title: l10n.setPersonalTimezone,
              value: profile.timezoneLabel,
              onTap: () => showComingSoonSnackBar(context),
            ),
          ],
        ),
        gap,
        AppButton(
          label: l10n.setSaveChanges,
          isLoading: controller.isLoading,
          onPressed: save,
        ),
      ],
    );
  }
}

/// AUTH-04: chọn một ảnh (photo picker hệ thống), thu nhỏ như ảnh ký ức.
Future<void> _pickAvatar(ProfileSettingsController controller) async {
  final picked = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    maxWidth: kValueUploadImageMaxSide,
    maxHeight: kValueUploadImageMaxSide,
    imageQuality: kValueUploadImageQuality,
  );
  if (picked != null) {
    controller.setAvatar(picked.path);
  }
}
