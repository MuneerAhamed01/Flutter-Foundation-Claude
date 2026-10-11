import 'package:dio/dio.dart';
import 'package:flutter_foundation/features/home/data/models/post_model.dart';
import 'package:retrofit/retrofit.dart';

part 'home_api.g.dart';

/// Retrofit interface: declare endpoints, the generator writes the Dio code.
@RestApi()
abstract class HomeApi {
  factory HomeApi(Dio dio) = _HomeApi;

  @GET('/posts')
  Future<List<PostModel>> getPosts();

  @GET('/posts/{id}')
  Future<PostModel> getPost(@Path('id') int id);
}
