// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'couple_week.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoupleWeek {

@JsonKey(name: 'start') DateTime get start;@JsonKey(name: 'end') DateTime get end;@JsonKey(name: 'headline') String get headline;@JsonKey(name: 'checkins') int get checkins;@JsonKey(name: 'requestsHelped') int get requestsHelped;@JsonKey(name: 'thanks') int get thanks;@JsonKey(name: 'togetherMissions') int get togetherMissions;@JsonKey(name: 'highlightThanks') String? get highlightThanks;@JsonKey(name: 'highlightByUserId') String? get highlightByUserId;@JsonKey(name: 'highlightAt') DateTime? get highlightAt;@JsonKey(name: 'together') List<CoupleWeekItem> get together;
/// Create a copy of CoupleWeek
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoupleWeekCopyWith<CoupleWeek> get copyWith => _$CoupleWeekCopyWithImpl<CoupleWeek>(this as CoupleWeek, _$identity);

  /// Serializes this CoupleWeek to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoupleWeek&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.checkins, checkins) || other.checkins == checkins)&&(identical(other.requestsHelped, requestsHelped) || other.requestsHelped == requestsHelped)&&(identical(other.thanks, thanks) || other.thanks == thanks)&&(identical(other.togetherMissions, togetherMissions) || other.togetherMissions == togetherMissions)&&(identical(other.highlightThanks, highlightThanks) || other.highlightThanks == highlightThanks)&&(identical(other.highlightByUserId, highlightByUserId) || other.highlightByUserId == highlightByUserId)&&(identical(other.highlightAt, highlightAt) || other.highlightAt == highlightAt)&&const DeepCollectionEquality().equals(other.together, together));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,end,headline,checkins,requestsHelped,thanks,togetherMissions,highlightThanks,highlightByUserId,highlightAt,const DeepCollectionEquality().hash(together));

@override
String toString() {
  return 'CoupleWeek(start: $start, end: $end, headline: $headline, checkins: $checkins, requestsHelped: $requestsHelped, thanks: $thanks, togetherMissions: $togetherMissions, highlightThanks: $highlightThanks, highlightByUserId: $highlightByUserId, highlightAt: $highlightAt, together: $together)';
}


}

/// @nodoc
abstract mixin class $CoupleWeekCopyWith<$Res>  {
  factory $CoupleWeekCopyWith(CoupleWeek value, $Res Function(CoupleWeek) _then) = _$CoupleWeekCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'start') DateTime start,@JsonKey(name: 'end') DateTime end,@JsonKey(name: 'headline') String headline,@JsonKey(name: 'checkins') int checkins,@JsonKey(name: 'requestsHelped') int requestsHelped,@JsonKey(name: 'thanks') int thanks,@JsonKey(name: 'togetherMissions') int togetherMissions,@JsonKey(name: 'highlightThanks') String? highlightThanks,@JsonKey(name: 'highlightByUserId') String? highlightByUserId,@JsonKey(name: 'highlightAt') DateTime? highlightAt,@JsonKey(name: 'together') List<CoupleWeekItem> together
});




}
/// @nodoc
class _$CoupleWeekCopyWithImpl<$Res>
    implements $CoupleWeekCopyWith<$Res> {
  _$CoupleWeekCopyWithImpl(this._self, this._then);

  final CoupleWeek _self;
  final $Res Function(CoupleWeek) _then;

/// Create a copy of CoupleWeek
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = null,Object? end = null,Object? headline = null,Object? checkins = null,Object? requestsHelped = null,Object? thanks = null,Object? togetherMissions = null,Object? highlightThanks = freezed,Object? highlightByUserId = freezed,Object? highlightAt = freezed,Object? together = null,}) {
  return _then(_self.copyWith(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,headline: null == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String,checkins: null == checkins ? _self.checkins : checkins // ignore: cast_nullable_to_non_nullable
as int,requestsHelped: null == requestsHelped ? _self.requestsHelped : requestsHelped // ignore: cast_nullable_to_non_nullable
as int,thanks: null == thanks ? _self.thanks : thanks // ignore: cast_nullable_to_non_nullable
as int,togetherMissions: null == togetherMissions ? _self.togetherMissions : togetherMissions // ignore: cast_nullable_to_non_nullable
as int,highlightThanks: freezed == highlightThanks ? _self.highlightThanks : highlightThanks // ignore: cast_nullable_to_non_nullable
as String?,highlightByUserId: freezed == highlightByUserId ? _self.highlightByUserId : highlightByUserId // ignore: cast_nullable_to_non_nullable
as String?,highlightAt: freezed == highlightAt ? _self.highlightAt : highlightAt // ignore: cast_nullable_to_non_nullable
as DateTime?,together: null == together ? _self.together : together // ignore: cast_nullable_to_non_nullable
as List<CoupleWeekItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [CoupleWeek].
extension CoupleWeekPatterns on CoupleWeek {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoupleWeek value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoupleWeek() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoupleWeek value)  $default,){
final _that = this;
switch (_that) {
case _CoupleWeek():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoupleWeek value)?  $default,){
final _that = this;
switch (_that) {
case _CoupleWeek() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CoupleWeek implements CoupleWeek {
  const _CoupleWeek({@JsonKey(name: 'start') required this.start, @JsonKey(name: 'end') required this.end, @JsonKey(name: 'headline') this.headline = '', @JsonKey(name: 'checkins') this.checkins = 0, @JsonKey(name: 'requestsHelped') this.requestsHelped = 0, @JsonKey(name: 'thanks') this.thanks = 0, @JsonKey(name: 'togetherMissions') this.togetherMissions = 0, @JsonKey(name: 'highlightThanks') this.highlightThanks, @JsonKey(name: 'highlightByUserId') this.highlightByUserId, @JsonKey(name: 'highlightAt') this.highlightAt, @JsonKey(name: 'together') final  List<CoupleWeekItem> together = const []}): _together = together;
  factory _CoupleWeek.fromJson(Map<String, dynamic> json) => _$CoupleWeekFromJson(json);

@override@JsonKey(name: 'start') final  DateTime start;
@override@JsonKey(name: 'end') final  DateTime end;
@override@JsonKey(name: 'headline') final  String headline;
@override@JsonKey(name: 'checkins') final  int checkins;
@override@JsonKey(name: 'requestsHelped') final  int requestsHelped;
@override@JsonKey(name: 'thanks') final  int thanks;
@override@JsonKey(name: 'togetherMissions') final  int togetherMissions;
@override@JsonKey(name: 'highlightThanks') final  String? highlightThanks;
@override@JsonKey(name: 'highlightByUserId') final  String? highlightByUserId;
@override@JsonKey(name: 'highlightAt') final  DateTime? highlightAt;
 final  List<CoupleWeekItem> _together;
@override@JsonKey(name: 'together') List<CoupleWeekItem> get together {
  if (_together is EqualUnmodifiableListView) return _together;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_together);
}


/// Create a copy of CoupleWeek
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoupleWeekCopyWith<_CoupleWeek> get copyWith => __$CoupleWeekCopyWithImpl<_CoupleWeek>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoupleWeekToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoupleWeek&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.checkins, checkins) || other.checkins == checkins)&&(identical(other.requestsHelped, requestsHelped) || other.requestsHelped == requestsHelped)&&(identical(other.thanks, thanks) || other.thanks == thanks)&&(identical(other.togetherMissions, togetherMissions) || other.togetherMissions == togetherMissions)&&(identical(other.highlightThanks, highlightThanks) || other.highlightThanks == highlightThanks)&&(identical(other.highlightByUserId, highlightByUserId) || other.highlightByUserId == highlightByUserId)&&(identical(other.highlightAt, highlightAt) || other.highlightAt == highlightAt)&&const DeepCollectionEquality().equals(other._together, _together));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,end,headline,checkins,requestsHelped,thanks,togetherMissions,highlightThanks,highlightByUserId,highlightAt,const DeepCollectionEquality().hash(_together));

@override
String toString() {
  return 'CoupleWeek(start: $start, end: $end, headline: $headline, checkins: $checkins, requestsHelped: $requestsHelped, thanks: $thanks, togetherMissions: $togetherMissions, highlightThanks: $highlightThanks, highlightByUserId: $highlightByUserId, highlightAt: $highlightAt, together: $together)';
}


}

/// @nodoc
abstract mixin class _$CoupleWeekCopyWith<$Res> implements $CoupleWeekCopyWith<$Res> {
  factory _$CoupleWeekCopyWith(_CoupleWeek value, $Res Function(_CoupleWeek) _then) = __$CoupleWeekCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'start') DateTime start,@JsonKey(name: 'end') DateTime end,@JsonKey(name: 'headline') String headline,@JsonKey(name: 'checkins') int checkins,@JsonKey(name: 'requestsHelped') int requestsHelped,@JsonKey(name: 'thanks') int thanks,@JsonKey(name: 'togetherMissions') int togetherMissions,@JsonKey(name: 'highlightThanks') String? highlightThanks,@JsonKey(name: 'highlightByUserId') String? highlightByUserId,@JsonKey(name: 'highlightAt') DateTime? highlightAt,@JsonKey(name: 'together') List<CoupleWeekItem> together
});




}
/// @nodoc
class __$CoupleWeekCopyWithImpl<$Res>
    implements _$CoupleWeekCopyWith<$Res> {
  __$CoupleWeekCopyWithImpl(this._self, this._then);

  final _CoupleWeek _self;
  final $Res Function(_CoupleWeek) _then;

/// Create a copy of CoupleWeek
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? start = null,Object? end = null,Object? headline = null,Object? checkins = null,Object? requestsHelped = null,Object? thanks = null,Object? togetherMissions = null,Object? highlightThanks = freezed,Object? highlightByUserId = freezed,Object? highlightAt = freezed,Object? together = null,}) {
  return _then(_CoupleWeek(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,headline: null == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String,checkins: null == checkins ? _self.checkins : checkins // ignore: cast_nullable_to_non_nullable
as int,requestsHelped: null == requestsHelped ? _self.requestsHelped : requestsHelped // ignore: cast_nullable_to_non_nullable
as int,thanks: null == thanks ? _self.thanks : thanks // ignore: cast_nullable_to_non_nullable
as int,togetherMissions: null == togetherMissions ? _self.togetherMissions : togetherMissions // ignore: cast_nullable_to_non_nullable
as int,highlightThanks: freezed == highlightThanks ? _self.highlightThanks : highlightThanks // ignore: cast_nullable_to_non_nullable
as String?,highlightByUserId: freezed == highlightByUserId ? _self.highlightByUserId : highlightByUserId // ignore: cast_nullable_to_non_nullable
as String?,highlightAt: freezed == highlightAt ? _self.highlightAt : highlightAt // ignore: cast_nullable_to_non_nullable
as DateTime?,together: null == together ? _self._together : together // ignore: cast_nullable_to_non_nullable
as List<CoupleWeekItem>,
  ));
}


}

// dart format on
