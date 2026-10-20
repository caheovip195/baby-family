// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'billing_catalog.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BillingCatalog {

@JsonKey(name: 'plans') List<BillingPlanRecord> get plans;
/// Create a copy of BillingCatalog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BillingCatalogCopyWith<BillingCatalog> get copyWith => _$BillingCatalogCopyWithImpl<BillingCatalog>(this as BillingCatalog, _$identity);

  /// Serializes this BillingCatalog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BillingCatalog&&const DeepCollectionEquality().equals(other.plans, plans));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(plans));

@override
String toString() {
  return 'BillingCatalog(plans: $plans)';
}


}

/// @nodoc
abstract mixin class $BillingCatalogCopyWith<$Res>  {
  factory $BillingCatalogCopyWith(BillingCatalog value, $Res Function(BillingCatalog) _then) = _$BillingCatalogCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'plans') List<BillingPlanRecord> plans
});




}
/// @nodoc
class _$BillingCatalogCopyWithImpl<$Res>
    implements $BillingCatalogCopyWith<$Res> {
  _$BillingCatalogCopyWithImpl(this._self, this._then);

  final BillingCatalog _self;
  final $Res Function(BillingCatalog) _then;

/// Create a copy of BillingCatalog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? plans = null,}) {
  return _then(_self.copyWith(
plans: null == plans ? _self.plans : plans // ignore: cast_nullable_to_non_nullable
as List<BillingPlanRecord>,
  ));
}

}


/// Adds pattern-matching-related methods to [BillingCatalog].
extension BillingCatalogPatterns on BillingCatalog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BillingCatalog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BillingCatalog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BillingCatalog value)  $default,){
final _that = this;
switch (_that) {
case _BillingCatalog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BillingCatalog value)?  $default,){
final _that = this;
switch (_that) {
case _BillingCatalog() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BillingCatalog implements BillingCatalog {
  const _BillingCatalog({@JsonKey(name: 'plans') final  List<BillingPlanRecord> plans = const <BillingPlanRecord>[]}): _plans = plans;
  factory _BillingCatalog.fromJson(Map<String, dynamic> json) => _$BillingCatalogFromJson(json);

 final  List<BillingPlanRecord> _plans;
@override@JsonKey(name: 'plans') List<BillingPlanRecord> get plans {
  if (_plans is EqualUnmodifiableListView) return _plans;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_plans);
}


/// Create a copy of BillingCatalog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BillingCatalogCopyWith<_BillingCatalog> get copyWith => __$BillingCatalogCopyWithImpl<_BillingCatalog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BillingCatalogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BillingCatalog&&const DeepCollectionEquality().equals(other._plans, _plans));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_plans));

@override
String toString() {
  return 'BillingCatalog(plans: $plans)';
}


}

/// @nodoc
abstract mixin class _$BillingCatalogCopyWith<$Res> implements $BillingCatalogCopyWith<$Res> {
  factory _$BillingCatalogCopyWith(_BillingCatalog value, $Res Function(_BillingCatalog) _then) = __$BillingCatalogCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'plans') List<BillingPlanRecord> plans
});




}
/// @nodoc
class __$BillingCatalogCopyWithImpl<$Res>
    implements _$BillingCatalogCopyWith<$Res> {
  __$BillingCatalogCopyWithImpl(this._self, this._then);

  final _BillingCatalog _self;
  final $Res Function(_BillingCatalog) _then;

/// Create a copy of BillingCatalog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? plans = null,}) {
  return _then(_BillingCatalog(
plans: null == plans ? _self._plans : plans // ignore: cast_nullable_to_non_nullable
as List<BillingPlanRecord>,
  ));
}


}

// dart format on
