import 'package:freezed_annotation/freezed_annotation.dart';

part 'bootstrap_subject.freezed.dart';
part 'bootstrap_subject.g.dart';

/// Bé / thai kỳ trong bootstrap (`subjects`, tài liệu kỹ thuật 11.4) — nguồn sự
/// thật của danh sách bé khi mở app ở chế độ server.
@Freezed(when: FreezedWhenOptions.none)
abstract class BootstrapSubject with _$BootstrapSubject {
  @JsonSerializable(explicitToJson: true)
  const factory BootstrapSubject({
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'displayName') String? displayName,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'nickname') String? nickname,
    @JsonKey(name: 'birthDate') DateTime? birthDate,
    @JsonKey(name: 'dueDate') DateTime? dueDate,
    @JsonKey(name: 'colorIndex') int? colorIndex,
    @JsonKey(name: 'gender') String? gender,
    @JsonKey(name: 'expectedCount') int? expectedCount,
    @JsonKey(name: 'seqNo') int? seqNo,
    @JsonKey(name: 'status') String? status,

    /// URL ký ngắn hạn của ảnh đại diện / ảnh bìa bé (null khi chưa có).
    @JsonKey(name: 'avatarUrl') String? avatarUrl,
    @JsonKey(name: 'coverUrl') String? coverUrl,
  }) = _BootstrapSubject;

  factory BootstrapSubject.fromJson(Map<String, dynamic> json) =>
      _$BootstrapSubjectFromJson(json);
}
