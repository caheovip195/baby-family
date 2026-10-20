// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_settings_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationSettingsRecord {

@JsonKey(name: 'quietStart') String? get quietStart;@JsonKey(name: 'quietEnd') String? get quietEnd;@JsonKey(name: 'hideSensitivePreview') bool? get hideSensitivePreview;@JsonKey(name: 'categories') Map<String, bool> get categories;@JsonKey(name: 'circleDigestMode') String? get circleDigestMode;@JsonKey(name: 'circleDigestTime') String? get circleDigestTime;
/// Create a copy of NotificationSettingsRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationSettingsRecordCopyWith<NotificationSettingsRecord> get copyWith => _$NotificationSettingsRecordCopyWithImpl<NotificationSettingsRecord>(this as NotificationSettingsRecord, _$identity);

  /// Serializes this NotificationSettingsRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationSettingsRecord&&(identical(other.quietStart, quietStart) || other.quietStart == quietStart)&&(identical(other.quietEnd, quietEnd) || other.quietEnd == quietEnd)&&(identical(other.hideSensitivePreview, hideSensitivePreview) || other.hideSensitivePreview == hideSensitivePreview)&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.circleDigestMode, circleDigestMode) || other.circleDigestMode == circleDigestMode)&&(identical(other.circleDigestTime, circleDigestTime) || other.circleDigestTime == circleDigestTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quietStart,quietEnd,hideSensitivePreview,const DeepCollectionEquality().hash(categories),circleDigestMode,circleDigestTime);

@override
String toString() {
  return 'NotificationSettingsRecord(quietStart: $quietStart, quietEnd: $quietEnd, hideSensitivePreview: $hideSensitivePreview, categories: $categories, circleDigestMode: $circleDigestMode, circleDigestTime: $circleDigestTime)';
}


}

/// @nodoc
abstract mixin class $NotificationSettingsRecordCopyWith<$Res>  {
  factory $NotificationSettingsRecordCopyWith(NotificationSettingsRecord value, $Res Function(NotificationSettingsRecord) _then) = _$NotificationSettingsRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'quietStart') String? quietStart,@JsonKey(name: 'quietEnd') String? quietEnd,@JsonKey(name: 'hideSensitivePreview') bool? hideSensitivePreview,@JsonKey(name: 'categories') Map<String, bool> categories,@JsonKey(name: 'circleDigestMode') String? circleDigestMode,@JsonKey(name: 'circleDigestTime') String? circleDigestTime
});




}
/// @nodoc
class _$NotificationSettingsRecordCopyWithImpl<$Res>
    implements $NotificationSettingsRecordCopyWith<$Res> {
  _$NotificationSettingsRecordCopyWithImpl(this._self, this._then);

  final NotificationSettingsRecord _self;
  final $Res Function(NotificationSettingsRecord) _then;

/// Create a copy of NotificationSettingsRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quietStart = freezed,Object? quietEnd = freezed,Object? hideSensitivePreview = freezed,Object? categories = null,Object? circleDigestMode = freezed,Object? circleDigestTime = freezed,}) {
  return _then(_self.copyWith(
quietStart: freezed == quietStart ? _self.quietStart : quietStart // ignore: cast_nullable_to_non_nullable
as String?,quietEnd: freezed == quietEnd ? _self.quietEnd : quietEnd // ignore: cast_nullable_to_non_nullable
as String?,hideSensitivePreview: freezed == hideSensitivePreview ? _self.hideSensitivePreview : hideSensitivePreview // ignore: cast_nullable_to_non_nullable
as bool?,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,circleDigestMode: freezed == circleDigestMode ? _self.circleDigestMode : circleDigestMode // ignore: cast_nullable_to_non_nullable
as String?,circleDigestTime: freezed == circleDigestTime ? _self.circleDigestTime : circleDigestTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationSettingsRecord].
extension NotificationSettingsRecordPatterns on NotificationSettingsRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationSettingsRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationSettingsRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationSettingsRecord value)  $default,){
final _that = this;
switch (_that) {
case _NotificationSettingsRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationSettingsRecord value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationSettingsRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _NotificationSettingsRecord implements NotificationSettingsRecord {
  const _NotificationSettingsRecord({@JsonKey(name: 'quietStart') this.quietStart, @JsonKey(name: 'quietEnd') this.quietEnd, @JsonKey(name: 'hideSensitivePreview') this.hideSensitivePreview, @JsonKey(name: 'categories') final  Map<String, bool> categories = const <String, bool>{}, @JsonKey(name: 'circleDigestMode') this.circleDigestMode, @JsonKey(name: 'circleDigestTime') this.circleDigestTime}): _categories = categories;
  factory _NotificationSettingsRecord.fromJson(Map<String, dynamic> json) => _$NotificationSettingsRecordFromJson(json);

@override@JsonKey(name: 'quietStart') final  String? quietStart;
@override@JsonKey(name: 'quietEnd') final  String? quietEnd;
@override@JsonKey(name: 'hideSensitivePreview') final  bool? hideSensitivePreview;
 final  Map<String, bool> _categories;
@override@JsonKey(name: 'categories') Map<String, bool> get categories {
  if (_categories is EqualUnmodifiableMapView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_categories);
}

@override@JsonKey(name: 'circleDigestMode') final  String? circleDigestMode;
@override@JsonKey(name: 'circleDigestTime') final  String? circleDigestTime;

/// Create a copy of NotificationSettingsRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationSettingsRecordCopyWith<_NotificationSettingsRecord> get copyWith => __$NotificationSettingsRecordCopyWithImpl<_NotificationSettingsRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationSettingsRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationSettingsRecord&&(identical(other.quietStart, quietStart) || other.quietStart == quietStart)&&(identical(other.quietEnd, quietEnd) || other.quietEnd == quietEnd)&&(identical(other.hideSensitivePreview, hideSensitivePreview) || other.hideSensitivePreview == hideSensitivePreview)&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.circleDigestMode, circleDigestMode) || other.circleDigestMode == circleDigestMode)&&(identical(other.circleDigestTime, circleDigestTime) || other.circleDigestTime == circleDigestTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quietStart,quietEnd,hideSensitivePreview,const DeepCollectionEquality().hash(_categories),circleDigestMode,circleDigestTime);

@override
String toString() {
  return 'NotificationSettingsRecord(quietStart: $quietStart, quietEnd: $quietEnd, hideSensitivePreview: $hideSensitivePreview, categories: $categories, circleDigestMode: $circleDigestMode, circleDigestTime: $circleDigestTime)';
}


}

/// @nodoc
abstract mixin class _$NotificationSettingsRecordCopyWith<$Res> implements $NotificationSettingsRecordCopyWith<$Res> {
  factory _$NotificationSettingsRecordCopyWith(_NotificationSettingsRecord value, $Res Function(_NotificationSettingsRecord) _then) = __$NotificationSettingsRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'quietStart') String? quietStart,@JsonKey(name: 'quietEnd') String? quietEnd,@JsonKey(name: 'hideSensitivePreview') bool? hideSensitivePreview,@JsonKey(name: 'categories') Map<String, bool> categories,@JsonKey(name: 'circleDigestMode') String? circleDigestMode,@JsonKey(name: 'circleDigestTime') String? circleDigestTime
});




}
/// @nodoc
class __$NotificationSettingsRecordCopyWithImpl<$Res>
    implements _$NotificationSettingsRecordCopyWith<$Res> {
  __$NotificationSettingsRecordCopyWithImpl(this._self, this._then);

  final _NotificationSettingsRecord _self;
  final $Res Function(_NotificationSettingsRecord) _then;

/// Create a copy of NotificationSettingsRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quietStart = freezed,Object? quietEnd = freezed,Object? hideSensitivePreview = freezed,Object? categories = null,Object? circleDigestMode = freezed,Object? circleDigestTime = freezed,}) {
  return _then(_NotificationSettingsRecord(
quietStart: freezed == quietStart ? _self.quietStart : quietStart // ignore: cast_nullable_to_non_nullable
as String?,quietEnd: freezed == quietEnd ? _self.quietEnd : quietEnd // ignore: cast_nullable_to_non_nullable
as String?,hideSensitivePreview: freezed == hideSensitivePreview ? _self.hideSensitivePreview : hideSensitivePreview // ignore: cast_nullable_to_non_nullable
as bool?,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,circleDigestMode: freezed == circleDigestMode ? _self.circleDigestMode : circleDigestMode // ignore: cast_nullable_to_non_nullable
as String?,circleDigestTime: freezed == circleDigestTime ? _self.circleDigestTime : circleDigestTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
