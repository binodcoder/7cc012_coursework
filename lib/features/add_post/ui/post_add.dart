import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../db/db_helper.dart';
import '../../../resources/strings_manager.dart';
import '../../home/bloc/post_state.dart';
import '../../home/model/post_model.dart';
import '../bloc/post_add_bloc.dart';
import '../bloc/post_add_event.dart';
import '../bloc/post_add_state.dart';

class AddPost extends StatefulWidget {
  const AddPost({
    super.key,
    this.post,
  });

  final Post? post;

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();

  String? imagePath;

  Widget _imageDisplay(String imagePath) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Image.file(File(imagePath)),
    );
  }

  Widget _imagePickerButtons(PostAddBloc postBloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            postBloc.add(PostAddPickFromGalaryButtonPressEvent());
          },
          child: const Text('Pick from gallery'),
        ),
        ElevatedButton(
          onPressed: () {
            postBloc.add(PostAddPickFromCameraButtonPressEvent());
          },
          child: const Text('Pick from camera'),
        ),
      ],
    );
  }

  @override
  void initState() {
    postAddBloc.add(PostAddInitialEvent());
    super.initState();
  }

  final PostAddBloc postAddBloc = PostAddBloc();

  @override
  Widget build(BuildContext context) {
    if (widget.post != null) {
      titleController.text = widget.post!.title;
      contentController.text = widget.post!.content;
      imagePath = widget.post!.imagePath;
    }

    // var postBloc = BlocProvider.of<PostBloc>(context);

    return BlocConsumer<PostAddBloc, PostAddState>(
      bloc: postAddBloc,
      listenWhen: (previous, current) => current is PostAddActionState,
      buildWhen: (previous, current) => current is! PostAddActionState,
      listener: (context, state) {
        if (state is AddPostImagePickedFromGalaryState) {
          setState(() {
            imagePath = state.imagePath;
          });
        } else if (state is AddPostImagePickedFromCameraState) {
          setState(() {
            imagePath = state.imagePath;
          });
        } else if (state is AddPostSavedState) {}
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case PostAddInitialState:
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
                _imagePickerButtons(postAddBloc),
                const SizedBox(height: 20),
                imagePath == null ? const Text('no image') : _imageDisplay(imagePath!),
                ElevatedButton(
                  onPressed: () async {
                    var title = titleController.text;
                    var content = contentController.text;

                    if (title.isNotEmpty && content.isNotEmpty) {
                      if (widget.post != null) {
                        // Update post to local database
                        var updatedPost = Post(
                          widget.post!.id,
                          titleController.text,
                          contentController.text,
                          imagePath!,
                          0,
                        );
                        await dbHelper.updatePost(updatedPost);
                        postAddBloc.add(PostAddUpdateButtonPressEvent());
                      } else {
                        var newPost = Post(
                          //Save post to local database
                          // Using timestamp as a unique identifier
                          DateTime.now().toString(),
                          title,
                          content,
                          imagePath!,
                          0,
                        );
                        await dbHelper.insertPost(newPost);
                        postAddBloc.add(PostAddSaveButtonPressEvent());
                      }

                      titleController.clear();
                      contentController.clear();
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  child: Text(
                    widget.post == null ? AppStrings.addPost : AppStrings.updatePost,
                  ),
                ),
              ]),
            );

          case PostErrorState:
            return const Scaffold(body: Center(child: Text('Error')));
          default:
            return const SizedBox();
        }
      },
    );
  }
}
