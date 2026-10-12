import 'package:baby_family/data/dto/birth_draft.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/pregnancy/name_candidate.dart';
import 'package:baby_family/data/model/pregnancy/prep_summary.dart';
import 'package:baby_family/data/service/base.dart';
import 'package:baby_family/utils/constants/enum.dart';

/// Thai kỳ: chuẩn bị đón bé, đặt tên, chào đời, lưu trữ (PREG-01…07, HOME-03).
/// Ảnh bụng/siêu âm/ký ức thai kỳ đi qua `IMemoryService`.
abstract class IPregnancyService extends IBaseService {
  /// PREG-04 + HOME-03 “12/30”.
  Future<PrepSummary> prep(String pregnancyId);

  Future<void> togglePrep(String itemId);

  Future<void> addPrep(
    String pregnancyId, {
    required String title,
    PrepGroup group = PrepGroup.bag,
    MissionOwnerKind ownerKind = MissionOwnerKind.me,
  });

  /// Đổi nhãn người phụ trách (“Cùng nhau” / “Của tôi”); nhờ bạn đời dùng
  /// [requestPrepFromPartner].
  Future<void> setPrepOwner(String itemId, MissionOwnerKind ownerKind);

  /// “Đã nhờ Papa” — gửi Lời nhờ cho bạn đời và gắn nhãn mục chuẩn bị.
  Future<void> requestPrepFromPartner(String itemId);

  /// PREG-07 (chỉ Papa & Mama).
  Future<List<NameCandidate>> names(String pregnancyId);

  Future<void> addName(
    String pregnancyId, {
    required String name,
    String? meaning,
  });

  /// Thích/bỏ thích của chính tôi.
  Future<void> toggleNameLike(String nameId);

  /// Chọn tên → cột mốc “Chọn được tên” của thai kỳ (cập nhật nếu đã có).
  Future<void> chooseName(String nameId);

  /// PREG-05 B2: điền sẵn tên đã chọn/cả hai thích + tên ở nhà + bản nháp.
  Future<BirthDraft> birthDraft(String pregnancyId);

  /// PREG-05: thai kỳ → bé đã chào đời (ký ức thai kỳ thành chương đầu).
  Future<Child> convertToBaby(
    String pregnancyId, {
    required String name,
    required DateTime birthDate,
    String? nickname,
    String? avatarAsset,
    ChildGender gender = ChildGender.unknown,
    double? weightKg,
    double? heightCm,
    String? birthTime,
  });

  /// PREG-06: lưu trữ hành trình (ẩn khỏi Trang chủ, tắt nhắc);
  /// [parentsOnly] → mọi ký ức thai kỳ chỉ Papa & Mama xem.
  Future<void> archive(String pregnancyId, {bool parentsOnly = true});
}
