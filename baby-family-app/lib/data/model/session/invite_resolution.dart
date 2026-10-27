import 'package:baby_family/data/model/circle/circle_subject_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'invite_resolution.freezed.dart';
part 'invite_resolution.g.dart';

/// `POST /v1/invites/resolve` — chỉ thông tin xem trước (INV-01/05).
@Freezed(when: FreezedWhenOptions.none)
abstract class InviteResolution with _$InviteResolution {
  @JsonSerializable(explicitToJson: true)
  const factory InviteResolution({
    @JsonKey(name: 'inviteId') String? inviteId,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'state') String? state,
    @JsonKey(name: 'familyName') String? familyName,
    @JsonKey(name: 'inviterCallName') String? inviterCallName,
    @JsonKey(name: 'inviterKind') String? inviterKind,
    @JsonKey(name: 'proposedKind') String? proposedKind,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'expiresAt') DateTime? expiresAt,

    /// Lời mời CIRCLE: quan hệ + chỉ bé/thai kỳ được cấp quyền (kèm quyền
    /// xem/tải ảnh từng bé) + tên gọi Bố/Mẹ đặt cho người được mời
    /// (BF-20261026-006).
    @JsonKey(name: 'relation') String? relation,
    @JsonKey(name: 'displayName') String? displayName,
    @JsonKey(name: 'children')
    @Default(<CircleSubjectRecord>[])
    List<CircleSubjectRecord> children,
  }) = _InviteResolution;

  factory InviteResolution.fromJson(Map<String, dynamic> json) =>
      _$InviteResolutionFromJson(json);
}
