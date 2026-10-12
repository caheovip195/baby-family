import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/service/child.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/legacy.dart';

/// MEM-24 Thêm góc nhìn của bạn (mỗi Parent 1 góc nhìn/ký ức — BR-071;
/// mở lại sẽ sửa góc nhìn đã có).
final memoryPerspectiveControllerProvider =
    ChangeNotifierProvider.autoDispose<MemoryPerspectiveController>(
      MemoryPerspectiveController.new,
    );

class MemoryPerspectiveController extends BaseNotifier {
  MemoryPerspectiveController(super.ref);

  IMemoryService get memoryService => ref.read(memoryServiceProvider);
  IFamilyService get familyService => ref.read(familyServiceProvider);
  IChildService get childService => ref.read(childServiceProvider);

  final body = TextEditingController();
  bool loaded = false;
  Memory? memory;
  Member? author;
  int people = 0;
  List<String> mediaAssets = [];

  DateTime get today => childService.today;

  Future<void> init(String memoryId) async {
    final (value, views, members, me) = await (
      memoryService.memory(memoryId),
      memoryService.perspectives(memoryId),
      familyService.members(),
      familyService.me(),
    ).wait;
    if (isDisposed) {
      return;
    }
    memory = value;
    author = members
        .where((member) => member.userId == value?.authorId)
        .firstOrNull;
    people = members.length;
    final mine = views.where((view) => view.authorId == me?.userId).firstOrNull;
    if (mine != null) {
      body.text = mine.body;
      mediaAssets = [...mine.mediaAssets];
    }
    loaded = true;
    notifyListeners();
  }

  Future<bool> save() async {
    final value = memory;
    if (value == null) {
      return false;
    }
    final result = await callFuture(
      memoryService.savePerspective(
        value.id,
        body: body.text,
        mediaAssets: mediaAssets,
      ),
    );
    return !isDisposed && result.isSuccess;
  }

  @override
  void dispose() {
    body.dispose();
    super.dispose();
  }
}
