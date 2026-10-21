import 'dart:async';

import 'package:baby_family/data/dto/result.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/family.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/family/plan_offer.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/service/child.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/data/service/voice_recording.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/legacy.dart';

/// MEM-05 Soạn ký ức (+ MEM-13 nhật ký, MEM-14 thư, cột mốc, ghi âm, kỷ vật,
/// ảnh tháng từ MEM-21) và MEM-09 Sửa ký ức (cùng form, điền sẵn; người không
/// phải tác giả chỉ đổi bé và người xem — đặc tả 7.8.3). Không chặn lưu (giai
/// đoạn UI): thiếu bé → gắn “Cả nhà”.
final memoryComposerControllerProvider =
    ChangeNotifierProvider.autoDispose<MemoryComposerController>(
      MemoryComposerController.new,
    );

class MemoryComposerController extends BaseNotifier {
  MemoryComposerController(super.ref);

  IMemoryService get memoryService => ref.read(memoryServiceProvider);
  IChildService get childService => ref.read(childServiceProvider);
  IFamilyService get familyService => ref.read(familyServiceProvider);
  IVoiceRecordingService get voiceRecording =>
      ref.read(voiceRecordingServiceProvider);

  /// Xin quyền thư viện (một lần) để ưu tiên hiển thị bản gốc trong máy.
  Future<void> enableLocalMedia() =>
      ref.read(localMediaServiceProvider).enable();

  final caption = TextEditingController();
  final title = TextEditingController();

  MemoryKind kind = MemoryKind.photo;
  bool loaded = false;
  List<Child> children = const [];
  List<Member> members = const [];
  List<String> mediaAssets = [];
  final Set<String> childIds = {};
  bool familyMoment = false;
  late DateTime occurredAt = today;
  MemoryVisibility visibility = MemoryVisibility.family;

  /// MEM-09: tác giả bật/tắt bình luận của ký ức.
  bool commentsEnabled = true;
  String? milestoneCode;
  String? milestoneTitle;
  DateTime? sealedUntil;
  int? voiceDurationSec;

  /// Tệp ghi âm trên máy (rỗng ở bản mẫu); gửi lên như asset audio của VOICE.
  String? voicePath;

  /// Đang ghi âm.
  bool recording = false;

  /// Người dùng từ chối quyền micro ở lần bấm gần nhất.
  bool micDenied = false;

  /// “Nâng cao” (đặc tả 7.8.2): ai ở đó, cảm xúc của khoảnh khắc, địa điểm.
  List<String> people = [];
  String? feeling;
  String? locationLabel;
  int? monthIndex;

  /// Lỗi của lần lưu gần nhất (server từ chối, mất mạng…) để màn báo lại.
  Exception? saveError;

  /// MEM-09: ký ức đang sửa (null = soạn mới).
  Memory? editing;

  bool get isEditing => editing != null;

  /// MEM-18: [editing] là nháp trên tài khoản — lưu xong thì đăng.
  bool publishOnSave = false;

  /// MEM-09: chỉ tác giả sửa chú thích, tiêu đề và ngày.
  bool canEditContent = true;

  DateTime get today => childService.today;

  int get relativeCount =>
      members.where((member) => member.role == FamilyRole.relative).length;

  /// Bé được chọn đầu tiên (ảnh tháng, thư, chọn cột mốc).
  Child? get firstChild =>
      children.where((child) => childIds.contains(child.id)).firstOrNull;

  bool get hasMedia => switch (kind) {
    MemoryKind.photo ||
    MemoryKind.milestone ||
    MemoryKind.keepsake ||
    MemoryKind.monthlyPhoto ||
    MemoryKind.diary => true,
    _ => false,
  };

  Future<void> init(
    String? kindName,
    String? childId, {
    String? memoryId,
    String? draftId,
  }) async {
    if (draftId != null) {
      publishOnSave = true;
      return _initEdit(draftId);
    }
    if (memoryId != null) {
      return _initEdit(memoryId);
    }
    kind = MemoryKind.fromName(kindName) ?? MemoryKind.photo;
    final (loadedChildren, loadedMembers, draft) = await (
      childService.children(),
      familyService.members(),
      memoryService.draft(kind),
    ).wait;
    if (isDisposed) {
      return;
    }
    // Thai kỳ chỉ hiện khi soạn cho chính thai kỳ đó (Pencil MEM-05: Hana,
    // Haru, Cả nhà).
    children = loadedChildren
        .where((child) => !child.isPregnancy || child.id == childId)
        .toList();
    members = loadedMembers;
    if (draft != null) {
      caption.text = draft.body ?? '';
      title.text = draft.title ?? '';
      mediaAssets = [...draft.mediaAssets];
      childIds.addAll(draft.childIds);
      milestoneCode = draft.milestoneCode;
      milestoneTitle = draft.milestoneTitle;
    } else if (childId != null &&
        children.any((child) => child.id == childId)) {
      childIds.add(childId);
    }
    if (kind == MemoryKind.letter && childIds.isEmpty) {
      final first = children.firstOrNull;
      if (first != null) {
        childIds.add(first.id);
      }
    }
    if (kind == MemoryKind.monthlyPhoto) {
      final child = firstChild;
      final birth = child?.birthDate;
      monthIndex = birth == null ? null : childMonthIndex(birth, today);
      final asset = child?.coverAsset ?? child?.avatarAsset;
      mediaAssets = [?asset];
    }
    loaded = true;
    notifyListeners();
  }

  /// MEM-09: điền sẵn từ ký ức; thai kỳ chỉ hiện khi ký ức gắn thai kỳ đó.
  Future<void> _initEdit(String memoryId) async {
    final (memory, loadedChildren, loadedMembers, me) = await (
      memoryService.memory(memoryId),
      childService.children(),
      familyService.members(),
      familyService.me(),
    ).wait;
    if (isDisposed) {
      return;
    }
    if (memory != null) {
      editing = memory;
      kind = memory.kind;
      canEditContent = memory.authorId == me?.userId;
      caption.text = memory.body ?? '';
      title.text = memory.title ?? '';
      mediaAssets = [...memory.mediaAssets];
      childIds.addAll(memory.childIds);
      familyMoment = memory.childIds.isEmpty;
      occurredAt = memory.occurredAt;
      visibility = memory.visibility;
      commentsEnabled = memory.commentsEnabled;
    }
    children = loadedChildren
        .where((child) => !child.isPregnancy || childIds.contains(child.id))
        .toList();
    members = loadedMembers;
    loaded = true;
    notifyListeners();
  }

  /// Đang soạn dở: có chữ / ảnh / ghi âm (ảnh tháng tự điền ảnh nên bỏ qua).
  /// Khi sửa, đóng không lưu thì bỏ thay đổi (không tạo nháp).
  bool get hasContent =>
      loaded &&
      !isEditing &&
      kind != MemoryKind.monthlyPhoto &&
      (caption.text.trim().isNotEmpty ||
          title.text.trim().isNotEmpty ||
          mediaAssets.isNotEmpty ||
          voiceDurationSec != null);

  /// Đóng giữa chừng → nháp trên máy (MEM-18).
  Future<void> saveDraft() async {
    final heading = title.text.trim();
    await memoryService.saveDraft(
      kind: kind,
      title: heading.isNotEmpty ? heading : caption.text.trim(),
      childIds: childIds.toList(),
      mediaAssets: mediaAssets,
      voiceDurationSec: voiceDurationSec,
    );
  }

  void toggleChild(String id) {
    if (kind == MemoryKind.letter) {
      childIds
        ..clear()
        ..add(id);
    } else if (!childIds.remove(id)) {
      childIds.add(id);
    }
    notifyListeners();
  }

  void toggleFamilyMoment() {
    familyMoment = !familyMoment;
    notifyListeners();
  }

  void setDate(DateTime value) {
    occurredAt = value;
    notifyListeners();
  }

  /// “Chỉ mình tôi” chỉ dành cho tác giả (MEM-09).
  List<MemoryVisibility> get visibilityOptions => canEditContent
      ? MemoryVisibility.values
      : [
          for (final value in MemoryVisibility.values)
            if (value != MemoryVisibility.onlyMe) value,
        ];

  void setVisibility(MemoryVisibility value) {
    if (!visibilityOptions.contains(value)) {
      return;
    }
    visibility = value;
    notifyListeners();
  }

  void setCommentsEnabled(bool value) {
    commentsEnabled = value;
    notifyListeners();
  }

  void setMilestone({required String code, required String title}) {
    milestoneCode = code;
    milestoneTitle = title;
    notifyListeners();
  }

  /// Tên gợi ý cho “Ai ở đó”: thành viên gia đình (tên gọi trong nhà).
  List<String> get peopleSuggestions => [
    for (final member in members)
      if (member.callName.isEmpty ? member.displayName : member.callName
          case final name when name.trim().isNotEmpty)
        name,
  ];

  void togglePerson(String name) {
    final value = name.trim();
    if (value.isEmpty) {
      return;
    }
    people = people.contains(value)
        ? [
            for (final person in people)
              if (person != value) person,
          ]
        : [...people, value];
    notifyListeners();
  }

  void setFeeling(String? value) {
    feeling = value;
    notifyListeners();
  }

  void setLocation(String? value) {
    final text = value?.trim();
    locationLabel = text == null || text.isEmpty ? null : text;
    notifyListeners();
  }

  void setSealedUntil(DateTime? value) {
    sealedUntil = value;
    notifyListeners();
  }

  /// Bấm mic: bắt đầu → dừng (giữ bản ghi) → bấm lại để ghi lại từ đầu.
  Future<void> toggleVoice() async {
    if (recording) {
      final result = await voiceRecording.stop();
      recording = false;
      voiceDurationSec = result?.durationSec;
      voicePath = result?.path;
    } else if (voiceDurationSec != null) {
      voiceDurationSec = null;
      voicePath = null;
    } else {
      micDenied = !await voiceRecording.start();
      recording = !micDenied;
    }
    if (!isDisposed) {
      notifyListeners();
    }
  }

  /// SUB-05: giới hạn độ dài video (phút) của gói đang dùng và gói hiện tại
  /// (gói chưa bán trên Store — dùng thử/hết hạn — theo giới hạn Family).
  Future<({int maxMinutes, PlanState plan})> videoLimit() async {
    final results = await Future.wait<Object?>([
      familyService.currentFamily(),
      familyService.planOffers(),
    ]);
    final plan = (results[0] as Family?)?.plan.state ?? PlanState.family;
    final offers = results[1]! as List<PlanOffer>;
    final offer =
        offers.where((o) => o.code == plan).firstOrNull ??
        offers.where((o) => o.code == PlanState.family).firstOrNull;
    return (maxMinutes: offer?.videoMinutes ?? 0, plan: plan);
  }

  /// MEM-04: ảnh chọn từ photo picker hệ thống (đường dẫn file trên máy).
  /// Video đã chọn dài hơn giới hạn của gói thì bỏ ra; trả số phút (làm tròn
  /// lên) của video dài nhất bị bỏ để hiện SUB-05.
  Future<({List<String> accepted, int? tooLongMinutes})> screenPicked(
    List<String> paths,
  ) async {
    final limit = await videoLimit();
    final accepted = <String>[];
    int? tooLong;
    for (final path in paths) {
      final seconds = await memoryService.videoDurationSec(path);
      if (seconds != null && seconds > limit.maxMinutes * 60) {
        final minutes = (seconds / 60).ceil();
        tooLong = tooLong == null || minutes > tooLong ? minutes : tooLong;
        continue;
      }
      accepted.add(path);
    }
    return (accepted: accepted, tooLongMinutes: tooLong);
  }

  void addMedia(List<String> paths) {
    if (paths.isEmpty) {
      return;
    }
    mediaAssets = [
      ...mediaAssets,
      ...paths.where((p) => !mediaAssets.contains(p)),
    ];
    notifyListeners();
  }

  /// MEM-09: tác giả đổi ảnh khi sửa (thêm/bớt, đổi bìa); ký ức có ảnh phải
  /// còn ít nhất một ảnh.
  bool get canEditMedia => !isEditing || canEditContent;

  bool get canRemoveMedia =>
      canEditMedia &&
      (!isEditing || editing!.mediaAssets.isEmpty || mediaAssets.length > 1);

  void removeMedia(String asset) {
    if (!canRemoveMedia) {
      return;
    }
    mediaAssets.remove(asset);
    notifyListeners();
  }

  /// Ảnh đầu danh sách là bìa.
  void makeCover(String asset) {
    if (!canEditMedia || !mediaAssets.remove(asset)) {
      return;
    }
    mediaAssets = [asset, ...mediaAssets];
    notifyListeners();
  }

  /// Bé dùng cho MEM-11 (bé đầu tiên đang chọn, không phải thai kỳ).
  String? get milestoneChildId =>
      (firstChild ?? children.where((child) => !child.isPregnancy).firstOrNull)
          ?.id;

  /// Lưu ký ức (bản mock luôn thành công; chế độ server tải ảnh lên rồi tạo ký
  /// ức — lỗi ghi vào [saveError]).
  Future<Memory?> save() async {
    final original = editing;
    if (original != null) {
      return _saveEdit(original);
    }
    final ids = childIds.isEmpty
        ? children.where((child) => !child.isPregnancy).map((c) => c.id)
        : childIds;
    final text = caption.text.trim();
    final heading = title.text.trim();
    final child = firstChild;
    final result = await callFuture(
      kind == MemoryKind.monthlyPhoto && child != null && mediaAssets.isNotEmpty
          ? memoryService.saveMonthlyPhoto(
              child.id,
              asset: mediaAssets.first,
              monthIndex: monthIndex,
            )
          : memoryService.create(
              kind: kind,
              childIds: ids.toList(),
              title: heading.isEmpty ? null : heading,
              body: text.isEmpty ? null : text,
              mediaAssets: kind == MemoryKind.voice && voicePath != ''
                  ? [?voicePath]
                  : mediaAssets,
              visibility: visibility,
              occurredAt: occurredAt,
              people: people,
              feeling: feeling,
              locationLabel: locationLabel,
              milestoneCode: milestoneCode,
              milestoneTitle: milestoneTitle,
              voiceDurationSec: voiceDurationSec,
              sealedUntil: sealedUntil,
              // MEM-06: ảnh/video tải nền, màn soạn đóng ngay.
              deferUpload: true,
            ),
    );
    if (isDisposed) {
      return null;
    }
    if (result case Failure(:final error)) {
      saveError = error;
      return null;
    }
    saveError = null;
    await memoryService.clearDraft(kind);
    return result.dataOrThrow;
  }

  /// MEM-09: chỉ gửi trường đã đổi (người lưu sau thắng ở từng trường — đặc tả
  /// 13.3); người không phải tác giả không gửi chú thích/ngày.
  Future<Memory?> _saveEdit(Memory original) async {
    final text = caption.text.trim();
    final heading = title.text.trim();
    final ids = familyMoment
        ? <String>[]
        : childIds.isEmpty
        ? children
              .where((child) => !child.isPregnancy)
              .map((c) => c.id)
              .toList()
        : childIds.toList();
    final sameKids =
        ids.length == original.childIds.length &&
        ids.toSet().containsAll(original.childIds);
    final result = await callFuture(
      memoryService.updateMemory(
        original.id,
        title: canEditContent && heading != (original.title ?? '').trim()
            ? heading
            : null,
        body: canEditContent && text != (original.body ?? '').trim()
            ? text
            : null,
        childIds: sameKids ? null : ids,
        occurredAt: canEditContent && occurredAt != original.occurredAt
            ? occurredAt
            : null,
        visibility: visibility == original.visibility ? null : visibility,
        commentsEnabled:
            canEditContent && commentsEnabled != original.commentsEnabled
            ? commentsEnabled
            : null,
        mediaAssets:
            canEditMedia && !_sameList(mediaAssets, original.mediaAssets)
            ? [...mediaAssets]
            : null,
      ),
    );
    if (isDisposed) {
      return null;
    }
    if (result case Failure(:final error)) {
      saveError = error;
      return null;
    }
    if (publishOnSave) {
      final published = await callFuture(
        memoryService.publishDraft(original.id),
      );
      if (isDisposed) {
        return null;
      }
      if (published case Failure(:final error)) {
        saveError = error;
        return null;
      }
      saveError = null;
      return published.dataOrThrow ?? result.dataOrThrow;
    }
    saveError = null;
    return result.dataOrThrow;
  }

  static bool _sameList(List<String> a, List<String> b) =>
      a.length == b.length &&
      [for (var i = 0; i < a.length; i++) a[i] == b[i]].every((same) => same);

  @override
  void dispose() {
    if (recording) {
      unawaited(voiceRecording.cancel());
    }
    caption.dispose();
    title.dispose();
    super.dispose();
  }
}
