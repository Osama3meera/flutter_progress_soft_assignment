import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:osama_hasan_progress_soft/model/post/post.dart';
import 'package:osama_hasan_progress_soft/network/dio_client.dart';
import 'package:osama_hasan_progress_soft/network/request_state.dart';

@lazySingleton
class PostRepository {
  final DioClient _dioClient;

  PostRepository(this._dioClient);

  Future<RequestState<List<Post>>> fetchPosts() async {
    try {
      final response = await _dioClient.get('/posts');
      final List<Post> posts =
          (response.data as List).map((json) => Post.fromJson(json)).toList();
      return Success(data: posts);
    } on DioException catch (e) {
      return Error(exception: e);
    }
  }
}
