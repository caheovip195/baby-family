import 'package:baby_family/data/dto/circle_view.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/circle/circle_post_draft.dart';
import 'package:baby_family/data/model/circle/circle_preferences.dart';
import 'package:baby_family/data/model/family/family.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/model/memory/memory_comment.dart';
import 'package:baby_family/data/repository/child.dart';
import 'package:baby_family/data/repository/family.dart';
import 'package:baby_family/data/repository/memory.dart';
import 'package:baby_family/data/service/circle.dart';
import 'package:baby_family/data/service_imp/child.dart';
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

  // ------------------------------------------------------------ batch 3

  @override
  Future<List<Memory>> firsts(String childId) async {
    final current = await view(childId: childId);
    return [
      for (final memory in current?.memories ?? const <Memory>[])
        if (memory.kind == MemoryKind.milestone) memory,
    ];
  }

  @override
  Future<Memory?> memory(String memoryId) async {
    await ready();
    final row = _memoryRepository.memory(memoryId);
    return row == null
        ? null
        : Memory.fromJson({
            ...row,
            'commentCount': _memoryRepository.comments(memoryId).length,
          });
  }

  @override
  Future<List<MemoryComment>> wishes(String memoryId) async {
    await ready();
    return _memoryRepository
        .comments(memoryId)
        .map(MemoryComment.fromJson)
        .toList();
  }

  @override
  Future<void> toggleHeart(String memoryId) async {
    final current = await memory(memoryId);
    final me = _familyRepository.member(myMemberId);
    if (current == null || me == null) {
      return;
    }
    final name = (me['callName'] as String?) ?? '';
    final names = [...current.reactorNames];
    final hearts = current.reactions['❤️'] ?? 0;
    final liked = names.contains(name);
    liked ? names.remove(name) : names.insert(0, name);
    _memoryRepository.updateMemory(memoryId, {
      'reactorNames': names,
      'reactions': {
        ...current.reactions,
        '❤️': liked ? (hearts - 1).clamp(0, 1 << 20) : hearts + 1,
      },
    });
  }

  @override
  Future<CirclePostDraft> postDraft() async {
    await ready();
    return CirclePostDraft.fromJson(_memoryRepository.circlePostDraft());
  }

  @override
  Future<void> submitPost(CirclePostDraft post) async {
    await ready();
    _memoryRepository.addPendingPost({
      'familyId': familyId,
      'kind': MemoryKind.photo.name,
      'authorId': myUserId,
      'occurredAt': (post.takenAt ?? now).toIso8601String(),
      'createdAt': now.toIso8601String(),
      'childIds': post.childIds,
      'visibility': MemoryVisibility.family.name,
      'body': post.message.trim(),
      'mediaAssets': post.mediaAssets,
      ChildServiceImp.localKey: true,
    });
  }

  @override
  Future<CirclePreferences> preferences() async {
    await ready();
    return CirclePreferences.fromJson(
      _familyRepository.circlePreferences(myUserId),
    );
  }

  @override
  Future<void> savePreferences(CirclePreferences preferences) async {
    await ready();
    _familyRepository.saveCirclePreferences(myUserId, preferences.toJson());
  }

  @override
  Future<void> leaveFamily({bool removeContent = false}) async {
    await ready();
    final memberId = myMemberId;
    if (memberId == null) {
      return;
    }
    _familyRepository.removeMember(memberId);
    sessionRepository.patchSession({
      'memberId': null,
      'familyId': null,
      'role': FamilyRole.relative.name,
    });
  }
}
