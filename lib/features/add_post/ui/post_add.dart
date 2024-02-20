import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_blog_bloc/features/home/ui/post.dart';
import '../../../db/db_helper.dart';
import '../../../resources/strings_manager.dart';
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
    if (widget.post != null) {
      titleController.text = widget.post!.title;
      contentController.text = widget.post!.content;

      postAddBloc.add(PostAddReadyToUpdateEvent(widget.post!));
    } else {
      postAddBloc.add(PostAddInitialEvent());
    }
    super.initState();
  }

  final PostAddBloc postAddBloc = PostAddBloc();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostAddBloc, PostAddState>(
      bloc: postAddBloc,
      listenWhen: (previous, current) => current is PostAddActionState,
      buildWhen: (previous, current) => current is! PostAddActionState,
      listener: (context, state) {
        if (state is AddPostSavedState) {
          titleController.clear();
          contentController.clear();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const HomeScreen(),
              fullscreenDialog: true,
            ),
          );
        } else if (state is AddPostUpdatedState) {
          titleController.clear();
          contentController.clear();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const HomeScreen(),
              fullscreenDialog: true,
            ),
          );
        }
      },
      builder: (context, state) {
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
            state.imagePath == null
                ? const Text('no image')
                : Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Image.file(File(state.imagePath!)),
                  ),
            ElevatedButton(
              onPressed: () async {
                var title = titleController.text;
                var content = contentController.text;
                var imagePath = state.imagePath;
                if (title.isNotEmpty && content.isNotEmpty) {
                  if (widget.post != null) {
                    var updatedPost = Post(
                      widget.post!.id,
                      titleController.text,
                      contentController.text,
                      imagePath!,
                      0,
                    );
                    postAddBloc.add(PostAddUpdateButtonPressEvent(updatedPost));
                  } else {
                    var newPost = Post(
                      DateTime.now().toString(),
                      title,
                      content,
                      imagePath!,
                      0,
                    );
                    postAddBloc.add(PostAddSaveButtonPressEvent(newPost));
                  }
                }
              },
              child: Text(
                widget.post == null ? AppStrings.addPost : AppStrings.updatePost,
              ),
            ),
          ]),
        );
      },
    );
  }
}
