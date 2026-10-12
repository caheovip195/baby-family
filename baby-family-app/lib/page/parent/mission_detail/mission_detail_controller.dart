import 'package:baby_family/data/dto/mission_completion.dart';
import 'package:baby_family/data/model/care/mission.dart';
import 'package:baby_family/data/model/care/swap_option.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/care.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/care.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// CARE-02 “Chi tiết nhiệm vụ” (mục 9.7, không có trong Pencil): Hoàn thành /
/// Đổi (nhiệm vụ hệ thống) / Bỏ khỏi hôm nay; của bạn đời chỉ xem + Cảm ơn.
final missionDetailControllerProvider =
    ChangeNotifierProvider.autoDispose<MissionDetailController>(
      MissionDetailController.new,
    );

class MissionDetailController extends BaseNotifier {
  MissionDetailController(super.ref) {
    ref
      ..listen(mockRevisionProvider, (_, _) => _reload())
      ..listen(appLanguageProvider, (_, _) => _reload());
  }

  ICareService get careService => ref.read(careServiceProvider);

  String? missionId;
  Mission? mission;
  List<Child> children = const [];
  Member? partner;
  bool loaded = false;

  DateTime get now => ref.read(appClockProvider).now();

  bool get isMine => mission?.ownerKind == MissionOwnerKind.me;

  bool get isPartner => mission?.ownerKind == MissionOwnerKind.partner;

  bool get canSwap =>
      isMine &&
      mission?.source == MissionSource.system &&
      !(mission?.isDone ?? true);

  List<Child> get missionChildren => [
    for (final child in children)
      if (mission?.childIds.contains(child.id) ?? false) child,
  ];

  String get partnerCallName => partner?.callName ?? '';

  Future<void> init(String id) async {
    missionId = id;
    await _reload();
  }

  Future<void> _reload() async {
    final id = missionId;
    if (id == null) {
      return;
    }
    final loadedMission = await careService.mission(id);
    final loadedChildren = await ref.read(childServiceProvider).children();
    final loadedPartner = await ref.read(familyServiceProvider).partner();
    if (isDisposed) {
      return;
    }
    mission = loadedMission;
    children = loadedChildren;
    partner = loadedPartner;
    loaded = true;
    notifyListeners();
  }

  Future<MissionCompletion?> complete() async {
    final id = missionId;
    if (id == null || isPartner) {
      return null;
    }
    final result = await callFuture(careService.completeMission(id));
    return result.isSuccess ? result.dataOrThrow : null;
  }

  Future<void> undo() => careService.undoCompletion(missionId!);

  Future<void> saveMoment(String note) => careService.saveMoment(
    missionId!,
    note: note.trim().isEmpty ? null : note,
  );

  Future<SwapOption> swapOptions() => careService.swapOptions(missionId!);

  Future<void> swap(String templateId) =>
      careService.swapMission(missionId!, templateId);

  Future<void> removeFromToday() => careService.removeFromToday(missionId!);

  Future<void> thank() async {
    if (mission?.thankedByPartner ?? true) {
      return;
    }
    await careService.thankPartner(missionId!);
  }
}
