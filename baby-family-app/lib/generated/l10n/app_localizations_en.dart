// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Baby Family';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonStart => 'Get started';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonClose => 'Close';

  @override
  String get commonCopyError => 'Copy error';

  @override
  String commonDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days left',
      one: '1 day left',
      zero: 'Today is the last day',
    );
    return '$_temp0';
  }

  @override
  String commonUpdatedAt(DateTime time) {
    final intl.DateFormat timeDateFormat = intl.DateFormat.Hm(localeName);
    final String timeString = timeDateFormat.format(time);

    return 'Updated at $timeString';
  }

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNetwork =>
      'Can\'t reach the server. Please check your connection and try again.';

  @override
  String get errorRenewSessionNetwork =>
      'Can\'t reach the server to renew your session. Please check your connection and try again.';

  @override
  String get errorSessionExpired =>
      'Your session has expired. Please sign in again.';

  @override
  String get errorUpgradeRequired =>
      'This version of the app is out of date. Please update to continue.';

  @override
  String get errorStartupTitle => 'The app couldn\'t start';

  @override
  String get errorStartupDescription =>
      'Please reopen the app. If the problem persists, send the details below to our support team:';

  @override
  String get languagePickerTitle => 'Choose language';

  @override
  String get welcomeSlide1Title => 'Keep your child\'s journey';

  @override
  String get welcomeSlide1Description =>
      'From the first ultrasound to the first wobbly steps — every moment stays private to your family.';

  @override
  String get welcomeSlide2Title => 'Papa & Mama caring together';

  @override
  String get welcomeSlide2Description =>
      'Small daily missions help Papa and Mama share childcare without having to remind each other.';

  @override
  String get welcomeSlide3Title => 'Grandparents along for the ride';

  @override
  String get welcomeSlide3Description =>
      'Invite grandparents and relatives to watch your little one grow — safely, no social network needed.';

  @override
  String get welcomeHaveInviteCode => 'I have an invite code';
}
