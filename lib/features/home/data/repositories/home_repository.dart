import 'package:flutter_foundation/core/network/result.dart';
import 'package:flutter_foundation/core/network/safe_api_call.dart';
import 'package:flutter_foundation/features/home/data/models/post_model.dart';
import 'package:flutter_foundation/features/home/data/sources/home_api.dart';

/// The ViewModel depends on this interface, so it can be mocked in tests.
abstract interface class HomeRepository {
  Future<Result<List<PostModel>>> getPosts();
}

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._api);

  final HomeApi _api;

  @override
  Future<Result<List<PostModel>>> getPosts() => safeApiCall(_api.getPosts);
}
