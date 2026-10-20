import 'package:baby_family/data/model/session/bootstrap_entitlement.dart';
import 'package:baby_family/data/model/session/bootstrap_family.dart';
import 'package:baby_family/data/model/session/bootstrap_parent.dart';
import 'package:baby_family/data/model/session/bootstrap_subject.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_bootstrap.freezed.dart';
part 'family_bootstrap.g.dart';

/// `GET /v1/families/{fid}/bootstrap` (tài liệu kỹ thuật 11.4), phần app đang dùng.
@Freezed(when: FreezedWhenOptions.none)
abstract class FamilyBootstrap with _$FamilyBootstrap {
  @JsonSerializable(explicitToJson: true)
  const factory FamilyBootstrap({
    @JsonKey(name: 'family') BootstrapFamily? family,
    @JsonKey(name: 'me') BootstrapParent? me,
    @JsonKey(name: 'parents')
    @Default(<BootstrapParent>[])
    List<BootstrapParent> parents,
    @JsonKey(name: 'coupleLinked') @Default(false) bool coupleLinked,
    @JsonKey(name: 'subjects')
    @Default(<BootstrapSubject>[])
    List<BootstrapSubject> subjects,
    @JsonKey(name: 'entitlement') BootstrapEntitlement? entitlement,
    @JsonKey(name: 'accessVersion') int? accessVersion,
  }) = _FamilyBootstrap;

  factory FamilyBootstrap.fromJson(Map<String, dynamic> json) =>
      _$FamilyBootstrapFromJson(json);
}
