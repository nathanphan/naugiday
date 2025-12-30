// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pantry_ingredient.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PantryIngredient {

 String get id; String get name; String get categoryId; String? get categoryName; double get quantity; String get unit; DateTime? get expiryDate; bool? get freshnessOverride; IngredientInventoryState get inventoryState; List<IngredientPhoto> get photos; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of PantryIngredient
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PantryIngredientCopyWith<PantryIngredient> get copyWith => _$PantryIngredientCopyWithImpl<PantryIngredient>(this as PantryIngredient, _$identity);

  /// Serializes this PantryIngredient to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PantryIngredient&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.freshnessOverride, freshnessOverride) || other.freshnessOverride == freshnessOverride)&&(identical(other.inventoryState, inventoryState) || other.inventoryState == inventoryState)&&const DeepCollectionEquality().equals(other.photos, photos)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,categoryId,categoryName,quantity,unit,expiryDate,freshnessOverride,inventoryState,const DeepCollectionEquality().hash(photos),createdAt,updatedAt);

@override
String toString() {
  return 'PantryIngredient(id: $id, name: $name, categoryId: $categoryId, categoryName: $categoryName, quantity: $quantity, unit: $unit, expiryDate: $expiryDate, freshnessOverride: $freshnessOverride, inventoryState: $inventoryState, photos: $photos, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PantryIngredientCopyWith<$Res>  {
  factory $PantryIngredientCopyWith(PantryIngredient value, $Res Function(PantryIngredient) _then) = _$PantryIngredientCopyWithImpl;
@useResult
$Res call({
 String id, String name, String categoryId, String? categoryName, double quantity, String unit, DateTime? expiryDate, bool? freshnessOverride, IngredientInventoryState inventoryState, List<IngredientPhoto> photos, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$PantryIngredientCopyWithImpl<$Res>
    implements $PantryIngredientCopyWith<$Res> {
  _$PantryIngredientCopyWithImpl(this._self, this._then);

  final PantryIngredient _self;
  final $Res Function(PantryIngredient) _then;

/// Create a copy of PantryIngredient
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? categoryId = null,Object? categoryName = freezed,Object? quantity = null,Object? unit = null,Object? expiryDate = freezed,Object? freshnessOverride = freezed,Object? inventoryState = null,Object? photos = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,freshnessOverride: freezed == freshnessOverride ? _self.freshnessOverride : freshnessOverride // ignore: cast_nullable_to_non_nullable
as bool?,inventoryState: null == inventoryState ? _self.inventoryState : inventoryState // ignore: cast_nullable_to_non_nullable
as IngredientInventoryState,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<IngredientPhoto>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PantryIngredient].
extension PantryIngredientPatterns on PantryIngredient {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PantryIngredient value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PantryIngredient() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PantryIngredient value)  $default,){
final _that = this;
switch (_that) {
case _PantryIngredient():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PantryIngredient value)?  $default,){
final _that = this;
switch (_that) {
case _PantryIngredient() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String categoryId,  String? categoryName,  double quantity,  String unit,  DateTime? expiryDate,  bool? freshnessOverride,  IngredientInventoryState inventoryState,  List<IngredientPhoto> photos,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PantryIngredient() when $default != null:
return $default(_that.id,_that.name,_that.categoryId,_that.categoryName,_that.quantity,_that.unit,_that.expiryDate,_that.freshnessOverride,_that.inventoryState,_that.photos,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String categoryId,  String? categoryName,  double quantity,  String unit,  DateTime? expiryDate,  bool? freshnessOverride,  IngredientInventoryState inventoryState,  List<IngredientPhoto> photos,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PantryIngredient():
return $default(_that.id,_that.name,_that.categoryId,_that.categoryName,_that.quantity,_that.unit,_that.expiryDate,_that.freshnessOverride,_that.inventoryState,_that.photos,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String categoryId,  String? categoryName,  double quantity,  String unit,  DateTime? expiryDate,  bool? freshnessOverride,  IngredientInventoryState inventoryState,  List<IngredientPhoto> photos,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PantryIngredient() when $default != null:
return $default(_that.id,_that.name,_that.categoryId,_that.categoryName,_that.quantity,_that.unit,_that.expiryDate,_that.freshnessOverride,_that.inventoryState,_that.photos,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PantryIngredient extends PantryIngredient {
  const _PantryIngredient({required this.id, required this.name, required this.categoryId, this.categoryName, required this.quantity, required this.unit, this.expiryDate, this.freshnessOverride, required this.inventoryState, final  List<IngredientPhoto> photos = const <IngredientPhoto>[], required this.createdAt, required this.updatedAt}): _photos = photos,super._();
  factory _PantryIngredient.fromJson(Map<String, dynamic> json) => _$PantryIngredientFromJson(json);

@override final  String id;
@override final  String name;
@override final  String categoryId;
@override final  String? categoryName;
@override final  double quantity;
@override final  String unit;
@override final  DateTime? expiryDate;
@override final  bool? freshnessOverride;
@override final  IngredientInventoryState inventoryState;
 final  List<IngredientPhoto> _photos;
@override@JsonKey() List<IngredientPhoto> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of PantryIngredient
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PantryIngredientCopyWith<_PantryIngredient> get copyWith => __$PantryIngredientCopyWithImpl<_PantryIngredient>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PantryIngredientToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PantryIngredient&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.freshnessOverride, freshnessOverride) || other.freshnessOverride == freshnessOverride)&&(identical(other.inventoryState, inventoryState) || other.inventoryState == inventoryState)&&const DeepCollectionEquality().equals(other._photos, _photos)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,categoryId,categoryName,quantity,unit,expiryDate,freshnessOverride,inventoryState,const DeepCollectionEquality().hash(_photos),createdAt,updatedAt);

@override
String toString() {
  return 'PantryIngredient(id: $id, name: $name, categoryId: $categoryId, categoryName: $categoryName, quantity: $quantity, unit: $unit, expiryDate: $expiryDate, freshnessOverride: $freshnessOverride, inventoryState: $inventoryState, photos: $photos, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PantryIngredientCopyWith<$Res> implements $PantryIngredientCopyWith<$Res> {
  factory _$PantryIngredientCopyWith(_PantryIngredient value, $Res Function(_PantryIngredient) _then) = __$PantryIngredientCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String categoryId, String? categoryName, double quantity, String unit, DateTime? expiryDate, bool? freshnessOverride, IngredientInventoryState inventoryState, List<IngredientPhoto> photos, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$PantryIngredientCopyWithImpl<$Res>
    implements _$PantryIngredientCopyWith<$Res> {
  __$PantryIngredientCopyWithImpl(this._self, this._then);

  final _PantryIngredient _self;
  final $Res Function(_PantryIngredient) _then;

/// Create a copy of PantryIngredient
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? categoryId = null,Object? categoryName = freezed,Object? quantity = null,Object? unit = null,Object? expiryDate = freezed,Object? freshnessOverride = freezed,Object? inventoryState = null,Object? photos = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_PantryIngredient(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,freshnessOverride: freezed == freshnessOverride ? _self.freshnessOverride : freshnessOverride // ignore: cast_nullable_to_non_nullable
as bool?,inventoryState: null == inventoryState ? _self.inventoryState : inventoryState // ignore: cast_nullable_to_non_nullable
as IngredientInventoryState,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<IngredientPhoto>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
