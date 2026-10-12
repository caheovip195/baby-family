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
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/legacy.dart';

/// MEM-05 Soạn ký ức (+ MEM-13 nhật ký, MEM-14 thư, cột mốc, ghi âm, kỷ vật,
/// ảnh tháng từ MEM-21). Không chặn lưu (giai đoạn UI): thiếu bé → gắn
/// “Cả nhà”.
final memoryComposerControllerProvider =
    ChangeNotifierProvider.autoDispose<MemoryComposerController>(
      MemoryComposerController.new,
    );

class MemoryComposerController extends BaseNotifier {
  MemoryComposerController(super.ref);

  IMemoryService get memoryService => ref.read(memoryServiceProvider);
  IChildService get childService => ref.read(childServiceProvider);
  IFamilyService get familyService => ref.read(familyServiceProvider);

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
  String? milestoneCode;
  String? milestoneTitle;
  DateTime? sealedUntil;
  int? voiceDurationSec;
  int? monthIndex;

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

  Future<void> init(String? kindName, String? childId) async {
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

  void setVisibility(MemoryVisibility value) {
    visibility = value;
    notifyListeners();
  }

  void setMilestone({required String code, required String title}) {
    milestoneCode = code;
    milestoneTitle = title;
    notifyListeners();
  }

  void setSealedUntil(DateTime? value) {
    sealedUntil = value;
    notifyListeners();
  }

  void toggleVoice() {
    voiceDurationSec = voiceDurationSec == null ? 12 : null;
    notifyListeners();
  }

  void removeMedia(String asset) {
    mediaAssets.remove(asset);
    notifyListeners();
  }

  /// Bé dùng cho MEM-11 (bé đầu tiên đang chọn, không phải thai kỳ).
  String? get milestoneChildId =>
      (firstChild ?? children.where((child) => !child.isPregnancy).firstOrNull)
          ?.id;

  /// Lưu ký ức (pass-through: luôn thành công với dữ liệu mẫu).
  Future<Memory?> save() async {
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
              mediaAssets: mediaAssets,
              visibility: visibility,
              occurredAt: occurredAt,
              milestoneCode: milestoneCode,
              milestoneTitle: milestoneTitle,
              voiceDurationSec: voiceDurationSec,
              sealedUntil: sealedUntil,
            ),
    );
    if (isDisposed) {
      return null;
    }
    if (result.isFailure) {
      return null;
    }
    await memoryService.clearDraft(kind);
    return result.dataOrThrow;
  }

  @override
  void dispose() {
    caption.dispose();
    title.dispose();
    super.dispose();
  }
}
