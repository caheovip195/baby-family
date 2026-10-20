import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_dispatch.freezed.dart';
part 'otp_dispatch.g.dart';

/// `POST /v1/auth/phone/otp` (tài liệu kỹ thuật 5.3).
@Freezed(when: FreezedWhenOptions.none)
abstract class OtpDispatch with _$OtpDispatch {
  @JsonSerializable(explicitToJson: true)
  const factory OtpDispatch({
    @JsonKey(name: 'expiresIn') int? expiresIn,
    @JsonKey(name: 'resendIn') int? resendIn,
    @JsonKey(name: 'channelUsed') String? channelUsed,
  }) = _OtpDispatch;

  factory OtpDispatch.fromJson(Map<String, dynamic> json) =>
      _$OtpDispatchFromJson(json);
}
