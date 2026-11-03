import 'package:freezed_annotation/freezed_annotation.dart';

part 'couple_question_record.freezed.dart';
part 'couple_question_record.g.dart';

/// Câu hỏi kết nối hôm nay (`GET /families/{fid}/us/question/today`):
/// câu trả lời của bạn đời chỉ có khi cả hai đã trả lời (BF-20261027-002).
@Freezed(when: FreezedWhenOptions.none)
abstract class CoupleQuestionRecord with _$CoupleQuestionRecord {
  @JsonSerializable(explicitToJson: true)
  const factory CoupleQuestionRecord({
    @JsonKey(name: 'date') String? date,
    @JsonKey(name: 'code') String? code,
    @JsonKey(name: 'textI18n')
    @Default(<String, String>{})
    Map<String, String> textI18n,
    @JsonKey(name: 'myAnswer') String? myAnswer,
    @JsonKey(name: 'partnerAnswered') @Default(false) bool partnerAnswered,
    @JsonKey(name: 'partnerAnswer') String? partnerAnswer,
  }) = _CoupleQuestionRecord;

  factory CoupleQuestionRecord.fromJson(Map<String, dynamic> json) =>
      _$CoupleQuestionRecordFromJson(json);
}

/// US-14 Tuần của hai ta (`GET /families/{fid}/us/week`): không điểm, không
/// chia theo người.
@Freezed(when: FreezedWhenOptions.none)
abstract class CoupleWeekRecord with _$CoupleWeekRecord {
  @JsonSerializable(explicitToJson: true)
  const factory CoupleWeekRecord({
    @JsonKey(name: 'weekStart') String? weekStart,
    @JsonKey(name: 'weekEnd') String? weekEnd,
    @JsonKey(name: 'checkins') @Default(0) int checkins,
    @JsonKey(name: 'requestsHelped') @Default(0) int requestsHelped,
    @JsonKey(name: 'thanks') @Default(0) int thanks,
    @JsonKey(name: 'togetherMissions') @Default(0) int togetherMissions,
    @JsonKey(name: 'together')
    @Default(<CoupleWeekTogetherRecord>[])
    List<CoupleWeekTogetherRecord> together,
  }) = _CoupleWeekRecord;

  factory CoupleWeekRecord.fromJson(Map<String, dynamic> json) =>
      _$CoupleWeekRecordFromJson(json);
}

@Freezed(when: FreezedWhenOptions.none)
abstract class CoupleWeekTogetherRecord with _$CoupleWeekTogetherRecord {
  @JsonSerializable(explicitToJson: true)
  const factory CoupleWeekTogetherRecord({
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'date') DateTime? date,
  }) = _CoupleWeekTogetherRecord;

  factory CoupleWeekTogetherRecord.fromJson(Map<String, dynamic> json) =>
      _$CoupleWeekTogetherRecordFromJson(json);
}
