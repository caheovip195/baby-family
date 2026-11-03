import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/year_book/year_book.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/year_book.dart';
import 'package:baby_family/data/service/year_book.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/helper/year_book_pdf.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/legacy.dart';

/// REC-04 — Sách của con [2.0]: chọn năm; mỗi tháng một chương, ký ức và ảnh
/// tự chọn sẵn (cột mốc trước); chọn/bỏ ký ức, ảnh; sửa chú thích, tên sách,
/// tên chương; lưu; xuất PDF dựng trên máy (gói cho phép, dùng thử chỉ xem
/// trước).
final yearBookControllerProvider =
    ChangeNotifierProvider.autoDispose<YearBookController>(
      YearBookController.new,
    );

class YearBookController extends BaseNotifier {
  YearBookController(super.ref) {
    today = ref.read(todayProvider);
  }

  IYearBookService get yearBookService => ref.read(yearBookServiceProvider);

  late DateTime today;
  String? childId;
  Child? child;

  /// Sách cả nhà (mọi ký ức của gia đình, BF-20261030-001).
  bool family = false;

  /// Năm sinh của bé lớn nhất (năm đầu của sách cả nhà).
  int? _eldestYear;
  late int year = today.year;
  YearBookRecord? book;
  bool loaded = false;
  bool hasError = false;

  /// Có chỉnh sửa chưa lưu.
  bool dirty = false;

  /// Đang đọc bản người thân (server trả `readOnly`, BF-20261030-002).
  bool get readOnly => book?.readOnly ?? false;
  bool exporting = false;

  /// Năm có thể làm sách: năm sinh (bé lớn nhất với cả nhà) → năm nay (mới
  /// nhất trước).
  List<int> get years {
    final first = (family ? _eldestYear : child?.birthDate?.year) ?? today.year;
    return [for (var y = today.year; y >= first; y--) y];
  }

  /// [id] null = sách cả nhà; [atYear] mở đúng năm (người thân từ danh sách).
  Future<void> init(String? id, {int? atYear}) async {
    childId = id;
    family = id == null;
    if (atYear != null) {
      year = atYear;
    }
    await load();
  }

  /// Bé đang mở; người thân có thể không đọc được hồ sơ bé → null.
  Future<Child?> _child(String? id) async {
    if (id == null) {
      return null;
    }
    try {
      return child ?? await ref.read(childServiceProvider).child(id);
    } catch (_) {
      return null;
    }
  }

  Future<void> load() async {
    final id = childId;
    if (id == null && !family) {
      return;
    }
    hasError = false;
    try {
      final kid = await _child(id);
      if (kid?.birthDate case final birth? when year < birth.year) {
        year = birth.year;
      }
      if (family && _eldestYear == null) {
        final births = <int>[];
        try {
          for (final kid in await ref.read(childServiceProvider).children()) {
            births.addAll([?kid.birthDate?.year]);
          }
        } catch (_) {
          // Người thân: không có danh sách bé → chỉ năm đang mở.
        }
        _eldestYear = births.isEmpty
            ? null
            : births.reduce((a, b) => a < b ? a : b);
      }
      final value = await yearBookService.book(family ? null : id, year);
      if (isDisposed) {
        return;
      }
      child = kid;
      book = value;
      dirty = false;
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    loaded = true;
    notifyListeners();
  }

  /// Đổi giữa sách của bé và sách cả nhà (giữ năm đang chọn).
  Future<void> setFamily(bool value) async {
    if (value == family) {
      return;
    }
    family = value;
    loaded = false;
    notifyListeners();
    await load();
  }

  Future<void> setYear(int value) async {
    if (value == year) {
      return;
    }
    year = value;
    loaded = false;
    notifyListeners();
    await load();
  }

  /// Bản cho ông bà: bật/tắt chia sẻ với người thân (lưu mới có hiệu lực).
  void setShared(bool value) =>
      _edit((book) => book.copyWith(sharedWithCircle: value));

  void setTitle(String? value) =>
      _edit((book) => book.copyWith(title: _clean(value)));

  void setChapterTitle(int month, String? value) =>
      _editChapter(month, (chapter) => chapter.copyWith(title: _clean(value)));

  /// Bật/tắt ký ức; bật lại ký ức chưa chọn ảnh thì chọn sẵn ảnh đầu.
  void toggleItem(int month, String memoryId) =>
      _editItem(month, memoryId, (item) {
        final included = !item.included;
        return item.copyWith(
          included: included,
          selectedAssetIds: included && item.selectedAssetIds.isEmpty
              ? [?item.photos.firstOrNull?.assetId]
              : item.selectedAssetIds,
        );
      });

  /// Chọn/bỏ ảnh (giữ thứ tự của ký ức); chọn ảnh thì ký ức vào sách.
  void togglePhoto(int month, String memoryId, String assetId) =>
      _editItem(month, memoryId, (item) {
        final selected = {...item.selectedAssetIds};
        if (!selected.remove(assetId)) {
          selected.add(assetId);
        }
        return item.copyWith(
          included: item.included || selected.isNotEmpty,
          selectedAssetIds: [
            for (final photo in item.photos)
              if (selected.contains(photo.assetId)) photo.assetId,
          ],
        );
      });

  void setCaption(int month, String memoryId, String value) => _editItem(
    month,
    memoryId,
    (item) => item.copyWith(caption: value.trim()),
  );

  /// Lưu bản chỉnh sửa; true = server đã nhận, false = lưu trên máy chờ gửi.
  Future<bool> save() async {
    final current = book;
    if (current == null) {
      return false;
    }
    final saved = await whileLoading(() => yearBookService.save(current));
    if (isDisposed) {
      return !saved.pending;
    }
    book = saved;
    dirty = false;
    notifyListeners();
    return !saved.pending;
  }

  /// Dựng PDF trên máy (xem trước trong app — mọi gói; xuất theo gói).
  Future<Uint8List?> buildPdf({
    required String title,
    required String subtitle,
    required String Function(int month) chapterHeading,
    required String Function(DateTime date) dateLine,
  }) async {
    final current = book;
    if (current == null || current.includedCount == 0 || exporting) {
      return null;
    }
    exporting = true;
    notifyListeners();
    try {
      final chapters = <YearBookPdfChapter>[];
      for (final chapter in current.chapters) {
        final entries = <YearBookPdfEntry>[];
        for (final item in chapter.items.where((item) => item.included)) {
          final images = <Uint8List>[];
          for (final photo in item.photos) {
            if (!item.selectedAssetIds.contains(photo.assetId)) {
              continue;
            }
            if (await yearBookService.photo(photo) case final bytes?) {
              images.add(bytes);
            }
          }
          final date = DateTime.tryParse(item.occurredAt ?? '')?.toLocal();
          entries.add(
            YearBookPdfEntry(
              caption: item.caption,
              dateLine: date == null ? '' : dateLine(date),
              images: images,
            ),
          );
        }
        if (entries.isNotEmpty) {
          chapters.add(
            YearBookPdfChapter(
              heading: chapter.title ?? chapterHeading(chapter.month),
              entries: entries,
            ),
          );
        }
      }
      return await buildYearBookPdf(
        YearBookPdfInput(
          title: title,
          subtitle: subtitle,
          chapters: chapters,
          regularFont: await rootBundle.load(
            'assets/fonts/BeVietnamPro-Regular.ttf',
          ),
          boldFont: await rootBundle.load(
            'assets/fonts/BeVietnamPro-SemiBold.ttf',
          ),
        ),
      );
    } finally {
      exporting = false;
      if (!isDisposed) {
        notifyListeners();
      }
    }
  }

  /// Tên file PDF của sách đang mở.
  String get pdfFileName {
    final current = book;
    return 'year-book-${current?.isFamily ?? false ? 'family-' : ''}'
        '${current?.year ?? year}.pdf';
  }

  static String? _clean(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  void _edit(YearBookRecord Function(YearBookRecord book) change) {
    final current = book;
    if (current == null) {
      return;
    }
    book = change(current);
    dirty = true;
    notifyListeners();
  }

  void _editChapter(
    int month,
    YearBookChapter Function(YearBookChapter chapter) change,
  ) => _edit(
    (book) => book.copyWith(
      chapters: [
        for (final chapter in book.chapters)
          chapter.month == month ? change(chapter) : chapter,
      ],
    ),
  );

  void _editItem(
    int month,
    String memoryId,
    YearBookItem Function(YearBookItem item) change,
  ) => _editChapter(
    month,
    (chapter) => chapter.copyWith(
      items: [
        for (final item in chapter.items)
          item.memoryId == memoryId ? change(item) : item,
      ],
    ),
  );
}
