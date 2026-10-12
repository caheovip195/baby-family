import 'package:freezed_annotation/freezed_annotation.dart';

part 'bridge_share.freezed.dart';
part 'bridge_share.g.dart';

/// Những gì một người chọn chia sẻ trong phiên Cầu nối (US-10/11).
@Freezed(when: FreezedWhenOptions.none)
abstract class BridgeShare with _$BridgeShare {
  @JsonSerializable(explicitToJson: true)
  const factory BridgeShare({
    @JsonKey(name: 'userId') required String userId,
    @JsonKey(name: 'feelings') @Default([]) List<String> feelings,
    @JsonKey(name: 'needs') @Default([]) List<String> needs,
    @JsonKey(name: 'topic') String? topic,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'understood') @Default(false) bool understood,
    @JsonKey(name: 'readDone') @Default(false) bool readDone,
  }) = _BridgeShare;

  factory BridgeShare.fromJson(Map<String, dynamic> json) =>
      _$BridgeShareFromJson(json);
}
