import 'package:baby_family/data/dto/memory_search_result.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/service/child.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/legacy.dart';

/// MEM-15 Tìm kiếm: ô tìm + gần đây, bộ lọc (loại, bé, người đăng, năm),
/// kết quả lưới Ảnh & video + danh sách Nhật ký.
final memorySearchControllerProvider =
    ChangeNotifierProvider.autoDispose<MemorySearchController>(
      MemorySearchController.new,
    );

class MemorySearchController extends BaseNotifier {
  MemorySearchController(super.ref) {
    childId = ref.read(selectedSubjectProvider);
    year = childService.today.year;
    load();
  }

  /// Số ô ảnh hiện trước khi bấm “Xem tất cả” (2 hàng × 3).
  static const previewTiles = 6;

  IMemoryService get memoryService => ref.read(memoryServiceProvider);
  IChildService get childService => ref.read(childServiceProvider);
  IFamilyService get familyService => ref.read(familyServiceProvider);

  final input = TextEditingController();
  final focus = FocusNode();

  bool loaded = false;
  List<String> recents = const [];
  List<Child> children = const [];
  List<Member> members = const [];
  MemorySearchResult? result;
  bool showAllMedia = false;

  /// Bộ lọc: loại (null = tất cả), bé, người đăng (userId), năm.
  MemoryKind? kind;
  String? childId;
  String? authorId;
  int? year;

  Child? get child => children.where((item) => item.id == childId).firstOrNull;

  Member? memberByUser(String? userId) =>
      members.where((member) => member.userId == userId).firstOrNull;

  /// Năm có thể lọc (năm nay về năm sinh bé lớn nhất).
  List<int> get years {
    final today = childService.today;
    final first = children
        .map((item) => item.birthDate?.year ?? today.year)
        .fold(today.year, (a, b) => a < b ? a : b);
    return [for (var value = today.year; value >= first; value--) value];
  }

  bool _keep(Memory memory) =>
      (authorId == null || memory.authorId == authorId) &&
      (year == null || memory.occurredAt.year == year);

  List<Memory> get media => kind == MemoryKind.diary
      ? const []
      : (result?.media ?? const []).where(_keep).toList();

  List<Memory> get diaries => kind == MemoryKind.photo
      ? const []
      : (result?.diaries ?? const []).where(_keep).toList();

  int get total => media.length + diaries.length;

  bool get hasQuery => (result?.query.trim() ?? '').isNotEmpty;

  Future<void> load() async {
    try {
      final (rows, kids, people) = await (
        memoryService.searchRecents(),
        childService.children(),
        familyService.members(),
      ).wait;
      if (isDisposed) {
        return;
      }
      recents = rows;
      children = kids.where((item) => !item.isPregnancy).toList();
      members = people;
    } catch (_) {
      // Gần đây trống — vẫn tìm được.
    }
    if (isDisposed) {
      return;
    }
    loaded = true;
    notifyListeners();
  }

  Future<void> search([String? text]) async {
    if (text != null) {
      input
        ..text = text
        ..selection = TextSelection.collapsed(offset: text.length);
    }
    final query = input.text.trim();
    showAllMedia = false;
    if (query.isEmpty) {
      result = null;
      notifyListeners();
      return;
    }
    final value = await memoryService.search(query, childId: childId);
    final latest = await memoryService.searchRecents();
    if (isDisposed) {
      return;
    }
    result = value;
    recents = latest;
    notifyListeners();
  }

  void clear() {
    input.clear();
    result = null;
    focus.requestFocus();
    notifyListeners();
  }

  void setKind(MemoryKind? value) {
    kind = value;
    notifyListeners();
  }

  Future<void> setChild(String? value) async {
    childId = value;
    await search();
  }

  void setAuthor(String? value) {
    authorId = value;
    notifyListeners();
  }

  void setYear(int? value) {
    year = value;
    notifyListeners();
  }

  void expandMedia() {
    showAllMedia = true;
    notifyListeners();
  }

  @override
  void dispose() {
    input.dispose();
    focus.dispose();
    super.dispose();
  }
}
