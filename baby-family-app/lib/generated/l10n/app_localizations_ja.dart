// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'Baby Family';

  @override
  String get commonContinue => '次へ';

  @override
  String get commonStart => 'はじめる';

  @override
  String get commonCancel => 'キャンセル';

  @override
  String get commonConfirm => '確認';

  @override
  String get commonRetry => 'もう一度試す';

  @override
  String get commonClose => '閉じる';

  @override
  String get commonCopyError => 'エラーをコピー';

  @override
  String commonDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '残り $count 日',
      zero: '今日が最終日です',
    );
    return '$_temp0';
  }

  @override
  String commonUpdatedAt(DateTime time) {
    final intl.DateFormat timeDateFormat = intl.DateFormat.Hm(localeName);
    final String timeString = timeDateFormat.format(time);

    return '$timeString に更新';
  }

  @override
  String get errorGeneric => '問題が発生しました。もう一度お試しください。';

  @override
  String get errorNetwork => 'サーバーに接続できません。通信環境を確認して、もう一度お試しください。';

  @override
  String get errorRenewSessionNetwork =>
      'ログインを更新するためのサーバーに接続できません。通信環境を確認して、もう一度お試しください。';

  @override
  String get errorSessionExpired => 'ログインの有効期限が切れました。もう一度ログインしてください。';

  @override
  String get errorUpgradeRequired => 'アプリのバージョンが古くなっています。更新してご利用ください。';

  @override
  String get errorStartupTitle => 'アプリを起動できませんでした';

  @override
  String get errorStartupDescription =>
      'アプリを開き直してください。問題が続く場合は、以下の情報をサポートにお送りください：';

  @override
  String get languagePickerTitle => '言語を選択';

  @override
  String get welcomeSlide1Title => 'お子さまの成長の歩みを残そう';

  @override
  String get welcomeSlide1Description =>
      'はじめてのエコー写真から、よちよち歩きまで。すべての瞬間を家族だけの大切な思い出に。';

  @override
  String get welcomeSlide2Title => 'Papa & Mama で一緒に子育て';

  @override
  String get welcomeSlide2Description =>
      '毎日の小さなタスクで、Papa と Mama が声をかけ合わなくても子育てを分かち合えます。';

  @override
  String get welcomeSlide3Title => '祖父母も一緒に成長を見守ろう';

  @override
  String get welcomeSlide3Description => '祖父母や親戚と成長を見守る。SNSなしで安全に、プライベートに。';

  @override
  String get welcomeHaveInviteCode => '招待コードを持っています';

  @override
  String get commonSave => '保存';

  @override
  String get commonDone => '完了';

  @override
  String get commonAdd => '追加';

  @override
  String get commonSeeAll => 'すべて見る';

  @override
  String get commonBack => '戻る';

  @override
  String get commonEmptyTitle => 'まだ何もありません';

  @override
  String get commonEmptyMessage => '家族の最初の瞬間を残してみましょう。';

  @override
  String get commonOffline => 'オフラインです。保存済みの内容は引き続きご覧いただけます。';

  @override
  String get commonMockMode => 'サンプルデータ';

  @override
  String get commonAllFamily => '家族みんな';

  @override
  String get commonMine => '自分';

  @override
  String commonPartnerTasks(String callName) {
    return '$callName のタスク';
  }

  @override
  String get commonTogether => '一緒に';

  @override
  String get commonOnlyYou => '自分だけ';

  @override
  String get commonOnlyParents => 'Papa & Mama だけ';

  @override
  String get commonPhotos => '写真';

  @override
  String get commonTimeline => 'タイムライン';

  @override
  String get commonCollections => 'コレクション';

  @override
  String get commonMemory => '思い出';

  @override
  String get commonDiary => '日記';

  @override
  String get commonMilestone => '成長の節目';

  @override
  String get commonLetter => 'お子さまへの手紙';

  @override
  String get commonMission => 'タスク';

  @override
  String get commonEvent => 'イベント';

  @override
  String get commonCheckin => '気持ちのチェックイン';

  @override
  String get commonRequest => 'お願い';

  @override
  String get commonThanks => 'ありがとう';

  @override
  String get commonSelectChild => 'お子さまを選択';

  @override
  String get commonQuickCreate => '小さな瞬間を残そう';

  @override
  String get commonName => '名前';

  @override
  String get commonDate => '日付';

  @override
  String get commonBody => '内容';

  @override
  String get commonSaved => 'デモに保存しました';

  @override
  String get commonInvalidInput => '必要な情報を入力してから保存してください。';

  @override
  String commonChildAge(int months, int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years歳$monthsか月',
      zero: '生後$monthsか月',
    );
    return '$_temp0';
  }

  @override
  String commonPregnancyWeek(int week) {
    return '妊娠$week週';
  }

  @override
  String commonCountMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '思い出$count件',
    );
    return '$_temp0';
  }

  @override
  String commonHearts(int count) {
    return '$count Hearts';
  }

  @override
  String get navHome => 'ホーム';

  @override
  String get navMemories => '思い出';

  @override
  String get navCare => '子育て';

  @override
  String get navUs => 'Papa & Mama';

  @override
  String homeGreeting(String name) {
    return 'こんにちは、$name';
  }

  @override
  String get homeToday => '子どもたちの今日';

  @override
  String get homeSpecialDay => '特別な日';

  @override
  String get homeMonthlyPhoto => '月齢写真を撮る';

  @override
  String get homeMissions => '今日のタスク';

  @override
  String get homePrompt => '思い出を残すヒント';

  @override
  String get homeRecordQuote => '言葉を記録';

  @override
  String get homeRecent => '家族の新着';

  @override
  String get homeThisWeek => '家族の今週';

  @override
  String get homeFamilyTree => '家族の木';

  @override
  String get homeFamily => '自分の家族';

  @override
  String get careTitle => '子育て';

  @override
  String get careTodayTree => '今日の木';

  @override
  String careProgress(int done, int total) {
    return '家族のタスク $done/$total';
  }

  @override
  String get careAddMission => 'タスクを追加';

  @override
  String get careMissionTitle => 'タスク名';

  @override
  String get careWhoDoes => '誰が担当しますか？';

  @override
  String get careWhen => 'いつですか？';

  @override
  String get careReminder => 'やさしいリマインダー';

  @override
  String get careRepeat => '繰り返し';

  @override
  String careAskPartner(String callName) {
    return '$callName にお願いする';
  }

  @override
  String get careCompleteTitle => '小さなタスクに、少しの愛情';

  @override
  String get careSaveMoment => '思い出として保存';

  @override
  String get careUndo => '元に戻す';

  @override
  String get careSwapTitle => 'タスクを変更';

  @override
  String get careRemoveToday => '今日から外す（減点なし）';

  @override
  String get careTreeTitle => '家族の木';

  @override
  String careTreeLevel(int level) {
    return 'レベル$level';
  }

  @override
  String get careTreeNext => '一緒に木をもう少し育てよう';

  @override
  String get careContribution => '家族みんなの積み重ね';

  @override
  String get careHeartsPrivacy => '自分のHeartsは自分だけに表示されます。比較されず、減ることもありません。';

  @override
  String get usTitle => 'Papa & Mama';

  @override
  String get usHowAreYou => '今日はどんな気持ちですか？';

  @override
  String get usEnergy => '今のエネルギー';

  @override
  String get usNeed => '今、何が必要ですか？';

  @override
  String usShareWith(String callName) {
    return '$callName に共有';
  }

  @override
  String get usPrivate => 'Papa & Mama だけのプライベートな場所';

  @override
  String get usSendRequest => 'お願いを送る';

  @override
  String get usRequestMessage => 'どんなことをお願いしますか？';

  @override
  String get usAccept => '引き受ける';

  @override
  String get usDecline => '今日は難しい';

  @override
  String get usRequestAccepted => '引き受けました';

  @override
  String get usRequestDone => '完了しました';

  @override
  String get usDailyQuestion => '今日のつながる質問';

  @override
  String get usJournal => '二人の日記';

  @override
  String get usBridge => '二人をつなぐ小さな橋';

  @override
  String get usWeek => '二人の一週間';

  @override
  String get usHug => 'ハグを送る';

  @override
  String get usSeen => '見たよ';

  @override
  String get usTakeOver => '任せて';

  @override
  String get usThanksRecent => '最近のありがとう';

  @override
  String get familyTitle => '自分の家族';

  @override
  String get familyChildren => '子どもたち';

  @override
  String get familyParents => 'Papa & Mama';

  @override
  String get familyRelatives => '祖父母・親戚';

  @override
  String get familyInvite => '親戚を招待';

  @override
  String get familyPermissions => '権限';

  @override
  String get familyPrivateNotice => '親戚には共有した内容だけが見えます。Papa & Mama はいつも非公開です。';

  @override
  String get familyTrial => '無料お試し';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsAppearance => '外観';

  @override
  String get settingsLight => 'ライト';

  @override
  String get settingsDark => 'ダーク';

  @override
  String get settingsSystem => 'システムに合わせる';

  @override
  String get settingsTextSize => '文字サイズ';

  @override
  String get settingsRegular => '標準';

  @override
  String get settingsLarge => '大きい';

  @override
  String get settingsExtraLarge => 'とても大きい';

  @override
  String get settingsNotifications => '通知';

  @override
  String get settingsPrivacy => 'プライバシー';

  @override
  String get settingsAi => 'AIサポート';

  @override
  String get settingsSecurity => 'セキュリティと端末';

  @override
  String get settingsData => '自分のデータ';

  @override
  String get settingsBilling => 'プランと支払い';

  @override
  String get settingsHelp => 'ヘルプ';

  @override
  String get settingsAbout => 'このアプリについて';

  @override
  String get settingsLogout => 'ログアウト';

  @override
  String get settingsLanguageNotice => 'すぐに適用され、再起動は不要です。家族が書いた内容は翻訳されません。';

  @override
  String get settingsLunar => '旧暦の日付を表示';

  @override
  String get settingsHaptics => '操作時の振動';

  @override
  String get billingTitle => '子どもの大切な瞬間をすべて残す';

  @override
  String get billingHouse => 'House';

  @override
  String get billingFamily => 'Family';

  @override
  String get billingRestore => '購入を復元';

  @override
  String get billingUpgrade => 'プランをアップグレード';

  @override
  String get billingExpired => '家族の3か月のお試し期間が終了しました';

  @override
  String get billingExport => 'データをダウンロード';

  @override
  String get billingPrivacy => '思い出はいつも家族のものです。プランの期限が切れてもデータをダウンロードできます。';

  @override
  String get billingFamilyFeatures => '親戚12人まで · ストレージ200 GB';

  @override
  String get billingHouseFeatures => 'Papa & Mama 向け · ストレージ50 GB';

  @override
  String get notificationsTitle => '通知';

  @override
  String get notificationsAll => 'すべて';

  @override
  String get notificationsPrivate => 'Papa & Mama';

  @override
  String get stateLoading => '読み込み中…';

  @override
  String get stateEmptyMemories => 'まだ思い出がありません。最初の瞬間を残しましょう！';

  @override
  String get stateEmptyCare => '今日のタスクはまだありません';

  @override
  String get stateError => '内容を読み込めませんでした。もう一度お試しください。';

  @override
  String get commonChoose => '選択';

  @override
  String get commonRequired => 'この項目を入力してください';

  @override
  String get memoriesTitle => '思い出';

  @override
  String get memoriesTimeline => 'タイムライン';

  @override
  String get memoriesPhotos => '写真';

  @override
  String get memoriesCollections => 'コレクション';

  @override
  String get memoriesAll => 'すべて';

  @override
  String get memoriesFirsts => 'はじめて';

  @override
  String get memoriesQuotes => 'ことば';

  @override
  String get memoriesVoices => '声';

  @override
  String get memoriesNew => '新しい思い出';

  @override
  String get memoriesCaptionHint => 'この瞬間について、何を覚えておきたいですか？';

  @override
  String get memoriesChildren => 'この瞬間のお子さま';

  @override
  String get memoriesFamily => '家族みんな';

  @override
  String get memoriesDate => '思い出の日付';

  @override
  String get memoriesToday => '今日';

  @override
  String get memoriesVisibility => '見られる人';

  @override
  String get memoriesPrivacyHint => '保存前に写真の GPS 位置情報を削除します。';

  @override
  String get memoriesAddMedia => '写真を追加';

  @override
  String get memoriesAddPerspective => 'あなたの視点を追加';

  @override
  String get memoriesTogether => '二人でつづる';

  @override
  String get memoriesCommentHint => 'コメントを書く…';

  @override
  String get memoriesComments => 'コメント';

  @override
  String get memoriesSend => '送信';

  @override
  String get memoriesMonthly => '月ごとの成長';

  @override
  String get memoriesYear => '最初の一年';

  @override
  String get memoriesCompare => '比べる';

  @override
  String get memoriesCollage => 'コラージュ';

  @override
  String get memoriesMonthlyPhoto => '月齢写真';

  @override
  String get memoriesGhost => '前の写真のガイド';

  @override
  String get memoriesGallery => 'ライブラリから選択';

  @override
  String get memoriesCapture => '写真を撮る';

  @override
  String get memoriesQuote => 'お子さまのことば';

  @override
  String get memoriesQuoteHint => '今日、お子さまは何を話しましたか？';

  @override
  String get memoriesQuoteContext => 'いつ話していましたか？';

  @override
  String get memoriesRecordVoice => 'お子さまの声を録音';

  @override
  String get memoriesPerspective => 'あなたの視点';

  @override
  String get memoriesPerspectiveHint => 'この瞬間について、何を覚えていますか？';

  @override
  String get memoriesInheritedVisibility => '元の思い出と同じ閲覧範囲';

  @override
  String get memoriesStory => 'お子さまの今日';

  @override
  String get memoriesReplyHint => '返信する…';

  @override
  String get memoriesEmpty => 'まだ思い出がありません。最初の瞬間を残しましょう！';

  @override
  String get memoriesSaved => '思い出を保存しました';

  @override
  String get memoriesChooseChildren => 'お子さまを一人以上、または家族みんなを選択してください';

  @override
  String memoriesMonthLabel(int month) {
    String _temp0 = intl.Intl.pluralLogic(
      month,
      locale: localeName,
      other: '$monthか月',
    );
    return '$_temp0';
  }

  @override
  String memoriesWeekLabel(int week) {
    return '$week週目';
  }

  @override
  String memoriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '思い出$count件',
    );
    return '$_temp0';
  }

  @override
  String get pregnancyTitle => '妊娠の記録';

  @override
  String get pregnancyBump => 'おなかの写真';

  @override
  String get pregnancyUltrasound => 'エコー写真';

  @override
  String get pregnancyPreparations => '準備';

  @override
  String get pregnancyCaptureBump => '今週のおなかの写真を撮る';

  @override
  String get pregnancyGuide => '前の写真のガイドで同じ角度に合わせましょう';

  @override
  String get pregnancyBumpKindness => '何週間か撮れなくても大丈夫。どの写真も大切な一枚です。';

  @override
  String get pregnancyRemind => '毎週日曜日にお知らせ';

  @override
  String get pregnancyBirth => '赤ちゃんが生まれました';

  @override
  String get pregnancyNames => '赤ちゃんの名前';

  @override
  String get pregnancyArchive => '記録をアーカイブ';

  @override
  String pregnancyPrepareProgress(int done, int total) {
    return '$total件中$done件準備済み';
  }

  @override
  String get pregnancyAddPreparation => '項目を追加';

  @override
  String get pregnancyPreparationHint => '家族で準備したいもの';

  @override
  String get pregnancyCreateMission => 'タスクにする';

  @override
  String get pregnancyBirthWelcome => '家族へようこそ';

  @override
  String get pregnancyBabyName => '名前またはニックネーム';

  @override
  String get pregnancyNickname => 'ニックネーム';

  @override
  String get pregnancyBirthDate => '生年月日 *';

  @override
  String get pregnancyBirthTime => '出生時刻';

  @override
  String get pregnancyBirthWeight => '体重（kg）';

  @override
  String get pregnancyBirthGender => '性別（任意）';

  @override
  String get pregnancyBirthPreview => 'ウェルカムカードを見る';

  @override
  String get pregnancyAnnounce => '親戚にお知らせしますか？';

  @override
  String get pregnancyAnnounceHint =>
      '妊娠の記録を共有している親戚だけにお知らせします。妊娠中の思い出は赤ちゃんの物語の最初の章になります。';

  @override
  String get pregnancyBirthComplete => 'ようこそ、赤ちゃん！情報を保存しました。';

  @override
  String get pregnancyArchiveIntro => '思い出はすべて残ります。いつでも戻ってこられます。';

  @override
  String get pregnancyPause => '記録を一時停止';

  @override
  String get pregnancyPauseHint => 'ホームに表示せず、リマインダーを止めます。好きなときに再開できます。';

  @override
  String get pregnancyEnd => 'この旅は終わりを迎えました';

  @override
  String get pregnancyEndHint =>
      '心よりお悔やみ申し上げます。カウントダウン、リマインダー、お祝いのメッセージをすぐに停止します。';

  @override
  String get pregnancyParentsOnly => 'この思い出を見られるのは Papa & Mama だけ';

  @override
  String get pregnancyArchivePrivacy => '親戚への通知は送信されません。';

  @override
  String get pregnancyArchiveSaved => '記録を非公開でアーカイブしました';

  @override
  String get pregnancyPrivate => 'Papa & Mama だけが見られます';

  @override
  String get pregnancyBothLike => '二人のお気に入り';

  @override
  String get pregnancyAddName => '名前の候補を追加';

  @override
  String get pregnancyNameHint => '名前の候補';

  @override
  String get pregnancyMeaning => '意味';

  @override
  String get pregnancyChooseName => 'この名前を選ぶ';

  @override
  String get pregnancyNameChosen => '名前の候補を保存しました';

  @override
  String get pregnancyMockMedia => 'サンプル写真の準備ができました';

  @override
  String get commonSkip => 'スキップ';

  @override
  String get commonLater => 'あとで';

  @override
  String get commonOr => 'または';

  @override
  String get commonCopied => 'コピーしました';

  @override
  String get commonChoosePhoto => '写真を選択';

  @override
  String get commonRemovePhoto => '写真を削除';

  @override
  String get commonTerms => '利用規約';

  @override
  String get commonPrivacyPolicy => 'プライバシーポリシー';

  @override
  String get commonOptional => '任意';

  @override
  String get authTitle => 'Baby Family へようこそ';

  @override
  String get authSubtitle => 'ログインして、家族みんなでお子さまの成長を残しましょう。';

  @override
  String get authPrivate => 'プライベート';

  @override
  String get authTrial => '3か月無料';

  @override
  String get authFamily => '家族みんな';

  @override
  String get authApple => 'Apple で続ける';

  @override
  String get authGoogle => 'Google で続ける';

  @override
  String get authPhone => '電話番号で続ける';

  @override
  String get authLegal => '続行すると、Baby Family の利用規約とプライバシーポリシーに同意したものとします。';

  @override
  String get authPhoneTitle => '電話番号';

  @override
  String get authPhoneSubtitle => 'Zalo または SMS で6桁の確認コードを送信します。';

  @override
  String get authPhoneLabel => '電話番号';

  @override
  String get authCountryCode => '国番号';

  @override
  String get authPhonePrivate => '電話番号はログインにのみ使用し、他の人には表示しません。';

  @override
  String get authSendCode => 'コードを送信';

  @override
  String get authOtpTitle => '確認コードを入力';

  @override
  String authOtpSubtitle(String phone) {
    return '6桁のコードを Zalo で $phone に送りました。';
  }

  @override
  String authOtpDemo(String code) {
    return 'デモコード：$code';
  }

  @override
  String get authResend => 'コードを再送信';

  @override
  String authResendCountdown(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: 'あと$seconds秒で再送信',
    );
    return '$_temp0';
  }

  @override
  String get authSendSms => 'SMS で送信';

  @override
  String get authChangePhone => '電話番号を変更';

  @override
  String get authProfileTitle => 'あなたについて教えてください';

  @override
  String get authProfileSubtitle => 'この名前はパートナーや家族に表示されます。';

  @override
  String get authNameLabel => 'お名前';

  @override
  String get authTermsConsent => '利用規約に同意します';

  @override
  String get authDataConsent =>
      'プライバシーポリシーに従って Baby Family が私と子どもの個人データを処理することに同意します';

  @override
  String get errorRequired => 'この項目を入力してください。';

  @override
  String get errorPhone => '有効な電話番号を入力してください。';

  @override
  String get errorConsent => '続行するには両方の項目に同意してください。';

  @override
  String get errorOtp => 'コードが正しくありません。もう一度お試しください。';

  @override
  String get errorOtpExpired => 'コードの有効期限が切れました。再送信してください。';

  @override
  String get errorInviteCode => '招待コードは8文字の英数字です。';

  @override
  String get errorBirthday => '生年月日に未来の日付は指定できません。';

  @override
  String get errorPregnancyWeek => '妊娠週数は4週から42週の間で入力してください。';

  @override
  String get onboardingRoleTitle => '家族の中での役割は？';

  @override
  String get onboardingRoleSubtitle =>
      'Baby Family は Papa と Mama が一緒に使います。祖父母や親戚はあとで招待できます。';

  @override
  String get onboardingPapaDescription => 'お子さまのお父さん。Mama と一緒に家族を管理';

  @override
  String get onboardingMamaDescription => 'お子さまのお母さん。Papa と一緒に家族を管理';

  @override
  String get onboardingCircle => '家族・親戚';

  @override
  String get onboardingCircleDescription => '祖父母、親戚、養育者。家族への招待が必要です';

  @override
  String get onboardingCallName => 'お子さまからの呼び名';

  @override
  String get onboardingOtherCallName => 'その他…';

  @override
  String get onboardingFatherCallName => 'お父さん';

  @override
  String get onboardingFatherCallNameAlt => 'パパ';

  @override
  String get onboardingMotherCallName => 'お母さん';

  @override
  String get onboardingMotherCallNameAlt => 'ママ';

  @override
  String get onboardingFamilyTitle => '家族の名前をつけよう';

  @override
  String get onboardingFamilySubtitle => '家族の名前は Papa、Mama、招待された家族だけに表示されます。';

  @override
  String get onboardingFamilyName => '家族の名前';

  @override
  String get onboardingCreateFamily => '家族を作成';

  @override
  String onboardingInviteTitle(String callName) {
    return '$callName を招待';
  }

  @override
  String get onboardingInviteSubtitle =>
      'Baby Family は Papa と Mama で使います。パートナーが参加すると、家族の3か月無料お試しが始まります。';

  @override
  String get onboardingInviteCode => '招待コード';

  @override
  String get onboardingInviteExpiry => '有効期限7日 · 1回のみ使用可能';

  @override
  String get onboardingInviteApproval => 'パートナーの参加時に自分が最終確認する';

  @override
  String get onboardingShareInvite => 'Zalo、Messenger などで招待';

  @override
  String get onboardingCopyInvite => '招待リンクをコピー';

  @override
  String get onboardingInviteSent => '招待を送信しました';

  @override
  String onboardingWaitingTitle(String callName) {
    return '$callName の参加を待っています…';
  }

  @override
  String get onboardingWaitingSubtitle =>
      'パートナーが招待を受けると、家族の機能が使えるようになり、3か月無料お試しが始まります。';

  @override
  String get onboardingResendInvite => '招待を再送信';

  @override
  String get onboardingShowQr => 'QR コードを表示';

  @override
  String get onboardingChangeInvite => '招待方法を変更';

  @override
  String get onboardingCancelFamily => 'この家族を取り消す';

  @override
  String get onboardingActivateDemo => 'パートナーの参加をシミュレート';

  @override
  String get onboardingActivatedTitle => 'Papa & Mama がそろいました 🎉';

  @override
  String get onboardingActivatedSubtitle =>
      'お子さまの成長を残し、子育てを分かち合い、お互いをもっと理解しましょう。';

  @override
  String get onboardingTrial => '3か月無料お試し';

  @override
  String get onboardingSetupChild => 'お子さまの情報を設定';

  @override
  String get onboardingStageTitle => '今、家族はどんな時期ですか？';

  @override
  String get onboardingStageSubtitle => 'お子さまや妊娠の記録は、いつでも追加できます。';

  @override
  String get onboardingPregnant => '妊娠中';

  @override
  String get onboardingPregnantDescription => 'お腹の写真、エコー、子どもへの手紙を残し、出産の準備';

  @override
  String get onboardingBorn => '赤ちゃんが生まれた';

  @override
  String get onboardingBornDescription => 'プロフィールを作り、初めてを残し、一緒に子育て';

  @override
  String get onboardingBoth => '子どもがいて、妊娠中';

  @override
  String get onboardingBothDescription => '複数の子どもや妊娠を1つの家族で管理';

  @override
  String get onboardingPregnancyTitle => 'こんにちは、小さな赤ちゃん';

  @override
  String get onboardingPregnancySubtitle => 'まずはニックネームから。他の情報はあとで追加できます。';

  @override
  String get onboardingNickname => '赤ちゃんのニックネーム';

  @override
  String get onboardingDueDate => '出産予定日';

  @override
  String get onboardingKnowWeek => '妊娠週数だけわかる';

  @override
  String get onboardingWeek => '妊娠週数';

  @override
  String get onboardingBabyCount => '赤ちゃんの人数';

  @override
  String get onboardingSingle => '一人';

  @override
  String get onboardingTwins => '双子';

  @override
  String get onboardingTriplets => '三つ子';

  @override
  String get onboardingSkipDueDate => '出産予定日をスキップ';

  @override
  String get onboardingChildTitle => 'お子さまを紹介してください';

  @override
  String get onboardingChildSubtitle => '名前かニックネームと誕生日があれば始められます。';

  @override
  String get onboardingChildName => '名前またはニックネーム';

  @override
  String get onboardingBirthday => '誕生日';

  @override
  String get onboardingBoy => '男の子';

  @override
  String get onboardingGirl => '女の子';

  @override
  String get onboardingAddChild => '別のお子さまを追加';

  @override
  String get onboardingPrivacyTitle => '家族だけの場所';

  @override
  String get onboardingPrivacySubtitle => 'Baby Family は、かけがえのない瞬間を守ります。';

  @override
  String get onboardingPrivacyInvited => '招待された人だけがお子さまの写真を見られます';

  @override
  String get onboardingPrivacyInvitedDescription =>
      '公開ページはありません。家族を検索することもできません。';

  @override
  String get onboardingPrivacyUs => 'Papa & Mama は二人だけの場所';

  @override
  String get onboardingPrivacyUsDescription => '気持ち、お願い、二人の日記は祖父母には表示されません。';

  @override
  String get onboardingPrivacyData => 'データはあなたのもの';

  @override
  String get onboardingPrivacyDataDescription => '設定からいつでもダウンロードや削除ができます。';

  @override
  String get onboardingUnderstood => 'わかりました';

  @override
  String get onboardingNotificationsTitle => '大切な瞬間を見逃さない';

  @override
  String get onboardingNotificationsSubtitle =>
      'Papa/Mama のタスク、新しい写真、サポートのお願いを受け取ります。種類と静かな時間は設定で変更できます。';

  @override
  String get onboardingEnableNotifications => '通知を有効にする';

  @override
  String get inviteTitle => '招待コードを入力';

  @override
  String get inviteSubtitle => 'Papa または Mama からの招待メッセージに8文字のコードがあります。';

  @override
  String get inviteView => '招待を見る';

  @override
  String get inviteScanQr => 'QR コードを読み取る';

  @override
  String get inviteUseDemo => 'デモの招待コードを使用';

  @override
  String get inviteJoin => '家族に参加';

  @override
  String get inviteDecline => '辞退する';

  @override
  String get inviteRole => 'あなたの役割';

  @override
  String get inviteAccepted => 'デモで招待を受けました';

  @override
  String get inviteDeclined => 'デモで招待を辞退しました';

  @override
  String get inviteInvalidTitle => 'この招待は無効になりました';

  @override
  String get inviteInvalidDescription => '招待した人に新しいリンクを送ってもらってください。';

  @override
  String get circleWaitingTitle => '家族からの招待が必要です';

  @override
  String get circleWaitingSubtitle =>
      'Papa または Mama に招待されると、孫の写真や初めての瞬間を見られます。';

  @override
  String get circleAskInvite => '家族に招待をお願い';

  @override
  String get circleAskMessage => 'Baby Family を入れました。お孫さんの成長を見られるように招待してください。';

  @override
  String get circleSwitchRole => '私はお子さまの Papa/Mama です';

  @override
  String get circleSignOut => 'ログアウト';

  @override
  String get authDemoDescription => 'サンプルデータでログインと権限の操作をシミュレートします。';

  @override
  String get authDemoAction => 'サンプルデータで続ける';

  @override
  String get onboardingFirstMemoryTitle => '家族の最初の思い出';

  @override
  String get onboardingFirstMemorySubtitle => 'Baby Family にお子さまの最初の瞬間を残しましょう。';

  @override
  String get onboardingFirstMemoryChoosePhoto => '写真を選ぶ';

  @override
  String get memoriesKeepsakes => '記念の品';

  @override
  String get memoriesBest => '家族のお気に入りの写真';

  @override
  String get memoriesRecordedVoice => 'サンプルの音声を保存しました';

  @override
  String get familyRelationship => 'この方は…';

  @override
  String get familyCallName => '子どもからの呼び名';

  @override
  String get familyPhotosPermission => '写真と思い出を見る';

  @override
  String get familyFirstsPermission => 'ハートとコメント';

  @override
  String get familyDownloadPermission => '写真を追加';

  @override
  String get familyInvitePreview => '共有範囲をプレビュー';

  @override
  String get familyHidden => 'Papa & Mama、タスク、非公開の内容は共有されません。';

  @override
  String get familyCreateInvite => '招待を作成';

  @override
  String get familyInviteCreated => 'サンプルの招待を作成しました。親戚へのメッセージは送信していません。';

  @override
  String get billingMockNotice => 'サンプルデータです。プランの選択、購入の復元、データの書き出しをシミュレートします。';

  @override
  String get billingSelected => 'デモでプランを選択しました。取引は発生していません。';

  @override
  String get billingRestored => '購入の復元をシミュレートしました。';

  @override
  String get billingExportReady => 'データの書き出しをシミュレートしました。家族の思い出は安全に保管されています。';

  @override
  String get notificationsReadAll => 'すべて既読にする';

  @override
  String get circleGreeting => '家族の大切な子どもたち';

  @override
  String get circleSendWish => 'メッセージを送る';

  @override
  String get settingsDemoSection => 'この項目の設定はサンプルデータでシミュレートしています。';

  @override
  String get usNeedSpace => '少し静かな時間';

  @override
  String get usNeedTalk => '話を聞いてほしい';

  @override
  String get usBridgeAngry => '今、腹が立っている';

  @override
  String get usBridgeStuck => 'うまく言葉にできない';

  @override
  String get usBridgeHint => '今の気持ちと必要なことを書いてみましょう。ひと休みして、準備ができたら戻れます。';

  @override
  String get usThanksHint => '今日はどんなことにありがとうを伝えたいですか？';

  @override
  String get usJournalHint => '今、心にあることを書き留める場所です。';

  @override
  String get usNeedHelp => '具体的な助け';

  @override
  String get usBridgeEmotion => '今、こんな気持ち…';

  @override
  String get usBridgeAnger => '怒り';

  @override
  String get usBridgePrivate => 'ここに書いた内容は自分だけが見られます';

  @override
  String get usBridgeDraft => 'よければ、自分だけの下書きを書いてみてください';

  @override
  String get usBridgeKeepPrivate => '非公開にする';

  @override
  String get usBridgePause => '一度休む';

  @override
  String get usThanksWall => 'ありがとうの壁';

  @override
  String get settingsDisplayTitle => '表示と言語';

  @override
  String get settingsOther => 'その他';

  @override
  String get settingsReduceMotion => '動きを減らす';

  @override
  String get settingsReduceMotionHint => 'アニメーションを少なくする';

  @override
  String get settingsLunarHint => '西暦の日付と並べて表示';

  @override
  String get settingsDeleteAccount => 'アカウントを削除';

  @override
  String get familyManage => '家族を管理';

  @override
  String familyYou(String callName) {
    return '$callName（あなた）';
  }

  @override
  String get familyStorageLabel => 'ストレージ';

  @override
  String get familyViewPlans => 'House / Family プランを見る';

  @override
  String get familyAddChild => '子ども・妊娠を追加';

  @override
  String get familyLockedTitle => 'Family で祖父母を招待';

  @override
  String get familyLockedDescription =>
      'お試し期間は Papa & Mama のみです。Family にアップグレードして、祖父母や親戚と成長を見守りましょう。';

  @override
  String get familyFollowing => '見守れる子ども';

  @override
  String get relationPaternalGrandfather => '父方の祖父';

  @override
  String get relationPaternalGrandmother => '父方の祖母';

  @override
  String get relationMaternalGrandfather => '母方の祖父';

  @override
  String get relationMaternalGrandmother => '母方の祖母';

  @override
  String get relationAunt => 'おば';

  @override
  String get relationUncle => 'おじ';

  @override
  String get billingHouseChildren => 'Papa & Mama、子どもの人数は無制限';

  @override
  String get billingHouseCare => 'タスク、日記、Papa & Mama';

  @override
  String get billingHouseStorage => '50 GB のストレージ';

  @override
  String get billingInviteRelatives => '祖父母や親戚を招待';

  @override
  String get billingFamilyIncludes => 'House のすべての機能';

  @override
  String get billingFamilyRelatives => '最大12人の家族を招待';

  @override
  String get billingFamilyStorage => '200 GB、オリジナル画質の写真';

  @override
  String get billingFamilyVideos => '最大10分の動画、祖父母への近況';

  @override
  String get billingLegal =>
      '1つのプランで家族全員が使えます。Papa または Mama が支払えます。毎年自動更新され、App Store / Google Play の設定でいつでも解約できます。利用規約・プライバシー';

  @override
  String get billingChoosePlans => 'House / Family を選ぶ';

  @override
  String get billingRetentionHint => '削除前に何度もお知らせします。';

  @override
  String get circleTitle => '大切な孫たち';

  @override
  String get circleNewPhotos => '今週の新しい写真';

  @override
  String get circleVoiceTip => '「メッセージを送る」を長押しして声を録音';

  @override
  String get notificationsToday => '今日';

  @override
  String get notificationsYesterday => '昨日';

  @override
  String stateEmptyMemoryTitle(String name) {
    return '$name の思い出はまだありません';
  }

  @override
  String get stateEmptyMemoryDescription => '最初の瞬間を残しましょう。写真、日記、子どもの笑い声など。';

  @override
  String get stateEmptyCareDescription => 'Papa & Mama で分担する小さなタスクを選びましょう。';

  @override
  String get stateErrorTitle => '思い出を読み込めませんでした';

  @override
  String get stateErrorDescription =>
      'こちらで小さな問題が発生しました。思い出は安全です。少し待ってから再試行してください。';

  @override
  String get stateErrorCode => 'エラー：MEM-500・サポートに連絡';

  @override
  String get splashTagline => '一緒に成長し、愛をずっと残す';

  @override
  String get splashPreparing => '家族の空間を準備しています…';

  @override
  String get onboardingChildAvatarOptional => 'プロフィール写真を追加（任意）';

  @override
  String get onboardingComplete => '完了';

  @override
  String get onboardingSkipGender => 'スキップ';

  @override
  String inviteJoinAsParent(String callName) {
    return '$callName として参加';
  }

  @override
  String get memoriesMilestones => '成長の節目';

  @override
  String get memoriesAlbum => 'アルバム';

  @override
  String get memoriesChooseAlbum => 'アルバムを選択';

  @override
  String get memoriesCaptionSuggestion => 'キャプションの提案';

  @override
  String get memoriesCover => '表紙';

  @override
  String get memoriesVideo => '動画 [1.1]';

  @override
  String memoriesNextMonth(int month) {
    return '$monthか月・明日';
  }

  @override
  String get memoriesPerspectivePrompt => 'この瞬間について、何を覚えていますか？';

  @override
  String get pregnancyHeight => '身長';

  @override
  String get pregnancyBabyBoy => '男の子';

  @override
  String get pregnancyBabyGirl => '女の子';

  @override
  String get pregnancyLater => 'あとで';

  @override
  String get pregnancyBirthBag => '入院バッグ';

  @override
  String get pregnancyDocuments => '書類';

  @override
  String get pregnancyNursery => '赤ちゃんのスペース';

  @override
  String get pregnancySupport => '心のサポート（任意）';

  @override
  String commonChildNameAge(String name, String age) {
    return '$name · $age';
  }

  @override
  String get homeEvening => 'こんばんは、';

  @override
  String get homeTomorrow => '明日';

  @override
  String get homeRecord => '記録する';

  @override
  String get homeParentsPrivacy => 'Papa & Mama · 二人だけ';

  @override
  String get homeHug => 'ハグする';

  @override
  String homeMomentCount(int count) {
    return '$count件の瞬間';
  }

  @override
  String homePhotoCount(int count) {
    return '写真$count枚';
  }

  @override
  String homeYourHearts(int count) {
    return '💗 自分の$count';
  }

  @override
  String homeMoreMissions(int count) {
    return '+ 自分のタスク$count件 · 💗 自分だけ';
  }

  @override
  String get careTreeBloom => '全部終えて木に花を咲かせよう 🌸';

  @override
  String careMyHeartsToday(int count) {
    return '今日の自分の Hearts：$count';
  }

  @override
  String get carePrivateHearts => '自分だけ';

  @override
  String get homeOtherPrompt => '別の提案';

  @override
  String commonWeek(int week) {
    return '$week週';
  }

  @override
  String homeChildToday(String name) {
    return '今日の$name';
  }

  @override
  String get homeFirstsRecent => '最近の初めて';

  @override
  String homeChildMissions(String name) {
    return '今日の$nameのタスク';
  }

  @override
  String get homeCompare => '比較';

  @override
  String careSwapHeading(String title) {
    return '「$title」を変更';
  }

  @override
  String get careSwapHint => '同じくらいの Hearts の選択肢で二人のタスクのバランスを保ちます。';

  @override
  String careSwapRemaining(int count) {
    return '今日はあと$count回変更できます';
  }

  @override
  String get careSwapConfirm => 'このタスクに変更';

  @override
  String careCompleteHearts(int count) {
    return 'すばらしい！木に +$count 💗';
  }

  @override
  String careCompleteHint(String title) {
    return '$titleで木に葉が一枚増えました。（写真を保存すると +2 💗）';
  }

  @override
  String get careSaveMemoryQuestion => 'この瞬間を保存しますか？';

  @override
  String get careMemoryCaption => 'この瞬間をひとこと…';

  @override
  String get careSaveMission => 'タスクを保存';

  @override
  String pregnancyNamesFor(String child) {
    return '$child の名前を考える';
  }

  @override
  String pregnancyChooseNameFor(String name, String child) {
    return '$child の名前を「$name」にする';
  }

  @override
  String get memoriesSavePerspective => '視点を保存・ふたりで語る';

  @override
  String get circleViewComment => '閲覧とコメント';

  @override
  String get homeStoryView => 'ストーリーで見る';

  @override
  String get homeCurrentChapter => '現在のチャプター';

  @override
  String get homeNextFirst => '次の初めては？';

  @override
  String homeMonthShort(int month) {
    return '$monthか月';
  }

  @override
  String get homeMomentLabel => '瞬間';

  @override
  String get homeQuoteLabel => '新しい言葉';

  @override
  String get commonFirsts => '初めて';

  @override
  String get circleLike => 'ハートを送る';

  @override
  String homeMonthlyProgress(int done, int total) {
    return '$done/$total枚';
  }

  @override
  String get stateAddMemory => '思い出を追加';

  @override
  String get careCamera => '写真を撮る';

  @override
  String get careGallery => '写真を選ぶ';

  @override
  String get carePhotoSelected => '写真を選択しました';

  @override
  String get commonCamera => 'カメラ';

  @override
  String get commonGallery => 'ライブラリ';

  @override
  String get careForWho => '誰のため？';

  @override
  String get careOneChild => '1人の子ども';

  @override
  String get careManyChildren => '複数の子ども';

  @override
  String get careBothParents => 'ふたり';

  @override
  String get careWhenQuestion => 'いつ？';

  @override
  String get careWhoQuestion => '誰がする？';

  @override
  String get careMemoryPrompt => '完了時に写真の保存を提案';

  @override
  String get careRemindBefore => '15分前に通知';

  @override
  String careAskPartnerPrompt(String callName) {
    return '$callName に頼みたい？お願いを送る →';
  }

  @override
  String get careTreeName => '緑の木';

  @override
  String get careTreeGrows => 'Papa & Mama のハートで育つ';

  @override
  String get careTreeNearBloom => 'もうすぐ花が咲く木へ 🌸';

  @override
  String get careTreeReward => 'ごほうび：アルバムの「桜」テーマ';

  @override
  String get careTreeMoments => '子育ての瞬間';

  @override
  String get careTreeTogether => '一緒に過ごした回数';

  @override
  String get careTreeBloomDays => '花が咲いた日数';

  @override
  String get careTreeYourContribution => 'あなたの貢献';

  @override
  String get careTreeToday => '今日';

  @override
  String get careTreeWeek => '今週';

  @override
  String get careTreeTotal => '合計';

  @override
  String memoriesSelectedPhotos(int count) {
    return '$count枚の写真を選択';
  }

  @override
  String get usOnlyTwo => 'ふたりだけに見える';

  @override
  String usMe(String callName) {
    return '$callName（あなた）';
  }

  @override
  String usEnergyValue(int value) {
    return '元気 $value/5';
  }

  @override
  String get usHugShort => 'ハグ';

  @override
  String get usDailyQuestionShort => '今日の質問';

  @override
  String get usBridgeShort => 'かけ橋';

  @override
  String get usWeekShort => 'ふたりの1週間';

  @override
  String get usCheckinTitle => '今日はどんな気分？';

  @override
  String get usEnergyShort => '元気';

  @override
  String get usNeedShort => '今ほしいのは…';

  @override
  String get usNeedRest => '休息';

  @override
  String get usNeedChildcare => '子どもを見てほしい';

  @override
  String get usNeedQuiet => '静かな時間';

  @override
  String get usNeedHug => 'ハグ';

  @override
  String get usNeedConversation => '話したい';

  @override
  String get usNeedEncouragement => '励まし';

  @override
  String get usOnlyMe => '自分だけ';

  @override
  String usSendTo(String callName) {
    return '$callName に送る';
  }

  @override
  String usRequestTo(String callName) {
    return '$callName にお願い';
  }

  @override
  String usRequestGentle(String callName) {
    return 'お願いは手伝いへの誘いです。$callName はいつでも「今日はできない」と言えます。';
  }

  @override
  String get usRequestOneThing => 'ひとつお願い';

  @override
  String get usRequestRest => '休みたい';

  @override
  String get usRequestWatchChild => '子どもを見る';

  @override
  String get usRequestRestHint => '子どもを見てほしい';

  @override
  String get usRequestWatchHint => 'しばらく';

  @override
  String get usRequestLibrary => 'ライブラリ';

  @override
  String get usRequestLibraryHint => 'タスクを選ぶ';

  @override
  String get usRequestCustom => '自分で書く';

  @override
  String get usRequestCustomHint => 'ほかのこと';

  @override
  String get usRequestDuration => 'どのくらい？';

  @override
  String get usRequestWhen => 'いつ？';

  @override
  String get usRequestWhichChild => 'どの子ども？';

  @override
  String usRequestMinutes(int minutes) {
    return '$minutes分';
  }

  @override
  String get usRequestNow => '今すぐ';

  @override
  String get usRequestTonight => '今夜';

  @override
  String get usRequestChooseTime => '時間を選ぶ';

  @override
  String get usRequestOtherChild => '二人とも';

  @override
  String get usRequestNeeds => 'または今ほしいのは…（ハートなし）';

  @override
  String usRequestSendCount(String callName, int count) {
    return '$callName に送る・未完了 $count/5';
  }

  @override
  String usRequestFrom(String callName) {
    return '$callName からのお願い';
  }

  @override
  String usRequestBy(String callName) {
    return '$callName からあなたへ';
  }

  @override
  String get usRequestSoon => '早めにお願い';

  @override
  String get usRequestAcceptedTitle => 'お願いを引き受けました';

  @override
  String get usRequestReasonHint => '今日はできない場合、理由を選択（任意）';

  @override
  String get usRequestReasonMeeting => '会議中';

  @override
  String get usRequestReasonLate => '帰りが遅くなる';

  @override
  String get usRequestAccept => '引き受ける・任せて';

  @override
  String get usRequestDecline => '今日はできない';

  @override
  String usRequestDeclineNote(String callName) {
    return '断ってもポイントは減りません。$callName にやさしく通知します。';
  }

  @override
  String usRequestSent(String callName) {
    return '$callName が送信';
  }

  @override
  String get usRequestViewed => '確認しました';

  @override
  String get usRequestAcceptedShort => '引き受けました';

  @override
  String get usRequestFinished => '完了';

  @override
  String get usRequestFinish => '完了 ✓';

  @override
  String get commonCreateNew => '新しく作る';

  @override
  String get switcherViewBy => '表示対象';

  @override
  String switcherPregnancy(int number, String name) {
    return '妊娠 #$number · $name';
  }

  @override
  String get switcherAllDescription => 'すべての子どもと家族の瞬間';

  @override
  String get familyManageChildren => '子どもの管理';

  @override
  String careWeekday(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      'mon': '月',
      'tue': '火',
      'wed': '水',
      'thu': '木',
      'fri': '金',
      'sat': '土',
      'other': '日',
    });
    return '$_temp0';
  }

  @override
  String get notificationsFamily => '家族';

  @override
  String get memoriesSaveQuote => '言葉を保存';

  @override
  String get pregnancyFirstPhoto => '赤ちゃんの最初の写真';

  @override
  String get pregnancyFirstPhotoHint => '任意・「誕生」の思い出に保存';

  @override
  String get pregnancyCompleteAnnounce => '完了してお知らせ';

  @override
  String pregnancyWelcomeName(String name) {
    return 'ようこそ、$name！';
  }

  @override
  String get pregnancyShort => '妊娠';

  @override
  String get memoriesPerspectiveshort => '視点';

  @override
  String get pregnancyBumpWeeks => '週ごとのお腹の写真';

  @override
  String pregnancyFirstsFor(String child) {
    return '$child の初めて';
  }

  @override
  String get pregnancyBabyLetter => '赤ちゃんへの手紙';

  @override
  String get pregnancyBumpPhoto => 'お腹の写真';

  @override
  String usRequestHearts(int count) {
    return '完了すると +$count 💗（自分だけに表示）';
  }

  @override
  String usRequestReminder(String time) {
    return '$timeに通知';
  }

  @override
  String get usRequestAcceptedBadge => '引き受け済み';

  @override
  String get pregnancyPrepareBaby => '赤ちゃんを迎える準備';

  @override
  String get commonAll => 'すべて';

  @override
  String pregnancyCaptureWeek(int week) {
    return '$week週のお腹の写真を撮る';
  }

  @override
  String get memoriesMarkMilestone => '記念日を記録';

  @override
  String get careMine => '私';

  @override
  String get careTogether => '二人で';

  @override
  String get careTodayShort => '今日';

  @override
  String get carePrivateContribution => '自分だけに表示';

  @override
  String usRequestRestTitle(int minutes, String child) {
    return '$minutes分休みたいので、$childを見てほしい';
  }

  @override
  String usRequestWatchTitle(int minutes, String child) {
    return '$childを$minutes分見てほしい';
  }

  @override
  String usRequestAllChildren(int count) {
    return '子ども$count人全員';
  }

  @override
  String usRequestMessagePreview(int minutes, String child) {
    return '「$minutes分くらい休みたいです。$childを見てもらえる？💛」';
  }

  @override
  String get quickCheckin => 'チェックイン';

  @override
  String get quickThanks => 'ありがとう';

  @override
  String get careFinish => '完了';

  @override
  String carePartnerTab(String callName) {
    return '$callNameの担当';
  }

  @override
  String get billingSupport => 'サポート';

  @override
  String get homeChildLetter => '赤ちゃんへの手紙';

  @override
  String commonAgeDays(int days) {
    return '$days日';
  }

  @override
  String commonAgeMonths(int months) {
    return '$monthsか月';
  }

  @override
  String commonAgeMonthsDays(int months, int days) {
    return '$monthsか月$days日';
  }

  @override
  String commonAgeYears(int years) {
    return '$years歳';
  }

  @override
  String commonAgeYearsMonths(int years, int months) {
    return '$years歳$monthsか月';
  }

  @override
  String commonPregnancyWeekOnly(int week) {
    return '$week週';
  }

  @override
  String commonPregnancyWeekDay(int week, int day) {
    return '$week週$day日';
  }

  @override
  String get commonScreenInProgress => 'この画面はデザインに合わせて作り直し中です。';

  @override
  String get stateOfflineTitle => 'オフラインです';

  @override
  String stateOfflineSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '保存済みのデータを表示中 · $count件の思い出がアップロード待ち',
      zero: '保存済みのデータを表示中',
    );
    return '$_temp0';
  }

  @override
  String get commonPlay => '再生';

  @override
  String get commonPause => '一時停止';

  @override
  String get commonMarkDone => '完了にする';

  @override
  String get commonNotifications => 'お知らせ';

  @override
  String get commonComingSoon => '近日公開';

  @override
  String commonQuoted(String text) {
    return '「$text」';
  }

  @override
  String get commonTimeJustNow => 'たった今';

  @override
  String commonTimeMinutesAgo(int count) {
    return '$count 分前';
  }

  @override
  String commonTimeHoursAgo(int count) {
    return '$count 時間前';
  }

  @override
  String get commonTimeYesterday => '昨日';

  @override
  String commonTimeDaysAgo(int count) {
    return '$count 日前';
  }

  @override
  String usMoodLabel(String mood) {
    String _temp0 = intl.Intl.selectLogic(mood, {
      'ok': 'いい感じ',
      'normal': 'ふつう',
      'tired': '疲れた',
      'exhausted': 'くたくた',
      'stressed': 'プレッシャー',
      'sad': '悲しい',
      'annoyed': 'イライラ',
      'overwhelmed': 'いっぱいいっぱい',
      'lonely': 'さみしい',
      'missYou': '会いたい',
      'other': 'いい感じ',
    });
    return '$_temp0';
  }

  @override
  String usCheckinNeed(String need) {
    String _temp0 = intl.Intl.selectLogic(need, {
      'rest': '休みたい',
      'childcare': '子守りを手伝ってほしい',
      'quiet': '静かにしたい',
      'hug': 'ハグしてほしい',
      'talk': '話したい',
      'encouragement': '励ましてほしい',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String usCheckinNeedMinutes(String need, int minutes) {
    return '$need $minutes分';
  }

  @override
  String get usMoodNotShared => 'まだ共有されていません';

  @override
  String usReplySent(String callName) {
    return '$callNameに送りました 💛';
  }

  @override
  String get usSettingsTooltip => 'Papa & Mama の設定';

  @override
  String usOpenRequestWatch(String callName, String child, int minutes) {
    return '$callNameに$childを$minutes分見てもらうようお願いしました';
  }

  @override
  String usOpenRequestMine(String callName, String title) {
    return '$callNameへのお願い：$title';
  }

  @override
  String usOpenRequestTheirs(String callName, String title) {
    return '$callNameからのお願い：$title';
  }

  @override
  String usRequestStatusPartner(String status, String callName, String time) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'seen': '$callNameが確認 · $time',
      'accepted': '$callNameが引き受けました · $time',
      'done': '$callNameが完了 · $time',
      'declined': '$callName：今日は無理',
      'other': '送信済み · $time',
    });
    return '$_temp0';
  }

  @override
  String usRequestStatusMine(String status, String time) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'accepted': '引き受けました · $time',
      'other': '返事待ち · $time',
    });
    return '$_temp0';
  }

  @override
  String get usDailyQuestionHintBoth => 'ふたりとも答えると、お互いの答えが見られます。';

  @override
  String get usDailyQuestionYourAnswer => 'あなたの答え';

  @override
  String usDailyQuestionAnswerBy(String callName, String answer) {
    return '$callName：$answer';
  }

  @override
  String usThanksByLine(String callName, String time) {
    return '$callName · $time';
  }

  @override
  String get usYou => 'あなた';

  @override
  String usRequestRestMessage(int minutes, String child) {
    return '$minutes分くらい休みたいな。$childを見ていてくれる？💛';
  }

  @override
  String usRequestWatchMessage(int minutes, String child) {
    return '$childを$minutes分くらい見ていてくれる？💛';
  }

  @override
  String usRequestReasonBusyWith(String child) {
    return '$childを見ているところ';
  }

  @override
  String usRequestYouAsked(String callName) {
    return '$callNameへのお願い';
  }

  @override
  String get usRequestMineTitle => 'あなたのお願い';

  @override
  String get usRequestYouSent => '送信しました';

  @override
  String usRequestPartnerViewed(String callName) {
    return '$callNameが確認しました';
  }

  @override
  String usRequestPartnerAccepted(String callName) {
    return '$callNameが引き受けました';
  }

  @override
  String usRequestBadge(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'sent': '送信済み',
      'seen': '既読',
      'accepted': '引き受け済み',
      'done': '完了',
      'declined': '今日は無理',
      'acknowledged': '確認済み',
      'expired': '期限切れ',
      'cancelled': '取り消し',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get usRequestCancel => 'お願いを取り消す';

  @override
  String get usRequestThank => 'ありがとうを送る';

  @override
  String get usRequestDoMyself => '自分でやる';

  @override
  String get usRequestSendHug => '🤗 を送る';

  @override
  String usThanksTitle(String callName) {
    return '$callNameにありがとう';
  }

  @override
  String get usThanksSamples => '例文';

  @override
  String get usThanksSample1 => '子どもを見ていてくれてありがとう 💛';

  @override
  String get usThanksSample2 => '今日そばにいてくれてありがとう';

  @override
  String get usThanksSample3 => 'あなたがいると、全部が軽くなる';

  @override
  String get usThanksSticker => 'スタンプ';

  @override
  String get usThanksPostFamily => '家族の思い出として投稿を提案';

  @override
  String usThanksPostFamilyHint(String callName) {
    return '$callNameの同意が必要です';
  }

  @override
  String usThanksSent(String callName) {
    return '$callNameにありがとうを送りました 💛';
  }

  @override
  String get careTreeBloomed => '今日はわが家みんなで心をこめてお世話できました 🌸';

  @override
  String careOpenRequestFromPartner(int count, String callName, String title) {
    return '進行中のお願い $count 件 · $callNameから：$title';
  }

  @override
  String careOpenRequestToPartner(int count, String callName, String title) {
    return '進行中のお願い $count 件 · $callNameへ：$title';
  }

  @override
  String get careMetaSuggested => '今日のおすすめ';

  @override
  String get careMetaCustom => '自分で追加';

  @override
  String careMetaHearts(int count) {
    return '+$count 💗';
  }

  @override
  String careMetaDoneAt(String time) {
    return '$time 完了';
  }

  @override
  String carePartnerDoneAt(String time) {
    return '$time に完了';
  }

  @override
  String careCategory(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'care': 'お世話',
      'bonding': 'ふれあい',
      'outing': 'おでかけ',
      'memory': '思い出',
      'support': 'パートナーを支える',
      'self': 'セルフケア',
      'together': '家族みんな',
      'couple': 'ふたり',
      'other': '自由入力',
    });
    return '$_temp0';
  }

  @override
  String careDurationMin(int minutes) {
    return '$minutes 分';
  }

  @override
  String carePartnerNote(String callName) {
    return '$callNameが終えたことだけ見られます。$callNameの Hearts は$callNameだけに表示されます。';
  }

  @override
  String carePartnerAllDone(String callName, int count) {
    return '$callNameは今日の $count 件をすべて終えました';
  }

  @override
  String get careThank => 'ありがとう';

  @override
  String get careThanked => 'お礼済み';

  @override
  String get careDoneTogether => 'いっしょに完了';

  @override
  String get careMineEmpty => '今日のあなたのタスクはまだありません';

  @override
  String carePartnerEmpty(String callName) {
    return '$callNameの今日のタスクはまだありません';
  }

  @override
  String get careTogetherEmpty => '今日のいっしょのタスクはまだありません';

  @override
  String careDoneSnack(String title) {
    return '「$title」完了';
  }

  @override
  String careSuggestFor(String name, String age) {
    return '$nameへのおすすめ · $age';
  }

  @override
  String get careSuggestToday => '今日のおすすめ';

  @override
  String careCompleteDesc(String title, int photoHearts) {
    return '$title · 今日の木に葉っぱが1枚 🍃（写真を残すと +$photoHearts 💗）';
  }

  @override
  String get careNoteHint => 'メモ（任意）…';

  @override
  String get careLibraryLink => 'ライブラリ';

  @override
  String get careLibraryTitle => 'タスクライブラリ';

  @override
  String get careTitleHint => '何をする？';

  @override
  String get careTomorrow => '明日';

  @override
  String careRepeatOption(String repeat) {
    String _temp0 = intl.Intl.selectLogic(repeat, {
      'daily': '毎日',
      'weekdays': '平日',
      'weekends': '週末',
      'other': '繰り返しなし',
    });
    return '$_temp0';
  }

  @override
  String careReminderOption(String reminder) {
    String _temp0 = intl.Intl.selectLogic(reminder, {
      'atTime': '時間どおりに通知',
      'before15': '15分前に通知',
      'before30': '30分前に通知',
      'before60': '60分前に通知',
      'other': '通知しない',
    });
    return '$_temp0';
  }

  @override
  String get careTimeAny => '時間指定なし';

  @override
  String careTreeNextLevel(String name) {
    return 'もうすぐ$name 🌸';
  }

  @override
  String careTreeRewardLabel(String reward) {
    return 'ごほうび：$reward';
  }

  @override
  String careTreePercent(int percent) {
    return '$percent%';
  }

  @override
  String get careTreeContributionTitle => 'あなたの貢献 🔒 あなただけに表示';

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
    return 'いっしょに · $day';
  }

  @override
  String get careYesterday => '昨日';

  @override
  String careWeekdayLong(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      'mon': '月曜日',
      'tue': '火曜日',
      'wed': '水曜日',
      'thu': '木曜日',
      'fri': '金曜日',
      'sat': '土曜日',
      'other': '日曜日',
    });
    return '$_temp0';
  }

  @override
  String get careDetailTitle => 'タスクの詳細';

  @override
  String get careComplete => '完了する';

  @override
  String get careOwnerLabel => '担当';

  @override
  String get careChildLabel => '対象';

  @override
  String get careTimeLabel => '時間';

  @override
  String get careMissionNotFound => 'このタスクは見つかりません';

  @override
  String get careSwapAction => '別のタスクに替える';

  @override
  String get commonJustNow => 'たった今';

  @override
  String commonMinutesAgo(int count) {
    return '$count分前';
  }

  @override
  String commonHoursAgo(int count) {
    return '$count時間前';
  }

  @override
  String commonDaysAgo(int count) {
    return '$count日前';
  }

  @override
  String famTrialSubtitle(int days, String date) {
    return '残り$days日 · $dateまで';
  }

  @override
  String famStorageUsage(String used, String total) {
    return '$used GB / $total GB';
  }

  @override
  String get famPlanHouse => 'Houseプラン';

  @override
  String get famPlanFamily => 'Familyプラン';

  @override
  String famPlanRenews(String date) {
    return '$dateに更新';
  }

  @override
  String get famRoleFather => 'パパ';

  @override
  String get famRoleMother => 'ママ';

  @override
  String famPregnancySubtitle(int week, String date) {
    return '妊娠$week週 · 予定日 $date';
  }

  @override
  String get famRelativePending => '参加待ち';

  @override
  String get famRelationOther => 'その他…';

  @override
  String famInviteSlots(int used, int max) {
    return 'Familyプラン · 親族枠 $used/$max 使用中';
  }

  @override
  String famPregnancyChild(String name) {
    return '$name（妊娠中）';
  }

  @override
  String get famPhotosPermissionHint => '「家族みんな」の公開範囲';

  @override
  String get famCommentPermissionHint => '孫にメッセージを送る';

  @override
  String get famPostPermissionHint => 'Papa/Mamaの承認後に表示';

  @override
  String get famInviteNote => '親族はPapa & Mamaのスペースや非公開の内容を見られません。';

  @override
  String famInviteShared(String callName, String link) {
    return '$callNameへの招待を作成しました：$link';
  }

  @override
  String subTrialLeft(int days) {
    return 'お試し残り$days日';
  }

  @override
  String subBuy(String plan, String price) {
    return '$planにアップグレード · $price';
  }

  @override
  String get subCurrentPlan => '現在のプラン';

  @override
  String subPurchased(String plan) {
    return '$planにアップグレードしました 🎉';
  }

  @override
  String get subRestoreNone => '復元できる購入はまだありません。';

  @override
  String subExpiredStats(int memories, int firsts, String names) {
    return '$namesの思い出$memories件と初めて$firsts件を保存しました。データはすべて安全です。アップグレードして家族で成長の記録を続けましょう。';
  }

  @override
  String subRetentionTitle(String date) {
    return 'データは$dateまで保管されます';
  }

  @override
  String get subExportStarted => 'データを準備しています。ダウンロードできるようになったらお知らせします。';

  @override
  String setProfileSubtitle(String callName, String family) {
    return '$callName · $family';
  }

  @override
  String setAiQuota(int remaining, int total) {
    return '$remaining/$total回';
  }

  @override
  String get setPlanTrial => 'お試し';

  @override
  String get setPlanExpired => '期限切れ';

  @override
  String setVersion(String version) {
    return 'v$version';
  }

  @override
  String setTextPreview(String name) {
    return '$nameが新しいマイルストーンを達成：ひとりでおすわり 🎉';
  }

  @override
  String cirHello(String callName) {
    return '$callName、こんにちは';
  }

  @override
  String cirTitle(String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': 'おばあちゃんの大切な孫',
      'grandpa': 'おじいちゃんの大切な孫',
      'other': '家族の大切な子どもたち',
    });
    return '$_temp0';
  }

  @override
  String cirHeroCaption(String text, String author, String time) {
    return '「$text」— $author、$time';
  }

  @override
  String cirLiked(String name) {
    return '$nameにハートを送りました 💛';
  }

  @override
  String cirWishHint(String name) {
    return '$nameへのメッセージを書く…';
  }

  @override
  String get cirWishSend => '送信';

  @override
  String cirWishSent(String name) {
    return '$nameにメッセージを送りました';
  }

  @override
  String cirEmpty(String callName) {
    return 'Papa & Mamaはまだ新しい写真を投稿していません。投稿されたら$callNameにお知らせします。';
  }

  @override
  String pregJourneyTitle(String child) {
    return '$childのマタニティ記録';
  }

  @override
  String pregJourneyStats(int days, int memories, int firsts) {
    return 'あと$days日 · 思い出$memories件 · はじめて$firsts件';
  }

  @override
  String get pregWeekThis => '今週';

  @override
  String get pregWeekFirsts => 'はじめて';

  @override
  String pregBumpGhostHint(int week) {
    return '$week週の写真をうっすら重ねて同じ角度で撮れます';
  }

  @override
  String pregWeekDayShort(int week, int day) {
    return '$week週+$day';
  }

  @override
  String pregPostedBy(String callName) {
    return '$callNameが投稿';
  }

  @override
  String pregUltrasoundWeek(int week) {
    return 'エコー · $week週';
  }

  @override
  String pregQuoted(String text) {
    return '「$text」';
  }

  @override
  String get pregFirstLabel => 'はじめて';

  @override
  String get pregMilestoneLater => '誕生後に赤ちゃんのマイルストーンになります';

  @override
  String get pregMenuEdit => '妊娠情報を編集';

  @override
  String get pregMenuArchive => 'アーカイブ';

  @override
  String pregBumpCompare(int from, int to) {
    return '比較 · $from週 → $to週';
  }

  @override
  String pregWeekShort(int week) {
    return '$week週';
  }

  @override
  String pregWeekCapture(int week) {
    return '$week週 · 撮影';
  }

  @override
  String get pregUltrasoundAdd => 'エコー写真を追加';

  @override
  String get pregUltrasoundEmpty => 'まだエコー写真がありません';

  @override
  String get pregUltrasoundEmptyHint => '妊娠週ごとにメッセージ付きで保存しましょう。';

  @override
  String pregDaysLeft(int days) {
    return 'あと$days日';
  }

  @override
  String get pregGroupBag => '出産準備バッグ';

  @override
  String get pregGroupPapers => '書類';

  @override
  String get pregGroupNursery => '赤ちゃんコーナー';

  @override
  String get pregGroupHealth => '健康';

  @override
  String pregOwnerRequested(String callName) {
    return '$callNameにお願い済み';
  }

  @override
  String pregOwnerAsk(String callName) {
    return '$callNameにお願い';
  }

  @override
  String get pregOwnerTitle => '誰が担当しますか？';

  @override
  String get pregBirthCountTitle => 'おめでとうございます！赤ちゃんは何人？';

  @override
  String pregBirthBabyCount(int count) {
    return '$count人';
  }

  @override
  String get pregBirthWelcomeTitle => 'ようこそ、わが家へ 🎉';

  @override
  String pregBirthBabyIndex(int index, int count) {
    return '$index/$count人目 · いつでも編集できます';
  }

  @override
  String pregBirthNameValue(String name, String nickname) {
    return '$name（$nickname）';
  }

  @override
  String get pregBirthWeightLabel => '体重（記録のみ）';

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
    return '$familyがお迎えします';
  }

  @override
  String pregBirthWelcomeName(String name) {
    return 'ようこそ、$name！💜';
  }

  @override
  String pregBirthNickname(String nickname) {
    return 'みんなの「$nickname」';
  }

  @override
  String pregBirthNicknameSiblings(String nickname, String siblings) {
    return 'みんなの「$nickname」 · $siblingsの弟妹';
  }

  @override
  String pregNamesAnd(String first, String last) {
    return '$firstと$last';
  }

  @override
  String pregBirthAnnounceNote(String child) {
    return '妊娠を共有している家族のみ。妊娠中の思い出は$childの最初の章になります。';
  }

  @override
  String get pregBirthDone => '完了してお知らせ 🎉';

  @override
  String pregArchiveTitle(String child) {
    return '$childの記録をアーカイブ';
  }

  @override
  String get pregNamesBothLike => 'ふたりともお気に入り 💞';

  @override
  String pregNamesAddedBy(String callName) {
    return '$callNameが追加';
  }

  @override
  String pregNamesLikeBy(String callName) {
    return '$callNameのお気に入り';
  }

  @override
  String get authNameHint => '名前を入力';

  @override
  String authResendIn(String time) {
    return '$time 後に再送信';
  }

  @override
  String authCountryCodeSemantics(String code) {
    return '国番号 $code';
  }

  @override
  String get authChangeAvatar => 'プロフィール写真を選ぶ';

  @override
  String onbFamilyDefaultName(String name) {
    return '$nameの家';
  }

  @override
  String onbMemberLabel(String callName, String name) {
    return '$callName $name';
  }

  @override
  String onbFamilyCoverWaiting(String member, String partnerCallName) {
    return '$member · $partnerCallNameを待っています';
  }

  @override
  String get onbFamilySuggestion1 => 'トマトの家';

  @override
  String get onbFamilySuggestion2 => '小さな巣';

  @override
  String get onbFamilySuggestion3 => 'わが家';

  @override
  String get onbChangeCover => 'カバーを変更';

  @override
  String onbInviteSubtitle(String callName) {
    return 'Baby Family にはパパとママの両方が必要です。$callNameが参加すると、3か月の無料体験が始まります。';
  }

  @override
  String onbInviteApproval(String callName) {
    return '$callNameの参加時に最終確認します';
  }

  @override
  String onbInviteShareMessage(String code, String link) {
    return 'Baby Family で一緒に子どもの成長を残そう！招待コード：$code · $link';
  }

  @override
  String onbWaitingSubtitle(String callName) {
    return '$callNameが招待を受けると、家族のスペースが開き、3か月の無料体験が始まります。';
  }

  @override
  String onbWaitingSentAt(String time) {
    return '$timeに招待を送信しました';
  }

  @override
  String onbWaitingOpened(String callName) {
    return '$callNameが招待リンクを開きました';
  }

  @override
  String onbWaitingExpires(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'あと$count日で期限切れ',
      zero: '今日で期限切れ',
    );
    return '$_temp0';
  }

  @override
  String get onbCancelFamilyMessage => '役割の選択に戻ります。送信した招待は無効になります。';

  @override
  String onbTrialUntil(String date) {
    return '$dateまで · カード登録不要';
  }

  @override
  String onbTrialAfter(String housePrice, String familyPrice) {
    return 'その後は House（$housePrice）または Family（$familyPrice）を選んで続けます。';
  }

  @override
  String onbStageSubtitle(String first, String second) {
    return '$firstと$secondはいつでも別の子どもや妊娠を追加できます。';
  }

  @override
  String get onbStageBothDescription => '子どものプロフィールと妊娠を同じ家族で並行して記録';

  @override
  String get onbNicknameIdea1 => 'まめ';

  @override
  String get onbNicknameIdea2 => 'トマト';

  @override
  String get onbNicknameIdea3 => 'ジャックフルーツ';

  @override
  String get onbNicknameIdea4 => 'リス';

  @override
  String onbMeetCountdown(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$nameに会えるまであと$count日',
      zero: '今日$nameに会えます',
    );
    return '$_temp0';
  }

  @override
  String get onbKnowDueDate => '予定日がわかる';

  @override
  String onbWeekValue(int week) {
    return '$week週';
  }

  @override
  String onbNotifMeta(String time) {
    return 'Baby Family · $time';
  }

  @override
  String get onbNotifNow => '今';

  @override
  String get onbNotif5Minutes => '5分前';

  @override
  String get onbNotif1Hour => '1時間前';

  @override
  String onbNotifRequestTitle(String sender, String receiver, String child) {
    return '$senderから$receiverへ：今夜$childをお風呂に';
  }

  @override
  String get onbNotifRequestBody => 'ワンタップで引き受けたり別の時間を提案したり。';

  @override
  String onbNotifPhotosTitle(String child) {
    return '今日の$childの新しい写真が3枚';
  }

  @override
  String get onbNotifPhotosBody => 'おばあちゃんが2枚にハートを送りました。';

  @override
  String get onbNotifUsTitle => 'Papa & Mama から新しいお知らせがあります';

  @override
  String get onbNotifUsBody => 'プライベートな内容はロック画面に表示されません。';

  @override
  String get onbNotifChildFallback => '赤ちゃん';

  @override
  String onbFirstMemorySubtitle(String name) {
    return '$nameの最初の瞬間を Baby Family に残しましょう。';
  }

  @override
  String invInviterParent(String name, String callName) {
    return '$name（$callName）があなたを招待しました';
  }

  @override
  String invInviterRelative(String name, String callName, String pronoun) {
    return '$name（$callName）が$pronounを孫の見守りに招待しました';
  }

  @override
  String invQuotedMessage(String message) {
    return '「$message」';
  }

  @override
  String invRoleParent(String callName) {
    return 'あなたの役割：子どもたちの$callName';
  }

  @override
  String invRoleRelative(String callName, String permission) {
    return '$callName · $permission';
  }

  @override
  String invPronoun(String relation) {
    String _temp0 = intl.Intl.selectLogic(relation, {
      'grandmaPaternal': 'おばあちゃん',
      'grandmaMaternal': 'おばあちゃん',
      'grandpaPaternal': 'おじいちゃん',
      'grandpaMaternal': 'おじいちゃん',
      'other': 'あなた',
    });
    return '$_temp0';
  }

  @override
  String invPronounTitle(String relation) {
    String _temp0 = intl.Intl.selectLogic(relation, {
      'grandmaPaternal': 'おばあちゃん',
      'grandmaMaternal': 'おばあちゃん',
      'grandpaPaternal': 'おじいちゃん',
      'grandpaMaternal': 'おじいちゃん',
      'other': 'あなた',
    });
    return '$_temp0';
  }

  @override
  String get invParentSees => '見られるもの：思い出、ミッション、Papa & Mama';

  @override
  String invParentManage(String callName) {
    return '$callNameと一緒に家族を管理し、親族を招待';
  }

  @override
  String invParentApproval(String member) {
    return '参加時に$memberが最終確認します';
  }

  @override
  String invRelativeSees(String pronoun, String names) {
    return '$pronounが見られるもの：$namesの写真・動画・はじめて';
  }

  @override
  String invRelativeHiddenChildren(String pronoun, String names) {
    return '$pronounが見られないもの：$names、Papa & Mama、ミッション';
  }

  @override
  String invRelativeHidden(String pronoun) {
    return '$pronounが見られないもの：Papa & Mama、ミッション';
  }

  @override
  String invRelativeApproval(String pronoun) {
    return '$pronounが投稿した写真はパパ・ママの承認後に表示されます';
  }

  @override
  String get invViewOnly => '閲覧のみ';

  @override
  String get homeMorning => 'おはようございます、';

  @override
  String get homeAfternoon => 'こんにちは、';

  @override
  String homeGreetingName(String callName, String name, String emoji) {
    return '$callName $name $emoji';
  }

  @override
  String get homeMonthlyToday => '今日';

  @override
  String homeMonthlyInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'あと$count日',
    );
    return '$_temp0';
  }

  @override
  String homeMonthlyTurns(String name, int months) {
    return '$name が$monthsか月に 🎉';
  }

  @override
  String homeMonthlyPrepare(int done, int total) {
    return '月齢フォトの準備 — $done/$total枚撮影済み';
  }

  @override
  String homeMoodTitle(String callName, String mood) {
    String _temp0 = intl.Intl.selectLogic(mood, {
      'ok': '元気です',
      'normal': 'ふつうです',
      'tired': '疲れています',
      'exhausted': 'くたくたです',
      'stressed': 'ストレスを感じています',
      'sad': '悲しい気分です',
      'annoyed': 'イライラしています',
      'overwhelmed': 'いっぱいいっぱいです',
      'lonely': 'さみしい気分です',
      'missYou': 'あなたに会いたい',
      'other': 'チェックインしました',
    });
    return '$callNameは$_temp0';
  }

  @override
  String homeNeedLabel(String need) {
    String _temp0 = intl.Intl.selectLogic(need, {
      'rest': '休みたい',
      'childcare': '子どもを見てほしい',
      'quiet': '静かな時間がほしい',
      'hug': 'ハグしてほしい',
      'talk': '話したい',
      'encouragement': '励ましてほしい',
      'other': 'サポートがほしい',
    });
    return '$_temp0';
  }

  @override
  String homeNeedMinutes(String need, int minutes) {
    return '$need（約$minutes分）';
  }

  @override
  String homeFamilyProgress(int done, int total) {
    return '家族のタスク $done/$total';
  }

  @override
  String homePromptKicker(String name, String age) {
    return '記録のヒント · $name $age';
  }

  @override
  String homeFeedAddedPhotos(String callName, int count, String name) {
    return '$callName が $name の写真を$count枚追加しました';
  }

  @override
  String homeMorePhotos(int count) {
    return '+$count';
  }

  @override
  String homeRecordedBy(String callName, String time) {
    return '$callName が$time記録';
  }

  @override
  String homeReactedBy(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$name ほか$count人',
      zero: '$name',
    );
    return '$_temp0';
  }

  @override
  String homePostedBy(String callName) {
    return '$callName が投稿';
  }

  @override
  String homePerspectiveQuote(String callName, String text) {
    return '$callName：「$text」';
  }

  @override
  String homeTreeProgress(String name, int percent, String next) {
    return '$name · $nextまで $percent% 🌸';
  }

  @override
  String homeChildBorn(String age, String date) {
    return '$age · $date 生まれ';
  }

  @override
  String homeChildBornLunar(String age, String date, int day, int month) {
    return '$age · $date 生まれ（旧暦$month/$day）';
  }

  @override
  String homeChildCountdown(int count, int months) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$monthsか月まであと$count日',
      zero: '今日で$monthsか月',
    );
    return '$_temp0';
  }

  @override
  String homeMonthlySlot(int month) {
    return '$monthか月フォト';
  }

  @override
  String homeChapterTitle(int month, String name) {
    return '$nameの$monthか月目';
  }

  @override
  String homeChapterStats(int memories, int firsts, int voices) {
    return '思い出$memories件 · はじめて$firsts件 · 録音$voices件';
  }

  @override
  String get homeMonthlyGrowth => '月ごとの成長';

  @override
  String homeTrimester(int number) {
    return '妊娠第$number期';
  }

  @override
  String homeDaysToMeet(int count, String name) {
    return '$nameに会えるまであと$count日 💜';
  }

  @override
  String homeDueDate(String date) {
    return '出産予定日 $date';
  }

  @override
  String homeFetalSize(String name, String fruit, int cm) {
    return '今週の$nameは$fruitくらい · 約${cm}cm';
  }

  @override
  String get homeReference => '目安';

  @override
  String get homeCapture => '撮影';

  @override
  String homeWeekShort(int week) {
    return '$week週';
  }

  @override
  String homeBothTellWeek(int week) {
    return 'ふたりで語る · $week週';
  }

  @override
  String homeProgressCount(int done, int total) {
    return '$done/$total';
  }

  @override
  String homeNamesSummary(int count, int liked) {
    return '名前の候補$count件 · ふたりともお気に入り$liked件 💞';
  }

  @override
  String switcherPregnancyLabel(String name, int week) {
    return '$name · $week週';
  }

  @override
  String get commonLastNight => '昨夜';

  @override
  String get commonYesterdayLower => '昨日';

  @override
  String commonDotJoin(String first, String second) {
    return '$first · $second';
  }

  @override
  String commonNamesAnd(String first, String second) {
    return '$firstと$second';
  }

  @override
  String commonMissionCategory(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'care': 'お世話',
      'bonding': 'ふれあい',
      'outing': 'おでかけ',
      'memory': '思い出',
      'support': 'サポート',
      'self': 'セルフケア',
      'together': 'いっしょに',
      'couple': 'ふたり',
      'custom': 'カスタム',
      'other': 'タスク',
    });
    return '$_temp0';
  }

  @override
  String get commonSuggestedToday => '今日のおすすめ';

  @override
  String commonHeartsPlus(int count) {
    return '+$count 💗';
  }

  @override
  String get memJustNow => 'たった今';

  @override
  String memMinutesAgo(int count) {
    return '$count分前';
  }

  @override
  String memHoursAgo(int count) {
    return '$count時間前';
  }

  @override
  String get memYesterday => '昨日';

  @override
  String get memTodayLower => '今日';

  @override
  String memTodayAt(String time) {
    return '今日 $time';
  }

  @override
  String memYesterdayAt(String time) {
    return '昨日 $time';
  }

  @override
  String memDateAt(String date, String time) {
    return '$date $time';
  }

  @override
  String get memSearch => '思い出を検索';

  @override
  String get memFilterVoice => '録音';

  @override
  String memChildStats(int memories, int firsts, int voices) {
    return '思い出 $memories · 初めて $firsts · 録音 $voices';
  }

  @override
  String memChapterRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String memChapterCurrent(String range) {
    return '$range · 進行中';
  }

  @override
  String memChapterTitle(int month, String name) {
    return '$nameの$monthか月目';
  }

  @override
  String memChapterStats(int memories, int firsts, int voices) {
    return '思い出 $memories · 初めて $firsts · 録音 $voices';
  }

  @override
  String memChapterStatsMonthly(int memories, int firsts) {
    return '思い出 $memories · 初めて $firsts · 月フォト ✓';
  }

  @override
  String get memChapterReplay => 'この月を振り返る';

  @override
  String memDueIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'あと$days日',
      one: '明日',
      zero: '今日',
    );
    return '$_temp0';
  }

  @override
  String memMonthlyNextIn(int days, int month) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$monthか月 · あと$days日',
      one: '$monthか月 · 明日',
      zero: '$monthか月 · 今日',
    );
    return '$_temp0';
  }

  @override
  String memCardMeta(String children, String author, String time) {
    return '$children · $authorが投稿 · $time';
  }

  @override
  String memBothTellPreview(String callName, String text) {
    return '$callName：「$text」';
  }

  @override
  String memQuotedBy(String body, String author) {
    return '「$body」· $author';
  }

  @override
  String get memFirstTime => 'はじめて';

  @override
  String memFirstMeta(String age, String who) {
    return '$age · $who';
  }

  @override
  String memBothParentsTell(String first, String second) {
    return '$firstと$secondが一緒に語る';
  }

  @override
  String memAuthorTells(String callName) {
    return '$callNameが語る';
  }

  @override
  String memQuoteMeta(String name, String age, String callName, String when) {
    return '$name · $age · $callNameが$when記録';
  }

  @override
  String memLetterSealed(String date) {
    return '$dateまで封印';
  }

  @override
  String memCollMonthly(String name, int count, int total) {
    return '$name · $count/$total枚';
  }

  @override
  String memCollFirsts(int count) {
    return 'マイルストーン $count';
  }

  @override
  String memCollQuotes(String name, int count) {
    return '$name · $count件';
  }

  @override
  String memCollVoices(int count) {
    return '録音 $count件';
  }

  @override
  String memCollLetters(int count, int sealed) {
    return '手紙 $count通 · 封印 $sealed';
  }

  @override
  String memCollBest(int count) {
    return 'ふたりのお気に入り · $count';
  }

  @override
  String memCollKeepsakes(int count) {
    return '$count点';
  }

  @override
  String get memComposerDiary => '日記を書く';

  @override
  String get memComposerMilestone => 'マイルストーンを記録';

  @override
  String get memComposerVoice => '新しい録音';

  @override
  String get memComposerKeepsake => '新しい記念の品';

  @override
  String memComposerMonthly(int month, String name) {
    return '$monthか月フォト · $name';
  }

  @override
  String memAudienceRelatives(int count) {
    return '家族 · 親族$count人';
  }

  @override
  String memAudiencePeople(int count) {
    return '家族 · $count人';
  }

  @override
  String get memChooseMilestone => 'マイルストーンを選ぶ';

  @override
  String get memDiaryTitleHint => '日記のタイトル';

  @override
  String get memDiaryBodyHint => '今日の家族はどうだった？';

  @override
  String get memLetterTo => '宛先';

  @override
  String get memLetterBodyHint => '大好きなあなたへ、伝えたいことがあります…';

  @override
  String get memLetterOpenDate => '開封日';

  @override
  String get memLetterOpenNone => 'なし';

  @override
  String get memVoiceTapToRecord => 'タップして録音';

  @override
  String memVoiceRecorded(String duration) {
    return '録音済み · $duration';
  }

  @override
  String get memKeepsakeTitleHint => '記念の品の名前';

  @override
  String get memKeepsakeHint => 'この品の物語…';

  @override
  String get memVisibilityFamilyTag => '👨‍👩‍👧‍👦 家族';

  @override
  String get memVisibilityParentsTag => '👫 パパとママだけ';

  @override
  String get memVisibilityOnlyMeTag => '🔒 自分だけ';

  @override
  String memSecondPerspective(String time) {
    return 'もうひとつの視点 · $time';
  }

  @override
  String memCommentsCount(int count) {
    return 'コメント（$count）';
  }

  @override
  String get memMenuFavorite => 'お気に入り';

  @override
  String get memMenuUnfavorite => 'お気に入りを解除';

  @override
  String get memEditPerspective => 'あなたの視点を編集';

  @override
  String get memMoreActions => 'その他の操作';

  @override
  String get memPregnancyAlbum => '妊娠期';

  @override
  String memMonthCell(int month) {
    return '$monthか月';
  }

  @override
  String memGhostToggle(int month, int percent) {
    return '$monthか月のゴースト · $percent%';
  }

  @override
  String get memStickerNone => 'なし';

  @override
  String get memFlipCamera => 'カメラ切替';

  @override
  String get memBrightness => '明るさ';

  @override
  String memQuoteAge(String name, String age, String when) {
    return '— $name、$age · $when';
  }

  @override
  String get memQuoteContextLabel => 'いつ言った？（任意）';

  @override
  String get memQuoteContextHint => '夕方の散歩で空を見上げて';

  @override
  String memOriginalTag(String callName, String when) {
    return '$callNameが語る · $when';
  }

  @override
  String memInheritedAudience(String audience) {
    return '元の思い出と同じ閲覧者：$audience';
  }

  @override
  String memStoryMeta(String callName, String time, int index, int total) {
    return '$callNameが投稿 · $time · $index/$total';
  }

  @override
  String memStoryReply(String callName) {
    return '$callNameに返信…';
  }

  @override
  String get memFirstsTitle => '初めての瞬間';

  @override
  String get memFirstsHideMissing => '未記録を隠す';

  @override
  String get memFirstsAdd => 'タップして記録';

  @override
  String get homeOpenFamily => 'わが家';

  @override
  String get homeChangeCover => 'カバーを変更';

  @override
  String get authCodeResent => 'コードを再送信しました';

  @override
  String commonLunarYear(String stem, String branch) {
    String _temp0 = intl.Intl.selectLogic(stem, {
      '0': '甲',
      '1': '乙',
      '2': '丙',
      '3': '丁',
      '4': '戊',
      '5': '己',
      '6': '庚',
      '7': '辛',
      '8': '壬',
      '9': '癸',
      'other': '',
    });
    String _temp1 = intl.Intl.selectLogic(branch, {
      '0': '子',
      '1': '丑',
      '2': '寅',
      '3': '卯',
      '4': '辰',
      '5': '巳',
      '6': '午',
      '7': '未',
      '8': '申',
      '9': '酉',
      '10': '戌',
      '11': '亥',
      'other': '',
    });
    return '$_temp0$_temp1';
  }

  @override
  String commonLunarDate(int day, int month) {
    return '旧暦$month月$day日';
  }

  @override
  String commonAgeDaysOld(int days) {
    return '生後$days日';
  }

  @override
  String commonAgeWeeks(int weeks) {
    return '$weeks週';
  }

  @override
  String commonAgeWeeksDays(int weeks, int days) {
    return '$weeks週$days日';
  }

  @override
  String get memAlbumDetailTitle => 'アルバムの詳細';

  @override
  String get memPhotoViewerTitle => '写真を見る';

  @override
  String get memSearchTitle => '検索';

  @override
  String get memOnThisDayTitle => 'あの日の思い出';

  @override
  String get recapWeekTitle => 'わが家の一週間';

  @override
  String get calendarTitle => 'カレンダー';

  @override
  String get calendarCreateEvent => '予定を作成';

  @override
  String get careHistoryTitle => '履歴';

  @override
  String get careBadgesTitle => 'わが家のバッジ';

  @override
  String get careSettingsTitle => 'ミッション設定';

  @override
  String get childProfileTitle => '子どものプロフィール';

  @override
  String get childEditTitle => 'プロフィールを編集';

  @override
  String get childAddTitle => '子どもを追加';

  @override
  String get familyRelativeDetailTitle => '家族の詳細';

  @override
  String get familySettingsTitle => '家族の設定';

  @override
  String get settingsProfileTitle => 'プロフィール';

  @override
  String memoriesYearOrdinal(String year) {
    String _temp0 = intl.Intl.selectLogic(year, {
      '1': '1年目',
      '2': '2年目',
      '3': '3年目',
      'other': '$year年目',
    });
    return '$_temp0';
  }

  @override
  String careWeekdayTitle(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      'mon': '月曜日',
      'tue': '火曜日',
      'wed': '水曜日',
      'thu': '木曜日',
      'fri': '金曜日',
      'sat': '土曜日',
      'other': '日曜日',
    });
    return '$_temp0';
  }

  @override
  String calendarDayTitle(String weekday, String date) {
    return '$weekday、$date';
  }

  @override
  String calendarMonthYear(String month, String year) {
    return '$year年$month月';
  }

  @override
  String get calendarModeWeek => '週';

  @override
  String get calendarModeMonth => '月';

  @override
  String get calendarLegendMission => 'タスク';

  @override
  String get calendarLegendEvent => '予定';

  @override
  String get calendarLegendCouple => 'ふたり';

  @override
  String get calendarLunar => '旧暦';

  @override
  String calendarLunarShort(String day, String month) {
    return '$month/$day';
  }

  @override
  String get calendarToday => '今日';

  @override
  String calendarItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件',
    );
    return '$_temp0';
  }

  @override
  String get calendarAllDay => '終日';

  @override
  String calendarKindLabel(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'family': '家族の予定',
      'child': '子どもの予定',
      'couple': 'ふたりの約束',
      'anniversary': '記念日',
      'health': '健診・予防接種',
      'other': 'タスク',
    });
    return '$_temp0';
  }

  @override
  String calendarOwnerLabel(String owner, String callName) {
    String _temp0 = intl.Intl.selectLogic(owner, {
      'me': '自分',
      'together': 'いっしょに',
      'other': '$callName',
    });
    return '$_temp0';
  }

  @override
  String get calendarCoupleOnly => 'ふたりだけに表示';

  @override
  String get calendarEmptyDay => 'この日はまだ予定がありません。予定やタスクを追加しますか？';

  @override
  String get calendarAddEvent => '予定';

  @override
  String get calendarAddMission => 'タスク';

  @override
  String get calendarAddMenu => 'カレンダーに追加';

  @override
  String get calendarPrevMonth => '前の月';

  @override
  String get calendarNextMonth => '次の月';

  @override
  String get calendarEventType => '予定の種類';

  @override
  String calendarEventKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'child': '子ども',
      'family': '家族',
      'couple': 'ふたり',
      'anniversary': '記念日',
      'other': '健診・予防接種',
    });
    return '$_temp0';
  }

  @override
  String get calendarEventTypeHint =>
      'パパとママには常に表示されます。親族には「家族を招待」を選んだときだけ表示されます。';

  @override
  String get calendarDate => '日付';

  @override
  String get calendarUseLunar => '旧暦の日付を使う';

  @override
  String calendarLunarDayName(String day, String month) {
    String _temp0 = intl.Intl.selectLogic(day, {
      '15': '旧暦$month月十五夜',
      'other': '旧暦$month月$day日',
    });
    return '$_temp0';
  }

  @override
  String calendarThisYear(String date) {
    return '今年：$date';
  }

  @override
  String get calendarRepeatYearly => '毎年くり返す';

  @override
  String get calendarRepeatByLunar => '旧暦の日付で';

  @override
  String get calendarRepeatBySolar => '新暦の日付で';

  @override
  String get calendarTime => '時間';

  @override
  String get calendarRelatedChildren => '関係する子ども（任意）';

  @override
  String get calendarParticipants => '参加者';

  @override
  String get calendarInviteFamily => '家族を招待';

  @override
  String get calendarFamilyPlanTag => 'ファミリープラン';

  @override
  String get calendarInviteFamilyHint => '祖父母や親族もこの予定を見られます';

  @override
  String get calendarReminders => 'リマインダー';

  @override
  String calendarReminder(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'dayBefore0900': '前日 9:00',
      'morning': '当日の朝',
      'atTime': '時間ちょうど',
      'hourBefore': '1時間前',
      'other': '1週間前',
    });
    return '$_temp0';
  }

  @override
  String get calendarAddReminder => '追加';

  @override
  String get calendarNote => 'メモ';

  @override
  String get calendarNoteHint => 'メモを追加…';

  @override
  String get calendarSaveEvent => '予定を保存';

  @override
  String get calendarEventSaved => '予定を保存しました';

  @override
  String get careHistoryAll => 'すべて';

  @override
  String get careHistoryCategory => '種類';

  @override
  String get careHistoryLegendMine => '自分';

  @override
  String careHistoryLegendPartner(String callName) {
    return '$callName（完了）';
  }

  @override
  String careHistoryToday(String date) {
    return '今日 · $date';
  }

  @override
  String careHistoryYesterday(String date) {
    return '昨日 · $date';
  }

  @override
  String careHistoryDate(String weekday, String date) {
    return '$weekday $date';
  }

  @override
  String careHistoryLunar(String day, String month) {
    return '旧暦$month/$day';
  }

  @override
  String careHistoryPartnerDone(String callName) {
    return '$callName · 完了';
  }

  @override
  String careHistoryTogetherDone(String couple, String time) {
    String _temp0 = intl.Intl.selectLogic(couple, {
      'yes': 'ふたり',
      'other': 'いっしょに',
    });
    return '$_temp0 · $time 完了';
  }

  @override
  String get careHistoryMissed => 'できなかった';

  @override
  String careHistoryNote(String callName) {
    return 'ハートは自分のタスクにだけ表示されます。$callNameのタスクは完了したものだけ表示されます。';
  }

  @override
  String get careHistoryEmpty => '履歴にタスクはまだありません';

  @override
  String careCategoryName(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'care': 'お世話',
      'bonding': 'ふれあい',
      'play': '遊び',
      'outing': 'おでかけ',
      'memory': '思い出づくり',
      'support': 'パートナーを支える',
      'self': 'セルフケア',
      'chores': '赤ちゃんの家事',
      'other': 'その他',
    });
    return '$_temp0';
  }

  @override
  String get careBadgesSubtitle => '家族みんなで続けている素敵な習慣の記録。比べたり、点数をつけたりはしません。';

  @override
  String careBadgesUnlocked(int done, int total) {
    return '$done / $total 個のバッジを獲得';
  }

  @override
  String careBadgesLatest(String title, String date) {
    return '最新：$title · $date';
  }

  @override
  String get careBadgesEarned => '獲得済み';

  @override
  String get careBadgesUpcoming => 'もうすぐ';

  @override
  String careBadgeAchievedOn(String date) {
    return '$date 獲得';
  }

  @override
  String get careSettingsLevelSection => '家族の毎日のタスク量';

  @override
  String careSettingsLevel(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      'light': '少なめ',
      'medium': 'ふつう',
      'other': '多め',
    });
    return '$_temp0';
  }

  @override
  String get careSettingsPerPerson => '件 / 人';

  @override
  String careSettingsTogether(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      'light': 'いっしょに 0〜1 件',
      'other': 'いっしょに 1 件',
    });
    return '$_temp0';
  }

  @override
  String get careSettingsDefault => '標準';

  @override
  String careSettingsLevelNote(String partner, String me) {
    return '$partnerと$meの両方に適用され、ふたりのボードは常に同じ量です。変更すると$partnerにやさしい通知が届きます。';
  }

  @override
  String get careSettingsCategoriesSection => '受け取りたいタスクの種類';

  @override
  String get careSettingsCategoriesHint =>
      '一部をオフにしても、残りの種類から同じ数のタスクが届きます。あなたのボードにだけ適用されます。';

  @override
  String get careSettingsTimingSection => '時間とリマインダー';

  @override
  String get careSettingsBoardTime => 'タスクボードが届く時間';

  @override
  String careSettingsBoardTimeHint(int count) {
    return '通知「今日は小さなタスクが $count 件…」';
  }

  @override
  String careSettingsAskAtNight(String time) {
    return '$time に確認';
  }

  @override
  String get careSettingsAskAtNightHint => '自分で追加した未完了タスクを明日に移しますか？';

  @override
  String get careSettingsDefaultReminder => '標準のリマインダー';

  @override
  String get careSettingsDefaultReminderHint => '時間を決めたタスク用';

  @override
  String careReminderShort(String reminder) {
    String _temp0 = intl.Intl.selectLogic(reminder, {
      'atTime': '時間ちょうど',
      'before15': '15分前',
      'before30': '30分前',
      'before60': '1時間前',
      'other': 'なし',
    });
    return '$_temp0';
  }

  @override
  String famPlanPaidSubtitle(String price, String date) {
    return '$price · $date に更新';
  }

  @override
  String get famManagePlan => 'プランを管理';

  @override
  String famInviteRelativeCount(int used, int max) {
    return '家族を招待（$used/$max）';
  }

  @override
  String famRelativeFollows(String relation, String children) {
    return '$relation · $children をフォロー';
  }

  @override
  String famRelativeFollowsNone(String relation) {
    return '$relation · まだフォローなし';
  }

  @override
  String famRelationMotherOf(String callName) {
    return '$callNameの母';
  }

  @override
  String famRelationFatherOf(String callName) {
    return '$callNameの父';
  }

  @override
  String get famRelationNanny => 'ベビーシッター';

  @override
  String get famPermSummaryView => '閲覧';

  @override
  String get famPermSummaryComment => '閲覧、コメント';

  @override
  String get famPermSummaryDownload => '写真の保存可';

  @override
  String get famPermSummaryContribute => '写真の投稿可';

  @override
  String famRelativeSince(String relation, String date) {
    return '関係：$relation · $date に参加';
  }

  @override
  String famRelativeActive(String time) {
    return '$timeにアクティブ';
  }

  @override
  String get famDisplayName => '表示名';

  @override
  String get famSignIn => 'ログイン';

  @override
  String famSignInPhone(String phone) {
    return '電話 $phone';
  }

  @override
  String get famPostedMemories => '投稿した思い出';

  @override
  String famMemoryCount(int count) {
    return '$count 件の思い出';
  }

  @override
  String get famPermByChild => '子どもごとの権限';

  @override
  String get famPermHide => '一時非表示';

  @override
  String get famPermLevelView => '閲覧';

  @override
  String get famPermLevelComment => 'コメント';

  @override
  String get famPermLevelContribute => '投稿';

  @override
  String famPregnancyWeekShort(int week) {
    return '妊娠 · $week週';
  }

  @override
  String get famNotShared => '未共有';

  @override
  String get famPermHidden => '一時非表示中';

  @override
  String get famShare => '共有';

  @override
  String get famAllowDownload => '端末への写真保存を許可';

  @override
  String famAllowDownloadOff(String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': 'おばあちゃん',
      'grandpa': 'おじいちゃん',
      'other': '家族',
    });
    return 'オフ — $_temp0はアプリ内で見るだけで保存できません';
  }

  @override
  String famAllowDownloadOn(String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': 'おばあちゃん',
      'grandpa': 'おじいちゃん',
      'other': '家族',
    });
    return 'オン — $_temp0は写真を保存できます';
  }

  @override
  String famMuteFrom(String callName) {
    return '$callNameからの通知をオフ';
  }

  @override
  String famMuteHint(String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': 'おばあちゃん',
      'grandpa': 'おじいちゃん',
      'other': '家族',
    });
    return '$_temp0はこれまで通り閲覧・コメントできます';
  }

  @override
  String famRelativeNote(String callName) {
    return '$callNameは Papa & Mama、ミッション、お願い、Hearts を見ることはありません。';
  }

  @override
  String get famPauseView => '閲覧を一時停止';

  @override
  String get famResumeView => '閲覧を再開';

  @override
  String get famReport => '報告';

  @override
  String get famRemoveRelative => '家族から外す';

  @override
  String famRemoveTitle(String callName) {
    return '$callNameを家族から外しますか？';
  }

  @override
  String famRemoveSummary(String callName, int count) {
    return '$callNameは $count 件の思い出を投稿しました。今後は子どもたちを見られなくなります。';
  }

  @override
  String get famRemoveKeepPosts => '投稿した思い出を残す';

  @override
  String get famRemoveKeepPostsHint => '家族の思い出に残ります';

  @override
  String get famRemoveDeletePosts => 'これらの思い出も削除';

  @override
  String famRemoved(String callName) {
    return '$callNameを家族から外しました';
  }

  @override
  String get famSettingsChangeCover => 'カバーを変更';

  @override
  String get famSettingsName => '家族の名前';

  @override
  String get famSettingsMemoriesSection => '思い出と家族';

  @override
  String get famSettingsDefaultVisibility => '新しい思い出の公開範囲';

  @override
  String get famSettingsDefaultVisibilityHint => '投稿したばかりの思い出の既定';

  @override
  String get famSettingsApprove => '家族が投稿した写真を確認';

  @override
  String get famSettingsApproveHint => '祖父母の写真は Papa/Mama の承認後に表示';

  @override
  String get famSettingsTree => '家族がファミリーツリーを見られる';

  @override
  String get famSettingsMilestones => 'マイルストーンの提案';

  @override
  String get famSettingsMilestonesHint => '子どもたちの大切な「はじめて」をお知らせ';

  @override
  String get famSettingsDatesSection => '日付と言語';

  @override
  String get famSettingsTimezone => '家族のタイムゾーン';

  @override
  String get famSettingsLunar => '旧暦を表示';

  @override
  String get famSettingsMilestonesBy => 'お食い初め・1歳の祝いの基準';

  @override
  String get famSettingsLunarCalendar => '旧暦';

  @override
  String get famSettingsSolarCalendar => '新暦';

  @override
  String get famSettingsContentLanguage => '提案コンテンツの言語';

  @override
  String get famDeleteFamily => '家族を削除';

  @override
  String get famDeleteFamilyHint => '慎重な確認が必要 · 30日以内なら復元可';

  @override
  String get setProfileChangeAvatar => 'プロフィール写真を変更';

  @override
  String get setProfileName => 'あなたの名前';

  @override
  String get setProfileCallName => '家族での呼び名';

  @override
  String setProfileCallNameHint(String callName) {
    return '子どもや家族にはあなたが「$callName」と表示されます。';
  }

  @override
  String get setSignInSection => 'ログイン方法';

  @override
  String get setSignInApple => 'Apple';

  @override
  String get setSignInGoogle => 'Google';

  @override
  String get setNotLinked => '未連携';

  @override
  String get setUnlink => '連携解除';

  @override
  String get setLink => '連携';

  @override
  String get setSignInHint => 'アカウントを失わないよう、ログイン方法を最低1つ残してください。';

  @override
  String get setTimezoneSection => 'タイムゾーン';

  @override
  String get setAutoTimezone => '端末に合わせて自動';

  @override
  String get setAutoTimezoneHint => 'ミッションやお願いの通知を今いる場所の時刻で';

  @override
  String get setPersonalTimezone => '個人のタイムゾーン';

  @override
  String get setSaveChanges => '変更を保存';

  @override
  String get setChangesSaved => '変更を保存しました';

  @override
  String get setNotifGroupsSection => '通知グループ';

  @override
  String get setQuietSection => 'おやすみ時間とロック画面';

  @override
  String get setQuietHours => 'おやすみ時間';

  @override
  String get setQuietHoursHint => '通知はまとめて後で届きます';

  @override
  String get setFrom => '開始';

  @override
  String get setTo => '終了';

  @override
  String setUrgentBypass(String callName) {
    return '$callNameのお願いはおやすみ時間でも通知';
  }

  @override
  String setUrgentBypassOff(String time) {
    return 'オフ — 「早めに」のお願いも $time 以降に届きます';
  }

  @override
  String get setUrgentBypassOn => 'オン — 「早めに」のお願いはすぐに通知';

  @override
  String get setHideLockScreen => 'ロック画面で内容を隠す';

  @override
  String get setHideLockScreenHint => '表示：「Papa & Mama から新しいお知らせがあります」';

  @override
  String get setRelativesSection => '家族';

  @override
  String get setDigestTime => 'ダイジェストの送信時刻';

  @override
  String get setMutePeople => '人ごとに通知をオフ';

  @override
  String setPeopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 人',
      zero: 'なし',
    );
    return '$_temp0';
  }

  @override
  String get setVisOnlyMeHint => '下書きや自分だけのもの';

  @override
  String get setVisParents => 'Papa & Mama';

  @override
  String get setVisParentsHint => 'Papa と Mama だけ';

  @override
  String get setVisFamilyHint => 'Papa、Mama と、その子を共有している家族';

  @override
  String get setVisibilityHint => '一般公開はありません。思い出ごとの公開範囲はいつでも変更できます。';

  @override
  String get setDashboardSection => '権限ダッシュボード';

  @override
  String get setWhoSees => '誰がどの子を見ているか';

  @override
  String setRelativeCount(int count) {
    return '家族 $count 人';
  }

  @override
  String get setStatDownload => '写真の保存可';

  @override
  String get setStatPost => '写真の投稿可';

  @override
  String get setStatFamilyMemories => '「家族みんな」の思い出';

  @override
  String get setStatMemoriesUnit => '件';

  @override
  String get setStatDevices => 'ログイン中の端末';

  @override
  String get setStatDevicesUnit => '台';

  @override
  String get setStatAi => 'オンの AI';

  @override
  String get setStatAiUnit => '機能';

  @override
  String get setOpenPermissions => '詳細を見て権限を編集';

  @override
  String get setPrivacyNote =>
      'Papa & Mama、ミッション、お願い、Hearts はいつもふたりだけのもの。家族には見えません。';

  @override
  String get setBlocked => 'ブロック中の人';

  @override
  String get setAppLockSection => 'アプリロック';

  @override
  String get setFaceIdLock => 'Face ID でロック';

  @override
  String get setFaceIdLockHint => 'Baby Family を開くには Face ID が必要';

  @override
  String get setBackupPin => '予備の PIN';

  @override
  String get setPinSet => '設定済み';

  @override
  String get setPinNotSet => '未設定';

  @override
  String get setPinHint => 'Face ID が認識しないときは 6 桁の PIN で開けます。';

  @override
  String get setDevicesSection => 'ログイン中の端末';

  @override
  String setDeviceInUse(String location) {
    return '$location · 使用中';
  }

  @override
  String setDeviceLastActive(String location, String time) {
    return '$location · $time';
  }

  @override
  String get setThisDevice => 'この端末';

  @override
  String get setSignOutAll => 'すべての端末からログアウト';

  @override
  String get setSignOutAllHint => 'この端末を含むすべての端末で再ログインが必要です。思い出とデータはそのまま残ります。';

  @override
  String setDeviceSignedOut(String device) {
    return '$device からログアウトしました';
  }

  @override
  String get setDataSubtitle => '家族の思い出はいつも家族のもの。いつでもダウンロードできます。';

  @override
  String get setExportSection => 'データの書き出し';

  @override
  String get setExportPersonal => '個人データ';

  @override
  String get setExportPersonalWho => 'すべてのメンバー';

  @override
  String get setExportPersonalDesc =>
      'あなたが作ったもの：投稿した思い出、プライベート日記、気分、送受信したありがとう。';

  @override
  String get setExportFamily => '家族データ';

  @override
  String get setExportFamilyDesc =>
      'ZIP ファイル：元の写真/動画、memories.csv、オフライン閲覧ページ。Papa & Mama は含みません。';

  @override
  String get setExport => '書き出す';

  @override
  String get setExporting => '書き出し中…';

  @override
  String get setExportStatusSection => '書き出しの状況';

  @override
  String setExportPreparing(int percent) {
    return '準備中 · $percent%';
  }

  @override
  String setExportStarted(String time) {
    return '今日 $time に開始 · 完了したら通知します。';
  }

  @override
  String setExportReadyTitle(String name, int size) {
    return '$name · $size MB';
  }

  @override
  String setExportExpires(String date) {
    return 'ダウンロードリンクは $date まで';
  }

  @override
  String get setDownload => 'ダウンロード';

  @override
  String get setDownloadStarted => 'ダウンロードを開始しました';

  @override
  String get setOnDeviceSection => 'この端末';

  @override
  String get setCache => 'キャッシュ';

  @override
  String setCacheSize(int size) {
    return '端末に $size MB';
  }

  @override
  String get setClearCache => 'キャッシュを削除';

  @override
  String get setCacheHint => 'キャッシュの削除は端末の空き容量を増やすだけ。思い出はクラウドに安全に残ります。';

  @override
  String setDelStep(int step) {
    return 'ステップ $step/4';
  }

  @override
  String get setDelStepFinal => 'ステップ 3–4/4';

  @override
  String get setDelTitle1 => 'アカウントを削除する前に';

  @override
  String setDelSubtitle1(String name) {
    return '$nameさん、変わることをまとめました。いつでも中止できます。';
  }

  @override
  String get setDelWillDelete => '削除されるもの';

  @override
  String get setDelItemPrivate => 'あなたのプライベート日記、気分、下書き';

  @override
  String setDelItemCouple(String partner) {
    return 'あなたの Papa & Mama の部分 — $partnerの分は残ります';
  }

  @override
  String get setDelItemCoupleSolo => 'あなたの Papa & Mama の部分';

  @override
  String get setDelItemProfile => 'プロフィールとログイン方法';

  @override
  String setDelPosted(int count) {
    return 'あなたが投稿した思い出 $count 件';
  }

  @override
  String get setDelKeepForFamily => '家族のために残す';

  @override
  String get setDelKeepHint => '「退会したユーザー」として表示';

  @override
  String get setDelDeleteMemories => 'これらの思い出を削除';

  @override
  String get setDelSubscription => 'プラン';

  @override
  String get setDelSubscriptionBody =>
      'App Store / Google Play で購入したプランはアカウント削除では解約されません。更新を止めるにはストアで解約してください。';

  @override
  String get setDelHowToCancel => 'ストアでの解約方法';

  @override
  String get setDelOthersNote =>
      'あなたの写真への他の人のコメントはその人のもの。アプリが他人の内容を消すことはありません。';

  @override
  String get setDelKeepAccount => 'アカウントを残す';

  @override
  String setDelTitle2(String family) {
    return '$familyはどうなる？';
  }

  @override
  String setDelSubtitle2(String partner) {
    return '家族には$partnerがいるので、子どもたちと思い出はすべて$partnerのもとに残ります。';
  }

  @override
  String setDelPartnerKeeps(String partner, String family) {
    return '$partnerが$familyを引き継ぎます';
  }

  @override
  String setDelPartnerItem1(String partner, String children) {
    return '$partnerは$childrenの思い出をすべて閲覧・保存できます';
  }

  @override
  String get setDelPartnerItem2 => '家族は閲覧と保存のみのモードになります';

  @override
  String setDelPartnerItem3(String partner) {
    return '$partnerは新しいパートナーを家族に招待できます';
  }

  @override
  String setDelCoupleData(String partner) {
    return 'Papa & Mama でのあなたの気分・日記・共有は削除されます。$partnerの分はそのまま残ります。';
  }

  @override
  String get setDelExportTip => '自分用にコピーを残しますか？';

  @override
  String get setDelExportTipHint => '削除前に個人データを書き出す';

  @override
  String get setDelOnlyBadge => 'あなたが唯一の Papa/Mama の場合';

  @override
  String get setDelOnlyTitle => '子どもたちの思い出は誰が引き継ぐ？';

  @override
  String setDelOnlySubtitle(String family) {
    return '$familyを管理しているのはあなただけです。続ける前に方法を選んでください。';
  }

  @override
  String get setDelInviteParent => '先に別の人を Parent に招待';

  @override
  String get setDelInviteParentHint =>
      '家族・子どもたち・思い出はその人が引き継ぎます。参加後に戻って削除してください。';

  @override
  String get setDelDeleteFamily => '家族ごと削除';

  @override
  String setDelDeleteFamilyHint(String children) {
    return '$childrenとすべての思い出は30日後に完全に削除されます。30日以内なら復元できます。';
  }

  @override
  String get setDelOnlyExportTip => '元の写真と動画をすべて残すため、先に家族データを書き出しましょう。';

  @override
  String get setDelInviteNewParent => '新しい Parent を招待';

  @override
  String get setDelTitle3 => '最終確認';

  @override
  String get setDelSubtitle3 => 'アカウント保護のため、連携済みの方法でもう一度ログインしてください。';

  @override
  String setDelVerified(String account) {
    return '確認済み · $account';
  }

  @override
  String setDelUseOtp(String phone) {
    return '電話 $phone で OTP を使う';
  }

  @override
  String get setDelWhatHappens => '「アカウントを削除」を押すと';

  @override
  String get setDelHappen1 => 'すべての端末からすぐにログアウトします';

  @override
  String setDelHappen2(String date) {
    return 'アカウントは30日間削除待ち — $date まで';
  }

  @override
  String get setDelHappen3 => 'それまでにログインすれば復元できます';

  @override
  String get setDelHappen4 => '30日後にデータは完全に削除され、確認メールが届きます';

  @override
  String get setDelConfirmCheck => '理解したうえでアカウントを削除します';

  @override
  String get setFaqSection => 'よくある質問';

  @override
  String get setFaqAll => 'すべての質問を見る';

  @override
  String get setSupportSection => 'さらにサポートが必要なとき';

  @override
  String get setSendRequest => 'サポートを依頼';

  @override
  String get setSendRequestHint => '問題を説明し、必要ならスクリーンショットを添付';

  @override
  String get setMyReports => '自分の報告';

  @override
  String setReportsOpen(int count) {
    return '$count 件対応中';
  }

  @override
  String get setContactSection => 'お問い合わせ';

  @override
  String get setEmailSupport => 'サポートチームのメール';

  @override
  String get setHotline => 'サポートダイヤル';

  @override
  String setAppVersion(String version) {
    return 'バージョン $version';
  }

  @override
  String get setTerms => '利用規約';

  @override
  String get setPrivacyPolicy => 'プライバシーポリシー';

  @override
  String get setLicenses => 'オープンソースライセンス';

  @override
  String get setMadeWith => 'ベトナムの家族のために愛をこめて';

  @override
  String setCopyright(String year) {
    return '© $year Baby Family';
  }

  @override
  String commonAndList(String items, String last) {
    return '$itemsと$last';
  }

  @override
  String get memAlbumsAuto => '自動アルバム';

  @override
  String get memAlbumsAutoHint => '自動で更新';

  @override
  String get memAlbumsFamily => 'わが家のアルバム';

  @override
  String get memAlbumNew => '新しいアルバム';

  @override
  String get memAlbumNameHint => 'アルバム名';

  @override
  String get memAlbumCreate => 'アルバムを作成';

  @override
  String memAlbumMonthlyMeta(String name, int count) {
    return '$name · $count枚';
  }

  @override
  String memAlbumFirstsMeta(int count) {
    return '$count件のマイルストーン';
  }

  @override
  String memAlbumVideosMeta(int count) {
    return '$count本の動画';
  }

  @override
  String memAlbumQuotesMeta(int count) {
    return '$count件の言葉';
  }

  @override
  String memAlbumVoicesMeta(int count) {
    return '$count件の録音';
  }

  @override
  String memAlbumParentsMeta(int count) {
    return '$count件の思い出 · パパとママ';
  }

  @override
  String memAlbumDetailMeta(int count, String range) {
    return '$count件の思い出 · $range';
  }

  @override
  String memAlbumCreatedBy(String callName) {
    return '$callNameが作成';
  }

  @override
  String get memAlbumPermissionNote => '閲覧者は自分が見られる思い出だけを表示します。';

  @override
  String get memAlbumRename => '名前を変更';

  @override
  String get memAlbumChangeCover => 'カバーを変更';

  @override
  String get memAlbumDelete => 'アルバムを削除';

  @override
  String get memAlbumDeleteNote => 'アルバム内の思い出は残ります';

  @override
  String memAlbumDeleteConfirm(String title) {
    return 'アルバム「$title」を削除しますか？';
  }

  @override
  String memNamesPair(String first, String second) {
    return '$firstと$second';
  }

  @override
  String memDotMeta3(String first, String second, String third) {
    return '$first · $second · $third';
  }

  @override
  String get memViewerSwipeHint => '下にスワイプして閉じる';

  @override
  String get memViewerDownload => '保存';

  @override
  String get memViewerShare => '共有';

  @override
  String get memViewerInfo => '情報';

  @override
  String get memViewerDownloaded => '端末に保存しました';

  @override
  String get memCommentReply => '返信';

  @override
  String memCommentReplying(String name) {
    return '$nameに返信中';
  }

  @override
  String get memCommentEditing => 'コメントを編集中';

  @override
  String get memCommentEdit => '編集';

  @override
  String get memCommentCopy => 'コピー';

  @override
  String get memCommentDelete => '削除';

  @override
  String memCommentMinutes(int count) {
    return '$count分';
  }

  @override
  String memCommentHours(int count) {
    return '$count時間';
  }

  @override
  String get memCommentEmoji => '絵文字';

  @override
  String get memMilestoneSearchHint => 'マイルストーンを検索（例：「寝返り」「歯」）';

  @override
  String memMilestoneRecordedCount(int done, int total) {
    return '$done / $total 記録済み';
  }

  @override
  String memMilestoneRecordedAt(String date) {
    return '記録済み · $date';
  }

  @override
  String get memMilestoneCustom => '✏️ わが家だけのマイルストーン';

  @override
  String get memMilestoneCustomHint => 'マイルストーン名';

  @override
  String get memMilestoneNoResult => '該当するマイルストーンがありません';

  @override
  String memDiarySavedDraft(String time) {
    return '下書き保存 · $time';
  }

  @override
  String get memDiarySaved => '日記を保存しました';

  @override
  String get memFormatBold => '太字';

  @override
  String get memFormatItalic => '斜体';

  @override
  String get memFormatList => '箇条書き';

  @override
  String get memFormatNumbered => '番号付きリスト';

  @override
  String get memFormatImage => '写真を挿入';

  @override
  String get memFormatHeading => '見出し';

  @override
  String get memFormatHideKeyboard => 'キーボードを閉じる';

  @override
  String get memLetterSaveDraft => '下書き保存';

  @override
  String get memLetterDraftSaved => '下書きを保存しました';

  @override
  String get memLetterRecipient => '宛先';

  @override
  String get memLetterFormat => '形式';

  @override
  String get memLetterWrite => '書く';

  @override
  String get memLetterVideo => '動画を撮る';

  @override
  String get memLetterPickDate => '日付を選ぶ';

  @override
  String get memLetterBirthdayN => 'N歳の誕生日';

  @override
  String memLetterBirthdayAge(int age) {
    return '$age歳の誕生日';
  }

  @override
  String memLetterOpensOn(String name, String date) {
    return '$nameが$dateに開封';
  }

  @override
  String get memLetterReaders => '開封日に読める人';

  @override
  String memLetterReadersNote(String mode, String me, String partner) {
    String _temp0 = intl.Intl.selectLogic(mode, {
      'onlyMe': '開封時：$meだけが子どもと一緒に読みます。$partnerには表示されません。',
      'family': '開封時：家族みんなで読みます。それまでは$meだけが読んで編集できます。',
      'other':
          '開封時：$meと$partnerが子どもと一緒に読みます。それまでは$meだけが読んで編集でき、$partnerには手紙があることだけが見えます。',
    });
    return '$_temp0';
  }

  @override
  String get memLetterEnvelopePreview => '封筒のプレビュー';

  @override
  String memLetterEnvelopeTo(String name) {
    return '$nameへ';
  }

  @override
  String memLetterEnvelopeBirthday(String date, int age) {
    return '$dateに開封 · $age歳の誕生日';
  }

  @override
  String memLetterEnvelopeDate(String date) {
    return '$dateに開封';
  }

  @override
  String get memLetterEnvelopeAnytime => '開封日なし';

  @override
  String memLetterTimelineHint(String callName, String date) {
    return 'タイムライン：「💌 $callNameからの手紙 — $dateに開封」';
  }

  @override
  String memLetterTimelineHintNow(String callName) {
    return 'タイムライン：「💌 $callNameからの手紙」';
  }

  @override
  String get memLetterSeal => '手紙を封印する';

  @override
  String memLetterSalutation(String child, String callName) {
    return '$callNameから$childへ、';
  }

  @override
  String get memLetterSignOff => '愛をこめて、';

  @override
  String get memSearchHint => '思い出・言葉・日記を検索…';

  @override
  String get memSearchRecent => '最近';

  @override
  String get memSearchKind => '種類';

  @override
  String get memSearchKindAll => 'すべて';

  @override
  String get memSearchAuthor => '投稿者';

  @override
  String memSearchResults(int count, String query) {
    return '「$query」の検索結果 $count件';
  }

  @override
  String memSearchMedia(int count) {
    return '写真・動画 · $count';
  }

  @override
  String memSearchDiaries(int count) {
    return '日記 · $count';
  }

  @override
  String get memSearchNoResult => '思い出が見つかりません';

  @override
  String memOnThisDayMonthShort(int month) {
    return '$month月';
  }

  @override
  String memOnThisDayHeader(int day, int month) {
    return 'わが家の$month月$day日';
  }

  @override
  String memOnThisDaySummary(int years, int count) {
    return '$years年分の思い出 · $count件';
  }

  @override
  String memOnThisDayYearsAgo(int count) {
    return '$count年前';
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
    return '$count枚';
  }

  @override
  String memQuoteOfChild(String name, String age) {
    return '$nameの言葉 · $age';
  }

  @override
  String get memOnThisDayReshare => '新しい説明をつけて再共有';

  @override
  String get memOnThisDayFooter => '閲覧できる思い出のみ表示 · 設定でオフ';

  @override
  String get memOnThisDayEmpty => '今日は過去の思い出がありません';

  @override
  String recapWeekRange(String range, String audience) {
    return '今週 · $range · $audience';
  }

  @override
  String recapQuoteMeta(String name, String age) {
    return '$nameの新しい言葉 · $age';
  }

  @override
  String get recapShareFamily => '家族に共有';

  @override
  String get recapFamilyBadge => 'Family';

  @override
  String get recapSaveTimeline => 'タイムラインに保存';

  @override
  String get recapDownload => 'まとめ画像を保存';

  @override
  String get recapNote => '共有前に確認できます。パパとママの内容は含まれません。';

  @override
  String get recapNextHighlights => 'ハイライト';

  @override
  String get recapShared => '家族に共有しました';

  @override
  String get recapSaved => 'タイムラインに保存しました';

  @override
  String get memLetterSealDone => '手紙を封印しました';

  @override
  String usThanksMonth(String month) {
    return '$month月';
  }

  @override
  String get usThanksAll => 'すべて';

  @override
  String get usThanksMine => 'あなた';

  @override
  String usThanksPartner(String callName) {
    return '$callName';
  }

  @override
  String usThanksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ありがとう $count 件',
    );
    return '$_temp0';
  }

  @override
  String get usThanksYou => 'あなた';

  @override
  String get usThanksSendCta => 'ありがとうを送る';

  @override
  String get usThanksReact => 'ハートを送る';

  @override
  String get usThanksWallEmpty => '今月のありがとうはまだありません';

  @override
  String get usJournalOnlyYou => 'あなただけが読めます';

  @override
  String usJournalOnlyYouHint(String callName) {
    return '$callNameにも見えません。あなたが一部を共有した場合を除きます。';
  }

  @override
  String get usJournalFaceId => 'Face ID でロック';

  @override
  String get usJournalFaceIdHint => '日記を開くたびに Face ID を求める';

  @override
  String usJournalMonth(String month) {
    return '$month月';
  }

  @override
  String usJournalMood(String mood) {
    String _temp0 = intl.Intl.selectLogic(mood, {
      'tired': '疲れた',
      'grateful': '感謝',
      'worried': '心配',
      'other': '穏やか',
    });
    return '$_temp0';
  }

  @override
  String get usJournalShareAction => 'この部分をパートナーに共有';

  @override
  String usJournalShared(String callName) {
    return '$callNameに1か所共有済み';
  }

  @override
  String get usJournalWrite => '新しいページを書く';

  @override
  String usJournalSharePreview(String callName) {
    return '$callNameにはこの内容がそのまま表示されます：';
  }

  @override
  String usJournalShareConfirm(String callName) {
    return '$callNameに共有';
  }

  @override
  String get usJournalNewPage => '新しいページ';

  @override
  String get usJournalMoodLabel => '今の気持ちは？';

  @override
  String get usJournalTitleLabel => 'タイトル';

  @override
  String get usJournalBodyLabel => '書き留めたいこと';

  @override
  String get usJournalSave => 'ページを保存';

  @override
  String get usJournalEmpty => 'まだページがありません。自分のために少し書いてみましょう。';

  @override
  String usSettingsScope(String callName) {
    return 'あなたにだけ適用 · $callNameには別の設定があります';
  }

  @override
  String get usSettingsCheckinSection => '気持ちのチェックイン';

  @override
  String usSettingsShareMode(String mode, String callName) {
    String _temp0 = intl.Intl.selectLogic(mode, {
      'askEachTime': '毎回たずねる',
      'alwaysShare': 'いつも$callNameと共有',
      'other': 'いつも非公開',
    });
    return '$_temp0';
  }

  @override
  String usSettingsShareModeHint(String mode, String callName) {
    String _temp0 = intl.Intl.selectLogic(mode, {
      'askEachTime': 'チェックインのたびに共有か非公開かを選ぶ',
      'alwaysShare': '$callNameが気持ちとチェックした項目を見られます',
      'other': 'あなただけが見返せます',
    });
    return '$_temp0';
  }

  @override
  String get usSettingsPrivacySection => 'プライバシー';

  @override
  String get usSettingsHideLock => 'ロック画面で内容を隠す';

  @override
  String get usSettingsHideLockHint => '「Papa & Mama から新しいお知らせがあります」とだけ表示';

  @override
  String get usSettingsFaceId => 'Papa & Mama を開くときに Face ID';

  @override
  String get usSettingsFaceIdHint => 'このタブを開くたびに Face ID を求める';

  @override
  String get usSettingsRequestsSection => 'お願い';

  @override
  String usSettingsUrgentBypass(String callName) {
    return '$callNameの「早めにね」のお願いをおやすみ時間中も届ける';
  }

  @override
  String usSettingsUrgentBypassHint(String from, String to) {
    return 'おやすみ時間：$from〜$to。オフにすると、お願いはおやすみ時間の後に届きます。';
  }

  @override
  String get usSettingsBridgeSection => 'かけはし';

  @override
  String get usSettingsBridgeKeep => 'かけはしの内容を保存する期間';

  @override
  String usSettingsRetention(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days日',
      zero: 'すぐ削除',
    );
    return '$_temp0';
  }

  @override
  String get usSettingsBridgeHint => 'この期間が過ぎると、ふたりが書いた内容は自動的に削除されます。';

  @override
  String get usSettingsDataSection => 'データ';

  @override
  String get usSettingsClearMood => '自分の気持ちの履歴を削除';

  @override
  String get usSettingsClearMoodHint => '保存したすべてのチェックインを削除します。元に戻せません。';

  @override
  String get usSettingsClearMoodConfirm => '気持ちの履歴を削除しますか？';

  @override
  String get usSettingsClearMoodDone => '気持ちの履歴を削除しました';

  @override
  String get commonDelete => '削除';

  @override
  String get childEditProfile => 'プロフィールを編集';

  @override
  String get childChangeCover => 'カバーを変更';

  @override
  String childColorName(String index) {
    String _temp0 = intl.Intl.selectLogic(index, {
      '0': 'ピーチ',
      '1': 'ミント',
      '2': 'スカイ',
      '3': 'ラベンダー',
      '4': 'レモン',
      '5': 'ローズ',
      '6': 'アプリコット',
      'other': 'アクア',
    });
    return '$_temp0';
  }

  @override
  String childColorNamed(String color) {
    return '$color';
  }

  @override
  String get childStatMemories => '思い出';

  @override
  String get childStatMilestones => '成長記録';

  @override
  String get childStatLetters => '子どもへの手紙';

  @override
  String get childBirthDate => '誕生日';

  @override
  String childLunarBirth(String date) {
    return '旧暦：$date';
  }

  @override
  String get childBirthTime => '生まれた時刻';

  @override
  String get childBirthTimeHidden => '親族には生まれた時刻は表示されません';

  @override
  String get childBirthTimeShown => '親族にも生まれた時刻が表示されます';

  @override
  String get childDueDate => '出産予定日';

  @override
  String get childOriginPregnancy => '妊娠中の記録';

  @override
  String childOriginPregnancyValue(int weeks) {
    return '妊娠の記録 · $weeks週';
  }

  @override
  String get childNameStory => '名前の由来';

  @override
  String childNameGivenBy(String names) {
    return '$namesが名付けました';
  }

  @override
  String childNamesAnd(String first, String second) {
    return '$firstと$second';
  }

  @override
  String childLikes(String name) {
    return '$nameの好きなもの';
  }

  @override
  String get childFavFood => '好きな食べ物';

  @override
  String get childFavToy => 'おもちゃ';

  @override
  String get childFavSong => '歌';

  @override
  String childQuoted(String text) {
    return '「$text」';
  }

  @override
  String childRelativesSee(String name) {
    return '$nameを見られる親族';
  }

  @override
  String get childRelativesNone => 'まだ親族と共有していません';

  @override
  String get childArchiveAction => 'プロフィールをアーカイブ';

  @override
  String childArchiveConfirmTitle(String name) {
    return '$nameのプロフィールをアーカイブしますか？';
  }

  @override
  String get childArchiveConfirmBody =>
      'この子だけの思い出は非表示になり、きょうだいとの思い出は残ります。いつでも元に戻せます。';

  @override
  String get childArchive => 'アーカイブ';

  @override
  String childEditTitleNamed(String name) {
    return '$nameのプロフィールを編集';
  }

  @override
  String get childChangeAvatar => 'プロフィール写真を変更';

  @override
  String get childChangeTimelineCover => 'タイムラインのカバーを変更';

  @override
  String get childFieldName => '名前';

  @override
  String get childFieldNickname => '呼び名';

  @override
  String get childBirthDateWarning => '思い出の年齢は新しい誕生日で計算し直されます。';

  @override
  String get childShowBirthTime => '親族に生まれた時刻を表示';

  @override
  String get childShowBirthTimeHint => '親族には子どもの年齢が常に表示されます';

  @override
  String get childColorLabel => 'テーマカラー';

  @override
  String childColorUsedBy(String color, String name) {
    return '$colorは$nameに使用中';
  }

  @override
  String get childNameGivenByLabel => '名付け親：';

  @override
  String get childNameGivenByOther => '+ その他';

  @override
  String get childLikesSection => '好きなもの';

  @override
  String get childSaveChanges => '変更を保存';

  @override
  String get childrenReorderHint => '長押ししてドラッグすると表示順を変えられます';

  @override
  String childPregnancyTag(int number) {
    return '第$number子（妊娠中）';
  }

  @override
  String childDueShort(String date) {
    return '予定日 $date';
  }

  @override
  String childrenArchived(int count) {
    return 'アーカイブ済み（$count）';
  }

  @override
  String childArchivedOn(String date) {
    return '$date アーカイブ';
  }

  @override
  String childPrivateMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '専用の思い出 $count 件',
    );
    return '$_temp0';
  }

  @override
  String get childRestore => '元に戻す';

  @override
  String childrenArchiveNote(int days) {
    return 'アーカイブした子は切り替えから非表示になります。$days日たつと完全に削除できます。';
  }

  @override
  String childAddSubtitle(String family, String names) {
    return '新しい子は$familyに加わります。$namesのプロフィールはそのままです。';
  }

  @override
  String childNamesList(String rest, String last) {
    return '$restと$last';
  }

  @override
  String get childAddBorn => 'もう生まれた子';

  @override
  String get childAddBornHint => '名前と誕生日でプロフィールを追加';

  @override
  String get childAddExpecting => '赤ちゃんを待っています';

  @override
  String childAddExpectingHint(int number) {
    return '新しい妊娠の記録を始める（第$number子）';
  }

  @override
  String get childNameHint => '例：ビン、ミット、スー…';

  @override
  String get childBirthDateHint => '誕生日を選ぶ';

  @override
  String get childDueDateHint => '出産予定日を選ぶ';

  @override
  String get childGenderOptional => '性別（任意）';

  @override
  String childGender(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'boy': '男の子',
      'girl': '女の子',
      'other': '答えない',
    });
    return '$_temp0';
  }

  @override
  String get childAddShareNote => '追加したあと、どの親族と共有するか選べます。最初は誰とも共有されません。';

  @override
  String get memSearchYear => '年';

  @override
  String memDotMeta2(String first, String second) {
    return '$first · $second';
  }

  @override
  String childLunarDateYear(String day, String month, String year) {
    return '$year年$month月$day日';
  }

  @override
  String get careMoreMenu => 'その他';

  @override
  String get careMenuHistory => 'タスクの履歴';

  @override
  String setDelPartnerRole(String callName) {
    return '$callName · 家族の管理者';
  }

  @override
  String memAlbumCount(int count) {
    return '$count件のアルバム';
  }

  @override
  String get usBridgeRewriteTitle => 'やさしく書き直す';

  @override
  String get usBridgeNextStepTitle => '次の小さな一歩';

  @override
  String get usSafetyTitle => '安全サポート';

  @override
  String get recapDayTitle => '今日のストーリー';

  @override
  String get recapMonthTitle => '月齢の振り返り';

  @override
  String get careStatsTitle => '統計';

  @override
  String get memTrashTitle => 'ゴミ箱';

  @override
  String get memDraftsTitle => '下書き';

  @override
  String get memPendingTitle => '承認待ち';

  @override
  String get childArchiveTitle => '子どもをアーカイブまたは削除';

  @override
  String get circleTabHome => '孫';

  @override
  String get circleTabMemories => '思い出';

  @override
  String get circleTabPost => '写真を投稿';

  @override
  String get circleTabMe => '自分';

  @override
  String get circlePostTitle => '孫の写真を投稿';

  @override
  String get circleMemoryDetailTitle => '思い出の詳細';

  @override
  String get circlePausedTitle => '家族の共有が一時停止中';

  @override
  String get circleLeaveTitle => '家族を離れる';

  @override
  String get billingPlanTitle => '家族のプラン';

  @override
  String get familyInvitePartnerTitle => 'パートナーを招待';

  @override
  String get familyPendingInvitesTitle => '保留中の招待';

  @override
  String get settingsBlockedTitle => 'ブロック中の人';
}
