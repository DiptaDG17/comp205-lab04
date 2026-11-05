
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/posts_view_model.dart';

/// Part 4: loading, error, offline banner and the list.
class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PostsViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Campus Feed')),
      // TODO(4.2): show
      //  - a CircularProgressIndicator while loading (and no posts yet)
      //  - on error: the error text and a FilledButton 'Try again' that calls load()
      //  - otherwise a Column: if offline, a banner with the text
      //    'Offline - showing saved posts', then an Expanded list of ListTiles
      //    (title, and the body as subtitle with maxLines: 2)
      //  - bonus: RefreshIndicator for pull-to-refresh
      body: vm.loading && vm.posts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : vm.error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(vm.error!),
                      FilledButton(
                        onPressed: vm.load,
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    if (vm.offline)
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('Offline - showing saved posts'),
                      ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: vm.posts.length,
                        itemBuilder: (context, index) {
                          final post = vm.posts[index];
                          return ListTile(
                            title: Text(post.title),
                            subtitle: Text(post.body, maxLines: 2),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}

