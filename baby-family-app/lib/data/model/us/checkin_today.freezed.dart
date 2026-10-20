// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkin_today.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CheckinToday {

@JsonKey(name: 'mine') CheckinRecord? get mine;@JsonKey(name: 'partner') CheckinRecord? get partner;
/// Create a copy of CheckinToday
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckinTodayCopyWith<CheckinToday> get copyWith => _$CheckinTodayCopyWithImpl<CheckinToday>(this as CheckinToday, _$identity);

  /// Serializes this CheckinToday to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckinToday&&(identical(other.mine, mine) || other.mine == mine)&&(identical(other.partner, partner) || other.partner == partner));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mine,partner);

@override
String toString() {
  return 'CheckinToday(mine: $mine, partner: $partner)';
}


}

/// @nodoc
abstract mixin class $CheckinTodayCopyWith<$Res>  {
  factory $CheckinTodayCopyWith(CheckinToday value, $Res Function(CheckinToday) _then) = _$CheckinTodayCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'mine') CheckinRecord? mine,@JsonKey(name: 'partner') CheckinRecord? partner
});


$CheckinRecordCopyWith<$Res>? get mine;$CheckinRecordCopyWith<$Res>? get partner;

}
/// @nodoc
class _$CheckinTodayCopyWithImpl<$Res>
    implements $CheckinTodayCopyWith<$Res> {
  _$CheckinTodayCopyWithImpl(this._self, this._then);

  final CheckinToday _self;
  final $Res Function(CheckinToday) _then;

/// Create a copy of CheckinToday
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mine = freezed,Object? partner = freezed,}) {
  return _then(_self.copyWith(
mine: freezed == mine ? _self.mine : mine // ignore: cast_nullable_to_non_nullable
as CheckinRecord?,partner: freezed == partner ? _self.partner : partner // ignore: cast_nullable_to_non_nullable
as CheckinRecord?,
  ));
}
/// Create a copy of CheckinToday
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CheckinRecordCopyWith<$Res>? get mine {
    if (_self.mine == null) {
    return null;
  }

  return $CheckinRecordCopyWith<$Res>(_self.mine!, (value) {
    return _then(_self.copyWith(mine: value));
  });
}/// Create a copy of CheckinToday
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CheckinRecordCopyWith<$Res>? get partner {
    if (_self.partner == null) {
    return null;
  }

  return $CheckinRecordCopyWith<$Res>(_self.partner!, (value) {
    return _then(_self.copyWith(partner: value));
  });
}
}


/// Adds pattern-matching-related methods to [CheckinToday].
extension CheckinTodayPatterns on CheckinToday {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckinToday value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckinToday() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckinToday value)  $default,){
final _that = this;
switch (_that) {
case _CheckinToday():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckinToday value)?  $default,){
final _that = this;
switch (_that) {
case _CheckinToday() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CheckinToday implements CheckinToday {
  const _CheckinToday({@JsonKey(name: 'mine') this.mine, @JsonKey(name: 'partner') this.partner});
  factory _CheckinToday.fromJson(Map<String, dynamic> json) => _$CheckinTodayFromJson(json);

@override@JsonKey(name: 'mine') final  CheckinRecord? mine;
@override@JsonKey(name: 'partner') final  CheckinRecord? partner;

/// Create a copy of CheckinToday
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckinTodayCopyWith<_CheckinToday> get copyWith => __$CheckinTodayCopyWithImpl<_CheckinToday>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CheckinTodayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckinToday&&(identical(other.mine, mine) || other.mine == mine)&&(identical(other.partner, partner) || other.partner == partner));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mine,partner);

@override
String toString() {
  return 'CheckinToday(mine: $mine, partner: $partner)';
}


}

/// @nodoc
abstract mixin class _$CheckinTodayCopyWith<$Res> implements $CheckinTodayCopyWith<$Res> {
  factory _$CheckinTodayCopyWith(_CheckinToday value, $Res Function(_CheckinToday) _then) = __$CheckinTodayCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'mine') CheckinRecord? mine,@JsonKey(name: 'partner') CheckinRecord? partner
});


@override $CheckinRecordCopyWith<$Res>? get mine;@override $CheckinRecordCopyWith<$Res>? get partner;

}
/// @nodoc
class __$CheckinTodayCopyWithImpl<$Res>
    implements _$CheckinTodayCopyWith<$Res> {
  __$CheckinTodayCopyWithImpl(this._self, this._then);

  final _CheckinToday _self;
  final $Res Function(_CheckinToday) _then;

/// Create a copy of CheckinToday
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mine = freezed,Object? partner = freezed,}) {
  return _then(_CheckinToday(
mine: freezed == mine ? _self.mine : mine // ignore: cast_nullable_to_non_nullable
as CheckinRecord?,partner: freezed == partner ? _self.partner : partner // ignore: cast_nullable_to_non_nullable
as CheckinRecord?,
  ));
}

/// Create a copy of CheckinToday
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CheckinRecordCopyWith<$Res>? get mine {
    if (_self.mine == null) {
    return null;
  }

  return $CheckinRecordCopyWith<$Res>(_self.mine!, (value) {
    return _then(_self.copyWith(mine: value));
  });
}/// Create a copy of CheckinToday
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CheckinRecordCopyWith<$Res>? get partner {
    if (_self.partner == null) {
    return null;
  }

  return $CheckinRecordCopyWith<$Res>(_self.partner!, (value) {
    return _then(_self.copyWith(partner: value));
  });
}
}

// dart format on
