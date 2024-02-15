import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_blog_bloc/resources/colour_manager.dart';
import 'package:my_blog_bloc/resources/strings_manager.dart';
import '../../../db/db_helper.dart';
import '../bloc/post_bloc.dart';
import '../bloc/post_event.dart';
import '../bloc/post_state.dart';
import '../model/post_model.dart';
import 'post_add.dart';
import 'post_details.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final DatabaseHelper dbHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    var postBloc = BlocProvider.of<PostBloc>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => AddPost(),
              fullscreenDialog: true,
            ),
          );
        },
      ),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(AppStrings.titleLabel),
            TextButton(
              onPressed: () async {
                postBloc.add(DeletePostEvents(postBloc.selectedPosts));

                for (var element in postBloc.selectedPosts) {
                  await dbHelper.deletePost(element.id);
                  postBloc.add(DeletePostEvent(element.id));
                }
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  color: ColorManager.white,
                ),
              ),
            )
          ],
        ),
      ),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          return FutureBuilder<List<Post>>(
            future: dbHelper.getPosts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('${AppStrings.error}: ${snapshot.error}');
              } else {
                var posts = snapshot.data as List<Post>;

                for (var element in posts) {
                  if (element.isSelected == 1) {
                    postBloc.selectedPosts.add(element);
                  }
                }

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    var post = posts[index];
                    return ListTile(
                      tileColor: post.isSelected == 0 ? ColorManager.white : ColorManager.grey,
                      onLongPress: () async {
                        var updatedPost = post;
                        if (updatedPost.isSelected == 0) {
                          updatedPost.isSelected = 1;
                          postBloc.add(SelectPostEvent(updatedPost));
                        } else {
                          updatedPost.isSelected = 0;
                          postBloc.add(DeSelectPostEvent(updatedPost));
                        }
                        await dbHelper.updatePost(updatedPost);
                        // postBloc.add(UpdatePostEvent(updatedPost));
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => PostDetailsPage(
                              post: post,
                            ),
                          ),
                        );
                      },
                      title: Text(post.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post.content),
                          if (post.imageUrl.isNotEmpty)
                            Image.network(
                              post.imageUrl,
                              height: 100,
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => AddPost(
                                        post: post,
                                      ),
                                      fullscreenDialog: true,
                                    ),
                                  );
                                },
                                child: const Text(AppStrings.edit),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await dbHelper.deletePost(post.id);
                                  postBloc.add(DeletePostEvent(post.id));
                                },
                                child: const Text(AppStrings.delete),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
