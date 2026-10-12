import 'package:baby_family/data/dto/circle_view.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/family.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/model/memory/memory_comment.dart';
import 'package:baby_family/data/repository/child.dart';
import 'package:baby_family/data/repository/family.dart';
import 'package:baby_family/data/repository/memory.dart';
import 'package:baby_family/data/service/circle.dart';
import 'package:baby_family/data/service_imp/mock_service.dart';
import 'package:baby_family/utils/constants/enum.dart';

class CircleServiceImp extends MockServiceImp implements ICircleService {
  CircleServiceImp(
    super.sessionRepository,
    super.clock,
    this._familyRepository,
    this._childRepository,
    this._memoryRepository,
  );

  final IFamilyRepository _familyRepository;
  final IChildRepository _childRepository;
  final IMemoryRepository _memoryRepository;

  @override
  Future<CircleView?> view({String? childId}) async {
    await ready();
    final familyRow = _familyRepository.family(familyId);
    final memberRow = _familyRepository.member(myMemberId);
    if (familyRow == null || memberRow == null) {
      return null;
    }
    final viewer = Member.fromJson(memberRow);
    final granted = viewer.role.isParent
        ? null
        : viewer.grantedChildIds.toSet();
    final children = [
      for (final row in _childRepository.children(familyId))
        // Thai kỳ chỉ hiện khi Papa/Mama đã cấp quyền (FAM-03 “Bơ (thai kỳ)”).
        if (row['archived'] != true &&
            (granted == null
                ? row['kind'] == ChildKind.baby.name
                : granted.contains(row['id'])))
          Child.fromJson(row),
    ];
    final visibleIds = {
      for (final child in children)
        if (childId == null || child.id == childId) child.id,
    };
    final memories = [
      for (final row in _memoryRepository.memories(familyId))
        if (row['visibility'] == MemoryVisibility.family.name &&
            (row['childIds'] as List).isNotEmpty &&
            (row['childIds'] as List).every(
              (id) => granted == null || granted.contains(id),
            ) &&
            (row['childIds'] as List).any(visibleIds.contains))
          Memory.fromJson({
            ...row,
            'commentCount': _memoryRepository
                .comments(row['id'] as String)
                .length,
          }),
    ]..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    return CircleView(
      family: Family.fromJson(familyRow),
      viewer: viewer,
      children: children,
      memories: memories,
    );
  }

  @override
  Future<MemoryComment?> sendWish(String memoryId, String body) async {
    await ready();
    final member = _familyRepository.member(myMemberId);
    if (member == null || member['canComment'] == false) {
      return null;
    }
    return MemoryComment.fromJson(
      _memoryRepository.addComment({
        'memoryId': memoryId,
        'authorId': myUserId,
        'authorName': member['callName'] ?? member['displayName'] ?? '',
        'authorRole': member['role'],
        'body': body.trim(),
        'createdAt': now.toIso8601String(),
      }),
    );
  }
}
