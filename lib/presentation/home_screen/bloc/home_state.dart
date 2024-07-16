part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

class GetPostLoadingState extends HomeState {}

class GetPostSuccessState extends HomeState {
  final List<Post> posts;

  GetPostSuccessState(this.posts);
}

class GetPostErrorState extends HomeState {
  final DioException exception;

  GetPostErrorState(this.exception);
}

class GetUserInfoSuccessState extends HomeState {
  final int age;
  final String gender;
  final String mobile;
  final String name;

  GetUserInfoSuccessState(this.age, this.gender, this.mobile, this.name);
}

class UserLogoutState extends HomeState {}
