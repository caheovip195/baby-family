import 'package:freezed_annotation/freezed_annotation.dart';

part 'timezone_catalog.freezed.dart';
part 'timezone_catalog.g.dart';

/// `GET /v1/catalog/timezones`: danh mục múi giờ IANA có version, nhãn theo
/// ngôn ngữ (FAM-07).
@Freezed(when: FreezedWhenOptions.none)
abstract class TimezoneCatalog with _$TimezoneCatalog {
  @JsonSerializable(explicitToJson: true)
  const factory TimezoneCatalog({
    @JsonKey(name: 'version') String? version,
    @JsonKey(name: 'items')
    @Default(<TimezoneOption>[])
    List<TimezoneOption> items,
  }) = _TimezoneCatalog;

  factory TimezoneCatalog.fromJson(Map<String, dynamic> json) =>
      _$TimezoneCatalogFromJson(json);
}

@Freezed(when: FreezedWhenOptions.none)
abstract class TimezoneOption with _$TimezoneOption {
  @JsonSerializable(explicitToJson: true)
  const factory TimezoneOption({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'label') @Default('') String label,
    @JsonKey(name: 'offsetMinutes') @Default(0) int offsetMinutes,
  }) = _TimezoneOption;

  factory TimezoneOption.fromJson(Map<String, dynamic> json) =>
      _$TimezoneOptionFromJson(json);
}
