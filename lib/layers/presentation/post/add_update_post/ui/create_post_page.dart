import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/db/db_helper.dart';
import '../../../../../core/entities/post.dart';
import '../../../../../core/model/post_model.dart';
import '../../../../../injection_container.dart';
import '../../../../../resources/colour_manager.dart';
import '../../../../../resources/strings_manager.dart';
import '../../../../../resources/values_manager.dart';
import '../../read_posts/bloc/read_posts_bloc.dart';
import '../bloc/create_post_bloc.dart';
import '../bloc/create_post_bloc_event.dart';
import '../bloc/create_post_bloc_state.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({
    super.key,
    this.post,
  });

  final Post? post;

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();

  Widget _imagePickerButtons(CreatePostBloc postBloc, BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(AppRadius.r4)),
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0, right: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () async {
              postBloc.add(PostAddPickFromGalaryButtonPressEvent());
            },
            child: Text(
              'Pick Galary',
              style: TextStyle(color: Colors.red[900], fontWeight: FontWeight.bold),
            ),
          ),
          const Text(
            '|',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          InkWell(
            onTap: () async {
              postBloc.add(PostAddPickFromCameraButtonPressEvent());
            },
            child: Row(
              children: [
                const Icon(
                  Icons.camera_enhance_outlined,
                  color: Colors.blue,
                ),
                const SizedBox(
                  width: 6.0,
                ),
                Text(
                  'Camera',
                  style: TextStyle(color: Colors.red[900], fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ],
      ),
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

  final CreatePostBloc postAddBloc = sl<CreatePostBloc>();
  ReadPostsBloc postBloc = sl<ReadPostsBloc>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<CreatePostBloc, CreatePostState>(
      bloc: postAddBloc,
      listenWhen: (previous, current) => current is PostAddActionState,
      buildWhen: (previous, current) => current is! PostAddActionState,
      listener: (context, state) {
        if (state is AddPostSavedState) {
          titleController.clear();
          contentController.clear();
          Navigator.pop(context);
        } else if (state is AddPostUpdatedState) {
          titleController.clear();
          contentController.clear();
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.post == null ? AppStrings.addPost : AppStrings.updatePost,
            ),
          ),
          body: Form(
            key: _formKey,
            child: Container(
              margin: const EdgeInsets.all(10),
              child: ListView(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLines: 2,
                    minLines: 1,
                    validator: (value) {
                      if (value == null || value == '') {
                        return '*Required';
                      }
                      return null;
                    },
                    controller: titleController,
                    decoration: const InputDecoration(labelText: AppStrings.title),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLines: 5,
                    minLines: 1,
                    validator: (value) {
                      if (value == null || value == '') {
                        return '*Required';
                      }
                      return null;
                    },
                    controller: contentController,
                    decoration: const InputDecoration(labelText: AppStrings.content),
                  ),
                ),
                _imagePickerButtons(postAddBloc, context),
                const SizedBox(height: 20),
                Container(
                  width: size.width,
                  height: size.height * 0.3,
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorManager.white),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox(
                      width: size.width,
                      height: size.height * 0.3,
                      child: state.imagePath == null
                          ? Image.asset(
                              'assets/images/noimage.jpg',
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(state.imagePath!),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      var title = titleController.text;
                      var content = contentController.text;
                      var imagePath = state.imagePath;
                      if (title.isNotEmpty && content.isNotEmpty) {
                        if (widget.post != null) {
                          var updatedPost = PostModel(
                            id: widget.post!.id,
                            title: titleController.text,
                            content: contentController.text,
                            imagePath: imagePath,
                            isSelected: 0,
                          );
                          postAddBloc.add(PostAddUpdateButtonPressEvent(updatedPost));
                        } else {
                          var newPost = PostModel(
                            title: title,
                            content: content,
                            imagePath: imagePath,
                            isSelected: 0,
                          );
                          postAddBloc.add(PostAddSaveButtonPressEvent(newPost));
                        }
                      }
                    }
                  },
                  child: Text(
                    widget.post == null ? AppStrings.addPost : AppStrings.updatePost,
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}
