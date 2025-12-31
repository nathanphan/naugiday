// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'permission_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PermissionState {

 PermissionAccessStatus get cameraStatus; PermissionAccessStatus get photoStatus; DateTime get lastCheckedAt;
/// Create a copy of PermissionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PermissionStateCopyWith<PermissionState> get copyWith => _$PermissionStateCopyWithImpl<PermissionState>(this as PermissionState, _$identity);

  /// Serializes this PermissionState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionState&&(identical(other.cameraStatus, cameraStatus) || other.cameraStatus == cameraStatus)&&(identical(other.photoStatus, photoStatus) || other.photoStatus == photoStatus)&&(identical(other.lastCheckedAt, lastCheckedAt) || other.lastCheckedAt == lastCheckedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cameraStatus,photoStatus,lastCheckedAt);

@override
String toString() {
  return 'PermissionState(cameraStatus: $cameraStatus, photoStatus: $photoStatus, lastCheckedAt: $lastCheckedAt)';
}


}

/// @nodoc
abstract mixin class $PermissionStateCopyWith<$Res>  {
  factory $PermissionStateCopyWith(PermissionState value, $Res Function(PermissionState) _then) = _$PermissionStateCopyWithImpl;
@useResult
$Res call({
 PermissionAccessStatus cameraStatus, PermissionAccessStatus photoStatus, DateTime lastCheckedAt
});




}
/// @nodoc
class _$PermissionStateCopyWithImpl<$Res>
    implements $PermissionStateCopyWith<$Res> {
  _$PermissionStateCopyWithImpl(this._self, this._then);

  final PermissionState _self;
  final $Res Function(PermissionState) _then;

/// Create a copy of PermissionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cameraStatus = null,Object? photoStatus = null,Object? lastCheckedAt = null,}) {
  return _then(_self.copyWith(
cameraStatus: null == cameraStatus ? _self.cameraStatus : cameraStatus // ignore: cast_nullable_to_non_nullable
as PermissionAccessStatus,photoStatus: null == photoStatus ? _self.photoStatus : photoStatus // ignore: cast_nullable_to_non_nullable
as PermissionAccessStatus,lastCheckedAt: null == lastCheckedAt ? _self.lastCheckedAt : lastCheckedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PermissionState].
extension PermissionStatePatterns on PermissionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PermissionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PermissionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PermissionState value)  $default,){
final _that = this;
switch (_that) {
case _PermissionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PermissionState value)?  $default,){
final _that = this;
switch (_that) {
case _PermissionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PermissionAccessStatus cameraStatus,  PermissionAccessStatus photoStatus,  DateTime lastCheckedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PermissionState() when $default != null:
return $default(_that.cameraStatus,_that.photoStatus,_that.lastCheckedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PermissionAccessStatus cameraStatus,  PermissionAccessStatus photoStatus,  DateTime lastCheckedAt)  $default,) {final _that = this;
switch (_that) {
case _PermissionState():
return $default(_that.cameraStatus,_that.photoStatus,_that.lastCheckedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PermissionAccessStatus cameraStatus,  PermissionAccessStatus photoStatus,  DateTime lastCheckedAt)?  $default,) {final _that = this;
switch (_that) {
case _PermissionState() when $default != null:
return $default(_that.cameraStatus,_that.photoStatus,_that.lastCheckedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PermissionState extends PermissionState {
  const _PermissionState({required this.cameraStatus, required this.photoStatus, required this.lastCheckedAt}): super._();
  factory _PermissionState.fromJson(Map<String, dynamic> json) => _$PermissionStateFromJson(json);

@override final  PermissionAccessStatus cameraStatus;
@override final  PermissionAccessStatus photoStatus;
@override final  DateTime lastCheckedAt;

/// Create a copy of PermissionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PermissionStateCopyWith<_PermissionState> get copyWith => __$PermissionStateCopyWithImpl<_PermissionState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PermissionStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PermissionState&&(identical(other.cameraStatus, cameraStatus) || other.cameraStatus == cameraStatus)&&(identical(other.photoStatus, photoStatus) || other.photoStatus == photoStatus)&&(identical(other.lastCheckedAt, lastCheckedAt) || other.lastCheckedAt == lastCheckedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cameraStatus,photoStatus,lastCheckedAt);

@override
String toString() {
  return 'PermissionState(cameraStatus: $cameraStatus, photoStatus: $photoStatus, lastCheckedAt: $lastCheckedAt)';
}


}

/// @nodoc
abstract mixin class _$PermissionStateCopyWith<$Res> implements $PermissionStateCopyWith<$Res> {
  factory _$PermissionStateCopyWith(_PermissionState value, $Res Function(_PermissionState) _then) = __$PermissionStateCopyWithImpl;
@override @useResult
$Res call({
 PermissionAccessStatus cameraStatus, PermissionAccessStatus photoStatus, DateTime lastCheckedAt
});




}
/// @nodoc
class __$PermissionStateCopyWithImpl<$Res>
    implements _$PermissionStateCopyWith<$Res> {
  __$PermissionStateCopyWithImpl(this._self, this._then);

  final _PermissionState _self;
  final $Res Function(_PermissionState) _then;

/// Create a copy of PermissionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cameraStatus = null,Object? photoStatus = null,Object? lastCheckedAt = null,}) {
  return _then(_PermissionState(
cameraStatus: null == cameraStatus ? _self.cameraStatus : cameraStatus // ignore: cast_nullable_to_non_nullable
as PermissionAccessStatus,photoStatus: null == photoStatus ? _self.photoStatus : photoStatus // ignore: cast_nullable_to_non_nullable
as PermissionAccessStatus,lastCheckedAt: null == lastCheckedAt ? _self.lastCheckedAt : lastCheckedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
