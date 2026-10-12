import 'package:baby_family/data/model/child/child.dart';
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

/// MEM-23 Ghi câu nói của con (sheet ≤ 3 chạm).
final memoryQuoteControllerProvider =
    ChangeNotifierProvider.autoDispose<MemoryQuoteController>(
      MemoryQuoteController.new,
    );

class MemoryQuoteController extends BaseNotifier {
  MemoryQuoteController(super.ref);

  IMemoryService get memoryService => ref.read(memoryServiceProvider);
  IChildService get childService => ref.read(childServiceProvider);
  IFamilyService get familyService => ref.read(familyServiceProvider);

  final quote = TextEditingController();
  final quoteContext = TextEditingController();

  bool loaded = false;
  List<Child> children = const [];
  String? childId;
  int people = 0;
  MemoryVisibility visibility = MemoryVisibility.family;
  bool voiceAttached = false;

  DateTime get today => childService.today;
  Child? get child =>
      children.where((value) => value.id == childId).firstOrNull;

  Future<void> init(String? preferredChildId) async {
    final (kids, members, draft) = await (
      childService.children(),
      familyService.members(),
      memoryService.draft(MemoryKind.quote),
    ).wait;
    if (isDisposed) {
      return;
    }
    // Câu nói chỉ của bé đã sinh; mặc định bé lớn nhất (đã biết nói).
    children = kids.where((value) => !value.isPregnancy).toList();
    people = members.length;
    final ids = children.map((value) => value.id).toSet();
    childId = [
      preferredChildId,
      draft?.childIds.firstOrNull,
      children.firstOrNull?.id,
    ].firstWhere((id) => ids.contains(id), orElse: () => null);
    if (draft != null) {
      quote.text = draft.body ?? '';
    }
    loaded = true;
    notifyListeners();
  }

  void selectChild(String id) {
    childId = id;
    notifyListeners();
  }

  void setVisibility(MemoryVisibility value) {
    visibility = value;
    notifyListeners();
  }

  void toggleVoice() {
    voiceAttached = !voiceAttached;
    notifyListeners();
  }

  Future<bool> save() async {
    final id = childId;
    final result = await callFuture(
      memoryService.create(
        kind: MemoryKind.quote,
        childIds: [?id],
        body: quote.text.trim(),
        quoteContext: quoteContext.text.trim().isEmpty
            ? null
            : quoteContext.text.trim(),
        visibility: visibility,
        voiceDurationSec: voiceAttached ? 8 : null,
      ),
    );
    if (isDisposed || result.isFailure) {
      return false;
    }
    await memoryService.clearDraft(MemoryKind.quote);
    return true;
  }

  @override
  void dispose() {
    quote.dispose();
    quoteContext.dispose();
    super.dispose();
  }
}
