import 'package:flutter_foundation/core/network/failure.dart';

/// Repository return type: either [Ok] with data or [Err] with a [Failure].
/// Use `switch` to handle both cases exhaustively.
sealed class Result<T> {
  const Result();
}

final class Ok<T> extends Result<T> {
  const Ok(this.data);

  final T data;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);

  final Failure failure;
}
