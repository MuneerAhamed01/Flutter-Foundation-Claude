import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_foundation/core/network/failure.dart';

part 'view_state.freezed.dart';

/// Generic state for ViewModels that load one piece of data.
/// Screens with richer state should define their own freezed state class.
@freezed
sealed class ViewState<T> with _$ViewState<T> {
  const factory ViewState.initial() = ViewInitial<T>;
  const factory ViewState.loading() = ViewLoading<T>;
  const factory ViewState.success(T data) = ViewSuccess<T>;
  const factory ViewState.failure(Failure failure) = ViewFailure<T>;
}
