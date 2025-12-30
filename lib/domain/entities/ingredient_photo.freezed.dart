// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ingredient_photo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IngredientPhoto {

 String get id; String get path; IngredientPhotoSource get source; int get displayOrder; DateTime get createdAt;
/// Create a copy of IngredientPhoto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IngredientPhotoCopyWith<IngredientPhoto> get copyWith => _$IngredientPhotoCopyWithImpl<IngredientPhoto>(this as IngredientPhoto, _$identity);

  /// Serializes this IngredientPhoto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IngredientPhoto&&(identical(other.id, id) || other.id == id)&&(identical(other.path, path) || other.path == path)&&(identical(other.source, source) || other.source == source)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,path,source,displayOrder,createdAt);

@override
String toString() {
  return 'IngredientPhoto(id: $id, path: $path, source: $source, displayOrder: $displayOrder, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $IngredientPhotoCopyWith<$Res>  {
  factory $IngredientPhotoCopyWith(IngredientPhoto value, $Res Function(IngredientPhoto) _then) = _$IngredientPhotoCopyWithImpl;
@useResult
$Res call({
 String id, String path, IngredientPhotoSource source, int displayOrder, DateTime createdAt
});




}
/// @nodoc
class _$IngredientPhotoCopyWithImpl<$Res>
    implements $IngredientPhotoCopyWith<$Res> {
  _$IngredientPhotoCopyWithImpl(this._self, this._then);

  final IngredientPhoto _self;
  final $Res Function(IngredientPhoto) _then;

/// Create a copy of IngredientPhoto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? path = null,Object? source = null,Object? displayOrder = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as IngredientPhotoSource,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [IngredientPhoto].
extension IngredientPhotoPatterns on IngredientPhoto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IngredientPhoto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IngredientPhoto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IngredientPhoto value)  $default,){
final _that = this;
switch (_that) {
case _IngredientPhoto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IngredientPhoto value)?  $default,){
final _that = this;
switch (_that) {
case _IngredientPhoto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String path,  IngredientPhotoSource source,  int displayOrder,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IngredientPhoto() when $default != null:
return $default(_that.id,_that.path,_that.source,_that.displayOrder,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String path,  IngredientPhotoSource source,  int displayOrder,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _IngredientPhoto():
return $default(_that.id,_that.path,_that.source,_that.displayOrder,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String path,  IngredientPhotoSource source,  int displayOrder,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _IngredientPhoto() when $default != null:
return $default(_that.id,_that.path,_that.source,_that.displayOrder,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IngredientPhoto extends IngredientPhoto {
  const _IngredientPhoto({required this.id, required this.path, required this.source, required this.displayOrder, required this.createdAt}): super._();
  factory _IngredientPhoto.fromJson(Map<String, dynamic> json) => _$IngredientPhotoFromJson(json);

@override final  String id;
@override final  String path;
@override final  IngredientPhotoSource source;
@override final  int displayOrder;
@override final  DateTime createdAt;

/// Create a copy of IngredientPhoto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IngredientPhotoCopyWith<_IngredientPhoto> get copyWith => __$IngredientPhotoCopyWithImpl<_IngredientPhoto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IngredientPhotoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IngredientPhoto&&(identical(other.id, id) || other.id == id)&&(identical(other.path, path) || other.path == path)&&(identical(other.source, source) || other.source == source)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,path,source,displayOrder,createdAt);

@override
String toString() {
  return 'IngredientPhoto(id: $id, path: $path, source: $source, displayOrder: $displayOrder, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$IngredientPhotoCopyWith<$Res> implements $IngredientPhotoCopyWith<$Res> {
  factory _$IngredientPhotoCopyWith(_IngredientPhoto value, $Res Function(_IngredientPhoto) _then) = __$IngredientPhotoCopyWithImpl;
@override @useResult
$Res call({
 String id, String path, IngredientPhotoSource source, int displayOrder, DateTime createdAt
});




}
/// @nodoc
class __$IngredientPhotoCopyWithImpl<$Res>
    implements _$IngredientPhotoCopyWith<$Res> {
  __$IngredientPhotoCopyWithImpl(this._self, this._then);

  final _IngredientPhoto _self;
  final $Res Function(_IngredientPhoto) _then;

/// Create a copy of IngredientPhoto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? path = null,Object? source = null,Object? displayOrder = null,Object? createdAt = null,}) {
  return _then(_IngredientPhoto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as IngredientPhotoSource,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
