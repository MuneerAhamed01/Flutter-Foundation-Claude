// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'view_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ViewState<T> {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ViewState<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ViewState<$T>()';
}


}

/// @nodoc
class $ViewStateCopyWith<T,$Res>  {
$ViewStateCopyWith(ViewState<T> _, $Res Function(ViewState<T>) __);
}


/// Adds pattern-matching-related methods to [ViewState].
extension ViewStatePatterns<T> on ViewState<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ViewInitial<T> value)?  initial,TResult Function( ViewLoading<T> value)?  loading,TResult Function( ViewSuccess<T> value)?  success,TResult Function( ViewFailure<T> value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ViewInitial() when initial != null:
return initial(_that);case ViewLoading() when loading != null:
return loading(_that);case ViewSuccess() when success != null:
return success(_that);case ViewFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ViewInitial<T> value)  initial,required TResult Function( ViewLoading<T> value)  loading,required TResult Function( ViewSuccess<T> value)  success,required TResult Function( ViewFailure<T> value)  failure,}){
final _that = this;
switch (_that) {
case ViewInitial():
return initial(_that);case ViewLoading():
return loading(_that);case ViewSuccess():
return success(_that);case ViewFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ViewInitial<T> value)?  initial,TResult? Function( ViewLoading<T> value)?  loading,TResult? Function( ViewSuccess<T> value)?  success,TResult? Function( ViewFailure<T> value)?  failure,}){
final _that = this;
switch (_that) {
case ViewInitial() when initial != null:
return initial(_that);case ViewLoading() when loading != null:
return loading(_that);case ViewSuccess() when success != null:
return success(_that);case ViewFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( T data)?  success,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ViewInitial() when initial != null:
return initial();case ViewLoading() when loading != null:
return loading();case ViewSuccess() when success != null:
return success(_that.data);case ViewFailure() when failure != null:
return failure(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( T data)  success,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case ViewInitial():
return initial();case ViewLoading():
return loading();case ViewSuccess():
return success(_that.data);case ViewFailure():
return failure(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( T data)?  success,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case ViewInitial() when initial != null:
return initial();case ViewLoading() when loading != null:
return loading();case ViewSuccess() when success != null:
return success(_that.data);case ViewFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class ViewInitial<T> implements ViewState<T> {
  const ViewInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ViewInitial<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ViewState<$T>.initial()';
}


}




/// @nodoc


class ViewLoading<T> implements ViewState<T> {
  const ViewLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ViewLoading<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ViewState<$T>.loading()';
}


}




/// @nodoc


class ViewSuccess<T> implements ViewState<T> {
  const ViewSuccess(this.data);
  

 final  T data;

/// Create a copy of ViewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ViewSuccessCopyWith<T, ViewSuccess<T>> get copyWith => _$ViewSuccessCopyWithImpl<T, ViewSuccess<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ViewSuccess<T>&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(data));
}

@override
String toString() {
    return 'ViewState<$T>.success(data: $data)';
}


}

/// @nodoc
abstract mixin class $ViewSuccessCopyWith<T,$Res> implements $ViewStateCopyWith<T, $Res> {
  factory $ViewSuccessCopyWith(ViewSuccess<T> value, $Res Function(ViewSuccess<T>) _then) = _$ViewSuccessCopyWithImpl;
@useResult
$Res call({
 T data
});




}
/// @nodoc
class _$ViewSuccessCopyWithImpl<T,$Res>
    implements $ViewSuccessCopyWith<T, $Res> {
  _$ViewSuccessCopyWithImpl(this._self, this._then);

  final ViewSuccess<T> _self;
  final $Res Function(ViewSuccess<T>) _then;

/// Create a copy of ViewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(ViewSuccess<T>(
freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

/// @nodoc


class ViewFailure<T> implements ViewState<T> {
  const ViewFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of ViewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ViewFailureCopyWith<T, ViewFailure<T>> get copyWith => _$ViewFailureCopyWithImpl<T, ViewFailure<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ViewFailure<T>&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,failure);
}

@override
String toString() {
    return 'ViewState<$T>.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ViewFailureCopyWith<T,$Res> implements $ViewStateCopyWith<T, $Res> {
  factory $ViewFailureCopyWith(ViewFailure<T> value, $Res Function(ViewFailure<T>) _then) = _$ViewFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$ViewFailureCopyWithImpl<T,$Res>
    implements $ViewFailureCopyWith<T, $Res> {
  _$ViewFailureCopyWithImpl(this._self, this._then);

  final ViewFailure<T> _self;
  final $Res Function(ViewFailure<T>) _then;

/// Create a copy of ViewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(ViewFailure<T>(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
