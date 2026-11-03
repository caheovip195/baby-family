import 'package:baby_family/data/model/family/family.dart';
import 'package:baby_family/data/model/family/plan_offer.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/utils/constants/enum.dart';

/// SUB-05: giới hạn độ dài video (phút) của gói đang dùng và gói hiện tại
/// (gói chưa bán trên Store — dùng thử/hết hạn — theo giới hạn Family). Dùng
/// chung cho MEM-04 và MEM-24 (BF-20261030-007).
Future<({int maxMinutes, PlanState plan})> planVideoLimit(
  IFamilyService familyService,
) async {
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

/// Bỏ video dài hơn giới hạn của gói; trả số phút (làm tròn lên) của video
/// dài nhất bị bỏ để hiện SUB-05.
Future<({List<String> accepted, int? tooLongMinutes})> screenPickedMedia(
  IFamilyService familyService,
  IMemoryService memoryService,
  List<String> paths,
) async {
  final limit = await planVideoLimit(familyService);
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
