import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/memory/day_story.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/service/child.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// REC-01 — Câu chuyện ngày (Pencil `kIqYL`, mục 9.10 + AI 7.18): ảnh bìa,
/// tiêu đề, đoạn văn (AI gợi ý hoặc tự viết), ký ức trong ngày được tick, ảnh
/// kèm, ai sẽ thấy; Lưu / Bỏ. Mọi thay đổi chỉ là bản nháp trên màn cho tới
/// khi bấm “Lưu câu chuyện”.
final dayStoryControllerProvider = ChangeNotifierProvider.autoDispose
    .family<DayStoryController, String?>(DayStoryController.new);

class DayStoryController extends BaseNotifier {
  DayStoryController(super.ref, this.childId) {
    load();
  }

  final String? childId;

  IMemoryService get memoryService => ref.read(memoryServiceProvider);
  IChildService get childService => ref.read(childServiceProvider);

  bool loaded = false;
  bool hasError = false;
  bool saving = false;

  /// Bản gốc từ service (đoạn văn AI để “Viết lại”).
  DayStory? original;

  /// Bản nháp đang sửa.
  DayStory? story;
  Child? child;

  /// “Tự viết”: đoạn văn chuyển sang ô nhập.
  bool manual = false;

  DateTime get today => childService.today;

  int get selectedCount =>
      story?.items.where((item) => item.selected).length ?? 0;

  /// Ảnh có thể kèm (ảnh trong ngày; dữ liệu cũ chỉ có ảnh đã chọn).
  List<String> get photoOptions {
    final value = story;
    if (value == null) {
      return const [];
    }
    return value.photoOptions.isEmpty ? value.photoAssets : value.photoOptions;
  }

  Future<void> load() async {
    hasError = false;
    try {
      final (value, kids) = await (
        memoryService.dayStory(childId: childId),
        childService.children(),
      ).wait;
      if (isDisposed) {
        return;
      }
      original = value;
      story = value;
      child = kids.where((kid) => kid.id == value?.childId).firstOrNull;
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    loaded = true;
    notifyListeners();
  }

  void _update(DayStory Function(DayStory story) change) {
    final value = story;
    if (value == null) {
      return;
    }
    story = change(value);
    notifyListeners();
  }

  void toggleItem(String id) => _update(
    (value) => value.copyWith(
      items: [
        for (final item in value.items)
          item.id == id ? item.copyWith(selected: !item.selected) : item,
      ],
    ),
  );

  void togglePhoto(String asset) => _update((value) {
    final selected = [...value.photoAssets];
    if (!selected.remove(asset)) {
      selected.add(asset);
    }
    return value.copyWith(
      photoAssets: [
        for (final option in photoOptions)
          if (selected.contains(option)) option,
      ],
    );
  });

  /// “Đổi ảnh bìa”: lần lượt dùng ảnh kèm tiếp theo trong ngày.
  void nextCover() => _update((value) {
    final options = photoOptions;
    if (options.isEmpty) {
      return value;
    }
    final index = options.indexOf(value.coverAsset ?? '');
    return value.copyWith(coverAsset: options[(index + 1) % options.length]);
  });

  void setTitle(String title) {
    if (title.trim().isEmpty) {
      return;
    }
    _update((value) => value.copyWith(title: title.trim()));
  }

  void setBody(String body) {
    final value = story;
    if (value == null) {
      return;
    }
    story = value.copyWith(body: body, aiGenerated: false);
  }

  /// “Viết lại”: lấy lại đoạn văn gợi ý bởi AI.
  void rewrite() {
    final source = original;
    manual = false;
    _update(
      (value) => value.copyWith(
        body: source?.body ?? value.body,
        aiGenerated: source?.aiGenerated ?? value.aiGenerated,
      ),
    );
  }

  void writeManually() {
    manual = true;
    notifyListeners();
  }

  void setVisibility(MemoryVisibility visibility) =>
      _update((value) => value.copyWith(visibility: visibility));

  Future<bool> save() async {
    final value = story;
    if (value == null || saving) {
      return false;
    }
    saving = true;
    notifyListeners();
    try {
      await memoryService.saveDayStory(value);
      return true;
    } catch (_) {
      return false;
    } finally {
      if (!isDisposed) {
        saving = false;
        notifyListeners();
      }
    }
  }
}
