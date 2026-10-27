import 'dart:async';

import 'package:baby_family/data/dto/diary_block.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/service/child.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/legacy.dart';

/// MEM-13 Viết nhật ký: tiêu đề, thân định dạng nhẹ (đậm, nghiêng, danh
/// sách, tiêu đề), chèn ảnh, gợi ý theo tuổi bé, bé • ngày • ai thấy; mở lại
/// nháp đang soạn; tự lưu nháp trên máy sau [autosaveDelay] ngừng gõ.
final diaryEditorControllerProvider = ChangeNotifierProvider.autoDispose
    .family<DiaryEditorController, String?>(DiaryEditorController.new);

class DiaryEditorController extends BaseNotifier {
  DiaryEditorController(super.ref, String? childId) {
    _childId = childId ?? ref.read(selectedSubjectProvider);
    load();
  }

  static const _bullet = '• ';

  IMemoryService get memoryService => ref.read(memoryServiceProvider);
  IChildService get childService => ref.read(childServiceProvider);

  final title = TextEditingController();
  List<DiaryBlock> blocks = [];

  String? _childId;
  bool loaded = false;
  List<Child> children = const [];
  List<String> prompts = const [];
  int _promptOffset = 0;
  DateTime? occurredAt;
  MemoryVisibility visibility = MemoryVisibility.family;

  /// Giờ lưu nháp gần nhất (“Đã lưu nháp · 21:14”).
  DateTime? savedAt;

  static const autosaveDelay = Duration(seconds: 2);
  Timer? _autosave;

  /// Nháp trên máy đang cập nhật (null = chưa lưu lần nào).
  String? _draftId;

  /// Bản đã lưu gần nhất (bỏ qua khi không đổi gì).
  String? _savedSnapshot;

  /// Ảnh chèn trong trang và vị trí (đứng trước khối [photoIndex]).
  String? photo;
  int photoIndex = 0;
  String? _sourcePhoto;

  /// Khối đang soạn (định dạng áp dụng cho khối này).
  int focusedIndex = 0;

  DateTime get today => childService.today;

  Child? get child =>
      children.where((item) => item.id == _childId).firstOrNull ??
      children.firstOrNull;

  DiaryBlock? get focusedBlock =>
      focusedIndex < blocks.length ? blocks[focusedIndex] : null;

  /// Gợi ý đang hiện (xoay vòng khi bấm “Gợi ý khác”).
  List<String> get visiblePrompts => [
    for (var index = 0; index < prompts.length; index++)
      prompts[(index + _promptOffset) % prompts.length],
  ];

  Future<void> load() async {
    try {
      final (kids, draft) = await (
        childService.children(),
        memoryService.draft(MemoryKind.diary),
      ).wait;
      if (isDisposed) {
        return;
      }
      children = kids.where((item) => !item.isPregnancy).toList();
      if (draft != null) {
        _applyDraft(draft);
      }
      if (blocks.isEmpty) {
        _addBlock(blocks.length, DiaryBlockKind.paragraph, '');
      }
      _savedSnapshot = _snapshot;
      title.addListener(_scheduleAutosave);
      final current = child;
      prompts = current == null
          ? const []
          : await memoryService.diaryPrompts(current.id);
    } catch (_) {
      if (blocks.isEmpty) {
        _addBlock(0, DiaryBlockKind.paragraph, '');
      }
    }
    if (isDisposed) {
      return;
    }
    loaded = true;
    notifyListeners();
  }

  /// Đọc nháp: đoạn cách nhau dòng trống; dòng “• ” là danh sách; dòng kết
  /// thúc bằng “:” đứng đầu một đoạn nhiều dòng là chữ đậm.
  void _applyDraft(Memory draft) {
    // Nháp mẫu của bản demo có id `draft-…`; nháp thật trên máy thì cập nhật.
    _draftId = draft.id.startsWith('draft-') ? null : draft.id;
    _childId = draft.childIds.firstOrNull ?? _childId;
    title.text = draft.title ?? '';
    visibility = draft.visibility;
    savedAt = draft.createdAt;
    occurredAt = null;
    for (final paragraph in (draft.body ?? '').split('\n\n')) {
      final lines = paragraph.split('\n');
      for (var index = 0; index < lines.length; index++) {
        final line = lines[index];
        if (line.startsWith(_bullet)) {
          _addBlock(
            blocks.length,
            DiaryBlockKind.bullet,
            line.substring(_bullet.length),
          );
        } else {
          _addBlock(
            blocks.length,
            DiaryBlockKind.paragraph,
            line,
            bold: lines.length > 1 && line.trimRight().endsWith(':'),
          );
        }
      }
    }
    _sourcePhoto = draft.mediaAssets.firstOrNull;
    photo = _sourcePhoto;
    photoIndex = blocks.length > 1 ? blocks.length - 1 : blocks.length;
  }

  void _addBlock(
    int index,
    DiaryBlockKind kind,
    String text, {
    bool bold = false,
  }) {
    final block = DiaryBlock(
      controller: TextEditingController(text: text),
      focusNode: FocusNode(),
      kind: kind,
      bold: bold,
    );
    block.controller.addListener(_scheduleAutosave);
    block.focusNode.addListener(() {
      if (block.focusNode.hasFocus) {
        focusedIndex = blocks.indexOf(block);
        notifyListeners();
      }
    });
    blocks.insert(index, block);
    if (photo != null && index < photoIndex) {
      photoIndex++;
    }
  }

  void selectChild(String id) {
    _childId = id;
    notifyListeners();
    final current = child;
    if (current != null) {
      memoryService.diaryPrompts(current.id).then((value) {
        if (!isDisposed) {
          prompts = value;
          notifyListeners();
        }
      });
    }
  }

  void setDate(DateTime value) {
    occurredAt = value;
    notifyListeners();
  }

  void setVisibility(MemoryVisibility value) {
    visibility = value;
    notifyListeners();
  }

  void nextPrompts() {
    if (prompts.isEmpty) {
      return;
    }
    _promptOffset = (_promptOffset + 1) % prompts.length;
    notifyListeners();
  }

  /// Chạm gợi ý: thêm câu hỏi (đậm) + một đoạn trống để viết tiếp.
  void usePrompt(String prompt) {
    _addBlock(blocks.length, DiaryBlockKind.paragraph, prompt, bold: true);
    _addBlock(blocks.length, DiaryBlockKind.paragraph, '');
    blocks.last.focusNode.requestFocus();
    notifyListeners();
  }

  void toggleBold() => _update((block) => block.copyWith(bold: !block.bold));

  void toggleItalic() =>
      _update((block) => block.copyWith(italic: !block.italic));

  void toggleKind(DiaryBlockKind kind) => _update(
    (block) => block.copyWith(
      kind: block.kind == kind ? DiaryBlockKind.paragraph : kind,
    ),
  );

  void _update(DiaryBlock Function(DiaryBlock block) change) {
    final block = focusedBlock;
    if (block == null) {
      return;
    }
    blocks[focusedIndex] = change(block);
    notifyListeners();
  }

  void removePhoto() {
    photo = null;
    notifyListeners();
  }

  /// “Chèn ảnh”: đặt lại ảnh vào sau khối đang soạn.
  void insertPhoto() {
    final asset = photo ?? _sourcePhoto;
    if (asset == null) {
      return;
    }
    photo = asset;
    photoIndex = focusedIndex + 1;
    notifyListeners();
  }

  String _serialize() {
    final buffer = StringBuffer();
    for (var index = 0; index < blocks.length; index++) {
      final block = blocks[index];
      final text = block.controller.text.trim();
      if (text.isEmpty) {
        continue;
      }
      if (buffer.isNotEmpty) {
        final previous = blocks[index - 1];
        final tight =
            previous.bold ||
            (previous.kind != DiaryBlockKind.paragraph &&
                block.kind != DiaryBlockKind.paragraph);
        buffer.write(tight ? '\n' : '\n\n');
      }
      buffer.write(
        block.kind == DiaryBlockKind.paragraph ? text : '$_bullet$text',
      );
    }
    return buffer.toString();
  }

  String get _snapshot => [
    title.text.trim(),
    _serialize(),
    photo ?? '',
    _childId ?? '',
  ].join('\u0000');

  bool get _hasText =>
      title.text.trim().isNotEmpty || _serialize().trim().isNotEmpty;

  void _scheduleAutosave() {
    if (!loaded) {
      return;
    }
    _autosave?.cancel();
    _autosave = Timer(autosaveDelay, () => unawaited(autosave()));
  }

  /// Lưu nháp trên máy nếu nội dung đổi kể từ lần lưu trước.
  Future<void> autosave() async {
    _autosave?.cancel();
    _autosave = null;
    final snapshot = _snapshot;
    if (!_hasText || snapshot == _savedSnapshot) {
      return;
    }
    final saved = await memoryService.saveDraft(
      kind: MemoryKind.diary,
      title: title.text.trim(),
      body: _serialize(),
      childIds: [?child?.id],
      mediaAssets: [?photo],
      draftId: _draftId,
    );
    _draftId = saved.id;
    _savedSnapshot = snapshot;
    savedAt = saved.updatedAt;
    if (!isDisposed) {
      notifyListeners();
    }
  }

  /// “Lưu” — luôn thành công với dữ liệu mẫu (pass-through).
  Future<bool> save() async {
    _autosave?.cancel();
    _autosave = null;
    final current = child;
    final result = await callFuture(
      memoryService.create(
        kind: MemoryKind.diary,
        childIds: [?current?.id],
        title: title.text.trim(),
        body: _serialize(),
        mediaAssets: [?photo],
        visibility: visibility,
        occurredAt: occurredAt ?? today,
        // Offline-first: lưu trên máy ngay, tự gửi khi có mạng.
        deferUpload: true,
      ),
    );
    if (result.isSuccess) {
      await memoryService.clearDraft(MemoryKind.diary);
      _savedSnapshot = _snapshot;
    }
    return result.isSuccess;
  }

  @override
  void dispose() {
    // Đóng giữa chừng: lưu nốt thay đổi chưa kịp tự lưu.
    if (_autosave != null) {
      unawaited(autosave());
    }
    _autosave?.cancel();
    title.dispose();
    for (final block in blocks) {
      block.dispose();
    }
    super.dispose();
  }
}
