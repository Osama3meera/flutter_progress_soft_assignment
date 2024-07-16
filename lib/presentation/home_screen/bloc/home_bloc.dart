import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osama_hasan_progress_soft/data/posts_repository/posts_repository.dart';
import 'package:osama_hasan_progress_soft/di/injection.dart';
import 'package:osama_hasan_progress_soft/model/post/post.dart';
import 'package:osama_hasan_progress_soft/network/request_state.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final postsRepository = getIt<PostRepository>();

  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {});

    on<GetPostsStarted>((event, emit) {
      emit.call(GetPostLoadingState());
      _getPosts();
    });

    on<GetPostsSuccess>((event, emit) {
      emit.call((GetPostSuccessState(event.posts)));
    });

    on<GetPostsFailed>((event, emit) {
      emit.call((GetPostErrorState(event.exception)));
    });
  }

  Future<void> _getPosts() async {
    await postsRepository.fetchPosts().then((value) {
      if (value is Success<List<Post>>) {
        add(GetPostsSuccess(value.data));
      } else if (value is Error<List<Post>>) {
        add(GetPostsFailed(value.exception));
      }
    });
  }
}
