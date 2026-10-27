// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pregnancy_name_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PregnancyNameRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'name') String? get name;@JsonKey(name: 'meaning') String? get meaning;@JsonKey(name: 'addedByUserId') String? get addedByUserId;@JsonKey(name: 'likedByMe') bool get likedByMe;@JsonKey(name: 'likedByPartner') bool get likedByPartner;@JsonKey(name: 'chosen') bool get chosen;@JsonKey(name: 'createdAt') DateTime? get createdAt;
/// Create a copy of PregnancyNameRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PregnancyNameRecordCopyWith<PregnancyNameRecord> get copyWith => _$PregnancyNameRecordCopyWithImpl<PregnancyNameRecord>(this as PregnancyNameRecord, _$identity);

  /// Serializes this PregnancyNameRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PregnancyNameRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.meaning, meaning) || other.meaning == meaning)&&(identical(other.addedByUserId, addedByUserId) || other.addedByUserId == addedByUserId)&&(identical(other.likedByMe, likedByMe) || other.likedByMe == likedByMe)&&(identical(other.likedByPartner, likedByPartner) || other.likedByPartner == likedByPartner)&&(identical(other.chosen, chosen) || other.chosen == chosen)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,meaning,addedByUserId,likedByMe,likedByPartner,chosen,createdAt);

@override
String toString() {
  return 'PregnancyNameRecord(id: $id, name: $name, meaning: $meaning, addedByUserId: $addedByUserId, likedByMe: $likedByMe, likedByPartner: $likedByPartner, chosen: $chosen, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PregnancyNameRecordCopyWith<$Res>  {
  factory $PregnancyNameRecordCopyWith(PregnancyNameRecord value, $Res Function(PregnancyNameRecord) _then) = _$PregnancyNameRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'name') String? name,@JsonKey(name: 'meaning') String? meaning,@JsonKey(name: 'addedByUserId') String? addedByUserId,@JsonKey(name: 'likedByMe') bool likedByMe,@JsonKey(name: 'likedByPartner') bool likedByPartner,@JsonKey(name: 'chosen') bool chosen,@JsonKey(name: 'createdAt') DateTime? createdAt
});




}
/// @nodoc
class _$PregnancyNameRecordCopyWithImpl<$Res>
    implements $PregnancyNameRecordCopyWith<$Res> {
  _$PregnancyNameRecordCopyWithImpl(this._self, this._then);

  final PregnancyNameRecord _self;
  final $Res Function(PregnancyNameRecord) _then;

/// Create a copy of PregnancyNameRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? meaning = freezed,Object? addedByUserId = freezed,Object? likedByMe = null,Object? likedByPartner = null,Object? chosen = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,meaning: freezed == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String?,addedByUserId: freezed == addedByUserId ? _self.addedByUserId : addedByUserId // ignore: cast_nullable_to_non_nullable
as String?,likedByMe: null == likedByMe ? _self.likedByMe : likedByMe // ignore: cast_nullable_to_non_nullable
as bool,likedByPartner: null == likedByPartner ? _self.likedByPartner : likedByPartner // ignore: cast_nullable_to_non_nullable
as bool,chosen: null == chosen ? _self.chosen : chosen // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PregnancyNameRecord].
extension PregnancyNameRecordPatterns on PregnancyNameRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PregnancyNameRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PregnancyNameRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PregnancyNameRecord value)  $default,){
final _that = this;
switch (_that) {
case _PregnancyNameRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PregnancyNameRecord value)?  $default,){
final _that = this;
switch (_that) {
case _PregnancyNameRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PregnancyNameRecord implements PregnancyNameRecord {
  const _PregnancyNameRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'name') this.name, @JsonKey(name: 'meaning') this.meaning, @JsonKey(name: 'addedByUserId') this.addedByUserId, @JsonKey(name: 'likedByMe') this.likedByMe = false, @JsonKey(name: 'likedByPartner') this.likedByPartner = false, @JsonKey(name: 'chosen') this.chosen = false, @JsonKey(name: 'createdAt') this.createdAt});
  factory _PregnancyNameRecord.fromJson(Map<String, dynamic> json) => _$PregnancyNameRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'meaning') final  String? meaning;
@override@JsonKey(name: 'addedByUserId') final  String? addedByUserId;
@override@JsonKey(name: 'likedByMe') final  bool likedByMe;
@override@JsonKey(name: 'likedByPartner') final  bool likedByPartner;
@override@JsonKey(name: 'chosen') final  bool chosen;
@override@JsonKey(name: 'createdAt') final  DateTime? createdAt;

/// Create a copy of PregnancyNameRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PregnancyNameRecordCopyWith<_PregnancyNameRecord> get copyWith => __$PregnancyNameRecordCopyWithImpl<_PregnancyNameRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PregnancyNameRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PregnancyNameRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.meaning, meaning) || other.meaning == meaning)&&(identical(other.addedByUserId, addedByUserId) || other.addedByUserId == addedByUserId)&&(identical(other.likedByMe, likedByMe) || other.likedByMe == likedByMe)&&(identical(other.likedByPartner, likedByPartner) || other.likedByPartner == likedByPartner)&&(identical(other.chosen, chosen) || other.chosen == chosen)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,meaning,addedByUserId,likedByMe,likedByPartner,chosen,createdAt);

@override
String toString() {
  return 'PregnancyNameRecord(id: $id, name: $name, meaning: $meaning, addedByUserId: $addedByUserId, likedByMe: $likedByMe, likedByPartner: $likedByPartner, chosen: $chosen, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PregnancyNameRecordCopyWith<$Res> implements $PregnancyNameRecordCopyWith<$Res> {
  factory _$PregnancyNameRecordCopyWith(_PregnancyNameRecord value, $Res Function(_PregnancyNameRecord) _then) = __$PregnancyNameRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'name') String? name,@JsonKey(name: 'meaning') String? meaning,@JsonKey(name: 'addedByUserId') String? addedByUserId,@JsonKey(name: 'likedByMe') bool likedByMe,@JsonKey(name: 'likedByPartner') bool likedByPartner,@JsonKey(name: 'chosen') bool chosen,@JsonKey(name: 'createdAt') DateTime? createdAt
});




}
/// @nodoc
class __$PregnancyNameRecordCopyWithImpl<$Res>
    implements _$PregnancyNameRecordCopyWith<$Res> {
  __$PregnancyNameRecordCopyWithImpl(this._self, this._then);

  final _PregnancyNameRecord _self;
  final $Res Function(_PregnancyNameRecord) _then;

/// Create a copy of PregnancyNameRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? meaning = freezed,Object? addedByUserId = freezed,Object? likedByMe = null,Object? likedByPartner = null,Object? chosen = null,Object? createdAt = freezed,}) {
  return _then(_PregnancyNameRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,meaning: freezed == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String?,addedByUserId: freezed == addedByUserId ? _self.addedByUserId : addedByUserId // ignore: cast_nullable_to_non_nullable
as String?,likedByMe: null == likedByMe ? _self.likedByMe : likedByMe // ignore: cast_nullable_to_non_nullable
as bool,likedByPartner: null == likedByPartner ? _self.likedByPartner : likedByPartner // ignore: cast_nullable_to_non_nullable
as bool,chosen: null == chosen ? _self.chosen : chosen // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$PregnancyNameList {

@JsonKey(name: 'items', fromJson: _nameItems) List<PregnancyNameRecord> get items;@JsonKey(name: 'chosenLimit') int get chosenLimit;
/// Create a copy of PregnancyNameList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PregnancyNameListCopyWith<PregnancyNameList> get copyWith => _$PregnancyNameListCopyWithImpl<PregnancyNameList>(this as PregnancyNameList, _$identity);

  /// Serializes this PregnancyNameList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PregnancyNameList&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.chosenLimit, chosenLimit) || other.chosenLimit == chosenLimit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),chosenLimit);

@override
String toString() {
  return 'PregnancyNameList(items: $items, chosenLimit: $chosenLimit)';
}


}

/// @nodoc
abstract mixin class $PregnancyNameListCopyWith<$Res>  {
  factory $PregnancyNameListCopyWith(PregnancyNameList value, $Res Function(PregnancyNameList) _then) = _$PregnancyNameListCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'items', fromJson: _nameItems) List<PregnancyNameRecord> items,@JsonKey(name: 'chosenLimit') int chosenLimit
});




}
/// @nodoc
class _$PregnancyNameListCopyWithImpl<$Res>
    implements $PregnancyNameListCopyWith<$Res> {
  _$PregnancyNameListCopyWithImpl(this._self, this._then);

  final PregnancyNameList _self;
  final $Res Function(PregnancyNameList) _then;

/// Create a copy of PregnancyNameList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? chosenLimit = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<PregnancyNameRecord>,chosenLimit: null == chosenLimit ? _self.chosenLimit : chosenLimit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PregnancyNameList].
extension PregnancyNameListPatterns on PregnancyNameList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PregnancyNameList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PregnancyNameList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PregnancyNameList value)  $default,){
final _that = this;
switch (_that) {
case _PregnancyNameList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PregnancyNameList value)?  $default,){
final _that = this;
switch (_that) {
case _PregnancyNameList() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PregnancyNameList implements PregnancyNameList {
  const _PregnancyNameList({@JsonKey(name: 'items', fromJson: _nameItems) final  List<PregnancyNameRecord> items = const <PregnancyNameRecord>[], @JsonKey(name: 'chosenLimit') this.chosenLimit = 1}): _items = items;
  factory _PregnancyNameList.fromJson(Map<String, dynamic> json) => _$PregnancyNameListFromJson(json);

 final  List<PregnancyNameRecord> _items;
@override@JsonKey(name: 'items', fromJson: _nameItems) List<PregnancyNameRecord> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'chosenLimit') final  int chosenLimit;

/// Create a copy of PregnancyNameList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PregnancyNameListCopyWith<_PregnancyNameList> get copyWith => __$PregnancyNameListCopyWithImpl<_PregnancyNameList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PregnancyNameListToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PregnancyNameList&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.chosenLimit, chosenLimit) || other.chosenLimit == chosenLimit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),chosenLimit);

@override
String toString() {
  return 'PregnancyNameList(items: $items, chosenLimit: $chosenLimit)';
}


}

/// @nodoc
abstract mixin class _$PregnancyNameListCopyWith<$Res> implements $PregnancyNameListCopyWith<$Res> {
  factory _$PregnancyNameListCopyWith(_PregnancyNameList value, $Res Function(_PregnancyNameList) _then) = __$PregnancyNameListCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'items', fromJson: _nameItems) List<PregnancyNameRecord> items,@JsonKey(name: 'chosenLimit') int chosenLimit
});




}
/// @nodoc
class __$PregnancyNameListCopyWithImpl<$Res>
    implements _$PregnancyNameListCopyWith<$Res> {
  __$PregnancyNameListCopyWithImpl(this._self, this._then);

  final _PregnancyNameList _self;
  final $Res Function(_PregnancyNameList) _then;

/// Create a copy of PregnancyNameList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? chosenLimit = null,}) {
  return _then(_PregnancyNameList(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<PregnancyNameRecord>,chosenLimit: null == chosenLimit ? _self.chosenLimit : chosenLimit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
