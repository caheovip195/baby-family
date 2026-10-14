import 'package:baby_family/data/dto/care_board.dart';
import 'package:baby_family/data/dto/couple_today.dart';
import 'package:baby_family/data/dto/fetal_size.dart';
import 'package:baby_family/data/model/care/family_tree.dart';
import 'package:baby_family/data/model/care/mission.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/family.dart';
import 'package:baby_family/data/model/family/family_membership.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/memory/bump_photo.dart';
import 'package:baby_family/data/model/memory/chapter_summary.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/model/memory/memory_perspective.dart';
import 'package:baby_family/data/model/memory/memory_prompt.dart';
import 'package:baby_family/data/model/memory/milestone_item.dart';
import 'package:baby_family/data/model/memory/monthly_photo.dart';
import 'package:baby_family/data/model/memory/story_item.dart';
import 'package:baby_family/data/model/memory/week_summary.dart';
import 'package:baby_family/data/model/pregnancy/name_candidate.dart';
import 'package:baby_family/data/model/pregnancy/prep_item.dart';
import 'package:baby_family/data/model/pregnancy/prep_summary.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/care.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/notification.dart';
import 'package:baby_family/data/provider/pregnancy.dart';
import 'package:baby_family/data/provider/us.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:hooks_riverpod/legacy.dart';

/// HOME-01 (Cả nhà, Pencil ClpJ6/uEPMP), HOME-02 (bé đã sinh, gfj2H),
/// HOME-03 (thai kỳ, l2ePul). Chủ thể theo `selectedSubjectProvider` (SW-01).
final homeTabControllerProvider =
    ChangeNotifierProvider.autoDispose<HomeTabController>(
      HomeTabController.new,
    );

class HomeTabController extends BaseNotifier {
  HomeTabController(super.ref) {
    ref
      ..listen(selectedSubjectProvider, (_, _) => load())
      ..listen(mockRevisionProvider, (_, _) => load(silent: true))
      ..listen(appLanguageProvider, (_, _) => load(silent: true));
    load();
  }

  /// Số ảnh story tối đa trong dải “Hôm nay của {bé}” (HOME-02).
  static const todayStripCount = 4;

  /// Số ảnh tháng / ảnh bụng hiển thị trên Trang chủ (HOME-02/03).
  static const monthlyRowCount = 6;
  static const bumpRowCount = 5;

  /// Số mục chuẩn bị đón bé xem trước (HOME-03).
  static const prepPreviewCount = 2;

  /// Số ảnh trong lưới thẻ nhóm ảnh (HOME-01 “Mới trong nhà”).
  static const groupGridCount = 3;

  int _revision = 0;
  bool hasError = false;
  bool loaded = false;

  DateTime today = DateTime(0);
  DateTime now = DateTime(0);
  List<Child> children = const [];
  List<Member> members = const [];
  Member? me;
  int unreadCount = 0;

  /// SUB-06: gói của gia đình (banner thanh toán gia hạn chưa thành công).
  Family? family;
  bool _paymentIssueDismissed = false;

  // HOME-01
  List<StoryItem> stories = const [];
  CareBoard? board;
  CoupleToday? couple;
  MemoryPrompt? prompt;
  List<Memory> memories = const [];
  WeekSummary? week;
  FamilyTree? tree;
  List<MonthlyPhoto> specialMonthly = const [];

  // HOME-02
  List<ChapterSummary> chapters = const [];
  List<MilestoneItem> milestones = const [];
  List<MonthlyPhoto> monthlyPhotos = const [];

  // HOME-03
  PrepSummary? prep;
  List<NameCandidate> names = const [];
  List<BumpPhoto> bumps = const [];
  List<MemoryPerspective> bothTellPerspectives = const [];
  FetalSize? fetalSize;

  String? get subjectId => ref.read(selectedSubjectProvider);

  Child? get subject =>
      children.where((child) => child.id == subjectId).firstOrNull;

  bool get showLunar => ref.read(appLunarDateProvider);

  Child? childById(String? id) =>
      children.where((child) => child.id == id).firstOrNull;

  Member? memberByUserId(String? userId) =>
      members.where((member) => member.userId == userId).firstOrNull;

  /// Tên gọi (Papa/Mama/Bà ngoại…) của người tạo nội dung.
  String callNameOf(String? userId) {
    final member = memberByUserId(userId);
    if (member == null) {
      return '';
    }
    return member.callName.isEmpty ? member.displayName : member.callName;
  }

  /// Tên gọi của bạn đời (“Của Papa”).
  String get partnerCallName {
    final partner = members
        .where(
          (member) =>
              member.role != FamilyRole.relative && member.userId != me?.userId,
        )
        .firstOrNull;
    return partner == null ? '' : callNameOf(partner.userId);
  }

  void selectSubject(String? childId) =>
      ref.read(selectedSubjectProvider.notifier).select(childId);

  /// SUB-06 — hiện banner khi gia hạn chưa thành công (seed `paymentIssue`);
  /// đóng banner chỉ ẩn trong phiên xem này.
  bool get showPaymentIssue =>
      family?.plan.paymentIssue == true && !_paymentIssueDismissed;

  PlanState? get planState => family?.plan.state;

  void dismissPaymentIssue() {
    _paymentIssueDismissed = true;
    notifyListeners();
  }

  /// FAM-08 — các gia đình của tài khoản (sheet “Chuyển gia đình”).
  Future<List<FamilyMembership>> memberships() =>
      ref.read(familyServiceProvider).memberships();

  Future<void> switchFamily(String familyId) =>
      ref.read(familyServiceProvider).switchFamily(familyId);

  Future<void> load({bool silent = false}) async {
    final revision = ++_revision;
    hasError = false;
    if (!silent) {
      toLoading();
    }
    try {
      final childService = ref.read(childServiceProvider);
      final familyService = ref.read(familyServiceProvider);
      final clock = ref.read(appClockProvider);
      final loadedChildren = await childService.children();
      final loadedMembers = await familyService.members();
      final loadedMe = await familyService.me();
      final unread = await ref.read(notificationServiceProvider).unreadCount();
      final loadedFamily = await familyService.currentFamily();
      final subjectId = this.subjectId;
      final current = loadedChildren
          .where((child) => child.id == subjectId)
          .firstOrNull;
      if (isDisposed || revision != _revision) {
        return;
      }
      today = childService.today;
      now = clock.now();
      children = loadedChildren;
      members = loadedMembers;
      me = loadedMe;
      unreadCount = unread;
      family = loadedFamily;
      if (current == null) {
        await _loadFamily(revision);
      } else if (current.isPregnancy) {
        await _loadPregnancy(current, revision);
      } else {
        await _loadChild(current, revision);
      }
      if (isDisposed || revision != _revision) {
        return;
      }
      loaded = true;
    } on Object {
      if (isDisposed || revision != _revision) {
        return;
      }
      hasError = true;
    }
    if (!isDisposed && revision == _revision) {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadFamily(int revision) async {
    final memoryService = ref.read(memoryServiceProvider);
    final special = specialChild;
    final results = await Future.wait<Object?>([
      memoryService.stories(),
      ref.read(careServiceProvider).board(),
      ref.read(usServiceProvider).coupleToday(),
      memoryService.todayPrompt(),
      memoryService.memories(),
      ref.read(childServiceProvider).weekSummary(),
      ref.read(careServiceProvider).tree(),
      if (special != null) memoryService.monthlyPhotos(special.id),
    ]);
    if (isDisposed || revision != _revision) {
      return;
    }
    stories = results[0]! as List<StoryItem>;
    board = results[1]! as CareBoard;
    couple = results[2]! as CoupleToday;
    prompt = results[3] as MemoryPrompt?;
    memories = results[4]! as List<Memory>;
    week = results[5]! as WeekSummary;
    tree = results[6]! as FamilyTree;
    specialMonthly = special == null
        ? const []
        : results[7]! as List<MonthlyPhoto>;
  }

  Future<void> _loadChild(Child child, int revision) async {
    final memoryService = ref.read(memoryServiceProvider);
    final results = await Future.wait<Object?>([
      memoryService.stories(childId: child.id),
      ref.read(childServiceProvider).chapters(child.id),
      memoryService.milestones(child.id),
      memoryService.monthlyPhotos(child.id),
      memoryService.memories(childId: child.id),
      ref.read(careServiceProvider).board(childId: child.id),
    ]);
    if (isDisposed || revision != _revision) {
      return;
    }
    stories = results[0]! as List<StoryItem>;
    chapters = results[1]! as List<ChapterSummary>;
    milestones = results[2]! as List<MilestoneItem>;
    monthlyPhotos = results[3]! as List<MonthlyPhoto>;
    memories = results[4]! as List<Memory>;
    board = results[5]! as CareBoard;
  }

  Future<void> _loadPregnancy(Child pregnancy, int revision) async {
    final memoryService = ref.read(memoryServiceProvider);
    final pregnancyService = ref.read(pregnancyServiceProvider);
    final results = await Future.wait<Object?>([
      pregnancyService.prep(pregnancy.id),
      pregnancyService.names(pregnancy.id),
      memoryService.bumpPhotos(pregnancy.id),
      memoryService.milestones(pregnancy.id),
      memoryService.memories(childId: pregnancy.id),
      ref.read(childServiceProvider).fetalSize(pregnancy.id),
    ]);
    if (isDisposed || revision != _revision) {
      return;
    }
    prep = results[0]! as PrepSummary;
    names = results[1]! as List<NameCandidate>;
    bumps = results[2]! as List<BumpPhoto>;
    milestones = results[3]! as List<MilestoneItem>;
    memories = results[4]! as List<Memory>;
    fetalSize = results[5] as FetalSize?;
    final told = bothTellMemory;
    bothTellPerspectives = told == null
        ? const []
        : await memoryService.perspectives(told.id);
  }

  // ---------------------------------------------------------------- HOME-01

  /// Bé có ngày tròn tháng sắp tới để chụp ảnh tháng: bé nhỏ nhất đã sinh.
  Child? get specialChild {
    final born = children.where(
      (child) => !child.isPregnancy && child.birthDate != null,
    );
    if (born.isEmpty) {
      return null;
    }
    return born.reduce((a, b) => a.birthDate!.isAfter(b.birthDate!) ? a : b);
  }

  /// Tháng tuổi bé sắp tròn (ảnh tháng thứ mấy).
  int get specialMonth {
    final birth = specialChild?.birthDate;
    return birth == null ? 0 : childAgeInMonths(birth, today) + 1;
  }

  /// Số ngày tới ngày tròn [specialMonth] tháng.
  int get specialDaysLeft {
    final birth = specialChild?.birthDate;
    return birth == null
        ? 0
        : daysUntil(childMonthDate(birth, specialMonth), today);
  }

  int get specialMonthlyDone =>
      specialMonthly.where((photo) => photo.asset != null).length;

  List<StoryItem> storiesOf(String childId) =>
      stories.where((story) => story.childId == childId).toList();

  int unseenStories(String childId) =>
      stories.where((story) => story.childId == childId && !story.seen).length;

  /// Nhiệm vụ chưa xong của tôi — thẻ đầu + “+ n việc nữa của tôi”.
  List<Mission> get myPending =>
      board?.mine.where((mission) => !mission.isDone).toList() ?? const [];

  /// “Mới trong nhà”: nhóm ảnh mới nhất, câu nói mới nhất, ký ức có ảnh mới
  /// nhất (theo thứ tự thiết kế HOME-01).
  Memory? get feedGroup => memories
      .where(
        (memory) =>
            memory.kind == MemoryKind.photo &&
            memory.mediaAssets.length > groupGridCount,
      )
      .firstOrNull;

  Memory? get feedQuote =>
      memories.where((memory) => memory.kind == MemoryKind.quote).firstOrNull;

  Memory? get feedMemory {
    final group = feedGroup;
    return memories
        .where(
          (memory) =>
              memory.kind == MemoryKind.photo &&
              memory.id != group?.id &&
              memory.mediaAssets.isNotEmpty &&
              memory.childIds.every(
                (id) => !(childById(id)?.isPregnancy ?? false),
              ),
        )
        .firstOrNull;
  }

  // ---------------------------------------------------------------- HOME-02

  ChapterSummary? get currentChapter =>
      chapters.where((chapter) => chapter.current).firstOrNull ??
      chapters.firstOrNull;

  /// Lần đầu đã đạt, mới nhất trước.
  List<MilestoneItem> get achievedFirsts =>
      milestones.where((item) => item.achievedAt != null).toList()
        ..sort((a, b) => b.achievedAt!.compareTo(a.achievedAt!));

  List<MilestoneItem> get nextFirsts =>
      milestones.where((item) => item.achievedAt == null).toList();

  Memory? get latestVoice =>
      memories.where((memory) => memory.kind == MemoryKind.voice).firstOrNull;

  int get monthlyDone =>
      monthlyPhotos.where((photo) => photo.asset != null).length;

  /// Nhiệm vụ của tôi cho bé đang xem, chưa xong trước.
  Mission? get childMission {
    final mine = board?.mine ?? const <Mission>[];
    return mine.where((mission) => !mission.isDone).firstOrNull ??
        mine.firstOrNull;
  }

  // ---------------------------------------------------------------- HOME-03

  /// Ảnh bụng gần nhất (tối đa [bumpRowCount] − 1) + ô chụp tuần hiện tại.
  List<BumpPhoto> get recentBumps {
    final week = currentPregnancyWeek;
    final taken = bumps
        .where((photo) => photo.asset != null && photo.week < week)
        .toList();
    return taken.length <= bumpRowCount - 1
        ? taken
        : taken.sublist(taken.length - (bumpRowCount - 1));
  }

  int get currentPregnancyWeek {
    final due = subject?.dueDate;
    return due == null ? 0 : pregnancyWeek(due, today).week;
  }

  List<MilestoneItem> get pregnancyFirsts =>
      milestones.where((item) => item.forPregnancy).toList();

  /// Ký ức thai kỳ có góc nhìn của cả hai (“Cả hai cùng kể”), cột mốc trước.
  Memory? get bothTellMemory {
    final told = memories.where(
      (memory) => memory.perspectiveCount > 0 && memory.body != null,
    );
    return told
            .where((memory) => memory.kind == MemoryKind.milestone)
            .firstOrNull ??
        told.firstOrNull;
  }

  /// Việc chuẩn bị chưa xong của tôi hoặc cùng nhau.
  List<PrepItem> get prepPreview => (prep?.items ?? const <PrepItem>[])
      .where((item) => !item.done && item.ownerKind != MissionOwnerKind.partner)
      .take(prepPreviewCount)
      .toList();

  int get namesBothLike => names.where((name) => name.bothLike).length;

  // ---------------------------------------------------------------- actions

  Future<void> completeMission(Mission mission) async {
    await ref.read(careServiceProvider).completeMission(mission.id);
  }

  Future<void> dismissPrompt() async {
    await ref.read(memoryServiceProvider).dismissPrompt();
    if (!isDisposed) {
      await load(silent: true);
    }
  }
}
