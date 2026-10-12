import 'package:baby_family/data/model/us/rewrite_option.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'rewrite_suggestion.freezed.dart';
part 'rewrite_suggestion.g.dart';

/// US-09 “Viết lại nhẹ nhàng” — câu gốc + 3 gợi ý AI.
@Freezed(when: FreezedWhenOptions.none)
abstract class RewriteSuggestion with _$RewriteSuggestion {
  @JsonSerializable(explicitToJson: true)
  const factory RewriteSuggestion({
    @JsonKey(name: 'original') required String original,
    @JsonKey(name: 'options') @Default([]) List<RewriteOption> options,
    @JsonKey(name: 'selected')
    @Default(RewriteTone.neutral)
    RewriteTone selected,
    @JsonKey(name: 'edited') String? edited,
  }) = _RewriteSuggestion;

  factory RewriteSuggestion.fromJson(Map<String, dynamic> json) =>
      _$RewriteSuggestionFromJson(json);
}
