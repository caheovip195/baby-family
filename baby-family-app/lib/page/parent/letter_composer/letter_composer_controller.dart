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
import 'package:baby_family/utils/constants/values.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/legacy.dart';

/// MEM-14 Thư gửi con: người nhận (bé), hình thức, nội dung thư, hẹn ngày
/// mở (Không / Chọn ngày / Sinh nhật thứ N), ai được đọc, xem trước phong bì,
/// Niêm phong.
final letterComposerControllerProvider = ChangeNotifierProvider.autoDispose
    .family<LetterComposerController, String?>(LetterComposerController.new);

class LetterComposerController extends BaseNotifier {
  LetterComposerController(super.ref, String? childId) {
    _recipientId = childId ?? ref.read(selectedSubjectProvider);
    load();
  }

  IMemoryService get memoryService => ref.read(memoryServiceProvider);
  IChildService get childService => ref.read(childServiceProvider);
  IFamilyService get familyService => ref.read(familyServiceProvider);

  final body = TextEditingController();

  bool loaded = false;
  List<Child> children = const [];
  Member? me;
  Member? partner;
  String? _recipientId;
  LetterFormat format = LetterFormat.write;
  LetterOpenMode openMode = LetterOpenMode.birthday;
  int birthdayAge = kValueLetterDefaultBirthday;
  DateTime? pickedDate;
  MemoryVisibility readers = MemoryVisibility.parents;

  /// Lời mở đầu / ký tên lấy từ nháp (null → câu mặc định theo bé + người viết).
  String? _salutation;
  List<String>? _signature;

  DateTime get today => childService.today;

  Child? get recipient =>
      children.where((child) => child.id == _recipientId).firstOrNull ??
      children.firstOrNull;

  String? get salutation => _salutation;
  List<String>? get signature => _signature;

  /// Ngày mở thư theo lựa chọn (null = không hẹn).
  DateTime? get openDate {
    final birth = recipient?.birthDate;
    return switch (openMode) {
      LetterOpenMode.none => null,
      LetterOpenMode.date => pickedDate,
      LetterOpenMode.birthday =>
        birth == null
            ? null
            : DateTime(birth.year + birthdayAge, birth.month, birth.day),
    };
  }

  Future<void> load() async {
    try {
      final (kids, draft, current, other) = await (
        childService.children(),
        memoryService.draft(MemoryKind.letter),
        familyService.me(),
        familyService.partner(),
      ).wait;
      if (isDisposed) {
        return;
      }
      children = kids.where((child) => !child.isPregnancy).toList();
      me = current;
      partner = other;
      if (draft != null) {
        _applyDraft(draft);
      }
    } catch (_) {
      // Không có nháp — soạn thư trống.
    }
    if (isDisposed) {
      return;
    }
    loaded = true;
    notifyListeners();
  }

  /// Nháp: đoạn đầu = lời mở đầu, đoạn cuối = ký tên, ở giữa = thân thư.
  void _applyDraft(Memory draft) {
    _recipientId = draft.childIds.firstOrNull ?? _recipientId;
    readers = draft.visibility;
    final parts = (draft.body ?? '').split('\n\n');
    if (parts.length >= 3) {
      _salutation = parts.first;
      _signature = parts.last.split('\n');
      body.text = parts.sublist(1, parts.length - 1).join('\n\n');
    } else {
      body.text = draft.body ?? '';
    }
    final sealed = draft.sealedUntil;
    final birth = recipient?.birthDate;
    if (sealed == null) {
      openMode = LetterOpenMode.none;
    } else if (birth != null &&
        sealed.month == birth.month &&
        sealed.day == birth.day &&
        sealed.year > birth.year) {
      openMode = LetterOpenMode.birthday;
      birthdayAge = sealed.year - birth.year;
    } else {
      openMode = LetterOpenMode.date;
      pickedDate = sealed;
    }
  }

  void selectRecipient(String id) {
    if (id != _recipientId) {
      _recipientId = id;
      _salutation = null;
      notifyListeners();
    }
  }

  void setFormat(LetterFormat value) {
    format = value;
    notifyListeners();
  }

  void setOpenMode(LetterOpenMode value) {
    openMode = value;
    notifyListeners();
  }

  void setPickedDate(DateTime value) {
    pickedDate = value;
    openMode = LetterOpenMode.date;
    notifyListeners();
  }

  void changeBirthday(int delta) {
    birthdayAge = (birthdayAge + delta).clamp(1, 99);
    notifyListeners();
  }

  void setReaders(MemoryVisibility value) {
    readers = value;
    notifyListeners();
  }

  /// “Niêm phong thư” — lưu thư (ký ức loại thư) và xoá nháp.
  Future<bool> seal({
    required String salutation,
    required List<String> signature,
  }) async {
    final child = recipient;
    final text = [
      salutation,
      body.text.trim(),
      signature.join('\n'),
    ].where((part) => part.isNotEmpty).join('\n\n');
    final result = await callFuture(
      memoryService.create(
        kind: MemoryKind.letter,
        childIds: [?child?.id],
        body: text,
        visibility: readers,
        sealedUntil: openDate,
        // Offline-first: lưu trên máy ngay, tự gửi khi có mạng.
        deferUpload: true,
      ),
    );
    if (result.isSuccess) {
      await memoryService.clearDraft(MemoryKind.letter);
    }
    return result.isSuccess;
  }

  @override
  void dispose() {
    body.dispose();
    super.dispose();
  }
}
