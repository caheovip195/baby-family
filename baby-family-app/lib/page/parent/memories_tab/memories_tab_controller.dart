import 'package:baby_family/data/dto/memory_grid_photo.dart';
import 'package:baby_family/data/dto/recap_week_entry.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/memory/album.dart';
import 'package:baby_family/data/model/memory/chapter_summary.dart';
import 'package:baby_family/data/model/memory/child_memory_stats.dart';
import 'package:baby_family/data/model/memory/collection_summary.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/child.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:hooks_riverpod/legacy.dart';

/// MEM-01 Dòng thời gian • MEM-02 Ảnh • MEM-22 Bộ sưu tập.
final memoriesTabControllerProvider =
    ChangeNotifierProvider.autoDispose<MemoriesTabController>(
      MemoriesTabController.new,
    );

class MemoriesTabController extends BaseNotifier {
  MemoriesTabController(super.ref) {
    ref
      ..listen(mockRevisionProvider, (_, _) => load())
      ..listen(appLanguageProvider, (_, _) => load())
      ..listen(selectedSubjectProvider, (_, _) => load());
    load();
  }

  IMemoryService get memoryService => ref.read(memoryServiceProvider);
  IChildService get childService => ref.read(childServiceProvider);
  IFamilyService get familyService => ref.read(familyServiceProvider);

  int tabIndex = 0;
  MemoryFilter filter = MemoryFilter.all;
  bool hasError = false;
  bool loaded = false;

  List<Child> children = const [];
  List<Memory> memories = const [];

  /// MEM-02: ảnh của bé/cả nhà (chế độ server lấy từ lưới ảnh của server).
  List<MemoryGridPhoto> photos = const [];
  List<ChapterSummary> chapters = const [];

  /// Thẻ recap tuần mới nhất (dòng thời gian cả nhà, chế độ server).
  RecapWeekEntry? recapWeek;
  ChildMemoryStats? stats;
  Map<String, Member> _membersByUser = const {};
  List<CollectionSummary> collections = const [];
  int sealedLetters = 0;

  /// MEM-22 “Album tự tạo”: album của nhà mình (thẻ cuối lưới → MEM-03).
  List<Album> familyAlbums = const [];

  /// Bé dùng cho “Con lớn từng tháng” (bé đang chọn hoặc bé nhỏ nhất đã sinh).
  Child? monthlyChild;
  int monthlyCount = 0;

  /// Bé có câu nói gần nhất (MEM-22 “Hana · 34 câu”).
  Child? quoteChild;
  Memory? latestQuote;
  int _loadId = 0;

  String? get subjectId => ref.read(selectedSubjectProvider);
  Child? get subject => childById(subjectId);
  DateTime get today => childService.today;
  DateTime get now => ref.read(appClockProvider).now();

  Child? childById(String? id) =>
      children.where((child) => child.id == id).firstOrNull;
  Member? memberByUser(String? userId) => _membersByUser[userId];

  void selectSubject(String? childId) =>
      ref.read(selectedSubjectProvider.notifier).select(childId);

  void selectTab(int index) {
    tabIndex = index;
    notifyListeners();
  }

  void selectFilter(MemoryFilter value) {
    filter = value;
    notifyListeners();
  }

  Future<void> load() async {
    final id = ++_loadId;
    hasError = false;
    try {
      final subjectId = this.subjectId;
      final results = await Future.wait([
        childService.children(),
        memoryService.timeline(childId: subjectId),
        familyService.members(),
        memoryService.collections(),
        memoryService.sealedLetters(),
        memoryService.memories(kinds: {MemoryKind.quote}),
        memoryService.albums(),
      ]);
      if (isDisposed || id != _loadId) {
        return;
      }
      children = results[0] as List<Child>;
      memories = results[1] as List<Memory>;
      _membersByUser = {
        for (final member in results[2] as List<Member>)
          if (member.userId != null) member.userId!: member,
      };
      collections = results[3] as List<CollectionSummary>;
      sealedLetters = results[4] as int;
      latestQuote = (results[5] as List<Memory>).firstOrNull;
      familyAlbums = (results[6] as List<Album>)
          .where((album) => !album.isAuto)
          .toList();
      quoteChild = childById(latestQuote?.childIds.firstOrNull);
      final child = subject;
      final born = child != null && !child.isPregnancy;
      stats = child == null ? null : await childService.stats(child.id);
      chapters = born ? await childService.chapters(child.id) : const [];
      final week = subjectId == null
          ? await memoryService.latestRecapWeek()
          : null;
      recapWeek = week == null ? null : RecapWeekEntry(week);
      monthlyChild = born
          ? child
          : children.where((c) => !c.isPregnancy).lastOrNull;
      // Sau timeline: ký ức của các ô ảnh đã có trong kho.
      photos = await memoryService.photos(childId: subjectId);
      monthlyCount = monthlyChild == null
          ? 0
          : (await memoryService.monthlyPhotos(monthlyChild!.id)).length;
      if (isDisposed || id != _loadId) {
        return;
      }
    } catch (_) {
      if (isDisposed || id != _loadId) {
        return;
      }
      hasError = true;
    }
    loaded = true;
    notifyListeners();
  }

  /// Ký ức hiển thị trên dòng thời gian (ảnh tháng & ảnh bụng nằm ở album riêng).
  List<Memory> get timelineMemories {
    final kinds = filter.kinds;
    return memories.where((memory) {
      if (filter == MemoryFilter.all &&
          (memory.kind == MemoryKind.monthlyPhoto ||
              memory.kind == MemoryKind.bump)) {
        return false;
      }
      if (kinds == null) {
        return true;
      }
      return kinds.contains(memory.kind) &&
          (filter != MemoryFilter.photos || memory.mediaAssets.isNotEmpty);
    }).toList();
  }

  /// Dòng thời gian: chương tháng ([ChapterSummary]) xen ký ức ([Memory]);
  /// thẻ recap tuần ([RecapWeekEntry]) đứng trước ký ức cũ hơn cuối tuần đó.
  List<Object> get timeline {
    final entries = _timelineEntries;
    final week = recapWeek;
    if (week == null || filter != MemoryFilter.all) {
      return entries;
    }
    final after = week.weekStart.add(const Duration(days: 7));
    final index = entries.indexWhere(
      (entry) =>
          (entry is Memory && entry.occurredAt.isBefore(after)) ||
          entry is ChapterSummary,
    );
    return [...entries]..insert(index < 0 ? entries.length : index, week);
  }

  List<Object> get _timelineEntries {
    final items = timelineMemories;
    if (chapters.isEmpty) {
      return items;
    }
    final result = <Object>[];
    final placed = <String>{};
    for (final chapter in chapters) {
      final inChapter = items
          .where(
            (memory) =>
                !memory.occurredAt.isBefore(chapter.start) &&
                memory.occurredAt.isBefore(chapter.end),
          )
          .toList();
      if (inChapter.isEmpty && filter != MemoryFilter.all) {
        continue;
      }
      result
        ..add(chapter)
        ..addAll(inChapter);
      placed.addAll(inChapter.map((memory) => memory.id));
    }
    result.addAll(items.where((memory) => !placed.contains(memory.id)));
    return result;
  }

  /// MEM-02: ảnh theo tháng lịch (mới nhất trước).
  List<({DateTime month, List<({String asset, Memory memory})> photos})>
  get photoGroups {
    final groups = <DateTime, List<({String asset, Memory memory})>>{};
    for (final photo in photos) {
      final at = photo.memory.occurredAt;
      (groups[DateTime(at.year, at.month)] ??= []).add((
        asset: photo.asset,
        memory: photo.memory,
      ));
    }
    return [
      for (final entry in groups.entries)
        (month: entry.key, photos: entry.value),
    ];
  }

  /// Số tháng của lưới ảnh tháng (“5/6 ảnh”).
  int get monthlyTotal {
    final birth = monthlyChild?.birthDate;
    return birth == null ? 0 : childMonthIndex(birth, today);
  }

  /// MEM-06 “Thử lại” / “Huỷ” trên thẻ ký ức đang tải nền.
  Future<void> retryUpload(String memoryId) async {
    await memoryService.retryUpload(memoryId);
    await load();
  }

  Future<void> cancelUpload(String memoryId) async {
    await memoryService.cancelUpload(memoryId);
    await load();
  }
}
