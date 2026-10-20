// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'badge_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BadgeRecord {

@JsonKey(name: 'code') String? get code;@JsonKey(name: 'title') String? get title;@JsonKey(name: 'titleI18n') Map<String, String> get titleI18n;@JsonKey(name: 'description') String? get description;@JsonKey(name: 'descI18n') Map<String, String> get descI18n;@JsonKey(name: 'icon') String? get icon;@JsonKey(name: 'earned') bool get earned;@JsonKey(name: 'achievedAt') DateTime? get achievedAt;@JsonKey(name: 'progress') BadgeProgressRecord? get progress;
/// Create a copy of BadgeRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BadgeRecordCopyWith<BadgeRecord> get copyWith => _$BadgeRecordCopyWithImpl<BadgeRecord>(this as BadgeRecord, _$identity);

  /// Serializes this BadgeRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BadgeRecord&&(identical(other.code, code) || other.code == code)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.titleI18n, titleI18n)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.descI18n, descI18n)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.earned, earned) || other.earned == earned)&&(identical(other.achievedAt, achievedAt) || other.achievedAt == achievedAt)&&(identical(other.progress, progress) || other.progress == progress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,title,const DeepCollectionEquality().hash(titleI18n),description,const DeepCollectionEquality().hash(descI18n),icon,earned,achievedAt,progress);

@override
String toString() {
  return 'BadgeRecord(code: $code, title: $title, titleI18n: $titleI18n, description: $description, descI18n: $descI18n, icon: $icon, earned: $earned, achievedAt: $achievedAt, progress: $progress)';
}


}

/// @nodoc
abstract mixin class $BadgeRecordCopyWith<$Res>  {
  factory $BadgeRecordCopyWith(BadgeRecord value, $Res Function(BadgeRecord) _then) = _$BadgeRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'code') String? code,@JsonKey(name: 'title') String? title,@JsonKey(name: 'titleI18n') Map<String, String> titleI18n,@JsonKey(name: 'description') String? description,@JsonKey(name: 'descI18n') Map<String, String> descI18n,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'earned') bool earned,@JsonKey(name: 'achievedAt') DateTime? achievedAt,@JsonKey(name: 'progress') BadgeProgressRecord? progress
});


$BadgeProgressRecordCopyWith<$Res>? get progress;

}
/// @nodoc
class _$BadgeRecordCopyWithImpl<$Res>
    implements $BadgeRecordCopyWith<$Res> {
  _$BadgeRecordCopyWithImpl(this._self, this._then);

  final BadgeRecord _self;
  final $Res Function(BadgeRecord) _then;

/// Create a copy of BadgeRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = freezed,Object? title = freezed,Object? titleI18n = null,Object? description = freezed,Object? descI18n = null,Object? icon = freezed,Object? earned = null,Object? achievedAt = freezed,Object? progress = freezed,}) {
  return _then(_self.copyWith(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,titleI18n: null == titleI18n ? _self.titleI18n : titleI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descI18n: null == descI18n ? _self.descI18n : descI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,earned: null == earned ? _self.earned : earned // ignore: cast_nullable_to_non_nullable
as bool,achievedAt: freezed == achievedAt ? _self.achievedAt : achievedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as BadgeProgressRecord?,
  ));
}
/// Create a copy of BadgeRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BadgeProgressRecordCopyWith<$Res>? get progress {
    if (_self.progress == null) {
    return null;
  }

  return $BadgeProgressRecordCopyWith<$Res>(_self.progress!, (value) {
    return _then(_self.copyWith(progress: value));
  });
}
}


/// Adds pattern-matching-related methods to [BadgeRecord].
extension BadgeRecordPatterns on BadgeRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BadgeRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BadgeRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BadgeRecord value)  $default,){
final _that = this;
switch (_that) {
case _BadgeRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BadgeRecord value)?  $default,){
final _that = this;
switch (_that) {
case _BadgeRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BadgeRecord implements BadgeRecord {
  const _BadgeRecord({@JsonKey(name: 'code') this.code, @JsonKey(name: 'title') this.title, @JsonKey(name: 'titleI18n') final  Map<String, String> titleI18n = const <String, String>{}, @JsonKey(name: 'description') this.description, @JsonKey(name: 'descI18n') final  Map<String, String> descI18n = const <String, String>{}, @JsonKey(name: 'icon') this.icon, @JsonKey(name: 'earned') this.earned = false, @JsonKey(name: 'achievedAt') this.achievedAt, @JsonKey(name: 'progress') this.progress}): _titleI18n = titleI18n,_descI18n = descI18n;
  factory _BadgeRecord.fromJson(Map<String, dynamic> json) => _$BadgeRecordFromJson(json);

@override@JsonKey(name: 'code') final  String? code;
@override@JsonKey(name: 'title') final  String? title;
 final  Map<String, String> _titleI18n;
@override@JsonKey(name: 'titleI18n') Map<String, String> get titleI18n {
  if (_titleI18n is EqualUnmodifiableMapView) return _titleI18n;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_titleI18n);
}

@override@JsonKey(name: 'description') final  String? description;
 final  Map<String, String> _descI18n;
@override@JsonKey(name: 'descI18n') Map<String, String> get descI18n {
  if (_descI18n is EqualUnmodifiableMapView) return _descI18n;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_descI18n);
}

@override@JsonKey(name: 'icon') final  String? icon;
@override@JsonKey(name: 'earned') final  bool earned;
@override@JsonKey(name: 'achievedAt') final  DateTime? achievedAt;
@override@JsonKey(name: 'progress') final  BadgeProgressRecord? progress;

/// Create a copy of BadgeRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BadgeRecordCopyWith<_BadgeRecord> get copyWith => __$BadgeRecordCopyWithImpl<_BadgeRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BadgeRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BadgeRecord&&(identical(other.code, code) || other.code == code)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._titleI18n, _titleI18n)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._descI18n, _descI18n)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.earned, earned) || other.earned == earned)&&(identical(other.achievedAt, achievedAt) || other.achievedAt == achievedAt)&&(identical(other.progress, progress) || other.progress == progress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,title,const DeepCollectionEquality().hash(_titleI18n),description,const DeepCollectionEquality().hash(_descI18n),icon,earned,achievedAt,progress);

@override
String toString() {
  return 'BadgeRecord(code: $code, title: $title, titleI18n: $titleI18n, description: $description, descI18n: $descI18n, icon: $icon, earned: $earned, achievedAt: $achievedAt, progress: $progress)';
}


}

/// @nodoc
abstract mixin class _$BadgeRecordCopyWith<$Res> implements $BadgeRecordCopyWith<$Res> {
  factory _$BadgeRecordCopyWith(_BadgeRecord value, $Res Function(_BadgeRecord) _then) = __$BadgeRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'code') String? code,@JsonKey(name: 'title') String? title,@JsonKey(name: 'titleI18n') Map<String, String> titleI18n,@JsonKey(name: 'description') String? description,@JsonKey(name: 'descI18n') Map<String, String> descI18n,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'earned') bool earned,@JsonKey(name: 'achievedAt') DateTime? achievedAt,@JsonKey(name: 'progress') BadgeProgressRecord? progress
});


@override $BadgeProgressRecordCopyWith<$Res>? get progress;

}
/// @nodoc
class __$BadgeRecordCopyWithImpl<$Res>
    implements _$BadgeRecordCopyWith<$Res> {
  __$BadgeRecordCopyWithImpl(this._self, this._then);

  final _BadgeRecord _self;
  final $Res Function(_BadgeRecord) _then;

/// Create a copy of BadgeRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = freezed,Object? title = freezed,Object? titleI18n = null,Object? description = freezed,Object? descI18n = null,Object? icon = freezed,Object? earned = null,Object? achievedAt = freezed,Object? progress = freezed,}) {
  return _then(_BadgeRecord(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,titleI18n: null == titleI18n ? _self._titleI18n : titleI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descI18n: null == descI18n ? _self._descI18n : descI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,earned: null == earned ? _self.earned : earned // ignore: cast_nullable_to_non_nullable
as bool,achievedAt: freezed == achievedAt ? _self.achievedAt : achievedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as BadgeProgressRecord?,
  ));
}

/// Create a copy of BadgeRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BadgeProgressRecordCopyWith<$Res>? get progress {
    if (_self.progress == null) {
    return null;
  }

  return $BadgeProgressRecordCopyWith<$Res>(_self.progress!, (value) {
    return _then(_self.copyWith(progress: value));
  });
}
}

// dart format on
