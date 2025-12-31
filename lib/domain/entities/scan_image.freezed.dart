// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScanImage {

 String get id; ScanImageSource get source; String get path; String? get thumbnailPath; int get sizeBytes; DateTime get createdAt; ScanImageStatus get status; String? get failureReason;
/// Create a copy of ScanImage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScanImageCopyWith<ScanImage> get copyWith => _$ScanImageCopyWithImpl<ScanImage>(this as ScanImage, _$identity);

  /// Serializes this ScanImage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanImage&&(identical(other.id, id) || other.id == id)&&(identical(other.source, source) || other.source == source)&&(identical(other.path, path) || other.path == path)&&(identical(other.thumbnailPath, thumbnailPath) || other.thumbnailPath == thumbnailPath)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,source,path,thumbnailPath,sizeBytes,createdAt,status,failureReason);

@override
String toString() {
  return 'ScanImage(id: $id, source: $source, path: $path, thumbnailPath: $thumbnailPath, sizeBytes: $sizeBytes, createdAt: $createdAt, status: $status, failureReason: $failureReason)';
}


}

/// @nodoc
abstract mixin class $ScanImageCopyWith<$Res>  {
  factory $ScanImageCopyWith(ScanImage value, $Res Function(ScanImage) _then) = _$ScanImageCopyWithImpl;
@useResult
$Res call({
 String id, ScanImageSource source, String path, String? thumbnailPath, int sizeBytes, DateTime createdAt, ScanImageStatus status, String? failureReason
});




}
/// @nodoc
class _$ScanImageCopyWithImpl<$Res>
    implements $ScanImageCopyWith<$Res> {
  _$ScanImageCopyWithImpl(this._self, this._then);

  final ScanImage _self;
  final $Res Function(ScanImage) _then;

/// Create a copy of ScanImage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? source = null,Object? path = null,Object? thumbnailPath = freezed,Object? sizeBytes = null,Object? createdAt = null,Object? status = null,Object? failureReason = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ScanImageSource,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,thumbnailPath: freezed == thumbnailPath ? _self.thumbnailPath : thumbnailPath // ignore: cast_nullable_to_non_nullable
as String?,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ScanImageStatus,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScanImage].
extension ScanImagePatterns on ScanImage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScanImage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScanImage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScanImage value)  $default,){
final _that = this;
switch (_that) {
case _ScanImage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScanImage value)?  $default,){
final _that = this;
switch (_that) {
case _ScanImage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ScanImageSource source,  String path,  String? thumbnailPath,  int sizeBytes,  DateTime createdAt,  ScanImageStatus status,  String? failureReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScanImage() when $default != null:
return $default(_that.id,_that.source,_that.path,_that.thumbnailPath,_that.sizeBytes,_that.createdAt,_that.status,_that.failureReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ScanImageSource source,  String path,  String? thumbnailPath,  int sizeBytes,  DateTime createdAt,  ScanImageStatus status,  String? failureReason)  $default,) {final _that = this;
switch (_that) {
case _ScanImage():
return $default(_that.id,_that.source,_that.path,_that.thumbnailPath,_that.sizeBytes,_that.createdAt,_that.status,_that.failureReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ScanImageSource source,  String path,  String? thumbnailPath,  int sizeBytes,  DateTime createdAt,  ScanImageStatus status,  String? failureReason)?  $default,) {final _that = this;
switch (_that) {
case _ScanImage() when $default != null:
return $default(_that.id,_that.source,_that.path,_that.thumbnailPath,_that.sizeBytes,_that.createdAt,_that.status,_that.failureReason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScanImage extends ScanImage {
  const _ScanImage({required this.id, required this.source, required this.path, this.thumbnailPath, required this.sizeBytes, required this.createdAt, required this.status, this.failureReason}): super._();
  factory _ScanImage.fromJson(Map<String, dynamic> json) => _$ScanImageFromJson(json);

@override final  String id;
@override final  ScanImageSource source;
@override final  String path;
@override final  String? thumbnailPath;
@override final  int sizeBytes;
@override final  DateTime createdAt;
@override final  ScanImageStatus status;
@override final  String? failureReason;

/// Create a copy of ScanImage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScanImageCopyWith<_ScanImage> get copyWith => __$ScanImageCopyWithImpl<_ScanImage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScanImageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScanImage&&(identical(other.id, id) || other.id == id)&&(identical(other.source, source) || other.source == source)&&(identical(other.path, path) || other.path == path)&&(identical(other.thumbnailPath, thumbnailPath) || other.thumbnailPath == thumbnailPath)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,source,path,thumbnailPath,sizeBytes,createdAt,status,failureReason);

@override
String toString() {
  return 'ScanImage(id: $id, source: $source, path: $path, thumbnailPath: $thumbnailPath, sizeBytes: $sizeBytes, createdAt: $createdAt, status: $status, failureReason: $failureReason)';
}


}

/// @nodoc
abstract mixin class _$ScanImageCopyWith<$Res> implements $ScanImageCopyWith<$Res> {
  factory _$ScanImageCopyWith(_ScanImage value, $Res Function(_ScanImage) _then) = __$ScanImageCopyWithImpl;
@override @useResult
$Res call({
 String id, ScanImageSource source, String path, String? thumbnailPath, int sizeBytes, DateTime createdAt, ScanImageStatus status, String? failureReason
});




}
/// @nodoc
class __$ScanImageCopyWithImpl<$Res>
    implements _$ScanImageCopyWith<$Res> {
  __$ScanImageCopyWithImpl(this._self, this._then);

  final _ScanImage _self;
  final $Res Function(_ScanImage) _then;

/// Create a copy of ScanImage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? source = null,Object? path = null,Object? thumbnailPath = freezed,Object? sizeBytes = null,Object? createdAt = null,Object? status = null,Object? failureReason = freezed,}) {
  return _then(_ScanImage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ScanImageSource,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,thumbnailPath: freezed == thumbnailPath ? _self.thumbnailPath : thumbnailPath // ignore: cast_nullable_to_non_nullable
as String?,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ScanImageStatus,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
