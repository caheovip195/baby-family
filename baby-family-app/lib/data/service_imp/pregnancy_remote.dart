import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/pregnancy/prep_item.dart';
import 'package:baby_family/data/model/pregnancy/prep_summary.dart';
import 'package:baby_family/data/repository/child.dart';
import 'package:baby_family/data/repository/family.dart';
import 'package:baby_family/data/repository/memory.dart';
import 'package:baby_family/data/repository/pregnancy.dart';
import 'package:baby_family/data/repository/pregnancy_remote.dart';
import 'package:baby_family/data/repository/session.dart';
import 'package:baby_family/data/repository/us.dart';
import 'package:baby_family/data/service_imp/pregnancy.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/helper/app_clock.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

/// PREG-04/05/06 qua server (BF-20261019-001):
/// - Chuẩn bị đón bé: danh sách trên server (lần đầu server thêm mục mặc định),
///   phản chiếu vào kho trên máy với id của server; người phụ trách / “Đã nhờ”
///   vẫn chỉ trên máy.
/// - Bé chào đời: `POST /pregnancies/:id/birth` (Idempotency-Key giữ nguyên khi
///   thử lại); server tạo bé mới và chuyển ký ức thai kỳ sang bé.
/// - Lưu trữ: “chỉ Papa & Mama” → `ENDED_PRIVATE` (ẩn khỏi người thân ngay),
///   ngược lại `ARCHIVED`.
/// Đặt tên (PREG-07, bản 1.1) vẫn trên máy.
class PregnancyRemoteServiceImp extends PregnancyServiceImp {
  PregnancyRemoteServiceImp(
    ISessionRepository sessionRepository,
    AppClock clock,
    this._store,
    this._children,
    IFamilyRepository familyRepository,
    this._memories,
    IUsRepository usRepository,
    this._remote,
  ) : super(
        sessionRepository,
        clock,
        _store,
        _children,
        familyRepository,
        _memories,
        usRepository,
      );

  final IPregnancyRepository _store;
  final IChildRepository _children;
  final IMemoryRepository _memories;
  final IPregnancyRemoteRepository _remote;

  /// Khoá chống trùng của lần chuyển đang chờ, theo thai kỳ.
  final _birthKeys = <String, String>{};

  static final _day = DateFormat('yyyy-MM-dd');

  bool get _remoteOn =>
      sessionRepository.session()[kValueSessionKeyServerFamilyId] != null;

  @override
  Future<PrepSummary> prep(String pregnancyId) async {
    if (!_remoteOn) {
      return super.prep(pregnancyId);
    }
    await ready();
    final existing = {
      for (final row in _store.prepItems(pregnancyId)) row['id']: row,
    };
    final groups = await _remote.prepItems(pregnancyId);
    final items = <PrepItem>[];
    for (final group in groups) {
      for (final record in group.items) {
        final id = record.id;
        if (id == null) {
          continue;
        }
        final fields = {
          'group': (_groups[record.groupCode] ?? PrepGroup.bag).name,
          'title': record.title ?? '',
          'done': record.done,
        };
        final row = existing[id];
        if (row == null) {
          _store.addPrepItem({
            'id': id,
            'familyId': familyId,
            'pregnancyId': pregnancyId,
            ...fields,
            'together': true,
            'requestedFromPartner': false,
          });
        } else if (fields.entries.any((e) => row[e.key] != e.value)) {
          _store.updatePrepItem(id, fields);
        }
        final local = {...?existing[id], ...fields};
        items.add(
          PrepItem.fromJson({
            'id': id,
            'pregnancyId': pregnancyId,
            ...local,
            'ownerKind': local['together'] == true
                ? MissionOwnerKind.together.name
                : MissionOwnerKind.me.name,
          }),
        );
      }
    }
    return PrepSummary(
      done: items.where((item) => item.done).length,
      total: items.length,
      items: items,
    );
  }

  @override
  Future<void> togglePrep(String itemId) async {
    if (!_remoteOn) {
      return super.togglePrep(itemId);
    }
    final row = _findPrepRow(itemId);
    final done = row?['done'] != true;
    await _remote.updatePrep(itemId, {'done': done});
    await super.togglePrep(itemId);
  }

  @override
  Future<void> addPrep(
    String pregnancyId, {
    required String title,
    PrepGroup group = PrepGroup.bag,
    MissionOwnerKind ownerKind = MissionOwnerKind.me,
  }) async {
    if (!_remoteOn) {
      return super.addPrep(
        pregnancyId,
        title: title,
        group: group,
        ownerKind: ownerKind,
      );
    }
    final record = await _remote.createPrep(
      pregnancyId,
      groupCode: _groupCodes[group]!,
      title: title.trim(),
    );
    final id = record?.id;
    if (id == null) {
      return;
    }
    _store.addPrepItem({
      'id': id,
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
    if (!_remoteOn) {
      return super.convertToBaby(
        pregnancyId,
        name: name,
        birthDate: birthDate,
        nickname: nickname,
        avatarAsset: avatarAsset,
        gender: gender,
        weightKg: weightKg,
        heightCm: heightCm,
        birthTime: birthTime,
      );
    }
    await ready();
    final key = _birthKeys[pregnancyId] ??= const Uuid().v4();
    final result = await _remote.convert(pregnancyId, key, {
      'children': [
        {
          'name': name.trim(),
          if (nickname != null && nickname.trim().isNotEmpty)
            'nickname': nickname.trim(),
          'gender': switch (gender) {
            ChildGender.boy => 'MALE',
            ChildGender.girl => 'FEMALE',
            ChildGender.unknown => 'UNSPECIFIED',
          },
          'birthDate': _day.format(birthDate),
          if (birthTime != null && birthTime.isNotEmpty) 'birthTime': birthTime,
          if (weightKg != null || heightCm != null)
            'birthStats': {
              if (weightKg != null) 'weightG': (weightKg * 1000).round(),
              'lengthCm': ?heightCm,
            },
        },
      ],
    });
    _birthKeys.remove(pregnancyId);
    final childId = result?.children.firstOrNull?.id;
    if (childId == null) {
      throw StateError('Birth conversion without child');
    }
    final pregnancy = _children.child(pregnancyId);
    _children.addChild({
      'id': childId,
      'familyId': familyId,
      'name': name.trim(),
      'nickname': ?nickname,
      'kind': ChildKind.baby.name,
      'birthDate': birthDate.toIso8601String(),
      'gender': gender.name,
      'colorIndex': pregnancy?['colorIndex'] ?? 0,
      'avatarAsset': ?avatarAsset,
      'birthWeightKg': ?weightKg,
      'birthHeightCm': ?heightCm,
      'birthTime': ?birthTime,
    });
    // Thai kỳ đã thành bé: ẩn khỏi danh sách, ký ức thai kỳ thành chương đầu
    // của bé (server đã chuyển liên kết).
    _children.updateChild(pregnancyId, {'archived': true});
    for (final row in _memories.memories(familyId)) {
      final ids = (row['childIds'] as List).cast<String>();
      if (ids.contains(pregnancyId)) {
        _memories.updateMemory(row['id'] as String, {
          'childIds': [for (final id in ids) id == pregnancyId ? childId : id],
        });
      }
    }
    return Child.fromJson(_children.child(childId)!);
  }

  @override
  Future<void> archive(String pregnancyId, {bool parentsOnly = true}) async {
    if (_remoteOn) {
      await _remote.archive(
        pregnancyId,
        parentsOnly ? 'ENDED_PRIVATE' : 'ARCHIVED',
      );
    }
    await super.archive(pregnancyId, parentsOnly: parentsOnly);
  }

  Map<String, dynamic>? _findPrepRow(String itemId) {
    for (final child in _children.children(familyId)) {
      for (final row in _store.prepItems(child['id'] as String)) {
        if (row['id'] == itemId) {
          return row;
        }
      }
    }
    return null;
  }

  static const _groupCodes = {
    PrepGroup.bag: 'HOSPITAL_BAG',
    PrepGroup.papers: 'PAPERS',
    PrepGroup.nursery: 'NURSERY',
    PrepGroup.health: 'HEALTH',
  };

  static final _groups = {
    for (final entry in _groupCodes.entries) entry.value: entry.key,
  };
}
