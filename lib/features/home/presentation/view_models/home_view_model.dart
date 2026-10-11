import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foundation/core/base/view_state.dart';
import 'package:flutter_foundation/core/network/result.dart';
import 'package:flutter_foundation/features/home/data/models/post_model.dart';
import 'package:flutter_foundation/features/home/data/repositories/home_repository.dart';

/// ViewModel = Cubit. Holds UI state, talks to repositories, never to widgets.
class HomeViewModel extends Cubit<ViewState<List<PostModel>>> {
  HomeViewModel(this._repository) : super(const ViewState.initial());

  final HomeRepository _repository;

  Future<void> load() async {
    emit(const ViewState.loading());
    final result = await _repository.getPosts();
    emit(switch (result) {
      Ok(:final data) => ViewState.success(data),
      Err(:final failure) => ViewState.failure(failure),
    });
  }
}
