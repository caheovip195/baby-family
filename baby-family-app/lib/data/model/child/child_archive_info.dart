import 'package:freezed_annotation/freezed_annotation.dart';

part 'child_archive_info.freezed.dart';
part 'child_archive_info.g.dart';

/// CHD-05: tác động khi lưu trữ / xoá vĩnh viễn một bé.
@Freezed(when: FreezedWhenOptions.none)
abstract class ChildArchiveInfo with _$ChildArchiveInfo {
  @JsonSerializable(explicitToJson: true)
  const factory ChildArchiveInfo({
    @JsonKey(name: 'childId') required String childId,
    @JsonKey(name: 'addedByUserId') String? addedByUserId,
    @JsonKey(name: 'addedAt') DateTime? addedAt,
    @JsonKey(name: 'duplicateOfChildId') String? duplicateOfChildId,
    @JsonKey(name: 'privateMemoryCount') @Default(0) int privateMemoryCount,
    @JsonKey(name: 'sharedMemoryCount') @Default(0) int sharedMemoryCount,
    @JsonKey(name: 'sharedWithChildIds')
    @Default([])
    List<String> sharedWithChildIds,
    @JsonKey(name: 'archivedAt') DateTime? archivedAt,
    @JsonKey(name: 'deletableFrom') DateTime? deletableFrom,
  }) = _ChildArchiveInfo;

  const ChildArchiveInfo._();

  factory ChildArchiveInfo.fromJson(Map<String, dynamic> json) =>
      _$ChildArchiveInfoFromJson(json);

  bool get canDelete => deletableFrom != null;
}
