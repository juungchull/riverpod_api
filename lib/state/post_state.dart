import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_api/model/post.dart';
import 'package:riverpod_api/services/http_get_service.dart';

final postsProvider =
    StateNotifierProvider<PostsNotifier, PostState>((ref) => PostsNotifier());

@immutable
abstract class PostState {}

class InitialPostState extends PostState {}

class PostsLoadingPostSate extends PostState {}

class PostsLoadedPostState extends PostState {
  PostsLoadedPostState({
    required this.posts,
  });

  final List<Post> posts;
}

class ErrorPostState extends PostState {
  ErrorPostState({
    required this.message,
  });

  final String message;
}

class PostsNotifier extends StateNotifier<PostState> {
  PostsNotifier() : super(InitialPostState());
  final HttpGetPost _httpGetPost = HttpGetPost();

  void fetchPosts() async {
    try {
      state = PostsLoadingPostSate();
      List<Post> posts = await _httpGetPost.getPosts();
      state = PostsLoadedPostState(posts: posts);
      _httpGetPost.getPosts();
    } catch (e) {
      state = ErrorPostState(message: e.toString());
    }
  }
}
