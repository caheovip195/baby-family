import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_device.freezed.dart';
part 'login_device.g.dart';

/// Thiết bị đang đăng nhập (SET-07).
@Freezed(when: FreezedWhenOptions.none)
abstract class LoginDevice with _$LoginDevice {
  @JsonSerializable(explicitToJson: true)
  const factory LoginDevice({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'kind') @Default(DeviceKind.phone) DeviceKind kind,
    @JsonKey(name: 'location') @Default('') String location,
    @JsonKey(name: 'lastActiveAt') DateTime? lastActiveAt,
    @JsonKey(name: 'current') @Default(false) bool current,
  }) = _LoginDevice;

  factory LoginDevice.fromJson(Map<String, dynamic> json) =>
      _$LoginDeviceFromJson(json);
}
