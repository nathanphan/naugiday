// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecipeImage {

 String get id; String get localPath; String get fileName; int get fileSizeBytes; DateTime? get addedAt;
/// Create a copy of RecipeImage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipeImageCopyWith<RecipeImage> get copyWith => _$RecipeImageCopyWithImpl<RecipeImage>(this as RecipeImage, _$identity);

  /// Serializes this RecipeImage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecipeImage&&(identical(other.id, id) || other.id == id)&&(identical(other.localPath, localPath) || other.localPath == localPath)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,localPath,fileName,fileSizeBytes,addedAt);

@override
String toString() {
  return 'RecipeImage(id: $id, localPath: $localPath, fileName: $fileName, fileSizeBytes: $fileSizeBytes, addedAt: $addedAt)';
}


}

/// @nodoc
abstract mixin class $RecipeImageCopyWith<$Res>  {
  factory $RecipeImageCopyWith(RecipeImage value, $Res Function(RecipeImage) _then) = _$RecipeImageCopyWithImpl;
@useResult
$Res call({
 String id, String localPath, String fileName, int fileSizeBytes, DateTime? addedAt
});




}
/// @nodoc
class _$RecipeImageCopyWithImpl<$Res>
    implements $RecipeImageCopyWith<$Res> {
  _$RecipeImageCopyWithImpl(this._self, this._then);

  final RecipeImage _self;
  final $Res Function(RecipeImage) _then;

/// Create a copy of RecipeImage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? localPath = null,Object? fileName = null,Object? fileSizeBytes = null,Object? addedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,localPath: null == localPath ? _self.localPath : localPath // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,addedAt: freezed == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RecipeImage].
extension RecipeImagePatterns on RecipeImage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecipeImage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecipeImage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecipeImage value)  $default,){
final _that = this;
switch (_that) {
case _RecipeImage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecipeImage value)?  $default,){
final _that = this;
switch (_that) {
case _RecipeImage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String localPath,  String fileName,  int fileSizeBytes,  DateTime? addedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecipeImage() when $default != null:
return $default(_that.id,_that.localPath,_that.fileName,_that.fileSizeBytes,_that.addedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String localPath,  String fileName,  int fileSizeBytes,  DateTime? addedAt)  $default,) {final _that = this;
switch (_that) {
case _RecipeImage():
return $default(_that.id,_that.localPath,_that.fileName,_that.fileSizeBytes,_that.addedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String localPath,  String fileName,  int fileSizeBytes,  DateTime? addedAt)?  $default,) {final _that = this;
switch (_that) {
case _RecipeImage() when $default != null:
return $default(_that.id,_that.localPath,_that.fileName,_that.fileSizeBytes,_that.addedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecipeImage extends RecipeImage {
  const _RecipeImage({required this.id, required this.localPath, required this.fileName, required this.fileSizeBytes, this.addedAt}): super._();
  factory _RecipeImage.fromJson(Map<String, dynamic> json) => _$RecipeImageFromJson(json);

@override final  String id;
@override final  String localPath;
@override final  String fileName;
@override final  int fileSizeBytes;
@override final  DateTime? addedAt;

/// Create a copy of RecipeImage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipeImageCopyWith<_RecipeImage> get copyWith => __$RecipeImageCopyWithImpl<_RecipeImage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecipeImageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecipeImage&&(identical(other.id, id) || other.id == id)&&(identical(other.localPath, localPath) || other.localPath == localPath)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,localPath,fileName,fileSizeBytes,addedAt);

@override
String toString() {
  return 'RecipeImage(id: $id, localPath: $localPath, fileName: $fileName, fileSizeBytes: $fileSizeBytes, addedAt: $addedAt)';
}


}

/// @nodoc
abstract mixin class _$RecipeImageCopyWith<$Res> implements $RecipeImageCopyWith<$Res> {
  factory _$RecipeImageCopyWith(_RecipeImage value, $Res Function(_RecipeImage) _then) = __$RecipeImageCopyWithImpl;
@override @useResult
$Res call({
 String id, String localPath, String fileName, int fileSizeBytes, DateTime? addedAt
});




}
/// @nodoc
class __$RecipeImageCopyWithImpl<$Res>
    implements _$RecipeImageCopyWith<$Res> {
  __$RecipeImageCopyWithImpl(this._self, this._then);

  final _RecipeImage _self;
  final $Res Function(_RecipeImage) _then;

/// Create a copy of RecipeImage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? localPath = null,Object? fileName = null,Object? fileSizeBytes = null,Object? addedAt = freezed,}) {
  return _then(_RecipeImage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,localPath: null == localPath ? _self.localPath : localPath // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,addedAt: freezed == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
