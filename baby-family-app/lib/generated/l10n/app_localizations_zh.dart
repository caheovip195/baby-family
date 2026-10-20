// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'Baby Family';

  @override
  String get commonContinue => '继续';

  @override
  String get commonStart => '开始使用';

  @override
  String get commonCancel => '取消';

  @override
  String get commonConfirm => '确认';

  @override
  String get commonRetry => '重试';

  @override
  String get commonClose => '关闭';

  @override
  String get commonCopyError => '复制错误信息';

  @override
  String commonDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '还剩 $count 天',
      zero: '今天是最后一天',
    );
    return '$_temp0';
  }

  @override
  String commonUpdatedAt(DateTime time) {
    final intl.DateFormat timeDateFormat = intl.DateFormat.Hm(localeName);
    final String timeString = timeDateFormat.format(time);

    return '更新于 $timeString';
  }

  @override
  String get errorGeneric => '出现了一点问题，请重试。';

  @override
  String get errorNetwork => '无法连接服务器。请检查网络连接后重试。';

  @override
  String get errorRenewSessionNetwork => '无法连接服务器以续期登录。请检查网络连接后重试。';

  @override
  String get errorSessionExpired => '登录已过期，请重新登录。';

  @override
  String get errorUpgradeRequired => '应用版本已过旧，请更新后继续使用。';

  @override
  String get errorStartupTitle => '应用无法启动';

  @override
  String get errorStartupDescription => '请重新打开应用。如果问题仍然存在，请将以下信息发送给客服：';

  @override
  String get languagePickerTitle => '选择语言';

  @override
  String get welcomeSlide1Title => '珍藏孩子的成长旅程';

  @override
  String get welcomeSlide1Description => '从第一次超声照片到蹒跚学步，每个瞬间都只属于你们的家人。';

  @override
  String get welcomeSlide2Title => 'Papa & Mama 一起照顾孩子';

  @override
  String get welcomeSlide2Description => '每天的小任务让 Papa 和 Mama 一起分担育儿，不用彼此提醒。';

  @override
  String get welcomeSlide3Title => '让长辈一起见证成长';

  @override
  String get welcomeSlide3Description => '邀请祖父母和亲友见证孩子成长——安全、私密，无需社交网络。';

  @override
  String get welcomeHaveInviteCode => '我有邀请码';

  @override
  String get commonSave => '保存';

  @override
  String get commonDone => '完成';

  @override
  String get commonAdd => '添加';

  @override
  String get commonSeeAll => '查看全部';

  @override
  String get commonBack => '返回';

  @override
  String get commonEmptyTitle => '暂无内容';

  @override
  String get commonEmptyMessage => '为家人留下第一个珍贵瞬间吧。';

  @override
  String get commonOffline => '你目前离线。已保存的内容依然可查看。';

  @override
  String get commonMockMode => '示例数据';

  @override
  String get commonAllFamily => '全家';

  @override
  String get commonMine => '我的';

  @override
  String commonPartnerTasks(String callName) {
    return '$callName 的任务';
  }

  @override
  String get commonTogether => '一起完成';

  @override
  String get commonOnlyYou => '仅自己';

  @override
  String get commonOnlyParents => '仅 Papa & Mama';

  @override
  String get commonPhotos => '照片';

  @override
  String get commonTimeline => '时间线';

  @override
  String get commonCollections => '合集';

  @override
  String get commonMemory => '回忆';

  @override
  String get commonDiary => '日记';

  @override
  String get commonMilestone => '成长里程碑';

  @override
  String get commonLetter => '写给孩子的信';

  @override
  String get commonMission => '任务';

  @override
  String get commonEvent => '活动';

  @override
  String get commonCheckin => '心情打卡';

  @override
  String get commonRequest => '请求';

  @override
  String get commonThanks => '感谢';

  @override
  String get commonSelectChild => '选择孩子';

  @override
  String get commonQuickCreate => '记录一个小瞬间';

  @override
  String get commonName => '名称';

  @override
  String get commonDate => '日期';

  @override
  String get commonBody => '内容';

  @override
  String get commonSaved => '已在演示版中保存';

  @override
  String get commonInvalidInput => '请填写完整后再保存。';

  @override
  String commonChildAge(int months, int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years岁$months个月',
      zero: '$months个月',
    );
    return '$_temp0';
  }

  @override
  String commonPregnancyWeek(int week) {
    return '孕$week周';
  }

  @override
  String commonCountMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count条回忆',
    );
    return '$_temp0';
  }

  @override
  String commonHearts(int count) {
    return '$count Hearts';
  }

  @override
  String get navHome => '首页';

  @override
  String get navMemories => '回忆';

  @override
  String get navCare => '育儿';

  @override
  String get navUs => 'Papa & Mama';

  @override
  String homeGreeting(String name) {
    return '你好，$name';
  }

  @override
  String get homeToday => '孩子们的今天';

  @override
  String get homeSpecialDay => '特别的日子';

  @override
  String get homeMonthlyPhoto => '拍月龄照';

  @override
  String get homeMissions => '今日任务';

  @override
  String get homePrompt => '记录灵感';

  @override
  String get homeRecordQuote => '记录童言';

  @override
  String get homeRecent => '家中新鲜事';

  @override
  String get homeThisWeek => '我们家的一周';

  @override
  String get homeFamilyTree => '家庭树';

  @override
  String get homeFamily => '我的家庭';

  @override
  String get careTitle => '育儿';

  @override
  String get careTodayTree => '今日之树';

  @override
  String careProgress(int done, int total) {
    return '家庭任务 $done/$total';
  }

  @override
  String get careAddMission => '添加任务';

  @override
  String get careMissionTitle => '任务名称';

  @override
  String get careWhoDoes => '由谁完成？';

  @override
  String get careWhen => '什么时候？';

  @override
  String get careReminder => '温馨提醒';

  @override
  String get careRepeat => '重复';

  @override
  String careAskPartner(String callName) {
    return '请$callName帮忙';
  }

  @override
  String get careCompleteTitle => '小小任务，满满关爱';

  @override
  String get careSaveMoment => '保存为回忆';

  @override
  String get careUndo => '撤销';

  @override
  String get careSwapTitle => '更换任务';

  @override
  String get careRemoveToday => '从今天移除（不扣除任何积分）';

  @override
  String get careTreeTitle => '家庭树';

  @override
  String careTreeLevel(int level) {
    return '等级$level';
  }

  @override
  String get careTreeNext => '一起让家庭树茁壮成长';

  @override
  String get careContribution => '全家的贡献';

  @override
  String get careHeartsPrivacy => '每个人的爱心只有本人可见。不作比较，也永不扣除。';

  @override
  String get usTitle => 'Papa & Mama';

  @override
  String get usHowAreYou => '今天感觉怎么样？';

  @override
  String get usEnergy => '你的精力';

  @override
  String get usNeed => '你现在需要什么？';

  @override
  String usShareWith(String callName) {
    return '分享给$callName';
  }

  @override
  String get usPrivate => '仅 Papa & Mama 可见的私密空间';

  @override
  String get usSendRequest => '发送请求';

  @override
  String get usRequestMessage => '想请对方帮什么忙？';

  @override
  String get usAccept => '我来帮忙';

  @override
  String get usDecline => '今天不太方便';

  @override
  String get usRequestAccepted => '已接受';

  @override
  String get usRequestDone => '已完成';

  @override
  String get usDailyQuestion => '今天的互动话题';

  @override
  String get usJournal => '私密日记';

  @override
  String get usBridge => '爱的桥梁';

  @override
  String get usWeek => '我们俩的一周';

  @override
  String get usHug => '送一个拥抱';

  @override
  String get usSeen => '看到了';

  @override
  String get usTakeOver => '让我来';

  @override
  String get usThanksRecent => '最近的感谢';

  @override
  String get familyTitle => '我的家庭';

  @override
  String get familyChildren => '孩子们';

  @override
  String get familyParents => 'Papa & Mama';

  @override
  String get familyRelatives => '祖父母与亲友';

  @override
  String get familyInvite => '邀请亲友';

  @override
  String get familyPermissions => '权限';

  @override
  String get familyPrivateNotice => '亲友只能看到你分享的内容。Papa & Mama 空间始终私密。';

  @override
  String get familyTrial => '免费试用';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsAppearance => '外观';

  @override
  String get settingsLight => '浅色';

  @override
  String get settingsDark => '深色';

  @override
  String get settingsSystem => '跟随系统';

  @override
  String get settingsTextSize => '字号';

  @override
  String get settingsRegular => '标准';

  @override
  String get settingsLarge => '大';

  @override
  String get settingsExtraLarge => '特大';

  @override
  String get settingsNotifications => '通知';

  @override
  String get settingsPrivacy => '隐私';

  @override
  String get settingsAi => 'AI 辅助';

  @override
  String get settingsSecurity => '安全与设备';

  @override
  String get settingsData => '我的数据';

  @override
  String get settingsBilling => '套餐与付款';

  @override
  String get settingsHelp => '帮助';

  @override
  String get settingsAbout => '关于';

  @override
  String get settingsLogout => '退出登录';

  @override
  String get settingsLanguageNotice => '立即生效，无需重启。家人写的内容不会翻译。';

  @override
  String get settingsLunar => '显示农历日期';

  @override
  String get settingsHaptics => '触感反馈';

  @override
  String get billingTitle => '珍藏孩子的每个瞬间';

  @override
  String get billingHouse => 'House';

  @override
  String get billingFamily => 'Family';

  @override
  String get billingRestore => '恢复购买';

  @override
  String get billingUpgrade => '升级方案';

  @override
  String get billingExpired => '你的家庭试用期已结束';

  @override
  String get billingExport => '下载数据';

  @override
  String get billingPrivacy => '回忆始终属于家人。方案到期后仍可下载数据。';

  @override
  String get billingFamilyFeatures => '最多12位亲友 · 200 GB 存储';

  @override
  String get billingHouseFeatures => '专为 Papa & Mama · 50 GB 存储';

  @override
  String get notificationsTitle => '通知';

  @override
  String get notificationsAll => '全部';

  @override
  String get notificationsPrivate => 'Papa & Mama';

  @override
  String get stateLoading => '正在加载…';

  @override
  String get stateEmptyMemories => '还没有回忆。记录第一个瞬间吧！';

  @override
  String get stateEmptyCare => '今天还没有任务';

  @override
  String get stateError => '暂时无法加载内容，请重试。';

  @override
  String get commonChoose => '选择';

  @override
  String get commonRequired => '请填写此项';

  @override
  String get memoriesTitle => '回忆';

  @override
  String get memoriesTimeline => '时间线';

  @override
  String get memoriesPhotos => '照片';

  @override
  String get memoriesCollections => '合集';

  @override
  String get memoriesAll => '全部';

  @override
  String get memoriesFirsts => '第一次';

  @override
  String get memoriesQuotes => '童言';

  @override
  String get memoriesVoices => '声音';

  @override
  String get memoriesNew => '新回忆';

  @override
  String get memoriesCaptionHint => '关于这个瞬间，你想记住什么？';

  @override
  String get memoriesChildren => '这个瞬间里的孩子';

  @override
  String get memoriesFamily => '全家';

  @override
  String get memoriesDate => '发生日期';

  @override
  String get memoriesToday => '今天';

  @override
  String get memoriesVisibility => '谁可以查看';

  @override
  String get memoriesPrivacyHint => '保存前会移除照片中的 GPS 位置信息。';

  @override
  String get memoriesAddMedia => '添加照片';

  @override
  String memUploadProgress(int done, int total) {
    return '正在上传 $done/$total…';
  }

  @override
  String get memUploadFailed => '上传未完成';

  @override
  String get memUploadRetry => '重试';

  @override
  String get memUploadCancel => '取消';

  @override
  String get memoriesSetCover => '设为封面';

  @override
  String get memoriesRemoveMedia => '移除这张照片';

  @override
  String get memoriesAddPerspective => '添加你的视角';

  @override
  String get memoriesTogether => '两人一起讲述';

  @override
  String get memoriesCommentHint => '写评论…';

  @override
  String get memoriesComments => '评论';

  @override
  String get memoriesSend => '发送';

  @override
  String get memoriesMonthly => '每月成长记录';

  @override
  String get memoriesYear => '第一年';

  @override
  String get memoriesCompare => '对比';

  @override
  String get memoriesCollage => '拼图';

  @override
  String get memoriesMonthlyPhoto => '拍摄月龄照';

  @override
  String get memoriesGhost => '上一张照片引导';

  @override
  String get memoriesGallery => '从相册选择';

  @override
  String get memoriesCapture => '拍照';

  @override
  String get memoriesQuote => '孩子说的话';

  @override
  String get memoriesQuoteHint => '今天孩子说了什么？';

  @override
  String get memoriesQuoteContext => '孩子什么时候说的？';

  @override
  String get memoriesRecordVoice => '录下孩子的声音';

  @override
  String get memoriesPerspective => '你的视角';

  @override
  String get memoriesPerspectiveHint => '你记得这个瞬间的什么？';

  @override
  String get memoriesInheritedVisibility => '与原回忆相同的查看者';

  @override
  String get memoriesStory => '孩子的今天';

  @override
  String get memoriesReplyHint => '回复…';

  @override
  String get memoriesEmpty => '还没有回忆。记录第一个瞬间吧！';

  @override
  String get memoriesSaved => '瞬间已保存';

  @override
  String get memoriesChooseChildren => '请至少选择一个孩子或全家';

  @override
  String memoriesMonthLabel(int month) {
    String _temp0 = intl.Intl.pluralLogic(
      month,
      locale: localeName,
      other: '$month个月',
    );
    return '$_temp0';
  }

  @override
  String memoriesWeekLabel(int week) {
    return '第$week周';
  }

  @override
  String memoriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count条回忆',
    );
    return '$_temp0';
  }

  @override
  String get pregnancyTitle => '孕期旅程';

  @override
  String get pregnancyBump => '孕肚照';

  @override
  String get pregnancyUltrasound => '超声照片';

  @override
  String get pregnancyPreparations => '准备事项';

  @override
  String get pregnancyCaptureBump => '拍下本周的孕肚照';

  @override
  String get pregnancyGuide => '用上一张照片的半透明引导，保持相同角度';

  @override
  String get pregnancyBumpKindness => '错过几周也没关系，每张照片都很珍贵。';

  @override
  String get pregnancyRemind => '每周日提醒拍照';

  @override
  String get pregnancyBirth => '宝宝出生了';

  @override
  String get pregnancyNames => '给宝宝起名';

  @override
  String get pregnancyArchive => '归档旅程';

  @override
  String pregnancyPrepareProgress(int done, int total) {
    return '已准备$done/$total项';
  }

  @override
  String get pregnancyAddPreparation => '添加事项';

  @override
  String get pregnancyPreparationHint => '家里需要准备的物品';

  @override
  String get pregnancyCreateMission => '转为任务';

  @override
  String get pregnancyBirthWelcome => '欢迎宝宝来到我们家';

  @override
  String get pregnancyBabyName => '名字或昵称';

  @override
  String get pregnancyNickname => '小名';

  @override
  String get pregnancyBirthDate => '出生日期 *';

  @override
  String get pregnancyBirthTime => '出生时间';

  @override
  String get pregnancyBirthWeight => '体重（kg）';

  @override
  String get pregnancyBirthGender => '性别（选填）';

  @override
  String get pregnancyBirthPreview => '查看欢迎卡片';

  @override
  String get pregnancyAnnounce => '向亲友分享喜讯？';

  @override
  String get pregnancyAnnounceHint => '仅限已获准查看孕期记录的亲友。孕期回忆将成为宝宝故事的第一章。';

  @override
  String get pregnancyBirthComplete => '欢迎宝宝！信息已保存。';

  @override
  String get pregnancyArchiveIntro => '所有回忆都会保留。你可以随时回来。';

  @override
  String get pregnancyPause => '暂停旅程';

  @override
  String get pregnancyPauseHint => '从首页隐藏并关闭提醒。你想回来时随时可以重新开启。';

  @override
  String get pregnancyEnd => '这段旅程已结束';

  @override
  String get pregnancyEndHint => '我们深感遗憾。应用将立即停止所有倒计时、提醒和祝福。';

  @override
  String get pregnancyParentsOnly => '仅 Papa & Mama 可查看这些回忆';

  @override
  String get pregnancyArchivePrivacy => '不会向亲友发送任何通知。';

  @override
  String get pregnancyArchiveSaved => '旅程已私密归档';

  @override
  String get pregnancyPrivate => '仅 Papa & Mama 可见';

  @override
  String get pregnancyBothLike => '两人都喜欢';

  @override
  String get pregnancyAddName => '添加候选名字';

  @override
  String get pregnancyNameHint => '候选名字';

  @override
  String get pregnancyMeaning => '含义';

  @override
  String get pregnancyChooseName => '选用这个名字';

  @override
  String get pregnancyNameChosen => '候选名字已保存';

  @override
  String get pregnancyMockMedia => '示例照片已准备好';

  @override
  String get commonSkip => '跳过';

  @override
  String get commonLater => '稍后';

  @override
  String get commonOr => '或';

  @override
  String get commonCopied => '已复制';

  @override
  String get commonChoosePhoto => '选择照片';

  @override
  String get commonRemovePhoto => '移除照片';

  @override
  String get commonTerms => '使用条款';

  @override
  String get commonPrivacyPolicy => '隐私政策';

  @override
  String get commonOptional => '选填';

  @override
  String get authTitle => '欢迎使用 Baby Family';

  @override
  String get authSubtitle => '登录后，与家人一起记录孩子的成长旅程。';

  @override
  String get authPrivate => '私密';

  @override
  String authTrial(int days) {
    return '免费$days天';
  }

  @override
  String get authFamily => '全家';

  @override
  String get authApple => '通过 Apple 继续';

  @override
  String get authGoogle => '通过 Google 继续';

  @override
  String get authPhone => '使用手机号';

  @override
  String get authLegal => '继续即表示你同意 Baby Family 的使用条款和隐私政策。';

  @override
  String get authPhoneTitle => '你的手机号';

  @override
  String get authPhoneSubtitle => '我们将通过 Zalo 或短信发送6位验证码。';

  @override
  String get authPhoneLabel => '手机号';

  @override
  String get authCountryCode => '国家代码';

  @override
  String get authPhonePrivate => '手机号仅用于登录，不会向他人显示。';

  @override
  String get authSendCode => '发送验证码';

  @override
  String get authOtpTitle => '输入验证码';

  @override
  String authOtpSubtitle(String phone) {
    return '6位验证码已通过 Zalo 发送到 $phone。';
  }

  @override
  String authOtpDemo(String code) {
    return '演示验证码：$code';
  }

  @override
  String get authResend => '重新发送';

  @override
  String authResendCountdown(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds秒后重新发送',
    );
    return '$_temp0';
  }

  @override
  String get authSendSms => '通过短信发送';

  @override
  String get authChangePhone => '更换手机号';

  @override
  String get authProfileTitle => '简单介绍一下自己';

  @override
  String get authProfileSubtitle => '伴侣和家人会看到这个名字。';

  @override
  String get authNameLabel => '你的名字';

  @override
  String get authTermsConsent => '我同意使用条款';

  @override
  String get authDataConsent => '我同意 Baby Family 按照隐私政策处理我和孩子的个人数据';

  @override
  String get errorRequired => '请填写此项。';

  @override
  String get errorPhone => '请输入有效的手机号。';

  @override
  String get errorConsent => '请同意两项内容后继续。';

  @override
  String get errorOtp => '验证码不正确，请重试。';

  @override
  String get errorOtpExpired => '验证码已过期，请重新发送。';

  @override
  String get errorInviteCode => '邀请码由8个字母和数字组成。';

  @override
  String get errorBirthday => '出生日期不能是未来日期。';

  @override
  String get errorPregnancyWeek => '孕周需为4至42周。';

  @override
  String get onboardingRoleTitle => '你在家庭中的角色是？';

  @override
  String get onboardingRoleSubtitle =>
      'Baby Family 需要 Papa 和 Mama 一起加入，之后再邀请长辈和亲友。';

  @override
  String get onboardingPapaDescription => '孩子的爸爸，与 Mama 一起管理家庭';

  @override
  String get onboardingMamaDescription => '孩子的妈妈，与 Papa 一起管理家庭';

  @override
  String get onboardingCircle => '亲友';

  @override
  String get onboardingCircleDescription => '长辈、亲友和照顾孩子的人，需要邀请才能加入';

  @override
  String get onboardingCallName => '孩子怎么称呼你';

  @override
  String get onboardingOtherCallName => '其他…';

  @override
  String get onboardingFatherCallName => '爸爸';

  @override
  String get onboardingFatherCallNameAlt => '老爸';

  @override
  String get onboardingMotherCallName => '妈妈';

  @override
  String get onboardingMotherCallNameAlt => '妈咪';

  @override
  String get onboardingFamilyTitle => '为小家起个名字';

  @override
  String get onboardingFamilySubtitle => '家庭名称仅对 Papa、Mama 和受邀亲友可见。';

  @override
  String get onboardingFamilyName => '家庭名称';

  @override
  String get onboardingCreateFamily => '创建家庭';

  @override
  String onboardingInviteTitle(String callName) {
    return '邀请$callName一起加入';
  }

  @override
  String onboardingInviteSubtitle(int days) {
    return 'Baby Family 需要 Papa 和 Mama 一起加入。伴侣加入后，家庭即可开始$days天免费试用。';
  }

  @override
  String get onboardingInviteCode => '邀请码';

  @override
  String get onboardingInviteExpiry => '7天后到期 · 仅可使用一次';

  @override
  String get onboardingInviteApproval => '伴侣加入时由我最终确认';

  @override
  String get onboardingShareInvite => '通过 Zalo、Messenger 等发送邀请';

  @override
  String get onboardingCopyInvite => '复制邀请链接';

  @override
  String get onboardingInviteSent => '邀请已发送';

  @override
  String onboardingWaitingTitle(String callName) {
    return '正在等待$callName加入…';
  }

  @override
  String onboardingWaitingSubtitle(int days) {
    return '伴侣接受邀请后，家庭功能将开启，并开始$days天免费试用。';
  }

  @override
  String get onboardingResendInvite => '重新发送邀请';

  @override
  String get onboardingShowQr => '显示二维码';

  @override
  String get onboardingChangeInvite => '更换邀请方式';

  @override
  String get onboardingCancelFamily => '取消这个家庭';

  @override
  String get onboardingActivateDemo => '模拟伴侣加入';

  @override
  String get onboardingActivatedTitle => 'Papa & Mama 都到齐了 🎉';

  @override
  String get onboardingActivatedSubtitle => '一起记录孩子的成长、分担育儿，也更懂彼此。';

  @override
  String onboardingTrial(int days) {
    return '$days天免费试用';
  }

  @override
  String get onboardingSetupChild => '设置宝宝资料';

  @override
  String get onboardingStageTitle => '家里现在处于哪个阶段？';

  @override
  String get onboardingStageSubtitle => '随时可以添加其他孩子或孕期记录。';

  @override
  String get onboardingPregnant => '正在孕期';

  @override
  String get onboardingPregnantDescription => '保存孕照、超声照片和给宝宝的信，准备迎接宝宝';

  @override
  String get onboardingBorn => '宝宝已出生';

  @override
  String get onboardingBornDescription => '建立宝宝档案，记录第一次，一起照顾孩子';

  @override
  String get onboardingBoth => '已有孩子，也正在孕期';

  @override
  String get onboardingBothDescription => '同一个家庭管理多个孩子和孕期';

  @override
  String get onboardingPregnancyTitle => '你好，小宝贝';

  @override
  String get onboardingPregnancySubtitle => '先取一个小名，其他信息以后再补充。';

  @override
  String get onboardingNickname => '宝宝的小名';

  @override
  String get onboardingDueDate => '预产期';

  @override
  String get onboardingKnowWeek => '我只知道孕周';

  @override
  String get onboardingWeek => '孕周';

  @override
  String get onboardingBabyCount => '宝宝数量';

  @override
  String get onboardingSingle => '一个宝宝';

  @override
  String get onboardingTwins => '双胞胎';

  @override
  String get onboardingTriplets => '三胞胎';

  @override
  String get onboardingSkipDueDate => '跳过预产期';

  @override
  String get onboardingChildTitle => '介绍家里的宝贝';

  @override
  String get onboardingChildSubtitle => '有名字或小名以及出生日期，就可以开始了。';

  @override
  String get onboardingChildName => '名字或小名';

  @override
  String get onboardingBirthday => '出生日期';

  @override
  String get onboardingBoy => '男孩';

  @override
  String get onboardingGirl => '女孩';

  @override
  String get onboardingAddChild => '添加其他孩子';

  @override
  String get onboardingPrivacyTitle => '家庭的私密空间';

  @override
  String get onboardingPrivacySubtitle => 'Baby Family 守护最珍贵的瞬间。';

  @override
  String get onboardingPrivacyInvited => '只有受邀者才能查看孩子的照片';

  @override
  String get onboardingPrivacyInvitedDescription => '没有公开页面，也无法搜索到你的家庭。';

  @override
  String get onboardingPrivacyUs => 'Papa & Mama 是你们的私密空间';

  @override
  String get onboardingPrivacyUsDescription => '心情、请求和私密日记，长辈都无法查看。';

  @override
  String get onboardingPrivacyData => '数据属于你';

  @override
  String get onboardingPrivacyDataDescription => '随时可在设置中下载或删除。';

  @override
  String get onboardingUnderstood => '明白了';

  @override
  String get onboardingNotificationsTitle => '不错过每个瞬间';

  @override
  String get onboardingNotificationsSubtitle =>
      '接收 Papa/Mama 的任务、宝宝新照片和帮助请求。在设置中管理类别和免打扰时段。';

  @override
  String get onboardingEnableNotifications => '开启通知';

  @override
  String get inviteTitle => '输入邀请码';

  @override
  String get inviteSubtitle => '8位邀请码在 Papa 或 Mama 发来的邀请消息中。';

  @override
  String get inviteView => '查看邀请';

  @override
  String get inviteScanQr => '扫描二维码';

  @override
  String get inviteUseDemo => '使用演示邀请码';

  @override
  String get inviteJoin => '加入家庭';

  @override
  String get inviteDecline => '拒绝';

  @override
  String get inviteRole => '你的角色';

  @override
  String get inviteAccepted => '已在演示版中接受邀请';

  @override
  String get inviteDeclined => '已在演示版中拒绝邀请';

  @override
  String get inviteInvalidTitle => '邀请已失效';

  @override
  String get inviteInvalidDescription => '请邀请人发送新的链接。';

  @override
  String get circleWaitingTitle => '需要家人邀请你加入家庭';

  @override
  String get circleWaitingSubtitle => 'Papa 或 Mama 邀请你后，就能查看孙辈的照片和第一次。';

  @override
  String get circleAskInvite => '请孩子邀请我';

  @override
  String get circleAskMessage => '我已经安装了 Baby Family，邀请我一起看看宝宝的成长吧。';

  @override
  String get circleSwitchRole => '我是孩子的 Papa/Mama';

  @override
  String get circleSignOut => '退出登录';

  @override
  String get authDemoDescription => '登录和权限操作使用示例数据进行模拟。';

  @override
  String get authDemoAction => '使用示例数据继续';

  @override
  String get onboardingFirstMemoryTitle => '家庭的第一段回忆';

  @override
  String get onboardingFirstMemorySubtitle => '在 Baby Family 留下宝宝的第一个瞬间。';

  @override
  String get onboardingFirstMemoryChoosePhoto => '选择照片';

  @override
  String get memoriesKeepsakes => '纪念品';

  @override
  String get memoriesBest => '家里最爱的照片';

  @override
  String get memoriesRecordedVoice => '示例录音已保存';

  @override
  String get familyRelationship => '这个人是…';

  @override
  String get familyCallName => '孩子的称呼';

  @override
  String get familyPhotosPermission => '查看照片与回忆';

  @override
  String get familyFirstsPermission => '点赞和评论';

  @override
  String get familyDownloadPermission => '添加照片';

  @override
  String get familyInvitePreview => '预览共享权限';

  @override
  String get familyHidden => 'Papa & Mama、任务及私密内容始终不共享。';

  @override
  String get familyCreateInvite => '创建邀请';

  @override
  String get familyInviteCreated => '示例邀请已创建，尚未向亲友发送消息。';

  @override
  String get billingMockNotice => '这是示例数据。方案选择、恢复购买和数据导出均为模拟操作。';

  @override
  String get billingSelected => '已在演示版中选择方案，没有产生交易。';

  @override
  String get billingRestored => '已模拟恢复购买。';

  @override
  String get billingExportReady => '已模拟数据导出请求，家庭回忆依然安全。';

  @override
  String get notificationsReadAll => '全部标为已读';

  @override
  String get circleGreeting => '家里的小宝贝';

  @override
  String get circleSendWish => '送上祝福';

  @override
  String get settingsDemoSection => '本部分的选项使用示例数据进行模拟。';

  @override
  String get usNeedSpace => '安静一会儿';

  @override
  String get usNeedTalk => '希望有人倾听';

  @override
  String get usBridgeAngry => '我有点生气';

  @override
  String get usBridgeStuck => '我不知道怎么开口';

  @override
  String get usBridgeHint => '说说你的感受和需要。可以先休息一下，准备好后再聊。';

  @override
  String get usThanksHint => '今天你想感谢对方什么？';

  @override
  String get usJournalHint => '写下此刻的想法。';

  @override
  String get usNeedHelp => '实际帮助';

  @override
  String get usBridgeEmotion => '我现在感到…';

  @override
  String get usBridgeAnger => '生气';

  @override
  String get usBridgePrivate => '只有你能看到在这里写下的内容';

  @override
  String get usBridgeDraft => '如果愿意，可以写一份私密草稿';

  @override
  String get usBridgeKeepPrivate => '保留私密';

  @override
  String get usBridgePause => '暂停';

  @override
  String get usThanksWall => '感谢墙';

  @override
  String get settingsDisplayTitle => '显示与语言';

  @override
  String get settingsOther => '其他';

  @override
  String get settingsReduceMotion => '减少动态效果';

  @override
  String get settingsReduceMotionHint => '减少动画';

  @override
  String get settingsLunarHint => '显示在公历日期旁';

  @override
  String get settingsDeleteAccount => '删除账户';

  @override
  String get familyManage => '管理家庭';

  @override
  String familyYou(String callName) {
    return '$callName（你）';
  }

  @override
  String get familyStorageLabel => '存储空间';

  @override
  String get familyViewPlans => '查看 House / Family 套餐';

  @override
  String get familyAddChild => '添加孩子／孕期';

  @override
  String get familyLockedTitle => '使用 Family 邀请祖父母';

  @override
  String get familyLockedDescription =>
      '试用期仅限 Papa & Mama。升级至 Family，让祖父母和亲友一起见证孩子成长。';

  @override
  String get familyFollowing => '可查看的孩子';

  @override
  String get relationPaternalGrandfather => '爷爷';

  @override
  String get relationPaternalGrandmother => '奶奶';

  @override
  String get relationMaternalGrandfather => '外公';

  @override
  String get relationMaternalGrandmother => '外婆';

  @override
  String get relationAunt => '姑姑／阿姨';

  @override
  String get relationUncle => '叔叔／伯伯';

  @override
  String get billingHouseChildren => 'Papa & Mama，孩子数量不限';

  @override
  String get billingHouseCare => '任务、日记与 Papa & Mama 空间';

  @override
  String get billingHouseStorage => '50 GB 存储空间';

  @override
  String get billingInviteRelatives => '邀请祖父母和亲友';

  @override
  String get billingFamilyIncludes => 'House 的所有功能';

  @override
  String get billingFamilyRelatives => '最多邀请 12 位亲友';

  @override
  String get billingFamilyStorage => '200 GB，原画质照片';

  @override
  String get billingFamilyVideos => '最长10分钟视频、祖父母简报';

  @override
  String get billingLegal =>
      '套餐适用于全家，Papa 或 Mama 均可付款。每年自动续订，可随时在 App Store / Google Play 设置中取消。条款 · 隐私';

  @override
  String get billingChoosePlans => '选择 House / Family';

  @override
  String get billingRetentionHint => '删除前我们会多次通知你。';

  @override
  String get circleTitle => '亲爱的孙辈';

  @override
  String get circleNewPhotos => '本周新照片';

  @override
  String get circleVoiceTip => '长按“发送祝福”录制语音';

  @override
  String get notificationsToday => '今天';

  @override
  String get notificationsYesterday => '昨天';

  @override
  String stateEmptyMemoryTitle(String name) {
    return '还没有 $name 的回忆';
  }

  @override
  String get stateEmptyMemoryDescription => '保存第一个瞬间吧——一张照片、一篇日记或孩子的笑声。';

  @override
  String get stateEmptyCareDescription => '选择几个小任务，让 Papa & Mama 一起分担。';

  @override
  String get stateErrorTitle => '暂时无法加载回忆';

  @override
  String get stateErrorDescription => '我们遇到了一个小问题。你的回忆依然安全，请稍后重试。';

  @override
  String get stateErrorCode => '错误：MEM-500 · 联系支持';

  @override
  String get splashTagline => '陪伴成长——珍藏爱意';

  @override
  String get splashPreparing => '正在准备你的家庭空间…';

  @override
  String get onboardingChildAvatarOptional => '添加头像（可选）';

  @override
  String get onboardingComplete => '完成';

  @override
  String get onboardingSkipGender => '跳过';

  @override
  String inviteJoinAsParent(String callName) {
    return '以 $callName 身份加入';
  }

  @override
  String get memoriesMilestones => '里程碑';

  @override
  String get memoriesAlbum => '相册';

  @override
  String get memoriesChooseAlbum => '选择相册';

  @override
  String get memoriesCaptionSuggestion => '文字建议';

  @override
  String get memoriesCover => '封面';

  @override
  String get memoriesVideo => '视频 [1.1]';

  @override
  String memoriesNextMonth(int month) {
    return '第 $month 月 · 明天';
  }

  @override
  String get memoriesPerspectivePrompt => '你对这个瞬间有什么回忆？';

  @override
  String get pregnancyHeight => '身长';

  @override
  String get pregnancyBabyBoy => '男孩';

  @override
  String get pregnancyBabyGirl => '女孩';

  @override
  String get pregnancyLater => '稍后';

  @override
  String get pregnancyBirthBag => '待产包';

  @override
  String get pregnancyDocuments => '证件';

  @override
  String get pregnancyNursery => '宝宝的小天地';

  @override
  String get pregnancySupport => '心理支持（可选）';

  @override
  String commonChildNameAge(String name, String age) {
    return '$name · $age';
  }

  @override
  String get homeEvening => '晚上好，';

  @override
  String get homeTomorrow => '明天';

  @override
  String get homeRecord => '记录';

  @override
  String get homeParentsPrivacy => 'Papa & Mama · 仅你们两人';

  @override
  String get homeHug => '抱一抱';

  @override
  String homeMomentCount(int count) {
    return '$count 个瞬间';
  }

  @override
  String homePhotoCount(int count) {
    return '$count 张照片';
  }

  @override
  String homeYourHearts(int count) {
    return '💗 我的 $count';
  }

  @override
  String homeMoreMissions(int count) {
    return '+ 我的 $count 项任务 · 💗 仅自己可见';
  }

  @override
  String get careTreeBloom => '全部完成，让树开花 🌸';

  @override
  String careMyHeartsToday(int count) {
    return '我今天的 Hearts：$count';
  }

  @override
  String get carePrivateHearts => '仅自己可见';

  @override
  String get homeOtherPrompt => '换个建议';

  @override
  String commonWeek(int week) {
    return '第 $week 周';
  }

  @override
  String homeChildToday(String name) {
    return '$name 的今天';
  }

  @override
  String get homeFirstsRecent => '最近的第一次';

  @override
  String homeChildMissions(String name) {
    return '今天照顾 $name 的任务';
  }

  @override
  String get homeCompare => '对比';

  @override
  String careSwapHeading(String title) {
    return '更换“$title”';
  }

  @override
  String get careSwapHint => '这些选项的 Hearts 相近，让两人的任务板保持平衡。';

  @override
  String careSwapRemaining(int count) {
    return '今天还可更换 $count 次';
  }

  @override
  String get careSwapConfirm => '换成这个任务';

  @override
  String careCompleteHearts(int count) {
    return '太棒了！为树增加 $count 💗';
  }

  @override
  String careCompleteHint(String title) {
    return '$title，树又多了一片叶子。（保存照片再加 2 💗）';
  }

  @override
  String get careSaveMemoryQuestion => '保存这个瞬间？';

  @override
  String get careMemoryCaption => '简单记录这个瞬间…';

  @override
  String get careSaveMission => '保存任务';

  @override
  String pregnancyNamesFor(String child) {
    return '为 $child 起名';
  }

  @override
  String pregnancyChooseNameFor(String name, String child) {
    return '选择“$name”作为 $child 的名字';
  }

  @override
  String get memoriesSavePerspective => '保存视角 · 两人共同讲述';

  @override
  String get circleViewComment => '查看与评论';

  @override
  String get homeStoryView => '以故事查看';

  @override
  String get homeCurrentChapter => '当前篇章';

  @override
  String get homeNextFirst => '下一个第一次？';

  @override
  String homeMonthShort(int month) {
    return '$month月';
  }

  @override
  String get homeMomentLabel => '瞬间';

  @override
  String get homeQuoteLabel => '新童言';

  @override
  String get commonFirsts => '第一次';

  @override
  String get circleLike => '点赞';

  @override
  String homeMonthlyProgress(int done, int total) {
    return '$done/$total 张照片';
  }

  @override
  String get stateAddMemory => '添加回忆';

  @override
  String get careCamera => '拍照';

  @override
  String get careGallery => '选择照片';

  @override
  String get carePhotoSelected => '已选照片';

  @override
  String get commonCamera => '相机';

  @override
  String get commonGallery => '图库';

  @override
  String get careForWho => '为谁？';

  @override
  String get careOneChild => '一个孩子';

  @override
  String get careManyChildren => '多个孩子';

  @override
  String get careBothParents => '我们俩';

  @override
  String get careWhenQuestion => '何时？';

  @override
  String get careWhoQuestion => '谁来做？';

  @override
  String get careMemoryPrompt => '完成时提示保存照片';

  @override
  String get careRemindBefore => '提前15分钟提醒';

  @override
  String careAskPartnerPrompt(String callName) {
    return '想请 $callName 帮忙？发送请求 →';
  }

  @override
  String get careTreeName => '绿树';

  @override
  String get careTreeGrows => '由 Papa & Mama 的爱心滋养';

  @override
  String get careTreeNearBloom => '即将开花 🌸';

  @override
  String get careTreeReward => '奖励：相册“樱花”主题';

  @override
  String get careTreeMoments => '照顾孩子的瞬间';

  @override
  String get careTreeTogether => '一起完成的次数';

  @override
  String get careTreeBloomDays => '开花的日子';

  @override
  String get careTreeYourContribution => '你的贡献';

  @override
  String get careTreeToday => '今天';

  @override
  String get careTreeWeek => '本周';

  @override
  String get careTreeTotal => '总计';

  @override
  String memoriesSelectedPhotos(int count) {
    return '已选择 $count 张照片';
  }

  @override
  String get usOnlyTwo => '只有你们两人可见';

  @override
  String usMe(String callName) {
    return '$callName（你）';
  }

  @override
  String usEnergyValue(int value) {
    return '精力 $value/5';
  }

  @override
  String get usHugShort => '拥抱';

  @override
  String get usDailyQuestionShort => '今天的问题';

  @override
  String get usBridgeShort => '沟通桥梁';

  @override
  String get usWeekShort => '我们的一周';

  @override
  String get usCheckinTitle => '你今天怎么样？';

  @override
  String get usEnergyShort => '精力';

  @override
  String get usNeedShort => '我需要…';

  @override
  String get usNeedRest => '休息';

  @override
  String get usNeedChildcare => '帮忙照顾孩子';

  @override
  String get usNeedQuiet => '安静';

  @override
  String get usNeedHug => '一个拥抱';

  @override
  String get usNeedConversation => '聊天';

  @override
  String get usNeedEncouragement => '鼓励';

  @override
  String get usOnlyMe => '仅自己';

  @override
  String usSendTo(String callName) {
    return '发送给 $callName';
  }

  @override
  String usRequestTo(String callName) {
    return '请 $callName 帮忙';
  }

  @override
  String usRequestGentle(String callName) {
    return '请求是邀请帮忙，$callName 可以随时说“今天不行”。';
  }

  @override
  String get usRequestOneThing => '请帮个忙';

  @override
  String get usRequestRest => '需要休息';

  @override
  String get usRequestWatchChild => '照看孩子';

  @override
  String get usRequestRestHint => '帮忙照看孩子';

  @override
  String get usRequestWatchHint => '一会儿';

  @override
  String get usRequestLibrary => '任务库';

  @override
  String get usRequestLibraryHint => '选择任务';

  @override
  String get usRequestCustom => '自己填写';

  @override
  String get usRequestCustomHint => '其他事情';

  @override
  String get usRequestDuration => '多久？';

  @override
  String get usRequestWhen => '何时？';

  @override
  String get usRequestWhichChild => '照看哪个孩子？';

  @override
  String usRequestMinutes(int minutes) {
    return '$minutes 分钟';
  }

  @override
  String get usRequestNow => '现在';

  @override
  String get usRequestTonight => '今晚';

  @override
  String get usRequestChooseTime => '选择时间';

  @override
  String get usRequestOtherChild => '两个孩子';

  @override
  String get usRequestNeeds => '或者我需要…（不计爱心）';

  @override
  String usRequestSendCount(String callName, int count) {
    return '发送给 $callName · $count/5 个未完成';
  }

  @override
  String usRequestFrom(String callName) {
    return '来自 $callName 的请求';
  }

  @override
  String usRequestBy(String callName) {
    return '$callName 请你帮忙';
  }

  @override
  String get usRequestSoon => '尽快哦';

  @override
  String get usRequestAcceptedTitle => '你已接受请求';

  @override
  String get usRequestReasonHint => '如果今天不行，可选择原因（可选）';

  @override
  String get usRequestReasonMeeting => '我在开会';

  @override
  String get usRequestReasonLate => '晚点回家';

  @override
  String get usRequestAccept => '接受——交给我吧';

  @override
  String get usRequestDecline => '今天不行';

  @override
  String usRequestDeclineNote(String callName) {
    return '拒绝不会扣分。$callName 会收到温和的通知。';
  }

  @override
  String usRequestSent(String callName) {
    return '$callName 已发送';
  }

  @override
  String get usRequestViewed => '你已查看';

  @override
  String get usRequestAcceptedShort => '你已接受';

  @override
  String get usRequestFinished => '已完成';

  @override
  String get usRequestFinish => '完成 ✓';

  @override
  String get commonCreateNew => '新建';

  @override
  String get switcherViewBy => '查看方式';

  @override
  String switcherPregnancy(int number, String name) {
    return '孕期 #$number · $name';
  }

  @override
  String get switcherAllDescription => '所有孩子和共同瞬间';

  @override
  String get familyManageChildren => '管理孩子';

  @override
  String careWeekday(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      'mon': '一',
      'tue': '二',
      'wed': '三',
      'thu': '四',
      'fri': '五',
      'sat': '六',
      'other': '日',
    });
    return '$_temp0';
  }

  @override
  String get notificationsFamily => '家庭';

  @override
  String get memoriesSaveQuote => '保存话语';

  @override
  String get pregnancyFirstPhoto => '宝宝的第一张照片';

  @override
  String get pregnancyFirstPhotoHint => '可选 · 保存为“出生”回忆';

  @override
  String get pregnancyCompleteAnnounce => '完成并报喜';

  @override
  String pregnancyWelcomeName(String name) {
    return '欢迎你，$name！';
  }

  @override
  String get pregnancyShort => '孕期';

  @override
  String get memoriesPerspectiveshort => '视角';

  @override
  String get pregnancyBumpWeeks => '每周孕照';

  @override
  String pregnancyFirstsFor(String child) {
    return '$child 的第一次';
  }

  @override
  String get pregnancyBabyLetter => '给宝宝的信';

  @override
  String get pregnancyBumpPhoto => '孕照';

  @override
  String usRequestHearts(int count) {
    return '完成后获得 +$count 💗（仅你可见）';
  }

  @override
  String usRequestReminder(String time) {
    return '$time 提醒我';
  }

  @override
  String get usRequestAcceptedBadge => '已接受';

  @override
  String get pregnancyPrepareBaby => '准备迎接宝宝';

  @override
  String get commonAll => '全部';

  @override
  String pregnancyCaptureWeek(int week) {
    return '拍摄第$week周的孕肚照';
  }

  @override
  String get memoriesMarkMilestone => '标记里程碑';

  @override
  String get careMine => '我';

  @override
  String get careTogether => '一起';

  @override
  String get careTodayShort => '今天';

  @override
  String get carePrivateContribution => '仅你可见';

  @override
  String usRequestRestTitle(int minutes, String child) {
    return '需要休息$minutes分钟，请帮忙照顾$child';
  }

  @override
  String usRequestWatchTitle(int minutes, String child) {
    return '帮忙照顾$child$minutes分钟';
  }

  @override
  String usRequestAllChildren(int count) {
    return '全部$count个孩子';
  }

  @override
  String usRequestMessagePreview(int minutes, String child) {
    return '“我需要休息大约$minutes分钟。可以帮我照顾$child吗？💛”';
  }

  @override
  String get quickCheckin => '状态签到';

  @override
  String get quickThanks => '感谢';

  @override
  String get careFinish => '完成';

  @override
  String carePartnerTab(String callName) {
    return '$callName的';
  }

  @override
  String get billingSupport => '支持';

  @override
  String get homeChildLetter => '给宝宝的信';

  @override
  String commonAgeDays(int days) {
    return '$days天';
  }

  @override
  String commonAgeMonths(int months) {
    return '$months个月';
  }

  @override
  String commonAgeMonthsDays(int months, int days) {
    return '$months个月$days天';
  }

  @override
  String commonAgeYears(int years) {
    return '$years岁';
  }

  @override
  String commonAgeYearsMonths(int years, int months) {
    return '$years岁$months个月';
  }

  @override
  String commonPregnancyWeekOnly(int week) {
    return '第$week周';
  }

  @override
  String commonPregnancyWeekDay(int week, int day) {
    return '第$week周+$day天';
  }

  @override
  String get commonScreenInProgress => '此页面正在按设计重建。';

  @override
  String get stateOfflineTitle => '当前离线';

  @override
  String stateOfflineSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '正在查看已保存的数据 · $count 条回忆等待上传',
      zero: '正在查看已保存的数据',
    );
    return '$_temp0';
  }

  @override
  String get commonPlay => '播放';

  @override
  String get commonPause => '暂停';

  @override
  String get commonMarkDone => '标记为完成';

  @override
  String get commonNotifications => '通知';

  @override
  String get commonComingSoon => '即将推出';

  @override
  String commonQuoted(String text) {
    return '“$text”';
  }

  @override
  String get commonTimeJustNow => '刚刚';

  @override
  String commonTimeMinutesAgo(int count) {
    return '$count 分钟前';
  }

  @override
  String commonTimeHoursAgo(int count) {
    return '$count 小时前';
  }

  @override
  String get commonTimeYesterday => '昨天';

  @override
  String commonTimeDaysAgo(int count) {
    return '$count 天前';
  }

  @override
  String usMoodLabel(String mood) {
    String _temp0 = intl.Intl.selectLogic(mood, {
      'ok': '还好',
      'normal': '一般',
      'tired': '累',
      'exhausted': '精疲力尽',
      'stressed': '有压力',
      'sad': '难过',
      'annoyed': '烦躁',
      'overwhelmed': '不堪重负',
      'lonely': '孤单',
      'missYou': '想你',
      'other': '还好',
    });
    return '$_temp0';
  }

  @override
  String usCheckinNeed(String need) {
    String _temp0 = intl.Intl.selectLogic(need, {
      'rest': '需要休息',
      'childcare': '需要帮忙带娃',
      'quiet': '需要安静',
      'hug': '需要一个拥抱',
      'talk': '想聊聊',
      'encouragement': '需要鼓励',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String usCheckinNeedMinutes(String need, int minutes) {
    return '$need $minutes 分钟';
  }

  @override
  String get usMoodNotShared => '尚未分享';

  @override
  String usReplySent(String callName) {
    return '已发送给 $callName 💛';
  }

  @override
  String get usSettingsTooltip => 'Papa & Mama 设置';

  @override
  String usOpenRequestWatch(String callName, String child, int minutes) {
    return '你请 $callName 照看 $child $minutes 分钟';
  }

  @override
  String usOpenRequestMine(String callName, String title) {
    return '你请 $callName：$title';
  }

  @override
  String usOpenRequestTheirs(String callName, String title) {
    return '$callName 请你：$title';
  }

  @override
  String usRequestStatusPartner(String status, String callName, String time) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'seen': '$callName 已查看 · $time',
      'accepted': '$callName 已接受 · $time',
      'done': '$callName 已完成 · $time',
      'declined': '$callName：今天不行',
      'other': '已发送 · $time',
    });
    return '$_temp0';
  }

  @override
  String usRequestStatusMine(String status, String time) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'accepted': '你已接受 · $time',
      'other': '等你回复 · $time',
    });
    return '$_temp0';
  }

  @override
  String get usDailyQuestionHintBoth => '两人都回答后才会看到彼此的答案。';

  @override
  String get usDailyQuestionYourAnswer => '你的回答';

  @override
  String usDailyQuestionAnswerBy(String callName, String answer) {
    return '$callName：$answer';
  }

  @override
  String usThanksByLine(String callName, String time) {
    return '$callName · $time';
  }

  @override
  String get usYou => '你';

  @override
  String usRequestRestMessage(int minutes, String child) {
    return '我需要休息大约 $minutes 分钟。你帮我照看一下 $child 好吗？💛';
  }

  @override
  String usRequestWatchMessage(int minutes, String child) {
    return '你帮我照看 $child 大约 $minutes 分钟好吗？💛';
  }

  @override
  String usRequestReasonBusyWith(String child) {
    return '正在照看 $child';
  }

  @override
  String usRequestYouAsked(String callName) {
    return '你请 $callName 帮忙';
  }

  @override
  String get usRequestMineTitle => '你的请求';

  @override
  String get usRequestYouSent => '你已发送';

  @override
  String usRequestPartnerViewed(String callName) {
    return '$callName 已查看';
  }

  @override
  String usRequestPartnerAccepted(String callName) {
    return '$callName 已接受';
  }

  @override
  String usRequestBadge(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'sent': '已发送',
      'seen': '已查看',
      'accepted': '已接受',
      'done': '已完成',
      'declined': '今天不行',
      'acknowledged': '已看到',
      'expired': '已过期',
      'cancelled': '已取消',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get usRequestCancel => '取消请求';

  @override
  String get usRequestThank => '说声谢谢';

  @override
  String get usRequestDoMyself => '我自己来';

  @override
  String get usRequestSendHug => '发送 🤗';

  @override
  String usThanksTitle(String callName) {
    return '感谢 $callName';
  }

  @override
  String get usThanksSamples => '推荐语句';

  @override
  String get usThanksSample1 => '谢谢你帮我照看孩子 💛';

  @override
  String get usThanksSample2 => '谢谢你今天陪着我';

  @override
  String get usThanksSample3 => '有你在，一切都轻松多了';

  @override
  String get usThanksSticker => '贴纸';

  @override
  String get usThanksPostFamily => '建议发布为家庭时刻';

  @override
  String usThanksPostFamilyHint(String callName) {
    return '需要 $callName 同意';
  }

  @override
  String usThanksSent(String callName) {
    return '已向 $callName 发送感谢 💛';
  }

  @override
  String get careTreeBloomed => '今天我们家把孩子照顾得圆圆满满 🌸';

  @override
  String careOpenRequestFromPartner(int count, String callName, String title) {
    return '$count 个进行中的请求 · $callName请你：$title';
  }

  @override
  String careOpenRequestToPartner(int count, String callName, String title) {
    return '$count 个进行中的请求 · 你请$callName：$title';
  }

  @override
  String get careMetaSuggested => '今日推荐';

  @override
  String get careMetaCustom => '自己添加';

  @override
  String careMetaHearts(int count) {
    return '+$count 💗';
  }

  @override
  String careMetaDoneAt(String time) {
    return '$time 已完成';
  }

  @override
  String carePartnerDoneAt(String time) {
    return '$time 完成';
  }

  @override
  String careCategory(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'care': '照护',
      'bonding': '亲子',
      'outing': '外出',
      'memory': '留念',
      'support': '支持伴侣',
      'self': '照顾自己',
      'together': '全家',
      'couple': '我们俩',
      'other': '自定义',
    });
    return '$_temp0';
  }

  @override
  String careDurationMin(int minutes) {
    return '$minutes 分钟';
  }

  @override
  String carePartnerNote(String callName) {
    return '你只能看到$callName完成了哪些事。$callName的 Hearts 只有$callName自己能看到。';
  }

  @override
  String carePartnerAllDone(String callName, int count) {
    return '$callName今天的 $count 件事都完成了';
  }

  @override
  String get careThank => '感谢';

  @override
  String get careThanked => '已感谢';

  @override
  String get careDoneTogether => '一起完成';

  @override
  String get careMineEmpty => '你今天还没有任务';

  @override
  String carePartnerEmpty(String callName) {
    return '$callName今天还没有任务';
  }

  @override
  String get careTogetherEmpty => '今天还没有一起做的事';

  @override
  String careDoneSnack(String title) {
    return '已完成“$title”';
  }

  @override
  String careSuggestFor(String name, String age) {
    return '给$name的建议 · $age';
  }

  @override
  String get careSuggestToday => '今日建议';

  @override
  String careCompleteDesc(String title, int photoHearts) {
    return '$title · 今天的树多了一片叶子 🍃（存照片再 +$photoHearts 💗）';
  }

  @override
  String get careNoteHint => '备注（可选）…';

  @override
  String get careLibraryLink => '任务库';

  @override
  String get careLibraryTitle => '任务库';

  @override
  String get careTitleHint => '做什么？';

  @override
  String get careTomorrow => '明天';

  @override
  String careRepeatOption(String repeat) {
    String _temp0 = intl.Intl.selectLogic(repeat, {
      'daily': '每天',
      'weekdays': '工作日',
      'weekends': '周末',
      'other': '不重复',
    });
    return '$_temp0';
  }

  @override
  String careReminderOption(String reminder) {
    String _temp0 = intl.Intl.selectLogic(reminder, {
      'atTime': '准时提醒',
      'before15': '提前15分钟提醒',
      'before30': '提前30分钟提醒',
      'before60': '提前60分钟提醒',
      'other': '不提醒',
    });
    return '$_temp0';
  }

  @override
  String get careTimeAny => '任意时间';

  @override
  String careTreeNextLevel(String name) {
    return '快到$name了 🌸';
  }

  @override
  String careTreeRewardLabel(String reward) {
    return '奖励：$reward';
  }

  @override
  String careTreePercent(int percent) {
    return '$percent%';
  }

  @override
  String get careTreeContributionTitle => '你的贡献 🔒 仅你可见';

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
    return '一起 · $day';
  }

  @override
  String get careYesterday => '昨天';

  @override
  String careWeekdayLong(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      'mon': '星期一',
      'tue': '星期二',
      'wed': '星期三',
      'thu': '星期四',
      'fri': '星期五',
      'sat': '星期六',
      'other': '星期日',
    });
    return '$_temp0';
  }

  @override
  String get careDetailTitle => '任务详情';

  @override
  String get careComplete => '完成';

  @override
  String get careOwnerLabel => '执行人';

  @override
  String get careChildLabel => '给孩子';

  @override
  String get careTimeLabel => '时间';

  @override
  String get careMissionNotFound => '找不到这个任务';

  @override
  String get careSwapAction => '换一件事';

  @override
  String get commonJustNow => '刚刚';

  @override
  String commonMinutesAgo(int count) {
    return '$count 分钟前';
  }

  @override
  String commonHoursAgo(int count) {
    return '$count 小时前';
  }

  @override
  String commonDaysAgo(int count) {
    return '$count 天前';
  }

  @override
  String famTrialSubtitle(int days, String date) {
    return '剩余 $days 天 · $date 到期';
  }

  @override
  String famStorageUsage(String used, String total) {
    return '$used GB / $total GB';
  }

  @override
  String get famPlanHouse => 'House 套餐';

  @override
  String get famPlanFamily => 'Family 套餐';

  @override
  String famPlanRenews(String date) {
    return '$date 续订';
  }

  @override
  String get famRoleFather => '爸爸';

  @override
  String get famRoleMother => '妈妈';

  @override
  String famPregnancySubtitle(int week, String date) {
    return '孕 $week 周 · 预产期 $date';
  }

  @override
  String get famRelativePending => '等待加入';

  @override
  String get famRelationOther => '其他…';

  @override
  String famInviteSlots(int used, int max) {
    return 'Family 套餐 · 已使用 $used/$max 个亲属名额';
  }

  @override
  String famPregnancyChild(String name) {
    return '$name（孕期）';
  }

  @override
  String get famPhotosPermissionHint => '“全家”可见';

  @override
  String get famCommentPermissionHint => '给孩子送上祝福';

  @override
  String get famPostPermissionHint => 'Papa/Mama 审核后显示';

  @override
  String get famInviteNote => '亲属看不到 Papa & Mama 空间和私密内容。';

  @override
  String famInviteShared(String callName, String link) {
    return '已为$callName创建邀请：$link';
  }

  @override
  String subTrialLeft(int days) {
    return '试用还剩 $days 天';
  }

  @override
  String subBuy(String plan, String price) {
    return '升级 $plan · $price';
  }

  @override
  String get subCurrentPlan => '当前套餐';

  @override
  String subPurchased(String plan) {
    return '全家已升级到 $plan 🎉';
  }

  @override
  String get subRestoreNone => '暂未找到可恢复的购买。';

  @override
  String subExpiredStats(int memories, int firsts, String names) {
    return '全家已保存 $memories 个回忆和 $names 的 $firsts 个第一次。一切都很安全——升级后全家可以继续记录孩子们的成长。';
  }

  @override
  String subRetentionTitle(String date) {
    return '数据保留至 $date';
  }

  @override
  String get subExportStarted => '正在准备数据，可以下载时会通知你。';

  @override
  String setProfileSubtitle(String callName, String family) {
    return '$callName · $family';
  }

  @override
  String setAiQuota(int remaining, int total) {
    return '$remaining/$total 次';
  }

  @override
  String get setPlanTrial => '试用';

  @override
  String get setPlanExpired => '已到期';

  @override
  String setVersion(String version) {
    return 'v$version';
  }

  @override
  String setTextPreview(String name) {
    return '$name刚达成新里程碑：能自己坐稳了 🎉';
  }

  @override
  String cirHello(String callName) {
    return '$callName，您好';
  }

  @override
  String cirTitle(String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': '奶奶的宝贝孙儿',
      'grandpa': '爷爷的宝贝孙儿',
      'other': '全家的宝贝',
    });
    return '$_temp0';
  }

  @override
  String cirHeroCaption(String text, String author, String time) {
    return '“$text” —— $author，$time';
  }

  @override
  String cirLiked(String name) {
    return '已给$name点赞 💛';
  }

  @override
  String cirWishHint(String name) {
    return '给$name写句祝福…';
  }

  @override
  String get cirWishSend => '发送';

  @override
  String cirWishSent(String name) {
    return '已给$name送上祝福';
  }

  @override
  String cirEmpty(String callName) {
    return 'Papa & Mama 还没有发新照片。有新照片时会通知$callName。';
  }

  @override
  String pregJourneyTitle(String child) {
    return '$child的孕期旅程';
  }

  @override
  String pregJourneyStats(int days, int memories, int firsts) {
    return '还有$days天 · $memories个回忆 · $firsts个第一次';
  }

  @override
  String get pregWeekThis => '本周';

  @override
  String get pregWeekFirsts => '第一次';

  @override
  String pregBumpGhostHint(int week) {
    return '有第$week周的半透明参考，保持相同角度';
  }

  @override
  String pregWeekDayShort(int week, int day) {
    return '第$week周+$day';
  }

  @override
  String pregPostedBy(String callName) {
    return '$callName发布';
  }

  @override
  String pregUltrasoundWeek(int week) {
    return 'B超 · 第$week周';
  }

  @override
  String pregQuoted(String text) {
    return '“$text”';
  }

  @override
  String get pregFirstLabel => '第一次';

  @override
  String get pregMilestoneLater => '宝宝出生后将成为里程碑';

  @override
  String get pregMenuEdit => '编辑孕期';

  @override
  String get pregMenuArchive => '归档';

  @override
  String pregBumpCompare(int from, int to) {
    return '对比 · 第$from周 → 第$to周';
  }

  @override
  String pregWeekShort(int week) {
    return '$week周';
  }

  @override
  String pregWeekCapture(int week) {
    return '$week周 · 拍摄';
  }

  @override
  String get pregUltrasoundAdd => '添加B超照片';

  @override
  String get pregUltrasoundEmpty => '还没有B超照片';

  @override
  String get pregUltrasoundEmptyHint => '按孕周保存B超照片并附上留言。';

  @override
  String pregDaysLeft(int days) {
    return '还有$days天';
  }

  @override
  String get pregGroupBag => '待产包';

  @override
  String get pregGroupPapers => '证件';

  @override
  String get pregGroupNursery => '宝宝角落';

  @override
  String get pregGroupHealth => '健康';

  @override
  String pregOwnerRequested(String callName) {
    return '已拜托$callName';
  }

  @override
  String pregOwnerAsk(String callName) {
    return '拜托$callName';
  }

  @override
  String get pregOwnerTitle => '谁来负责这一项？';

  @override
  String get pregBirthCountTitle => '恭喜全家！有几个宝宝？';

  @override
  String pregBirthBabyCount(int count) {
    return '$count个宝宝';
  }

  @override
  String get pregBirthWelcomeTitle => '欢迎宝宝来到我们家 🎉';

  @override
  String pregBirthBabyIndex(int index, int count) {
    return '宝宝$index/$count · 信息随时可修改';
  }

  @override
  String pregBirthNameValue(String name, String nickname) {
    return '$name（$nickname）';
  }

  @override
  String get pregBirthWeightLabel => '体重（仅保存）';

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
    return '$family欢迎你';
  }

  @override
  String pregBirthWelcomeName(String name) {
    return '欢迎$name！💜';
  }

  @override
  String pregBirthNickname(String nickname) {
    return '全家的“$nickname”';
  }

  @override
  String pregBirthNicknameSiblings(String nickname, String siblings) {
    return '全家的“$nickname” · $siblings的弟弟妹妹';
  }

  @override
  String pregNamesAnd(String first, String last) {
    return '$first和$last';
  }

  @override
  String pregBirthAnnounceNote(String child) {
    return '仅限已共享孕期的亲人。孕期回忆将成为$child的第一章。';
  }

  @override
  String get pregBirthDone => '完成并报喜 🎉';

  @override
  String pregArchiveTitle(String child) {
    return '归档$child的旅程';
  }

  @override
  String get pregNamesBothLike => '两人都喜欢 💞';

  @override
  String pregNamesAddedBy(String callName) {
    return '$callName添加';
  }

  @override
  String pregNamesLikeBy(String callName) {
    return '$callName喜欢';
  }

  @override
  String get authNameHint => '输入姓名';

  @override
  String authResendIn(String time) {
    return '$time 后重新发送';
  }

  @override
  String authCountryCodeSemantics(String code) {
    return '国家代码 $code';
  }

  @override
  String get authChangeAvatar => '选择头像';

  @override
  String onbFamilyDefaultName(String name) {
    return '$name的家';
  }

  @override
  String onbMemberLabel(String callName, String name) {
    return '$callName $name';
  }

  @override
  String onbFamilyCoverWaiting(String member, String partnerCallName) {
    return '$member · 正在等待$partnerCallName';
  }

  @override
  String get onbFamilySuggestion1 => '番茄之家';

  @override
  String get onbFamilySuggestion2 => '温馨小窝';

  @override
  String get onbFamilySuggestion3 => '我们的家';

  @override
  String get onbChangeCover => '更换封面';

  @override
  String onbInviteSubtitle(String callName, int days) {
    return 'Baby Family 需要 Papa 和 Mama 一起加入。$callName 加入后，全家开始 $days 天免费试用。';
  }

  @override
  String onbInviteApproval(String callName) {
    return '$callName 加入时由我最终确认';
  }

  @override
  String onbInviteShareMessage(String code, String link) {
    return '来 Baby Family 和我一起记录孩子的成长吧！邀请码：$code · $link';
  }

  @override
  String onbWaitingSubtitle(String callName, int days) {
    return '$callName 接受邀请后，家庭将解锁并开始 $days 天免费试用。';
  }

  @override
  String onbWaitingSentAt(String time) {
    return '邀请已于 $time 发送';
  }

  @override
  String onbWaitingOpened(String callName) {
    return '$callName 已打开邀请链接';
  }

  @override
  String onbWaitingExpires(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 天后过期',
      zero: '今天过期',
    );
    return '$_temp0';
  }

  @override
  String get onbCancelFamilyMessage => '你将返回选择角色的步骤，已发送的邀请将失效。';

  @override
  String onbTrialUntil(String date) {
    return '至 $date · 无需绑定银行卡';
  }

  @override
  String onbTrialAfter(String housePrice, String familyPrice) {
    return '之后选择 House（$housePrice）或 Family（$familyPrice）套餐继续使用。';
  }

  @override
  String onbStageSubtitle(String first, String second) {
    return '$first和$second可以随时添加其他宝宝或孕期。';
  }

  @override
  String get onbStageBothDescription => '宝宝档案与孕期在同一个家庭中并行';

  @override
  String get onbNicknameIdea1 => '豆豆';

  @override
  String get onbNicknameIdea2 => '番茄';

  @override
  String get onbNicknameIdea3 => '菠萝蜜';

  @override
  String get onbNicknameIdea4 => '松鼠';

  @override
  String onbMeetCountdown(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '还有 $count 天见到$name',
      zero: '今天见到$name',
    );
    return '$_temp0';
  }

  @override
  String get onbKnowDueDate => '我知道预产期';

  @override
  String onbWeekValue(int week) {
    return '第 $week 周';
  }

  @override
  String onbNotifMeta(String time) {
    return 'Baby Family · $time';
  }

  @override
  String get onbNotifNow => '刚刚';

  @override
  String get onbNotif5Minutes => '5 分钟前';

  @override
  String get onbNotif1Hour => '1 小时前';

  @override
  String onbNotifRequestTitle(String sender, String receiver, String child) {
    return '$sender 请 $receiver：今晚给$child洗澡';
  }

  @override
  String get onbNotifRequestBody => '一键接受或建议其他时间。';

  @override
  String onbNotifPhotosTitle(String child) {
    return '今天有 3 张$child的新照片';
  }

  @override
  String get onbNotifPhotosBody => '奶奶给 2 张照片点了爱心。';

  @override
  String get onbNotifUsTitle => '你有来自 Papa & Mama 的新动态';

  @override
  String get onbNotifUsBody => '私密内容在锁屏上隐藏。';

  @override
  String get onbNotifChildFallback => '宝宝';

  @override
  String onbFirstMemorySubtitle(String name) {
    return '在 Baby Family 保存$name的第一个瞬间。';
  }

  @override
  String invInviterParent(String name, String callName) {
    return '$name（$callName）邀请你加入';
  }

  @override
  String invInviterRelative(String name, String callName, String pronoun) {
    return '$name（$callName）邀请$pronoun关注孙辈';
  }

  @override
  String invQuotedMessage(String message) {
    return '“$message”';
  }

  @override
  String invRoleParent(String callName) {
    return '你的角色：孩子们的$callName';
  }

  @override
  String invRoleRelative(String callName, String permission) {
    return '$callName · $permission';
  }

  @override
  String invPronoun(String relation) {
    String _temp0 = intl.Intl.selectLogic(relation, {
      'grandmaPaternal': '奶奶',
      'grandmaMaternal': '外婆',
      'grandpaPaternal': '爷爷',
      'grandpaMaternal': '外公',
      'other': '你',
    });
    return '$_temp0';
  }

  @override
  String invPronounTitle(String relation) {
    String _temp0 = intl.Intl.selectLogic(relation, {
      'grandmaPaternal': '奶奶',
      'grandmaMaternal': '外婆',
      'grandpaPaternal': '爷爷',
      'grandpaMaternal': '外公',
      'other': '你',
    });
    return '$_temp0';
  }

  @override
  String get invParentSees => '你将看到：回忆、任务、Papa & Mama';

  @override
  String invParentManage(String callName) {
    return '与$callName一起管理家庭并邀请亲人';
  }

  @override
  String invParentApproval(String member) {
    return '你加入时$member将最终确认';
  }

  @override
  String invRelativeSees(String pronoun, String names) {
    return '$pronoun将看到：$names的照片、视频和第一次';
  }

  @override
  String invRelativeHiddenChildren(String pronoun, String names) {
    return '$pronoun不会看到：$names、Papa & Mama、任务';
  }

  @override
  String invRelativeHidden(String pronoun) {
    return '$pronoun不会看到：Papa & Mama、任务';
  }

  @override
  String invRelativeApproval(String pronoun) {
    return '$pronoun发布的照片需经 Papa/Mama 审核后显示';
  }

  @override
  String get invViewOnly => '仅查看';

  @override
  String get homeMorning => '早上好，';

  @override
  String get homeAfternoon => '下午好，';

  @override
  String homeGreetingName(String callName, String name, String emoji) {
    return '$callName $name $emoji';
  }

  @override
  String get homeMonthlyToday => '今天';

  @override
  String homeMonthlyInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '还有 $count 天',
    );
    return '$_temp0';
  }

  @override
  String homeMonthlyTurns(String name, int months) {
    return '$name 满 $months 个月啦 🎉';
  }

  @override
  String homeMonthlyPrepare(int done, int total) {
    return '准备拍月照 — 已有 $done/$total 张';
  }

  @override
  String homeMoodTitle(String callName, String mood) {
    String _temp0 = intl.Intl.selectLogic(mood, {
      'ok': '还不错',
      'normal': '一般',
      'tired': '有点累',
      'exhausted': '累坏了',
      'stressed': '压力很大',
      'sad': '有点难过',
      'annoyed': '有点烦',
      'overwhelmed': '不堪重负',
      'lonely': '觉得孤单',
      'missYou': '想你了',
      'other': '已打卡',
    });
    return '$callName$_temp0';
  }

  @override
  String homeNeedLabel(String need) {
    String _temp0 = intl.Intl.selectLogic(need, {
      'rest': '需要休息',
      'childcare': '需要帮忙带孩子',
      'quiet': '需要安静一下',
      'hug': '需要一个拥抱',
      'talk': '想聊聊',
      'encouragement': '需要鼓励',
      'other': '需要支持',
    });
    return '$_temp0';
  }

  @override
  String homeNeedMinutes(String need, int minutes) {
    return '$need约 $minutes 分钟';
  }

  @override
  String homeFamilyProgress(int done, int total) {
    return '全家 $done/$total 项任务';
  }

  @override
  String homePromptKicker(String name, String age) {
    return '记录建议 · $name $age';
  }

  @override
  String homeFeedAddedPhotos(String callName, int count, String name) {
    return '$callName 刚添加了 $count 张 $name 的照片';
  }

  @override
  String homeMorePhotos(int count) {
    return '+$count';
  }

  @override
  String homeRecordedBy(String callName, String time) {
    return '$callName 记录于$time';
  }

  @override
  String homeReactedBy(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$name 和其他 $count 人',
      zero: '$name',
    );
    return '$_temp0';
  }

  @override
  String homePostedBy(String callName) {
    return '$callName 发布';
  }

  @override
  String homePerspectiveQuote(String callName, String text) {
    return '$callName 说：“$text”';
  }

  @override
  String homeTreeProgress(String name, int percent, String next) {
    return '$name · 距离$next还差 $percent% 🌸';
  }

  @override
  String homeChildBorn(String age, String date) {
    return '$age · 生于 $date';
  }

  @override
  String homeChildBornLunar(String age, String date, int day, int month) {
    return '$age · 生于 $date（农历$month月$day日）';
  }

  @override
  String homeChildCountdown(int count, int months) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '还有 $count 天满 $months 个月',
      zero: '今天满 $months 个月',
    );
    return '$_temp0';
  }

  @override
  String homeMonthlySlot(int month) {
    return '第$month个月照片';
  }

  @override
  String homeChapterTitle(int month, String name) {
    return '$name的第$month个月';
  }

  @override
  String homeChapterStats(int memories, int firsts, int voices) {
    return '$memories 条回忆 · $firsts 个第一次 · $voices 段录音';
  }

  @override
  String get homeMonthlyGrowth => '每月的成长';

  @override
  String homeTrimester(int number) {
    return '孕$number期';
  }

  @override
  String homeDaysToMeet(int count, String name) {
    return '还有 $count 天见到$name 💜';
  }

  @override
  String homeDueDate(String date) {
    return '预产期 $date';
  }

  @override
  String homeFetalSize(String name, String fruit, int cm) {
    return '本周$name大约像$fruit那么大 · 约 $cm 厘米';
  }

  @override
  String get homeReference => '仅供参考';

  @override
  String get homeCapture => '拍摄';

  @override
  String homeWeekShort(int week) {
    return '第$week周';
  }

  @override
  String homeBothTellWeek(int week) {
    return '两人一起讲 · 第$week周';
  }

  @override
  String homeProgressCount(int done, int total) {
    return '$done/$total';
  }

  @override
  String homeNamesSummary(int count, int liked) {
    return '$count 个备选名字 · $liked 个两人都喜欢 💞';
  }

  @override
  String switcherPregnancyLabel(String name, int week) {
    return '$name · 第$week周';
  }

  @override
  String get commonLastNight => '昨晚';

  @override
  String get commonYesterdayLower => '昨天';

  @override
  String commonDotJoin(String first, String second) {
    return '$first · $second';
  }

  @override
  String commonNamesAnd(String first, String second) {
    return '$first 和 $second';
  }

  @override
  String commonMissionCategory(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'care': '照顾',
      'bonding': '亲子',
      'outing': '出游',
      'memory': '回忆',
      'support': '支持',
      'self': '自我关照',
      'together': '一起',
      'couple': '我们俩',
      'custom': '自定义',
      'other': '任务',
    });
    return '$_temp0';
  }

  @override
  String get commonSuggestedToday => '今日推荐';

  @override
  String commonHeartsPlus(int count) {
    return '+$count 💗';
  }

  @override
  String get memJustNow => '刚刚';

  @override
  String memMinutesAgo(int count) {
    return '$count 分钟前';
  }

  @override
  String memHoursAgo(int count) {
    return '$count 小时前';
  }

  @override
  String get memYesterday => '昨天';

  @override
  String get memTodayLower => '今天';

  @override
  String memTodayAt(String time) {
    return '今天 $time';
  }

  @override
  String memYesterdayAt(String time) {
    return '昨天 $time';
  }

  @override
  String memDateAt(String date, String time) {
    return '$date $time';
  }

  @override
  String get memSearch => '搜索回忆';

  @override
  String get memFilterVoice => '录音';

  @override
  String memChildStats(int memories, int firsts, int voices) {
    return '$memories 条回忆 · $firsts 个第一次 · $voices 段录音';
  }

  @override
  String memChapterRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String memChapterCurrent(String range) {
    return '$range · 进行中';
  }

  @override
  String memChapterTitle(int month, String name) {
    return '$name的第 $month 个月';
  }

  @override
  String memChapterStats(int memories, int firsts, int voices) {
    return '$memories 条回忆 · $firsts 个第一次 · $voices 段录音';
  }

  @override
  String memChapterStatsMonthly(int memories, int firsts) {
    return '$memories 条回忆 · $firsts 个第一次 · 月照 ✓';
  }

  @override
  String get memChapterReplay => '回顾这个月';

  @override
  String memDueIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '还有 $days 天',
      one: '明天',
      zero: '今天',
    );
    return '$_temp0';
  }

  @override
  String memMonthlyNextIn(int days, int month) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '第 $month 个月 · 还有 $days 天',
      one: '第 $month 个月 · 明天',
      zero: '第 $month 个月 · 今天',
    );
    return '$_temp0';
  }

  @override
  String memCardMeta(String children, String author, String time) {
    return '$children · $author 发布 · $time';
  }

  @override
  String memBothTellPreview(String callName, String text) {
    return '$callName 说：“$text”';
  }

  @override
  String memQuotedBy(String body, String author) {
    return '“$body” · $author';
  }

  @override
  String get memFirstTime => '第一次';

  @override
  String memFirstMeta(String age, String who) {
    return '$age · $who';
  }

  @override
  String memBothParentsTell(String first, String second) {
    return '$first 和 $second 一起讲述';
  }

  @override
  String memAuthorTells(String callName) {
    return '$callName 讲述';
  }

  @override
  String memQuoteMeta(String name, String age, String callName, String when) {
    return '$name · $age · $callName 记录于$when';
  }

  @override
  String memLetterSealed(String date) {
    return '封存至 $date';
  }

  @override
  String memCollMonthly(String name, int count, int total) {
    return '$name · $count/$total 张';
  }

  @override
  String memCollFirsts(int count) {
    return '$count 个里程碑';
  }

  @override
  String memCollQuotes(String name, int count) {
    return '$name · $count 句';
  }

  @override
  String memCollVoices(int count) {
    return '$count 段录音';
  }

  @override
  String memCollLetters(int count, int sealed) {
    return '$count 封信 · $sealed 封封存';
  }

  @override
  String memCollBest(int count) {
    return '两人都喜欢 · $count';
  }

  @override
  String memCollKeepsakes(int count) {
    return '$count 件物品';
  }

  @override
  String get memComposerDiary => '写日记';

  @override
  String get memComposerMilestone => '记录里程碑';

  @override
  String get memComposerVoice => '新录音';

  @override
  String get memComposerKeepsake => '新纪念品';

  @override
  String memComposerMonthly(int month, String name) {
    return '第 $month 个月照片 · $name';
  }

  @override
  String memAudienceRelatives(int count) {
    return '全家 · $count 位亲人';
  }

  @override
  String memAudiencePeople(int count) {
    return '全家 · $count 人';
  }

  @override
  String get memChooseMilestone => '选择里程碑';

  @override
  String get memDiaryTitleHint => '日记标题';

  @override
  String get memDiaryBodyHint => '今天我们家怎么样？';

  @override
  String get memLetterTo => '写给';

  @override
  String get memLetterBodyHint => '亲爱的宝贝，爸爸妈妈想告诉你……';

  @override
  String get memLetterOpenDate => '约定开启日期';

  @override
  String get memLetterOpenNone => '不设置';

  @override
  String get memVoiceTapToRecord => '点击录音';

  @override
  String memVoiceRecorded(String duration) {
    return '已录音 · $duration';
  }

  @override
  String get memKeepsakeTitleHint => '纪念品名称';

  @override
  String get memKeepsakeHint => '这件物品的故事……';

  @override
  String get memVisibilityFamilyTag => '👨‍👩‍👧‍👦 全家';

  @override
  String get memVisibilityParentsTag => '👫 仅爸爸妈妈';

  @override
  String get memVisibilityOnlyMeTag => '🔒 仅自己';

  @override
  String memSecondPerspective(String time) {
    return '第二视角 · $time';
  }

  @override
  String memCommentsCount(int count) {
    return '评论（$count）';
  }

  @override
  String get memMenuFavorite => '收藏';

  @override
  String get memMenuUnfavorite => '取消收藏';

  @override
  String get memEditPerspective => '编辑你的视角';

  @override
  String get memMoreActions => '更多操作';

  @override
  String get memPregnancyAlbum => '孕期';

  @override
  String memMonthCell(int month) {
    return '第 $month 个月';
  }

  @override
  String memGhostToggle(int month, int percent) {
    return '第 $month 个月虚影 · $percent%';
  }

  @override
  String get memStickerNone => '无';

  @override
  String get memFlipCamera => '切换镜头';

  @override
  String get memBrightness => '亮度';

  @override
  String memQuoteAge(String name, String age, String when) {
    return '— $name，$age · $when';
  }

  @override
  String get memQuoteContextLabel => '孩子什么时候说的？（可选）';

  @override
  String get memQuoteContextHint => '傍晚散步时，抬头看天';

  @override
  String memOriginalTag(String callName, String when) {
    return '$callName 讲述 · $when';
  }

  @override
  String memInheritedAudience(String audience) {
    return '查看者与原回忆相同：$audience';
  }

  @override
  String memStoryMeta(String callName, String time, int index, int total) {
    return '$callName 发布 · $time · $index/$total';
  }

  @override
  String memStoryReply(String callName) {
    return '回复 $callName…';
  }

  @override
  String get memFirstsTitle => '第一次';

  @override
  String get memFirstsHideMissing => '隐藏未记录的里程碑';

  @override
  String get memFirstsAdd => '点击记录';

  @override
  String get homeOpenFamily => '我们家';

  @override
  String get homeChangeCover => '更换封面';

  @override
  String get authCodeResent => '验证码已重新发送';

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
    return '农历$month月$day日';
  }

  @override
  String commonAgeDaysOld(int days) {
    return '出生$days天';
  }

  @override
  String commonAgeWeeks(int weeks) {
    return '$weeks周';
  }

  @override
  String commonAgeWeeksDays(int weeks, int days) {
    return '$weeks周$days天';
  }

  @override
  String get memAlbumDetailTitle => '相册详情';

  @override
  String get memPhotoViewerTitle => '查看照片';

  @override
  String get memVideoPlay => '播放视频';

  @override
  String get memVideoPause => '暂停视频';

  @override
  String get memSearchTitle => '搜索';

  @override
  String get memOnThisDayTitle => '那年今日';

  @override
  String get recapWeekTitle => '我们家的一周';

  @override
  String recapWeekHeadline(int moments, int firsts) {
    String _temp0 = intl.Intl.pluralLogic(
      moments,
      locale: localeName,
      other: '$moments 个瞬间',
      zero: '平静的一周',
    );
    String _temp1 = intl.Intl.pluralLogic(
      firsts,
      locale: localeName,
      other: ' · $firsts 个第一次',
      zero: '',
    );
    return '$_temp0$_temp1';
  }

  @override
  String get calendarTitle => '日历';

  @override
  String get calendarCreateEvent => '创建活动';

  @override
  String get careHistoryTitle => '历史';

  @override
  String get careBadgesTitle => '我们家的徽章';

  @override
  String get careSettingsTitle => '任务设置';

  @override
  String get childProfileTitle => '宝宝档案';

  @override
  String get childEditTitle => '编辑宝宝档案';

  @override
  String get childAddTitle => '添加宝宝';

  @override
  String get familyRelativeDetailTitle => '亲人详情';

  @override
  String get familySettingsTitle => '家庭设置';

  @override
  String get settingsProfileTitle => '个人资料';

  @override
  String memoriesYearOrdinal(String year) {
    String _temp0 = intl.Intl.selectLogic(year, {
      '1': '第一年',
      '2': '第二年',
      '3': '第三年',
      'other': '第$year年',
    });
    return '$_temp0';
  }

  @override
  String careWeekdayTitle(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      'mon': '星期一',
      'tue': '星期二',
      'wed': '星期三',
      'thu': '星期四',
      'fri': '星期五',
      'sat': '星期六',
      'other': '星期日',
    });
    return '$_temp0';
  }

  @override
  String calendarDayTitle(String weekday, String date) {
    return '$weekday，$date';
  }

  @override
  String calendarMonthYear(String month, String year) {
    return '$year年$month月';
  }

  @override
  String get calendarModeWeek => '周';

  @override
  String get calendarModeMonth => '月';

  @override
  String get calendarLegendMission => '任务';

  @override
  String get calendarLegendEvent => '事件';

  @override
  String get calendarLegendCouple => '我们俩';

  @override
  String get calendarLunar => '农历';

  @override
  String calendarLunarShort(String day, String month) {
    return '$month/$day';
  }

  @override
  String get calendarToday => '今天';

  @override
  String calendarItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 项',
    );
    return '$_temp0';
  }

  @override
  String get calendarAllDay => '全天';

  @override
  String calendarKindLabel(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'family': '家庭活动',
      'child': '宝宝的事',
      'couple': '两人约会',
      'anniversary': '纪念日提醒',
      'health': '体检/疫苗',
      'other': '任务',
    });
    return '$_temp0';
  }

  @override
  String calendarOwnerLabel(String owner, String callName) {
    String _temp0 = intl.Intl.selectLogic(owner, {
      'me': '我的',
      'together': '一起',
      'other': '$callName的',
    });
    return '$_temp0';
  }

  @override
  String get calendarCoupleOnly => '仅你们俩可见';

  @override
  String get calendarEmptyDay => '这天还没有安排。添加一个事件或任务？';

  @override
  String get calendarAddEvent => '事件';

  @override
  String get calendarAddMission => '任务';

  @override
  String get calendarAddMenu => '添加到日历';

  @override
  String get calendarPrevMonth => '上个月';

  @override
  String get calendarNextMonth => '下个月';

  @override
  String get calendarEventType => '事件类型';

  @override
  String calendarEventKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'child': '宝宝',
      'family': '家庭',
      'couple': '我们俩',
      'anniversary': '纪念日',
      'other': '体检/疫苗',
    });
    return '$_temp0';
  }

  @override
  String get calendarEventTypeHint => '父母双方始终可见。只有选择“邀请全家”时亲人才能看到。';

  @override
  String get calendarDate => '日期';

  @override
  String get calendarUseLunar => '使用农历日期';

  @override
  String calendarLunarDayName(String day, String month) {
    String _temp0 = intl.Intl.selectLogic(day, {
      '15': '农历$month月十五',
      'other': '农历$month月$day日',
    });
    return '$_temp0';
  }

  @override
  String calendarThisYear(String date) {
    return '今年：$date';
  }

  @override
  String get calendarRepeatYearly => '每年重复';

  @override
  String get calendarRepeatByLunar => '按农历日期';

  @override
  String get calendarRepeatBySolar => '按公历日期';

  @override
  String get calendarTime => '时间';

  @override
  String get calendarRelatedChildren => '相关宝宝（可选）';

  @override
  String get calendarParticipants => '参与者';

  @override
  String get calendarInviteFamily => '邀请全家';

  @override
  String get calendarFamilyPlanTag => '家庭版';

  @override
  String get calendarInviteFamilyHint => '祖父母和亲人也能看到此事件';

  @override
  String get calendarReminders => '提醒';

  @override
  String calendarReminder(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'dayBefore0900': '提前1天 9:00',
      'morning': '当天早上',
      'atTime': '准时',
      'hourBefore': '提前1小时',
      'other': '提前1周',
    });
    return '$_temp0';
  }

  @override
  String get calendarAddReminder => '添加';

  @override
  String get calendarNote => '备注';

  @override
  String get calendarNoteHint => '添加备注…';

  @override
  String get calendarSaveEvent => '保存事件';

  @override
  String get calendarEventSaved => '事件已保存';

  @override
  String get careHistoryAll => '全部';

  @override
  String get careHistoryCategory => '类型';

  @override
  String get careHistoryLegendMine => '我的';

  @override
  String careHistoryLegendPartner(String callName) {
    return '$callName的（已完成）';
  }

  @override
  String careHistoryToday(String date) {
    return '今天 · $date';
  }

  @override
  String careHistoryYesterday(String date) {
    return '昨天 · $date';
  }

  @override
  String careHistoryDate(String weekday, String date) {
    return '$weekday $date';
  }

  @override
  String careHistoryLunar(String day, String month) {
    return '农历$month/$day';
  }

  @override
  String careHistoryPartnerDone(String callName) {
    return '$callName · 已完成';
  }

  @override
  String careHistoryTogetherDone(String couple, String time) {
    String _temp0 = intl.Intl.selectLogic(couple, {
      'yes': '我们俩',
      'other': '一起',
    });
    return '$_temp0 · $time 完成';
  }

  @override
  String get careHistoryMissed => '没来得及做';

  @override
  String careHistoryNote(String callName) {
    return '爱心只显示在你的任务上。$callName的任务完成后才显示。';
  }

  @override
  String get careHistoryEmpty => '历史中还没有任务';

  @override
  String careCategoryName(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'care': '照顾',
      'bonding': '亲子',
      'play': '玩耍',
      'outing': '外出',
      'memory': '留住回忆',
      'support': '支持伴侣',
      'self': '照顾自己',
      'chores': '宝宝家务',
      'other': '其他',
    });
    return '$_temp0';
  }

  @override
  String get careBadgesSubtitle => '记录全家一起养成的好习惯——不比较，不给任何人打分。';

  @override
  String careBadgesUnlocked(int done, int total) {
    return '已解锁 $done / $total 枚徽章';
  }

  @override
  String careBadgesLatest(String title, String date) {
    return '最近：$title · $date';
  }

  @override
  String get careBadgesEarned => '已获得';

  @override
  String get careBadgesUpcoming => '即将解锁';

  @override
  String careBadgeAchievedOn(String date) {
    return '$date 获得';
  }

  @override
  String get careSettingsLevelSection => '全家每日任务量';

  @override
  String careSettingsLevel(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      'light': '轻松',
      'medium': '适中',
      'other': '较多',
    });
    return '$_temp0';
  }

  @override
  String get careSettingsPerPerson => '项 / 人';

  @override
  String careSettingsTogether(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      'light': '0–1 项共同任务',
      'other': '1 项共同任务',
    });
    return '$_temp0';
  }

  @override
  String get careSettingsDefault => '默认';

  @override
  String careSettingsLevelNote(String partner, String me) {
    return '同时适用于$partner和$me——两份清单始终一样多。你修改时$partner会收到一条温和的通知。';
  }

  @override
  String get careSettingsCategoriesSection => '我想接收的任务类型';

  @override
  String get careSettingsCategoriesHint => '关闭某些类型后，清单仍会从其余类型中补足任务数。只对你的清单生效。';

  @override
  String get careSettingsTimingSection => '时间与提醒';

  @override
  String get careSettingsBoardTime => '接收任务清单时间';

  @override
  String careSettingsBoardTimeHint(int count) {
    return '通知“今天你有 $count 件小事…”';
  }

  @override
  String careSettingsAskAtNight(String time) {
    return '$time 询问';
  }

  @override
  String get careSettingsAskAtNightHint => '自己添加的未完成任务——移到明天？';

  @override
  String get careSettingsDefaultReminder => '默认提醒';

  @override
  String get careSettingsDefaultReminderHint => '用于你设定时间的任务';

  @override
  String careReminderShort(String reminder) {
    String _temp0 = intl.Intl.selectLogic(reminder, {
      'atTime': '准时',
      'before15': '提前15分',
      'before30': '提前30分',
      'before60': '提前1小时',
      'other': '不提醒',
    });
    return '$_temp0';
  }

  @override
  String get careSeriesSection => '重复任务';

  @override
  String get careSeriesDaily => '每天';

  @override
  String careSeriesPausedUntil(String date) {
    return '暂停至 $date';
  }

  @override
  String get careSeriesPauseWeek => '暂停 1 周';

  @override
  String get careSeriesEnd => '停止重复';

  @override
  String get careSeriesEndConfirm => '从今天起未完成的任务将从任务板移除，已完成的仍会保留。';

  @override
  String get careSeriesPaused => '已暂停 1 周';

  @override
  String get careSeriesEnded => '已停止重复';

  @override
  String famPlanPaidSubtitle(String price, String date) {
    return '$price · $date 续订';
  }

  @override
  String get famManagePlan => '管理套餐';

  @override
  String famInviteRelativeCount(int used, int max) {
    return '邀请亲人（$used/$max）';
  }

  @override
  String famRelativeFollows(String relation, String children) {
    return '$relation · 关注 $children';
  }

  @override
  String famRelativeFollowsNone(String relation) {
    return '$relation · 尚未关注孩子';
  }

  @override
  String famRelationMotherOf(String callName) {
    return '$callName的妈妈';
  }

  @override
  String famRelationFatherOf(String callName) {
    return '$callName的爸爸';
  }

  @override
  String get famRelationNanny => '保姆';

  @override
  String get famPermSummaryView => '查看';

  @override
  String get famPermSummaryComment => '查看、评论';

  @override
  String get famPermSummaryDownload => '可下载照片';

  @override
  String get famPermSummaryContribute => '可投稿照片';

  @override
  String famRelativeSince(String relation, String date) {
    return '关系：$relation · $date 加入';
  }

  @override
  String famRelativeActive(String time) {
    return '$time活跃';
  }

  @override
  String get famDisplayName => '显示称呼';

  @override
  String get famSignIn => '登录方式';

  @override
  String famSignInPhone(String phone) {
    return '电话 $phone';
  }

  @override
  String get famPostedMemories => '已发布的回忆';

  @override
  String famMemoryCount(int count) {
    return '$count 条回忆';
  }

  @override
  String get famPermByChild => '按孩子设置权限';

  @override
  String get famPermHide => '暂时隐藏';

  @override
  String get famPermLevelView => '查看';

  @override
  String get famPermLevelComment => '评论';

  @override
  String get famPermLevelContribute => '投稿';

  @override
  String famPregnancyWeekShort(int week) {
    return '孕期 · 第$week周';
  }

  @override
  String get famNotShared => '未分享';

  @override
  String get famPermHidden => '暂时隐藏中';

  @override
  String get famShare => '分享';

  @override
  String get famAllowDownload => '允许下载照片到手机';

  @override
  String famAllowDownloadOff(String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': '奶奶',
      'grandpa': '爷爷',
      'other': '亲人',
    });
    return '关闭 — $_temp0只能在应用内查看，不能保存';
  }

  @override
  String famAllowDownloadOn(String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': '奶奶',
      'grandpa': '爷爷',
      'other': '亲人',
    });
    return '开启 — $_temp0可以保存照片';
  }

  @override
  String famMuteFrom(String callName) {
    return '关闭来自$callName的通知';
  }

  @override
  String famMuteHint(String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': '奶奶',
      'grandpa': '爷爷',
      'other': '亲人',
    });
    return '$_temp0仍可正常查看和评论';
  }

  @override
  String famRelativeNote(String callName) {
    return '$callName永远看不到 Papa & Mama、任务、请求和 Hearts。';
  }

  @override
  String get famPauseView => '暂停查看权限';

  @override
  String get famResumeView => '恢复查看权限';

  @override
  String get famReport => '举报';

  @override
  String get famRemoveRelative => '移出家庭';

  @override
  String famRemoveTitle(String callName) {
    return '将$callName移出家庭？';
  }

  @override
  String famRemoveSummary(String callName, int count) {
    return '$callName已发布 $count 条回忆。移出后将无法再看到孩子们。';
  }

  @override
  String get famRemoveKeepPosts => '保留已发布的回忆';

  @override
  String get famRemoveKeepPostsHint => '仍保留在家庭回忆中';

  @override
  String get famRemoveDeletePosts => '一并删除这些回忆';

  @override
  String famRemoved(String callName) {
    return '已将$callName移出家庭';
  }

  @override
  String get famSettingsChangeCover => '更换封面';

  @override
  String get famSettingsName => '家庭名称';

  @override
  String get famSettingsMemoriesSection => '回忆与亲人';

  @override
  String get famSettingsDefaultVisibility => '谁能看到新回忆';

  @override
  String get famSettingsDefaultVisibilityHint => '新发布回忆的默认设置';

  @override
  String get famSettingsApprove => '审核亲人发布的照片';

  @override
  String get famSettingsApproveHint => '爷爷奶奶的照片需 Papa/Mama 审核后显示';

  @override
  String get famSettingsTree => '亲人可见家庭树';

  @override
  String get famSettingsMilestones => '里程碑建议';

  @override
  String get famSettingsMilestonesHint => '提醒孩子们值得纪念的第一次';

  @override
  String get famSettingsDatesSection => '日期与语言';

  @override
  String get famSettingsTimezone => '家庭时区';

  @override
  String get famSettingsLunar => '显示农历';

  @override
  String get famSettingsMilestonesBy => '满月、周岁按';

  @override
  String get famSettingsLunarCalendar => '农历';

  @override
  String get famSettingsSolarCalendar => '公历';

  @override
  String get famSettingsContentLanguage => '建议内容语言';

  @override
  String get famDeleteFamily => '删除家庭';

  @override
  String get famDeleteFamilyHint => '需谨慎确认 · 30 天内可恢复';

  @override
  String famDelBody(int days) {
    return '需要爸爸和妈妈都同意。同意后家庭会再保留$days天以便取消；亲友会立即失去查看权限。期满后全家的回忆、照片、信件和记录都会被删除。';
  }

  @override
  String get famDelExportHint => '请先下载数据：设置 → 我的数据。';

  @override
  String get famDelVerifyHint => '使用发送到你手机的验证码重新验证。';

  @override
  String get famDelSendOtp => '发送验证码';

  @override
  String get famDelOtpSent => '验证码已发送';

  @override
  String get famDelStart => '申请删除家庭';

  @override
  String get famDelAgree => '同意删除家庭';

  @override
  String get famDelWaitingPartner => '正在等待伴侣同意删除家庭。你随时可以取消申请。';

  @override
  String get famDelPartnerAsked => '伴侣申请删除家庭。请重新验证以同意，或取消申请。';

  @override
  String famDelScheduled(String date) {
    return '家庭将于$date被删除。在此之前全家只能查看和下载。';
  }

  @override
  String get famDelCancel => '取消删除申请';

  @override
  String get famDelCancelled => '已取消删除申请';

  @override
  String get famDelRequested => '删除申请已更新';

  @override
  String get setProfileChangeAvatar => '更换头像';

  @override
  String get setProfileName => '你的名字';

  @override
  String get setProfileCallName => '家庭中的称呼';

  @override
  String setProfileCallNameHint(String callName) {
    return '孩子们和亲人会看到你的称呼“$callName”。';
  }

  @override
  String get setSignInSection => '登录方式';

  @override
  String get setSignInApple => 'Apple';

  @override
  String get setSignInGoogle => 'Google';

  @override
  String get setNotLinked => '未关联';

  @override
  String get setUnlink => '取消关联';

  @override
  String get phoneChangeTitle => '更换手机号';

  @override
  String get phoneChangeReauthHint => '请先使用发送到当前号码的验证码重新验证。';

  @override
  String get phoneChangeNewHint => '输入新手机号，我们会向它发送验证码。';

  @override
  String phoneChangeCodeSent(String phone) {
    return '验证码已发送至 $phone';
  }

  @override
  String get phoneChangeDone => '手机号已更换，其他设备已退出登录。';

  @override
  String get setChangePhone => '更换';

  @override
  String get setLink => '关联';

  @override
  String get setSignInHint => '请至少保留一种登录方式，以免丢失账户。';

  @override
  String get setTimezoneSection => '时区';

  @override
  String get setAutoTimezone => '跟随设备自动设置';

  @override
  String get setAutoTimezoneHint => '任务、请求提醒按你所在地时间';

  @override
  String get setPersonalTimezone => '个人时区';

  @override
  String get setSaveChanges => '保存更改';

  @override
  String get setChangesSaved => '已保存更改';

  @override
  String get setNotifGroupsSection => '通知分组';

  @override
  String get setQuietSection => '安静时段与锁屏';

  @override
  String get setQuietHours => '安静时段';

  @override
  String get setQuietHoursHint => '通知会合并稍后发送';

  @override
  String get setFrom => '从';

  @override
  String get setTo => '到';

  @override
  String setUrgentBypass(String callName) {
    return '$callName的请求不受安静时段限制';
  }

  @override
  String setUrgentBypassOff(String time) {
    return '关闭 — “尽快”请求也会等到 $time 之后';
  }

  @override
  String get setUrgentBypassOn => '开启 — “尽快”请求会立即通知';

  @override
  String get setHideLockScreen => '在锁屏上隐藏内容';

  @override
  String get setHideLockScreenHint => '显示：“你有一条来自 Papa & Mama 的新动态”';

  @override
  String get setRelativesSection => '亲人';

  @override
  String get setDigestTime => '简报发送时间';

  @override
  String get setMutePeople => '按人关闭通知';

  @override
  String setPeopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 人',
      zero: '暂无',
    );
    return '$_temp0';
  }

  @override
  String get setVisOnlyMeHint => '草稿、想自己保留的内容';

  @override
  String get setVisParents => 'Papa & Mama';

  @override
  String get setVisParentsHint => '仅 Papa 和 Mama';

  @override
  String get setVisFamilyHint => 'Papa、Mama 和获分享该孩子的亲人';

  @override
  String get setVisibilityHint => '没有公开分享。你可以随时更改每条回忆的可见范围。';

  @override
  String get setDashboardSection => '权限面板';

  @override
  String get setWhoSees => '谁能看到哪个孩子';

  @override
  String setRelativeCount(int count) {
    return '$count 位亲人';
  }

  @override
  String get setStatDownload => '可下载照片';

  @override
  String get setStatPost => '可发布照片';

  @override
  String get setStatFamilyMemories => '“全家”可见的回忆';

  @override
  String get setStatMemoriesUnit => '条回忆';

  @override
  String get setStatDevices => '已登录设备';

  @override
  String get setStatDevicesUnit => '台设备';

  @override
  String get setStatAi => '已开启的 AI';

  @override
  String get setStatAiUnit => '项功能';

  @override
  String get setOpenPermissions => '查看详情并调整权限';

  @override
  String get setPrivacyNote => 'Papa & Mama、任务、请求和 Hearts 永远只属于你们两人——亲人永远看不到。';

  @override
  String get setBlocked => '已屏蔽的人';

  @override
  String get setAppLockSection => '应用锁';

  @override
  String get setFaceIdLock => '使用面容 ID 锁定';

  @override
  String get setFaceIdLockHint => '打开 Baby Family 需要你的面容 ID';

  @override
  String get setBackupPin => '备用 PIN 码';

  @override
  String get setPinSet => '已设置';

  @override
  String get setPinNotSet => '未设置';

  @override
  String get setPinHint => '面容 ID 无法识别时，可用 6 位 PIN 码打开。';

  @override
  String get setDevicesSection => '已登录的设备';

  @override
  String setDeviceInUse(String location) {
    return '$location · 正在使用';
  }

  @override
  String setDeviceLastActive(String location, String time) {
    return '$location · $time';
  }

  @override
  String get setThisDevice => '本设备';

  @override
  String get setSignOutAll => '退出所有设备';

  @override
  String get setSignOutAllHint => '你需要在所有设备（包括本机）上重新登录。回忆和数据都会保留。';

  @override
  String setDeviceSignedOut(String device) {
    return '已退出 $device';
  }

  @override
  String get setDataSubtitle => '我们家的回忆永远属于我们家——随时可以下载。';

  @override
  String get setExportSection => '导出数据';

  @override
  String get setExportPersonal => '个人数据';

  @override
  String get setExportPersonalWho => '所有成员';

  @override
  String get setExportPersonalDesc => '你创建的内容：已发布的回忆、私人日记、心情、收发的感谢。';

  @override
  String get setExportFamily => '家庭数据';

  @override
  String get setExportFamilyDesc =>
      'ZIP 文件：原始照片/视频、memories.csv 和离线浏览页。不含 Papa & Mama。';

  @override
  String get setExport => '导出';

  @override
  String get setExporting => '导出中…';

  @override
  String get setExportStatusSection => '导出状态';

  @override
  String setExportPreparing(int percent) {
    return '准备中 · $percent%';
  }

  @override
  String setExportStarted(String time) {
    return '今天 $time 开始 · 完成后会通知你。';
  }

  @override
  String setExportReadyTitle(String name, int size) {
    return '$name · $size MB';
  }

  @override
  String setExportExpires(String date) {
    return '下载链接 $date 过期';
  }

  @override
  String get setDownload => '下载';

  @override
  String get setDownloadStarted => '已开始下载';

  @override
  String get setOnDeviceSection => '本机';

  @override
  String get setCache => '缓存';

  @override
  String setCacheSize(int size) {
    return '本机 $size MB';
  }

  @override
  String get setClearCache => '清除缓存';

  @override
  String get setCacheHint => '清除缓存只会释放手机空间，回忆仍安全保存在云端。';

  @override
  String setDelStep(int step) {
    return '第 $step/4 步';
  }

  @override
  String get setDelStepFinal => '第 3–4/4 步';

  @override
  String get setDelTitle1 => '删除账户之前';

  @override
  String setDelSubtitle1(String name) {
    return '$name，以下是将会发生的变化。你随时可以停下。';
  }

  @override
  String get setDelWillDelete => '将被删除';

  @override
  String get setDelItemPrivate => '你的私人日记、心情和草稿';

  @override
  String setDelItemCouple(String partner) {
    return '你在 Papa & Mama 中的内容——$partner的部分仍保留';
  }

  @override
  String get setDelItemCoupleSolo => '你在 Papa & Mama 中的内容';

  @override
  String get setDelItemProfile => '个人资料和登录方式';

  @override
  String setDelPosted(int count) {
    return '你发布的 $count 条回忆';
  }

  @override
  String get setDelKeepForFamily => '为家人保留';

  @override
  String get setDelKeepHint => '以“已离开的用户”显示';

  @override
  String get setDelDeleteMemories => '删除这些回忆';

  @override
  String get setDelSubscription => '订阅套餐';

  @override
  String get setDelSubscriptionBody =>
      '通过 App Store 或 Google Play 购买的套餐不会因删除账户而自动取消。请在商店中取消以免续费。';

  @override
  String get setDelHowToCancel => '查看如何在商店取消';

  @override
  String get setDelOthersNote => '别人在你照片下的评论仍属于他们——应用不会删除他人的内容。';

  @override
  String get setDelKeepAccount => '保留账户';

  @override
  String setDelTitle2(String family) {
    return '$family会怎样？';
  }

  @override
  String setDelSubtitle2(String partner) {
    return '家里还有$partner，孩子们和所有回忆都会留在$partner身边。';
  }

  @override
  String setDelPartnerKeeps(String partner, String family) {
    return '$partner继续管理$family';
  }

  @override
  String setDelPartnerItem1(String partner, String children) {
    return '$partner仍可查看和下载$children的所有回忆';
  }

  @override
  String get setDelPartnerItem2 => '家庭切换为仅查看和下载模式';

  @override
  String setDelPartnerItem3(String partner) {
    return '$partner可以邀请新的伴侣加入家庭';
  }

  @override
  String setDelCoupleData(String partner) {
    return '你在 Papa & Mama 中的心情、日记和分享将被删除。$partner的部分完整保留。';
  }

  @override
  String get setDelExportTip => '想为自己保留一份吗？';

  @override
  String get setDelExportTipHint => '删除前导出个人数据';

  @override
  String get setDelOnlyBadge => '当你是唯一的 Papa/Mama 时';

  @override
  String get setDelOnlyTitle => '谁来保管孩子们的回忆？';

  @override
  String setDelOnlySubtitle(String family) {
    return '$family只有你在管理。继续之前请选择一种方式。';
  }

  @override
  String get setDelInviteParent => '先邀请他人成为 Parent';

  @override
  String get setDelInviteParentHint => '由他们保管家庭、孩子和所有回忆。他们加入后你再回来删除账户。';

  @override
  String get setDelDeleteFamily => '删除整个家庭';

  @override
  String setDelDeleteFamilyHint(String children) {
    return '$children及所有回忆将在 30 天后永久删除。30 天内仍可恢复。';
  }

  @override
  String get setDelOnlyExportTip => '建议先导出家庭数据，保留全部原始照片和视频。';

  @override
  String get setDelInviteNewParent => '邀请新的 Parent';

  @override
  String get setDelTitle3 => '最后确认';

  @override
  String get setDelSubtitle3 => '为保护账户，请用已关联的方式重新登录。';

  @override
  String setDelVerified(String account) {
    return '已验证 · $account';
  }

  @override
  String setDelUseOtp(String phone) {
    return '通过手机 $phone 使用验证码';
  }

  @override
  String get setDelWhatHappens => '当你点击“删除账户”后';

  @override
  String get setDelHappen1 => '你会立即从所有设备退出';

  @override
  String setDelHappen2(String date) {
    return '账户将等待 30 天后删除——直到 $date';
  }

  @override
  String get setDelHappen3 => '在此之前重新登录即可恢复';

  @override
  String get setDelHappen4 => '30 天后数据将被永久删除，你会收到确认邮件';

  @override
  String get setDelConfirmCheck => '我已了解并希望删除我的账户';

  @override
  String get setFaqSection => '常见问题';

  @override
  String get setFaqAll => '查看全部问题';

  @override
  String get setSupportSection => '需要更多帮助';

  @override
  String get setSendRequest => '提交支持请求';

  @override
  String get setSendRequestHint => '描述问题，可附上截图';

  @override
  String get supportTitle => '联系客服';

  @override
  String get supportHint => '只有你在这里输入的内容会发送给客服。请勿填写密码或验证码。';

  @override
  String get supportCategoryLabel => '问题类型';

  @override
  String supportCategory(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'ACCOUNT': '账号',
      'INVITATION': '邀请',
      'MEDIA': '照片和视频',
      'BILLING': '套餐与付款',
      'PRIVACY': '隐私',
      'other': '其他',
    });
    return '$_temp0';
  }

  @override
  String get supportSubject => '标题';

  @override
  String get supportBody => '问题描述';

  @override
  String get supportSend => '提交';

  @override
  String supportSent(String code) {
    return '已提交请求 $code';
  }

  @override
  String get supportMine => '我的请求';

  @override
  String get supportEmpty => '你还没有提交过请求。';

  @override
  String supportStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'OPEN': '已受理',
      'IN_PROGRESS': '处理中',
      'WAITING_USER': '等待你回复',
      'RESOLVED': '已解决',
      'other': '已关闭',
    });
    return '$_temp0';
  }

  @override
  String get setMyReports => '我的反馈';

  @override
  String setReportsOpen(int count) {
    return '$count 条处理中';
  }

  @override
  String get setContactSection => '联系方式';

  @override
  String get setEmailSupport => '支持团队邮箱';

  @override
  String get setHotline => '支持热线';

  @override
  String setAppVersion(String version) {
    return '版本 $version';
  }

  @override
  String get setTerms => '使用条款';

  @override
  String get setPrivacyPolicy => '隐私政策';

  @override
  String get setLicenses => '开源许可';

  @override
  String get setMadeWith => '用爱为越南家庭打造';

  @override
  String setCopyright(String year) {
    return '© $year Baby Family';
  }

  @override
  String commonAndList(String items, String last) {
    return '$items和$last';
  }

  @override
  String get memAlbumsAuto => '自动相册';

  @override
  String get memAlbumsAutoHint => '自动更新';

  @override
  String get memAlbumsFamily => '我们家的相册';

  @override
  String get memAlbumNew => '新相册';

  @override
  String get memAlbumNameHint => '相册名称';

  @override
  String get memAlbumCreate => '创建相册';

  @override
  String memAlbumMonthlyMeta(String name, int count) {
    return '$name · $count 张照片';
  }

  @override
  String memAlbumFirstsMeta(int count) {
    return '$count 个里程碑';
  }

  @override
  String memAlbumVideosMeta(int count) {
    return '$count 个视频';
  }

  @override
  String memAlbumQuotesMeta(int count) {
    return '$count 句话';
  }

  @override
  String memAlbumVoicesMeta(int count) {
    return '$count 段录音';
  }

  @override
  String memAlbumParentsMeta(int count) {
    return '$count 条回忆 · 爸爸妈妈';
  }

  @override
  String memAlbumDetailMeta(int count, String range) {
    return '$count 条回忆 · $range';
  }

  @override
  String memAlbumCreatedBy(String callName) {
    return '$callName 创建';
  }

  @override
  String get memAlbumPermissionNote => '查看者只能看到他们有权限查看的回忆。';

  @override
  String get memAlbumRename => '重命名';

  @override
  String get memAlbumChangeCover => '更换封面';

  @override
  String get memAlbumDelete => '删除相册';

  @override
  String get memAlbumDeleteNote => '相册中的回忆会被保留';

  @override
  String memAlbumDeleteConfirm(String title) {
    return '删除相册“$title”？';
  }

  @override
  String memNamesPair(String first, String second) {
    return '$first 和 $second';
  }

  @override
  String memDotMeta3(String first, String second, String third) {
    return '$first · $second · $third';
  }

  @override
  String get memViewerSwipeHint => '下滑关闭';

  @override
  String get memViewerDownload => '下载';

  @override
  String get memViewerShare => '分享';

  @override
  String get memViewerInfo => '信息';

  @override
  String get memViewerDownloaded => '已保存到设备';

  @override
  String get memCommentReply => '回复';

  @override
  String memCommentReplying(String name) {
    return '正在回复 $name';
  }

  @override
  String get memCommentEditing => '正在编辑评论';

  @override
  String get memCommentEdit => '编辑';

  @override
  String get memCommentCopy => '复制';

  @override
  String get memCommentDelete => '删除';

  @override
  String memCommentMinutes(int count) {
    return '$count 分钟';
  }

  @override
  String memCommentHours(int count) {
    return '$count 小时';
  }

  @override
  String get memCommentEmoji => '表情';

  @override
  String get memMilestoneSearchHint => '搜索里程碑，例如“翻身”、“长牙”…';

  @override
  String memMilestoneRecordedCount(int done, int total) {
    return '已记录 $done / $total';
  }

  @override
  String memMilestoneRecordedAt(String date) {
    return '已记录 · $date';
  }

  @override
  String get memMilestoneCustom => '✏️ 我们家的专属里程碑';

  @override
  String get memMilestoneCustomHint => '里程碑名称';

  @override
  String get memMilestoneNoResult => '没有匹配的里程碑';

  @override
  String memDiarySavedDraft(String time) {
    return '已保存草稿 · $time';
  }

  @override
  String get memDiarySaved => '日记已保存';

  @override
  String get memFormatBold => '加粗';

  @override
  String get memFormatItalic => '斜体';

  @override
  String get memFormatList => '项目列表';

  @override
  String get memFormatNumbered => '编号列表';

  @override
  String get memFormatImage => '插入照片';

  @override
  String get memFormatHeading => '标题';

  @override
  String get memFormatHideKeyboard => '收起键盘';

  @override
  String get memLetterSaveDraft => '保存草稿';

  @override
  String get memLetterDraftSaved => '草稿已保存';

  @override
  String get memLetterRecipient => '寄给';

  @override
  String get memLetterFormat => '形式';

  @override
  String get memLetterWrite => '书写';

  @override
  String get memLetterVideo => '录视频';

  @override
  String get memLetterPickDate => '选择日期';

  @override
  String get memLetterBirthdayN => '第 N 个生日';

  @override
  String memLetterBirthdayAge(int age) {
    return '$age 岁生日';
  }

  @override
  String memLetterOpensOn(String name, String date) {
    return '$name 将在 $date 打开';
  }

  @override
  String get memLetterReaders => '开启日谁可以阅读';

  @override
  String memLetterReadersNote(String mode, String me, String partner) {
    String _temp0 = intl.Intl.selectLogic(mode, {
      'onlyMe': '开启时：只有$me和孩子一起读。$partner看不到这封信。',
      'family': '开启时：全家一起读。开启前只有$me可以阅读和修改。',
      'other': '开启时：$me和$partner与孩子一起读。开启前只有$me可以阅读和修改——$partner知道有信但看不到内容。',
    });
    return '$_temp0';
  }

  @override
  String get memLetterEnvelopePreview => '信封预览';

  @override
  String memLetterEnvelopeTo(String name) {
    return '致 $name';
  }

  @override
  String memLetterEnvelopeBirthday(String date, int age) {
    return '$date 开启 · $age 岁生日';
  }

  @override
  String memLetterEnvelopeDate(String date) {
    return '$date 开启';
  }

  @override
  String get memLetterEnvelopeAnytime => '未设定开启日期';

  @override
  String memLetterTimelineHint(String callName, String date) {
    return '时间线上：“💌 $callName的信 — $date 开启”';
  }

  @override
  String memLetterTimelineHintNow(String callName) {
    return '时间线上：“💌 $callName的信”';
  }

  @override
  String get memLetterSeal => '封存信件';

  @override
  String memLetterSalutation(String child, String callName) {
    return '亲爱的$child，$callName写给你：';
  }

  @override
  String get memLetterSignOff => '爱你的，';

  @override
  String get memSearchHint => '搜索回忆、话语、日记…';

  @override
  String get memSearchRecent => '最近';

  @override
  String get memSearchKind => '类型';

  @override
  String get memSearchKindAll => '全部';

  @override
  String get memSearchAuthor => '发布者';

  @override
  String memSearchResults(int count, String query) {
    return '“$query”的 $count 个结果';
  }

  @override
  String memSearchMedia(int count) {
    return '照片和视频 · $count';
  }

  @override
  String memSearchDiaries(int count) {
    return '日记 · $count';
  }

  @override
  String get memSearchNoResult => '没有找到回忆';

  @override
  String memOnThisDayMonthShort(int month) {
    return '$month月';
  }

  @override
  String memOnThisDayHeader(int day, int month) {
    return '我们家的$month月$day日';
  }

  @override
  String memOnThisDaySummary(int years, int count) {
    return '$years 年的纪念 · $count 条回忆';
  }

  @override
  String memOnThisDayYearsAgo(int count) {
    return '$count 年前';
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
    return '$count 张照片';
  }

  @override
  String memQuoteOfChild(String name, String age) {
    return '$name说的话 · $age';
  }

  @override
  String get memOnThisDayReshare => '配上新文字再次分享';

  @override
  String get memOnThisDayFooter => '只显示你有权限查看的回忆 · 可在设置中关闭';

  @override
  String get memOnThisDayEmpty => '今天还没有往年的回忆';

  @override
  String recapWeekRange(String range, String audience) {
    return '本周 · $range · $audience';
  }

  @override
  String recapQuoteMeta(String name, String age) {
    return '$name的新话语 · $age';
  }

  @override
  String get recapShareFamily => '分享给亲人';

  @override
  String get recapFamilyBadge => 'Family';

  @override
  String get recapSaveTimeline => '保存到时间线';

  @override
  String get recapDownload => '下载总结图片';

  @override
  String get recapNote => '分享前请先查看。不包含爸爸妈妈的私密内容。';

  @override
  String get recapNextHighlights => '精选照片';

  @override
  String get recapShared => '已分享给亲人';

  @override
  String get recapSaved => '已保存到时间线';

  @override
  String get memLetterSealDone => '信件已封存';

  @override
  String usThanksMonth(String month) {
    return '$month月';
  }

  @override
  String get usThanksAll => '全部';

  @override
  String get usThanksMine => '你的';

  @override
  String usThanksPartner(String callName) {
    return '$callName的';
  }

  @override
  String usThanksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条感谢',
    );
    return '$_temp0';
  }

  @override
  String get usThanksYou => '你';

  @override
  String get usThanksSendCta => '发送感谢';

  @override
  String get usThanksReact => '送爱心';

  @override
  String usThanksShareAsk(String name) {
    return '$name 想把这条感谢分享为全家的时刻';
  }

  @override
  String get usThanksShareApprove => '分享给全家';

  @override
  String get usThanksShareKeep => '只留给我们俩';

  @override
  String get usThanksShareFailed => '发送失败，请重试';

  @override
  String get usThanksWallEmpty => '本月还没有感谢';

  @override
  String get usJournalOnlyYou => '只有你能看到';

  @override
  String usJournalOnlyYouHint(String callName) {
    return '$callName也看不到——除非你主动分享一段。';
  }

  @override
  String get usJournalFaceId => '用面容 ID 锁定';

  @override
  String get usJournalFaceIdHint => '每次打开日记时验证面容 ID';

  @override
  String usJournalMonth(String month) {
    return '$month月';
  }

  @override
  String usJournalMood(String mood) {
    String _temp0 = intl.Intl.selectLogic(mood, {
      'tired': '累',
      'grateful': '感恩',
      'worried': '担心',
      'other': '平静',
    });
    return '$_temp0';
  }

  @override
  String get usJournalShareAction => '把这段分享给伴侣';

  @override
  String usJournalShared(String callName) {
    return '已与$callName分享 1 段';
  }

  @override
  String get usJournalWrite => '写新的一页';

  @override
  String usJournalSharePreview(String callName) {
    return '$callName将看到这一段：';
  }

  @override
  String usJournalShareConfirm(String callName) {
    return '分享给$callName';
  }

  @override
  String get usJournalNewPage => '新的一页';

  @override
  String get usJournalMoodLabel => '你现在感觉怎么样？';

  @override
  String get usJournalTitleLabel => '标题';

  @override
  String get usJournalBodyLabel => '想记下的事';

  @override
  String get usJournalSave => '保存';

  @override
  String get usJournalEmpty => '还没有内容。写几句只属于自己的话吧。';

  @override
  String usSettingsScope(String callName) {
    return '仅对你生效 · $callName有自己的设置';
  }

  @override
  String get usSettingsCheckinSection => '心情打卡时';

  @override
  String usSettingsShareMode(String mode, String callName) {
    String _temp0 = intl.Intl.selectLogic(mode, {
      'askEachTime': '每次询问',
      'alwaysShare': '总是分享给$callName',
      'other': '始终私密',
    });
    return '$_temp0';
  }

  @override
  String usSettingsShareModeHint(String mode, String callName) {
    String _temp0 = intl.Intl.selectLogic(mode, {
      'askEachTime': '每次打卡后选择分享或保密',
      'alwaysShare': '$callName能看到你的心情和你勾选的部分',
      'other': '只有你自己能回看',
    });
    return '$_temp0';
  }

  @override
  String get usSettingsPrivacySection => '隐私';

  @override
  String get usSettingsHideLock => '在锁屏上隐藏内容';

  @override
  String get usSettingsHideLockHint => '只显示“你有一条来自 Papa & Mama 的新动态”';

  @override
  String get usSettingsFaceId => '进入 Papa & Mama 时用面容 ID 锁定';

  @override
  String get usSettingsFaceIdHint => '每次打开此标签时验证面容 ID';

  @override
  String get usSettingsRequestsSection => '请求';

  @override
  String usSettingsUrgentBypass(String callName) {
    return '允许$callName的“尽快哦”请求在安静时段送达';
  }

  @override
  String usSettingsUrgentBypassHint(String from, String to) {
    return '你的安静时段：$from–$to。关闭后请求会在安静时段之后送达。';
  }

  @override
  String get usSettingsBridgeSection => '心桥';

  @override
  String get usSettingsBridgeKeep => '保留心桥对话内容';

  @override
  String usSettingsRetention(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days 天',
      zero: '立即删除',
    );
    return '$_temp0';
  }

  @override
  String get usSettingsBridgeHint => '超过此时间后，你们在对话中写下的内容将自动删除。';

  @override
  String get usSettingsDataSection => '数据';

  @override
  String get usSettingsClearMood => '删除我的心情记录';

  @override
  String get usSettingsClearMoodHint => '删除你保存的所有打卡，无法恢复。';

  @override
  String get usSettingsClearMoodConfirm => '删除心情记录？';

  @override
  String get usSettingsClearMoodDone => '心情记录已删除';

  @override
  String get commonDelete => '删除';

  @override
  String get childEditProfile => '编辑资料';

  @override
  String get childChangeCover => '更换封面';

  @override
  String childColorName(String index) {
    String _temp0 = intl.Intl.selectLogic(index, {
      '0': '桃色',
      '1': '薄荷',
      '2': '天蓝',
      '3': '薰衣草',
      '4': '柠檬',
      '5': '玫瑰',
      '6': '杏色',
      'other': '青玉',
    });
    return '$_temp0';
  }

  @override
  String childColorNamed(String color) {
    return '$color色';
  }

  @override
  String get childStatMemories => '回忆';

  @override
  String get childStatMilestones => '里程碑';

  @override
  String get childStatLetters => '写给孩子的信';

  @override
  String get childBirthDate => '出生日期';

  @override
  String childLunarBirth(String date) {
    return '农历：$date';
  }

  @override
  String get childBirthTime => '出生时间';

  @override
  String get childBirthTimeHidden => '亲人看不到出生时间';

  @override
  String get childBirthTimeShown => '亲人可以看到出生时间';

  @override
  String get childDueDate => '预产期';

  @override
  String get childOriginPregnancy => '孕期记录';

  @override
  String childOriginPregnancyValue(int weeks) {
    return '孕期旅程 · $weeks 周';
  }

  @override
  String get childNameStory => '名字的故事';

  @override
  String childNameGivenBy(String names) {
    return '$names取的名字';
  }

  @override
  String childNamesAnd(String first, String second) {
    return '$first和$second';
  }

  @override
  String childLikes(String name) {
    return '$name喜欢';
  }

  @override
  String get childFavFood => '爱吃的';

  @override
  String get childFavToy => '玩具';

  @override
  String get childFavSong => '歌曲';

  @override
  String childQuoted(String text) {
    return '“$text”';
  }

  @override
  String childRelativesSee(String name) {
    return '能看到$name的亲人';
  }

  @override
  String get childRelativesNone => '还没有分享给任何亲人';

  @override
  String get childArchiveAction => '归档宝宝资料';

  @override
  String childArchiveConfirmTitle(String name) {
    return '归档$name的资料？';
  }

  @override
  String get childArchiveConfirmBody => '只属于宝宝的回忆将被隐藏，与兄弟姐妹共有的回忆仍保留。你可以随时恢复。';

  @override
  String get childArchive => '归档';

  @override
  String childEditTitleNamed(String name) {
    return '编辑$name的资料';
  }

  @override
  String get childChangeAvatar => '更换头像';

  @override
  String get childChangeTimelineCover => '更换时间线封面';

  @override
  String get childFieldName => '名字';

  @override
  String get childFieldNickname => '小名';

  @override
  String get childBirthDateWarning => '回忆上的年龄将按新的出生日期重新计算。';

  @override
  String get childShowBirthTime => '让亲人看到出生时间';

  @override
  String get childShowBirthTimeHint => '亲人始终能看到宝宝的年龄';

  @override
  String get childColorLabel => '识别颜色';

  @override
  String childColorUsedBy(String color, String name) {
    return '$color色正用于$name';
  }

  @override
  String get childNameGivenByLabel => '取名人：';

  @override
  String get childNameGivenByOther => '+ 其他';

  @override
  String get childLikesSection => '喜好';

  @override
  String get childSaveChanges => '保存更改';

  @override
  String get childrenReorderHint => '长按拖动以调整显示顺序';

  @override
  String childPregnancyTag(int number) {
    return '第$number胎';
  }

  @override
  String childDueShort(String date) {
    return '预产期 $date';
  }

  @override
  String childrenArchived(int count) {
    return '已归档（$count）';
  }

  @override
  String childArchivedOn(String date) {
    return '$date 归档';
  }

  @override
  String childPrivateMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条专属回忆',
    );
    return '$_temp0';
  }

  @override
  String get childRestore => '恢复';

  @override
  String childrenArchiveNote(int days) {
    return '已归档的宝宝会从切换器中隐藏。归档满 $days 天后可以永久删除。';
  }

  @override
  String childAddSubtitle(String family, String names) {
    return '新宝宝将加入$family。$names的资料保持不变。';
  }

  @override
  String childNamesList(String rest, String last) {
    return '$rest和$last';
  }

  @override
  String get childAddBorn => '宝宝已出生';

  @override
  String get childAddBornHint => '用名字和出生日期添加资料';

  @override
  String get childAddExpecting => '我们正在期待宝宝';

  @override
  String childAddExpectingHint(int number) {
    return '创建新的孕期旅程（第$number胎）';
  }

  @override
  String get childNameHint => '例如：小宝、豆豆…';

  @override
  String get childBirthDateHint => '选择出生日期';

  @override
  String get childDueDateHint => '选择预产期';

  @override
  String get childGenderOptional => '性别（可选）';

  @override
  String childGender(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'boy': '男孩',
      'girl': '女孩',
      'other': '不说明',
    });
    return '$_temp0';
  }

  @override
  String get childAddShareNote => '添加后你可以选择分享给哪些亲人。默认不分享给任何人。';

  @override
  String get memSearchYear => '年份';

  @override
  String memDotMeta2(String first, String second) {
    return '$first · $second';
  }

  @override
  String childLunarDateYear(String day, String month, String year) {
    return '$year年$month月$day日';
  }

  @override
  String get careMoreMenu => '更多';

  @override
  String get careMenuHistory => '任务历史';

  @override
  String setDelPartnerRole(String callName) {
    return '$callName · 家庭管理者';
  }

  @override
  String memAlbumCount(int count) {
    return '$count 个相册';
  }

  @override
  String get usBridgeRewriteTitle => '温柔改写';

  @override
  String get usBridgeNextStepTitle => '下一个小步骤';

  @override
  String get usSafetyTitle => '安全支持';

  @override
  String get recapDayTitle => '今日故事';

  @override
  String get recapMonthTitle => '月龄回顾';

  @override
  String get careStatsTitle => '统计';

  @override
  String get memTrashTitle => '回收站';

  @override
  String get memDraftsTitle => '草稿';

  @override
  String get memPendingTitle => '待审核';

  @override
  String get childArchiveTitle => '归档或删除宝宝';

  @override
  String get circleTabHome => '宝贝';

  @override
  String get circleTabMemories => '回忆';

  @override
  String get circleTabPost => '发照片';

  @override
  String get circleTabMe => '我';

  @override
  String get circlePostTitle => '为宝贝发照片';

  @override
  String get circleMemoryDetailTitle => '回忆详情';

  @override
  String get circlePausedTitle => '家庭暂停分享';

  @override
  String get circleLeaveTitle => '离开家庭';

  @override
  String get billingPlanTitle => '家庭套餐';

  @override
  String get familyInvitePartnerTitle => '邀请伴侣加入';

  @override
  String get familyPendingInvitesTitle => '待处理的邀请';

  @override
  String get settingsBlockedTitle => '已屏蔽的人';

  @override
  String get subPlanActive => '生效中';

  @override
  String get subPlanAutoRenew => '自动续订';

  @override
  String get subPlanPayer => '付款人';

  @override
  String get subPlanChannel => '购买渠道';

  @override
  String get subPlanAppliesTo => '适用于';

  @override
  String subPlanWholeFamily(String family) {
    return '$family全家';
  }

  @override
  String subPlanGb(String value) {
    return '$value GB';
  }

  @override
  String subPlanUsedOf(String total) {
    return '已用 / $total GB';
  }

  @override
  String subPlanStorageKind(String kind, String size) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'photo': '照片',
      'video': '视频',
      'audio': '音频',
      'other': '其他',
    });
    return '$_temp0 · $size GB';
  }

  @override
  String get subPlanIncluded => '我们家的套餐包含';

  @override
  String get subPlanRelatives => '亲友';

  @override
  String subPlanSlots(int used, int max) {
    return '$used/$max';
  }

  @override
  String get subPlanAi => '本月 AI 次数';

  @override
  String subPlanAiRenews(String date) {
    return '$date 重置';
  }

  @override
  String subPlanAiLeft(int remaining, int total) {
    return '剩余 $remaining/$total';
  }

  @override
  String get subPlanVideo => '视频时长上限';

  @override
  String subPlanVideoHint(int count) {
    return '原图 · 每条回忆 $count 张';
  }

  @override
  String subPlanVideoHintCompressed(int count) {
    return '每条回忆 $count 张';
  }

  @override
  String subPlanMinutes(int count) {
    return '$count 分钟';
  }

  @override
  String subPlanManageStore(String channel) {
    return '在 $channel 中管理';
  }

  @override
  String get subPlanChange => '更换套餐';

  @override
  String subPlanNote(String channel, String payer, String partner) {
    return '套餐在 $payer 的 $channel 账户中，只有 $payer 可以更改或取消。$partner 会看到请 $payer 操作的提示。随时可在 $channel 设置中取消——我们家的回忆不会被删除。';
  }

  @override
  String subManageStoreMock(String channel) {
    return '示例数据：$channel 订阅管理页仅为模拟。';
  }

  @override
  String get subUpgradeTitle => '升级到 Family，邀请爷爷奶奶';

  @override
  String subUpgradeSubtitle(String payer, String channel) {
    return '我们家正在使用 House 套餐 · $payer 通过 $channel 付款。Family 可加入爷爷奶奶、亲友，并提供更大空间。';
  }

  @override
  String get subCmpRelatives => '爷爷奶奶、亲友';

  @override
  String get subCmpPhotos => '每条回忆照片数';

  @override
  String get subCmpVideo => '视频';

  @override
  String get subCmpVoice => '录音';

  @override
  String get subCmpOriginal => '保存原图';

  @override
  String get subCmpAi => '每月 AI 次数';

  @override
  String get subCmpDigest => '动态简报、审核亲友照片';

  @override
  String get subCmpNone => '—';

  @override
  String get subCmpYes => '有';

  @override
  String subCmpUpTo(int count) {
    return '最多 $count';
  }

  @override
  String subCmpMaxMinutes(int count) {
    return '≤ $count 分钟';
  }

  @override
  String get subUpgradeCurrent => '当前';

  @override
  String subUpgradeProrate(String channel) {
    return '升级立即生效。$channel 会自动按 House 套餐剩余时间折算差价——无需再付一整年。';
  }

  @override
  String subUpgradeCta(String price) {
    return '升级到 Family · $price';
  }

  @override
  String get subUpgradeLegal => '每年自动续订，可随时在 App Store 设置中取消。条款 · 隐私 · 恢复购买';

  @override
  String subUpgradeNotPayerLabel(String partner) {
    return '$partner 会看到（非付款人）';
  }

  @override
  String subUpgradeNotPayerBody(String payer) {
    return 'House 套餐由 $payer 付款。为避免重复付款，请让 $payer 升级。';
  }

  @override
  String subUpgradeAskPayer(String payer) {
    return '给 $payer 留言';
  }

  @override
  String subUpgradeAskSent(String payer) {
    return '已给 $payer 留言';
  }

  @override
  String subConfirmTitle(String plan) {
    return '确认 $plan 套餐';
  }

  @override
  String subConfirmAudienceFamily(String family, String papa, String mama) {
    return '适用于$family全家 · $papa、$mama和亲友';
  }

  @override
  String subConfirmAudienceHouse(String family, String papa, String mama) {
    return '适用于$family全家 · $papa & $mama';
  }

  @override
  String get subConfirmPrice => '价格';

  @override
  String get subConfirmMonthly => '折合';

  @override
  String get subConfirmCycle => '周期';

  @override
  String get subConfirmCycleValue => '1 年 · 自动续订';

  @override
  String get subConfirmEffective => '生效';

  @override
  String get subConfirmEffectiveValue => 'App Store 确认后立即生效';

  @override
  String get subConfirmPayVia => '付款方式';

  @override
  String get subConfirmPayViaValue => '你的 App Store 账户';

  @override
  String subConfirmRelatives(int count) {
    return '立即邀请最多 $count 位爷爷奶奶、亲友';
  }

  @override
  String subConfirmLimits(int storage, int video, String original) {
    String _temp0 = intl.Intl.selectLogic(original, {
      'yes': ' · 保存原图',
      'other': '',
    });
    return '$storage GB · 视频 ≤ $video 分钟$_temp0';
  }

  @override
  String get subConfirmTrialNote => '剩余试用期不叠加——年度周期从今天开始';

  @override
  String get subConfirmCta => '继续前往 App Store';

  @override
  String get subConfirmLegal =>
      '下一步是 App Store 付款页面。每年自动续订，可随时在 App Store 设置中取消。';

  @override
  String get subLinkTerms => '条款';

  @override
  String subLimitVideoTitle(int minutes) {
    return '这段视频长 $minutes 分钟';
  }

  @override
  String subLimitVideoBody(String plan, int max) {
    return '$plan每段视频最长可保存 $max 分钟。你可以剪短，或用文字记下这一刻。';
  }

  @override
  String get subLimitSafe => '你的回忆依然安全——没有删除任何内容，正在编辑的内容也会保留。';

  @override
  String subLimitTrim(int max) {
    return '剪至 $max 分钟';
  }

  @override
  String get subLimitPickAnother => '选择其他视频';

  @override
  String get subLimitSaveDiary => '保存为文字日记';

  @override
  String get subLimitTopPlan => '我们家已在使用最高套餐（Family），无需再升级。';

  @override
  String get subLimitUpgrade => '升级到 Family';

  @override
  String subLimitTrimmed(int max) {
    return '视频已剪至 $max 分钟';
  }

  @override
  String get subIssueTitle => '续订付款未成功';

  @override
  String subIssueBody(String plan) {
    return '请检查付款方式以免中断。在此期间，我们家的$plan仍正常使用。';
  }

  @override
  String get subIssueAction => '在 App Store 中检查';

  @override
  String get invInvalidTipMessage => '联系邀请你的人（宝宝的爸妈），请他们创建新的邀请。';

  @override
  String get invInvalidTipCode => '如果已有新的 8 位邀请码，可以立即输入。';

  @override
  String get invEnterOtherCode => '输入其他邀请码';

  @override
  String invElsewhereTitle(String callName) {
    return '你已是另一个家庭的$callName';
  }

  @override
  String get invElsewhereBody => '每个账户只能是一个家庭的爸妈，所以你暂时无法接受这个邀请。';

  @override
  String invElsewhereInvite(String inviter, String family) {
    return '$inviter 邀请你加入$family';
  }

  @override
  String invElsewhereRole(String callName) {
    return '建议角色：宝宝们的$callName';
  }

  @override
  String get invElsewhereJoinRelative => '以亲友身份加入';

  @override
  String invElsewhereJoinRelativeHint(String inviter) {
    return '不可用——此邀请仅限爸妈。如果想看宝宝们，请让 $inviter 发送亲友邀请。';
  }

  @override
  String get invElsewhereLeave => '了解如何离开当前家庭';

  @override
  String get invElsewhereLeaveHint => '爸妈可选的方式及如何求助';

  @override
  String get invWaitingTitle => '请求已发送';

  @override
  String invWaitingBody(String inviter) {
    return '$inviter 确认后即可完成。你可以先关闭应用——完成后会立即通知你。';
  }

  @override
  String invWaitingStepJoined(String family) {
    return '你已接受加入$family的邀请';
  }

  @override
  String invWaitingStepRole(String callName) {
    return '角色：宝宝们的$callName';
  }

  @override
  String invWaitingStepConfirm(String inviter) {
    return '等待 $inviter 确认';
  }

  @override
  String invWaitingStepConfirmHint(String inviter) {
    return '$inviter 开启了“最终确认”，以确保是你本人';
  }

  @override
  String invWaitingStepTrial(int days) {
    return '我们家开始 $days 天免费试用';
  }

  @override
  String get invWaitingNotice => '你会收到“欢迎回家！”的通知';

  @override
  String famPartnerLeftBanner(String partner, String family) {
    return '$partner 已离开$family（删除了账户）。在新伴侣加入前，我们家处于仅查看和下载模式。';
  }

  @override
  String get famPartnerInviteSubtitle =>
      '伴侣加入后，全家又能一起记录回忆、完成任务，并使用 Papa & Mama 空间。';

  @override
  String get famPartnerInviteRole => '邀请身份';

  @override
  String get famPartnerRecipientSees => '对方加入前会看到';

  @override
  String famPartnerRecipientHint(String name, String callName) {
    return '来自 $name（$callName）的邀请 · 仅宝宝们的名字和头像';
  }

  @override
  String get famPartnerRevoke => '撤回邀请';

  @override
  String get famPartnerRevoked => '邀请已撤回';

  @override
  String famInvitesCapacity(String family, int active, int pending) {
    return '$family亲友：$active 位已加入 · $pending 位待加入';
  }

  @override
  String get famInvitesPending => '待处理';

  @override
  String get famInvitesExpired => '已过期';

  @override
  String get famInviteNotOpened => '尚未打开链接';

  @override
  String get famInviteOpened => '已打开链接';

  @override
  String get famInviteExpiredTag => '已过期';

  @override
  String get famInviteKindRelative => '亲友邀请';

  @override
  String get famInvitePermView => '查看';

  @override
  String get famInvitePermComment => '查看 + 评论';

  @override
  String get famInvitePermPost => '查看 + 评论 + 发照片';

  @override
  String famInviteDates(String created, String expires, String daysLeft) {
    return '创建于 $created · $expires 过期 · $daysLeft';
  }

  @override
  String famInviteDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '剩 $count 天',
      zero: '今天过期',
    );
    return '$_temp0';
  }

  @override
  String famInviteExpiredOn(String date) {
    return '已于 $date 过期 · 链接无法打开';
  }

  @override
  String get famInviteResend => '重新发送链接';

  @override
  String get famInviteRevoke => '撤回';

  @override
  String get famInviteRenew => '创建新邀请';

  @override
  String famInviteResent(String callName) {
    return '已重新发送链接给 $callName';
  }

  @override
  String famInviteRevokedName(String callName) {
    return '已撤回给 $callName 的邀请';
  }

  @override
  String famInviteRenewed(String callName) {
    return '已为 $callName 创建新邀请';
  }

  @override
  String get famInvitesRules =>
      '亲友邀请 14 天后过期，且只能使用一次。撤回后旧链接将无法打开。最多 12 位亲友（含待处理邀请）。';

  @override
  String get famInviteMore => '邀请更多亲友';

  @override
  String get famInvitesEmpty => '暂无待处理的邀请';

  @override
  String get famSwitchTitle => '切换家庭';

  @override
  String famSwitchSubtitle(String callName, String family) {
    return '你是$family的$callName，也是另一个家庭的亲友。';
  }

  @override
  String famSwitchRoleParent(String callName) {
    return '$callName（爸妈）';
  }

  @override
  String famSwitchRoleRelative(String callName) {
    return '$callName（亲友）';
  }

  @override
  String get famSwitchViewing => '正在查看';

  @override
  String famSwitchFollows(String names) {
    return '关注宝宝 $names';
  }

  @override
  String famSwitchNote(String family) {
    return '切换后整个应用都会换成所选家庭。在$family，你只能看到分享给你的宝宝照片——没有照顾宝宝和 Papa & Mama。每个账户只能是一个家庭的爸妈。';
  }

  @override
  String famSwitchMock(String family) {
    return '示例中只有$family的数据。';
  }

  @override
  String get setAiMaster => '使用 AI 辅助';

  @override
  String get setAiMasterHint => 'AI 仅在你点按时运行。所有结果都是草稿，可修改、舍弃或保存。';

  @override
  String get setAiQuotaLabel => '本月剩余 AI 次数';

  @override
  String setAiQuotaTotal(int total) {
    return '/ $total 次';
  }

  @override
  String setAiRenews(String date) {
    return '$date 重置';
  }

  @override
  String setAiPlanQuota(String plan, int total) {
    return '$plan · 全家每月 $total 次';
  }

  @override
  String get setAiFeatures => '各项功能';

  @override
  String get setAiDataSection => '发送的数据';

  @override
  String get setAiData1 => '只发送各功能列出的内容，且仅限你点按的那一次。';

  @override
  String get setAiData2 => 'AI 不读取私人日记，不做诊断，也不会擅自给任何人发消息。';

  @override
  String get setAiData3 => '首次使用各项功能时，应用会先征得你的同意。';

  @override
  String get setAiData4 => '所有草稿都带有“✨ AI 建议”标签。';

  @override
  String get setAiDataLink => '查看发送给 AI 服务商的数据详情';

  @override
  String get setAiReport => '举报 AI 内容';

  @override
  String get setAiFoot => '关闭 AI 后，Baby Family 的所有功能仍可正常使用。';

  @override
  String get setBlockedBody => '被屏蔽的人无法评论或回应你的内容，你也不会收到与他们相关的通知。';

  @override
  String setBlockedSection(int count) {
    return '已屏蔽 · $count 人';
  }

  @override
  String setBlockedSince(String date) {
    return '自 $date 起屏蔽';
  }

  @override
  String get setUnblock => '取消屏蔽';

  @override
  String setUnblocked(String name) {
    return '已取消屏蔽 $name';
  }

  @override
  String get setUnblockInfo => '取消屏蔽后，此人可以像以前一样评论和回应你的内容。你可以随时在其主页再次屏蔽。';

  @override
  String get setBlockedPartnerNote =>
      'Papa 和 Mama 在应用中不能互相屏蔽。如需安静一下，可以在 Papa & Mama 中关闭心情分享。';

  @override
  String get setBlockedEmpty => '你还没有屏蔽任何人';

  @override
  String get commonDeleteForever => '永久删除';

  @override
  String memTrashInfo(int days) {
    return '已删除的回忆会保留 $days 天后才彻底删除。你能看到家里所有被删除的回忆。';
  }

  @override
  String memTrashInfoOwn(int days) {
    return '已删除的回忆会保留 $days 天后才彻底删除。你能看到自己删除的回忆。';
  }

  @override
  String memTrashCount(int count) {
    return '$count 条回忆';
  }

  @override
  String memTrashDeletedBy(String callName, String date) {
    return '$callName 于 $date 删除 ·';
  }

  @override
  String get memTrashFootnote => '恢复后，回忆会回到时间线上原来的位置，评论和点赞也会一起恢复。';

  @override
  String get memTrashEmpty => '回收站是空的';

  @override
  String memTrashEmptyHint(int days) {
    return '你删除的回忆会在这里保留 $days 天，方便你改变主意。';
  }

  @override
  String memTrashRestored(String title) {
    return '已恢复“$title”';
  }

  @override
  String get memTrashDeleted => '已永久删除';

  @override
  String get memTrashConfirmTitle => '永久删除这条回忆？';

  @override
  String get memTrashConfirmBody => '这条回忆的照片、评论和点赞将彻底消失，之后无法恢复。';

  @override
  String get memTrashKeep => '保留在回收站';

  @override
  String memCommentCount(int count) {
    return '$count 条评论';
  }

  @override
  String memHeartCount(int count) {
    return '$count 个点赞';
  }

  @override
  String get memMoveToTrash => '删除回忆';

  @override
  String memMovedToTrash(int days) {
    return '已移至回收站 · 保留 $days 天';
  }

  @override
  String get memMoveToTrashTitle => '删除这条回忆？';

  @override
  String memMoveToTrashBody(int days) {
    return '回忆会在回收站保留 $days 天，期间可以恢复。';
  }

  @override
  String get memDraftsSubtitle => '未写完的回忆会在你中途退出时自动保存。只有你能看到草稿。';

  @override
  String get memDraftsDevice => '本设备';

  @override
  String get memDraftsCloud => '已保存到账户';

  @override
  String get memDraftsLocalNote => '本设备上的草稿尚未保存到账户——删除应用后会丢失。';

  @override
  String get memDraftContinue => '继续编辑';

  @override
  String memDraftEditedToday(String time) {
    return '今天 $time 编辑';
  }

  @override
  String memDraftEditedYesterday(String time) {
    return '昨天 $time 编辑';
  }

  @override
  String memDraftEditedOn(String date, String time) {
    return '$date $time 编辑';
  }

  @override
  String memDraftSavedOn(String date, String time) {
    return '$date $time 保存';
  }

  @override
  String memDraftSavedOnDevice(String date, String time, String device) {
    return '$date $time 在 $device 上保存';
  }

  @override
  String get memKindMoment => '瞬间';

  @override
  String memKindVoiceDuration(String duration) {
    return '语音 $duration';
  }

  @override
  String get memDraftsEmpty => '还没有草稿';

  @override
  String get memDraftsEmptyHint => '编辑时中途退出，回忆会保存在这里。';

  @override
  String get memDraftDeleted => '草稿已删除';

  @override
  String get memDraftSaved => '已存入草稿';

  @override
  String get memDraftView => '查看草稿';

  @override
  String get memShortcutTrash => '回收站';

  @override
  String get memShortcutDrafts => '草稿';

  @override
  String get memShortcutPending => '待审核照片';

  @override
  String memPendingSubtitle(String partner) {
    return '亲人发的照片需你或$partner审核后才会对全家显示。等待期间只有发布者和父母能看到。';
  }

  @override
  String get memPendingKids => '照片中的宝宝';

  @override
  String get memPendingAudience => '谁能看到';

  @override
  String get memPendingReject => '拒绝';

  @override
  String get memPendingApprove => '通过并显示';

  @override
  String get memPendingRejectReason => '拒绝原因（可选）';

  @override
  String memPendingRejectHint(String name) {
    return '$name会收到这条温和的留言。照片不会对其他人显示。';
  }

  @override
  String get memPendingRejectSend => '拒绝照片';

  @override
  String memPendingWaited(int count) {
    return '已等待 $count 天';
  }

  @override
  String get memPendingEmpty => '没有待审核的照片';

  @override
  String get memPendingEmptyHint => '亲人为孩子发的照片会显示在这里等你审核。';

  @override
  String get memPendingApproved => '已通过——照片已对全家显示';

  @override
  String get memPendingRejected => '已拒绝照片';

  @override
  String memPendingAddChild(String name) {
    return '添加$name';
  }

  @override
  String get rptTitleMemory => '举报这条回忆';

  @override
  String get rptTitleComment => '举报这条评论';

  @override
  String rptTitlePerson(String name) {
    return '举报$name';
  }

  @override
  String get rptSubtitle => '告诉我们哪里不对。Baby Family 安全团队会进行审查。';

  @override
  String get rptNoteHint => '补充说明（可选）…';

  @override
  String get rptHideMemory => '立即对我隐藏这条回忆';

  @override
  String get rptHideComment => '立即对我隐藏这条评论';

  @override
  String get rptHidePerson => '立即对我隐藏此人';

  @override
  String get rptRemoveContent => '从家庭中移除';

  @override
  String get rptRemoveContentHint => '仅限父母 · 回忆将不再对任何人显示';

  @override
  String get rptRemovePerson => '移除亲人';

  @override
  String rptRemovePersonHint(String name) {
    return '仅限父母 · $name将无法再查看孩子的照片';
  }

  @override
  String get rptSend => '提交举报';

  @override
  String get rptSentTitle => '举报已提交';

  @override
  String get rptSentBodyHidden => '感谢你的反馈。该回忆已暂时隐藏，将在24小时内审核。处理完成后我们会通知你。';

  @override
  String get rptSentBody => '感谢你的反馈。我们会尽快审核，处理完成后会通知你。';

  @override
  String get rptCodeLabel => '举报编号';

  @override
  String get rptStatusReviewing => '审核中';

  @override
  String get rptStatusResolved => '已处理';

  @override
  String get rptTrack => '在 设置 › 我的举报 中查看进度';

  @override
  String get rptDone => '完成';

  @override
  String rptBlockTitle(String name) {
    return '屏蔽$name？';
  }

  @override
  String rptBlockEffectComment(String name) {
    return '$name将无法再评论或点赞你的回忆。';
  }

  @override
  String rptBlockEffectNotify(String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': '她',
      'grandpa': '他',
      'other': '对方',
    });
    return '$_temp0不会收到与你有关的通知。';
  }

  @override
  String rptBlockEffectStay(String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': '她',
      'grandpa': '他',
      'other': '对方',
    });
    return '$_temp0仍在家庭中，仍能看到共享的孩子照片。';
  }

  @override
  String rptBlockRemove(String name) {
    return '同时将$name移出家庭';
  }

  @override
  String rptBlockRemoveHint(String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': '她',
      'grandpa': '他',
      'other': '对方',
    });
    return '如果你不希望$_temp0再看孩子的照片，请选择此项。';
  }

  @override
  String get rptBlockConfirm => '屏蔽';

  @override
  String rptBlockDone(String name) {
    return '已屏蔽$name';
  }

  @override
  String rptBlockMenu(String name) {
    return '屏蔽$name';
  }

  @override
  String chdArchiveAddedBy(String birth, String callName, String date) {
    return '出生于 $birth · $callName 于 $date 添加';
  }

  @override
  String chdArchiveBorn(String birth) {
    return '出生于 $birth';
  }

  @override
  String chdArchiveDuplicate(String name) {
    return '可能与$name重复';
  }

  @override
  String chdArchiveSection(String name) {
    return '归档$name后';
  }

  @override
  String chdArchiveEffectHide(String name) {
    return '$name会从宝宝切换、首页和回忆中隐藏。';
  }

  @override
  String chdArchiveEffectPrivate(int count, String name) {
    return '仅标记$name的 $count 条回忆也会隐藏。';
  }

  @override
  String chdArchiveEffectShared(int count, String others) {
    return '与$others共同的 $count 条回忆仍显示在$others的页面。';
  }

  @override
  String get chdArchiveEffectRestore => '随时可在 孩子 › 已归档 中恢复。';

  @override
  String chdArchiveAction(String name) {
    return '归档$name';
  }

  @override
  String get chdArchiveDeleteSection => '永久删除';

  @override
  String chdArchiveLockedTitle(int days) {
    return '需归档至少 $days 天';
  }

  @override
  String chdArchiveLockedBody(String date, String name) {
    return '为避免误删，若今天归档，可于 $date 起删除。仅属于$name的内容会进入回收站保留30天。';
  }

  @override
  String chdArchiveLockedBodyArchived(String date, String name) {
    return '为避免误删，可于 $date 起删除。仅属于$name的内容会进入回收站保留30天。';
  }

  @override
  String chdArchived(String name) {
    return '已归档$name';
  }

  @override
  String chdRestored(String name) {
    return '已恢复$name';
  }

  @override
  String chdDeleteTitle(String name) {
    return '永久删除$name';
  }

  @override
  String chdDeleteArchivedName(String name) {
    return '$name · 已归档';
  }

  @override
  String chdDeleteArchivedFor(int days, String date) {
    return '已归档 $days 天 · 自 $date';
  }

  @override
  String chdDeleteEnough(int days) {
    return '已满 $days 天';
  }

  @override
  String chdDeleteEffectTrash(int count, String name) {
    return '仅属于$name的 $count 条回忆会进入回收站30天，之后彻底删除。';
  }

  @override
  String chdDeleteEffectShared(String others) {
    return '与$others共同的回忆仍保留在$others的页面。';
  }

  @override
  String get chdDeleteStep1 => '确认 1/2';

  @override
  String chdDeleteConfirm1(String name) {
    return '我明白$name将被删除，且此档案无法恢复。';
  }

  @override
  String get chdDeleteStep2 => '确认 2/2 · 输入宝宝名字';

  @override
  String chdDeleteHint(String name) {
    return '准确输入“$name”以解锁删除按钮。';
  }

  @override
  String chdDeleteAction(String name) {
    return '永久删除$name';
  }

  @override
  String chdDeleteRestoreInstead(String name) {
    return '改为恢复$name';
  }

  @override
  String chdDeleted(String name) {
    return '已删除$name';
  }

  @override
  String cirChildTomorrow(int months) {
    return '🎉 明天满 $months 个月';
  }

  @override
  String get cirChildFirsts => '宝贝的第一次';

  @override
  String get cirChildMemories => '宝贝的回忆';

  @override
  String cirChildMonth(int month) {
    return '第 $month 个月';
  }

  @override
  String cirChildMonthRange(String start, String end) {
    return '· $start – $end';
  }

  @override
  String get cirChildEmpty => '还没有宝贝的回忆';

  @override
  String cirDetailDownloadOff(String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': '您',
      'grandpa': '您',
      'other': '你',
    });
    return '下载照片：父母尚未为$_temp0开启';
  }

  @override
  String cirDetailAuthorAge(String name, String age) {
    return '$name $age';
  }

  @override
  String get cirDetailLiked => '已点赞';

  @override
  String cirDetailYou(String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': '您',
      'grandpa': '您',
      'other': '你',
    });
    return '$_temp0';
  }

  @override
  String cirDetailReactedBy(String names) {
    return '$names点了赞';
  }

  @override
  String cirDetailWishes(int count) {
    return '祝福（$count）';
  }

  @override
  String get cirDetailWishHint => '给宝贝写句祝福…';

  @override
  String get cirDetailVoice => '录制语音祝福';

  @override
  String get cirDetailSend => '发送祝福';

  @override
  String get cirDetailReported => '举报已提交';

  @override
  String get cirDetailMissing => '这条回忆已不再共享';

  @override
  String cirPostSelected(int count) {
    return '已选照片（$count）';
  }

  @override
  String get cirPostWhichKid => '是哪个宝贝的照片？';

  @override
  String get cirPostDate => '拍摄日期';

  @override
  String get cirPostMessage => '给宝贝的留言';

  @override
  String get cirPostMessageHint => '写几句话给宝贝…';

  @override
  String get cirPostApprovalTitle => '父母审核后才会显示';

  @override
  String get cirPostApprovalBody => '经宝贝的爸爸或妈妈同意后，照片才会对全家显示。';

  @override
  String get cirPostSend => '发送照片';

  @override
  String get cirPostRemovePhoto => '移除照片';

  @override
  String get cirPostSentTitle => '已发送！';

  @override
  String get cirPostSentBody => '爸爸/妈妈审核后才会对全家显示。';

  @override
  String get cirPostPending => '等待爸爸/妈妈审核';

  @override
  String get cirPostJustSent => '刚刚发送';

  @override
  String get cirPostBackHome => '返回宝贝页';

  @override
  String get cirPostMore => '再发照片';

  @override
  String get cirPostNoKid => '父母尚未为任何宝贝开启发照片权限';

  @override
  String cirPausedMessage(String family) {
    return '$family已暂停与亲人分享';
  }

  @override
  String get cirPausedSafe => '宝贝的照片依然安全保存';

  @override
  String cirMeRelation(String relation, String family) {
    return '$relation · $family';
  }

  @override
  String cirMeTextPreview(String name, String who) {
    return '$name有新照片啦，快来看看吧 🌸';
  }

  @override
  String get cirMeInstant => '有新照片时立即通知';

  @override
  String get cirMeDigest => '每日简报';

  @override
  String cirMeDigestHint(String time) {
    return '$time 发送 · 汇总当天新照片';
  }

  @override
  String get cirMeSwitchFamily => '切换家庭';

  @override
  String cirMeViewing(String family) {
    return '正在查看：$family';
  }

  @override
  String cirLeaveTitle(String family) {
    return '离开$family';
  }

  @override
  String cirLeaveBody(String who, String inviter) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': '您',
      'grandpa': '您',
      'other': '你',
    });
    return '$_temp0将无法再查看和评论宝贝的照片。想回来时，请$inviter重新发送邀请。';
  }

  @override
  String cirLeaveFollowing(String who, String names) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': '您',
      'grandpa': '您',
      'other': '你',
    });
    return '$_temp0正在关注$names';
  }

  @override
  String cirLeavePosted(String who, int photos, int comments) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': '您',
      'grandpa': '您',
      'other': '你',
    });
    return '$_temp0发布的内容 · $photos 张照片，$comments 条评论';
  }

  @override
  String get cirLeaveKeep => '保留给家人';

  @override
  String cirLeaveKeepHint(String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': '您',
      'grandpa': '您',
      'other': '你',
    });
    return '家人仍能看到$_temp0的照片和留言。（默认）';
  }

  @override
  String get cirLeaveRemove => '全部移除';

  @override
  String cirLeaveRemoveHint(String who, String family) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': '您',
      'grandpa': '您',
      'other': '你',
    });
    return '$_temp0的照片和评论将从$family移除。';
  }

  @override
  String cirLeaveNotice(String inviter, String name, String who) {
    String _temp0 = intl.Intl.selectLogic(who, {
      'grandma': '您',
      'grandpa': '您',
      'other': '你',
    });
    return '$inviter会收到一条简短通知：“$name已离开家庭。”确认后$_temp0将立即失去查看权限。';
  }

  @override
  String get cirLeaveStay => '留下';

  @override
  String commonListAnd(String list, String last) {
    return '$list和$last';
  }

  @override
  String get commonAiSuggested => 'AI 建议';

  @override
  String get commonAiReport => '举报 AI 内容';

  @override
  String get commonAiReported => '谢谢——我们会复查这条 AI 内容。';

  @override
  String commonWeekRange(String range) {
    return '$range 这一周';
  }

  @override
  String get usOnlyParents => '仅限 Papa 和 Mama';

  @override
  String get usPartnerLeftTitle => '这个空间需要你们两个人';

  @override
  String usPartnerLeftBody(String callName, String familyName) {
    return '$callName 的账户已删除，所以 Papa & Mama 暂时锁定。$familyName 的回忆都还在——你可以随时查看和下载。';
  }

  @override
  String usPartnerLeftStateTitle(String familyName) {
    return '$familyName 目前仅可查看和下载';
  }

  @override
  String get usPartnerLeftStateSub => '邀请新的伴侣，继续创建回忆并使用 Papa & Mama。';

  @override
  String get usPartnerLeftSection => '两个人都在时';

  @override
  String get usPartnerLeftCheckinSub => '我今天怎么样';

  @override
  String get usPartnerLeftRequestSub => '互相请求，没有压力';

  @override
  String get usPartnerLeftThanksSub => '记住小事';

  @override
  String get usPartnerLeftJournalSub => '只有你能看';

  @override
  String get usPartnerLeftPrivacy => '祖父母和亲友永远看不到 Papa & Mama 里的内容。';

  @override
  String get usPartnerLeftInvite => '邀请伴侣加入';

  @override
  String usCheckinAnnoyedPartner(String callName) {
    return '对 $callName 不满';
  }

  @override
  String get usBridgeAskTitle => '要使用“心桥”吗？';

  @override
  String usBridgeAskBody(String callName) {
    return '还没有发送任何内容给 $callName。“心桥”帮助你们说清感受，一起选一个小步骤——从私密的一步开始。';
  }

  @override
  String get usBridgeAskOpen => '打开心桥';

  @override
  String usBridgeStepKicker(int step, int total) {
    return '心桥 · 第 $step/$total 步';
  }

  @override
  String usBridgeFeelSub(String callName) {
    return '选择一种或几种感受。还没有发送任何内容给 $callName。';
  }

  @override
  String get usBridgeTopicTitle => '这件事关于…';

  @override
  String usBridgeTopicSub(String callName) {
    return '可选——你可以跳过。还没有发送任何内容给 $callName。';
  }

  @override
  String get usBridgeNeedTitle => '此刻我需要…';

  @override
  String usBridgeNeedSub(String callName) {
    return '选择一项或几项。还没有发送任何内容给 $callName。';
  }

  @override
  String get usBridgeFeltLabel => '我感到';

  @override
  String get usBridgeAboutLabel => '关于';

  @override
  String get usBridgeDraftLabel => '私人草稿（可选）';

  @override
  String usBridgeDraftCount(int count, int max) {
    return '$count/$max';
  }

  @override
  String get usBridgeDraftHint => '写下你的想法——只有你能看。';

  @override
  String get usBridgeDraftNote => '这份草稿永远不会被原样或自动发送。';

  @override
  String get usBridgeUnsafe => '我感到不安全';

  @override
  String get usBridgeChoiceTitle => '你想怎么处理这些内容？';

  @override
  String usBridgeChoiceSub(String callName) {
    return '由你决定。还没有发送任何内容给 $callName。';
  }

  @override
  String get usBridgeKeepPrivateDesc => '到此为止，就像一页日记。';

  @override
  String get usBridgeRewriteOption => '发送前改写';

  @override
  String get usBridgeRewriteOptionDesc => '选一句话，用更温和的方式改写。';

  @override
  String get usBridgeShareOption => '选择要分享的内容';

  @override
  String usBridgeShareOptionDesc(String callName) {
    return '选择 $callName 会看到的感受和需要。';
  }

  @override
  String get usBridgeKeptPrivate => '已保持私密——只有你能看到。';

  @override
  String usBridgePreviewTitle(String callName) {
    return '预览 $callName 会收到的内容';
  }

  @override
  String get usBridgePreviewSub => '只会发送你选中的内容。你的私人草稿仍然保密。';

  @override
  String get usBridgeFeelShort => '感到';

  @override
  String get usBridgeNeedShort => '需要';

  @override
  String get usBridgeMessageLabel => '留言（可选）';

  @override
  String usBridgeMessageHint(String callName) {
    return '一句你想让 $callName 读到的话';
  }

  @override
  String get usBridgeSendInvite => '发送邀请';

  @override
  String usBridgeInviteSent(String callName) {
    return '已向 $callName 发送邀请';
  }

  @override
  String get usBridgeRewriteSub => '选一个版本，再按你的意思修改。不会自动发送任何内容。';

  @override
  String get usBridgeRewriteOriginal => '你的原句';

  @override
  String usBridgeRewriteTone(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'neutral': '中性',
      'warm': '温暖',
      'other': '简短',
    });
    return '$_temp0';
  }

  @override
  String get usBridgeRewriteEdit => '使用前修改';

  @override
  String get usBridgeRewriteKeep => '保留原句';

  @override
  String get usBridgeRewriteUse => '用这句';

  @override
  String get usBridgeRewriteDataNote => '只有你选中的句子会发送给 AI 改写。AI 不会读取你的私人草稿或日记。';

  @override
  String usBridgeInviteTitle(String callName) {
    return '$callName 想在你准备好时平静地聊一聊';
  }

  @override
  String get usBridgeInviteSub => '一个说清感受、一起选择下一小步的空间。没有输赢。';

  @override
  String usBridgeInviteShared(String callName) {
    return '$callName 选择分享';
  }

  @override
  String usBridgeInviteSharedSub(String callName) {
    return '只有这些——其余的 $callName 保密';
  }

  @override
  String get usBridgeInviteNote => '进入共同对话前，你也有一个私密步骤来说出感受和需要。';

  @override
  String get usBridgeJoinNow => '立即加入';

  @override
  String get usBridgeLaterLabel => '稍后——提醒我';

  @override
  String get usBridgeLaterCustom => '自选';

  @override
  String get usBridgeNotReady => '我还没准备好';

  @override
  String get usBridgeNotReadySub => '邀请会暂停——不会有任何负面通知。';

  @override
  String get usBridgeRemindSet => '已设置提醒——邀请会保留。';

  @override
  String get usBridgePaused => '已暂停。你可以随时回来。';

  @override
  String get usBridgeLive => '进行中';

  @override
  String usBridgeStartedAt(String time, String date) {
    return '开始于 $time · $date';
  }

  @override
  String get usBridgeSessionIntro => '慢慢读你们选择分享的内容。这里没有对错。';

  @override
  String usBridgeYouName(String callName) {
    return '你（$callName）';
  }

  @override
  String usBridgeFeels(String callName) {
    return '$callName 感到';
  }

  @override
  String usBridgeNeeds(String callName) {
    return '$callName 需要';
  }

  @override
  String get usBridgeYouPending => '你还没选择';

  @override
  String get usBridgeYouUnderstood => '你：我理解';

  @override
  String usBridgePartnerPending(String callName) {
    return '$callName 还没选择';
  }

  @override
  String usBridgePartnerUnderstood(String callName) {
    return '$callName：我理解';
  }

  @override
  String get usBridgeYourTurn => '轮到你了';

  @override
  String usBridgePartnerReadDone(String callName) {
    return '$callName 已读完';
  }

  @override
  String usBridgeReadQuestion(String callName) {
    return '你读过 $callName 分享的内容了吗？';
  }

  @override
  String get usBridgeClarify => '我需要说清楚些';

  @override
  String get usBridgeUnderstand => '我理解';

  @override
  String get usBridgeClarifyNote => '“说清楚些”会多给一次表达机会——发送前你会看到确切内容。';

  @override
  String get usBridgeLeaveNote => '任何一方都可以随时暂停或离开。';

  @override
  String usBridgeWaiting(String callName) {
    return '等待 $callName 读完';
  }

  @override
  String usBridgeClarifyTitle(String callName) {
    return '向 $callName 说清楚些';
  }

  @override
  String usBridgeClarifySent(String callName) {
    return '已发送给 $callName';
  }

  @override
  String get usBridgeNextKicker => '心桥 · 你们都理解了';

  @override
  String get usBridgeNextSub => '选一件你们都能做的事。不需要今天解决所有问题。';

  @override
  String get usBridgeWhen => '什么时候？';

  @override
  String get usBridgeWhichChild => '照看哪个宝宝？';

  @override
  String get usBridgeReminder => '为两人设置提醒';

  @override
  String usBridgeReminderSub(String time) {
    return '$time 提醒——只有你们两人可见';
  }

  @override
  String get usBridgeNotConfirmed => '未确认';

  @override
  String get usBridgeAgreed => '已同意';

  @override
  String get usBridgeConfirmStep => '确认这一步';

  @override
  String get usBridgeConfirmNote => '两人都确认后这一步才生效。你仍然可以更改选择。';

  @override
  String get usBridgeCloseTitle => '你们要结束这次对话吗？';

  @override
  String get usBridgeCloseSub => '只有两人都同意才会结束。';

  @override
  String usBridgeStepChosen(String when) {
    return '已选步骤 · $when';
  }

  @override
  String usBridgeRelativeWhen(String day, String time) {
    String _temp0 = intl.Intl.selectLogic(day, {
      'tonight': '今晚 $time',
      'lastNight': '昨晚 $time',
      'today': '今天 $time',
      'yesterday': '昨天 $time',
      'other': '$time',
    });
    return '$_temp0';
  }

  @override
  String usBridgePartnerAgreedClose(String callName) {
    return '$callName 已同意结束';
  }

  @override
  String usBridgeThanksLabel(String callName) {
    return '给 $callName 发一句感谢？（可选）';
  }

  @override
  String usBridgeThanksListened(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {'other': '谢谢你愿意倾听 💛'});
    return '$_temp0';
  }

  @override
  String usBridgeThanksShort(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {'other': '谢谢你'});
    return '$_temp0';
  }

  @override
  String usBridgeRetention(int days, String date) {
    return '对话内容将在 $days 天后自动删除，只保留“$date 有过一次心桥对话”这一行。';
  }

  @override
  String get usBridgeCloseConfirm => '结束对话';

  @override
  String get usBridgeCloseLater => '还不，稍后';

  @override
  String get usBridgeClosed => '心桥对话已结束';

  @override
  String get usSafetyQuickExit => '快速退出';

  @override
  String get usSafetyHeadline => '你的安全最重要';

  @override
  String get usSafetyBody => '你现在不需要当面交谈。如果你或孩子们有危险，请立即拨打下面的号码之一。';

  @override
  String usSafetyCall(String number) {
    return '拨打 $number';
  }

  @override
  String get usSafetyTrustedTitle => '联系一位你信任的人';

  @override
  String get usSafetyTrustedSub => '你信任的亲友或邻居';

  @override
  String get usSafetyPrivateNote => '你刚写的内容会保密，不会发送给任何人。';

  @override
  String usSafetyNoNotify(String callName) {
    return '$callName 不会收到关于此页面的任何通知。';
  }

  @override
  String get usSafetyNoHistory => '此页面不会记录在对话历史中。';

  @override
  String get usSafetyKeepPrivate => '保密这些内容';

  @override
  String get usSafetyDisclaimer => 'Baby Family 不是紧急或治疗服务。此功能永远免费。';

  @override
  String get usCoupleWeekCheckins => '次签到';

  @override
  String get usCoupleWeekCheckinsSub => '你们分享了彼此的今天';

  @override
  String get usCoupleWeekRequests => '个请求得到帮助';

  @override
  String get usCoupleWeekRequestsSub => '互相接下并完成';

  @override
  String get usCoupleWeekThanks => '句感谢';

  @override
  String get usCoupleWeekThanksSub => '这周互相发送';

  @override
  String get usCoupleWeekTogether => '个共同任务';

  @override
  String get usCoupleWeekTogetherSub => '来自“我们俩”任务';

  @override
  String get usCoupleWeekThanksKicker => '本周的一句感谢';

  @override
  String usCoupleWeekThanksMeta(String callName, String date) {
    return '$callName · $date';
  }

  @override
  String get usCoupleWeekTogetherLabel => '我们一起';

  @override
  String get usCoupleWeekNote => '没有分数，没有比较——只是你们为彼此做的事。';

  @override
  String get usCoupleWeekSendThanks => '发一句感谢';

  @override
  String get recapDayDiscard => '放弃';

  @override
  String recapDayKicker(String date) {
    return '今日故事 · $date';
  }

  @override
  String recapDayChild(String name, String age) {
    return '$name · $age';
  }

  @override
  String get recapDayRewrite => '重写';

  @override
  String get recapDayManual => '自己写';

  @override
  String get recapDayRewritten => '段落已重写';

  @override
  String get recapDayMemories => '今天的回忆';

  @override
  String recapDaySelected(int selected, int total) {
    return '已选 $selected/$total';
  }

  @override
  String recapDayItemMeta(String kind, String time) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'photo': '照片',
      'mission': '任务已完成',
      'voice': '声音',
      'quote': '语录',
      'video': '视频',
      'other': '回忆',
    });
    return '$_temp0 · $time';
  }

  @override
  String get recapDayHint => '故事只使用你勾选的回忆。';

  @override
  String get recapDayPhotos => '附带照片';

  @override
  String get recapDayWhoSees => '谁能看到';

  @override
  String get recapDaySave => '保存故事';

  @override
  String get recapDaySaved => '今日故事已保存';

  @override
  String get recapDayTitleEdit => '故事标题';

  @override
  String recapDayOpen(String name) {
    return '$name 的今日故事';
  }

  @override
  String recapMonthHeadline(String name, int month) {
    return '$name 满 $month 个月啦 🎉';
  }

  @override
  String recapMonthRange(int month, String range) {
    return '第 $month 个月 · $range';
  }

  @override
  String recapMonthLabel(int month) {
    return '第 $month 个月';
  }

  @override
  String recapMonthNow(int month) {
    return '第 $month 个月 · 今天';
  }

  @override
  String get recapMonthVoices => '语录和声音';

  @override
  String get recapMonthVoicesKicker => '语录和声音';

  @override
  String recapMonthFirstMeta(String age, String date) {
    return '$age · $date';
  }

  @override
  String recapMonthVoiceMeta(String date, String callName) {
    return '$date · $callName 录制';
  }

  @override
  String get careMenuStats => '育儿统计';

  @override
  String get careStatsDone => '全家完成的任务';

  @override
  String get careStatsUnit => '件（本周）';

  @override
  String careStatsCategory(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'care': '照顾',
      'bonding': '亲子',
      'outing': '外出',
      'support': '互相支持',
      'together': '一起',
      'other': '其他',
    });
    return '$_temp0';
  }

  @override
  String get careStatsNote => '“我们俩”任务不计入育儿。';

  @override
  String careStatsBloomOf(int total) {
    return '/ $total 天';
  }

  @override
  String get careStatsBloomLabel => '我们家的树开花了';

  @override
  String get careStatsDisclaimer => '仅基于应用中记录的活动。父母为彼此做的很多事，应用都数不过来。';

  @override
  String get careStatsPrivacy => '只有 Papa 和 Mama 能看到这些统计';

  @override
  String get commonPrevWeek => '上一周';

  @override
  String get commonNextWeek => '下一周';

  @override
  String memPendingNotify(String name, int count, String child) {
    return '$name刚发布了$child的 $count 张照片——等待你审核';
  }

  @override
  String get authProviderUnavailable => '此版本暂不支持 Apple/Google 登录，请使用手机号码。';

  @override
  String onboardingPartnerApproveTitle(String callName) {
    return '$callName 想加入你们的家';
  }

  @override
  String onboardingPartnerApproveBody(int days) {
    return '请确认这确实是你的另一半。同意后，你们家可免费试用 $days 天。';
  }

  @override
  String get onboardingPartnerApprove => '同意';

  @override
  String get onboardingPartnerReject => '不是此人';

  @override
  String get errorOtpInvalid => '验证码不正确或已过期，请重试。';

  @override
  String get errorRateLimited => '操作太频繁，请稍后再试。';

  @override
  String get errorPhoneNotSupported => '暂不支持此手机号码。';

  @override
  String get errorInviteUnavailable => '邀请已过期或已被使用，请让对方重新发送。';

  @override
  String get errorAlreadyInFamily => '你已是另一个家庭的父/母，暂时无法加入。';

  @override
  String get errorServiceUnavailable => '服务器繁忙，请几分钟后再试。';

  @override
  String get memEditTitle => '编辑回忆';

  @override
  String get memEditSaved => '已保存更改';

  @override
  String get memEditAuthorOnlyHint => '只有发布者可以修改说明和日期。你仍可以修改孩子和可见范围。';

  @override
  String get memEditMediaHint => '编辑时暂时无法添加或删除照片。';

  @override
  String get errorVersionConflict => '这条回忆刚在别处被更新。请查看后再保存。';

  @override
  String get errorMemoryNotEditable => '你无法修改这条回忆的这一部分。';

  @override
  String get errorRequestOpenLimit => '你已有 5 个未完成的请求。等其中一个完成后再发送吧。';

  @override
  String get errorRequestResendBlocked => '这个请求刚被回复“今天不行”。稍后再试吧。';

  @override
  String get errorRequestChanged => '这个请求刚有变化。请查看最新状态。';

  @override
  String get notiSomeone => '一位家人';

  @override
  String notiMemoryPublished(String name) {
    return '$name 刚添加了一条新回忆';
  }

  @override
  String notiCommentCreated(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '一条回忆有 $count 条新评论',
      one: '$name 评论了一条回忆',
    );
    return '$_temp0';
  }

  @override
  String notiReactionChanged(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '一条回忆有 $count 个新心情',
      one: '$name 对一条回忆表达了心情',
    );
    return '$_temp0';
  }

  @override
  String notiRequestCreated(String name) {
    return '$name 给你发了一个请求';
  }

  @override
  String notiRequestAccepted(String name) {
    return '$name 接受了你的请求';
  }

  @override
  String notiRequestDone(String name) {
    return '$name 完成了你的请求 💛';
  }

  @override
  String notiRequestDeclined(String name) {
    return '$name 今天没法完成这个请求';
  }

  @override
  String notiRequestAcknowledged(String name) {
    return '$name 看到了你的请求';
  }

  @override
  String notiCheckinShared(String name) {
    return '$name 分享了当前状态';
  }

  @override
  String get notiAppreciationCreated => '你收到了一句感谢 ❤️';

  @override
  String get notiGeneric => '你有一条新动态';

  @override
  String get heartsReasonMission => '为家里做的一件小事';

  @override
  String get heartsReasonRequest => '帮伴侣完成了一个请求';

  @override
  String get heartsReasonOther => '你的 Hearts';

  @override
  String setDelOtpSent(String phone) {
    return '验证码已发送至 $phone';
  }

  @override
  String get errorReauthRequired => '验证已过期，请重新验证。';

  @override
  String get errorExportActive => '仍有一份导出正在准备中，请等待完成。';

  @override
  String get errorEventDateInvalid => '活动日期无效，请再检查一下。';

  @override
  String calendarChildBirthday(String name, int count) {
    return '$name的$count岁生日';
  }

  @override
  String calendarChildMonthiversary(String name, int count) {
    return '$name满$count个月';
  }

  @override
  String notiEventReminder(String title) {
    return '日程提醒：$title';
  }

  @override
  String get notiEventReminderPrivate => '你有一个即将到来的安排';

  @override
  String get notiBadgeEarned => '你的家庭获得了一枚新徽章 🏅';

  @override
  String get memCommentsAllow => '允许评论';

  @override
  String get memCommentsAllowHint => '关闭后大家仍可点表情';

  @override
  String get memCommentsOff => '此回忆已关闭评论';
}
