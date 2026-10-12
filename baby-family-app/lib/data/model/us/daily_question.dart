import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_question.freezed.dart';
part 'daily_question.g.dart';

/// Câu hỏi kết nối trong ngày (US-01). Câu trả lời của bạn đời chỉ hiện khi cả hai đã trả lời.
@Freezed(when: FreezedWhenOptions.none)
abstract class DailyQuestion with _$DailyQuestion {
  @JsonSerializable(explicitToJson: true)
  const factory DailyQuestion({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'date') required DateTime date,
    @JsonKey(name: 'text') required String text,
    @JsonKey(name: 'myAnswer') String? myAnswer,
    @JsonKey(name: 'partnerAnswer') String? partnerAnswer,
    @JsonKey(name: 'partnerAnswered') @Default(false) bool partnerAnswered,
  }) = _DailyQuestion;

  factory DailyQuestion.fromJson(Map<String, dynamic> json) =>
      _$DailyQuestionFromJson(json);
}
