part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class GetPostsStarted extends HomeEvent {}

class GetPostsSuccess extends HomeEvent {
  final List<Post> posts;

  GetPostsSuccess(this.posts);
}

class GetPostsFailed extends HomeEvent {
  final DioException exception;

  GetPostsFailed(this.exception);
}
