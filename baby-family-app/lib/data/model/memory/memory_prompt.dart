import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'memory_prompt.freezed.dart';
part 'memory_prompt.g.dart';

/// Gợi ý ghi lại (HOME-01, BR-073: tối đa 1/ngày/Parent).
@Freezed(when: FreezedWhenOptions.none)
abstract class MemoryPrompt with _$MemoryPrompt {
  @JsonSerializable(explicitToJson: true)
  const factory MemoryPrompt({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'childId') String? childId,
    @JsonKey(name: 'kind') @Default(MemoryKind.quote) MemoryKind kind,
    @JsonKey(name: 'text') required String text,
  }) = _MemoryPrompt;

  factory MemoryPrompt.fromJson(Map<String, dynamic> json) =>
      _$MemoryPromptFromJson(json);
}
