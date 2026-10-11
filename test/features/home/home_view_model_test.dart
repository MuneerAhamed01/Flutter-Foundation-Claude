import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_foundation/core/base/view_state.dart';
import 'package:flutter_foundation/core/network/failure.dart';
import 'package:flutter_foundation/core/network/result.dart';
import 'package:flutter_foundation/features/home/data/models/post_model.dart';
import 'package:flutter_foundation/features/home/data/repositories/home_repository.dart';
import 'package:flutter_foundation/features/home/presentation/view_models/home_view_model.dart';

class _MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late _MockHomeRepository repository;

  const posts = [PostModel(id: 1, userId: 1, title: 'title', body: 'body')];
  const failure = NetworkFailure();

  setUp(() => repository = _MockHomeRepository());

  blocTest<HomeViewModel, ViewState<List<PostModel>>>(
    'emits [loading, success] when posts load',
    setUp: () =>
        when(() => repository.getPosts())
            .thenAnswer((_) async => const Ok(posts)),
    build: () => HomeViewModel(repository),
    act: (vm) => vm.load(),
    expect: () => const [
      ViewState<List<PostModel>>.loading(),
      ViewState<List<PostModel>>.success(posts),
    ],
  );

  blocTest<HomeViewModel, ViewState<List<PostModel>>>(
    'emits [loading, failure] when the request fails',
    setUp: () =>
        when(() => repository.getPosts())
            .thenAnswer((_) async => const Err(failure)),
    build: () => HomeViewModel(repository),
    act: (vm) => vm.load(),
    expect: () => const [
      ViewState<List<PostModel>>.loading(),
      ViewState<List<PostModel>>.failure(failure),
    ],
  );
}
