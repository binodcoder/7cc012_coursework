import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/db/db_helper.dart';
import '../../../../core/entities/post.dart';
import '../../../../injection_container.dart';
import '../../../../resources/colour_manager.dart';
import '../../../../resources/strings_manager.dart';
import '../../../../core/model/post_model.dart';
import '../../../../resources/values_manager.dart';
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

  Widget _imagePickerButtons(PostAddBloc postBloc, BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(AppRadius.r4)),
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0, right: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () async {
              postBloc.add(PostAddPickFromGalaryButtonPressEvent(context));
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

    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //   children: [
    //     ElevatedButton(
    //       onPressed: () {
    //         postBloc.add(PostAddPickFromGalaryButtonPressEvent());
    //       },
    //       child: const Text('Pick from gallery'),
    //     ),
    //     ElevatedButton(
    //       onPressed: () {
    //         postBloc.add(PostAddPickFromCameraButtonPressEvent());
    //       },
    //       child: const Text('Pick from camera'),
    //     ),
    //   ],
    // );
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

  final PostAddBloc postAddBloc = sl<PostAddBloc>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<PostAddBloc, PostAddState>(
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
            title: const Text(AppStrings.addPost),
          ),
          body: Form(
            key: _formKey,
            child: ListView(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
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
                  minLines: 3,
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
              // Container(
              //   width: 100,
              //   height: 100,
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Colors.grey),
              //   ),
              //   child: state.imagePath == null
              //       ? Image.asset('assets/images/noimage.jpg')
              //       : Image.file(
              //           File(state.imagePath!),
              //         ),
              // ),
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
        );
      },
    );
  }
}
