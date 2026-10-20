// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deletion_preview_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeletionPreviewRecord {

@JsonKey(name: 'graceDays') int? get graceDays;@JsonKey(name: 'familyId') String? get familyId;@JsonKey(name: 'familyChoices') List<String> get familyChoices;@JsonKey(name: 'familyAfterDeletion') String? get familyAfterDeletion;@JsonKey(name: 'isPayer') bool get isPayer;
/// Create a copy of DeletionPreviewRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeletionPreviewRecordCopyWith<DeletionPreviewRecord> get copyWith => _$DeletionPreviewRecordCopyWithImpl<DeletionPreviewRecord>(this as DeletionPreviewRecord, _$identity);

  /// Serializes this DeletionPreviewRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeletionPreviewRecord&&(identical(other.graceDays, graceDays) || other.graceDays == graceDays)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&const DeepCollectionEquality().equals(other.familyChoices, familyChoices)&&(identical(other.familyAfterDeletion, familyAfterDeletion) || other.familyAfterDeletion == familyAfterDeletion)&&(identical(other.isPayer, isPayer) || other.isPayer == isPayer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,graceDays,familyId,const DeepCollectionEquality().hash(familyChoices),familyAfterDeletion,isPayer);

@override
String toString() {
  return 'DeletionPreviewRecord(graceDays: $graceDays, familyId: $familyId, familyChoices: $familyChoices, familyAfterDeletion: $familyAfterDeletion, isPayer: $isPayer)';
}


}

/// @nodoc
abstract mixin class $DeletionPreviewRecordCopyWith<$Res>  {
  factory $DeletionPreviewRecordCopyWith(DeletionPreviewRecord value, $Res Function(DeletionPreviewRecord) _then) = _$DeletionPreviewRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'graceDays') int? graceDays,@JsonKey(name: 'familyId') String? familyId,@JsonKey(name: 'familyChoices') List<String> familyChoices,@JsonKey(name: 'familyAfterDeletion') String? familyAfterDeletion,@JsonKey(name: 'isPayer') bool isPayer
});




}
/// @nodoc
class _$DeletionPreviewRecordCopyWithImpl<$Res>
    implements $DeletionPreviewRecordCopyWith<$Res> {
  _$DeletionPreviewRecordCopyWithImpl(this._self, this._then);

  final DeletionPreviewRecord _self;
  final $Res Function(DeletionPreviewRecord) _then;

/// Create a copy of DeletionPreviewRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? graceDays = freezed,Object? familyId = freezed,Object? familyChoices = null,Object? familyAfterDeletion = freezed,Object? isPayer = null,}) {
  return _then(_self.copyWith(
graceDays: freezed == graceDays ? _self.graceDays : graceDays // ignore: cast_nullable_to_non_nullable
as int?,familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,familyChoices: null == familyChoices ? _self.familyChoices : familyChoices // ignore: cast_nullable_to_non_nullable
as List<String>,familyAfterDeletion: freezed == familyAfterDeletion ? _self.familyAfterDeletion : familyAfterDeletion // ignore: cast_nullable_to_non_nullable
as String?,isPayer: null == isPayer ? _self.isPayer : isPayer // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DeletionPreviewRecord].
extension DeletionPreviewRecordPatterns on DeletionPreviewRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeletionPreviewRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeletionPreviewRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeletionPreviewRecord value)  $default,){
final _that = this;
switch (_that) {
case _DeletionPreviewRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeletionPreviewRecord value)?  $default,){
final _that = this;
switch (_that) {
case _DeletionPreviewRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _DeletionPreviewRecord implements DeletionPreviewRecord {
  const _DeletionPreviewRecord({@JsonKey(name: 'graceDays') this.graceDays, @JsonKey(name: 'familyId') this.familyId, @JsonKey(name: 'familyChoices') final  List<String> familyChoices = const <String>[], @JsonKey(name: 'familyAfterDeletion') this.familyAfterDeletion, @JsonKey(name: 'isPayer') this.isPayer = false}): _familyChoices = familyChoices;
  factory _DeletionPreviewRecord.fromJson(Map<String, dynamic> json) => _$DeletionPreviewRecordFromJson(json);

@override@JsonKey(name: 'graceDays') final  int? graceDays;
@override@JsonKey(name: 'familyId') final  String? familyId;
 final  List<String> _familyChoices;
@override@JsonKey(name: 'familyChoices') List<String> get familyChoices {
  if (_familyChoices is EqualUnmodifiableListView) return _familyChoices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_familyChoices);
}

@override@JsonKey(name: 'familyAfterDeletion') final  String? familyAfterDeletion;
@override@JsonKey(name: 'isPayer') final  bool isPayer;

/// Create a copy of DeletionPreviewRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeletionPreviewRecordCopyWith<_DeletionPreviewRecord> get copyWith => __$DeletionPreviewRecordCopyWithImpl<_DeletionPreviewRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeletionPreviewRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeletionPreviewRecord&&(identical(other.graceDays, graceDays) || other.graceDays == graceDays)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&const DeepCollectionEquality().equals(other._familyChoices, _familyChoices)&&(identical(other.familyAfterDeletion, familyAfterDeletion) || other.familyAfterDeletion == familyAfterDeletion)&&(identical(other.isPayer, isPayer) || other.isPayer == isPayer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,graceDays,familyId,const DeepCollectionEquality().hash(_familyChoices),familyAfterDeletion,isPayer);

@override
String toString() {
  return 'DeletionPreviewRecord(graceDays: $graceDays, familyId: $familyId, familyChoices: $familyChoices, familyAfterDeletion: $familyAfterDeletion, isPayer: $isPayer)';
}


}

/// @nodoc
abstract mixin class _$DeletionPreviewRecordCopyWith<$Res> implements $DeletionPreviewRecordCopyWith<$Res> {
  factory _$DeletionPreviewRecordCopyWith(_DeletionPreviewRecord value, $Res Function(_DeletionPreviewRecord) _then) = __$DeletionPreviewRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'graceDays') int? graceDays,@JsonKey(name: 'familyId') String? familyId,@JsonKey(name: 'familyChoices') List<String> familyChoices,@JsonKey(name: 'familyAfterDeletion') String? familyAfterDeletion,@JsonKey(name: 'isPayer') bool isPayer
});




}
/// @nodoc
class __$DeletionPreviewRecordCopyWithImpl<$Res>
    implements _$DeletionPreviewRecordCopyWith<$Res> {
  __$DeletionPreviewRecordCopyWithImpl(this._self, this._then);

  final _DeletionPreviewRecord _self;
  final $Res Function(_DeletionPreviewRecord) _then;

/// Create a copy of DeletionPreviewRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? graceDays = freezed,Object? familyId = freezed,Object? familyChoices = null,Object? familyAfterDeletion = freezed,Object? isPayer = null,}) {
  return _then(_DeletionPreviewRecord(
graceDays: freezed == graceDays ? _self.graceDays : graceDays // ignore: cast_nullable_to_non_nullable
as int?,familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,familyChoices: null == familyChoices ? _self._familyChoices : familyChoices // ignore: cast_nullable_to_non_nullable
as List<String>,familyAfterDeletion: freezed == familyAfterDeletion ? _self.familyAfterDeletion : familyAfterDeletion // ignore: cast_nullable_to_non_nullable
as String?,isPayer: null == isPayer ? _self.isPayer : isPayer // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
