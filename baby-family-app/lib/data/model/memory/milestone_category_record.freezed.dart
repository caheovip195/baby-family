// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'milestone_category_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MilestoneCategoryRecord {

@JsonKey(name: 'category') String? get category;@JsonKey(name: 'templates') List<MilestoneTemplateRecord> get templates;
/// Create a copy of MilestoneCategoryRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MilestoneCategoryRecordCopyWith<MilestoneCategoryRecord> get copyWith => _$MilestoneCategoryRecordCopyWithImpl<MilestoneCategoryRecord>(this as MilestoneCategoryRecord, _$identity);

  /// Serializes this MilestoneCategoryRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MilestoneCategoryRecord&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.templates, templates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,const DeepCollectionEquality().hash(templates));

@override
String toString() {
  return 'MilestoneCategoryRecord(category: $category, templates: $templates)';
}


}

/// @nodoc
abstract mixin class $MilestoneCategoryRecordCopyWith<$Res>  {
  factory $MilestoneCategoryRecordCopyWith(MilestoneCategoryRecord value, $Res Function(MilestoneCategoryRecord) _then) = _$MilestoneCategoryRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'category') String? category,@JsonKey(name: 'templates') List<MilestoneTemplateRecord> templates
});




}
/// @nodoc
class _$MilestoneCategoryRecordCopyWithImpl<$Res>
    implements $MilestoneCategoryRecordCopyWith<$Res> {
  _$MilestoneCategoryRecordCopyWithImpl(this._self, this._then);

  final MilestoneCategoryRecord _self;
  final $Res Function(MilestoneCategoryRecord) _then;

/// Create a copy of MilestoneCategoryRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = freezed,Object? templates = null,}) {
  return _then(_self.copyWith(
category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,templates: null == templates ? _self.templates : templates // ignore: cast_nullable_to_non_nullable
as List<MilestoneTemplateRecord>,
  ));
}

}


/// Adds pattern-matching-related methods to [MilestoneCategoryRecord].
extension MilestoneCategoryRecordPatterns on MilestoneCategoryRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MilestoneCategoryRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MilestoneCategoryRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MilestoneCategoryRecord value)  $default,){
final _that = this;
switch (_that) {
case _MilestoneCategoryRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MilestoneCategoryRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MilestoneCategoryRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MilestoneCategoryRecord implements MilestoneCategoryRecord {
  const _MilestoneCategoryRecord({@JsonKey(name: 'category') this.category, @JsonKey(name: 'templates') final  List<MilestoneTemplateRecord> templates = const <MilestoneTemplateRecord>[]}): _templates = templates;
  factory _MilestoneCategoryRecord.fromJson(Map<String, dynamic> json) => _$MilestoneCategoryRecordFromJson(json);

@override@JsonKey(name: 'category') final  String? category;
 final  List<MilestoneTemplateRecord> _templates;
@override@JsonKey(name: 'templates') List<MilestoneTemplateRecord> get templates {
  if (_templates is EqualUnmodifiableListView) return _templates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_templates);
}


/// Create a copy of MilestoneCategoryRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MilestoneCategoryRecordCopyWith<_MilestoneCategoryRecord> get copyWith => __$MilestoneCategoryRecordCopyWithImpl<_MilestoneCategoryRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MilestoneCategoryRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MilestoneCategoryRecord&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other._templates, _templates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,const DeepCollectionEquality().hash(_templates));

@override
String toString() {
  return 'MilestoneCategoryRecord(category: $category, templates: $templates)';
}


}

/// @nodoc
abstract mixin class _$MilestoneCategoryRecordCopyWith<$Res> implements $MilestoneCategoryRecordCopyWith<$Res> {
  factory _$MilestoneCategoryRecordCopyWith(_MilestoneCategoryRecord value, $Res Function(_MilestoneCategoryRecord) _then) = __$MilestoneCategoryRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'category') String? category,@JsonKey(name: 'templates') List<MilestoneTemplateRecord> templates
});




}
/// @nodoc
class __$MilestoneCategoryRecordCopyWithImpl<$Res>
    implements _$MilestoneCategoryRecordCopyWith<$Res> {
  __$MilestoneCategoryRecordCopyWithImpl(this._self, this._then);

  final _MilestoneCategoryRecord _self;
  final $Res Function(_MilestoneCategoryRecord) _then;

/// Create a copy of MilestoneCategoryRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = freezed,Object? templates = null,}) {
  return _then(_MilestoneCategoryRecord(
category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,templates: null == templates ? _self._templates : templates // ignore: cast_nullable_to_non_nullable
as List<MilestoneTemplateRecord>,
  ));
}


}

// dart format on
