import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission.freezed.dart';
part 'mission.g.dart';

/// Nhiệm vụ trong bảng ngày (mục 7.13). `hearts` = null với nhiệm vụ của bạn đời (BR-018).
@Freezed(when: FreezedWhenOptions.none)
abstract class Mission with _$Mission {
  @JsonSerializable(explicitToJson: true)
  const factory Mission({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'category')
    @Default(MissionCategory.care)
    MissionCategory category,
    @JsonKey(name: 'hearts') int? hearts,
    @JsonKey(name: 'ownerKind')
    @Default(MissionOwnerKind.me)
    MissionOwnerKind ownerKind,
    @JsonKey(name: 'source')
    @Default(MissionSource.system)
    MissionSource source,
    @JsonKey(name: 'templateId') String? templateId,
    @JsonKey(name: 'childIds') @Default([]) List<String> childIds,
    @JsonKey(name: 'date') required DateTime date,
    @JsonKey(name: 'dueTime') String? dueTime,
    @JsonKey(name: 'durationMin') int? durationMin,
    @JsonKey(name: 'icon') String? icon,
    @JsonKey(name: 'status') @Default(MissionStatus.todo) MissionStatus status,
    @JsonKey(name: 'repeat') @Default(MissionRepeat.none) MissionRepeat repeat,
    @JsonKey(name: 'reminder')
    @Default(MissionReminder.none)
    MissionReminder reminder,
    @JsonKey(name: 'late') @Default(false) bool late,
    @JsonKey(name: 'completedAt') DateTime? completedAt,
    @JsonKey(name: 'thankedByPartner') @Default(false) bool thankedByPartner,
    @JsonKey(name: 'note') String? note,
  }) = _Mission;

  const Mission._();

  factory Mission.fromJson(Map<String, dynamic> json) =>
      _$MissionFromJson(json);

  bool get isDone => status == MissionStatus.done;
}
