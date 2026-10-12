// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MissionTemplate {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'title') String get title;@JsonKey(name: 'category') MissionCategory get category;@JsonKey(name: 'hearts') int get hearts;@JsonKey(name: 'durationMin') int? get durationMin;@JsonKey(name: 'icon') String? get icon;@JsonKey(name: 'hint') String? get hint;@JsonKey(name: 'forPregnancy') bool get forPregnancy;@JsonKey(name: 'perChild') bool get perChild;
/// Create a copy of MissionTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MissionTemplateCopyWith<MissionTemplate> get copyWith => _$MissionTemplateCopyWithImpl<MissionTemplate>(this as MissionTemplate, _$identity);

  /// Serializes this MissionTemplate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MissionTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.hearts, hearts) || other.hearts == hearts)&&(identical(other.durationMin, durationMin) || other.durationMin == durationMin)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.hint, hint) || other.hint == hint)&&(identical(other.forPregnancy, forPregnancy) || other.forPregnancy == forPregnancy)&&(identical(other.perChild, perChild) || other.perChild == perChild));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,category,hearts,durationMin,icon,hint,forPregnancy,perChild);

@override
String toString() {
  return 'MissionTemplate(id: $id, title: $title, category: $category, hearts: $hearts, durationMin: $durationMin, icon: $icon, hint: $hint, forPregnancy: $forPregnancy, perChild: $perChild)';
}


}

/// @nodoc
abstract mixin class $MissionTemplateCopyWith<$Res>  {
  factory $MissionTemplateCopyWith(MissionTemplate value, $Res Function(MissionTemplate) _then) = _$MissionTemplateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'title') String title,@JsonKey(name: 'category') MissionCategory category,@JsonKey(name: 'hearts') int hearts,@JsonKey(name: 'durationMin') int? durationMin,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'hint') String? hint,@JsonKey(name: 'forPregnancy') bool forPregnancy,@JsonKey(name: 'perChild') bool perChild
});




}
/// @nodoc
class _$MissionTemplateCopyWithImpl<$Res>
    implements $MissionTemplateCopyWith<$Res> {
  _$MissionTemplateCopyWithImpl(this._self, this._then);

  final MissionTemplate _self;
  final $Res Function(MissionTemplate) _then;

/// Create a copy of MissionTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? category = null,Object? hearts = null,Object? durationMin = freezed,Object? icon = freezed,Object? hint = freezed,Object? forPregnancy = null,Object? perChild = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MissionCategory,hearts: null == hearts ? _self.hearts : hearts // ignore: cast_nullable_to_non_nullable
as int,durationMin: freezed == durationMin ? _self.durationMin : durationMin // ignore: cast_nullable_to_non_nullable
as int?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,hint: freezed == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as String?,forPregnancy: null == forPregnancy ? _self.forPregnancy : forPregnancy // ignore: cast_nullable_to_non_nullable
as bool,perChild: null == perChild ? _self.perChild : perChild // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MissionTemplate].
extension MissionTemplatePatterns on MissionTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MissionTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MissionTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MissionTemplate value)  $default,){
final _that = this;
switch (_that) {
case _MissionTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MissionTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _MissionTemplate() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MissionTemplate implements MissionTemplate {
  const _MissionTemplate({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'title') required this.title, @JsonKey(name: 'category') this.category = MissionCategory.care, @JsonKey(name: 'hearts') this.hearts = 0, @JsonKey(name: 'durationMin') this.durationMin, @JsonKey(name: 'icon') this.icon, @JsonKey(name: 'hint') this.hint, @JsonKey(name: 'forPregnancy') this.forPregnancy = false, @JsonKey(name: 'perChild') this.perChild = true});
  factory _MissionTemplate.fromJson(Map<String, dynamic> json) => _$MissionTemplateFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'category') final  MissionCategory category;
@override@JsonKey(name: 'hearts') final  int hearts;
@override@JsonKey(name: 'durationMin') final  int? durationMin;
@override@JsonKey(name: 'icon') final  String? icon;
@override@JsonKey(name: 'hint') final  String? hint;
@override@JsonKey(name: 'forPregnancy') final  bool forPregnancy;
@override@JsonKey(name: 'perChild') final  bool perChild;

/// Create a copy of MissionTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MissionTemplateCopyWith<_MissionTemplate> get copyWith => __$MissionTemplateCopyWithImpl<_MissionTemplate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MissionTemplateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MissionTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.hearts, hearts) || other.hearts == hearts)&&(identical(other.durationMin, durationMin) || other.durationMin == durationMin)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.hint, hint) || other.hint == hint)&&(identical(other.forPregnancy, forPregnancy) || other.forPregnancy == forPregnancy)&&(identical(other.perChild, perChild) || other.perChild == perChild));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,category,hearts,durationMin,icon,hint,forPregnancy,perChild);

@override
String toString() {
  return 'MissionTemplate(id: $id, title: $title, category: $category, hearts: $hearts, durationMin: $durationMin, icon: $icon, hint: $hint, forPregnancy: $forPregnancy, perChild: $perChild)';
}


}

/// @nodoc
abstract mixin class _$MissionTemplateCopyWith<$Res> implements $MissionTemplateCopyWith<$Res> {
  factory _$MissionTemplateCopyWith(_MissionTemplate value, $Res Function(_MissionTemplate) _then) = __$MissionTemplateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'title') String title,@JsonKey(name: 'category') MissionCategory category,@JsonKey(name: 'hearts') int hearts,@JsonKey(name: 'durationMin') int? durationMin,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'hint') String? hint,@JsonKey(name: 'forPregnancy') bool forPregnancy,@JsonKey(name: 'perChild') bool perChild
});




}
/// @nodoc
class __$MissionTemplateCopyWithImpl<$Res>
    implements _$MissionTemplateCopyWith<$Res> {
  __$MissionTemplateCopyWithImpl(this._self, this._then);

  final _MissionTemplate _self;
  final $Res Function(_MissionTemplate) _then;

/// Create a copy of MissionTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? category = null,Object? hearts = null,Object? durationMin = freezed,Object? icon = freezed,Object? hint = freezed,Object? forPregnancy = null,Object? perChild = null,}) {
  return _then(_MissionTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MissionCategory,hearts: null == hearts ? _self.hearts : hearts // ignore: cast_nullable_to_non_nullable
as int,durationMin: freezed == durationMin ? _self.durationMin : durationMin // ignore: cast_nullable_to_non_nullable
as int?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,hint: freezed == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as String?,forPregnancy: null == forPregnancy ? _self.forPregnancy : forPregnancy // ignore: cast_nullable_to_non_nullable
as bool,perChild: null == perChild ? _self.perChild : perChild // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
