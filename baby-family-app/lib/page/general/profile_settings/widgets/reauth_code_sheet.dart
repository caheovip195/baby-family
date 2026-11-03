part of '../mobile/profile_settings_mobile_view.dart';

/// Liên kết / gỡ Apple, Google (bản server): xác thực lại rồi đổi; huỷ hộp
/// thoại của nhà cung cấp hoặc đóng sheet mã thì im lặng.
Future<void> _changeLink(
  BuildContext context,
  ProfileSettingsController controller,
  AuthMethod method,
) async {
  final l10n = context.l10n;
  try {
    final changed = await controller.changeLink(
      method,
      askOtp: () => showAppBottomSheet<String>(
        context,
        builder: (_) => const _ReauthCodeSheet(),
      ),
    );
    if (changed && context.mounted) {
      showAppSnackBar(context, l10n.setChangesSaved);
    }
  } on UserCancelled {
    return;
  } on Object catch (error) {
    if (context.mounted) {
      showAppSnackBar(context, actionErrorMessage(error));
    }
  }
}

/// Nhập mã OTP vừa gửi tới số hiện tại; “Tiếp tục” trả mã cho controller.
class _ReauthCodeSheet extends StatefulWidget {
  const _ReauthCodeSheet();

  static const _otpLength = 6;

  @override
  State<_ReauthCodeSheet> createState() => _ReauthCodeSheetState();
}

class _ReauthCodeSheetState extends State<_ReauthCodeSheet> {
  String _code = '';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: AppBottomSheet(
        title: l10n.setSignInReauthTitle,
        children: [
          Text(
            l10n.phoneChangeReauthHint,
            style: AppTypography.adapt(
              context,
              AppTypography.body.copyWith(
                color: AppColors.resolve(context, kColorTextSecondary6B625B),
              ),
            ),
          ),
          AppTextField(
            label: l10n.authOtpTitle,
            keyboardType: TextInputType.number,
            maxLength: _ReauthCodeSheet._otpLength,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofocus: true,
            onChanged: (value) => setState(() => _code = value.trim()),
          ),
          AppButton(
            label: l10n.commonContinue,
            height: 44,
            onPressed: _code.length == _ReauthCodeSheet._otpLength
                ? () => Navigator.of(context).pop(_code)
                : null,
          ),
        ],
      ),
    );
  }
}
