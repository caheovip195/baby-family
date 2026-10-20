// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_created.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RequestCreated {

@JsonKey(name: 'request') RequestRecord? get request;@JsonKey(name: 'openCount') int? get openCount;@JsonKey(name: 'openLimit') int? get openLimit;
/// Create a copy of RequestCreated
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestCreatedCopyWith<RequestCreated> get copyWith => _$RequestCreatedCopyWithImpl<RequestCreated>(this as RequestCreated, _$identity);

  /// Serializes this RequestCreated to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestCreated&&(identical(other.request, request) || other.request == request)&&(identical(other.openCount, openCount) || other.openCount == openCount)&&(identical(other.openLimit, openLimit) || other.openLimit == openLimit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,request,openCount,openLimit);

@override
String toString() {
  return 'RequestCreated(request: $request, openCount: $openCount, openLimit: $openLimit)';
}


}

/// @nodoc
abstract mixin class $RequestCreatedCopyWith<$Res>  {
  factory $RequestCreatedCopyWith(RequestCreated value, $Res Function(RequestCreated) _then) = _$RequestCreatedCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'request') RequestRecord? request,@JsonKey(name: 'openCount') int? openCount,@JsonKey(name: 'openLimit') int? openLimit
});


$RequestRecordCopyWith<$Res>? get request;

}
/// @nodoc
class _$RequestCreatedCopyWithImpl<$Res>
    implements $RequestCreatedCopyWith<$Res> {
  _$RequestCreatedCopyWithImpl(this._self, this._then);

  final RequestCreated _self;
  final $Res Function(RequestCreated) _then;

/// Create a copy of RequestCreated
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? request = freezed,Object? openCount = freezed,Object? openLimit = freezed,}) {
  return _then(_self.copyWith(
request: freezed == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as RequestRecord?,openCount: freezed == openCount ? _self.openCount : openCount // ignore: cast_nullable_to_non_nullable
as int?,openLimit: freezed == openLimit ? _self.openLimit : openLimit // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of RequestCreated
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RequestRecordCopyWith<$Res>? get request {
    if (_self.request == null) {
    return null;
  }

  return $RequestRecordCopyWith<$Res>(_self.request!, (value) {
    return _then(_self.copyWith(request: value));
  });
}
}


/// Adds pattern-matching-related methods to [RequestCreated].
extension RequestCreatedPatterns on RequestCreated {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequestCreated value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequestCreated() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequestCreated value)  $default,){
final _that = this;
switch (_that) {
case _RequestCreated():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequestCreated value)?  $default,){
final _that = this;
switch (_that) {
case _RequestCreated() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _RequestCreated implements RequestCreated {
  const _RequestCreated({@JsonKey(name: 'request') this.request, @JsonKey(name: 'openCount') this.openCount, @JsonKey(name: 'openLimit') this.openLimit});
  factory _RequestCreated.fromJson(Map<String, dynamic> json) => _$RequestCreatedFromJson(json);

@override@JsonKey(name: 'request') final  RequestRecord? request;
@override@JsonKey(name: 'openCount') final  int? openCount;
@override@JsonKey(name: 'openLimit') final  int? openLimit;

/// Create a copy of RequestCreated
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestCreatedCopyWith<_RequestCreated> get copyWith => __$RequestCreatedCopyWithImpl<_RequestCreated>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RequestCreatedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestCreated&&(identical(other.request, request) || other.request == request)&&(identical(other.openCount, openCount) || other.openCount == openCount)&&(identical(other.openLimit, openLimit) || other.openLimit == openLimit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,request,openCount,openLimit);

@override
String toString() {
  return 'RequestCreated(request: $request, openCount: $openCount, openLimit: $openLimit)';
}


}

/// @nodoc
abstract mixin class _$RequestCreatedCopyWith<$Res> implements $RequestCreatedCopyWith<$Res> {
  factory _$RequestCreatedCopyWith(_RequestCreated value, $Res Function(_RequestCreated) _then) = __$RequestCreatedCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'request') RequestRecord? request,@JsonKey(name: 'openCount') int? openCount,@JsonKey(name: 'openLimit') int? openLimit
});


@override $RequestRecordCopyWith<$Res>? get request;

}
/// @nodoc
class __$RequestCreatedCopyWithImpl<$Res>
    implements _$RequestCreatedCopyWith<$Res> {
  __$RequestCreatedCopyWithImpl(this._self, this._then);

  final _RequestCreated _self;
  final $Res Function(_RequestCreated) _then;

/// Create a copy of RequestCreated
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? request = freezed,Object? openCount = freezed,Object? openLimit = freezed,}) {
  return _then(_RequestCreated(
request: freezed == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as RequestRecord?,openCount: freezed == openCount ? _self.openCount : openCount // ignore: cast_nullable_to_non_nullable
as int?,openLimit: freezed == openLimit ? _self.openLimit : openLimit // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of RequestCreated
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RequestRecordCopyWith<$Res>? get request {
    if (_self.request == null) {
    return null;
  }

  return $RequestRecordCopyWith<$Res>(_self.request!, (value) {
    return _then(_self.copyWith(request: value));
  });
}
}

// dart format on
