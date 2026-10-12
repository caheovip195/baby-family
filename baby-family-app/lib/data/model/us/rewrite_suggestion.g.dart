// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rewrite_suggestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RewriteSuggestion _$RewriteSuggestionFromJson(Map<String, dynamic> json) =>
    _RewriteSuggestion(
      original: json['original'] as String,
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => RewriteOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      selected:
          $enumDecodeNullable(_$RewriteToneEnumMap, json['selected']) ??
          RewriteTone.neutral,
      edited: json['edited'] as String?,
    );

Map<String, dynamic> _$RewriteSuggestionToJson(_RewriteSuggestion instance) =>
    <String, dynamic>{
      'original': instance.original,
      'options': instance.options.map((e) => e.toJson()).toList(),
      'selected': _$RewriteToneEnumMap[instance.selected]!,
      'edited': instance.edited,
    };

const _$RewriteToneEnumMap = {
  RewriteTone.neutral: 'neutral',
  RewriteTone.warm: 'warm',
  RewriteTone.short: 'short',
};
