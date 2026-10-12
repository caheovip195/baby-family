import 'package:baby_family/data/model/session/pending_invite.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_session.freezed.dart';
part 'app_session.g.dart';

/// Phiên hiện tại (mock: MockStore, thật: `GET /v1/me` + family state).
@Freezed(when: FreezedWhenOptions.none)
abstract class AppSession with _$AppSession {
  @JsonSerializable(explicitToJson: true)
  const factory AppSession({
    @JsonKey(name: 'state') @Default(SessionState.signedOut) SessionState state,
    @JsonKey(name: 'userId') String? userId,
    @JsonKey(name: 'familyId') String? familyId,
    @JsonKey(name: 'memberId') String? memberId,
    @JsonKey(name: 'role') FamilyRole? role,
    @JsonKey(name: 'callName') String? callName,
    @JsonKey(name: 'authMethod') AuthMethod? authMethod,
    @JsonKey(name: 'phone') String? phone,
    @JsonKey(name: 'stage') FamilyStage? stage,
    @JsonKey(name: 'pendingInvite') PendingInvite? pendingInvite,
  }) = _AppSession;

  factory AppSession.fromJson(Map<String, dynamic> json) =>
      _$AppSessionFromJson(json);
}
