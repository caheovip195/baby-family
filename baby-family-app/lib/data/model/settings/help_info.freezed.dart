// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'help_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HelpInfo {

@JsonKey(name: 'faqs') List<String> get faqs;@JsonKey(name: 'openReports') int get openReports;@JsonKey(name: 'email') String get email;@JsonKey(name: 'hotline') String get hotline;/// Câu trả lời cùng thứ tự với [faqs] (bản server); rỗng ở bản mẫu.
@JsonKey(name: 'faqAnswers') List<String> get faqAnswers;/// SET-12 đường dẫn pháp lý (bản server, khi đã cấu hình).
@JsonKey(name: 'termsUrl') String? get termsUrl;@JsonKey(name: 'privacyUrl') String? get privacyUrl;
/// Create a copy of HelpInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HelpInfoCopyWith<HelpInfo> get copyWith => _$HelpInfoCopyWithImpl<HelpInfo>(this as HelpInfo, _$identity);

  /// Serializes this HelpInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HelpInfo&&const DeepCollectionEquality().equals(other.faqs, faqs)&&(identical(other.openReports, openReports) || other.openReports == openReports)&&(identical(other.email, email) || other.email == email)&&(identical(other.hotline, hotline) || other.hotline == hotline)&&const DeepCollectionEquality().equals(other.faqAnswers, faqAnswers)&&(identical(other.termsUrl, termsUrl) || other.termsUrl == termsUrl)&&(identical(other.privacyUrl, privacyUrl) || other.privacyUrl == privacyUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(faqs),openReports,email,hotline,const DeepCollectionEquality().hash(faqAnswers),termsUrl,privacyUrl);

@override
String toString() {
  return 'HelpInfo(faqs: $faqs, openReports: $openReports, email: $email, hotline: $hotline, faqAnswers: $faqAnswers, termsUrl: $termsUrl, privacyUrl: $privacyUrl)';
}


}

/// @nodoc
abstract mixin class $HelpInfoCopyWith<$Res>  {
  factory $HelpInfoCopyWith(HelpInfo value, $Res Function(HelpInfo) _then) = _$HelpInfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'faqs') List<String> faqs,@JsonKey(name: 'openReports') int openReports,@JsonKey(name: 'email') String email,@JsonKey(name: 'hotline') String hotline,@JsonKey(name: 'faqAnswers') List<String> faqAnswers,@JsonKey(name: 'termsUrl') String? termsUrl,@JsonKey(name: 'privacyUrl') String? privacyUrl
});




}
/// @nodoc
class _$HelpInfoCopyWithImpl<$Res>
    implements $HelpInfoCopyWith<$Res> {
  _$HelpInfoCopyWithImpl(this._self, this._then);

  final HelpInfo _self;
  final $Res Function(HelpInfo) _then;

/// Create a copy of HelpInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? faqs = null,Object? openReports = null,Object? email = null,Object? hotline = null,Object? faqAnswers = null,Object? termsUrl = freezed,Object? privacyUrl = freezed,}) {
  return _then(_self.copyWith(
faqs: null == faqs ? _self.faqs : faqs // ignore: cast_nullable_to_non_nullable
as List<String>,openReports: null == openReports ? _self.openReports : openReports // ignore: cast_nullable_to_non_nullable
as int,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,hotline: null == hotline ? _self.hotline : hotline // ignore: cast_nullable_to_non_nullable
as String,faqAnswers: null == faqAnswers ? _self.faqAnswers : faqAnswers // ignore: cast_nullable_to_non_nullable
as List<String>,termsUrl: freezed == termsUrl ? _self.termsUrl : termsUrl // ignore: cast_nullable_to_non_nullable
as String?,privacyUrl: freezed == privacyUrl ? _self.privacyUrl : privacyUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HelpInfo].
extension HelpInfoPatterns on HelpInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HelpInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HelpInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HelpInfo value)  $default,){
final _that = this;
switch (_that) {
case _HelpInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HelpInfo value)?  $default,){
final _that = this;
switch (_that) {
case _HelpInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _HelpInfo implements HelpInfo {
  const _HelpInfo({@JsonKey(name: 'faqs') final  List<String> faqs = const [], @JsonKey(name: 'openReports') this.openReports = 0, @JsonKey(name: 'email') this.email = '', @JsonKey(name: 'hotline') this.hotline = '', @JsonKey(name: 'faqAnswers') final  List<String> faqAnswers = const [], @JsonKey(name: 'termsUrl') this.termsUrl, @JsonKey(name: 'privacyUrl') this.privacyUrl}): _faqs = faqs,_faqAnswers = faqAnswers;
  factory _HelpInfo.fromJson(Map<String, dynamic> json) => _$HelpInfoFromJson(json);

 final  List<String> _faqs;
@override@JsonKey(name: 'faqs') List<String> get faqs {
  if (_faqs is EqualUnmodifiableListView) return _faqs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_faqs);
}

@override@JsonKey(name: 'openReports') final  int openReports;
@override@JsonKey(name: 'email') final  String email;
@override@JsonKey(name: 'hotline') final  String hotline;
/// Câu trả lời cùng thứ tự với [faqs] (bản server); rỗng ở bản mẫu.
 final  List<String> _faqAnswers;
/// Câu trả lời cùng thứ tự với [faqs] (bản server); rỗng ở bản mẫu.
@override@JsonKey(name: 'faqAnswers') List<String> get faqAnswers {
  if (_faqAnswers is EqualUnmodifiableListView) return _faqAnswers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_faqAnswers);
}

/// SET-12 đường dẫn pháp lý (bản server, khi đã cấu hình).
@override@JsonKey(name: 'termsUrl') final  String? termsUrl;
@override@JsonKey(name: 'privacyUrl') final  String? privacyUrl;

/// Create a copy of HelpInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HelpInfoCopyWith<_HelpInfo> get copyWith => __$HelpInfoCopyWithImpl<_HelpInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HelpInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HelpInfo&&const DeepCollectionEquality().equals(other._faqs, _faqs)&&(identical(other.openReports, openReports) || other.openReports == openReports)&&(identical(other.email, email) || other.email == email)&&(identical(other.hotline, hotline) || other.hotline == hotline)&&const DeepCollectionEquality().equals(other._faqAnswers, _faqAnswers)&&(identical(other.termsUrl, termsUrl) || other.termsUrl == termsUrl)&&(identical(other.privacyUrl, privacyUrl) || other.privacyUrl == privacyUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_faqs),openReports,email,hotline,const DeepCollectionEquality().hash(_faqAnswers),termsUrl,privacyUrl);

@override
String toString() {
  return 'HelpInfo(faqs: $faqs, openReports: $openReports, email: $email, hotline: $hotline, faqAnswers: $faqAnswers, termsUrl: $termsUrl, privacyUrl: $privacyUrl)';
}


}

/// @nodoc
abstract mixin class _$HelpInfoCopyWith<$Res> implements $HelpInfoCopyWith<$Res> {
  factory _$HelpInfoCopyWith(_HelpInfo value, $Res Function(_HelpInfo) _then) = __$HelpInfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'faqs') List<String> faqs,@JsonKey(name: 'openReports') int openReports,@JsonKey(name: 'email') String email,@JsonKey(name: 'hotline') String hotline,@JsonKey(name: 'faqAnswers') List<String> faqAnswers,@JsonKey(name: 'termsUrl') String? termsUrl,@JsonKey(name: 'privacyUrl') String? privacyUrl
});




}
/// @nodoc
class __$HelpInfoCopyWithImpl<$Res>
    implements _$HelpInfoCopyWith<$Res> {
  __$HelpInfoCopyWithImpl(this._self, this._then);

  final _HelpInfo _self;
  final $Res Function(_HelpInfo) _then;

/// Create a copy of HelpInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? faqs = null,Object? openReports = null,Object? email = null,Object? hotline = null,Object? faqAnswers = null,Object? termsUrl = freezed,Object? privacyUrl = freezed,}) {
  return _then(_HelpInfo(
faqs: null == faqs ? _self._faqs : faqs // ignore: cast_nullable_to_non_nullable
as List<String>,openReports: null == openReports ? _self.openReports : openReports // ignore: cast_nullable_to_non_nullable
as int,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,hotline: null == hotline ? _self.hotline : hotline // ignore: cast_nullable_to_non_nullable
as String,faqAnswers: null == faqAnswers ? _self._faqAnswers : faqAnswers // ignore: cast_nullable_to_non_nullable
as List<String>,termsUrl: freezed == termsUrl ? _self.termsUrl : termsUrl // ignore: cast_nullable_to_non_nullable
as String?,privacyUrl: freezed == privacyUrl ? _self.privacyUrl : privacyUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
