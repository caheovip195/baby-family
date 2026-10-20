import 'package:freezed_annotation/freezed_annotation.dart';

part 'deletion_preview_record.freezed.dart';
part 'deletion_preview_record.g.dart';

/// `GET /me/deletion-preview` (SET-09): lựa chọn cho gia đình và thời gian chờ.
@Freezed(when: FreezedWhenOptions.none)
abstract class DeletionPreviewRecord with _$DeletionPreviewRecord {
  @JsonSerializable(explicitToJson: true)
  const factory DeletionPreviewRecord({
    @JsonKey(name: 'graceDays') int? graceDays,
    @JsonKey(name: 'familyId') String? familyId,
    @JsonKey(name: 'familyChoices')
    @Default(<String>[])
    List<String> familyChoices,
    @JsonKey(name: 'familyAfterDeletion') String? familyAfterDeletion,
    @JsonKey(name: 'isPayer') @Default(false) bool isPayer,
  }) = _DeletionPreviewRecord;

  factory DeletionPreviewRecord.fromJson(Map<String, dynamic> json) =>
      _$DeletionPreviewRecordFromJson(json);
}
