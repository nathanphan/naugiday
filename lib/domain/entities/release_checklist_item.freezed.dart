// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'release_checklist_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReleaseChecklistItem {

 String get id; String get title; String get status; String? get owner; String? get notes;
/// Create a copy of ReleaseChecklistItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReleaseChecklistItemCopyWith<ReleaseChecklistItem> get copyWith => _$ReleaseChecklistItemCopyWithImpl<ReleaseChecklistItem>(this as ReleaseChecklistItem, _$identity);

  /// Serializes this ReleaseChecklistItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReleaseChecklistItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,status,owner,notes);

@override
String toString() {
  return 'ReleaseChecklistItem(id: $id, title: $title, status: $status, owner: $owner, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $ReleaseChecklistItemCopyWith<$Res>  {
  factory $ReleaseChecklistItemCopyWith(ReleaseChecklistItem value, $Res Function(ReleaseChecklistItem) _then) = _$ReleaseChecklistItemCopyWithImpl;
@useResult
$Res call({
 String id, String title, String status, String? owner, String? notes
});




}
/// @nodoc
class _$ReleaseChecklistItemCopyWithImpl<$Res>
    implements $ReleaseChecklistItemCopyWith<$Res> {
  _$ReleaseChecklistItemCopyWithImpl(this._self, this._then);

  final ReleaseChecklistItem _self;
  final $Res Function(ReleaseChecklistItem) _then;

/// Create a copy of ReleaseChecklistItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? status = null,Object? owner = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReleaseChecklistItem].
extension ReleaseChecklistItemPatterns on ReleaseChecklistItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReleaseChecklistItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReleaseChecklistItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReleaseChecklistItem value)  $default,){
final _that = this;
switch (_that) {
case _ReleaseChecklistItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReleaseChecklistItem value)?  $default,){
final _that = this;
switch (_that) {
case _ReleaseChecklistItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String status,  String? owner,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReleaseChecklistItem() when $default != null:
return $default(_that.id,_that.title,_that.status,_that.owner,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String status,  String? owner,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _ReleaseChecklistItem():
return $default(_that.id,_that.title,_that.status,_that.owner,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String status,  String? owner,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _ReleaseChecklistItem() when $default != null:
return $default(_that.id,_that.title,_that.status,_that.owner,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReleaseChecklistItem extends ReleaseChecklistItem {
  const _ReleaseChecklistItem({required this.id, required this.title, required this.status, this.owner, this.notes}): super._();
  factory _ReleaseChecklistItem.fromJson(Map<String, dynamic> json) => _$ReleaseChecklistItemFromJson(json);

@override final  String id;
@override final  String title;
@override final  String status;
@override final  String? owner;
@override final  String? notes;

/// Create a copy of ReleaseChecklistItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReleaseChecklistItemCopyWith<_ReleaseChecklistItem> get copyWith => __$ReleaseChecklistItemCopyWithImpl<_ReleaseChecklistItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReleaseChecklistItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReleaseChecklistItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,status,owner,notes);

@override
String toString() {
  return 'ReleaseChecklistItem(id: $id, title: $title, status: $status, owner: $owner, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$ReleaseChecklistItemCopyWith<$Res> implements $ReleaseChecklistItemCopyWith<$Res> {
  factory _$ReleaseChecklistItemCopyWith(_ReleaseChecklistItem value, $Res Function(_ReleaseChecklistItem) _then) = __$ReleaseChecklistItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String status, String? owner, String? notes
});




}
/// @nodoc
class __$ReleaseChecklistItemCopyWithImpl<$Res>
    implements _$ReleaseChecklistItemCopyWith<$Res> {
  __$ReleaseChecklistItemCopyWithImpl(this._self, this._then);

  final _ReleaseChecklistItem _self;
  final $Res Function(_ReleaseChecklistItem) _then;

/// Create a copy of ReleaseChecklistItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? status = null,Object? owner = freezed,Object? notes = freezed,}) {
  return _then(_ReleaseChecklistItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
