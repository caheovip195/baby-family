// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission_template_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MissionTemplateRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'title') String? get title;@JsonKey(name: 'category') String? get category;@JsonKey(name: 'hearts') int get hearts;@JsonKey(name: 'durationMin') int? get durationMin;@JsonKey(name: 'multiChildOk') bool get multiChildOk;
/// Create a copy of MissionTemplateRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MissionTemplateRecordCopyWith<MissionTemplateRecord> get copyWith => _$MissionTemplateRecordCopyWithImpl<MissionTemplateRecord>(this as MissionTemplateRecord, _$identity);

  /// Serializes this MissionTemplateRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MissionTemplateRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.hearts, hearts) || other.hearts == hearts)&&(identical(other.durationMin, durationMin) || other.durationMin == durationMin)&&(identical(other.multiChildOk, multiChildOk) || other.multiChildOk == multiChildOk));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,category,hearts,durationMin,multiChildOk);

@override
String toString() {
  return 'MissionTemplateRecord(id: $id, title: $title, category: $category, hearts: $hearts, durationMin: $durationMin, multiChildOk: $multiChildOk)';
}


}

/// @nodoc
abstract mixin class $MissionTemplateRecordCopyWith<$Res>  {
  factory $MissionTemplateRecordCopyWith(MissionTemplateRecord value, $Res Function(MissionTemplateRecord) _then) = _$MissionTemplateRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'title') String? title,@JsonKey(name: 'category') String? category,@JsonKey(name: 'hearts') int hearts,@JsonKey(name: 'durationMin') int? durationMin,@JsonKey(name: 'multiChildOk') bool multiChildOk
});




}
/// @nodoc
class _$MissionTemplateRecordCopyWithImpl<$Res>
    implements $MissionTemplateRecordCopyWith<$Res> {
  _$MissionTemplateRecordCopyWithImpl(this._self, this._then);

  final MissionTemplateRecord _self;
  final $Res Function(MissionTemplateRecord) _then;

/// Create a copy of MissionTemplateRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? title = freezed,Object? category = freezed,Object? hearts = null,Object? durationMin = freezed,Object? multiChildOk = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,hearts: null == hearts ? _self.hearts : hearts // ignore: cast_nullable_to_non_nullable
as int,durationMin: freezed == durationMin ? _self.durationMin : durationMin // ignore: cast_nullable_to_non_nullable
as int?,multiChildOk: null == multiChildOk ? _self.multiChildOk : multiChildOk // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MissionTemplateRecord].
extension MissionTemplateRecordPatterns on MissionTemplateRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MissionTemplateRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MissionTemplateRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MissionTemplateRecord value)  $default,){
final _that = this;
switch (_that) {
case _MissionTemplateRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MissionTemplateRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MissionTemplateRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MissionTemplateRecord implements MissionTemplateRecord {
  const _MissionTemplateRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'title') this.title, @JsonKey(name: 'category') this.category, @JsonKey(name: 'hearts') this.hearts = 0, @JsonKey(name: 'durationMin') this.durationMin, @JsonKey(name: 'multiChildOk') this.multiChildOk = true});
  factory _MissionTemplateRecord.fromJson(Map<String, dynamic> json) => _$MissionTemplateRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'title') final  String? title;
@override@JsonKey(name: 'category') final  String? category;
@override@JsonKey(name: 'hearts') final  int hearts;
@override@JsonKey(name: 'durationMin') final  int? durationMin;
@override@JsonKey(name: 'multiChildOk') final  bool multiChildOk;

/// Create a copy of MissionTemplateRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MissionTemplateRecordCopyWith<_MissionTemplateRecord> get copyWith => __$MissionTemplateRecordCopyWithImpl<_MissionTemplateRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MissionTemplateRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MissionTemplateRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.hearts, hearts) || other.hearts == hearts)&&(identical(other.durationMin, durationMin) || other.durationMin == durationMin)&&(identical(other.multiChildOk, multiChildOk) || other.multiChildOk == multiChildOk));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,category,hearts,durationMin,multiChildOk);

@override
String toString() {
  return 'MissionTemplateRecord(id: $id, title: $title, category: $category, hearts: $hearts, durationMin: $durationMin, multiChildOk: $multiChildOk)';
}


}

/// @nodoc
abstract mixin class _$MissionTemplateRecordCopyWith<$Res> implements $MissionTemplateRecordCopyWith<$Res> {
  factory _$MissionTemplateRecordCopyWith(_MissionTemplateRecord value, $Res Function(_MissionTemplateRecord) _then) = __$MissionTemplateRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'title') String? title,@JsonKey(name: 'category') String? category,@JsonKey(name: 'hearts') int hearts,@JsonKey(name: 'durationMin') int? durationMin,@JsonKey(name: 'multiChildOk') bool multiChildOk
});




}
/// @nodoc
class __$MissionTemplateRecordCopyWithImpl<$Res>
    implements _$MissionTemplateRecordCopyWith<$Res> {
  __$MissionTemplateRecordCopyWithImpl(this._self, this._then);

  final _MissionTemplateRecord _self;
  final $Res Function(_MissionTemplateRecord) _then;

/// Create a copy of MissionTemplateRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? title = freezed,Object? category = freezed,Object? hearts = null,Object? durationMin = freezed,Object? multiChildOk = null,}) {
  return _then(_MissionTemplateRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,hearts: null == hearts ? _self.hearts : hearts // ignore: cast_nullable_to_non_nullable
as int,durationMin: freezed == durationMin ? _self.durationMin : durationMin // ignore: cast_nullable_to_non_nullable
as int?,multiChildOk: null == multiChildOk ? _self.multiChildOk : multiChildOk // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
