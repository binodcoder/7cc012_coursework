import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/post_bloc.dart';
import '../bloc/post_event.dart';
import '../../../db/db_helper.dart';
import '../../../resources/strings_manager.dart';
import '../model/post_model.dart';

class AddPost extends StatelessWidget {
  AddPost({
    super.key,
    this.post,
  });

  final Post? post;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    if (post != null) {
      titleController.text = post!.title;
      contentController.text = post!.content;
      imageController.text = post!.imageUrl;
    }

    var postBloc = BlocProvider.of<PostBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.titleLabel),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: AppStrings.title),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: contentController,
            decoration: const InputDecoration(labelText: AppStrings.content),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: imageController,
            decoration: const InputDecoration(labelText: AppStrings.imageURL),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            var title = titleController.text;
            var content = contentController.text;
            var imageUrl = imageController.text;

            if (title.isNotEmpty && content.isNotEmpty) {
              if (post != null) {
                // Update post to local database
                var updatedPost = Post(
                  post!.id,
                  titleController.text,
                  contentController.text,
                  imageController.text,
                  0,
                );
                await dbHelper.updatePost(updatedPost);
                postBloc.add(UpdatePostEvent(updatedPost));
              } else {
                var newPost = Post(
                  //Save post to local database
                  // Using timestamp as a unique identifier
                  DateTime.now().toString(),
                  title,
                  content,
                  imageUrl,
                  0,
                );
                await dbHelper.insertPost(newPost);
                postBloc.add(AddPostEvent(newPost));
              }

              titleController.clear();
              contentController.clear();
              imageController.clear();
              if (context.mounted) Navigator.pop(context);
            }
          },
          child: Text(
            post == null ? AppStrings.addPost : AppStrings.updatePost,
          ),
        ),
      ]),
    );
  }
}
