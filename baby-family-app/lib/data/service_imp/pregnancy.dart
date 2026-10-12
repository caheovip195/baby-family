import 'package:baby_family/data/dto/birth_draft.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/pregnancy/name_candidate.dart';
import 'package:baby_family/data/model/pregnancy/prep_item.dart';
import 'package:baby_family/data/model/pregnancy/prep_summary.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/child.dart';
import 'package:baby_family/data/repository/family.dart';
import 'package:baby_family/data/repository/memory.dart';
import 'package:baby_family/data/repository/pregnancy.dart';
import 'package:baby_family/data/repository/us.dart';
import 'package:baby_family/data/service/pregnancy.dart';
import 'package:baby_family/data/service_imp/mock_service.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/helper/child_age.dart';

class PregnancyServiceImp extends MockServiceImp implements IPregnancyService {
  PregnancyServiceImp(
    super.sessionRepository,
    super.clock,
    this._repository,
    this._childRepository,
    this._familyRepository,
    this._memoryRepository,
    this._usRepository,
  );

  final IPregnancyRepository _repository;
  final IChildRepository _childRepository;
  final IFamilyRepository _familyRepository;
  final IMemoryRepository _memoryRepository;
  final IUsRepository _usRepository;

  MissionOwnerKind _owner(JsonMap row) {
    if (row['together'] == true) {
      return MissionOwnerKind.together;
    }
    return row['ownerUserId'] == myUserId
        ? MissionOwnerKind.me
        : MissionOwnerKind.partner;
  }

  String? get _partnerUserId => _familyRepository
      .members(familyId)
      .where(
        (row) =>
            row['role'] != FamilyRole.relative.name &&
            row['userId'] != myUserId,
      )
      .map((row) => row['userId'] as String?)
      .firstOrNull;

  @override
  Future<PrepSummary> prep(String pregnancyId) async {
    await ready();
    final items = [
      for (final row in _repository.prepItems(pregnancyId))
        PrepItem.fromJson({...row, 'ownerKind': _owner(row).name}),
    ];
    final hidden = _repository.prepHiddenCounts();
    return PrepSummary(
      done:
          ((hidden['done'] as int?) ?? 0) +
          items.where((item) => item.done).length,
      total: ((hidden['total'] as int?) ?? 0) + items.length,
      items: items,
    );
  }

  @override
  Future<void> togglePrep(String itemId) async {
    await ready();
    final item = _findPrep(itemId);
    if (item != null) {
      _repository.updatePrepItem(itemId, {'done': item['done'] != true});
    }
  }

  JsonMap? _findPrep(String itemId) {
    for (final child in _childRepository.children(familyId)) {
      for (final row in _repository.prepItems(child['id'] as String)) {
        if (row['id'] == itemId) {
          return row;
        }
      }
    }
    return null;
  }

  @override
  Future<void> addPrep(
    String pregnancyId, {
    required String title,
    PrepGroup group = PrepGroup.bag,
    MissionOwnerKind ownerKind = MissionOwnerKind.me,
  }) async {
    await ready();
    _repository.addPrepItem({
      'familyId': familyId,
      'pregnancyId': pregnancyId,
      'group': group.name,
      'title': title.trim(),
      'done': false,
      'ownerUserId': ownerKind == MissionOwnerKind.together ? null : myUserId,
      'together': ownerKind == MissionOwnerKind.together,
      'requestedFromPartner': false,
      'isCustom': true,
    });
  }

  @override
  Future<void> setPrepOwner(String itemId, MissionOwnerKind ownerKind) async {
    await ready();
    if (ownerKind == MissionOwnerKind.partner) {
      return requestPrepFromPartner(itemId);
    }
    _repository.updatePrepItem(itemId, {
      'ownerUserId': ownerKind == MissionOwnerKind.together ? null : myUserId,
      'together': ownerKind == MissionOwnerKind.together,
      'requestedFromPartner': false,
    });
  }

  @override
  Future<void> requestPrepFromPartner(String itemId) async {
    await ready();
    final item = _findPrep(itemId);
    if (item == null) {
      return;
    }
    _repository.updatePrepItem(itemId, {
      'requestedFromPartner': true,
      'ownerUserId': _partnerUserId,
      'together': false,
    });
    _usRepository.addRequest({
      'familyId': familyId,
      'kind': RequestKind.task.name,
      'templateCode': 'prep',
      'title': item['title'],
      'childIds': [item['pregnancyId']],
      'dueAt': now.toIso8601String(),
      'urgency': RequestUrgency.normal.name,
      'status': RequestStatus.sent.name,
      'senderId': myUserId,
      'receiverId': _partnerUserId ?? '',
      'sentAt': now.toIso8601String(),
    });
  }

  @override
  Future<List<NameCandidate>> names(String pregnancyId) async {
    await ready();
    return [
      for (final row in _repository.names(pregnancyId))
        NameCandidate.fromJson({
          ...row,
          'addedByCallName': _callNameOf(row['addedByUserId'] as String?),
          'likedByMe': (row['likedByUserIds'] as List).contains(myUserId),
          'likedByPartner': (row['likedByUserIds'] as List).any(
            (id) => id != myUserId,
          ),
        }),
    ];
  }

  String? _callNameOf(String? userId) => _familyRepository
      .members(familyId)
      .where((row) => row['userId'] == userId)
      .map((row) => row['callName'] as String?)
      .firstOrNull;

  @override
  Future<void> addName(
    String pregnancyId, {
    required String name,
    String? meaning,
  }) async {
    await ready();
    _repository.addName({
      'familyId': familyId,
      'pregnancyId': pregnancyId,
      'name': name.trim(),
      'meaning': ?meaning,
      'addedByUserId': myUserId,
      'likedByUserIds': [myUserId],
      'createdAt': now.toIso8601String(),
    });
  }

  JsonMap? _findName(String nameId) {
    for (final child in _childRepository.children(familyId)) {
      for (final row in _repository.names(child['id'] as String)) {
        if (row['id'] == nameId) {
          return row;
        }
      }
    }
    return null;
  }

  @override
  Future<void> toggleNameLike(String nameId) async {
    await ready();
    final row = _findName(nameId);
    if (row == null) {
      return;
    }
    final liked = [...(row['likedByUserIds'] as List).cast<String>()];
    liked.contains(myUserId) ? liked.remove(myUserId) : liked.add(myUserId);
    _repository.updateName(nameId, {'likedByUserIds': liked});
  }

  @override
  Future<void> chooseName(String nameId) async {
    await ready();
    final row = _findName(nameId);
    if (row == null) {
      return;
    }
    final pregnancyId = row['pregnancyId'] as String;
    for (final other in _repository.names(pregnancyId)) {
      _repository.updateName(other['id'] as String, {
        'chosen': other['id'] == nameId,
      });
    }
    _saveNameMilestone(pregnancyId, row['name'] as String);
  }

  /// Cột mốc “Chọn được tên” (7.5) — một ký ức/thai kỳ, chọn lại thì cập nhật.
  void _saveNameMilestone(String pregnancyId, String name) {
    const code = 'name_chosen';
    final existing = _memoryRepository
        .memories(familyId)
        .where(
          (row) =>
              row['milestoneCode'] == code &&
              (row['childIds'] as List).contains(pregnancyId),
        )
        .firstOrNull;
    if (existing != null) {
      _memoryRepository.updateMemory(existing['id'] as String, {
        'body': name,
        'occurredAt': now.toIso8601String(),
      });
      return;
    }
    final milestones =
        (_memoryRepository.catalog()['milestones'] as List? ?? const [])
            .cast<Map>();
    final milestone = milestones
        .where((item) => item['code'] == code)
        .firstOrNull;
    final dueDate = DateTime.tryParse(
      _childRepository.child(pregnancyId)?['dueDate'] as String? ?? '',
    );
    final week = dueDate == null ? null : pregnancyWeek(dueDate, today);
    _memoryRepository.addMemory({
      'familyId': familyId,
      'kind': MemoryKind.milestone.name,
      'body': name,
      'childIds': [pregnancyId],
      'authorId': myUserId,
      'occurredAt': now.toIso8601String(),
      'createdAt': now.toIso8601String(),
      'mediaAssets': <String>[],
      'visibility': MemoryVisibility.parents.name,
      'milestoneCode': code,
      'milestoneTitle': ?milestone?['title'],
      'pregnancyWeek': ?week?.week,
      'pregnancyDay': ?week?.day,
    });
  }

  @override
  Future<BirthDraft> birthDraft(String pregnancyId) async {
    await ready();
    final names = _repository.names(pregnancyId);
    bool bothLike(JsonMap row) => (row['likedByUserIds'] as List).length > 1;
    final chosen =
        names.where((row) => row['chosen'] == true).firstOrNull ??
        names.where(bothLike).firstOrNull;
    final child = _childRepository.child(pregnancyId);
    final draft = _repository.birthDraft(pregnancyId) ?? const {};
    return BirthDraft(
      name: chosen?['name'] as String? ?? '',
      nickname: child?['name'] as String?,
      birthDate: DateTime.tryParse(draft['birthDate'] as String? ?? ''),
      birthTime: draft['birthTime'] as String?,
      gender:
          ChildGender.values
              .where((value) => value.name == draft['gender'])
              .firstOrNull ??
          ChildGender.unknown,
      weightKg: (draft['weightKg'] as num?)?.toDouble(),
      heightCm: (draft['heightCm'] as num?)?.toDouble(),
      samplePhotoAsset: draft['photoAsset'] as String?,
    );
  }

  @override
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
  }) async {
    await ready();
    _childRepository.updateChild(pregnancyId, {
      'name': name.trim(),
      'nickname': ?nickname,
      'avatarAsset': ?avatarAsset,
      'kind': ChildKind.baby.name,
      'birthDate': birthDate.toIso8601String(),
      'gender': gender.name,
      'birthWeightKg': ?weightKg,
      'birthHeightCm': ?heightCm,
      'birthTime': ?birthTime,
    });
    return Child.fromJson(_childRepository.child(pregnancyId)!);
  }

  @override
  Future<void> archive(String pregnancyId, {bool parentsOnly = true}) async {
    await ready();
    _childRepository.updateChild(pregnancyId, {'archived': true});
    if (!parentsOnly) {
      return;
    }
    for (final row in _memoryRepository.memories(familyId)) {
      if ((row['childIds'] as List).contains(pregnancyId)) {
        _memoryRepository.updateMemory(row['id'] as String, {
          'visibility': MemoryVisibility.parents.name,
        });
      }
    }
  }
}
