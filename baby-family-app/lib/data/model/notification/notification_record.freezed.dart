// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'tab') String? get tab;@JsonKey(name: 'category') String? get category;@JsonKey(name: 'templateCode') String? get templateCode;@JsonKey(name: 'params') Map<String, dynamic> get params;@JsonKey(name: 'createdAt') DateTime? get createdAt;@JsonKey(name: 'readAt') DateTime? get readAt;@JsonKey(name: 'deepLink') String? get deepLink;
/// Create a copy of NotificationRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationRecordCopyWith<NotificationRecord> get copyWith => _$NotificationRecordCopyWithImpl<NotificationRecord>(this as NotificationRecord, _$identity);

  /// Serializes this NotificationRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.tab, tab) || other.tab == tab)&&(identical(other.category, category) || other.category == category)&&(identical(other.templateCode, templateCode) || other.templateCode == templateCode)&&const DeepCollectionEquality().equals(other.params, params)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.readAt, readAt) || other.readAt == readAt)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tab,category,templateCode,const DeepCollectionEquality().hash(params),createdAt,readAt,deepLink);

@override
String toString() {
  return 'NotificationRecord(id: $id, tab: $tab, category: $category, templateCode: $templateCode, params: $params, createdAt: $createdAt, readAt: $readAt, deepLink: $deepLink)';
}


}

/// @nodoc
abstract mixin class $NotificationRecordCopyWith<$Res>  {
  factory $NotificationRecordCopyWith(NotificationRecord value, $Res Function(NotificationRecord) _then) = _$NotificationRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'tab') String? tab,@JsonKey(name: 'category') String? category,@JsonKey(name: 'templateCode') String? templateCode,@JsonKey(name: 'params') Map<String, dynamic> params,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'readAt') DateTime? readAt,@JsonKey(name: 'deepLink') String? deepLink
});




}
/// @nodoc
class _$NotificationRecordCopyWithImpl<$Res>
    implements $NotificationRecordCopyWith<$Res> {
  _$NotificationRecordCopyWithImpl(this._self, this._then);

  final NotificationRecord _self;
  final $Res Function(NotificationRecord) _then;

/// Create a copy of NotificationRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? tab = freezed,Object? category = freezed,Object? templateCode = freezed,Object? params = null,Object? createdAt = freezed,Object? readAt = freezed,Object? deepLink = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,tab: freezed == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,templateCode: freezed == templateCode ? _self.templateCode : templateCode // ignore: cast_nullable_to_non_nullable
as String?,params: null == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deepLink: freezed == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationRecord].
extension NotificationRecordPatterns on NotificationRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationRecord value)  $default,){
final _that = this;
switch (_that) {
case _NotificationRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationRecord value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _NotificationRecord implements NotificationRecord {
  const _NotificationRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'tab') this.tab, @JsonKey(name: 'category') this.category, @JsonKey(name: 'templateCode') this.templateCode, @JsonKey(name: 'params') final  Map<String, dynamic> params = const <String, dynamic>{}, @JsonKey(name: 'createdAt') this.createdAt, @JsonKey(name: 'readAt') this.readAt, @JsonKey(name: 'deepLink') this.deepLink}): _params = params;
  factory _NotificationRecord.fromJson(Map<String, dynamic> json) => _$NotificationRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'tab') final  String? tab;
@override@JsonKey(name: 'category') final  String? category;
@override@JsonKey(name: 'templateCode') final  String? templateCode;
 final  Map<String, dynamic> _params;
@override@JsonKey(name: 'params') Map<String, dynamic> get params {
  if (_params is EqualUnmodifiableMapView) return _params;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_params);
}

@override@JsonKey(name: 'createdAt') final  DateTime? createdAt;
@override@JsonKey(name: 'readAt') final  DateTime? readAt;
@override@JsonKey(name: 'deepLink') final  String? deepLink;

/// Create a copy of NotificationRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationRecordCopyWith<_NotificationRecord> get copyWith => __$NotificationRecordCopyWithImpl<_NotificationRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.tab, tab) || other.tab == tab)&&(identical(other.category, category) || other.category == category)&&(identical(other.templateCode, templateCode) || other.templateCode == templateCode)&&const DeepCollectionEquality().equals(other._params, _params)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.readAt, readAt) || other.readAt == readAt)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tab,category,templateCode,const DeepCollectionEquality().hash(_params),createdAt,readAt,deepLink);

@override
String toString() {
  return 'NotificationRecord(id: $id, tab: $tab, category: $category, templateCode: $templateCode, params: $params, createdAt: $createdAt, readAt: $readAt, deepLink: $deepLink)';
}


}

/// @nodoc
abstract mixin class _$NotificationRecordCopyWith<$Res> implements $NotificationRecordCopyWith<$Res> {
  factory _$NotificationRecordCopyWith(_NotificationRecord value, $Res Function(_NotificationRecord) _then) = __$NotificationRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'tab') String? tab,@JsonKey(name: 'category') String? category,@JsonKey(name: 'templateCode') String? templateCode,@JsonKey(name: 'params') Map<String, dynamic> params,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'readAt') DateTime? readAt,@JsonKey(name: 'deepLink') String? deepLink
});




}
/// @nodoc
class __$NotificationRecordCopyWithImpl<$Res>
    implements _$NotificationRecordCopyWith<$Res> {
  __$NotificationRecordCopyWithImpl(this._self, this._then);

  final _NotificationRecord _self;
  final $Res Function(_NotificationRecord) _then;

/// Create a copy of NotificationRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? tab = freezed,Object? category = freezed,Object? templateCode = freezed,Object? params = null,Object? createdAt = freezed,Object? readAt = freezed,Object? deepLink = freezed,}) {
  return _then(_NotificationRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,tab: freezed == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,templateCode: freezed == templateCode ? _self.templateCode : templateCode // ignore: cast_nullable_to_non_nullable
as String?,params: null == params ? _self._params : params // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deepLink: freezed == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
