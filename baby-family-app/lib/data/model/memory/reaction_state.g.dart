// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReactionState _$ReactionStateFromJson(Map<String, dynamic> json) =>
    _ReactionState(
      memoryId: json['memoryId'] as String?,
      reactions:
          (json['reactions'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const <String, int>{},
      myReaction: json['myReaction'] as String?,
      reactionCount: (json['reactionCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ReactionStateToJson(_ReactionState instance) =>
    <String, dynamic>{
      'memoryId': instance.memoryId,
      'reactions': instance.reactions,
      'myReaction': instance.myReaction,
      'reactionCount': instance.reactionCount,
    };
