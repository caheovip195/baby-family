// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plan_offer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlanOffer {

@JsonKey(name: 'code') PlanState get code;@JsonKey(name: 'storageGb') int get storageGb;@JsonKey(name: 'relativeSlots') int get relativeSlots;@JsonKey(name: 'priceText') String get priceText;@JsonKey(name: 'monthlyText') String get monthlyText;
/// Create a copy of PlanOffer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanOfferCopyWith<PlanOffer> get copyWith => _$PlanOfferCopyWithImpl<PlanOffer>(this as PlanOffer, _$identity);

  /// Serializes this PlanOffer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanOffer&&(identical(other.code, code) || other.code == code)&&(identical(other.storageGb, storageGb) || other.storageGb == storageGb)&&(identical(other.relativeSlots, relativeSlots) || other.relativeSlots == relativeSlots)&&(identical(other.priceText, priceText) || other.priceText == priceText)&&(identical(other.monthlyText, monthlyText) || other.monthlyText == monthlyText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,storageGb,relativeSlots,priceText,monthlyText);

@override
String toString() {
  return 'PlanOffer(code: $code, storageGb: $storageGb, relativeSlots: $relativeSlots, priceText: $priceText, monthlyText: $monthlyText)';
}


}

/// @nodoc
abstract mixin class $PlanOfferCopyWith<$Res>  {
  factory $PlanOfferCopyWith(PlanOffer value, $Res Function(PlanOffer) _then) = _$PlanOfferCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'code') PlanState code,@JsonKey(name: 'storageGb') int storageGb,@JsonKey(name: 'relativeSlots') int relativeSlots,@JsonKey(name: 'priceText') String priceText,@JsonKey(name: 'monthlyText') String monthlyText
});




}
/// @nodoc
class _$PlanOfferCopyWithImpl<$Res>
    implements $PlanOfferCopyWith<$Res> {
  _$PlanOfferCopyWithImpl(this._self, this._then);

  final PlanOffer _self;
  final $Res Function(PlanOffer) _then;

/// Create a copy of PlanOffer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? storageGb = null,Object? relativeSlots = null,Object? priceText = null,Object? monthlyText = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as PlanState,storageGb: null == storageGb ? _self.storageGb : storageGb // ignore: cast_nullable_to_non_nullable
as int,relativeSlots: null == relativeSlots ? _self.relativeSlots : relativeSlots // ignore: cast_nullable_to_non_nullable
as int,priceText: null == priceText ? _self.priceText : priceText // ignore: cast_nullable_to_non_nullable
as String,monthlyText: null == monthlyText ? _self.monthlyText : monthlyText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PlanOffer].
extension PlanOfferPatterns on PlanOffer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlanOffer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlanOffer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlanOffer value)  $default,){
final _that = this;
switch (_that) {
case _PlanOffer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlanOffer value)?  $default,){
final _that = this;
switch (_that) {
case _PlanOffer() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PlanOffer implements PlanOffer {
  const _PlanOffer({@JsonKey(name: 'code') required this.code, @JsonKey(name: 'storageGb') this.storageGb = 0, @JsonKey(name: 'relativeSlots') this.relativeSlots = 0, @JsonKey(name: 'priceText') this.priceText = '', @JsonKey(name: 'monthlyText') this.monthlyText = ''});
  factory _PlanOffer.fromJson(Map<String, dynamic> json) => _$PlanOfferFromJson(json);

@override@JsonKey(name: 'code') final  PlanState code;
@override@JsonKey(name: 'storageGb') final  int storageGb;
@override@JsonKey(name: 'relativeSlots') final  int relativeSlots;
@override@JsonKey(name: 'priceText') final  String priceText;
@override@JsonKey(name: 'monthlyText') final  String monthlyText;

/// Create a copy of PlanOffer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlanOfferCopyWith<_PlanOffer> get copyWith => __$PlanOfferCopyWithImpl<_PlanOffer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlanOfferToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlanOffer&&(identical(other.code, code) || other.code == code)&&(identical(other.storageGb, storageGb) || other.storageGb == storageGb)&&(identical(other.relativeSlots, relativeSlots) || other.relativeSlots == relativeSlots)&&(identical(other.priceText, priceText) || other.priceText == priceText)&&(identical(other.monthlyText, monthlyText) || other.monthlyText == monthlyText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,storageGb,relativeSlots,priceText,monthlyText);

@override
String toString() {
  return 'PlanOffer(code: $code, storageGb: $storageGb, relativeSlots: $relativeSlots, priceText: $priceText, monthlyText: $monthlyText)';
}


}

/// @nodoc
abstract mixin class _$PlanOfferCopyWith<$Res> implements $PlanOfferCopyWith<$Res> {
  factory _$PlanOfferCopyWith(_PlanOffer value, $Res Function(_PlanOffer) _then) = __$PlanOfferCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'code') PlanState code,@JsonKey(name: 'storageGb') int storageGb,@JsonKey(name: 'relativeSlots') int relativeSlots,@JsonKey(name: 'priceText') String priceText,@JsonKey(name: 'monthlyText') String monthlyText
});




}
/// @nodoc
class __$PlanOfferCopyWithImpl<$Res>
    implements _$PlanOfferCopyWith<$Res> {
  __$PlanOfferCopyWithImpl(this._self, this._then);

  final _PlanOffer _self;
  final $Res Function(_PlanOffer) _then;

/// Create a copy of PlanOffer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? storageGb = null,Object? relativeSlots = null,Object? priceText = null,Object? monthlyText = null,}) {
  return _then(_PlanOffer(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as PlanState,storageGb: null == storageGb ? _self.storageGb : storageGb // ignore: cast_nullable_to_non_nullable
as int,relativeSlots: null == relativeSlots ? _self.relativeSlots : relativeSlots // ignore: cast_nullable_to_non_nullable
as int,priceText: null == priceText ? _self.priceText : priceText // ignore: cast_nullable_to_non_nullable
as String,monthlyText: null == monthlyText ? _self.monthlyText : monthlyText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
