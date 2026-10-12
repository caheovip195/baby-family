import 'package:freezed_annotation/freezed_annotation.dart';

part 'storage_usage.freezed.dart';
part 'storage_usage.g.dart';

/// Dung lượng theo loại (SUB-03).
@Freezed(when: FreezedWhenOptions.none)
abstract class StorageUsage with _$StorageUsage {
  @JsonSerializable(explicitToJson: true)
  const factory StorageUsage({
    @JsonKey(name: 'kind') required String kind,
    @JsonKey(name: 'usedMb') @Default(0) int usedMb,
  }) = _StorageUsage;

  factory StorageUsage.fromJson(Map<String, dynamic> json) =>
      _$StorageUsageFromJson(json);
}
