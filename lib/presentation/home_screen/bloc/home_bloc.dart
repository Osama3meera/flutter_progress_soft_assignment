import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osama_hasan_progress_soft/data/posts_repository/posts_repository.dart';
import 'package:osama_hasan_progress_soft/di/injection.dart';
import 'package:osama_hasan_progress_soft/model/post/post.dart';
import 'package:osama_hasan_progress_soft/network/request_state.dart';
import 'package:osama_hasan_progress_soft/util/shared_preference/share_preference_helper.dart';
import 'package:osama_hasan_progress_soft/util/shared_preference/shared_prefs_constants.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final postsRepository = getIt<PostRepository>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Post> allPosts = [];

  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {});

    on<GetPostsStartedEvent>((event, emit) async {
      emit.call(GetPostLoadingState());
      await _getPosts(emit);
    });

    on<GetPostsSuccessEvent>((event, emit) {
      emit.call(GetPostSuccessState(event.posts));
    });

    on<GetPostsFailed>((event, emit) {
      emit.call(GetPostErrorState(event.exception));
    });

    on<FilterPostsEvent>((event, emit) {
      List<Post> filteredPosts = allPosts.where((post) {
        return post.title.toLowerCase().contains(event.query.toLowerCase()) ||
            post.body.toLowerCase().contains(event.query.toLowerCase());
      }).toList();
      emit.call(GetPostSuccessState(filteredPosts));
    });

    on<GetUserInfoEvent>((event, emit) {
      _getUserInfo();
    });

    on<GetUserInfoSuccessEvent>((event, emit) {
      emit.call(GetUserInfoSuccessState(
          event.age, event.gender, event.mobile, event.name));
    });

    on<UserLogoutEvent>((event, emit) async {
      await _clearUserData().whenComplete(() {
        emit.call(UserLogoutState());
      });
    });
  }

  Future<void> _getPosts(Emitter<HomeState> emit) async {
    await postsRepository.fetchPosts().then((value) {
      if (value is Success<List<Post>>) {
        allPosts = value.data;
        add(GetPostsSuccessEvent(value.data));
      } else if (value is Error<List<Post>>) {
        add(GetPostsFailed(value.exception));
      }
    });
  }

  Future<void> _getUserInfo() async {
    String? userMobileNumber = await SharedPreferencesHelper.instance
        .getString(SharedPrefsConstants.userMobileNumber);

    try {
      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .where('mobile', isEqualTo: userMobileNumber)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        var userData = userSnapshot.docs.first.data() as Map<String, dynamic>;

        int storedAge = userData['age'];
        String storedGender = userData['gender'];
        String storedMobile = userData['mobile'];
        String storedName = userData['name'];

        add(GetUserInfoSuccessEvent(
            storedAge, storedGender, storedMobile, storedName));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _clearUserData() async {
    await SharedPreferencesHelper.instance
        .removeKey(SharedPrefsConstants.userMobileNumber);
    await SharedPreferencesHelper.instance
        .saveBool(SharedPrefsConstants.userLoggedIn, false);
  }
}
