// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_queue_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScanQueueItem {

 String get id; String get scanImageId; DateTime get queuedAt; int get retryCount; DateTime? get lastAttemptAt; ScanQueueStatus get status;
/// Create a copy of ScanQueueItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScanQueueItemCopyWith<ScanQueueItem> get copyWith => _$ScanQueueItemCopyWithImpl<ScanQueueItem>(this as ScanQueueItem, _$identity);

  /// Serializes this ScanQueueItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanQueueItem&&(identical(other.id, id) || other.id == id)&&(identical(other.scanImageId, scanImageId) || other.scanImageId == scanImageId)&&(identical(other.queuedAt, queuedAt) || other.queuedAt == queuedAt)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount)&&(identical(other.lastAttemptAt, lastAttemptAt) || other.lastAttemptAt == lastAttemptAt)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,scanImageId,queuedAt,retryCount,lastAttemptAt,status);

@override
String toString() {
  return 'ScanQueueItem(id: $id, scanImageId: $scanImageId, queuedAt: $queuedAt, retryCount: $retryCount, lastAttemptAt: $lastAttemptAt, status: $status)';
}


}

/// @nodoc
abstract mixin class $ScanQueueItemCopyWith<$Res>  {
  factory $ScanQueueItemCopyWith(ScanQueueItem value, $Res Function(ScanQueueItem) _then) = _$ScanQueueItemCopyWithImpl;
@useResult
$Res call({
 String id, String scanImageId, DateTime queuedAt, int retryCount, DateTime? lastAttemptAt, ScanQueueStatus status
});




}
/// @nodoc
class _$ScanQueueItemCopyWithImpl<$Res>
    implements $ScanQueueItemCopyWith<$Res> {
  _$ScanQueueItemCopyWithImpl(this._self, this._then);

  final ScanQueueItem _self;
  final $Res Function(ScanQueueItem) _then;

/// Create a copy of ScanQueueItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? scanImageId = null,Object? queuedAt = null,Object? retryCount = null,Object? lastAttemptAt = freezed,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scanImageId: null == scanImageId ? _self.scanImageId : scanImageId // ignore: cast_nullable_to_non_nullable
as String,queuedAt: null == queuedAt ? _self.queuedAt : queuedAt // ignore: cast_nullable_to_non_nullable
as DateTime,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,lastAttemptAt: freezed == lastAttemptAt ? _self.lastAttemptAt : lastAttemptAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ScanQueueStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [ScanQueueItem].
extension ScanQueueItemPatterns on ScanQueueItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScanQueueItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScanQueueItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScanQueueItem value)  $default,){
final _that = this;
switch (_that) {
case _ScanQueueItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScanQueueItem value)?  $default,){
final _that = this;
switch (_that) {
case _ScanQueueItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String scanImageId,  DateTime queuedAt,  int retryCount,  DateTime? lastAttemptAt,  ScanQueueStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScanQueueItem() when $default != null:
return $default(_that.id,_that.scanImageId,_that.queuedAt,_that.retryCount,_that.lastAttemptAt,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String scanImageId,  DateTime queuedAt,  int retryCount,  DateTime? lastAttemptAt,  ScanQueueStatus status)  $default,) {final _that = this;
switch (_that) {
case _ScanQueueItem():
return $default(_that.id,_that.scanImageId,_that.queuedAt,_that.retryCount,_that.lastAttemptAt,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String scanImageId,  DateTime queuedAt,  int retryCount,  DateTime? lastAttemptAt,  ScanQueueStatus status)?  $default,) {final _that = this;
switch (_that) {
case _ScanQueueItem() when $default != null:
return $default(_that.id,_that.scanImageId,_that.queuedAt,_that.retryCount,_that.lastAttemptAt,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScanQueueItem extends ScanQueueItem {
  const _ScanQueueItem({required this.id, required this.scanImageId, required this.queuedAt, this.retryCount = 0, this.lastAttemptAt, required this.status}): super._();
  factory _ScanQueueItem.fromJson(Map<String, dynamic> json) => _$ScanQueueItemFromJson(json);

@override final  String id;
@override final  String scanImageId;
@override final  DateTime queuedAt;
@override@JsonKey() final  int retryCount;
@override final  DateTime? lastAttemptAt;
@override final  ScanQueueStatus status;

/// Create a copy of ScanQueueItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScanQueueItemCopyWith<_ScanQueueItem> get copyWith => __$ScanQueueItemCopyWithImpl<_ScanQueueItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScanQueueItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScanQueueItem&&(identical(other.id, id) || other.id == id)&&(identical(other.scanImageId, scanImageId) || other.scanImageId == scanImageId)&&(identical(other.queuedAt, queuedAt) || other.queuedAt == queuedAt)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount)&&(identical(other.lastAttemptAt, lastAttemptAt) || other.lastAttemptAt == lastAttemptAt)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,scanImageId,queuedAt,retryCount,lastAttemptAt,status);

@override
String toString() {
  return 'ScanQueueItem(id: $id, scanImageId: $scanImageId, queuedAt: $queuedAt, retryCount: $retryCount, lastAttemptAt: $lastAttemptAt, status: $status)';
}


}

/// @nodoc
abstract mixin class _$ScanQueueItemCopyWith<$Res> implements $ScanQueueItemCopyWith<$Res> {
  factory _$ScanQueueItemCopyWith(_ScanQueueItem value, $Res Function(_ScanQueueItem) _then) = __$ScanQueueItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String scanImageId, DateTime queuedAt, int retryCount, DateTime? lastAttemptAt, ScanQueueStatus status
});




}
/// @nodoc
class __$ScanQueueItemCopyWithImpl<$Res>
    implements _$ScanQueueItemCopyWith<$Res> {
  __$ScanQueueItemCopyWithImpl(this._self, this._then);

  final _ScanQueueItem _self;
  final $Res Function(_ScanQueueItem) _then;

/// Create a copy of ScanQueueItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? scanImageId = null,Object? queuedAt = null,Object? retryCount = null,Object? lastAttemptAt = freezed,Object? status = null,}) {
  return _then(_ScanQueueItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scanImageId: null == scanImageId ? _self.scanImageId : scanImageId // ignore: cast_nullable_to_non_nullable
as String,queuedAt: null == queuedAt ? _self.queuedAt : queuedAt // ignore: cast_nullable_to_non_nullable
as DateTime,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,lastAttemptAt: freezed == lastAttemptAt ? _self.lastAttemptAt : lastAttemptAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ScanQueueStatus,
  ));
}


}

// dart format on
