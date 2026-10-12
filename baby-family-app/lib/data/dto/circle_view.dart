import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/family.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/memory/memory.dart';

/// Những gì một người thân được thấy (CIR-01): chỉ các bé được cấp quyền,
/// (kể cả thai kỳ được cấp quyền), ký ức `family`; không có Papa & Mama,
/// nhiệm vụ, Hearts.
class CircleView {
  const CircleView({
    required this.family,
    required this.viewer,
    this.children = const [],
    this.memories = const [],
  });

  final Family family;
  final Member viewer;
  final List<Child> children;
  final List<Memory> memories;
}
