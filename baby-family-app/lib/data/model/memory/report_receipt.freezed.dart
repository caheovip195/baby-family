// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_receipt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportReceipt {

@JsonKey(name: 'code') String get code;@JsonKey(name: 'status') ReportStatus get status;@JsonKey(name: 'createdAt') DateTime get createdAt;
/// Create a copy of ReportReceipt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportReceiptCopyWith<ReportReceipt> get copyWith => _$ReportReceiptCopyWithImpl<ReportReceipt>(this as ReportReceipt, _$identity);

  /// Serializes this ReportReceipt to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportReceipt&&(identical(other.code, code) || other.code == code)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,status,createdAt);

@override
String toString() {
  return 'ReportReceipt(code: $code, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ReportReceiptCopyWith<$Res>  {
  factory $ReportReceiptCopyWith(ReportReceipt value, $Res Function(ReportReceipt) _then) = _$ReportReceiptCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'code') String code,@JsonKey(name: 'status') ReportStatus status,@JsonKey(name: 'createdAt') DateTime createdAt
});




}
/// @nodoc
class _$ReportReceiptCopyWithImpl<$Res>
    implements $ReportReceiptCopyWith<$Res> {
  _$ReportReceiptCopyWithImpl(this._self, this._then);

  final ReportReceipt _self;
  final $Res Function(ReportReceipt) _then;

/// Create a copy of ReportReceipt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReportStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportReceipt].
extension ReportReceiptPatterns on ReportReceipt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportReceipt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportReceipt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportReceipt value)  $default,){
final _that = this;
switch (_that) {
case _ReportReceipt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportReceipt value)?  $default,){
final _that = this;
switch (_that) {
case _ReportReceipt() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ReportReceipt implements ReportReceipt {
  const _ReportReceipt({@JsonKey(name: 'code') required this.code, @JsonKey(name: 'status') this.status = ReportStatus.reviewing, @JsonKey(name: 'createdAt') required this.createdAt});
  factory _ReportReceipt.fromJson(Map<String, dynamic> json) => _$ReportReceiptFromJson(json);

@override@JsonKey(name: 'code') final  String code;
@override@JsonKey(name: 'status') final  ReportStatus status;
@override@JsonKey(name: 'createdAt') final  DateTime createdAt;

/// Create a copy of ReportReceipt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportReceiptCopyWith<_ReportReceipt> get copyWith => __$ReportReceiptCopyWithImpl<_ReportReceipt>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportReceiptToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportReceipt&&(identical(other.code, code) || other.code == code)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,status,createdAt);

@override
String toString() {
  return 'ReportReceipt(code: $code, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ReportReceiptCopyWith<$Res> implements $ReportReceiptCopyWith<$Res> {
  factory _$ReportReceiptCopyWith(_ReportReceipt value, $Res Function(_ReportReceipt) _then) = __$ReportReceiptCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'code') String code,@JsonKey(name: 'status') ReportStatus status,@JsonKey(name: 'createdAt') DateTime createdAt
});




}
/// @nodoc
class __$ReportReceiptCopyWithImpl<$Res>
    implements _$ReportReceiptCopyWith<$Res> {
  __$ReportReceiptCopyWithImpl(this._self, this._then);

  final _ReportReceipt _self;
  final $Res Function(_ReportReceipt) _then;

/// Create a copy of ReportReceipt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_ReportReceipt(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReportStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
