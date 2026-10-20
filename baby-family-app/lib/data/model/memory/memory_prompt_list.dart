import 'package:baby_family/data/model/memory/memory_prompt_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'memory_prompt_list.freezed.dart';
part 'memory_prompt_list.g.dart';

/// `{items: [...]}` của `GET /families/:fid/memory-prompts`.
@Freezed(when: FreezedWhenOptions.none)
abstract class MemoryPromptList with _$MemoryPromptList {
  @JsonSerializable(explicitToJson: true)
  const factory MemoryPromptList({
    @JsonKey(name: 'items')
    @Default(<MemoryPromptRecord>[])
    List<MemoryPromptRecord> items,
  }) = _MemoryPromptList;

  factory MemoryPromptList.fromJson(Map<String, dynamic> json) =>
      _$MemoryPromptListFromJson(json);
}
