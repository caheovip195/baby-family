// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hearts_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HeartsEntry {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'hearts') int get hearts;@JsonKey(name: 'title') String get title;@JsonKey(name: 'at') DateTime get at;@JsonKey(name: 'together') bool get together;@JsonKey(name: 'missionId') String? get missionId;@JsonKey(name: 'requestId') String? get requestId;
/// Create a copy of HeartsEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HeartsEntryCopyWith<HeartsEntry> get copyWith => _$HeartsEntryCopyWithImpl<HeartsEntry>(this as HeartsEntry, _$identity);

  /// Serializes this HeartsEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HeartsEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.hearts, hearts) || other.hearts == hearts)&&(identical(other.title, title) || other.title == title)&&(identical(other.at, at) || other.at == at)&&(identical(other.together, together) || other.together == together)&&(identical(other.missionId, missionId) || other.missionId == missionId)&&(identical(other.requestId, requestId) || other.requestId == requestId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hearts,title,at,together,missionId,requestId);

@override
String toString() {
  return 'HeartsEntry(id: $id, hearts: $hearts, title: $title, at: $at, together: $together, missionId: $missionId, requestId: $requestId)';
}


}

/// @nodoc
abstract mixin class $HeartsEntryCopyWith<$Res>  {
  factory $HeartsEntryCopyWith(HeartsEntry value, $Res Function(HeartsEntry) _then) = _$HeartsEntryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'hearts') int hearts,@JsonKey(name: 'title') String title,@JsonKey(name: 'at') DateTime at,@JsonKey(name: 'together') bool together,@JsonKey(name: 'missionId') String? missionId,@JsonKey(name: 'requestId') String? requestId
});




}
/// @nodoc
class _$HeartsEntryCopyWithImpl<$Res>
    implements $HeartsEntryCopyWith<$Res> {
  _$HeartsEntryCopyWithImpl(this._self, this._then);

  final HeartsEntry _self;
  final $Res Function(HeartsEntry) _then;

/// Create a copy of HeartsEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? hearts = null,Object? title = null,Object? at = null,Object? together = null,Object? missionId = freezed,Object? requestId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hearts: null == hearts ? _self.hearts : hearts // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,together: null == together ? _self.together : together // ignore: cast_nullable_to_non_nullable
as bool,missionId: freezed == missionId ? _self.missionId : missionId // ignore: cast_nullable_to_non_nullable
as String?,requestId: freezed == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HeartsEntry].
extension HeartsEntryPatterns on HeartsEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HeartsEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HeartsEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HeartsEntry value)  $default,){
final _that = this;
switch (_that) {
case _HeartsEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HeartsEntry value)?  $default,){
final _that = this;
switch (_that) {
case _HeartsEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _HeartsEntry implements HeartsEntry {
  const _HeartsEntry({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'hearts') this.hearts = 0, @JsonKey(name: 'title') this.title = '', @JsonKey(name: 'at') required this.at, @JsonKey(name: 'together') this.together = false, @JsonKey(name: 'missionId') this.missionId, @JsonKey(name: 'requestId') this.requestId});
  factory _HeartsEntry.fromJson(Map<String, dynamic> json) => _$HeartsEntryFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'hearts') final  int hearts;
@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'at') final  DateTime at;
@override@JsonKey(name: 'together') final  bool together;
@override@JsonKey(name: 'missionId') final  String? missionId;
@override@JsonKey(name: 'requestId') final  String? requestId;

/// Create a copy of HeartsEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HeartsEntryCopyWith<_HeartsEntry> get copyWith => __$HeartsEntryCopyWithImpl<_HeartsEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HeartsEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HeartsEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.hearts, hearts) || other.hearts == hearts)&&(identical(other.title, title) || other.title == title)&&(identical(other.at, at) || other.at == at)&&(identical(other.together, together) || other.together == together)&&(identical(other.missionId, missionId) || other.missionId == missionId)&&(identical(other.requestId, requestId) || other.requestId == requestId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hearts,title,at,together,missionId,requestId);

@override
String toString() {
  return 'HeartsEntry(id: $id, hearts: $hearts, title: $title, at: $at, together: $together, missionId: $missionId, requestId: $requestId)';
}


}

/// @nodoc
abstract mixin class _$HeartsEntryCopyWith<$Res> implements $HeartsEntryCopyWith<$Res> {
  factory _$HeartsEntryCopyWith(_HeartsEntry value, $Res Function(_HeartsEntry) _then) = __$HeartsEntryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'hearts') int hearts,@JsonKey(name: 'title') String title,@JsonKey(name: 'at') DateTime at,@JsonKey(name: 'together') bool together,@JsonKey(name: 'missionId') String? missionId,@JsonKey(name: 'requestId') String? requestId
});




}
/// @nodoc
class __$HeartsEntryCopyWithImpl<$Res>
    implements _$HeartsEntryCopyWith<$Res> {
  __$HeartsEntryCopyWithImpl(this._self, this._then);

  final _HeartsEntry _self;
  final $Res Function(_HeartsEntry) _then;

/// Create a copy of HeartsEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? hearts = null,Object? title = null,Object? at = null,Object? together = null,Object? missionId = freezed,Object? requestId = freezed,}) {
  return _then(_HeartsEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hearts: null == hearts ? _self.hearts : hearts // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,together: null == together ? _self.together : together // ignore: cast_nullable_to_non_nullable
as bool,missionId: freezed == missionId ? _self.missionId : missionId // ignore: cast_nullable_to_non_nullable
as String?,requestId: freezed == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
