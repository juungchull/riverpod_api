import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_api/model/post.dart';
import 'package:riverpod_api/state/post_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeScreen'),
      ),
      body: Center(
        child: Consumer(
          builder: (context, ref, child) {
            PostState state = ref.watch(postsProvider);
            if (state is InitialPostState) {
              return const Text(
                'press FAB to Fetch Data',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              );
            }

            if (state is PostsLoadingPostSate) {
              return const CircularProgressIndicator();
            }

            if (state is ErrorPostState) {
              return Text(state.message);
            }

            if (state is PostsLoadedPostState) {
              return _buildListView(state);
            }
            return const Text('Nothing found');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(postsProvider.notifier).fetchPosts();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListView(PostsLoadedPostState state) {
    return ListView.builder(
      itemCount: state.posts.length,
      itemBuilder: (context, index) {
        Post post = state.posts[index];

        return ListTile(
          leading: CircleAvatar(
            child: Text(post.id.toString()),
          ),
          title: Text(
            post.title,
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(post.body),
        );
      },
    );
  }
}
