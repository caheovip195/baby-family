import 'package:freezed_annotation/freezed_annotation.dart';

part 'help_center_record.freezed.dart';
part 'help_center_record.g.dart';

/// `GET /v1/support/help-center`: câu hỏi thường gặp (có version) + liên hệ và
/// đường dẫn pháp lý (null khi server chưa cấu hình).
@Freezed(when: FreezedWhenOptions.none)
abstract class HelpCenterRecord with _$HelpCenterRecord {
  @JsonSerializable(explicitToJson: true)
  const factory HelpCenterRecord({
    @JsonKey(name: 'version') int? version,
    @JsonKey(name: 'faqs') @Default(<HelpFaqRecord>[]) List<HelpFaqRecord> faqs,
    @JsonKey(name: 'contact') HelpContactRecord? contact,
    @JsonKey(name: 'legal') HelpLegalRecord? legal,
  }) = _HelpCenterRecord;

  factory HelpCenterRecord.fromJson(Map<String, dynamic> json) =>
      _$HelpCenterRecordFromJson(json);
}

@Freezed(when: FreezedWhenOptions.none)
abstract class HelpFaqRecord with _$HelpFaqRecord {
  @JsonSerializable(explicitToJson: true)
  const factory HelpFaqRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'question') @Default('') String question,
    @JsonKey(name: 'answer') @Default('') String answer,
  }) = _HelpFaqRecord;

  factory HelpFaqRecord.fromJson(Map<String, dynamic> json) =>
      _$HelpFaqRecordFromJson(json);
}

@Freezed(when: FreezedWhenOptions.none)
abstract class HelpContactRecord with _$HelpContactRecord {
  @JsonSerializable(explicitToJson: true)
  const factory HelpContactRecord({
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'hotline') String? hotline,
  }) = _HelpContactRecord;

  factory HelpContactRecord.fromJson(Map<String, dynamic> json) =>
      _$HelpContactRecordFromJson(json);
}

@Freezed(when: FreezedWhenOptions.none)
abstract class HelpLegalRecord with _$HelpLegalRecord {
  @JsonSerializable(explicitToJson: true)
  const factory HelpLegalRecord({
    @JsonKey(name: 'termsUrl') String? termsUrl,
    @JsonKey(name: 'privacyUrl') String? privacyUrl,
    @JsonKey(name: 'licensesUrl') String? licensesUrl,
  }) = _HelpLegalRecord;

  factory HelpLegalRecord.fromJson(Map<String, dynamic> json) =>
      _$HelpLegalRecordFromJson(json);
}
