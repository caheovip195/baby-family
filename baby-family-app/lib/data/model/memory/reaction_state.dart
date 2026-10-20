import 'package:freezed_annotation/freezed_annotation.dart';

part 'reaction_state.freezed.dart';
part 'reaction_state.g.dart';

/// Cảm xúc của một ký ức sau khi thả/bỏ (`PUT|DELETE /v1/memories/{id}/reaction`).
/// Khoá của [reactions] là loại server (`LOVE`, `CUTE`, `HAHA`, `TOUCHED`, `CLAP`).
@Freezed(when: FreezedWhenOptions.none)
abstract class ReactionState with _$ReactionState {
  @JsonSerializable(explicitToJson: true)
  const factory ReactionState({
    @JsonKey(name: 'memoryId') String? memoryId,
    @JsonKey(name: 'reactions')
    @Default(<String, int>{})
    Map<String, int> reactions,
    @JsonKey(name: 'myReaction') String? myReaction,
    @JsonKey(name: 'reactionCount') @Default(0) int reactionCount,
  }) = _ReactionState;

  factory ReactionState.fromJson(Map<String, dynamic> json) =>
      _$ReactionStateFromJson(json);
}
