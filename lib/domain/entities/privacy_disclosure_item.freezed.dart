// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'privacy_disclosure_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PrivacyDisclosureItem {

 String get id; String get type; String get title; String get description; String get status; DateTime? get lastVerifiedAt;
/// Create a copy of PrivacyDisclosureItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivacyDisclosureItemCopyWith<PrivacyDisclosureItem> get copyWith => _$PrivacyDisclosureItemCopyWithImpl<PrivacyDisclosureItem>(this as PrivacyDisclosureItem, _$identity);

  /// Serializes this PrivacyDisclosureItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivacyDisclosureItem&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.lastVerifiedAt, lastVerifiedAt) || other.lastVerifiedAt == lastVerifiedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,description,status,lastVerifiedAt);

@override
String toString() {
  return 'PrivacyDisclosureItem(id: $id, type: $type, title: $title, description: $description, status: $status, lastVerifiedAt: $lastVerifiedAt)';
}


}

/// @nodoc
abstract mixin class $PrivacyDisclosureItemCopyWith<$Res>  {
  factory $PrivacyDisclosureItemCopyWith(PrivacyDisclosureItem value, $Res Function(PrivacyDisclosureItem) _then) = _$PrivacyDisclosureItemCopyWithImpl;
@useResult
$Res call({
 String id, String type, String title, String description, String status, DateTime? lastVerifiedAt
});




}
/// @nodoc
class _$PrivacyDisclosureItemCopyWithImpl<$Res>
    implements $PrivacyDisclosureItemCopyWith<$Res> {
  _$PrivacyDisclosureItemCopyWithImpl(this._self, this._then);

  final PrivacyDisclosureItem _self;
  final $Res Function(PrivacyDisclosureItem) _then;

/// Create a copy of PrivacyDisclosureItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? title = null,Object? description = null,Object? status = null,Object? lastVerifiedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,lastVerifiedAt: freezed == lastVerifiedAt ? _self.lastVerifiedAt : lastVerifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivacyDisclosureItem].
extension PrivacyDisclosureItemPatterns on PrivacyDisclosureItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivacyDisclosureItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivacyDisclosureItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivacyDisclosureItem value)  $default,){
final _that = this;
switch (_that) {
case _PrivacyDisclosureItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivacyDisclosureItem value)?  $default,){
final _that = this;
switch (_that) {
case _PrivacyDisclosureItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  String title,  String description,  String status,  DateTime? lastVerifiedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivacyDisclosureItem() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.description,_that.status,_that.lastVerifiedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  String title,  String description,  String status,  DateTime? lastVerifiedAt)  $default,) {final _that = this;
switch (_that) {
case _PrivacyDisclosureItem():
return $default(_that.id,_that.type,_that.title,_that.description,_that.status,_that.lastVerifiedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  String title,  String description,  String status,  DateTime? lastVerifiedAt)?  $default,) {final _that = this;
switch (_that) {
case _PrivacyDisclosureItem() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.description,_that.status,_that.lastVerifiedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PrivacyDisclosureItem extends PrivacyDisclosureItem {
  const _PrivacyDisclosureItem({required this.id, required this.type, required this.title, required this.description, required this.status, this.lastVerifiedAt}): super._();
  factory _PrivacyDisclosureItem.fromJson(Map<String, dynamic> json) => _$PrivacyDisclosureItemFromJson(json);

@override final  String id;
@override final  String type;
@override final  String title;
@override final  String description;
@override final  String status;
@override final  DateTime? lastVerifiedAt;

/// Create a copy of PrivacyDisclosureItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivacyDisclosureItemCopyWith<_PrivacyDisclosureItem> get copyWith => __$PrivacyDisclosureItemCopyWithImpl<_PrivacyDisclosureItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrivacyDisclosureItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivacyDisclosureItem&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.lastVerifiedAt, lastVerifiedAt) || other.lastVerifiedAt == lastVerifiedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,description,status,lastVerifiedAt);

@override
String toString() {
  return 'PrivacyDisclosureItem(id: $id, type: $type, title: $title, description: $description, status: $status, lastVerifiedAt: $lastVerifiedAt)';
}


}

/// @nodoc
abstract mixin class _$PrivacyDisclosureItemCopyWith<$Res> implements $PrivacyDisclosureItemCopyWith<$Res> {
  factory _$PrivacyDisclosureItemCopyWith(_PrivacyDisclosureItem value, $Res Function(_PrivacyDisclosureItem) _then) = __$PrivacyDisclosureItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, String title, String description, String status, DateTime? lastVerifiedAt
});




}
/// @nodoc
class __$PrivacyDisclosureItemCopyWithImpl<$Res>
    implements _$PrivacyDisclosureItemCopyWith<$Res> {
  __$PrivacyDisclosureItemCopyWithImpl(this._self, this._then);

  final _PrivacyDisclosureItem _self;
  final $Res Function(_PrivacyDisclosureItem) _then;

/// Create a copy of PrivacyDisclosureItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? title = null,Object? description = null,Object? status = null,Object? lastVerifiedAt = freezed,}) {
  return _then(_PrivacyDisclosureItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,lastVerifiedAt: freezed == lastVerifiedAt ? _self.lastVerifiedAt : lastVerifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
