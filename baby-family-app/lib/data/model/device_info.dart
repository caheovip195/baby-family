import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_info.freezed.dart';
part 'device_info.g.dart';

/// Thông tin thiết bị gửi kèm `POST /v1/me/devices` và header `X-Device-Id`.
@Freezed(when: FreezedWhenOptions.none)
abstract class DeviceInfo with _$DeviceInfo {
  @JsonSerializable(explicitToJson: true)
  const factory DeviceInfo({
    @JsonKey(name: 'deviceId') String? deviceId,
    @JsonKey(name: 'platform') DeviceType? deviceType,
    @JsonKey(name: 'osVersion') String? osVersion,
    @JsonKey(name: 'deviceModel') String? deviceModel,
    @JsonKey(name: 'appVersion') String? appVersion,
    @JsonKey(name: 'manufacturer') String? manufacturer,
    @JsonKey(name: 'sdkInt') int? sdkInt,
  }) = _DeviceInfo;

  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoFromJson(json);
}
