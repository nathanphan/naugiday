// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ingredient_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IngredientCategory {

 String get id; String get name; bool get isCustom; DateTime get createdAt;
/// Create a copy of IngredientCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IngredientCategoryCopyWith<IngredientCategory> get copyWith => _$IngredientCategoryCopyWithImpl<IngredientCategory>(this as IngredientCategory, _$identity);

  /// Serializes this IngredientCategory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IngredientCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,isCustom,createdAt);

@override
String toString() {
  return 'IngredientCategory(id: $id, name: $name, isCustom: $isCustom, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $IngredientCategoryCopyWith<$Res>  {
  factory $IngredientCategoryCopyWith(IngredientCategory value, $Res Function(IngredientCategory) _then) = _$IngredientCategoryCopyWithImpl;
@useResult
$Res call({
 String id, String name, bool isCustom, DateTime createdAt
});




}
/// @nodoc
class _$IngredientCategoryCopyWithImpl<$Res>
    implements $IngredientCategoryCopyWith<$Res> {
  _$IngredientCategoryCopyWithImpl(this._self, this._then);

  final IngredientCategory _self;
  final $Res Function(IngredientCategory) _then;

/// Create a copy of IngredientCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? isCustom = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [IngredientCategory].
extension IngredientCategoryPatterns on IngredientCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IngredientCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IngredientCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IngredientCategory value)  $default,){
final _that = this;
switch (_that) {
case _IngredientCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IngredientCategory value)?  $default,){
final _that = this;
switch (_that) {
case _IngredientCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  bool isCustom,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IngredientCategory() when $default != null:
return $default(_that.id,_that.name,_that.isCustom,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  bool isCustom,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _IngredientCategory():
return $default(_that.id,_that.name,_that.isCustom,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  bool isCustom,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _IngredientCategory() when $default != null:
return $default(_that.id,_that.name,_that.isCustom,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IngredientCategory extends IngredientCategory {
  const _IngredientCategory({required this.id, required this.name, required this.isCustom, required this.createdAt}): super._();
  factory _IngredientCategory.fromJson(Map<String, dynamic> json) => _$IngredientCategoryFromJson(json);

@override final  String id;
@override final  String name;
@override final  bool isCustom;
@override final  DateTime createdAt;

/// Create a copy of IngredientCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IngredientCategoryCopyWith<_IngredientCategory> get copyWith => __$IngredientCategoryCopyWithImpl<_IngredientCategory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IngredientCategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IngredientCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,isCustom,createdAt);

@override
String toString() {
  return 'IngredientCategory(id: $id, name: $name, isCustom: $isCustom, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$IngredientCategoryCopyWith<$Res> implements $IngredientCategoryCopyWith<$Res> {
  factory _$IngredientCategoryCopyWith(_IngredientCategory value, $Res Function(_IngredientCategory) _then) = __$IngredientCategoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, bool isCustom, DateTime createdAt
});




}
/// @nodoc
class __$IngredientCategoryCopyWithImpl<$Res>
    implements _$IngredientCategoryCopyWith<$Res> {
  __$IngredientCategoryCopyWithImpl(this._self, this._then);

  final _IngredientCategory _self;
  final $Res Function(_IngredientCategory) _then;

/// Create a copy of IngredientCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? isCustom = null,Object? createdAt = null,}) {
  return _then(_IngredientCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
