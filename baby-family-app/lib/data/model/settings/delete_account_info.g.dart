// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_account_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeleteAccountInfo _$DeleteAccountInfoFromJson(Map<String, dynamic> json) =>
    _DeleteAccountInfo(
      userName: json['userName'] as String? ?? '',
      partnerName: json['partnerName'] as String?,
      partnerCallName: json['partnerCallName'] as String?,
      familyName: json['familyName'] as String? ?? '',
      childNames:
          (json['childNames'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      postedMemories: (json['postedMemories'] as num?)?.toInt() ?? 0,
      onlyParent: json['onlyParent'] as bool? ?? false,
      maskedAppleAccount: json['maskedAppleAccount'] as String?,
      maskedPhone: json['maskedPhone'] as String?,
      purgeDate: DateTime.parse(json['purgeDate'] as String),
    );

Map<String, dynamic> _$DeleteAccountInfoToJson(_DeleteAccountInfo instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'partnerName': instance.partnerName,
      'partnerCallName': instance.partnerCallName,
      'familyName': instance.familyName,
      'childNames': instance.childNames,
      'postedMemories': instance.postedMemories,
      'onlyParent': instance.onlyParent,
      'maskedAppleAccount': instance.maskedAppleAccount,
      'maskedPhone': instance.maskedPhone,
      'purgeDate': instance.purgeDate.toIso8601String(),
    };
