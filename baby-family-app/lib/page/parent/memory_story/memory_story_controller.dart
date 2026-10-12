import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/memory/story_item.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/service/child.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/legacy.dart';

/// MEM-25 Hôm nay của bé (trình chiếu story): bắt đầu từ story chưa xem,
/// đánh dấu đã xem theo người xem.
final memoryStoryControllerProvider =
    ChangeNotifierProvider.autoDispose<MemoryStoryController>(
      MemoryStoryController.new,
    );

class MemoryStoryController extends BaseNotifier {
  MemoryStoryController(super.ref);

  IMemoryService get memoryService => ref.read(memoryServiceProvider);
  IChildService get childService => ref.read(childServiceProvider);
  IFamilyService get familyService => ref.read(familyServiceProvider);

  /// Thời gian hiển thị mỗi ảnh (tài liệu 9.4 MEM-25: ảnh 5 giây).
  static const photoDuration = Duration(seconds: 5);

  final reply = TextEditingController();
  bool loaded = false;
  Child? child;
  List<StoryItem> stories = const [];
  Map<String, Member> _membersByUser = const {};
  int index = 0;

  StoryItem? get current => index < stories.length ? stories[index] : null;
  Member? memberByUser(String? userId) => _membersByUser[userId];

  Future<void> init(String childId) async {
    final (value, items, members) = await (
      childService.child(childId),
      memoryService.stories(childId: childId),
      familyService.members(),
    ).wait;
    if (isDisposed) {
      return;
    }
    child = value;
    stories = items;
    _membersByUser = {
      for (final member in members)
        if (member.userId != null) member.userId!: member,
    };
    final unseen = items.indexWhere((story) => !story.seen);
    index = unseen < 0 ? 0 : unseen;
    loaded = true;
    notifyListeners();
    await _markSeen();
  }

  Future<void> _markSeen() async {
    final story = current;
    if (story != null && !story.seen) {
      await memoryService.markStorySeen(story.id);
    }
  }

  /// Sang story kế; trả về false khi đã hết (màn đóng lại).
  bool next() {
    if (index + 1 >= stories.length) {
      return false;
    }
    index++;
    notifyListeners();
    _markSeen();
    return true;
  }

  void previous() {
    if (index > 0) {
      index--;
      notifyListeners();
    }
  }

  Future<void> react(String emoji) async {
    final memoryId = current?.memoryId;
    if (memoryId != null) {
      await memoryService.react(memoryId, emoji);
    }
  }

  Future<void> sendReply() async {
    final memoryId = current?.memoryId;
    final text = reply.text.trim();
    if (memoryId == null || text.isEmpty) {
      return;
    }
    reply.clear();
    await memoryService.addComment(memoryId, text);
  }

  @override
  void dispose() {
    reply.dispose();
    super.dispose();
  }
}
