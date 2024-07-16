part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class GetPostsStartedEvent extends HomeEvent {}

class GetPostsSuccessEvent extends HomeEvent {
  final List<Post> posts;

  GetPostsSuccessEvent(this.posts);
}

class GetPostsFailed extends HomeEvent {
  final DioException exception;

  GetPostsFailed(this.exception);
}

class FilterPostsEvent extends HomeEvent {
  final String query;

  FilterPostsEvent(this.query);
}

class GetUserInfoEvent extends HomeEvent {}

class GetUserInfoSuccessEvent extends HomeEvent {
  final int age;
  final String gender;
  final String mobile;
  final String name;

  GetUserInfoSuccessEvent(this.age, this.gender, this.mobile, this.name);
}

class UserLogoutEvent extends HomeEvent {}
