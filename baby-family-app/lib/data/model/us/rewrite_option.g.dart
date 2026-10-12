// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rewrite_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RewriteOption _$RewriteOptionFromJson(Map<String, dynamic> json) =>
    _RewriteOption(
      tone: $enumDecode(_$RewriteToneEnumMap, json['tone']),
      text: json['text'] as String,
    );

Map<String, dynamic> _$RewriteOptionToJson(_RewriteOption instance) =>
    <String, dynamic>{
      'tone': _$RewriteToneEnumMap[instance.tone]!,
      'text': instance.text,
    };

const _$RewriteToneEnumMap = {
  RewriteTone.neutral: 'neutral',
  RewriteTone.warm: 'warm',
  RewriteTone.short: 'short',
};
