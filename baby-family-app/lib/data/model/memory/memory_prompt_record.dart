import 'package:freezed_annotation/freezed_annotation.dart';

part 'memory_prompt_record.freezed.dart';
part 'memory_prompt_record.g.dart';

/// Gợi ý ghi lại theo tuổi bé (`textI18n` theo ngôn ngữ).
@Freezed(when: FreezedWhenOptions.none)
abstract class MemoryPromptRecord with _$MemoryPromptRecord {
  @JsonSerializable(explicitToJson: true)
  const factory MemoryPromptRecord({
    @JsonKey(name: 'code') String? code,
    @JsonKey(name: 'targetKind') String? targetKind,
    @JsonKey(name: 'textI18n')
    @Default(<String, dynamic>{})
    Map<String, dynamic> textI18n,
    @JsonKey(name: 'childId') String? childId,
  }) = _MemoryPromptRecord;

  factory MemoryPromptRecord.fromJson(Map<String, dynamic> json) =>
      _$MemoryPromptRecordFromJson(json);
}
