import 'package:baby_family/data/dto/circle_view.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/provider/circle.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/circle.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:hooks_riverpod/legacy.dart';

/// CIR-01 — Cháu yêu (trang chủ người thân, chữ lớn): chọn cháu, ký ức mới
/// nhất làm ảnh lớn, ảnh mới trong tuần, Thả tim / Gửi lời chúc (mock).
final circleHomeControllerProvider =
    ChangeNotifierProvider.autoDispose<CircleHomeController>(
      CircleHomeController.new,
    );

class CircleHomeController extends BaseNotifier {
  CircleHomeController(super.ref) {
    // Nạp sau microtask: không đổi trạng thái khi provider đang được dựng.
    Future.microtask(load);
  }

  ICircleService get circleService => ref.read(circleServiceProvider);

  static const _weekPhotoCount = 3;
  static const _week = Duration(days: 7);

  CircleView? view;
  String? selectedChildId;
  bool hasError = false;
  final Set<String> _liked = {};

  /// userId → tên gọi (“Mama”) cho chú thích ký ức.
  Map<String, String> _authorNames = const {};

  DateTime get now => ref.read(appClockProvider).now();

  Child? get selectedChild =>
      view?.children.where((child) => child.id == selectedChildId).firstOrNull;

  List<Memory> get _childMemories => [
    for (final memory in view?.memories ?? const <Memory>[])
      if (memory.childIds.contains(selectedChildId)) memory,
  ];

  /// Ký ức mới nhất có ảnh (thiếu ảnh thì ký ức mới nhất).
  Memory? get hero {
    final memories = _childMemories;
    return memories.where((m) => m.mediaAssets.isNotEmpty).firstOrNull ??
        memories.firstOrNull;
  }

  /// Ảnh trong 7 ngày qua (trừ ảnh lớn), tối đa 3.
  List<String> get weekPhotos {
    final heroMemory = hero;
    final since = now.subtract(_week);
    return [
      for (final memory in _childMemories)
        if (memory.id != heroMemory?.id && memory.occurredAt.isAfter(since))
          ...memory.mediaAssets,
    ].take(_weekPhotoCount).toList();
  }

  bool get heroLiked => _liked.contains(hero?.id);

  String authorName(String userId) => _authorNames[userId] ?? '';

  Future<void> load() async {
    hasError = false;
    toLoading();
    try {
      final loaded = await circleService.view();
      final members = await ref.read(familyServiceProvider).members();
      if (isDisposed) {
        return;
      }
      view = loaded;
      _authorNames = {
        for (final member in members)
          if (member.userId != null) member.userId!: member.callName,
      };
      final children = loaded?.children ?? const <Child>[];
      if (!children.any((child) => child.id == selectedChildId)) {
        // Mặc định: cháu nhỏ nhất đã chào đời (Pencil chọn Haru).
        final sorted =
            children.where((child) => child.birthDate != null).toList()
              ..sort((a, b) => b.birthDate!.compareTo(a.birthDate!));
        selectedChildId = (sorted.firstOrNull ?? children.firstOrNull)?.id;
      }
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    toIdle();
  }

  void selectChild(String id) {
    selectedChildId = id;
    notifyListeners();
  }

  Future<void> like() async {
    final memory = hero;
    if (memory == null || !_liked.add(memory.id)) {
      return;
    }
    notifyListeners();
    await ref.read(memoryServiceProvider).react(memory.id, kValueHeartReaction);
  }

  Future<bool> sendWish(String body) async {
    final memory = hero;
    if (memory == null) {
      return false;
    }
    await circleService.sendWish(memory.id, body);
    return true;
  }
}
