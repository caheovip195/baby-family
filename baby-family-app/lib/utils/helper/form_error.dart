import 'package:baby_family/utils/extension/l10n.dart';
import 'package:flutter/widgets.dart';

/// Resolves validation codes at render time so language changes apply immediately.
String? formError(BuildContext context, String? code) => switch (code) {
  'required' => context.l10n.errorRequired,
  'phone' => context.l10n.errorPhone,
  'consent' => context.l10n.errorConsent,
  'otp' => context.l10n.errorOtp,
  'otpExpired' => context.l10n.errorOtpExpired,
  'invite' => context.l10n.errorInviteCode,
  'birthday' => context.l10n.errorBirthday,
  'week' => context.l10n.errorPregnancyWeek,
  _ => null,
};
