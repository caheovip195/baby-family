// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timezone_catalog.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimezoneCatalog {

@JsonKey(name: 'version') String? get version;@JsonKey(name: 'items') List<TimezoneOption> get items;
/// Create a copy of TimezoneCatalog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimezoneCatalogCopyWith<TimezoneCatalog> get copyWith => _$TimezoneCatalogCopyWithImpl<TimezoneCatalog>(this as TimezoneCatalog, _$identity);

  /// Serializes this TimezoneCatalog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimezoneCatalog&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'TimezoneCatalog(version: $version, items: $items)';
}


}

/// @nodoc
abstract mixin class $TimezoneCatalogCopyWith<$Res>  {
  factory $TimezoneCatalogCopyWith(TimezoneCatalog value, $Res Function(TimezoneCatalog) _then) = _$TimezoneCatalogCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'version') String? version,@JsonKey(name: 'items') List<TimezoneOption> items
});




}
/// @nodoc
class _$TimezoneCatalogCopyWithImpl<$Res>
    implements $TimezoneCatalogCopyWith<$Res> {
  _$TimezoneCatalogCopyWithImpl(this._self, this._then);

  final TimezoneCatalog _self;
  final $Res Function(TimezoneCatalog) _then;

/// Create a copy of TimezoneCatalog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = freezed,Object? items = null,}) {
  return _then(_self.copyWith(
version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<TimezoneOption>,
  ));
}

}


/// Adds pattern-matching-related methods to [TimezoneCatalog].
extension TimezoneCatalogPatterns on TimezoneCatalog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimezoneCatalog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimezoneCatalog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimezoneCatalog value)  $default,){
final _that = this;
switch (_that) {
case _TimezoneCatalog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimezoneCatalog value)?  $default,){
final _that = this;
switch (_that) {
case _TimezoneCatalog() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TimezoneCatalog implements TimezoneCatalog {
  const _TimezoneCatalog({@JsonKey(name: 'version') this.version, @JsonKey(name: 'items') final  List<TimezoneOption> items = const <TimezoneOption>[]}): _items = items;
  factory _TimezoneCatalog.fromJson(Map<String, dynamic> json) => _$TimezoneCatalogFromJson(json);

@override@JsonKey(name: 'version') final  String? version;
 final  List<TimezoneOption> _items;
@override@JsonKey(name: 'items') List<TimezoneOption> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of TimezoneCatalog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimezoneCatalogCopyWith<_TimezoneCatalog> get copyWith => __$TimezoneCatalogCopyWithImpl<_TimezoneCatalog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimezoneCatalogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimezoneCatalog&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'TimezoneCatalog(version: $version, items: $items)';
}


}

/// @nodoc
abstract mixin class _$TimezoneCatalogCopyWith<$Res> implements $TimezoneCatalogCopyWith<$Res> {
  factory _$TimezoneCatalogCopyWith(_TimezoneCatalog value, $Res Function(_TimezoneCatalog) _then) = __$TimezoneCatalogCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'version') String? version,@JsonKey(name: 'items') List<TimezoneOption> items
});




}
/// @nodoc
class __$TimezoneCatalogCopyWithImpl<$Res>
    implements _$TimezoneCatalogCopyWith<$Res> {
  __$TimezoneCatalogCopyWithImpl(this._self, this._then);

  final _TimezoneCatalog _self;
  final $Res Function(_TimezoneCatalog) _then;

/// Create a copy of TimezoneCatalog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = freezed,Object? items = null,}) {
  return _then(_TimezoneCatalog(
version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TimezoneOption>,
  ));
}


}


/// @nodoc
mixin _$TimezoneOption {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'label') String get label;@JsonKey(name: 'offsetMinutes') int get offsetMinutes;
/// Create a copy of TimezoneOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimezoneOptionCopyWith<TimezoneOption> get copyWith => _$TimezoneOptionCopyWithImpl<TimezoneOption>(this as TimezoneOption, _$identity);

  /// Serializes this TimezoneOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimezoneOption&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.offsetMinutes, offsetMinutes) || other.offsetMinutes == offsetMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,offsetMinutes);

@override
String toString() {
  return 'TimezoneOption(id: $id, label: $label, offsetMinutes: $offsetMinutes)';
}


}

/// @nodoc
abstract mixin class $TimezoneOptionCopyWith<$Res>  {
  factory $TimezoneOptionCopyWith(TimezoneOption value, $Res Function(TimezoneOption) _then) = _$TimezoneOptionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'label') String label,@JsonKey(name: 'offsetMinutes') int offsetMinutes
});




}
/// @nodoc
class _$TimezoneOptionCopyWithImpl<$Res>
    implements $TimezoneOptionCopyWith<$Res> {
  _$TimezoneOptionCopyWithImpl(this._self, this._then);

  final TimezoneOption _self;
  final $Res Function(TimezoneOption) _then;

/// Create a copy of TimezoneOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? offsetMinutes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,offsetMinutes: null == offsetMinutes ? _self.offsetMinutes : offsetMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TimezoneOption].
extension TimezoneOptionPatterns on TimezoneOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimezoneOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimezoneOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimezoneOption value)  $default,){
final _that = this;
switch (_that) {
case _TimezoneOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimezoneOption value)?  $default,){
final _that = this;
switch (_that) {
case _TimezoneOption() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TimezoneOption implements TimezoneOption {
  const _TimezoneOption({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'label') this.label = '', @JsonKey(name: 'offsetMinutes') this.offsetMinutes = 0});
  factory _TimezoneOption.fromJson(Map<String, dynamic> json) => _$TimezoneOptionFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'label') final  String label;
@override@JsonKey(name: 'offsetMinutes') final  int offsetMinutes;

/// Create a copy of TimezoneOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimezoneOptionCopyWith<_TimezoneOption> get copyWith => __$TimezoneOptionCopyWithImpl<_TimezoneOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimezoneOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimezoneOption&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.offsetMinutes, offsetMinutes) || other.offsetMinutes == offsetMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,offsetMinutes);

@override
String toString() {
  return 'TimezoneOption(id: $id, label: $label, offsetMinutes: $offsetMinutes)';
}


}

/// @nodoc
abstract mixin class _$TimezoneOptionCopyWith<$Res> implements $TimezoneOptionCopyWith<$Res> {
  factory _$TimezoneOptionCopyWith(_TimezoneOption value, $Res Function(_TimezoneOption) _then) = __$TimezoneOptionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'label') String label,@JsonKey(name: 'offsetMinutes') int offsetMinutes
});




}
/// @nodoc
class __$TimezoneOptionCopyWithImpl<$Res>
    implements _$TimezoneOptionCopyWith<$Res> {
  __$TimezoneOptionCopyWithImpl(this._self, this._then);

  final _TimezoneOption _self;
  final $Res Function(_TimezoneOption) _then;

/// Create a copy of TimezoneOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? offsetMinutes = null,}) {
  return _then(_TimezoneOption(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,offsetMinutes: null == offsetMinutes ? _self.offsetMinutes : offsetMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
