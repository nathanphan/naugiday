// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScanSession {

 String get id; DateTime get openedAt; ScanSessionState get state; List<String> get imageIds; DateTime get lastUpdatedAt; String? get sourceScreen;
/// Create a copy of ScanSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScanSessionCopyWith<ScanSession> get copyWith => _$ScanSessionCopyWithImpl<ScanSession>(this as ScanSession, _$identity);

  /// Serializes this ScanSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanSession&&(identical(other.id, id) || other.id == id)&&(identical(other.openedAt, openedAt) || other.openedAt == openedAt)&&(identical(other.state, state) || other.state == state)&&const DeepCollectionEquality().equals(other.imageIds, imageIds)&&(identical(other.lastUpdatedAt, lastUpdatedAt) || other.lastUpdatedAt == lastUpdatedAt)&&(identical(other.sourceScreen, sourceScreen) || other.sourceScreen == sourceScreen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,openedAt,state,const DeepCollectionEquality().hash(imageIds),lastUpdatedAt,sourceScreen);

@override
String toString() {
  return 'ScanSession(id: $id, openedAt: $openedAt, state: $state, imageIds: $imageIds, lastUpdatedAt: $lastUpdatedAt, sourceScreen: $sourceScreen)';
}


}

/// @nodoc
abstract mixin class $ScanSessionCopyWith<$Res>  {
  factory $ScanSessionCopyWith(ScanSession value, $Res Function(ScanSession) _then) = _$ScanSessionCopyWithImpl;
@useResult
$Res call({
 String id, DateTime openedAt, ScanSessionState state, List<String> imageIds, DateTime lastUpdatedAt, String? sourceScreen
});




}
/// @nodoc
class _$ScanSessionCopyWithImpl<$Res>
    implements $ScanSessionCopyWith<$Res> {
  _$ScanSessionCopyWithImpl(this._self, this._then);

  final ScanSession _self;
  final $Res Function(ScanSession) _then;

/// Create a copy of ScanSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? openedAt = null,Object? state = null,Object? imageIds = null,Object? lastUpdatedAt = null,Object? sourceScreen = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,openedAt: null == openedAt ? _self.openedAt : openedAt // ignore: cast_nullable_to_non_nullable
as DateTime,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as ScanSessionState,imageIds: null == imageIds ? _self.imageIds : imageIds // ignore: cast_nullable_to_non_nullable
as List<String>,lastUpdatedAt: null == lastUpdatedAt ? _self.lastUpdatedAt : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,sourceScreen: freezed == sourceScreen ? _self.sourceScreen : sourceScreen // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScanSession].
extension ScanSessionPatterns on ScanSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScanSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScanSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScanSession value)  $default,){
final _that = this;
switch (_that) {
case _ScanSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScanSession value)?  $default,){
final _that = this;
switch (_that) {
case _ScanSession() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime openedAt,  ScanSessionState state,  List<String> imageIds,  DateTime lastUpdatedAt,  String? sourceScreen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScanSession() when $default != null:
return $default(_that.id,_that.openedAt,_that.state,_that.imageIds,_that.lastUpdatedAt,_that.sourceScreen);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime openedAt,  ScanSessionState state,  List<String> imageIds,  DateTime lastUpdatedAt,  String? sourceScreen)  $default,) {final _that = this;
switch (_that) {
case _ScanSession():
return $default(_that.id,_that.openedAt,_that.state,_that.imageIds,_that.lastUpdatedAt,_that.sourceScreen);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime openedAt,  ScanSessionState state,  List<String> imageIds,  DateTime lastUpdatedAt,  String? sourceScreen)?  $default,) {final _that = this;
switch (_that) {
case _ScanSession() when $default != null:
return $default(_that.id,_that.openedAt,_that.state,_that.imageIds,_that.lastUpdatedAt,_that.sourceScreen);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScanSession extends ScanSession {
  const _ScanSession({required this.id, required this.openedAt, required this.state, final  List<String> imageIds = const <String>[], required this.lastUpdatedAt, this.sourceScreen}): _imageIds = imageIds,super._();
  factory _ScanSession.fromJson(Map<String, dynamic> json) => _$ScanSessionFromJson(json);

@override final  String id;
@override final  DateTime openedAt;
@override final  ScanSessionState state;
 final  List<String> _imageIds;
@override@JsonKey() List<String> get imageIds {
  if (_imageIds is EqualUnmodifiableListView) return _imageIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageIds);
}

@override final  DateTime lastUpdatedAt;
@override final  String? sourceScreen;

/// Create a copy of ScanSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScanSessionCopyWith<_ScanSession> get copyWith => __$ScanSessionCopyWithImpl<_ScanSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScanSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScanSession&&(identical(other.id, id) || other.id == id)&&(identical(other.openedAt, openedAt) || other.openedAt == openedAt)&&(identical(other.state, state) || other.state == state)&&const DeepCollectionEquality().equals(other._imageIds, _imageIds)&&(identical(other.lastUpdatedAt, lastUpdatedAt) || other.lastUpdatedAt == lastUpdatedAt)&&(identical(other.sourceScreen, sourceScreen) || other.sourceScreen == sourceScreen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,openedAt,state,const DeepCollectionEquality().hash(_imageIds),lastUpdatedAt,sourceScreen);

@override
String toString() {
  return 'ScanSession(id: $id, openedAt: $openedAt, state: $state, imageIds: $imageIds, lastUpdatedAt: $lastUpdatedAt, sourceScreen: $sourceScreen)';
}


}

/// @nodoc
abstract mixin class _$ScanSessionCopyWith<$Res> implements $ScanSessionCopyWith<$Res> {
  factory _$ScanSessionCopyWith(_ScanSession value, $Res Function(_ScanSession) _then) = __$ScanSessionCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime openedAt, ScanSessionState state, List<String> imageIds, DateTime lastUpdatedAt, String? sourceScreen
});




}
/// @nodoc
class __$ScanSessionCopyWithImpl<$Res>
    implements _$ScanSessionCopyWith<$Res> {
  __$ScanSessionCopyWithImpl(this._self, this._then);

  final _ScanSession _self;
  final $Res Function(_ScanSession) _then;

/// Create a copy of ScanSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? openedAt = null,Object? state = null,Object? imageIds = null,Object? lastUpdatedAt = null,Object? sourceScreen = freezed,}) {
  return _then(_ScanSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,openedAt: null == openedAt ? _self.openedAt : openedAt // ignore: cast_nullable_to_non_nullable
as DateTime,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as ScanSessionState,imageIds: null == imageIds ? _self._imageIds : imageIds // ignore: cast_nullable_to_non_nullable
as List<String>,lastUpdatedAt: null == lastUpdatedAt ? _self.lastUpdatedAt : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,sourceScreen: freezed == sourceScreen ? _self.sourceScreen : sourceScreen // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
