// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'help_center_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HelpCenterRecord {

@JsonKey(name: 'version') int? get version;@JsonKey(name: 'faqs') List<HelpFaqRecord> get faqs;@JsonKey(name: 'contact') HelpContactRecord? get contact;@JsonKey(name: 'legal') HelpLegalRecord? get legal;
/// Create a copy of HelpCenterRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HelpCenterRecordCopyWith<HelpCenterRecord> get copyWith => _$HelpCenterRecordCopyWithImpl<HelpCenterRecord>(this as HelpCenterRecord, _$identity);

  /// Serializes this HelpCenterRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HelpCenterRecord&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.faqs, faqs)&&(identical(other.contact, contact) || other.contact == contact)&&(identical(other.legal, legal) || other.legal == legal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(faqs),contact,legal);

@override
String toString() {
  return 'HelpCenterRecord(version: $version, faqs: $faqs, contact: $contact, legal: $legal)';
}


}

/// @nodoc
abstract mixin class $HelpCenterRecordCopyWith<$Res>  {
  factory $HelpCenterRecordCopyWith(HelpCenterRecord value, $Res Function(HelpCenterRecord) _then) = _$HelpCenterRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'version') int? version,@JsonKey(name: 'faqs') List<HelpFaqRecord> faqs,@JsonKey(name: 'contact') HelpContactRecord? contact,@JsonKey(name: 'legal') HelpLegalRecord? legal
});


$HelpContactRecordCopyWith<$Res>? get contact;$HelpLegalRecordCopyWith<$Res>? get legal;

}
/// @nodoc
class _$HelpCenterRecordCopyWithImpl<$Res>
    implements $HelpCenterRecordCopyWith<$Res> {
  _$HelpCenterRecordCopyWithImpl(this._self, this._then);

  final HelpCenterRecord _self;
  final $Res Function(HelpCenterRecord) _then;

/// Create a copy of HelpCenterRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = freezed,Object? faqs = null,Object? contact = freezed,Object? legal = freezed,}) {
  return _then(_self.copyWith(
version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int?,faqs: null == faqs ? _self.faqs : faqs // ignore: cast_nullable_to_non_nullable
as List<HelpFaqRecord>,contact: freezed == contact ? _self.contact : contact // ignore: cast_nullable_to_non_nullable
as HelpContactRecord?,legal: freezed == legal ? _self.legal : legal // ignore: cast_nullable_to_non_nullable
as HelpLegalRecord?,
  ));
}
/// Create a copy of HelpCenterRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HelpContactRecordCopyWith<$Res>? get contact {
    if (_self.contact == null) {
    return null;
  }

  return $HelpContactRecordCopyWith<$Res>(_self.contact!, (value) {
    return _then(_self.copyWith(contact: value));
  });
}/// Create a copy of HelpCenterRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HelpLegalRecordCopyWith<$Res>? get legal {
    if (_self.legal == null) {
    return null;
  }

  return $HelpLegalRecordCopyWith<$Res>(_self.legal!, (value) {
    return _then(_self.copyWith(legal: value));
  });
}
}


/// Adds pattern-matching-related methods to [HelpCenterRecord].
extension HelpCenterRecordPatterns on HelpCenterRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HelpCenterRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HelpCenterRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HelpCenterRecord value)  $default,){
final _that = this;
switch (_that) {
case _HelpCenterRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HelpCenterRecord value)?  $default,){
final _that = this;
switch (_that) {
case _HelpCenterRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _HelpCenterRecord implements HelpCenterRecord {
  const _HelpCenterRecord({@JsonKey(name: 'version') this.version, @JsonKey(name: 'faqs') final  List<HelpFaqRecord> faqs = const <HelpFaqRecord>[], @JsonKey(name: 'contact') this.contact, @JsonKey(name: 'legal') this.legal}): _faqs = faqs;
  factory _HelpCenterRecord.fromJson(Map<String, dynamic> json) => _$HelpCenterRecordFromJson(json);

@override@JsonKey(name: 'version') final  int? version;
 final  List<HelpFaqRecord> _faqs;
@override@JsonKey(name: 'faqs') List<HelpFaqRecord> get faqs {
  if (_faqs is EqualUnmodifiableListView) return _faqs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_faqs);
}

@override@JsonKey(name: 'contact') final  HelpContactRecord? contact;
@override@JsonKey(name: 'legal') final  HelpLegalRecord? legal;

/// Create a copy of HelpCenterRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HelpCenterRecordCopyWith<_HelpCenterRecord> get copyWith => __$HelpCenterRecordCopyWithImpl<_HelpCenterRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HelpCenterRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HelpCenterRecord&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other._faqs, _faqs)&&(identical(other.contact, contact) || other.contact == contact)&&(identical(other.legal, legal) || other.legal == legal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(_faqs),contact,legal);

@override
String toString() {
  return 'HelpCenterRecord(version: $version, faqs: $faqs, contact: $contact, legal: $legal)';
}


}

/// @nodoc
abstract mixin class _$HelpCenterRecordCopyWith<$Res> implements $HelpCenterRecordCopyWith<$Res> {
  factory _$HelpCenterRecordCopyWith(_HelpCenterRecord value, $Res Function(_HelpCenterRecord) _then) = __$HelpCenterRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'version') int? version,@JsonKey(name: 'faqs') List<HelpFaqRecord> faqs,@JsonKey(name: 'contact') HelpContactRecord? contact,@JsonKey(name: 'legal') HelpLegalRecord? legal
});


@override $HelpContactRecordCopyWith<$Res>? get contact;@override $HelpLegalRecordCopyWith<$Res>? get legal;

}
/// @nodoc
class __$HelpCenterRecordCopyWithImpl<$Res>
    implements _$HelpCenterRecordCopyWith<$Res> {
  __$HelpCenterRecordCopyWithImpl(this._self, this._then);

  final _HelpCenterRecord _self;
  final $Res Function(_HelpCenterRecord) _then;

/// Create a copy of HelpCenterRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = freezed,Object? faqs = null,Object? contact = freezed,Object? legal = freezed,}) {
  return _then(_HelpCenterRecord(
version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int?,faqs: null == faqs ? _self._faqs : faqs // ignore: cast_nullable_to_non_nullable
as List<HelpFaqRecord>,contact: freezed == contact ? _self.contact : contact // ignore: cast_nullable_to_non_nullable
as HelpContactRecord?,legal: freezed == legal ? _self.legal : legal // ignore: cast_nullable_to_non_nullable
as HelpLegalRecord?,
  ));
}

/// Create a copy of HelpCenterRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HelpContactRecordCopyWith<$Res>? get contact {
    if (_self.contact == null) {
    return null;
  }

  return $HelpContactRecordCopyWith<$Res>(_self.contact!, (value) {
    return _then(_self.copyWith(contact: value));
  });
}/// Create a copy of HelpCenterRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HelpLegalRecordCopyWith<$Res>? get legal {
    if (_self.legal == null) {
    return null;
  }

  return $HelpLegalRecordCopyWith<$Res>(_self.legal!, (value) {
    return _then(_self.copyWith(legal: value));
  });
}
}


/// @nodoc
mixin _$HelpFaqRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'question') String get question;@JsonKey(name: 'answer') String get answer;
/// Create a copy of HelpFaqRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HelpFaqRecordCopyWith<HelpFaqRecord> get copyWith => _$HelpFaqRecordCopyWithImpl<HelpFaqRecord>(this as HelpFaqRecord, _$identity);

  /// Serializes this HelpFaqRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HelpFaqRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.question, question) || other.question == question)&&(identical(other.answer, answer) || other.answer == answer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,question,answer);

@override
String toString() {
  return 'HelpFaqRecord(id: $id, question: $question, answer: $answer)';
}


}

/// @nodoc
abstract mixin class $HelpFaqRecordCopyWith<$Res>  {
  factory $HelpFaqRecordCopyWith(HelpFaqRecord value, $Res Function(HelpFaqRecord) _then) = _$HelpFaqRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'question') String question,@JsonKey(name: 'answer') String answer
});




}
/// @nodoc
class _$HelpFaqRecordCopyWithImpl<$Res>
    implements $HelpFaqRecordCopyWith<$Res> {
  _$HelpFaqRecordCopyWithImpl(this._self, this._then);

  final HelpFaqRecord _self;
  final $Res Function(HelpFaqRecord) _then;

/// Create a copy of HelpFaqRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? question = null,Object? answer = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HelpFaqRecord].
extension HelpFaqRecordPatterns on HelpFaqRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HelpFaqRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HelpFaqRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HelpFaqRecord value)  $default,){
final _that = this;
switch (_that) {
case _HelpFaqRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HelpFaqRecord value)?  $default,){
final _that = this;
switch (_that) {
case _HelpFaqRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _HelpFaqRecord implements HelpFaqRecord {
  const _HelpFaqRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'question') this.question = '', @JsonKey(name: 'answer') this.answer = ''});
  factory _HelpFaqRecord.fromJson(Map<String, dynamic> json) => _$HelpFaqRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'question') final  String question;
@override@JsonKey(name: 'answer') final  String answer;

/// Create a copy of HelpFaqRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HelpFaqRecordCopyWith<_HelpFaqRecord> get copyWith => __$HelpFaqRecordCopyWithImpl<_HelpFaqRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HelpFaqRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HelpFaqRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.question, question) || other.question == question)&&(identical(other.answer, answer) || other.answer == answer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,question,answer);

@override
String toString() {
  return 'HelpFaqRecord(id: $id, question: $question, answer: $answer)';
}


}

/// @nodoc
abstract mixin class _$HelpFaqRecordCopyWith<$Res> implements $HelpFaqRecordCopyWith<$Res> {
  factory _$HelpFaqRecordCopyWith(_HelpFaqRecord value, $Res Function(_HelpFaqRecord) _then) = __$HelpFaqRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'question') String question,@JsonKey(name: 'answer') String answer
});




}
/// @nodoc
class __$HelpFaqRecordCopyWithImpl<$Res>
    implements _$HelpFaqRecordCopyWith<$Res> {
  __$HelpFaqRecordCopyWithImpl(this._self, this._then);

  final _HelpFaqRecord _self;
  final $Res Function(_HelpFaqRecord) _then;

/// Create a copy of HelpFaqRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? question = null,Object? answer = null,}) {
  return _then(_HelpFaqRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$HelpContactRecord {

@JsonKey(name: 'email') String? get email;@JsonKey(name: 'hotline') String? get hotline;
/// Create a copy of HelpContactRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HelpContactRecordCopyWith<HelpContactRecord> get copyWith => _$HelpContactRecordCopyWithImpl<HelpContactRecord>(this as HelpContactRecord, _$identity);

  /// Serializes this HelpContactRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HelpContactRecord&&(identical(other.email, email) || other.email == email)&&(identical(other.hotline, hotline) || other.hotline == hotline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,hotline);

@override
String toString() {
  return 'HelpContactRecord(email: $email, hotline: $hotline)';
}


}

/// @nodoc
abstract mixin class $HelpContactRecordCopyWith<$Res>  {
  factory $HelpContactRecordCopyWith(HelpContactRecord value, $Res Function(HelpContactRecord) _then) = _$HelpContactRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'email') String? email,@JsonKey(name: 'hotline') String? hotline
});




}
/// @nodoc
class _$HelpContactRecordCopyWithImpl<$Res>
    implements $HelpContactRecordCopyWith<$Res> {
  _$HelpContactRecordCopyWithImpl(this._self, this._then);

  final HelpContactRecord _self;
  final $Res Function(HelpContactRecord) _then;

/// Create a copy of HelpContactRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = freezed,Object? hotline = freezed,}) {
  return _then(_self.copyWith(
email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,hotline: freezed == hotline ? _self.hotline : hotline // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HelpContactRecord].
extension HelpContactRecordPatterns on HelpContactRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HelpContactRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HelpContactRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HelpContactRecord value)  $default,){
final _that = this;
switch (_that) {
case _HelpContactRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HelpContactRecord value)?  $default,){
final _that = this;
switch (_that) {
case _HelpContactRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _HelpContactRecord implements HelpContactRecord {
  const _HelpContactRecord({@JsonKey(name: 'email') this.email, @JsonKey(name: 'hotline') this.hotline});
  factory _HelpContactRecord.fromJson(Map<String, dynamic> json) => _$HelpContactRecordFromJson(json);

@override@JsonKey(name: 'email') final  String? email;
@override@JsonKey(name: 'hotline') final  String? hotline;

/// Create a copy of HelpContactRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HelpContactRecordCopyWith<_HelpContactRecord> get copyWith => __$HelpContactRecordCopyWithImpl<_HelpContactRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HelpContactRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HelpContactRecord&&(identical(other.email, email) || other.email == email)&&(identical(other.hotline, hotline) || other.hotline == hotline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,hotline);

@override
String toString() {
  return 'HelpContactRecord(email: $email, hotline: $hotline)';
}


}

/// @nodoc
abstract mixin class _$HelpContactRecordCopyWith<$Res> implements $HelpContactRecordCopyWith<$Res> {
  factory _$HelpContactRecordCopyWith(_HelpContactRecord value, $Res Function(_HelpContactRecord) _then) = __$HelpContactRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'email') String? email,@JsonKey(name: 'hotline') String? hotline
});




}
/// @nodoc
class __$HelpContactRecordCopyWithImpl<$Res>
    implements _$HelpContactRecordCopyWith<$Res> {
  __$HelpContactRecordCopyWithImpl(this._self, this._then);

  final _HelpContactRecord _self;
  final $Res Function(_HelpContactRecord) _then;

/// Create a copy of HelpContactRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = freezed,Object? hotline = freezed,}) {
  return _then(_HelpContactRecord(
email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,hotline: freezed == hotline ? _self.hotline : hotline // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$HelpLegalRecord {

@JsonKey(name: 'termsUrl') String? get termsUrl;@JsonKey(name: 'privacyUrl') String? get privacyUrl;@JsonKey(name: 'licensesUrl') String? get licensesUrl;
/// Create a copy of HelpLegalRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HelpLegalRecordCopyWith<HelpLegalRecord> get copyWith => _$HelpLegalRecordCopyWithImpl<HelpLegalRecord>(this as HelpLegalRecord, _$identity);

  /// Serializes this HelpLegalRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HelpLegalRecord&&(identical(other.termsUrl, termsUrl) || other.termsUrl == termsUrl)&&(identical(other.privacyUrl, privacyUrl) || other.privacyUrl == privacyUrl)&&(identical(other.licensesUrl, licensesUrl) || other.licensesUrl == licensesUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,termsUrl,privacyUrl,licensesUrl);

@override
String toString() {
  return 'HelpLegalRecord(termsUrl: $termsUrl, privacyUrl: $privacyUrl, licensesUrl: $licensesUrl)';
}


}

/// @nodoc
abstract mixin class $HelpLegalRecordCopyWith<$Res>  {
  factory $HelpLegalRecordCopyWith(HelpLegalRecord value, $Res Function(HelpLegalRecord) _then) = _$HelpLegalRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'termsUrl') String? termsUrl,@JsonKey(name: 'privacyUrl') String? privacyUrl,@JsonKey(name: 'licensesUrl') String? licensesUrl
});




}
/// @nodoc
class _$HelpLegalRecordCopyWithImpl<$Res>
    implements $HelpLegalRecordCopyWith<$Res> {
  _$HelpLegalRecordCopyWithImpl(this._self, this._then);

  final HelpLegalRecord _self;
  final $Res Function(HelpLegalRecord) _then;

/// Create a copy of HelpLegalRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? termsUrl = freezed,Object? privacyUrl = freezed,Object? licensesUrl = freezed,}) {
  return _then(_self.copyWith(
termsUrl: freezed == termsUrl ? _self.termsUrl : termsUrl // ignore: cast_nullable_to_non_nullable
as String?,privacyUrl: freezed == privacyUrl ? _self.privacyUrl : privacyUrl // ignore: cast_nullable_to_non_nullable
as String?,licensesUrl: freezed == licensesUrl ? _self.licensesUrl : licensesUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HelpLegalRecord].
extension HelpLegalRecordPatterns on HelpLegalRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HelpLegalRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HelpLegalRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HelpLegalRecord value)  $default,){
final _that = this;
switch (_that) {
case _HelpLegalRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HelpLegalRecord value)?  $default,){
final _that = this;
switch (_that) {
case _HelpLegalRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _HelpLegalRecord implements HelpLegalRecord {
  const _HelpLegalRecord({@JsonKey(name: 'termsUrl') this.termsUrl, @JsonKey(name: 'privacyUrl') this.privacyUrl, @JsonKey(name: 'licensesUrl') this.licensesUrl});
  factory _HelpLegalRecord.fromJson(Map<String, dynamic> json) => _$HelpLegalRecordFromJson(json);

@override@JsonKey(name: 'termsUrl') final  String? termsUrl;
@override@JsonKey(name: 'privacyUrl') final  String? privacyUrl;
@override@JsonKey(name: 'licensesUrl') final  String? licensesUrl;

/// Create a copy of HelpLegalRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HelpLegalRecordCopyWith<_HelpLegalRecord> get copyWith => __$HelpLegalRecordCopyWithImpl<_HelpLegalRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HelpLegalRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HelpLegalRecord&&(identical(other.termsUrl, termsUrl) || other.termsUrl == termsUrl)&&(identical(other.privacyUrl, privacyUrl) || other.privacyUrl == privacyUrl)&&(identical(other.licensesUrl, licensesUrl) || other.licensesUrl == licensesUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,termsUrl,privacyUrl,licensesUrl);

@override
String toString() {
  return 'HelpLegalRecord(termsUrl: $termsUrl, privacyUrl: $privacyUrl, licensesUrl: $licensesUrl)';
}


}

/// @nodoc
abstract mixin class _$HelpLegalRecordCopyWith<$Res> implements $HelpLegalRecordCopyWith<$Res> {
  factory _$HelpLegalRecordCopyWith(_HelpLegalRecord value, $Res Function(_HelpLegalRecord) _then) = __$HelpLegalRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'termsUrl') String? termsUrl,@JsonKey(name: 'privacyUrl') String? privacyUrl,@JsonKey(name: 'licensesUrl') String? licensesUrl
});




}
/// @nodoc
class __$HelpLegalRecordCopyWithImpl<$Res>
    implements _$HelpLegalRecordCopyWith<$Res> {
  __$HelpLegalRecordCopyWithImpl(this._self, this._then);

  final _HelpLegalRecord _self;
  final $Res Function(_HelpLegalRecord) _then;

/// Create a copy of HelpLegalRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? termsUrl = freezed,Object? privacyUrl = freezed,Object? licensesUrl = freezed,}) {
  return _then(_HelpLegalRecord(
termsUrl: freezed == termsUrl ? _self.termsUrl : termsUrl // ignore: cast_nullable_to_non_nullable
as String?,privacyUrl: freezed == privacyUrl ? _self.privacyUrl : privacyUrl // ignore: cast_nullable_to_non_nullable
as String?,licensesUrl: freezed == licensesUrl ? _self.licensesUrl : licensesUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
