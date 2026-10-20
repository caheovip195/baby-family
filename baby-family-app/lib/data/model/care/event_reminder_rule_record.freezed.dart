// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_reminder_rule_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventReminderRuleRecord {

@JsonKey(name: 'recipientUserId') String? get recipientUserId;@JsonKey(name: 'offsetMinutes') int? get offsetMinutes;@JsonKey(name: 'enabled') bool get enabled;
/// Create a copy of EventReminderRuleRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventReminderRuleRecordCopyWith<EventReminderRuleRecord> get copyWith => _$EventReminderRuleRecordCopyWithImpl<EventReminderRuleRecord>(this as EventReminderRuleRecord, _$identity);

  /// Serializes this EventReminderRuleRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventReminderRuleRecord&&(identical(other.recipientUserId, recipientUserId) || other.recipientUserId == recipientUserId)&&(identical(other.offsetMinutes, offsetMinutes) || other.offsetMinutes == offsetMinutes)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,recipientUserId,offsetMinutes,enabled);

@override
String toString() {
  return 'EventReminderRuleRecord(recipientUserId: $recipientUserId, offsetMinutes: $offsetMinutes, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class $EventReminderRuleRecordCopyWith<$Res>  {
  factory $EventReminderRuleRecordCopyWith(EventReminderRuleRecord value, $Res Function(EventReminderRuleRecord) _then) = _$EventReminderRuleRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'recipientUserId') String? recipientUserId,@JsonKey(name: 'offsetMinutes') int? offsetMinutes,@JsonKey(name: 'enabled') bool enabled
});




}
/// @nodoc
class _$EventReminderRuleRecordCopyWithImpl<$Res>
    implements $EventReminderRuleRecordCopyWith<$Res> {
  _$EventReminderRuleRecordCopyWithImpl(this._self, this._then);

  final EventReminderRuleRecord _self;
  final $Res Function(EventReminderRuleRecord) _then;

/// Create a copy of EventReminderRuleRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recipientUserId = freezed,Object? offsetMinutes = freezed,Object? enabled = null,}) {
  return _then(_self.copyWith(
recipientUserId: freezed == recipientUserId ? _self.recipientUserId : recipientUserId // ignore: cast_nullable_to_non_nullable
as String?,offsetMinutes: freezed == offsetMinutes ? _self.offsetMinutes : offsetMinutes // ignore: cast_nullable_to_non_nullable
as int?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EventReminderRuleRecord].
extension EventReminderRuleRecordPatterns on EventReminderRuleRecord {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventReminderRuleRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventReminderRuleRecord() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventReminderRuleRecord value)  $default,){
final _that = this;
switch (_that) {
case _EventReminderRuleRecord():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventReminderRuleRecord value)?  $default,){
final _that = this;
switch (_that) {
case _EventReminderRuleRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _EventReminderRuleRecord implements EventReminderRuleRecord {
  const _EventReminderRuleRecord({@JsonKey(name: 'recipientUserId') this.recipientUserId, @JsonKey(name: 'offsetMinutes') this.offsetMinutes, @JsonKey(name: 'enabled') this.enabled = true});
  factory _EventReminderRuleRecord.fromJson(Map<String, dynamic> json) => _$EventReminderRuleRecordFromJson(json);

@override@JsonKey(name: 'recipientUserId') final  String? recipientUserId;
@override@JsonKey(name: 'offsetMinutes') final  int? offsetMinutes;
@override@JsonKey(name: 'enabled') final  bool enabled;

/// Create a copy of EventReminderRuleRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventReminderRuleRecordCopyWith<_EventReminderRuleRecord> get copyWith => __$EventReminderRuleRecordCopyWithImpl<_EventReminderRuleRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventReminderRuleRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventReminderRuleRecord&&(identical(other.recipientUserId, recipientUserId) || other.recipientUserId == recipientUserId)&&(identical(other.offsetMinutes, offsetMinutes) || other.offsetMinutes == offsetMinutes)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,recipientUserId,offsetMinutes,enabled);

@override
String toString() {
  return 'EventReminderRuleRecord(recipientUserId: $recipientUserId, offsetMinutes: $offsetMinutes, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$EventReminderRuleRecordCopyWith<$Res> implements $EventReminderRuleRecordCopyWith<$Res> {
  factory _$EventReminderRuleRecordCopyWith(_EventReminderRuleRecord value, $Res Function(_EventReminderRuleRecord) _then) = __$EventReminderRuleRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'recipientUserId') String? recipientUserId,@JsonKey(name: 'offsetMinutes') int? offsetMinutes,@JsonKey(name: 'enabled') bool enabled
});




}
/// @nodoc
class __$EventReminderRuleRecordCopyWithImpl<$Res>
    implements _$EventReminderRuleRecordCopyWith<$Res> {
  __$EventReminderRuleRecordCopyWithImpl(this._self, this._then);

  final _EventReminderRuleRecord _self;
  final $Res Function(_EventReminderRuleRecord) _then;

/// Create a copy of EventReminderRuleRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recipientUserId = freezed,Object? offsetMinutes = freezed,Object? enabled = null,}) {
  return _then(_EventReminderRuleRecord(
recipientUserId: freezed == recipientUserId ? _self.recipientUserId : recipientUserId // ignore: cast_nullable_to_non_nullable
as String?,offsetMinutes: freezed == offsetMinutes ? _self.offsetMinutes : offsetMinutes // ignore: cast_nullable_to_non_nullable
as int?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
