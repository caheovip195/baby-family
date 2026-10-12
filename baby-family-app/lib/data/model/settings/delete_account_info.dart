import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_account_info.freezed.dart';
part 'delete_account_info.g.dart';

/// Dữ liệu cho luồng xoá tài khoản (SET-09/09b/09c).
@Freezed(when: FreezedWhenOptions.none)
abstract class DeleteAccountInfo with _$DeleteAccountInfo {
  @JsonSerializable(explicitToJson: true)
  const factory DeleteAccountInfo({
    @JsonKey(name: 'userName') @Default('') String userName,
    @JsonKey(name: 'partnerName') String? partnerName,
    @JsonKey(name: 'partnerCallName') String? partnerCallName,
    @JsonKey(name: 'familyName') @Default('') String familyName,
    @JsonKey(name: 'childNames') @Default([]) List<String> childNames,
    @JsonKey(name: 'postedMemories') @Default(0) int postedMemories,
    @JsonKey(name: 'onlyParent') @Default(false) bool onlyParent,
    @JsonKey(name: 'maskedAppleAccount') String? maskedAppleAccount,
    @JsonKey(name: 'maskedPhone') String? maskedPhone,
    @JsonKey(name: 'purgeDate') required DateTime purgeDate,
  }) = _DeleteAccountInfo;

  factory DeleteAccountInfo.fromJson(Map<String, dynamic> json) =>
      _$DeleteAccountInfoFromJson(json);
}
