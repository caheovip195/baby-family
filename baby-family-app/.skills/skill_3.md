# Skill 3: Flutter Data Model Rules

## Goal
All data models must follow the project's Freezed model convention.

## Rules

- All model files must be placed under the `data/model` directory.
- Each model must be defined in its own separate file.
- Never put multiple models in the same file.
- Never create plain Dart model classes manually.
- Every model must use:
    - `freezed`
    - `json_serializable`
    - `freezed_annotation`
- Every model must include:
    - `.freezed.dart` part file
    - `.g.dart` part file
    - `fromJson`
    - `@JsonSerializable(explicitToJson: true)`
    - `@JsonKey(name: '...')` ghi rõ tên field theo API (API Baby Family dùng **camelCase** — tài liệu kỹ thuật 11.1)
    - `@Freezed(when: FreezedWhenOptions.none)`

## Required Pattern

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'action.freezed.dart';
part 'action.g.dart';

@Freezed(when: FreezedWhenOptions.none)
abstract class Action with _$Action {
  @JsonSerializable(explicitToJson: true)
  const factory Action({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
  }) = _Action;

  factory Action.fromJson(Map<String, dynamic> json) =>
      _$ActionFromJson(json);
}