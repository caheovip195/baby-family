// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'name_candidate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NameCandidate _$NameCandidateFromJson(Map<String, dynamic> json) =>
    _NameCandidate(
      id: json['id'] as String,
      pregnancyId: json['pregnancyId'] as String,
      name: json['name'] as String,
      meaning: json['meaning'] as String?,
      addedByUserId: json['addedByUserId'] as String,
      addedByCallName: json['addedByCallName'] as String?,
      likedByMe: json['likedByMe'] as bool? ?? false,
      likedByPartner: json['likedByPartner'] as bool? ?? false,
      chosen: json['chosen'] as bool? ?? false,
    );

Map<String, dynamic> _$NameCandidateToJson(_NameCandidate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pregnancyId': instance.pregnancyId,
      'name': instance.name,
      'meaning': instance.meaning,
      'addedByUserId': instance.addedByUserId,
      'addedByCallName': instance.addedByCallName,
      'likedByMe': instance.likedByMe,
      'likedByPartner': instance.likedByPartner,
      'chosen': instance.chosen,
    };
