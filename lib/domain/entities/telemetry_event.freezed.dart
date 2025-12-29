// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'telemetry_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TelemetryEvent {

 String get name; DateTime get occurredAt; String? get screenName; Map<String, String>? get metadata;
/// Create a copy of TelemetryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TelemetryEventCopyWith<TelemetryEvent> get copyWith => _$TelemetryEventCopyWithImpl<TelemetryEvent>(this as TelemetryEvent, _$identity);

  /// Serializes this TelemetryEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TelemetryEvent&&(identical(other.name, name) || other.name == name)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.screenName, screenName) || other.screenName == screenName)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,occurredAt,screenName,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'TelemetryEvent(name: $name, occurredAt: $occurredAt, screenName: $screenName, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $TelemetryEventCopyWith<$Res>  {
  factory $TelemetryEventCopyWith(TelemetryEvent value, $Res Function(TelemetryEvent) _then) = _$TelemetryEventCopyWithImpl;
@useResult
$Res call({
 String name, DateTime occurredAt, String? screenName, Map<String, String>? metadata
});




}
/// @nodoc
class _$TelemetryEventCopyWithImpl<$Res>
    implements $TelemetryEventCopyWith<$Res> {
  _$TelemetryEventCopyWithImpl(this._self, this._then);

  final TelemetryEvent _self;
  final $Res Function(TelemetryEvent) _then;

/// Create a copy of TelemetryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? occurredAt = null,Object? screenName = freezed,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,screenName: freezed == screenName ? _self.screenName : screenName // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [TelemetryEvent].
extension TelemetryEventPatterns on TelemetryEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TelemetryEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TelemetryEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TelemetryEvent value)  $default,){
final _that = this;
switch (_that) {
case _TelemetryEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TelemetryEvent value)?  $default,){
final _that = this;
switch (_that) {
case _TelemetryEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  DateTime occurredAt,  String? screenName,  Map<String, String>? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TelemetryEvent() when $default != null:
return $default(_that.name,_that.occurredAt,_that.screenName,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  DateTime occurredAt,  String? screenName,  Map<String, String>? metadata)  $default,) {final _that = this;
switch (_that) {
case _TelemetryEvent():
return $default(_that.name,_that.occurredAt,_that.screenName,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  DateTime occurredAt,  String? screenName,  Map<String, String>? metadata)?  $default,) {final _that = this;
switch (_that) {
case _TelemetryEvent() when $default != null:
return $default(_that.name,_that.occurredAt,_that.screenName,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TelemetryEvent extends TelemetryEvent {
  const _TelemetryEvent({required this.name, required this.occurredAt, this.screenName, final  Map<String, String>? metadata}): _metadata = metadata,super._();
  factory _TelemetryEvent.fromJson(Map<String, dynamic> json) => _$TelemetryEventFromJson(json);

@override final  String name;
@override final  DateTime occurredAt;
@override final  String? screenName;
 final  Map<String, String>? _metadata;
@override Map<String, String>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of TelemetryEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TelemetryEventCopyWith<_TelemetryEvent> get copyWith => __$TelemetryEventCopyWithImpl<_TelemetryEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TelemetryEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TelemetryEvent&&(identical(other.name, name) || other.name == name)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.screenName, screenName) || other.screenName == screenName)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,occurredAt,screenName,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'TelemetryEvent(name: $name, occurredAt: $occurredAt, screenName: $screenName, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$TelemetryEventCopyWith<$Res> implements $TelemetryEventCopyWith<$Res> {
  factory _$TelemetryEventCopyWith(_TelemetryEvent value, $Res Function(_TelemetryEvent) _then) = __$TelemetryEventCopyWithImpl;
@override @useResult
$Res call({
 String name, DateTime occurredAt, String? screenName, Map<String, String>? metadata
});




}
/// @nodoc
class __$TelemetryEventCopyWithImpl<$Res>
    implements _$TelemetryEventCopyWith<$Res> {
  __$TelemetryEventCopyWithImpl(this._self, this._then);

  final _TelemetryEvent _self;
  final $Res Function(_TelemetryEvent) _then;

/// Create a copy of TelemetryEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? occurredAt = null,Object? screenName = freezed,Object? metadata = freezed,}) {
  return _then(_TelemetryEvent(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,screenName: freezed == screenName ? _self.screenName : screenName // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}


}

// dart format on
