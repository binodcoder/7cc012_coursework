import 'package:blog_app/layers/presentation/widgets.dart/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/db/db_helper.dart';
import '../../../../../core/entities/post.dart';
import '../../../../../core/model/post_model.dart';
import '../../../../../injection_container.dart';
import '../../../../../resources/colour_manager.dart';
import '../../../../../resources/strings_manager.dart';
import '../../../../../resources/values_manager.dart';
import '../../../widgets.dart/custom_input_field.dart';
import '../../../widgets.dart/image_frame.dart';
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
                CustomTextFormField(
                  maxLines: 2,
                  minLines: 1,
                  controller: titleController,
                  hintText: AppStrings.title,
                  validator: (value) {
                    if (value == null || value == '') {
                      return '*Required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.02),
                CustomTextFormField(
                  maxLines: 5,
                  minLines: 1,
                  controller: contentController,
                  hintText: AppStrings.content,
                  validator: (value) {
                    if (value == null || value == '') {
                      return '*Required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.02),
                _imagePickerButtons(postAddBloc, context, size),
                SizedBox(height: size.height * 0.02),
                ImageFrame(
                  imagePath: state.imagePath,
                  size: size,
                ),
                SizedBox(height: size.height * 0.02),
                CustomButton(
                  onTap: () {
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
                  text: widget.post == null ? AppStrings.addPost : AppStrings.updatePost,
                  size: size,
                ),
              ]),
            ),
          ),
        );
      },
    );
  }

  Widget _imagePickerButtons(CreatePostBloc postBloc, BuildContext context, Size size) {
    return Container(
      decoration: BoxDecoration(color: ColorManager.redWhite, borderRadius: BorderRadius.circular(AppRadius.r4)),
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: EdgeInsets.all(size.height * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () async {
              postBloc.add(PostAddPickFromGalaryButtonPressEvent());
            },
            child: Row(
              children: [
                const Icon(
                  Icons.file_copy_outlined,
                  color: Colors.blue,
                ),
                const SizedBox(
                  width: 6.0,
                ),
                Text(
                  AppStrings.pickGalary,
                  style: TextStyle(color: Colors.red[900], fontWeight: FontWeight.bold),
                )
              ],
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
                  AppStrings.camera,
                  style: TextStyle(color: Colors.red[900], fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
