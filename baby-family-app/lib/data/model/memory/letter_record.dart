import 'package:freezed_annotation/freezed_annotation.dart';

part 'letter_record.freezed.dart';
part 'letter_record.g.dart';

/// Thư gửi con (MEM-14): người khác chỉ thấy phong bì khi còn niêm phong.
@Freezed(when: FreezedWhenOptions.none)
abstract class LetterRecord with _$LetterRecord {
  @JsonSerializable(explicitToJson: true)
  const factory LetterRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'sealed') @Default(false) bool sealed,
    @JsonKey(name: 'unlockAt') DateTime? unlockAt,
    @JsonKey(name: 'authorUserId') String? authorUserId,
  }) = _LetterRecord;

  factory LetterRecord.fromJson(Map<String, dynamic> json) =>
      _$LetterRecordFromJson(json);
}
