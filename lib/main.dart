import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'db_helper.dart';

void main() {
  runApp(MyApp());
}

class Post {
  final String id; // Unique identifier for each post
  String title;
  String content;
  String imageUrl;

  Post(this.id, this.title, this.content, this.imageUrl);

  // Convert Post object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
    };
  }
}

abstract class PostEvent {}

class AddPostEvent extends PostEvent {
  final Post post;

  AddPostEvent(this.post);
}

class UpdatePostEvent extends PostEvent {
  final Post updatedPost;

  UpdatePostEvent(this.updatedPost);
}

class DeletePostEvent extends PostEvent {
  final String postId;

  DeletePostEvent(this.postId);
}

class PostState {
  final List<Post> posts;

  PostState(this.posts);

  PostState copyWith({List<Post>? posts}) {
    return PostState(posts ?? this.posts);
  }
}

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostState([]));

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if (event is AddPostEvent) {
      List<Post> updatedPosts = List.from(state.posts)..add(event.post);
      yield state.copyWith(posts: updatedPosts);
    } else if (event is UpdatePostEvent) {
      List<Post> updatedPosts = state.posts.map((post) {
        if (post.id == event.updatedPost.id) {
          return event.updatedPost;
        }
        return post;
      }).toList();
      yield state.copyWith(posts: updatedPosts);
    } else if (event is DeletePostEvent) {
      List<Post> updatedPosts = state.posts.where((post) => post.id != event.postId).toList();
      yield state.copyWith(posts: updatedPosts);
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc(),
      child: MaterialApp(
        title: 'Flutter Blog App with BLoC',
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    var postBloc = BlocProvider.of<PostBloc>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter Blog App with BLoC'),
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: 'Content'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: imageController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              var title = titleController.text;
              var content = contentController.text;
              var imageUrl = imageController.text;

              if (title.isNotEmpty && content.isNotEmpty) {
                var newPost = Post(
                  DateTime.now().toString(), // Using timestamp as a unique identifier
                  title,
                  content,
                  imageUrl,
                );
                // Save post to local database
                await dbHelper.insertPost(newPost);
                postBloc.add(AddPostEvent(newPost));

                titleController.clear();
                contentController.clear();
                imageController.clear();
              }
            },
            child: Text('Add Post'),
          ),
          BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              return Expanded(
                child: FutureBuilder<List<Post>>(
                  future: dbHelper.getPosts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      var posts = snapshot.data as List<Post>;

                      return ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          var post = posts[index];
                          return ListTile(
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
                                        _navigateToEditScreen(context, post);
                                      },
                                      child: Text('Edit'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await dbHelper.deletePost(post.id);
                                        postBloc.add(DeletePostEvent(post.id));
                                      },
                                      child: Text('Delete'),
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
                ),
              );
            },
          )
        ]));
  }

  // Function to navigate to Edit Screen
  void _navigateToEditScreen(BuildContext context, Post post) {
    titleController.text = post.title;
    contentController.text = post.content;
    imageController.text = post.imageUrl;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Post'),
          content: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: 'Content'),
              ),
              TextField(
                controller: imageController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                var updatedPost = Post(
                  post.id,
                  titleController.text,
                  contentController.text,
                  imageController.text,
                );

                // Update post in local database
                await dbHelper.updatePost(updatedPost);

                // Update post in BLoC state
                BlocProvider.of<PostBloc>(context).add(UpdatePostEvent(updatedPost));

                titleController.clear();
                contentController.clear();
                imageController.clear();
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class EditPostDialog extends StatelessWidget {
  final Post post;
  final Function(Post) onEdit;

  const EditPostDialog({
    required this.post,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController(text: post.title);
    final TextEditingController contentController = TextEditingController(text: post.content);
    final TextEditingController imageController = TextEditingController(text: post.imageUrl);

    return AlertDialog(
      title: Text('Edit Post'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: contentController,
            decoration: InputDecoration(labelText: 'Content'),
          ),
          TextField(
            controller: imageController,
            decoration: InputDecoration(labelText: 'Image URL'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            var updatedPost = Post(
              post.id,
              titleController.text,
              contentController.text,
              imageController.text,
            );
            onEdit(updatedPost);
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
