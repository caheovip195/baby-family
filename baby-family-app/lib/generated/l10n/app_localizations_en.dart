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
      'Invite grandparents and relatives to watch your child grow — safe and private, without social media.';

  @override
  String get welcomeHaveInviteCode => 'I have an invite code';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDone => 'Done';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonSeeAll => 'See all';

  @override
  String get commonBack => 'Back';

  @override
  String get commonEmptyTitle => 'Nothing here yet';

  @override
  String get commonEmptyMessage => 'Save a first moment for your family.';

  @override
  String get commonOffline =>
      'You are offline. Your saved content is still here.';

  @override
  String get commonMockMode => 'Sample data';

  @override
  String get commonAllFamily => 'Whole family';

  @override
  String get commonMine => 'Mine';

  @override
  String commonPartnerTasks(String callName) {
    return '$callName’s tasks';
  }

  @override
  String get commonTogether => 'Together';

  @override
  String get commonOnlyYou => 'Only me';

  @override
  String get commonOnlyParents => 'Only Papa & Mama';

  @override
  String get commonPhotos => 'Photos';

  @override
  String get commonTimeline => 'Timeline';

  @override
  String get commonCollections => 'Collections';

  @override
  String get commonMemory => 'Memory';

  @override
  String get commonDiary => 'Diary';

  @override
  String get commonMilestone => 'Milestone';

  @override
  String get commonLetter => 'Letter to your child';

  @override
  String get commonMission => 'Task';

  @override
  String get commonEvent => 'Event';

  @override
  String get commonCheckin => 'Mood check-in';

  @override
  String get commonRequest => 'Request';

  @override
  String get commonThanks => 'Thank you';

  @override
  String get commonSelectChild => 'Choose child';

  @override
  String get commonQuickCreate => 'Capture a little moment';

  @override
  String get commonName => 'Name';

  @override
  String get commonDate => 'Date';

  @override
  String get commonBody => 'Content';

  @override
  String get commonSaved => 'Saved in the demo';

  @override
  String get commonInvalidInput => 'Please fill in the details before saving.';

  @override
  String commonChildAge(int months, int years) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months months',
      one: '1 month',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months months',
      one: '1 month',
    );
    String _temp2 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months months',
      one: '1 month',
    );
    String _temp3 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years years $_temp0',
      one: '1 year $_temp1',
      zero: '$_temp2',
    );
    return '$_temp3';
  }

  @override
  String commonPregnancyWeek(int week) {
    return 'Week $week of pregnancy';
  }

  @override
  String commonCountMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count memories',
      one: '1 memory',
    );
    return '$_temp0';
  }

  @override
  String commonHearts(int count) {
    return '$count Hearts';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navMemories => 'Memories';

  @override
  String get navCare => 'Care';

  @override
  String get navUs => 'Papa & Mama';

  @override
  String homeGreeting(String name) {
    return 'Hello, $name';
  }

  @override
  String get homeToday => 'Your children today';

  @override
  String get homeSpecialDay => 'Special day';

  @override
  String get homeMonthlyPhoto => 'Take monthly photo';

  @override
  String get homeMissions => 'Today’s missions';

  @override
  String get homePrompt => 'A moment to capture';

  @override
  String get homeRecordQuote => 'Record quote';

  @override
  String get homeRecent => 'New in the family';

  @override
  String get homeThisWeek => 'Your family this week';

  @override
  String get homeFamilyTree => 'Family tree';

  @override
  String get homeFamily => 'My family';

  @override
  String get careTitle => 'Care';

  @override
  String get careTodayTree => 'Today’s tree';

  @override
  String careProgress(int done, int total) {
    return '$done/$total family tasks';
  }

  @override
  String get careAddMission => 'Add task';

  @override
  String get careMissionTitle => 'Task name';

  @override
  String get careWhoDoes => 'Who will do it?';

  @override
  String get careWhen => 'When?';

  @override
  String get careReminder => 'Gentle reminder';

  @override
  String get careRepeat => 'Repeat';

  @override
  String careAskPartner(String callName) {
    return 'Ask $callName to help';
  }

  @override
  String get careCompleteTitle => 'A little task, a little love';

  @override
  String get careSaveMoment => 'Save as a memory';

  @override
  String get careUndo => 'Undo';

  @override
  String get careSwapTitle => 'Swap task';

  @override
  String get careRemoveToday => 'Remove from today (no deduction)';

  @override
  String get careTreeTitle => 'Family tree';

  @override
  String careTreeLevel(int level) {
    return 'Level $level';
  }

  @override
  String get careTreeNext => 'Help your tree grow a little more';

  @override
  String get careContribution => 'Family contributions';

  @override
  String get careHeartsPrivacy =>
      'Only you can see your Hearts. They are never compared or deducted.';

  @override
  String get usTitle => 'Papa & Mama';

  @override
  String get usHowAreYou => 'How are you feeling today?';

  @override
  String get usEnergy => 'Your energy';

  @override
  String get usNeed => 'What do you need?';

  @override
  String usShareWith(String callName) {
    return 'Share with $callName';
  }

  @override
  String get usPrivate => 'A private space for Papa & Mama';

  @override
  String get usSendRequest => 'Send a request';

  @override
  String get usRequestMessage => 'What would you like help with?';

  @override
  String get usAccept => 'I can help';

  @override
  String get usDecline => 'I can’t today';

  @override
  String get usRequestAccepted => 'Accepted';

  @override
  String get usRequestDone => 'Done';

  @override
  String get usDailyQuestion => 'Today’s connection question';

  @override
  String get usJournal => 'Private journal';

  @override
  String get usBridge => 'A little bridge between us';

  @override
  String get usWeek => 'Our week together';

  @override
  String get usHug => 'Send a hug';

  @override
  String get usSeen => 'Seen';

  @override
  String get usTakeOver => 'I’ll take over';

  @override
  String get usThanksRecent => 'Recent thank-yous';

  @override
  String get familyTitle => 'My family';

  @override
  String get familyChildren => 'Children';

  @override
  String get familyParents => 'Papa & Mama';

  @override
  String get familyRelatives => 'Grandparents & relatives';

  @override
  String get familyInvite => 'Invite relatives';

  @override
  String get familyPermissions => 'Permissions';

  @override
  String get familyPrivateNotice =>
      'Relatives only see what you share. Papa & Mama always stays private.';

  @override
  String get familyTrial => 'Free trial';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsLight => 'Light';

  @override
  String get settingsDark => 'Dark';

  @override
  String get settingsSystem => 'System';

  @override
  String get settingsTextSize => 'Text size';

  @override
  String get settingsRegular => 'Regular';

  @override
  String get settingsLarge => 'Large';

  @override
  String get settingsExtraLarge => 'Extra large';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsAi => 'AI assistance';

  @override
  String get settingsSecurity => 'Security & Devices';

  @override
  String get settingsData => 'My data';

  @override
  String get settingsBilling => 'Plans & payments';

  @override
  String get settingsHelp => 'Help';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsLogout => 'Sign out';

  @override
  String get settingsLanguageNotice =>
      'Changes apply immediately, without restarting. Family-written content is not translated.';

  @override
  String get settingsLunar => 'Show lunar dates';

  @override
  String get settingsHaptics => 'Haptic feedback';

  @override
  String get billingTitle => 'Keep every precious moment';

  @override
  String get billingHouse => 'House';

  @override
  String get billingFamily => 'Family';

  @override
  String get billingRestore => 'Restore purchases';

  @override
  String get billingUpgrade => 'Upgrade plan';

  @override
  String get billingExpired => 'Your family’s 3-month trial has ended';

  @override
  String get billingExport => 'Download data';

  @override
  String get billingPrivacy =>
      'Your memories belong to your family. You can download your data even after your plan expires.';

  @override
  String get billingFamilyFeatures => 'Up to 12 relatives · 200 GB storage';

  @override
  String get billingHouseFeatures => 'For Papa & Mama · 50 GB storage';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsAll => 'All';

  @override
  String get notificationsPrivate => 'Papa & Mama';

  @override
  String get stateLoading => 'Loading…';

  @override
  String get stateEmptyMemories => 'No memories yet. Save your first moment!';

  @override
  String get stateEmptyCare => 'No tasks today yet';

  @override
  String get stateError => 'Could not load content. Please try again.';

  @override
  String get commonChoose => 'Choose';

  @override
  String get commonRequired => 'Please fill in this field';

  @override
  String get memoriesTitle => 'Memories';

  @override
  String get memoriesTimeline => 'Timeline';

  @override
  String get memoriesPhotos => 'Photos';

  @override
  String get memoriesCollections => 'Collections';

  @override
  String get memoriesAll => 'All';

  @override
  String get memoriesFirsts => 'Firsts';

  @override
  String get memoriesQuotes => 'Quotes';

  @override
  String get memoriesVoices => 'Voices';

  @override
  String get memoriesNew => 'New memory';

  @override
  String get memoriesCaptionHint =>
      'What would you like to remember about this moment?';

  @override
  String get memoriesChildren => 'Children in this moment';

  @override
  String get memoriesFamily => 'The whole family';

  @override
  String get memoriesDate => 'Date of the moment';

  @override
  String get memoriesToday => 'Today';

  @override
  String get memoriesVisibility => 'Who can see';

  @override
  String get memoriesPrivacyHint =>
      'GPS location in photos is removed before saving.';

  @override
  String get memoriesAddMedia => 'Add photos';

  @override
  String get memoriesAddPerspective => 'Add your perspective';

  @override
  String get memoriesTogether => 'Told together';

  @override
  String get memoriesCommentHint => 'Write a comment…';

  @override
  String get memoriesComments => 'Comments';

  @override
  String get memoriesSend => 'Send';

  @override
  String get memoriesMonthly => 'Growing month by month';

  @override
  String get memoriesYear => 'First year';

  @override
  String get memoriesCompare => 'Compare';

  @override
  String get memoriesCollage => 'Collage';

  @override
  String get memoriesMonthlyPhoto => 'Monthly photo';

  @override
  String get memoriesGhost => 'Previous photo guide';

  @override
  String get memoriesGallery => 'Choose from library';

  @override
  String get memoriesCapture => 'Take photo';

  @override
  String get memoriesQuote => 'Your child’s words';

  @override
  String get memoriesQuoteHint => 'What did your child say today?';

  @override
  String get memoriesQuoteContext => 'When did your child say this?';

  @override
  String get memoriesRecordVoice => 'Record their voice';

  @override
  String get memoriesPerspective => 'Your perspective';

  @override
  String get memoriesPerspectiveHint =>
      'What do you remember about this moment?';

  @override
  String get memoriesInheritedVisibility =>
      'Same viewers as the original memory';

  @override
  String get memoriesStory => 'Your child today';

  @override
  String get memoriesReplyHint => 'Reply…';

  @override
  String get memoriesEmpty => 'No memories yet. Save your first moment!';

  @override
  String get memoriesSaved => 'Your moment has been saved';

  @override
  String get memoriesChooseChildren =>
      'Choose at least one child or the whole family';

  @override
  String memoriesMonthLabel(int month) {
    String _temp0 = intl.Intl.pluralLogic(
      month,
      locale: localeName,
      other: '$month months',
      one: '1 month',
    );
    return '$_temp0';
  }

  @override
  String memoriesWeekLabel(int week) {
    return 'Week $week';
  }

  @override
  String memoriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count memories',
      one: '1 memory',
    );
    return '$_temp0';
  }

  @override
  String get pregnancyTitle => 'Pregnancy journey';

  @override
  String get pregnancyBump => 'Bump photos';

  @override
  String get pregnancyUltrasound => 'Ultrasound';

  @override
  String get pregnancyPreparations => 'Preparations';

  @override
  String get pregnancyCaptureBump => 'Take this week’s bump photo';

  @override
  String get pregnancyGuide =>
      'Use the previous photo guide to keep the same angle';

  @override
  String get pregnancyBumpKindness =>
      'It is okay to miss a few weeks. Every photo is precious.';

  @override
  String get pregnancyRemind => 'Remind me every Sunday';

  @override
  String get pregnancyBirth => 'Our baby is here';

  @override
  String get pregnancyNames => 'Names for our baby';

  @override
  String get pregnancyArchive => 'Archive this journey';

  @override
  String pregnancyPrepareProgress(int done, int total) {
    return 'Prepared $done/$total';
  }

  @override
  String get pregnancyAddPreparation => 'Add an item';

  @override
  String get pregnancyPreparationHint => 'An item to prepare';

  @override
  String get pregnancyCreateMission => 'Create a task';

  @override
  String get pregnancyBirthWelcome => 'Welcome to our family';

  @override
  String get pregnancyBabyName => 'Name or nickname';

  @override
  String get pregnancyNickname => 'Nickname';

  @override
  String get pregnancyBirthDate => 'Date of birth *';

  @override
  String get pregnancyBirthTime => 'Time of birth';

  @override
  String get pregnancyBirthWeight => 'Weight (kg)';

  @override
  String get pregnancyBirthGender => 'Gender (optional)';

  @override
  String get pregnancyBirthPreview => 'View welcome card';

  @override
  String get pregnancyAnnounce => 'Share the news with relatives?';

  @override
  String get pregnancyAnnounceHint =>
      'Only relatives with access to the pregnancy. Pregnancy memories become the first chapter of your baby’s story.';

  @override
  String get pregnancyBirthComplete =>
      'Welcome, little one! The details have been saved.';

  @override
  String get pregnancyArchiveIntro =>
      'All memories will be kept. You can come back whenever you wish.';

  @override
  String get pregnancyPause => 'Pause the journey';

  @override
  String get pregnancyPauseHint =>
      'Hide from Home and turn off reminders. Return whenever you wish.';

  @override
  String get pregnancyEnd => 'This journey has ended';

  @override
  String get pregnancyEndHint =>
      'We are sorry. Countdowns, reminders and greetings will stop immediately.';

  @override
  String get pregnancyParentsOnly => 'Only Papa & Mama can see these memories';

  @override
  String get pregnancyArchivePrivacy =>
      'No notifications will be sent to relatives.';

  @override
  String get pregnancyArchiveSaved => 'The journey has been archived privately';

  @override
  String get pregnancyPrivate => 'Only Papa & Mama can see this';

  @override
  String get pregnancyBothLike => 'Both like this';

  @override
  String get pregnancyAddName => 'Add a name idea';

  @override
  String get pregnancyNameHint => 'Name idea';

  @override
  String get pregnancyMeaning => 'Meaning';

  @override
  String get pregnancyChooseName => 'Choose this name';

  @override
  String get pregnancyNameChosen => 'The name idea has been saved';

  @override
  String get pregnancyMockMedia => 'Sample photo is ready';

  @override
  String get commonSkip => 'Skip';

  @override
  String get commonLater => 'Later';

  @override
  String get commonOr => 'or';

  @override
  String get commonCopied => 'Copied';

  @override
  String get commonChoosePhoto => 'Choose photo';

  @override
  String get commonRemovePhoto => 'Remove photo';

  @override
  String get commonTerms => 'Terms of use';

  @override
  String get commonPrivacyPolicy => 'Privacy policy';

  @override
  String get commonOptional => 'Optional';

  @override
  String get authTitle => 'Welcome to Baby Family';

  @override
  String get authSubtitle =>
      'Sign in to capture your child’s journey with the whole family.';

  @override
  String get authPrivate => 'Private';

  @override
  String get authTrial => '3 months free';

  @override
  String get authFamily => 'Whole family';

  @override
  String get authApple => 'Continue with Apple';

  @override
  String get authGoogle => 'Continue with Google';

  @override
  String get authPhone => 'Use phone number';

  @override
  String get authLegal =>
      'By continuing, you agree to Baby Family’s Terms of use and Privacy policy.';

  @override
  String get authPhoneTitle => 'Your phone number';

  @override
  String get authPhoneSubtitle =>
      'We will send a 6-digit verification code via Zalo or SMS.';

  @override
  String get authPhoneLabel => 'Phone number';

  @override
  String get authCountryCode => 'Country code';

  @override
  String get authPhonePrivate =>
      'Your phone number is used only for sign-in and stays private.';

  @override
  String get authSendCode => 'Send code';

  @override
  String get authOtpTitle => 'Enter verification code';

  @override
  String authOtpSubtitle(String phone) {
    return 'A 6-digit code was sent via Zalo to $phone.';
  }

  @override
  String authOtpDemo(String code) {
    return 'Demo code: $code';
  }

  @override
  String get authResend => 'Resend code';

  @override
  String authResendCountdown(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: 'Resend in ${seconds}s',
      one: 'Resend in 1s',
    );
    return '$_temp0';
  }

  @override
  String get authSendSms => 'Send via SMS';

  @override
  String get authChangePhone => 'Change phone number';

  @override
  String get authProfileTitle => 'Tell us about yourself';

  @override
  String get authProfileSubtitle =>
      'Your partner and family members will see this name.';

  @override
  String get authNameLabel => 'Your name';

  @override
  String get authTermsConsent => 'I agree to the Terms of use';

  @override
  String get authDataConsent =>
      'I agree to Baby Family processing my and my child’s personal data under the Privacy policy';

  @override
  String get errorRequired => 'Please fill this in.';

  @override
  String get errorPhone => 'Please enter a valid phone number.';

  @override
  String get errorConsent => 'Please accept both items to continue.';

  @override
  String get errorOtp => 'That code is not correct. Please try again.';

  @override
  String get errorOtpExpired => 'This code has expired. Please resend it.';

  @override
  String get errorInviteCode => 'An invite code has 8 letters and digits.';

  @override
  String get errorBirthday => 'Birthday cannot be in the future.';

  @override
  String get errorPregnancyWeek => 'Pregnancy week must be between 4 and 42.';

  @override
  String get onboardingRoleTitle => 'Who are you in the family?';

  @override
  String get onboardingRoleSubtitle =>
      'Baby Family brings Papa and Mama together. Invite grandparents and relatives later.';

  @override
  String get onboardingPapaDescription =>
      'Your child’s father, managing the family with Mama';

  @override
  String get onboardingMamaDescription =>
      'Your child’s mother, managing the family with Papa';

  @override
  String get onboardingCircle => 'Family member';

  @override
  String get onboardingCircleDescription =>
      'Grandparents, relatives and carers need an invitation to join';

  @override
  String get onboardingCallName => 'Your children call you';

  @override
  String get onboardingOtherCallName => 'Other…';

  @override
  String get onboardingFatherCallName => 'Dad';

  @override
  String get onboardingFatherCallNameAlt => 'Daddy';

  @override
  String get onboardingMotherCallName => 'Mom';

  @override
  String get onboardingMotherCallNameAlt => 'Mommy';

  @override
  String get onboardingFamilyTitle => 'Name your family home';

  @override
  String get onboardingFamilySubtitle =>
      'Only Papa, Mama and invited family members see this name.';

  @override
  String get onboardingFamilyName => 'Family name';

  @override
  String get onboardingCreateFamily => 'Create family';

  @override
  String onboardingInviteTitle(String callName) {
    return 'Invite $callName to join';
  }

  @override
  String get onboardingInviteSubtitle =>
      'Baby Family needs Papa and Mama. When your partner joins, your family starts a free 3-month trial.';

  @override
  String get onboardingInviteCode => 'Invite code';

  @override
  String get onboardingInviteExpiry => 'Expires in 7 days · single use';

  @override
  String get onboardingInviteApproval => 'I confirm when my partner joins';

  @override
  String get onboardingShareInvite => 'Share via Zalo, Messenger…';

  @override
  String get onboardingCopyInvite => 'Copy invitation link';

  @override
  String get onboardingInviteSent => 'Invitation sent';

  @override
  String onboardingWaitingTitle(String callName) {
    return 'Waiting for $callName to join…';
  }

  @override
  String get onboardingWaitingSubtitle =>
      'When your partner accepts, your family home unlocks with a free 3-month trial.';

  @override
  String get onboardingResendInvite => 'Resend invitation';

  @override
  String get onboardingShowQr => 'Show QR code';

  @override
  String get onboardingChangeInvite => 'Change invitation';

  @override
  String get onboardingCancelFamily => 'Cancel this family';

  @override
  String get onboardingActivateDemo => 'Simulate partner joining';

  @override
  String get onboardingActivatedTitle => 'Papa & Mama are both here 🎉';

  @override
  String get onboardingActivatedSubtitle =>
      'Capture your child’s journey, share care and understand one another.';

  @override
  String get onboardingTrial => '3 months free trial';

  @override
  String get onboardingSetupChild => 'Set up your child';

  @override
  String get onboardingStageTitle => 'What stage is your family at?';

  @override
  String get onboardingStageSubtitle =>
      'You can add another child or pregnancy anytime.';

  @override
  String get onboardingPregnant => 'Expecting a baby';

  @override
  String get onboardingPregnantDescription =>
      'Save bump photos, scans and letters, and prepare for your baby';

  @override
  String get onboardingBorn => 'Baby has arrived';

  @override
  String get onboardingBornDescription =>
      'Create your child’s profile, save firsts and share care';

  @override
  String get onboardingBoth => 'Have a child and expecting';

  @override
  String get onboardingBothDescription =>
      'Keep multiple children and pregnancies in one family';

  @override
  String get onboardingPregnancyTitle => 'Hello, little one';

  @override
  String get onboardingPregnancySubtitle =>
      'Start with a nickname. You can add the other details later.';

  @override
  String get onboardingNickname => 'Baby’s nickname';

  @override
  String get onboardingDueDate => 'Due date';

  @override
  String get onboardingKnowWeek => 'I only know the pregnancy week';

  @override
  String get onboardingWeek => 'Pregnancy week';

  @override
  String get onboardingBabyCount => 'Number of babies';

  @override
  String get onboardingSingle => 'One baby';

  @override
  String get onboardingTwins => 'Twins';

  @override
  String get onboardingTriplets => 'Triplets';

  @override
  String get onboardingSkipDueDate => 'Skip due date';

  @override
  String get onboardingChildTitle => 'Introduce your child';

  @override
  String get onboardingChildSubtitle =>
      'A name or nickname and birthday are enough to start.';

  @override
  String get onboardingChildName => 'Name or nickname';

  @override
  String get onboardingBirthday => 'Birthday';

  @override
  String get onboardingBoy => 'Boy';

  @override
  String get onboardingGirl => 'Girl';

  @override
  String get onboardingAddChild => 'Add another child';

  @override
  String get onboardingPrivacyTitle => 'Your family’s private space';

  @override
  String get onboardingPrivacySubtitle =>
      'Baby Family protects your most precious moments.';

  @override
  String get onboardingPrivacyInvited =>
      'Only invited people see your child’s photos';

  @override
  String get onboardingPrivacyInvitedDescription =>
      'No public pages. Your family cannot be searched.';

  @override
  String get onboardingPrivacyUs => 'Papa & Mama is your private corner';

  @override
  String get onboardingPrivacyUsDescription =>
      'Feelings, requests and private journals stay between you.';

  @override
  String get onboardingPrivacyData => 'Your data belongs to you';

  @override
  String get onboardingPrivacyDataDescription =>
      'Download or delete it anytime in Settings.';

  @override
  String get onboardingUnderstood => 'Got it';

  @override
  String get onboardingNotificationsTitle => 'Stay close to every moment';

  @override
  String get onboardingNotificationsSubtitle =>
      'Receive Papa/Mama’s tasks, new photos and support requests. Manage categories and quiet hours in Settings.';

  @override
  String get onboardingEnableNotifications => 'Enable notifications';

  @override
  String get inviteTitle => 'Enter invitation code';

  @override
  String get inviteSubtitle =>
      'The 8-character code is in your invitation from Papa or Mama.';

  @override
  String get inviteView => 'View invitation';

  @override
  String get inviteScanQr => 'Scan QR code';

  @override
  String get inviteUseDemo => 'Use demo invitation';

  @override
  String get inviteJoin => 'Join family';

  @override
  String get inviteDecline => 'Decline';

  @override
  String get inviteRole => 'Your role';

  @override
  String get inviteAccepted => 'Invitation accepted in the demo';

  @override
  String get inviteDeclined => 'Invitation declined in the demo';

  @override
  String get inviteInvalidTitle => 'Invitation is no longer valid';

  @override
  String get inviteInvalidDescription => 'Please ask for a new invitation.';

  @override
  String get circleWaitingTitle => 'Your family needs to invite you';

  @override
  String get circleWaitingSubtitle =>
      'Once Papa or Mama invites you, you can see your grandchild’s photos and firsts.';

  @override
  String get circleAskInvite => 'Ask family to invite you';

  @override
  String get circleAskMessage =>
      'I’ve installed Baby Family. Please invite me to see our little one’s moments.';

  @override
  String get circleSwitchRole => 'I am the child’s Papa/Mama';

  @override
  String get circleSignOut => 'Sign out';

  @override
  String get authDemoDescription =>
      'Sign-in and permissions are simulated using sample data.';

  @override
  String get authDemoAction => 'Continue with sample data';

  @override
  String get onboardingFirstMemoryTitle => 'Your family’s first memory';

  @override
  String get onboardingFirstMemorySubtitle =>
      'Save your little one’s first moment in Baby Family.';

  @override
  String get onboardingFirstMemoryChoosePhoto => 'Choose a photo';

  @override
  String get memoriesKeepsakes => 'Keepsakes';

  @override
  String get memoriesBest => 'Our favorite family photos';

  @override
  String get memoriesRecordedVoice => 'Sample voice clip saved';

  @override
  String get familyRelationship => 'This person is…';

  @override
  String get familyCallName => 'Your child calls them';

  @override
  String get familyPhotosPermission => 'View photos & memories';

  @override
  String get familyFirstsPermission => 'Like & comment';

  @override
  String get familyDownloadPermission => 'Contribute photos';

  @override
  String get familyInvitePreview => 'Preview sharing access';

  @override
  String get familyHidden =>
      'Papa & Mama, tasks and private content always stay private.';

  @override
  String get familyCreateInvite => 'Create invitation';

  @override
  String get familyInviteCreated =>
      'Sample invitation created. No message has been sent.';

  @override
  String get billingMockNotice =>
      'This is sample data. Plan selection, restore and export are simulated.';

  @override
  String get billingSelected =>
      'Plan selected in the demo. No transaction was made.';

  @override
  String get billingRestored => 'Purchase restoration simulated.';

  @override
  String get billingExportReady =>
      'Data export request simulated. Your family’s memories are safe.';

  @override
  String get notificationsReadAll => 'Mark all read';

  @override
  String get circleGreeting => 'Our little ones';

  @override
  String get circleSendWish => 'Send a wish';

  @override
  String get settingsDemoSection =>
      'Options in this section are simulated using sample data.';

  @override
  String get usNeedSpace => 'A little quiet time';

  @override
  String get usNeedTalk => 'Someone to listen';

  @override
  String get usBridgeAngry => 'I feel upset';

  @override
  String get usBridgeStuck => 'I cannot find the words';

  @override
  String get usBridgeHint =>
      'Share how you feel and what you need. You can pause and return when you are ready.';

  @override
  String get usThanksHint => 'What would you like to thank them for today?';

  @override
  String get usJournalHint => 'A place to write down what is on your mind.';

  @override
  String get usNeedHelp => 'Practical help';

  @override
  String get usBridgeEmotion => 'I am feeling…';

  @override
  String get usBridgeAnger => 'Angry';

  @override
  String get usBridgePrivate => 'Only you can see what you write here';

  @override
  String get usBridgeDraft => 'Write a private draft, if you wish';

  @override
  String get usBridgeKeepPrivate => 'Keep private';

  @override
  String get usBridgePause => 'Pause';

  @override
  String get usThanksWall => 'Gratitude wall';

  @override
  String get settingsDisplayTitle => 'Display & Language';

  @override
  String get settingsOther => 'Other';

  @override
  String get settingsReduceMotion => 'Reduce motion';

  @override
  String get settingsReduceMotionHint => 'Fewer animations';

  @override
  String get settingsLunarHint => 'Alongside the solar date';

  @override
  String get settingsDeleteAccount => 'Delete account';

  @override
  String get familyManage => 'Manage family';

  @override
  String familyYou(String callName) {
    return '$callName (you)';
  }

  @override
  String get familyStorageLabel => 'Storage';

  @override
  String get familyViewPlans => 'View House / Family plans';

  @override
  String get familyAddChild => 'Add child / pregnancy';

  @override
  String get familyLockedTitle => 'Invite grandparents with Family';

  @override
  String get familyLockedDescription =>
      'The trial includes Papa & Mama. Upgrade to Family so grandparents and relatives can follow your children.';

  @override
  String get familyFollowing => 'Can follow';

  @override
  String get relationPaternalGrandfather => 'Paternal grandfather';

  @override
  String get relationPaternalGrandmother => 'Paternal grandmother';

  @override
  String get relationMaternalGrandfather => 'Maternal grandfather';

  @override
  String get relationMaternalGrandmother => 'Maternal grandmother';

  @override
  String get relationAunt => 'Aunt';

  @override
  String get relationUncle => 'Uncle';

  @override
  String get billingHouseChildren => 'Papa & Mama, unlimited children';

  @override
  String get billingHouseCare => 'Tasks, journals and Papa & Mama';

  @override
  String get billingHouseStorage => '50 GB storage';

  @override
  String get billingInviteRelatives => 'Invite grandparents and relatives';

  @override
  String get billingFamilyIncludes => 'Everything in House';

  @override
  String get billingFamilyRelatives => 'Invite up to 12 relatives';

  @override
  String get billingFamilyStorage => '200 GB, original quality photos';

  @override
  String get billingFamilyVideos => 'Videos up to 10 minutes, family updates';

  @override
  String get billingLegal =>
      'One plan covers your family. Papa or Mama can pay. Renews yearly; cancel anytime in App Store / Google Play settings. Terms · Privacy';

  @override
  String get billingChoosePlans => 'Choose House / Family';

  @override
  String get billingRetentionHint =>
      'We will notify you several times before deletion.';

  @override
  String get circleTitle => 'My dear grandchildren';

  @override
  String get circleNewPhotos => 'New photos this week';

  @override
  String get circleVoiceTip => 'Hold “Send a wish” to record your voice';

  @override
  String get notificationsToday => 'Today';

  @override
  String get notificationsYesterday => 'Yesterday';

  @override
  String stateEmptyMemoryTitle(String name) {
    return 'No memories of $name yet';
  }

  @override
  String get stateEmptyMemoryDescription =>
      'Save your first moment — a photo, a diary entry or your child’s laugh.';

  @override
  String get stateEmptyCareDescription =>
      'Choose a few small tasks for Papa & Mama to share.';

  @override
  String get stateErrorTitle => 'Could not load memories';

  @override
  String get stateErrorDescription =>
      'There is a small problem on our side. Your memories are safe. Try again in a moment.';

  @override
  String get stateErrorCode => 'Error: MEM-500 · Contact support';

  @override
  String get splashTagline => 'Grow together — Keep love forever';

  @override
  String get splashPreparing => 'Preparing your family’s space…';

  @override
  String get onboardingChildAvatarOptional => 'Add a profile photo (optional)';

  @override
  String get onboardingComplete => 'Done';

  @override
  String get onboardingSkipGender => 'Skip';

  @override
  String inviteJoinAsParent(String callName) {
    return 'Join as $callName';
  }

  @override
  String get memoriesMilestones => 'Milestones';

  @override
  String get memoriesAlbum => 'Album';

  @override
  String get memoriesChooseAlbum => 'Choose album';

  @override
  String get memoriesCaptionSuggestion => 'Caption suggestion';

  @override
  String get memoriesCover => 'Cover';

  @override
  String get memoriesVideo => 'Video [1.1]';

  @override
  String memoriesNextMonth(int month) {
    return 'Month $month · tomorrow';
  }

  @override
  String get memoriesPerspectivePrompt =>
      'What do you remember about this moment?';

  @override
  String get pregnancyHeight => 'Length';

  @override
  String get pregnancyBabyBoy => 'Boy';

  @override
  String get pregnancyBabyGirl => 'Girl';

  @override
  String get pregnancyLater => 'Later';

  @override
  String get pregnancyBirthBag => 'HOSPITAL BAG';

  @override
  String get pregnancyDocuments => 'DOCUMENTS';

  @override
  String get pregnancyNursery => 'BABY’S SPACE';

  @override
  String get pregnancySupport => 'Emotional support (optional)';

  @override
  String commonChildNameAge(String name, String age) {
    return '$name · $age';
  }

  @override
  String get homeEvening => 'Good evening,';

  @override
  String get homeTomorrow => 'TOMORROW';

  @override
  String get homeRecord => 'Record';

  @override
  String get homeParentsPrivacy => 'Papa & Mama · just you two';

  @override
  String get homeHug => 'A hug';

  @override
  String homeMomentCount(int count) {
    return '$count moments';
  }

  @override
  String homePhotoCount(int count) {
    return '$count photos';
  }

  @override
  String homeYourHearts(int count) {
    return '💗 $count mine';
  }

  @override
  String homeMoreMissions(int count) {
    return '+ $count more of my tasks · 💗 only you see';
  }

  @override
  String get careTreeBloom => 'Finish them all to help the tree bloom 🌸';

  @override
  String careMyHeartsToday(int count) {
    return 'My Hearts today: $count';
  }

  @override
  String get carePrivateHearts => 'Only you see';

  @override
  String get homeOtherPrompt => 'Another prompt';

  @override
  String commonWeek(int week) {
    return 'Week $week';
  }

  @override
  String homeChildToday(String name) {
    return '$name today';
  }

  @override
  String get homeFirstsRecent => 'Recent firsts';

  @override
  String homeChildMissions(String name) {
    return 'Tasks for $name today';
  }

  @override
  String get homeCompare => 'Compare';

  @override
  String careSwapHeading(String title) {
    return 'Swap “$title”';
  }

  @override
  String get careSwapHint =>
      'These choices have similar Hearts to keep your shared task board balanced.';

  @override
  String careSwapRemaining(int count) {
    return '$count swaps left today';
  }

  @override
  String get careSwapConfirm => 'Switch to this task';

  @override
  String careCompleteHearts(int count) {
    return 'Wonderful! +$count 💗 for the tree';
  }

  @override
  String careCompleteHint(String title) {
    return '$title — another leaf for the tree. (+2 💗 if you save a photo)';
  }

  @override
  String get careSaveMemoryQuestion => 'Save this moment?';

  @override
  String get careMemoryCaption => 'A short note about this moment…';

  @override
  String get careSaveMission => 'Save task';

  @override
  String pregnancyNamesFor(String child) {
    return 'Choose a name for $child';
  }

  @override
  String pregnancyChooseNameFor(String name, String child) {
    return 'Choose “$name” for $child';
  }

  @override
  String get memoriesSavePerspective => 'Save perspective · Both perspectives';

  @override
  String get circleViewComment => 'View & comment';

  @override
  String get homeStoryView => 'View as story';

  @override
  String get homeCurrentChapter => 'CURRENT CHAPTER';

  @override
  String get homeNextFirst => 'The next first?';

  @override
  String homeMonthShort(int month) {
    return '$month mo';
  }

  @override
  String get homeMomentLabel => 'moments';

  @override
  String get homeQuoteLabel => 'new quotes';

  @override
  String get commonFirsts => 'firsts';

  @override
  String get circleLike => 'Send a heart';

  @override
  String homeMonthlyProgress(int done, int total) {
    return '$done/$total photos';
  }

  @override
  String get stateAddMemory => 'Add memory';

  @override
  String get careCamera => 'Take photo';

  @override
  String get careGallery => 'Choose photo';

  @override
  String get carePhotoSelected => 'Photo selected';

  @override
  String get commonCamera => 'Camera';

  @override
  String get commonGallery => 'Library';

  @override
  String get careForWho => 'For whom?';

  @override
  String get careOneChild => 'One child';

  @override
  String get careManyChildren => 'Several children';

  @override
  String get careBothParents => 'Both of us';

  @override
  String get careWhenQuestion => 'When?';

  @override
  String get careWhoQuestion => 'Who does it?';

  @override
  String get careMemoryPrompt => 'Suggest a photo when done';

  @override
  String get careRemindBefore => 'Remind 15 minutes before';

  @override
  String careAskPartnerPrompt(String callName) {
    return 'Need $callName to help? Send a request →';
  }

  @override
  String get careTreeName => 'Green tree';

  @override
  String get careTreeGrows => 'Grown from Papa & Mama’s Hearts';

  @override
  String get careTreeNearBloom => 'A blooming tree is coming 🌸';

  @override
  String get careTreeReward => 'Reward: “Cherry blossom” album theme';

  @override
  String get careTreeMoments => 'Care moments';

  @override
  String get careTreeTogether => 'Times together';

  @override
  String get careTreeBloomDays => 'Blooming days';

  @override
  String get careTreeYourContribution => 'Your contribution';

  @override
  String get careTreeToday => 'Today';

  @override
  String get careTreeWeek => 'This week';

  @override
  String get careTreeTotal => 'Total';

  @override
  String memoriesSelectedPhotos(int count) {
    return '$count photos selected';
  }

  @override
  String get usOnlyTwo => 'Only you two can see';

  @override
  String usMe(String callName) {
    return '$callName (you)';
  }

  @override
  String usEnergyValue(int value) {
    return 'Energy $value/5';
  }

  @override
  String get usHugShort => 'Hug';

  @override
  String get usDailyQuestionShort => 'TODAY’S QUESTION';

  @override
  String get usBridgeShort => 'Bridge';

  @override
  String get usWeekShort => 'Our week';

  @override
  String get usCheckinTitle => 'How are you today?';

  @override
  String get usEnergyShort => 'Energy';

  @override
  String get usNeedShort => 'I need…';

  @override
  String get usNeedRest => 'Rest';

  @override
  String get usNeedChildcare => 'Help with childcare';

  @override
  String get usNeedQuiet => 'Quiet';

  @override
  String get usNeedHug => 'A hug';

  @override
  String get usNeedConversation => 'Talk';

  @override
  String get usNeedEncouragement => 'Encouragement';

  @override
  String get usOnlyMe => 'Only me';

  @override
  String usSendTo(String callName) {
    return 'Send to $callName';
  }

  @override
  String usRequestTo(String callName) {
    return 'Ask $callName';
  }

  @override
  String usRequestGentle(String callName) {
    return 'A request is an invitation to help. $callName can always say “Not today”.';
  }

  @override
  String get usRequestOneThing => 'ASK FOR HELP';

  @override
  String get usRequestRest => 'Need a break';

  @override
  String get usRequestWatchChild => 'Watch the child';

  @override
  String get usRequestRestHint => 'Help watch the child';

  @override
  String get usRequestWatchHint => 'For a while';

  @override
  String get usRequestLibrary => 'Library';

  @override
  String get usRequestLibraryHint => 'Choose a task';

  @override
  String get usRequestCustom => 'Write your own';

  @override
  String get usRequestCustomHint => 'Something else';

  @override
  String get usRequestDuration => 'How long?';

  @override
  String get usRequestWhen => 'When?';

  @override
  String get usRequestWhichChild => 'Which child?';

  @override
  String usRequestMinutes(int minutes) {
    return '$minutes minutes';
  }

  @override
  String get usRequestNow => 'Now';

  @override
  String get usRequestTonight => 'Tonight';

  @override
  String get usRequestChooseTime => 'Choose time';

  @override
  String get usRequestOtherChild => 'Both children';

  @override
  String get usRequestNeeds => 'OR I NEED…  (no Hearts)';

  @override
  String usRequestSendCount(String callName, int count) {
    return 'Send to $callName · $count/5 open';
  }

  @override
  String usRequestFrom(String callName) {
    return 'A request from $callName';
  }

  @override
  String usRequestBy(String callName) {
    return '$callName asks you';
  }

  @override
  String get usRequestSoon => 'Soon, please';

  @override
  String get usRequestAcceptedTitle => 'You accepted the request';

  @override
  String get usRequestReasonHint =>
      'If you cannot today, choose a reason (optional)';

  @override
  String get usRequestReasonMeeting => 'I’m in a meeting';

  @override
  String get usRequestReasonLate => 'Home late';

  @override
  String get usRequestAccept => 'Accept — I’ll take care of it';

  @override
  String get usRequestDecline => 'Not today';

  @override
  String usRequestDeclineNote(String callName) {
    return 'No points are deducted for declining. $callName receives a gentle notification.';
  }

  @override
  String usRequestSent(String callName) {
    return '$callName sent';
  }

  @override
  String get usRequestViewed => 'You viewed';

  @override
  String get usRequestAcceptedShort => 'You accepted';

  @override
  String get usRequestFinished => 'Done';

  @override
  String get usRequestFinish => 'Done ✓';

  @override
  String get commonCreateNew => 'Create new';

  @override
  String get switcherViewBy => 'View by';

  @override
  String switcherPregnancy(int number, String name) {
    return 'Pregnancy #$number · $name';
  }

  @override
  String get switcherAllDescription => 'All children and shared moments';

  @override
  String get familyManageChildren => 'Manage children';

  @override
  String careWeekday(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      'mon': 'Mon',
      'tue': 'Tue',
      'wed': 'Wed',
      'thu': 'Thu',
      'fri': 'Fri',
      'sat': 'Sat',
      'other': 'Sun',
    });
    return '$_temp0';
  }

  @override
  String get notificationsFamily => 'Family';

  @override
  String get memoriesSaveQuote => 'Save quote';

  @override
  String get pregnancyFirstPhoto => 'Baby’s first photo';

  @override
  String get pregnancyFirstPhotoHint => 'Optional · saved as a birth memory';

  @override
  String get pregnancyCompleteAnnounce => 'Finish & announce';

  @override
  String pregnancyWelcomeName(String name) {
    return 'Welcome, $name!';
  }

  @override
  String get pregnancyShort => 'Pregnancy';

  @override
  String get memoriesPerspectiveshort => 'Perspective';

  @override
  String get pregnancyBumpWeeks => 'Weekly bump photos';

  @override
  String pregnancyFirstsFor(String child) {
    return '$child’s firsts';
  }

  @override
  String get pregnancyBabyLetter => 'Letter to baby';

  @override
  String get pregnancyBumpPhoto => 'Bump photo';

  @override
  String usRequestHearts(int count) {
    return 'Completing this earns +$count 💗 (only you see)';
  }

  @override
  String usRequestReminder(String time) {
    return 'Remind me at $time';
  }

  @override
  String get usRequestAcceptedBadge => 'Accepted';

  @override
  String get pregnancyPrepareBaby => 'Prepare for our baby';

  @override
  String get commonAll => 'All';

  @override
  String pregnancyCaptureWeek(int week) {
    return 'Take a bump photo for week $week';
  }

  @override
  String get memoriesMarkMilestone => 'Mark a milestone';

  @override
  String get careMine => 'Me';

  @override
  String get careTogether => 'Together';

  @override
  String get careTodayShort => 'Today';

  @override
  String get carePrivateContribution => 'Only you can see';

  @override
  String usRequestRestTitle(int minutes, String child) {
    return 'Rest for $minutes minutes — please watch $child';
  }

  @override
  String usRequestWatchTitle(int minutes, String child) {
    return 'Watch $child for $minutes minutes';
  }

  @override
  String usRequestAllChildren(int count) {
    return 'All $count children';
  }

  @override
  String usRequestMessagePreview(int minutes, String child) {
    return '“I need about $minutes minutes of rest. Could you watch $child for me? 💛”';
  }

  @override
  String get quickCheckin => 'Check-in';

  @override
  String get quickThanks => 'Thanks';

  @override
  String get careFinish => 'Done';

  @override
  String carePartnerTab(String callName) {
    return '$callName’s';
  }

  @override
  String get billingSupport => 'Support';

  @override
  String get homeChildLetter => 'Letter to baby';

  @override
  String commonAgeDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String commonAgeMonths(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months months',
      one: '1 month',
    );
    return '$_temp0';
  }

  @override
  String commonAgeMonthsDays(int months, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months months',
      one: '1 month',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return '$_temp0 $_temp1';
  }

  @override
  String commonAgeYears(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years years',
      one: '1 year',
    );
    return '$_temp0';
  }

  @override
  String commonAgeYearsMonths(int years, int months) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years years',
      one: '1 year',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months months',
      one: '1 month',
    );
    return '$_temp0 $_temp1';
  }

  @override
  String commonPregnancyWeekOnly(int week) {
    return 'Week $week';
  }

  @override
  String commonPregnancyWeekDay(int week, int day) {
    String _temp0 = intl.Intl.pluralLogic(
      day,
      locale: localeName,
      other: '$day days',
      one: '1 day',
    );
    return 'Week $week + $_temp0';
  }

  @override
  String get commonScreenInProgress =>
      'This screen is being rebuilt from the design.';

  @override
  String get stateOfflineTitle => 'You\'re offline';

  @override
  String stateOfflineSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Showing saved data · $count memories waiting to upload',
      one: 'Showing saved data · 1 memory waiting to upload',
      zero: 'Showing saved data',
    );
    return '$_temp0';
  }

  @override
  String get commonPlay => 'Play';

  @override
  String get commonPause => 'Pause';

  @override
  String get commonMarkDone => 'Mark as done';

  @override
  String get commonNotifications => 'Notifications';

  @override
  String get commonComingSoon => 'Coming soon';

  @override
  String commonQuoted(String text) {
    return '“$text”';
  }

  @override
  String get commonTimeJustNow => 'Just now';

  @override
  String commonTimeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String commonTimeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String get commonTimeYesterday => 'yesterday';

  @override
  String commonTimeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String usMoodLabel(String mood) {
    String _temp0 = intl.Intl.selectLogic(mood, {
      'ok': 'Okay',
      'normal': 'So-so',
      'tired': 'Tired',
      'exhausted': 'Exhausted',
      'stressed': 'Stressed',
      'sad': 'Sad',
      'annoyed': 'Annoyed',
      'overwhelmed': 'Overwhelmed',
      'lonely': 'Lonely',
      'missYou': 'Miss you',
      'other': 'Okay',
    });
    return '$_temp0';
  }

  @override
  String usCheckinNeed(String need) {
    String _temp0 = intl.Intl.selectLogic(need, {
      'rest': 'Needs rest',
      'childcare': 'Needs help with the kids',
      'quiet': 'Needs quiet',
      'hug': 'Needs a hug',
      'talk': 'Wants to talk',
      'encouragement': 'Needs encouragement',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String usCheckinNeedMinutes(String need, int minutes) {
    return '$need $minutes\'';
  }

  @override
  String get usMoodNotShared => 'Not shared yet';

  @override
  String usReplySent(String callName) {
    return 'Sent to $callName 💛';
  }

  @override
  String get usSettingsTooltip => 'Papa & Mama settings';

  @override
  String usOpenRequestWatch(String callName, String child, int minutes) {
    return 'You asked $callName to watch $child for $minutes min';
  }

  @override
  String usOpenRequestMine(String callName, String title) {
    return 'You asked $callName: $title';
  }

  @override
  String usOpenRequestTheirs(String callName, String title) {
    return '$callName asked you: $title';
  }

  @override
  String usRequestStatusPartner(String status, String callName, String time) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'seen': '$callName saw it · $time',
      'accepted': '$callName accepted · $time',
      'done': '$callName finished · $time',
      'declined': '$callName: not today',
      'other': 'Sent · $time',
    });
    return '$_temp0';
  }

  @override
  String usRequestStatusMine(String status, String time) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'accepted': 'You accepted · $time',
      'other': 'Waiting for you · $time',
    });
    return '$_temp0';
  }

  @override
  String get usDailyQuestionHintBoth =>
      'You\'ll see each other\'s answers once you both reply.';

  @override
  String get usDailyQuestionYourAnswer => 'Your answer';

  @override
  String usDailyQuestionAnswerBy(String callName, String answer) {
    return '$callName: $answer';
  }

  @override
  String usThanksByLine(String callName, String time) {
    return '$callName · $time';
  }

  @override
  String get usYou => 'You';

  @override
  String usRequestRestMessage(int minutes, String child) {
    return 'I need about $minutes minutes of rest. Could you watch $child for me? 💛';
  }

  @override
  String usRequestWatchMessage(int minutes, String child) {
    return 'Could you watch $child for about $minutes minutes? 💛';
  }

  @override
  String usRequestReasonBusyWith(String child) {
    return 'Watching $child';
  }

  @override
  String usRequestYouAsked(String callName) {
    return 'You asked $callName';
  }

  @override
  String get usRequestMineTitle => 'Your request';

  @override
  String get usRequestYouSent => 'You sent it';

  @override
  String usRequestPartnerViewed(String callName) {
    return '$callName saw it';
  }

  @override
  String usRequestPartnerAccepted(String callName) {
    return '$callName accepted';
  }

  @override
  String usRequestBadge(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'sent': 'Sent',
      'seen': 'Seen',
      'accepted': 'Accepted',
      'done': 'Done',
      'declined': 'Not today',
      'acknowledged': 'Seen',
      'expired': 'Expired',
      'cancelled': 'Cancelled',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get usRequestCancel => 'Cancel request';

  @override
  String get usRequestThank => 'Say thank you';

  @override
  String get usRequestDoMyself => 'I\'ll do it myself';

  @override
  String get usRequestSendHug => 'Send 🤗';

  @override
  String usThanksTitle(String callName) {
    return 'Thank $callName';
  }

  @override
  String get usThanksSamples => 'SUGGESTIONS';

  @override
  String get usThanksSample1 => 'Thanks for watching the kids for me 💛';

  @override
  String get usThanksSample2 => 'Thanks for being there for me today';

  @override
  String get usThanksSample3 => 'Everything feels lighter with you';

  @override
  String get usThanksSticker => 'STICKER';

  @override
  String get usThanksPostFamily => 'Suggest sharing as a family moment';

  @override
  String usThanksPostFamilyHint(String callName) {
    return 'Needs $callName\'s OK';
  }

  @override
  String usThanksSent(String callName) {
    return 'Thank-you sent to $callName 💛';
  }

  @override
  String get careTreeBloomed =>
      'Today our family cared for the kids so fully 🌸';

  @override
  String careOpenRequestFromPartner(int count, String callName, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count open requests',
      one: '1 open request',
    );
    return '$_temp0 · $callName asks: $title';
  }

  @override
  String careOpenRequestToPartner(int count, String callName, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count open requests',
      one: '1 open request',
    );
    return '$_temp0 · You asked $callName: $title';
  }

  @override
  String get careMetaSuggested => 'Today\'s suggestion';

  @override
  String get careMetaCustom => 'Added by you';

  @override
  String careMetaHearts(int count) {
    return '+$count 💗';
  }

  @override
  String careMetaDoneAt(String time) {
    return 'Done $time';
  }

  @override
  String carePartnerDoneAt(String time) {
    return 'Done at $time';
  }

  @override
  String careCategory(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'care': 'Care',
      'bonding': 'Bonding',
      'outing': 'Outdoors',
      'memory': 'Keepsake',
      'support': 'Support partner',
      'self': 'Self-care',
      'together': 'Family',
      'couple': 'Us two',
      'other': 'Custom',
    });
    return '$_temp0';
  }

  @override
  String careDurationMin(int minutes) {
    return '$minutes min';
  }

  @override
  String carePartnerNote(String callName) {
    return 'You can only see what $callName has done. $callName\'s Hearts are visible only to $callName.';
  }

  @override
  String carePartnerAllDone(String callName, int count) {
    return '$callName finished all $count tasks today';
  }

  @override
  String get careThank => 'Thank';

  @override
  String get careThanked => 'Thanked';

  @override
  String get careDoneTogether => 'Done together';

  @override
  String get careMineEmpty => 'You have no tasks today';

  @override
  String carePartnerEmpty(String callName) {
    return '$callName has no tasks today';
  }

  @override
  String get careTogetherEmpty => 'No together tasks today';

  @override
  String careDoneSnack(String title) {
    return 'Done: “$title”';
  }

  @override
  String careSuggestFor(String name, String age) {
    return 'Ideas for $name · $age';
  }

  @override
  String get careSuggestToday => 'Ideas for today';

  @override
  String careCompleteDesc(String title, int photoHearts) {
    return '$title · today\'s tree gets a new leaf 🍃 (+$photoHearts 💗 if you save a photo)';
  }

  @override
  String get careNoteHint => 'Note (optional)…';

  @override
  String get careLibraryLink => 'Library';

  @override
  String get careLibraryTitle => 'Task library';

  @override
  String get careTitleHint => 'What to do?';

  @override
  String get careTomorrow => 'Tomorrow';

  @override
  String careRepeatOption(String repeat) {
    String _temp0 = intl.Intl.selectLogic(repeat, {
      'daily': 'Every day',
      'weekdays': 'Weekdays',
      'weekends': 'Weekends',
      'other': 'No repeat',
    });
    return '$_temp0';
  }

  @override
  String careReminderOption(String reminder) {
    String _temp0 = intl.Intl.selectLogic(reminder, {
      'atTime': 'Remind on time',
      'before15': 'Remind 15 min before',
      'before30': 'Remind 30 min before',
      'before60': 'Remind 60 min before',
      'other': 'No reminder',
    });
    return '$_temp0';
  }

  @override
  String get careTimeAny => 'Any time';

  @override
  String careTreeNextLevel(String name) {
    return 'Almost $name 🌸';
  }

  @override
  String careTreeRewardLabel(String reward) {
    return 'Reward: $reward';
  }

  @override
  String careTreePercent(int percent) {
    return '$percent%';
  }

  @override
  String get careTreeContributionTitle =>
      'Your contribution 🔒 Only you see this';

  @override
  String careHeartsValue(int count) {
    return '$count 💗';
  }

  @override
  String careHeartsPlus(int count) {
    return '+$count';
  }

  @override
  String careHistoryWhen(String day, String time) {
    return '$day · $time';
  }

  @override
  String careHistoryTogether(String day) {
    return 'Together · $day';
  }

  @override
  String get careYesterday => 'Yesterday';

  @override
  String careWeekdayLong(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      'mon': 'Monday',
      'tue': 'Tuesday',
      'wed': 'Wednesday',
      'thu': 'Thursday',
      'fri': 'Friday',
      'sat': 'Saturday',
      'other': 'Sunday',
    });
    return '$_temp0';
  }

  @override
  String get careDetailTitle => 'Task details';

  @override
  String get careComplete => 'Complete';

  @override
  String get careOwnerLabel => 'Done by';

  @override
  String get careChildLabel => 'For';

  @override
  String get careTimeLabel => 'Time';

  @override
  String get careMissionNotFound => 'This task could not be found';

  @override
  String get careSwapAction => 'Swap for another';

  @override
  String get commonJustNow => 'Just now';

  @override
  String commonMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String commonHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String commonDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String famTrialSubtitle(int days, String date) {
    return '$days days left · ends $date';
  }

  @override
  String famStorageUsage(String used, String total) {
    return '$used GB / $total GB';
  }

  @override
  String get famPlanHouse => 'House plan';

  @override
  String get famPlanFamily => 'Family plan';

  @override
  String famPlanRenews(String date) {
    return 'Renews $date';
  }

  @override
  String get famRoleFather => 'Dad';

  @override
  String get famRoleMother => 'Mom';

  @override
  String famPregnancySubtitle(int week, String date) {
    return '$week weeks pregnant · due $date';
  }

  @override
  String get famRelativePending => 'Invite pending';

  @override
  String get famRelationOther => 'Other…';

  @override
  String famInviteSlots(int used, int max) {
    return 'Family plan · $used/$max relative spots used';
  }

  @override
  String famPregnancyChild(String name) {
    return '$name (pregnancy)';
  }

  @override
  String get famPhotosPermissionHint => '“Whole family” visibility';

  @override
  String get famCommentPermissionHint => 'Send wishes to the little ones';

  @override
  String get famPostPermissionHint => 'Papa/Mama approve before it shows';

  @override
  String get famInviteNote =>
      'Relatives can\'t see the Papa & Mama space or private content.';

  @override
  String famInviteShared(String callName, String link) {
    return 'Invite created for $callName: $link';
  }

  @override
  String subTrialLeft(int days) {
    return '$days trial days left';
  }

  @override
  String subBuy(String plan, String price) {
    return 'Upgrade to $plan · $price';
  }

  @override
  String get subCurrentPlan => 'Current plan';

  @override
  String subPurchased(String plan) {
    return 'Your family is now on $plan 🎉';
  }

  @override
  String get subRestoreNone => 'No purchases to restore yet.';

  @override
  String subExpiredStats(int memories, int firsts, String names) {
    return 'Your family has saved $memories memories and $firsts firsts of $names. Everything is safe — upgrade so the whole family can keep recording the children\'s journey.';
  }

  @override
  String subRetentionTitle(String date) {
    return 'Your data is kept until $date';
  }

  @override
  String get subExportStarted =>
      'Preparing your data — we\'ll let you know when it\'s ready to download.';

  @override
  String setProfileSubtitle(String callName, String family) {
    return '$callName · $family';
  }

  @override
  String setAiQuota(int remaining, int total) {
    return '$remaining/$total uses';
  }

  @override
  String get setPlanTrial => 'Trial';

  @override
  String get setPlanExpired => 'Expired';

  @override
  String setVersion(String version) {
    return 'v$version';
  }

  @override
  String setTextPreview(String name) {
    return '$name just reached a new milestone: sitting up alone 🎉';
  }

  @override
  String cirHello(String callName) {
    return 'Hello $callName';
  }

  @override
  String cirTitle(String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': 'Grandma\'s little ones',
      'grandpa': 'Grandpa\'s little ones',
      'other': 'The family\'s little ones',
    });
    return '$_temp0';
  }

  @override
  String cirHeroCaption(String text, String author, String time) {
    return '“$text” — $author, $time';
  }

  @override
  String cirLiked(String name) {
    return 'You sent a heart to $name 💛';
  }

  @override
  String cirWishHint(String name) {
    return 'Write a wish for $name…';
  }

  @override
  String get cirWishSend => 'Send';

  @override
  String cirWishSent(String name) {
    return 'Your wish was sent to $name';
  }

  @override
  String cirEmpty(String callName) {
    return 'Papa & Mama haven\'t posted new photos yet. $callName will be notified when they do.';
  }

  @override
  String pregJourneyTitle(String child) {
    return '$child\'s journey';
  }

  @override
  String pregJourneyStats(int days, int memories, int firsts) {
    return '$days days to go · $memories memories · $firsts firsts';
  }

  @override
  String get pregWeekThis => 'this week';

  @override
  String get pregWeekFirsts => 'Firsts';

  @override
  String pregBumpGhostHint(int week) {
    return 'Week $week ghost overlay keeps the same angle';
  }

  @override
  String pregWeekDayShort(int week, int day) {
    return 'Week $week + $day';
  }

  @override
  String pregPostedBy(String callName) {
    return 'Posted by $callName';
  }

  @override
  String pregUltrasoundWeek(int week) {
    return 'ULTRASOUND · WEEK $week';
  }

  @override
  String pregQuoted(String text) {
    return '“$text”';
  }

  @override
  String get pregFirstLabel => 'FIRST';

  @override
  String get pregMilestoneLater => 'Becomes a milestone once baby arrives';

  @override
  String get pregMenuEdit => 'Edit pregnancy';

  @override
  String get pregMenuArchive => 'Archive';

  @override
  String pregBumpCompare(int from, int to) {
    return 'Compare · Week $from → Week $to';
  }

  @override
  String pregWeekShort(int week) {
    return 'W$week';
  }

  @override
  String pregWeekCapture(int week) {
    return 'W$week · shoot';
  }

  @override
  String get pregUltrasoundAdd => 'Add ultrasound';

  @override
  String get pregUltrasoundEmpty => 'No ultrasounds yet';

  @override
  String get pregUltrasoundEmptyHint => 'Keep ultrasounds by week with a note.';

  @override
  String pregDaysLeft(int days) {
    return '$days days to go';
  }

  @override
  String get pregGroupBag => 'Hospital bag';

  @override
  String get pregGroupPapers => 'Paperwork';

  @override
  String get pregGroupNursery => 'Baby\'s corner';

  @override
  String get pregGroupHealth => 'Health';

  @override
  String pregOwnerRequested(String callName) {
    return 'Asked $callName';
  }

  @override
  String pregOwnerAsk(String callName) {
    return 'Ask $callName';
  }

  @override
  String get pregOwnerTitle => 'Who takes care of this?';

  @override
  String get pregBirthCountTitle => 'Congratulations! How many babies?';

  @override
  String pregBirthBabyCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count babies',
      one: '1 baby',
    );
    return '$_temp0';
  }

  @override
  String get pregBirthWelcomeTitle => 'Welcome to our family, little one 🎉';

  @override
  String pregBirthBabyIndex(int index, int count) {
    return 'Baby $index/$count · you can edit this anytime';
  }

  @override
  String pregBirthNameValue(String name, String nickname) {
    return '$name ($nickname)';
  }

  @override
  String get pregBirthWeightLabel => 'Weight (saved only)';

  @override
  String pregKg(String value) {
    return '$value kg';
  }

  @override
  String pregCm(String value) {
    return '$value cm';
  }

  @override
  String pregBirthFamilyWelcomes(String family) {
    return '$family welcomes';
  }

  @override
  String pregBirthWelcomeName(String name) {
    return 'Welcome, $name! 💜';
  }

  @override
  String pregBirthNickname(String nickname) {
    return 'Everyone\'s “$nickname”';
  }

  @override
  String pregBirthNicknameSiblings(String nickname, String siblings) {
    return 'Everyone\'s “$nickname” · little sibling of $siblings';
  }

  @override
  String pregNamesAnd(String first, String last) {
    return '$first & $last';
  }

  @override
  String pregBirthAnnounceNote(String child) {
    return 'Only relatives sharing the pregnancy. Pregnancy memories become $child\'s first chapter.';
  }

  @override
  String get pregBirthDone => 'Finish & share the news 🎉';

  @override
  String pregArchiveTitle(String child) {
    return 'Archive $child\'s journey';
  }

  @override
  String get pregNamesBothLike => 'Both love it 💞';

  @override
  String pregNamesAddedBy(String callName) {
    return 'Added by $callName';
  }

  @override
  String pregNamesLikeBy(String callName) {
    return '$callName likes it';
  }

  @override
  String get authNameHint => 'Enter your name';

  @override
  String authResendIn(String time) {
    return 'Resend code in $time';
  }

  @override
  String authCountryCodeSemantics(String code) {
    return 'Country code $code';
  }

  @override
  String get authChangeAvatar => 'Choose a profile photo';

  @override
  String onbFamilyDefaultName(String name) {
    return 'The $name family';
  }

  @override
  String onbMemberLabel(String callName, String name) {
    return '$callName $name';
  }

  @override
  String onbFamilyCoverWaiting(String member, String partnerCallName) {
    return '$member · waiting for $partnerCallName';
  }

  @override
  String get onbFamilySuggestion1 => 'Tomato House';

  @override
  String get onbFamilySuggestion2 => 'Little Nest';

  @override
  String get onbFamilySuggestion3 => 'Our Home';

  @override
  String get onbChangeCover => 'Change cover';

  @override
  String onbInviteSubtitle(String callName) {
    return 'Baby Family needs both Papa and Mama. When $callName joins, your family starts a 3-month free trial.';
  }

  @override
  String onbInviteApproval(String callName) {
    return 'I\'ll give final approval when $callName joins';
  }

  @override
  String onbInviteShareMessage(String code, String link) {
    return 'Join me on Baby Family to keep our child\'s journey! Invite code: $code · $link';
  }

  @override
  String onbWaitingSubtitle(String callName) {
    return 'When $callName accepts, your family is unlocked and the 3-month free trial begins.';
  }

  @override
  String onbWaitingSentAt(String time) {
    return 'Invite sent at $time';
  }

  @override
  String onbWaitingOpened(String callName) {
    return '$callName opened the invite link';
  }

  @override
  String onbWaitingExpires(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Expires in $count days',
      one: 'Expires in 1 day',
      zero: 'Expires today',
    );
    return '$_temp0';
  }

  @override
  String get onbCancelFamilyMessage =>
      'You\'ll go back to choosing your role. The invite you sent will no longer work.';

  @override
  String onbTrialUntil(String date) {
    return 'Until $date · no card needed';
  }

  @override
  String onbTrialAfter(String housePrice, String familyPrice) {
    return 'After that, choose House ($housePrice) or Family ($familyPrice) to continue.';
  }

  @override
  String onbStageSubtitle(String first, String second) {
    return '$first and $second can add another child or pregnancy anytime.';
  }

  @override
  String get onbStageBothDescription =>
      'Children\'s profiles and pregnancies side by side in one family';

  @override
  String get onbNicknameIdea1 => 'Bean';

  @override
  String get onbNicknameIdea2 => 'Tomato';

  @override
  String get onbNicknameIdea3 => 'Jackfruit';

  @override
  String get onbNicknameIdea4 => 'Squirrel';

  @override
  String onbMeetCountdown(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days until you meet $name',
      one: '1 day until you meet $name',
      zero: 'Meeting $name today',
    );
    return '$_temp0';
  }

  @override
  String get onbKnowDueDate => 'I know the due date';

  @override
  String onbWeekValue(int week) {
    return 'Week $week';
  }

  @override
  String onbNotifMeta(String time) {
    return 'Baby Family · $time';
  }

  @override
  String get onbNotifNow => 'now';

  @override
  String get onbNotif5Minutes => '5 min ago';

  @override
  String get onbNotif1Hour => '1 hour ago';

  @override
  String onbNotifRequestTitle(String sender, String receiver, String child) {
    return '$sender asked $receiver: Bath $child tonight';
  }

  @override
  String get onbNotifRequestBody =>
      'Accept or suggest another time in one tap.';

  @override
  String onbNotifPhotosTitle(String child) {
    return '3 new photos of $child today';
  }

  @override
  String get onbNotifPhotosBody => 'Grandma loved 2 photos.';

  @override
  String get onbNotifUsTitle => 'You have a new update from Papa & Mama';

  @override
  String get onbNotifUsBody => 'Private content is hidden on the lock screen.';

  @override
  String get onbNotifChildFallback => 'baby';

  @override
  String onbFirstMemorySubtitle(String name) {
    return 'Save $name\'s first moment in Baby Family.';
  }

  @override
  String invInviterParent(String name, String callName) {
    return '$name ($callName) invited you to join';
  }

  @override
  String invInviterRelative(String name, String callName, String pronoun) {
    return '$name ($callName) invited $pronoun to follow the grandchildren';
  }

  @override
  String invQuotedMessage(String message) {
    return '“$message”';
  }

  @override
  String invRoleParent(String callName) {
    return 'Your role: the children\'s $callName';
  }

  @override
  String invRoleRelative(String callName, String permission) {
    return '$callName · $permission';
  }

  @override
  String invPronoun(String relation) {
    String _temp0 = intl.Intl.selectLogic(relation, {
      'grandmaPaternal': 'Grandma',
      'grandmaMaternal': 'Grandma',
      'grandpaPaternal': 'Grandpa',
      'grandpaMaternal': 'Grandpa',
      'other': 'you',
    });
    return '$_temp0';
  }

  @override
  String invPronounTitle(String relation) {
    String _temp0 = intl.Intl.selectLogic(relation, {
      'grandmaPaternal': 'Grandma',
      'grandmaMaternal': 'Grandma',
      'grandpaPaternal': 'Grandpa',
      'grandpaMaternal': 'Grandpa',
      'other': 'You',
    });
    return '$_temp0';
  }

  @override
  String get invParentSees => 'You\'ll see: memories, missions, Papa & Mama';

  @override
  String invParentManage(String callName) {
    return 'Manage the family and invite relatives with $callName';
  }

  @override
  String invParentApproval(String member) {
    return '$member will give final approval when you join';
  }

  @override
  String invRelativeSees(String pronoun, String names) {
    return '$pronoun will see: photos, videos and firsts of $names';
  }

  @override
  String invRelativeHiddenChildren(String pronoun, String names) {
    return '$pronoun won\'t see: $names, Papa & Mama, missions';
  }

  @override
  String invRelativeHidden(String pronoun) {
    return '$pronoun won\'t see: Papa & Mama, missions';
  }

  @override
  String invRelativeApproval(String pronoun) {
    return 'Photos $pronoun post are approved by Papa/Mama before they appear';
  }

  @override
  String get invViewOnly => 'View only';

  @override
  String get invNameSeparator => ', ';

  @override
  String get homeMorning => 'Good morning,';

  @override
  String get homeAfternoon => 'Good afternoon,';

  @override
  String homeGreetingName(String callName, String name, String emoji) {
    return '$callName $name $emoji';
  }

  @override
  String get homeMonthlyToday => 'TODAY';

  @override
  String homeMonthlyInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'IN $count DAYS',
      one: 'IN 1 DAY',
    );
    return '$_temp0';
  }

  @override
  String homeMonthlyTurns(String name, int months) {
    return '$name turns $months months 🎉';
  }

  @override
  String homeMonthlyPrepare(int done, int total) {
    return 'Get ready for the monthly photo — $done/$total taken';
  }

  @override
  String homeMoodTitle(String callName, String mood) {
    String _temp0 = intl.Intl.selectLogic(mood, {
      'ok': 'is doing okay',
      'normal': 'is feeling normal',
      'tired': 'is tired',
      'exhausted': 'is exhausted',
      'stressed': 'is stressed',
      'sad': 'is sad',
      'annoyed': 'is annoyed',
      'overwhelmed': 'is overwhelmed',
      'lonely': 'feels lonely',
      'missYou': 'misses you',
      'other': 'checked in',
    });
    return '$callName $_temp0';
  }

  @override
  String homeNeedLabel(String need) {
    String _temp0 = intl.Intl.selectLogic(need, {
      'rest': 'Needs a rest',
      'childcare': 'Needs help with the kids',
      'quiet': 'Needs some quiet',
      'hug': 'Needs a hug',
      'talk': 'Wants to talk',
      'encouragement': 'Needs encouragement',
      'other': 'Needs support',
    });
    return '$_temp0';
  }

  @override
  String homeNeedMinutes(String need, int minutes) {
    return '$need for about $minutes min';
  }

  @override
  String homeFamilyProgress(int done, int total) {
    return '$done/$total family tasks';
  }

  @override
  String homePromptKicker(String name, String age) {
    return 'Capture idea · $name $age';
  }

  @override
  String homeFeedAddedPhotos(String callName, int count, String name) {
    return '$callName just added $count photos of $name';
  }

  @override
  String homeMorePhotos(int count) {
    return '+$count';
  }

  @override
  String homeRecordedBy(String callName, String time) {
    return '$callName noted it $time';
  }

  @override
  String homeReactedBy(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$name and $count others',
      one: '$name and 1 other',
      zero: '$name',
    );
    return '$_temp0';
  }

  @override
  String homePostedBy(String callName) {
    return 'posted by $callName';
  }

  @override
  String homePerspectiveQuote(String callName, String text) {
    return '$callName: “$text”';
  }

  @override
  String homeTreeProgress(String name, int percent, String next) {
    return '$name · $percent% to $next 🌸';
  }

  @override
  String homeChildBorn(String age, String date) {
    return '$age · born $date';
  }

  @override
  String homeChildBornLunar(String age, String date, int day, int month) {
    return '$age · born $date (lunar $day/$month)';
  }

  @override
  String homeChildCountdown(int count, int months) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days until $months months',
      one: '1 day until $months months',
      zero: '$months months today',
    );
    return '$_temp0';
  }

  @override
  String homeMonthlySlot(int month) {
    return 'Month $month photo';
  }

  @override
  String homeChapterTitle(int month, String name) {
    return '$name\'s month $month';
  }

  @override
  String homeChapterStats(int memories, int firsts, int voices) {
    return '$memories memories · $firsts firsts · $voices voice clips';
  }

  @override
  String get homeMonthlyGrowth => 'Growing month by month';

  @override
  String homeTrimester(int number) {
    return 'Trimester $number';
  }

  @override
  String homeDaysToMeet(int count, String name) {
    return '$count days until we meet $name 💜';
  }

  @override
  String homeDueDate(String date) {
    return 'Due $date';
  }

  @override
  String homeFetalSize(String name, String fruit, int cm) {
    return 'This week $name is about the size of $fruit · around $cm cm';
  }

  @override
  String get homeReference => 'for reference';

  @override
  String get homeCapture => 'Snap';

  @override
  String homeWeekShort(int week) {
    return 'W$week';
  }

  @override
  String homeBothTellWeek(int week) {
    return 'Both tell · Week $week';
  }

  @override
  String homeProgressCount(int done, int total) {
    return '$done/$total';
  }

  @override
  String homeNamesSummary(int count, int liked) {
    return '$count name ideas · $liked you both like 💞';
  }

  @override
  String switcherPregnancyLabel(String name, int week) {
    return '$name · Week $week';
  }

  @override
  String get commonLastNight => 'last night';

  @override
  String get commonYesterdayLower => 'yesterday';

  @override
  String commonDotJoin(String first, String second) {
    return '$first · $second';
  }

  @override
  String commonNamesAnd(String first, String second) {
    return '$first & $second';
  }

  @override
  String commonMissionCategory(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'care': 'Care',
      'bonding': 'Bonding',
      'outing': 'Outing',
      'memory': 'Memories',
      'support': 'Support',
      'self': 'Self-care',
      'together': 'Together',
      'couple': 'Us two',
      'custom': 'Custom',
      'other': 'Task',
    });
    return '$_temp0';
  }

  @override
  String get commonSuggestedToday => 'Today\'s suggestion';

  @override
  String commonHeartsPlus(int count) {
    return '+$count 💗';
  }

  @override
  String get memJustNow => 'Just now';

  @override
  String memMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String memHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String get memYesterday => 'Yesterday';

  @override
  String get memTodayLower => 'today';

  @override
  String memTodayAt(String time) {
    return 'Today, $time';
  }

  @override
  String memYesterdayAt(String time) {
    return 'Yesterday, $time';
  }

  @override
  String memDateAt(String date, String time) {
    return '$date, $time';
  }

  @override
  String get memSearch => 'Search memories';

  @override
  String get memFilterVoice => 'Voice';

  @override
  String memChildStats(int memories, int firsts, int voices) {
    return '$memories memories · $firsts firsts · $voices voice clips';
  }

  @override
  String memChapterRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String memChapterCurrent(String range) {
    return '$range · IN PROGRESS';
  }

  @override
  String memChapterTitle(int month, String name) {
    return 'Month $month of $name';
  }

  @override
  String memChapterStats(int memories, int firsts, int voices) {
    return '$memories memories · $firsts firsts · $voices voice clips';
  }

  @override
  String memChapterStatsMonthly(int memories, int firsts) {
    return '$memories memories · $firsts firsts · monthly photo ✓';
  }

  @override
  String get memChapterReplay => 'Replay this month';

  @override
  String memDueIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'In $days days',
      one: 'Tomorrow',
      zero: 'Today',
    );
    return '$_temp0';
  }

  @override
  String memMonthlyNextIn(int days, int month) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Month $month · in $days days',
      one: 'Month $month · tomorrow',
      zero: 'Month $month · today',
    );
    return '$_temp0';
  }

  @override
  String memCardMeta(String children, String author, String time) {
    return '$children · posted by $author · $time';
  }

  @override
  String memBothTellPreview(String callName, String text) {
    return '$callName: “$text”';
  }

  @override
  String memQuotedBy(String body, String author) {
    return '“$body” · $author';
  }

  @override
  String get memFirstTime => 'First time';

  @override
  String memFirstMeta(String age, String who) {
    return '$age · $who';
  }

  @override
  String memBothParentsTell(String first, String second) {
    return '$first & $second told together';
  }

  @override
  String memAuthorTells(String callName) {
    return 'Told by $callName';
  }

  @override
  String memQuoteMeta(String name, String age, String callName, String when) {
    return '$name · $age · noted by $callName $when';
  }

  @override
  String memLetterSealed(String date) {
    return 'Sealed until $date';
  }

  @override
  String memCollMonthly(String name, int count, int total) {
    return '$name · $count/$total photos';
  }

  @override
  String memCollFirsts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count milestones',
      one: '1 milestone',
    );
    return '$_temp0';
  }

  @override
  String memCollQuotes(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count quotes',
      one: '1 quote',
    );
    return '$name · $_temp0';
  }

  @override
  String memCollVoices(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count voice clips',
      one: '1 voice clip',
    );
    return '$_temp0';
  }

  @override
  String memCollLetters(int count, int sealed) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count letters',
      one: '1 letter',
    );
    return '$_temp0 · $sealed sealed';
  }

  @override
  String memCollBest(int count) {
    return 'Both loved · $count';
  }

  @override
  String memCollKeepsakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get memComposerDiary => 'Write a diary';

  @override
  String get memComposerMilestone => 'Record a milestone';

  @override
  String get memComposerVoice => 'New voice clip';

  @override
  String get memComposerKeepsake => 'New keepsake';

  @override
  String memComposerMonthly(int month, String name) {
    return 'Month $month photo · $name';
  }

  @override
  String memAudienceRelatives(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count relatives',
      one: '1 relative',
    );
    return 'Family · $_temp0';
  }

  @override
  String memAudiencePeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '1 person',
    );
    return 'Family · $_temp0';
  }

  @override
  String get memChooseMilestone => 'Choose a milestone';

  @override
  String get memDiaryTitleHint => 'Diary title';

  @override
  String get memDiaryBodyHint => 'How was today for our family?';

  @override
  String get memLetterTo => 'To';

  @override
  String get memLetterBodyHint => 'Dear little one, we want to tell you…';

  @override
  String get memLetterOpenDate => 'Open on';

  @override
  String get memLetterOpenNone => 'None';

  @override
  String get memVoiceTapToRecord => 'Tap to record';

  @override
  String memVoiceRecorded(String duration) {
    return 'Recorded · $duration';
  }

  @override
  String get memKeepsakeTitleHint => 'Keepsake name';

  @override
  String get memKeepsakeHint => 'The story behind it…';

  @override
  String get memVisibilityFamilyTag => '👨‍👩‍👧‍👦 Family';

  @override
  String get memVisibilityParentsTag => '👫 Papa & Mama only';

  @override
  String get memVisibilityOnlyMeTag => '🔒 Only me';

  @override
  String memSecondPerspective(String time) {
    return 'Second perspective · $time';
  }

  @override
  String memCommentsCount(int count) {
    return 'Comments ($count)';
  }

  @override
  String get memMenuFavorite => 'Favorite';

  @override
  String get memMenuUnfavorite => 'Remove favorite';

  @override
  String get memEditPerspective => 'Edit your perspective';

  @override
  String get memMoreActions => 'More actions';

  @override
  String get memPregnancyAlbum => 'Pregnancy';

  @override
  String memMonthCell(int month) {
    return 'Month $month';
  }

  @override
  String memGhostToggle(int month, int percent) {
    return 'Month $month ghost · $percent%';
  }

  @override
  String get memStickerNone => 'None';

  @override
  String get memFlipCamera => 'Flip camera';

  @override
  String get memBrightness => 'Brightness';

  @override
  String memQuoteAge(String name, String age, String when) {
    return '— $name, $age · $when';
  }

  @override
  String get memQuoteContextLabel => 'When did they say it? (optional)';

  @override
  String get memQuoteContextHint => 'On an evening walk, looking at the sky';

  @override
  String memOriginalTag(String callName, String when) {
    return 'Told by $callName · $when';
  }

  @override
  String memInheritedAudience(String audience) {
    return 'Same viewers as the original: $audience';
  }

  @override
  String memStoryMeta(String callName, String time, int index, int total) {
    return 'Posted by $callName · $time · $index/$total';
  }

  @override
  String memStoryReply(String callName) {
    return 'Reply to $callName…';
  }

  @override
  String get memFirstsTitle => 'First moments';

  @override
  String get memFirstsHideMissing => 'Hide missing milestones';

  @override
  String get memFirstsAdd => 'Tap to record';

  @override
  String get homeOpenFamily => 'Our family';

  @override
  String get homeChangeCover => 'Change cover';

  @override
  String get authCodeResent => 'Code sent again';

  @override
  String commonLunarYear(String stem, String branch) {
    String _temp0 = intl.Intl.selectLogic(stem, {
      '0': 'Jia',
      '1': 'Yi',
      '2': 'Bing',
      '3': 'Ding',
      '4': 'Wu',
      '5': 'Ji',
      '6': 'Geng',
      '7': 'Xin',
      '8': 'Ren',
      '9': 'Gui',
      'other': '',
    });
    String _temp1 = intl.Intl.selectLogic(branch, {
      '0': 'Zi',
      '1': 'Chou',
      '2': 'Yin',
      '3': 'Mao',
      '4': 'Chen',
      '5': 'Si',
      '6': 'Wu',
      '7': 'Wei',
      '8': 'Shen',
      '9': 'You',
      '10': 'Xu',
      '11': 'Hai',
      'other': '',
    });
    return '$_temp0 $_temp1';
  }

  @override
  String commonLunarDate(int day, int month) {
    return 'Lunar $day/$month';
  }

  @override
  String commonAgeDaysOld(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days old',
      one: '1 day old',
    );
    return '$_temp0';
  }

  @override
  String commonAgeWeeks(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: '$weeks weeks',
      one: '1 week',
    );
    return '$_temp0';
  }

  @override
  String commonAgeWeeksDays(int weeks, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: '$weeks weeks',
      one: '1 week',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return '$_temp0 $_temp1';
  }

  @override
  String get memAlbumDetailTitle => 'Album details';

  @override
  String get memPhotoViewerTitle => 'Photo viewer';

  @override
  String get memSearchTitle => 'Search';

  @override
  String get memOnThisDayTitle => 'On this day';

  @override
  String get recapWeekTitle => 'Our family\'s week';

  @override
  String get calendarTitle => 'Calendar';

  @override
  String get calendarCreateEvent => 'New event';

  @override
  String get careHistoryTitle => 'History';

  @override
  String get careBadgesTitle => 'Our family badges';

  @override
  String get careSettingsTitle => 'Mission settings';

  @override
  String get childProfileTitle => 'Child profile';

  @override
  String get childEditTitle => 'Edit child profile';

  @override
  String get childAddTitle => 'Add a child';

  @override
  String get familyRelativeDetailTitle => 'Relative details';

  @override
  String get familySettingsTitle => 'Family settings';

  @override
  String get settingsProfileTitle => 'Profile';

  @override
  String memoriesYearOrdinal(String year) {
    String _temp0 = intl.Intl.selectLogic(year, {
      '1': 'First year',
      '2': 'Second year',
      '3': 'Third year',
      'other': 'Year $year',
    });
    return '$_temp0';
  }

  @override
  String careWeekdayTitle(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      'mon': 'Monday',
      'tue': 'Tuesday',
      'wed': 'Wednesday',
      'thu': 'Thursday',
      'fri': 'Friday',
      'sat': 'Saturday',
      'other': 'Sunday',
    });
    return '$_temp0';
  }

  @override
  String calendarDayTitle(String weekday, String date) {
    return '$weekday, $date';
  }

  @override
  String calendarMonthYear(String month, String year) {
    return '$month/$year';
  }

  @override
  String get calendarModeWeek => 'Week';

  @override
  String get calendarModeMonth => 'Month';

  @override
  String get calendarLegendMission => 'Tasks';

  @override
  String get calendarLegendEvent => 'Events';

  @override
  String get calendarLegendCouple => 'Us two';

  @override
  String get calendarLunar => 'Lunar';

  @override
  String calendarLunarShort(String day, String month) {
    return '$day/$month';
  }

  @override
  String get calendarToday => 'Today';

  @override
  String calendarItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get calendarAllDay => 'All day';

  @override
  String calendarKindLabel(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'family': 'Family event',
      'child': 'Child event',
      'couple': 'Date for us two',
      'anniversary': 'Anniversary',
      'health': 'Check-up/vaccine',
      'other': 'Task',
    });
    return '$_temp0';
  }

  @override
  String calendarOwnerLabel(String owner, String callName) {
    String _temp0 = intl.Intl.selectLogic(owner, {
      'me': 'mine',
      'together': 'together',
      'other': '$callName\'s',
    });
    return '$_temp0';
  }

  @override
  String get calendarCoupleOnly => 'Only you two see this';

  @override
  String get calendarEmptyDay =>
      'Nothing on this day yet. Add an event or a task?';

  @override
  String get calendarAddEvent => 'Event';

  @override
  String get calendarAddMission => 'Task';

  @override
  String get calendarAddMenu => 'Add to calendar';

  @override
  String get calendarPrevMonth => 'Previous month';

  @override
  String get calendarNextMonth => 'Next month';

  @override
  String get calendarEventType => 'Event type';

  @override
  String calendarEventKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'child': 'Child',
      'family': 'Family',
      'couple': 'Us two',
      'anniversary': 'Anniversary',
      'other': 'Check-up/vaccine',
    });
    return '$_temp0';
  }

  @override
  String get calendarEventTypeHint =>
      'Both parents always see it. Relatives only see it when you choose “Invite the family”.';

  @override
  String get calendarDate => 'Date';

  @override
  String get calendarUseLunar => 'Use lunar date';

  @override
  String calendarLunarDayName(String day, String month) {
    String _temp0 = intl.Intl.selectLogic(day, {
      '15': 'Full moon of lunar month $month',
      'other': 'Day $day of lunar month $month',
    });
    return '$_temp0';
  }

  @override
  String calendarThisYear(String date) {
    return 'This year: $date';
  }

  @override
  String get calendarRepeatYearly => 'Repeat every year';

  @override
  String get calendarRepeatByLunar => 'By lunar date';

  @override
  String get calendarRepeatBySolar => 'By calendar date';

  @override
  String get calendarTime => 'Time';

  @override
  String get calendarRelatedChildren => 'Related children (optional)';

  @override
  String get calendarParticipants => 'Participants';

  @override
  String get calendarInviteFamily => 'Invite the family';

  @override
  String get calendarFamilyPlanTag => 'Family plan';

  @override
  String get calendarInviteFamilyHint =>
      'Grandparents and relatives also see this event';

  @override
  String get calendarReminders => 'Reminders';

  @override
  String calendarReminder(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'dayBefore0900': '1 day before, 9:00',
      'morning': 'That morning',
      'atTime': 'At the time',
      'hourBefore': '1 hour before',
      'other': '1 week before',
    });
    return '$_temp0';
  }

  @override
  String get calendarAddReminder => 'Add';

  @override
  String get calendarNote => 'Note';

  @override
  String get calendarDraftNote =>
      'Order the salted-egg sponge cake Grandma loves';

  @override
  String get calendarNoteHint => 'Add a note…';

  @override
  String get calendarSaveEvent => 'Save event';

  @override
  String get calendarEventSaved => 'Event saved';

  @override
  String get careHistoryAll => 'All';

  @override
  String get careHistoryCategory => 'Type';

  @override
  String get careHistoryLegendMine => 'Mine';

  @override
  String careHistoryLegendPartner(String callName) {
    return '$callName\'s (done)';
  }

  @override
  String careHistoryToday(String date) {
    return 'Today · $date';
  }

  @override
  String careHistoryYesterday(String date) {
    return 'Yesterday · $date';
  }

  @override
  String careHistoryDate(String weekday, String date) {
    return '$weekday $date';
  }

  @override
  String careHistoryLunar(String day, String month) {
    return 'Lunar $day/$month';
  }

  @override
  String careHistoryPartnerDone(String callName) {
    return '$callName · done';
  }

  @override
  String careHistoryTogetherDone(String couple, String time) {
    String _temp0 = intl.Intl.selectLogic(couple, {
      'yes': 'Us two',
      'other': 'Together',
    });
    return '$_temp0 · done $time';
  }

  @override
  String get careHistoryMissed => 'Didn\'t get to it';

  @override
  String careHistoryNote(String callName) {
    return 'Hearts only show on your tasks. $callName\'s tasks only show once done.';
  }

  @override
  String get careHistoryEmpty => 'No tasks in your history yet';

  @override
  String careCategoryName(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'care': 'Care',
      'bonding': 'Bonding',
      'play': 'Play',
      'outing': 'Outings',
      'memory': 'Keep memories',
      'support': 'Support your partner',
      'self': 'Self-care',
      'chores': 'Baby chores',
      'other': 'Other',
    });
    return '$_temp0';
  }

  @override
  String get careBadgesSubtitle =>
      'Celebrating the good habits the whole family builds together — no comparing, no scoring anyone.';

  @override
  String careBadgesUnlocked(int done, int total) {
    return '$done / $total badges unlocked';
  }

  @override
  String careBadgesLatest(String title, String date) {
    return 'Latest: $title · $date';
  }

  @override
  String get careBadgesEarned => 'Earned';

  @override
  String get careBadgesUpcoming => 'Coming up';

  @override
  String careBadgeAchievedOn(String date) {
    return 'Earned $date';
  }

  @override
  String get careSettingsLevelSection => 'Daily task level for the family';

  @override
  String careSettingsLevel(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      'light': 'Light',
      'medium': 'Medium',
      'other': 'More',
    });
    return '$_temp0';
  }

  @override
  String get careSettingsPerPerson => 'tasks / person';

  @override
  String careSettingsTogether(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      'light': '0–1 shared task',
      'other': '1 shared task',
    });
    return '$_temp0';
  }

  @override
  String get careSettingsDefault => 'Default';

  @override
  String careSettingsLevelNote(String partner, String me) {
    return 'Applies to both $partner and $me — both boards stay equal. $partner gets a gentle notification when you change it.';
  }

  @override
  String get careSettingsCategoriesSection => 'Task types I want';

  @override
  String get careSettingsCategoriesHint =>
      'Turn some off and your board still gets the same number of tasks from the rest. Only applies to your board.';

  @override
  String get careSettingsTimingSection => 'Timing & reminders';

  @override
  String get careSettingsBoardTime => 'Daily board time';

  @override
  String careSettingsBoardTimeHint(int count) {
    return 'Notification “You have $count small tasks today…”';
  }

  @override
  String careSettingsAskAtNight(String time) {
    return 'Ask at $time';
  }

  @override
  String get careSettingsAskAtNightHint =>
      'Unfinished tasks you added — move to tomorrow?';

  @override
  String get careSettingsDefaultReminder => 'Default reminder';

  @override
  String get careSettingsDefaultReminderHint => 'For timed tasks you set';

  @override
  String careReminderShort(String reminder) {
    String _temp0 = intl.Intl.selectLogic(reminder, {
      'atTime': 'On time',
      'before15': '15′ before',
      'before30': '30′ before',
      'before60': '1 h before',
      'other': 'None',
    });
    return '$_temp0';
  }

  @override
  String famPlanPaidSubtitle(String price, String date) {
    return '$price · renews $date';
  }

  @override
  String get famManagePlan => 'Manage plan';

  @override
  String famInviteRelativeCount(int used, int max) {
    return 'Invite a relative ($used/$max)';
  }

  @override
  String famRelativeFollows(String relation, String children) {
    return '$relation · Follows $children';
  }

  @override
  String famRelativeFollowsNone(String relation) {
    return '$relation · Not following any child';
  }

  @override
  String famRelationMotherOf(String callName) {
    return '$callName\'s mother';
  }

  @override
  String famRelationFatherOf(String callName) {
    return '$callName\'s father';
  }

  @override
  String get famRelationNanny => 'Nanny';

  @override
  String get famPermSummaryView => 'View';

  @override
  String get famPermSummaryComment => 'View, comment';

  @override
  String get famPermSummaryDownload => 'can download photos';

  @override
  String get famPermSummaryContribute => 'contributes photos';

  @override
  String famRelativeSince(String relation, String date) {
    return 'Relation: $relation · Joined $date';
  }

  @override
  String famRelativeActive(String time) {
    return 'Active $time';
  }

  @override
  String get famDisplayName => 'Display name';

  @override
  String get famSignIn => 'Sign-in';

  @override
  String famSignInPhone(String phone) {
    return 'Phone $phone';
  }

  @override
  String get famPostedMemories => 'Posted memories';

  @override
  String famMemoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count memories',
      one: '1 memory',
    );
    return '$_temp0';
  }

  @override
  String get famPermByChild => 'Permissions per child';

  @override
  String get famPermHide => 'Hide';

  @override
  String get famPermLevelView => 'View';

  @override
  String get famPermLevelComment => 'Comment';

  @override
  String get famPermLevelContribute => 'Contribute';

  @override
  String famPregnancyWeekShort(int week) {
    return 'Pregnancy · Week $week';
  }

  @override
  String get famNotShared => 'Not shared';

  @override
  String get famPermHidden => 'Hidden for now';

  @override
  String get famShare => 'Share';

  @override
  String get famAllowDownload => 'Allow saving photos to device';

  @override
  String famAllowDownloadOff(String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': 'she',
      'grandpa': 'he',
      'other': 'they',
    });
    return 'Off — $_temp0 can view in the app, not save';
  }

  @override
  String famAllowDownloadOn(String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': 'she',
      'grandpa': 'he',
      'other': 'they',
    });
    return 'On — $_temp0 can save photos';
  }

  @override
  String famMuteFrom(String callName) {
    return 'Mute notifications from $callName';
  }

  @override
  String famMuteHint(String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': 'She',
      'grandpa': 'He',
      'other': 'They',
    });
    return '$_temp0 can still view and comment as usual';
  }

  @override
  String famRelativeNote(String callName) {
    return '$callName never sees Papa & Mama, missions, requests or Hearts.';
  }

  @override
  String get famPauseView => 'Pause viewing access';

  @override
  String get famResumeView => 'Resume viewing access';

  @override
  String get famReport => 'Report';

  @override
  String get famRemoveRelative => 'Remove from family';

  @override
  String famRemoveTitle(String callName) {
    return 'Remove $callName from the family?';
  }

  @override
  String famRemoveSummary(String callName, int count) {
    return '$callName has posted $count memories. $callName will no longer see the children.';
  }

  @override
  String get famRemoveKeepPosts => 'Keep their memories';

  @override
  String get famRemoveKeepPostsHint => 'They stay in the family\'s memories';

  @override
  String get famRemoveDeletePosts => 'Remove these memories too';

  @override
  String famRemoved(String callName) {
    return '$callName was removed from the family';
  }

  @override
  String get famSettingsChangeCover => 'Change cover';

  @override
  String get famSettingsName => 'Family name';

  @override
  String get famSettingsMemoriesSection => 'Memories & relatives';

  @override
  String get famSettingsDefaultVisibility => 'Who sees new memories';

  @override
  String get famSettingsDefaultVisibilityHint =>
      'Default for newly posted memories';

  @override
  String get famSettingsApprove => 'Review photos posted by relatives';

  @override
  String get famSettingsApproveHint =>
      'Grandparents\' photos show after Papa/Mama approve them';

  @override
  String get famSettingsTree => 'Relatives see the Family Tree';

  @override
  String get famSettingsMilestones => 'Milestone suggestions';

  @override
  String get famSettingsMilestonesHint =>
      'Reminders for the children\'s memorable firsts';

  @override
  String get famSettingsDatesSection => 'Dates & language';

  @override
  String get famSettingsTimezone => 'Family time zone';

  @override
  String get famSettingsLunar => 'Show lunar calendar';

  @override
  String get famSettingsMilestonesBy => 'Count full-month & first birthday by';

  @override
  String get famSettingsLunarCalendar => 'Lunar';

  @override
  String get famSettingsSolarCalendar => 'Solar';

  @override
  String get famSettingsContentLanguage => 'Suggested content language';

  @override
  String get famDeleteFamily => 'Delete family';

  @override
  String get famDeleteFamilyHint =>
      'Needs careful confirmation · 30 days to restore';

  @override
  String get setProfileChangeAvatar => 'Change photo';

  @override
  String get setProfileName => 'Your name';

  @override
  String get setProfileCallName => 'Family call name';

  @override
  String setProfileCallNameHint(String callName) {
    return 'The children and relatives will see you as “$callName”.';
  }

  @override
  String get setSignInSection => 'Sign-in methods';

  @override
  String get setSignInApple => 'Apple';

  @override
  String get setSignInGoogle => 'Google';

  @override
  String get setNotLinked => 'Not linked';

  @override
  String get setUnlink => 'Unlink';

  @override
  String get setLink => 'Link';

  @override
  String get setSignInHint =>
      'Always keep at least one sign-in method so you don\'t lose your account.';

  @override
  String get setTimezoneSection => 'Time zone';

  @override
  String get setAutoTimezone => 'Automatic from device';

  @override
  String get setAutoTimezoneHint =>
      'Mission and request reminders follow where you are';

  @override
  String get setPersonalTimezone => 'Personal time zone';

  @override
  String get setSaveChanges => 'Save changes';

  @override
  String get setChangesSaved => 'Changes saved';

  @override
  String get setNotifGroupsSection => 'Notification groups';

  @override
  String get setQuietSection => 'Quiet hours & lock screen';

  @override
  String get setQuietHours => 'Quiet hours';

  @override
  String get setQuietHoursHint => 'Notifications are bundled and sent later';

  @override
  String get setFrom => 'From';

  @override
  String get setTo => 'To';

  @override
  String setUrgentBypass(String callName) {
    return '$callName\'s requests bypass quiet hours';
  }

  @override
  String setUrgentBypassOff(String time) {
    return 'Off — “Soon please” requests also wait until $time';
  }

  @override
  String get setUrgentBypassOn =>
      'On — “Soon please” requests notify right away';

  @override
  String get setHideLockScreen => 'Hide content on the lock screen';

  @override
  String get setHideLockScreenHint =>
      'Shows: “You have a new update from Papa & Mama”';

  @override
  String get setRelativesSection => 'Relatives';

  @override
  String get setDigestTime => 'Digest time';

  @override
  String get setMutePeople => 'Mute by person';

  @override
  String setPeopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '1 person',
      zero: 'No one',
    );
    return '$_temp0';
  }

  @override
  String get setVisOnlyMeHint => 'Drafts, things to keep to yourself';

  @override
  String get setVisParents => 'Papa & Mama';

  @override
  String get setVisParentsHint => 'Only Papa and Mama';

  @override
  String get setVisFamilyHint =>
      'Papa, Mama and relatives the child in the memory is shared with';

  @override
  String get setVisibilityHint =>
      'There is no public sharing. You can change each memory\'s visibility at any time.';

  @override
  String get setDashboardSection => 'Permission dashboard';

  @override
  String get setWhoSees => 'Who sees which child';

  @override
  String setRelativeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count relatives',
      one: '1 relative',
    );
    return '$_temp0';
  }

  @override
  String get setStatDownload => 'Can save photos';

  @override
  String get setStatPost => 'Can post photos';

  @override
  String get setStatFamilyMemories => '“Everyone” memories';

  @override
  String get setStatMemoriesUnit => 'memories';

  @override
  String get setStatDevices => 'Signed-in devices';

  @override
  String get setStatDevicesUnit => 'devices';

  @override
  String get setStatAi => 'AI turned on';

  @override
  String get setStatAiUnit => 'features';

  @override
  String get setOpenPermissions => 'View details & edit permissions';

  @override
  String get setPrivacyNote =>
      'Papa & Mama, missions, requests and Hearts are always just for the two of you — relatives never see them.';

  @override
  String get setBlocked => 'Blocked people';

  @override
  String get setAppLockSection => 'App lock';

  @override
  String get setFaceIdLock => 'Lock with Face ID';

  @override
  String get setFaceIdLockHint => 'Opening Baby Family needs your Face ID';

  @override
  String get setBackupPin => 'Backup PIN';

  @override
  String get setPinSet => 'Set';

  @override
  String get setPinNotSet => 'Not set';

  @override
  String get setPinHint =>
      'If Face ID doesn\'t recognise you, open with your 6-digit PIN.';

  @override
  String get setDevicesSection => 'Signed-in devices';

  @override
  String setDeviceInUse(String location) {
    return '$location · In use';
  }

  @override
  String setDeviceLastActive(String location, String time) {
    return '$location · $time';
  }

  @override
  String get setThisDevice => 'This device';

  @override
  String get setSignOutAll => 'Sign out of all devices';

  @override
  String get setSignOutAllHint =>
      'You\'ll need to sign in again on every device, including this one. Memories and data stay intact.';

  @override
  String setDeviceSignedOut(String device) {
    return 'Signed out of $device';
  }

  @override
  String get setDataSubtitle =>
      'Your family\'s memories always belong to your family — download them anytime.';

  @override
  String get setExportSection => 'Export data';

  @override
  String get setExportPersonal => 'Personal data';

  @override
  String get setExportPersonalWho => 'Every member';

  @override
  String get setExportPersonalDesc =>
      'What you created: posted memories, private journal, moods, thank-yous sent and received.';

  @override
  String get setExportFamily => 'Family data';

  @override
  String get setExportFamilyDesc =>
      'ZIP file: original photos/videos, memories.csv and an offline viewer. Papa & Mama not included.';

  @override
  String get setExport => 'Export';

  @override
  String get setExporting => 'Exporting…';

  @override
  String get setExportStatusSection => 'Export status';

  @override
  String setExportPreparing(int percent) {
    return 'Preparing · $percent%';
  }

  @override
  String setExportStarted(String time) {
    return 'Started $time today · You\'ll get a notification when it\'s done.';
  }

  @override
  String setExportReadyTitle(String name, int size) {
    return '$name · $size MB';
  }

  @override
  String setExportExpires(String date) {
    return 'Download link expires $date';
  }

  @override
  String get setDownload => 'Download';

  @override
  String get setDownloadStarted => 'Download started';

  @override
  String get setOnDeviceSection => 'On this device';

  @override
  String get setCache => 'Cache';

  @override
  String setCacheSize(int size) {
    return '$size MB on this device';
  }

  @override
  String get setClearCache => 'Clear cache';

  @override
  String get setCacheHint =>
      'Clearing the cache only frees device storage. Memories stay safe in the cloud.';

  @override
  String setDelStep(int step) {
    return 'Step $step/4';
  }

  @override
  String get setDelStepFinal => 'Steps 3–4/4';

  @override
  String get setDelTitle1 => 'Before you delete your account';

  @override
  String setDelSubtitle1(String name) {
    return '$name, here\'s what will change. You can stop at any time.';
  }

  @override
  String get setDelWillDelete => 'Will be deleted';

  @override
  String get setDelItemPrivate => 'Your private journal, moods and drafts';

  @override
  String setDelItemCouple(String partner) {
    return 'Your Papa & Mama part — $partner keeps $partner\'s own';
  }

  @override
  String get setDelItemCoupleSolo => 'Your Papa & Mama part';

  @override
  String get setDelItemProfile => 'Profile and sign-in methods';

  @override
  String setDelPosted(int count) {
    return '$count memories you posted';
  }

  @override
  String get setDelKeepForFamily => 'Keep them for the family';

  @override
  String get setDelKeepHint => 'Shown as “Former member”';

  @override
  String get setDelDeleteMemories => 'Delete these memories';

  @override
  String get setDelSubscription => 'Subscription';

  @override
  String get setDelSubscriptionBody =>
      'Plans bought via the App Store or Google Play aren\'t cancelled when you delete your account. Cancel in the store to avoid renewal.';

  @override
  String get setDelHowToCancel => 'How to cancel in the store';

  @override
  String get setDelOthersNote =>
      'Other people\'s comments on your photos remain theirs — the app never deletes other people\'s content.';

  @override
  String get setDelKeepAccount => 'Keep my account';

  @override
  String setDelTitle2(String family) {
    return 'What happens to $family?';
  }

  @override
  String setDelSubtitle2(String partner) {
    return '$partner is still in the family, so the children and every memory stay with $partner.';
  }

  @override
  String setDelPartnerKeeps(String partner, String family) {
    return '$partner keeps $family';
  }

  @override
  String setDelPartnerItem1(String partner, String children) {
    return '$partner can still view and download every memory of $children';
  }

  @override
  String get setDelPartnerItem2 =>
      'The family switches to view & download only';

  @override
  String setDelPartnerItem3(String partner) {
    return '$partner can invite a new partner to the family';
  }

  @override
  String setDelCoupleData(String partner) {
    return 'Your moods, journal and shares in Papa & Mama will be deleted. $partner\'s part stays intact.';
  }

  @override
  String get setDelExportTip => 'Want to keep a copy for yourself?';

  @override
  String get setDelExportTipHint => 'Export your personal data before deleting';

  @override
  String get setDelOnlyBadge => 'When you\'re the only Papa/Mama';

  @override
  String get setDelOnlyTitle => 'Who will keep the children\'s memories?';

  @override
  String setDelOnlySubtitle(String family) {
    return 'You\'re the only manager of $family. Choose an option before continuing.';
  }

  @override
  String get setDelInviteParent => 'Invite someone as Parent first';

  @override
  String get setDelInviteParentHint =>
      'They keep the family, the children and every memory. Come back to delete your account after they join.';

  @override
  String get setDelDeleteFamily => 'Delete the whole family';

  @override
  String setDelDeleteFamilyHint(String children) {
    return '$children and every memory are deleted for good after 30 days. You can still restore them within those 30 days.';
  }

  @override
  String get setDelOnlyExportTip =>
      'Export the family data first to keep all original photos and videos.';

  @override
  String get setDelInviteNewParent => 'Invite a new Parent';

  @override
  String get setDelTitle3 => 'Final confirmation';

  @override
  String get setDelSubtitle3 =>
      'To protect your account, sign in again with a linked method.';

  @override
  String setDelVerified(String account) {
    return 'Verified · $account';
  }

  @override
  String setDelUseOtp(String phone) {
    return 'Use an OTP via phone $phone';
  }

  @override
  String get setDelWhatHappens => 'When you tap “Delete account”';

  @override
  String get setDelHappen1 => 'You\'re signed out of every device right away';

  @override
  String setDelHappen2(String date) {
    return 'The account waits 30 days before deletion — until $date';
  }

  @override
  String get setDelHappen3 => 'Sign in again before then to restore it';

  @override
  String get setDelHappen4 =>
      'After 30 days, the data is deleted for good and you get a confirmation email';

  @override
  String get setDelConfirmCheck => 'I understand and want to delete my account';

  @override
  String get setFaqSection => 'Frequently asked questions';

  @override
  String get setFaqAll => 'See all questions';

  @override
  String get setSupportSection => 'Need more help';

  @override
  String get setSendRequest => 'Send a support request';

  @override
  String get setSendRequestHint =>
      'Describe the issue, add a screenshot if you like';

  @override
  String get setMyReports => 'My reports';

  @override
  String setReportsOpen(int count) {
    return '$count in progress';
  }

  @override
  String get setContactSection => 'Contact';

  @override
  String get setEmailSupport => 'Support team email';

  @override
  String get setHotline => 'Support hotline';

  @override
  String setAppVersion(String version) {
    return 'Version $version';
  }

  @override
  String get setTerms => 'Terms of use';

  @override
  String get setPrivacyPolicy => 'Privacy policy';

  @override
  String get setLicenses => 'Open-source licences';

  @override
  String get setMadeWith => 'Made with love for Vietnamese families';

  @override
  String setCopyright(String year) {
    return '© $year Baby Family';
  }

  @override
  String commonAndList(String items, String last) {
    return '$items and $last';
  }

  @override
  String get memAlbumsAuto => 'Auto albums';

  @override
  String get memAlbumsAutoHint => 'Updates itself';

  @override
  String get memAlbumsFamily => 'Our family albums';

  @override
  String get memAlbumNew => 'New album';

  @override
  String get memAlbumNameHint => 'Album name';

  @override
  String get memAlbumCreate => 'Create album';

  @override
  String memAlbumMonthlyMeta(String name, int count) {
    return '$name · $count photos';
  }

  @override
  String memAlbumFirstsMeta(int count) {
    return '$count milestones';
  }

  @override
  String memAlbumVideosMeta(int count) {
    return '$count videos';
  }

  @override
  String memAlbumQuotesMeta(int count) {
    return '$count sayings';
  }

  @override
  String memAlbumVoicesMeta(int count) {
    return '$count recordings';
  }

  @override
  String memAlbumParentsMeta(int count) {
    return '$count memories · Papa & Mama';
  }

  @override
  String memAlbumDetailMeta(int count, String range) {
    return '$count memories · $range';
  }

  @override
  String memAlbumCreatedBy(String callName) {
    return 'By $callName';
  }

  @override
  String get memAlbumPermissionNote =>
      'Viewers only see the memories they are allowed to see in this album.';

  @override
  String get memAlbumRename => 'Rename';

  @override
  String get memAlbumChangeCover => 'Change cover';

  @override
  String get memAlbumDelete => 'Delete album';

  @override
  String get memAlbumDeleteNote => 'Memories in the album are kept';

  @override
  String memAlbumDeleteConfirm(String title) {
    return 'Delete the album “$title”?';
  }

  @override
  String memNamesPair(String first, String second) {
    return '$first & $second';
  }

  @override
  String memDotMeta3(String first, String second, String third) {
    return '$first · $second · $third';
  }

  @override
  String get memViewerSwipeHint => 'Swipe down to close';

  @override
  String get memViewerDownload => 'Download';

  @override
  String get memViewerShare => 'Share';

  @override
  String get memViewerInfo => 'Info';

  @override
  String get memViewerDownloaded => 'Saved to your device';

  @override
  String get memCommentReply => 'Reply';

  @override
  String memCommentReplying(String name) {
    return 'Replying to $name';
  }

  @override
  String get memCommentEditing => 'Editing comment';

  @override
  String get memCommentEdit => 'Edit';

  @override
  String get memCommentCopy => 'Copy';

  @override
  String get memCommentDelete => 'Delete';

  @override
  String memCommentMinutes(int count) {
    return '$count min';
  }

  @override
  String memCommentHours(int count) {
    return '$count h';
  }

  @override
  String get memCommentEmoji => 'Emoji';

  @override
  String get memMilestoneSearchHint =>
      'Search milestones, e.g. “roll”, “tooth”…';

  @override
  String memMilestoneRecordedCount(int done, int total) {
    return '$done / $total recorded';
  }

  @override
  String memMilestoneRecordedAt(String date) {
    return 'Recorded · $date';
  }

  @override
  String get memMilestoneCustom => '✏️ Our own milestone';

  @override
  String get memMilestoneCustomHint => 'Milestone name';

  @override
  String get memMilestoneNoResult => 'No matching milestone';

  @override
  String memDiarySavedDraft(String time) {
    return 'Draft saved · $time';
  }

  @override
  String get memDiarySaved => 'Diary saved';

  @override
  String get memFormatBold => 'Bold';

  @override
  String get memFormatItalic => 'Italic';

  @override
  String get memFormatList => 'Bulleted list';

  @override
  String get memFormatNumbered => 'Numbered list';

  @override
  String get memFormatImage => 'Insert photo';

  @override
  String get memFormatHeading => 'Heading';

  @override
  String get memFormatHideKeyboard => 'Hide keyboard';

  @override
  String get memLetterSaveDraft => 'Save draft';

  @override
  String get memLetterDraftSaved => 'Draft saved';

  @override
  String get memLetterRecipient => 'To';

  @override
  String get memLetterFormat => 'Format';

  @override
  String get memLetterWrite => 'Write';

  @override
  String get memLetterVideo => 'Record video';

  @override
  String get memLetterPickDate => 'Pick a date';

  @override
  String get memLetterBirthdayN => 'N-th birthday';

  @override
  String memLetterBirthdayAge(int age) {
    return '${age}th birthday';
  }

  @override
  String memLetterOpensOn(String name, String date) {
    return '$name opens it on $date';
  }

  @override
  String get memLetterReaders => 'Who can read it on the opening day';

  @override
  String memLetterReadersNote(String mode, String me, String partner) {
    String _temp0 = intl.Intl.selectLogic(mode, {
      'onlyMe':
          'When opened: only $me reads it with your child. $partner won’t see this letter.',
      'family':
          'When opened: the whole family reads it together. Until then, only $me can read and edit it.',
      'other':
          'When opened: $me and $partner read it with your child. Until then, only $me can read and edit it — $partner sees there is a letter but not its content.',
    });
    return '$_temp0';
  }

  @override
  String get memLetterEnvelopePreview => 'Envelope preview';

  @override
  String memLetterEnvelopeTo(String name) {
    return 'To $name';
  }

  @override
  String memLetterEnvelopeBirthday(String date, int age) {
    return 'Opens on $date · ${age}th birthday';
  }

  @override
  String memLetterEnvelopeDate(String date) {
    return 'Opens on $date';
  }

  @override
  String get memLetterEnvelopeAnytime => 'No opening date';

  @override
  String memLetterTimelineHint(String callName, String date) {
    return 'On the timeline: “💌 Letter from $callName — opens on $date”';
  }

  @override
  String memLetterTimelineHintNow(String callName) {
    return 'On the timeline: “💌 Letter from $callName”';
  }

  @override
  String get memLetterSeal => 'Seal the letter';

  @override
  String memLetterSalutation(String child, String callName) {
    return 'Dear $child, from $callName,';
  }

  @override
  String get memLetterSignOff => 'With love,';

  @override
  String get memSearchHint => 'Search memories, sayings, diaries…';

  @override
  String get memSearchRecent => 'Recent';

  @override
  String get memSearchKind => 'Type';

  @override
  String get memSearchKindAll => 'All';

  @override
  String get memSearchAuthor => 'Posted by';

  @override
  String memSearchResults(int count, String query) {
    return '$count results for “$query”';
  }

  @override
  String memSearchMedia(int count) {
    return 'Photos & videos · $count';
  }

  @override
  String memSearchDiaries(int count) {
    return 'Diaries · $count';
  }

  @override
  String get memSearchNoResult => 'No memories found';

  @override
  String memOnThisDayMonthShort(int month) {
    return 'M$month';
  }

  @override
  String memOnThisDayHeader(int day, int month) {
    return 'Our family’s $day/$month';
  }

  @override
  String memOnThisDaySummary(int years, int count) {
    return '$years years of memories · $count memories';
  }

  @override
  String memOnThisDayYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count years ago',
      one: '1 year ago',
    );
    return '$_temp0';
  }

  @override
  String memOnThisDayYearMeta(String date, String child, String age) {
    return '$date · $child $age';
  }

  @override
  String memOnThisDayMilestone(String title) {
    return '⭐ $title';
  }

  @override
  String memOnThisDayPhotos(int count) {
    return '$count photos';
  }

  @override
  String memQuoteOfChild(String name, String age) {
    return '$name’s saying · $age';
  }

  @override
  String get memOnThisDayReshare => 'Share again with a new caption';

  @override
  String get memOnThisDayFooter =>
      'Only memories you can see · Turn off in Settings';

  @override
  String get memOnThisDayEmpty => 'No memories from past years today';

  @override
  String recapWeekRange(String range, String audience) {
    return 'This week · $range · $audience';
  }

  @override
  String recapQuoteMeta(String name, String age) {
    return 'New saying from $name · $age';
  }

  @override
  String get recapShareFamily => 'Share with relatives';

  @override
  String get recapFamilyBadge => 'Family';

  @override
  String get recapSaveTimeline => 'Save to timeline';

  @override
  String get recapDownload => 'Download recap image';

  @override
  String get recapNote =>
      'Review before sharing. Papa & Mama content is never included.';

  @override
  String get recapNextHighlights => 'Highlights';

  @override
  String get recapShared => 'Shared with relatives';

  @override
  String get recapSaved => 'Saved to timeline';

  @override
  String get memLetterSealDone => 'Letter sealed';

  @override
  String usThanksMonth(String month) {
    String _temp0 = intl.Intl.selectLogic(month, {
      '1': 'Jan',
      '2': 'Feb',
      '3': 'Mar',
      '4': 'Apr',
      '5': 'May',
      '6': 'Jun',
      '7': 'Jul',
      '8': 'Aug',
      '9': 'Sep',
      '10': 'Oct',
      '11': 'Nov',
      'other': 'Dec',
    });
    return '$_temp0';
  }

  @override
  String get usThanksAll => 'All';

  @override
  String get usThanksMine => 'Yours';

  @override
  String usThanksPartner(String callName) {
    return '$callName\'s';
  }

  @override
  String usThanksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count thank-yous',
      one: '1 thank-you',
    );
    return '$_temp0';
  }

  @override
  String get usThanksYou => 'You';

  @override
  String get usThanksSendCta => 'Send a thank-you';

  @override
  String get usThanksReact => 'Add a heart';

  @override
  String get usThanksWallEmpty => 'No thank-yous this month yet';

  @override
  String get usJournalOnlyYou => 'Only you can read this';

  @override
  String usJournalOnlyYouHint(String callName) {
    return '$callName can\'t see it either — unless you choose to share a passage.';
  }

  @override
  String get usJournalFaceId => 'Lock with Face ID';

  @override
  String get usJournalFaceIdHint =>
      'Ask for Face ID each time you open the journal';

  @override
  String usJournalMonth(String month) {
    String _temp0 = intl.Intl.selectLogic(month, {
      '1': 'January',
      '2': 'February',
      '3': 'March',
      '4': 'April',
      '5': 'May',
      '6': 'June',
      '7': 'July',
      '8': 'August',
      '9': 'September',
      '10': 'October',
      '11': 'November',
      'other': 'December',
    });
    return '$_temp0';
  }

  @override
  String usJournalMood(String mood) {
    String _temp0 = intl.Intl.selectLogic(mood, {
      'tired': 'Tired',
      'grateful': 'Grateful',
      'worried': 'Worried',
      'other': 'Calm',
    });
    return '$_temp0';
  }

  @override
  String get usJournalShareAction => 'Share this passage with your partner';

  @override
  String usJournalShared(String callName) {
    return 'Shared 1 passage with $callName';
  }

  @override
  String get usJournalWrite => 'Write a new page';

  @override
  String usJournalSharePreview(String callName) {
    return '$callName will see exactly this:';
  }

  @override
  String usJournalShareConfirm(String callName) {
    return 'Share with $callName';
  }

  @override
  String get usJournalNewPage => 'New page';

  @override
  String get usJournalMoodLabel => 'How are you feeling?';

  @override
  String get usJournalTitleLabel => 'Title';

  @override
  String get usJournalBodyLabel => 'What you want to write down';

  @override
  String get usJournalSave => 'Save page';

  @override
  String get usJournalEmpty => 'No pages yet. Write a few lines just for you.';

  @override
  String usSettingsScope(String callName) {
    return 'Only applies to you · $callName has their own settings';
  }

  @override
  String get usSettingsCheckinSection => 'When you check in';

  @override
  String usSettingsShareMode(String mode, String callName) {
    String _temp0 = intl.Intl.selectLogic(mode, {
      'askEachTime': 'Ask every time',
      'alwaysShare': 'Always share with $callName',
      'other': 'Always private',
    });
    return '$_temp0';
  }

  @override
  String usSettingsShareModeHint(String mode, String callName) {
    String _temp0 = intl.Intl.selectLogic(mode, {
      'askEachTime': 'Choose to share or keep private after each check-in',
      'alwaysShare': '$callName sees your mood and the parts you tick',
      'other': 'Only you can look back at it',
    });
    return '$_temp0';
  }

  @override
  String get usSettingsPrivacySection => 'Privacy';

  @override
  String get usSettingsHideLock => 'Hide content on the lock screen';

  @override
  String get usSettingsHideLockHint =>
      'Only shows “You have a new update from Papa & Mama”';

  @override
  String get usSettingsFaceId => 'Face ID lock for Papa & Mama';

  @override
  String get usSettingsFaceIdHint =>
      'Ask for Face ID every time you open this tab';

  @override
  String get usSettingsRequestsSection => 'Requests';

  @override
  String usSettingsUrgentBypass(String callName) {
    return 'Let $callName\'s “Soon, please” requests come through quiet hours';
  }

  @override
  String usSettingsUrgentBypassHint(String from, String to) {
    return 'Your quiet hours: $from–$to. When off, requests arrive after quiet hours.';
  }

  @override
  String get usSettingsBridgeSection => 'Bridge';

  @override
  String get usSettingsBridgeKeep => 'Keep Bridge session content';

  @override
  String usSettingsRetention(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
      zero: 'Delete now',
    );
    return '$_temp0';
  }

  @override
  String get usSettingsBridgeHint =>
      'After this time, what you both wrote in the session is deleted automatically.';

  @override
  String get usSettingsDataSection => 'Data';

  @override
  String get usSettingsClearMood => 'Delete my mood history';

  @override
  String get usSettingsClearMoodHint =>
      'Deletes every check-in you saved. This can\'t be undone.';

  @override
  String get usSettingsClearMoodConfirm => 'Delete mood history?';

  @override
  String get usSettingsClearMoodDone => 'Mood history deleted';

  @override
  String get commonDelete => 'Delete';

  @override
  String get childEditProfile => 'Edit profile';

  @override
  String get childChangeCover => 'Change cover';

  @override
  String childColorName(String index) {
    String _temp0 = intl.Intl.selectLogic(index, {
      '0': 'Peach',
      '1': 'Mint',
      '2': 'Sky',
      '3': 'Lavender',
      '4': 'Lemon',
      '5': 'Rose',
      '6': 'Apricot',
      'other': 'Aqua',
    });
    return '$_temp0';
  }

  @override
  String childColorNamed(String color) {
    return '$color';
  }

  @override
  String get childStatMemories => 'memories';

  @override
  String get childStatMilestones => 'milestones';

  @override
  String get childStatLetters => 'letters';

  @override
  String get childBirthDate => 'Date of birth';

  @override
  String childLunarBirth(String date) {
    return 'Lunar: $date';
  }

  @override
  String get childBirthTime => 'Time of birth';

  @override
  String get childBirthTimeHidden => 'Relatives can\'t see the birth time';

  @override
  String get childBirthTimeShown => 'Relatives can see the birth time';

  @override
  String get childDueDate => 'Due date';

  @override
  String get childOriginPregnancy => 'Pregnancy journey';

  @override
  String childOriginPregnancyValue(int weeks) {
    return 'Pregnancy journey · $weeks weeks';
  }

  @override
  String get childNameStory => 'Name story';

  @override
  String childNameGivenBy(String names) {
    return 'Named by $names';
  }

  @override
  String childNamesAnd(String first, String second) {
    return '$first & $second';
  }

  @override
  String childLikes(String name) {
    return '$name loves';
  }

  @override
  String get childFavFood => 'Favourite food';

  @override
  String get childFavToy => 'Toy';

  @override
  String get childFavSong => 'Song';

  @override
  String childQuoted(String text) {
    return '“$text”';
  }

  @override
  String childRelativesSee(String name) {
    return 'Relatives who see $name';
  }

  @override
  String get childRelativesNone => 'Not shared with any relatives yet';

  @override
  String get childArchiveAction => 'Archive this profile';

  @override
  String childArchiveConfirmTitle(String name) {
    return 'Archive $name\'s profile?';
  }

  @override
  String get childArchiveConfirmBody =>
      'Memories only about this child are hidden; shared memories stay with the siblings. You can restore it any time.';

  @override
  String get childArchive => 'Archive';

  @override
  String childEditTitleNamed(String name) {
    return 'Edit $name\'s profile';
  }

  @override
  String get childChangeAvatar => 'Change profile photo';

  @override
  String get childChangeTimelineCover => 'Change timeline cover';

  @override
  String get childFieldName => 'Name';

  @override
  String get childFieldNickname => 'Nickname';

  @override
  String get childBirthDateWarning =>
      'Ages on memories will be recalculated from the new date of birth.';

  @override
  String get childShowBirthTime => 'Show birth time to relatives';

  @override
  String get childShowBirthTimeHint => 'Relatives always see the child\'s age';

  @override
  String get childColorLabel => 'Colour';

  @override
  String childColorUsedBy(String color, String name) {
    return '$color is used for $name';
  }

  @override
  String get childNameGivenByLabel => 'Named by:';

  @override
  String get childNameGivenByOther => '+ Other';

  @override
  String get childLikesSection => 'Favourites';

  @override
  String get childSaveChanges => 'Save changes';

  @override
  String get childrenReorderHint =>
      'Press and drag to change the display order';

  @override
  String childPregnancyTag(int number) {
    return 'Pregnancy #$number';
  }

  @override
  String childDueShort(String date) {
    return 'due $date';
  }

  @override
  String childrenArchived(int count) {
    return 'Archived ($count)';
  }

  @override
  String childArchivedOn(String date) {
    return 'Archived $date';
  }

  @override
  String childPrivateMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count private memories',
      one: '1 private memory',
    );
    return '$_temp0';
  }

  @override
  String get childRestore => 'Restore';

  @override
  String childrenArchiveNote(int days) {
    return 'Archived children are hidden from the child switcher. They can be deleted permanently after $days days in the archive.';
  }

  @override
  String childAddSubtitle(String family, String names) {
    return 'The new child joins $family. $names\'s profiles stay as they are.';
  }

  @override
  String childNamesList(String rest, String last) {
    return '$rest and $last';
  }

  @override
  String get childAddBorn => 'Our baby is here';

  @override
  String get childAddBornHint =>
      'Add a profile with the name and date of birth';

  @override
  String get childAddExpecting => 'We\'re expecting';

  @override
  String childAddExpectingHint(int number) {
    return 'Start a new pregnancy journey (Pregnancy #$number)';
  }

  @override
  String get childNameHint => 'e.g. Bin, Mit, Su…';

  @override
  String get childBirthDateHint => 'Choose a date of birth';

  @override
  String get childDueDateHint => 'Choose a due date';

  @override
  String get childGenderOptional => 'Gender (optional)';

  @override
  String childGender(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'boy': 'Boy',
      'girl': 'Girl',
      'other': 'Prefer not to say',
    });
    return '$_temp0';
  }

  @override
  String get childAddShareNote =>
      'After adding, you can choose which relatives to share with. By default it isn\'t shared with anyone.';

  @override
  String get memSearchYear => 'Year';

  @override
  String memDotMeta2(String first, String second) {
    return '$first · $second';
  }

  @override
  String childLunarDateYear(String day, String month, String year) {
    return '$day/$month $year';
  }

  @override
  String get careMoreMenu => 'More';

  @override
  String get careMenuHistory => 'Task history';

  @override
  String setDelPartnerRole(String callName) {
    return '$callName · Family manager';
  }

  @override
  String memAlbumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count albums',
      one: '1 album',
    );
    return '$_temp0';
  }
}
