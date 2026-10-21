// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_family_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MyFamilyRecord {

@JsonKey(name: 'familyId') String? get familyId;@JsonKey(name: 'name') String? get name;@JsonKey(name: 'role') String? get role;@JsonKey(name: 'status') MyFamilyStatusRecord? get status;@JsonKey(name: 'coverUrl') String? get coverUrl;@JsonKey(name: 'isDefault') bool get isDefault;
/// Create a copy of MyFamilyRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyFamilyRecordCopyWith<MyFamilyRecord> get copyWith => _$MyFamilyRecordCopyWithImpl<MyFamilyRecord>(this as MyFamilyRecord, _$identity);

  /// Serializes this MyFamilyRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyFamilyRecord&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,familyId,name,role,status,coverUrl,isDefault);

@override
String toString() {
  return 'MyFamilyRecord(familyId: $familyId, name: $name, role: $role, status: $status, coverUrl: $coverUrl, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class $MyFamilyRecordCopyWith<$Res>  {
  factory $MyFamilyRecordCopyWith(MyFamilyRecord value, $Res Function(MyFamilyRecord) _then) = _$MyFamilyRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'familyId') String? familyId,@JsonKey(name: 'name') String? name,@JsonKey(name: 'role') String? role,@JsonKey(name: 'status') MyFamilyStatusRecord? status,@JsonKey(name: 'coverUrl') String? coverUrl,@JsonKey(name: 'isDefault') bool isDefault
});


$MyFamilyStatusRecordCopyWith<$Res>? get status;

}
/// @nodoc
class _$MyFamilyRecordCopyWithImpl<$Res>
    implements $MyFamilyRecordCopyWith<$Res> {
  _$MyFamilyRecordCopyWithImpl(this._self, this._then);

  final MyFamilyRecord _self;
  final $Res Function(MyFamilyRecord) _then;

/// Create a copy of MyFamilyRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? familyId = freezed,Object? name = freezed,Object? role = freezed,Object? status = freezed,Object? coverUrl = freezed,Object? isDefault = null,}) {
  return _then(_self.copyWith(
familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MyFamilyStatusRecord?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of MyFamilyRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyFamilyStatusRecordCopyWith<$Res>? get status {
    if (_self.status == null) {
    return null;
  }

  return $MyFamilyStatusRecordCopyWith<$Res>(_self.status!, (value) {
    return _then(_self.copyWith(status: value));
  });
}
}


/// Adds pattern-matching-related methods to [MyFamilyRecord].
extension MyFamilyRecordPatterns on MyFamilyRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyFamilyRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyFamilyRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyFamilyRecord value)  $default,){
final _that = this;
switch (_that) {
case _MyFamilyRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyFamilyRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MyFamilyRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MyFamilyRecord implements MyFamilyRecord {
  const _MyFamilyRecord({@JsonKey(name: 'familyId') this.familyId, @JsonKey(name: 'name') this.name, @JsonKey(name: 'role') this.role, @JsonKey(name: 'status') this.status, @JsonKey(name: 'coverUrl') this.coverUrl, @JsonKey(name: 'isDefault') this.isDefault = false});
  factory _MyFamilyRecord.fromJson(Map<String, dynamic> json) => _$MyFamilyRecordFromJson(json);

@override@JsonKey(name: 'familyId') final  String? familyId;
@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'role') final  String? role;
@override@JsonKey(name: 'status') final  MyFamilyStatusRecord? status;
@override@JsonKey(name: 'coverUrl') final  String? coverUrl;
@override@JsonKey(name: 'isDefault') final  bool isDefault;

/// Create a copy of MyFamilyRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyFamilyRecordCopyWith<_MyFamilyRecord> get copyWith => __$MyFamilyRecordCopyWithImpl<_MyFamilyRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyFamilyRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyFamilyRecord&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,familyId,name,role,status,coverUrl,isDefault);

@override
String toString() {
  return 'MyFamilyRecord(familyId: $familyId, name: $name, role: $role, status: $status, coverUrl: $coverUrl, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$MyFamilyRecordCopyWith<$Res> implements $MyFamilyRecordCopyWith<$Res> {
  factory _$MyFamilyRecordCopyWith(_MyFamilyRecord value, $Res Function(_MyFamilyRecord) _then) = __$MyFamilyRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'familyId') String? familyId,@JsonKey(name: 'name') String? name,@JsonKey(name: 'role') String? role,@JsonKey(name: 'status') MyFamilyStatusRecord? status,@JsonKey(name: 'coverUrl') String? coverUrl,@JsonKey(name: 'isDefault') bool isDefault
});


@override $MyFamilyStatusRecordCopyWith<$Res>? get status;

}
/// @nodoc
class __$MyFamilyRecordCopyWithImpl<$Res>
    implements _$MyFamilyRecordCopyWith<$Res> {
  __$MyFamilyRecordCopyWithImpl(this._self, this._then);

  final _MyFamilyRecord _self;
  final $Res Function(_MyFamilyRecord) _then;

/// Create a copy of MyFamilyRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? familyId = freezed,Object? name = freezed,Object? role = freezed,Object? status = freezed,Object? coverUrl = freezed,Object? isDefault = null,}) {
  return _then(_MyFamilyRecord(
familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MyFamilyStatusRecord?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of MyFamilyRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyFamilyStatusRecordCopyWith<$Res>? get status {
    if (_self.status == null) {
    return null;
  }

  return $MyFamilyStatusRecordCopyWith<$Res>(_self.status!, (value) {
    return _then(_self.copyWith(status: value));
  });
}
}


/// @nodoc
mixin _$MyFamilyStatusRecord {

@JsonKey(name: 'family') String? get family;@JsonKey(name: 'membership') String? get membership;
/// Create a copy of MyFamilyStatusRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyFamilyStatusRecordCopyWith<MyFamilyStatusRecord> get copyWith => _$MyFamilyStatusRecordCopyWithImpl<MyFamilyStatusRecord>(this as MyFamilyStatusRecord, _$identity);

  /// Serializes this MyFamilyStatusRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyFamilyStatusRecord&&(identical(other.family, family) || other.family == family)&&(identical(other.membership, membership) || other.membership == membership));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,family,membership);

@override
String toString() {
  return 'MyFamilyStatusRecord(family: $family, membership: $membership)';
}


}

/// @nodoc
abstract mixin class $MyFamilyStatusRecordCopyWith<$Res>  {
  factory $MyFamilyStatusRecordCopyWith(MyFamilyStatusRecord value, $Res Function(MyFamilyStatusRecord) _then) = _$MyFamilyStatusRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'family') String? family,@JsonKey(name: 'membership') String? membership
});




}
/// @nodoc
class _$MyFamilyStatusRecordCopyWithImpl<$Res>
    implements $MyFamilyStatusRecordCopyWith<$Res> {
  _$MyFamilyStatusRecordCopyWithImpl(this._self, this._then);

  final MyFamilyStatusRecord _self;
  final $Res Function(MyFamilyStatusRecord) _then;

/// Create a copy of MyFamilyStatusRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? family = freezed,Object? membership = freezed,}) {
  return _then(_self.copyWith(
family: freezed == family ? _self.family : family // ignore: cast_nullable_to_non_nullable
as String?,membership: freezed == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MyFamilyStatusRecord].
extension MyFamilyStatusRecordPatterns on MyFamilyStatusRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyFamilyStatusRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyFamilyStatusRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyFamilyStatusRecord value)  $default,){
final _that = this;
switch (_that) {
case _MyFamilyStatusRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyFamilyStatusRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MyFamilyStatusRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MyFamilyStatusRecord implements MyFamilyStatusRecord {
  const _MyFamilyStatusRecord({@JsonKey(name: 'family') this.family, @JsonKey(name: 'membership') this.membership});
  factory _MyFamilyStatusRecord.fromJson(Map<String, dynamic> json) => _$MyFamilyStatusRecordFromJson(json);

@override@JsonKey(name: 'family') final  String? family;
@override@JsonKey(name: 'membership') final  String? membership;

/// Create a copy of MyFamilyStatusRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyFamilyStatusRecordCopyWith<_MyFamilyStatusRecord> get copyWith => __$MyFamilyStatusRecordCopyWithImpl<_MyFamilyStatusRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyFamilyStatusRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyFamilyStatusRecord&&(identical(other.family, family) || other.family == family)&&(identical(other.membership, membership) || other.membership == membership));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,family,membership);

@override
String toString() {
  return 'MyFamilyStatusRecord(family: $family, membership: $membership)';
}


}

/// @nodoc
abstract mixin class _$MyFamilyStatusRecordCopyWith<$Res> implements $MyFamilyStatusRecordCopyWith<$Res> {
  factory _$MyFamilyStatusRecordCopyWith(_MyFamilyStatusRecord value, $Res Function(_MyFamilyStatusRecord) _then) = __$MyFamilyStatusRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'family') String? family,@JsonKey(name: 'membership') String? membership
});




}
/// @nodoc
class __$MyFamilyStatusRecordCopyWithImpl<$Res>
    implements _$MyFamilyStatusRecordCopyWith<$Res> {
  __$MyFamilyStatusRecordCopyWithImpl(this._self, this._then);

  final _MyFamilyStatusRecord _self;
  final $Res Function(_MyFamilyStatusRecord) _then;

/// Create a copy of MyFamilyStatusRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? family = freezed,Object? membership = freezed,}) {
  return _then(_MyFamilyStatusRecord(
family: freezed == family ? _self.family : family // ignore: cast_nullable_to_non_nullable
as String?,membership: freezed == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MyFamilyList {

@JsonKey(name: 'items') List<MyFamilyRecord> get items;
/// Create a copy of MyFamilyList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyFamilyListCopyWith<MyFamilyList> get copyWith => _$MyFamilyListCopyWithImpl<MyFamilyList>(this as MyFamilyList, _$identity);

  /// Serializes this MyFamilyList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyFamilyList&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'MyFamilyList(items: $items)';
}


}

/// @nodoc
abstract mixin class $MyFamilyListCopyWith<$Res>  {
  factory $MyFamilyListCopyWith(MyFamilyList value, $Res Function(MyFamilyList) _then) = _$MyFamilyListCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'items') List<MyFamilyRecord> items
});




}
/// @nodoc
class _$MyFamilyListCopyWithImpl<$Res>
    implements $MyFamilyListCopyWith<$Res> {
  _$MyFamilyListCopyWithImpl(this._self, this._then);

  final MyFamilyList _self;
  final $Res Function(MyFamilyList) _then;

/// Create a copy of MyFamilyList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MyFamilyRecord>,
  ));
}

}


/// Adds pattern-matching-related methods to [MyFamilyList].
extension MyFamilyListPatterns on MyFamilyList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyFamilyList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyFamilyList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyFamilyList value)  $default,){
final _that = this;
switch (_that) {
case _MyFamilyList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyFamilyList value)?  $default,){
final _that = this;
switch (_that) {
case _MyFamilyList() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MyFamilyList implements MyFamilyList {
  const _MyFamilyList({@JsonKey(name: 'items') final  List<MyFamilyRecord> items = const <MyFamilyRecord>[]}): _items = items;
  factory _MyFamilyList.fromJson(Map<String, dynamic> json) => _$MyFamilyListFromJson(json);

 final  List<MyFamilyRecord> _items;
@override@JsonKey(name: 'items') List<MyFamilyRecord> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of MyFamilyList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyFamilyListCopyWith<_MyFamilyList> get copyWith => __$MyFamilyListCopyWithImpl<_MyFamilyList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyFamilyListToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyFamilyList&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'MyFamilyList(items: $items)';
}


}

/// @nodoc
abstract mixin class _$MyFamilyListCopyWith<$Res> implements $MyFamilyListCopyWith<$Res> {
  factory _$MyFamilyListCopyWith(_MyFamilyList value, $Res Function(_MyFamilyList) _then) = __$MyFamilyListCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'items') List<MyFamilyRecord> items
});




}
/// @nodoc
class __$MyFamilyListCopyWithImpl<$Res>
    implements _$MyFamilyListCopyWith<$Res> {
  __$MyFamilyListCopyWithImpl(this._self, this._then);

  final _MyFamilyList _self;
  final $Res Function(_MyFamilyList) _then;

/// Create a copy of MyFamilyList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_MyFamilyList(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MyFamilyRecord>,
  ));
}


}

// dart format on
