import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../bloc/post_bloc.dart';
import '../bloc/post_event.dart';
import '../../../db/db_helper.dart';
import '../../../resources/strings_manager.dart';
import '../model/post_model.dart';

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
  ImagePicker picker = ImagePicker();
  XFile? pickedFile;
  String? imagePath;

  Future<void> _pickImageFromGallery() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      pickedFile = photo;
      _getBytesFromImage(File(pickedFile!.path));
    }
  }

  void _pickImageFromCamera() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      pickedFile = photo;
      _getBytesFromImage(File(pickedFile!.path));
    }
  }

  Future<void> _getBytesFromImage(File? image) async {
    if (image != null) {
      Uint8List bytes = await image.readAsBytes();
      saveImage(bytes);
    }
  }

  Future<void> saveImage(Uint8List imageData) async {
    final directory = await getApplicationDocumentsDirectory();
    imagePath = '${directory.path}/image_${DateTime.now().millisecondsSinceEpoch}.png';
    final File imageFile = File(imagePath!);
    await imageFile.writeAsBytes(imageData);
  }

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

  Widget _imagePickerButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: _pickImageFromGallery,
          child: const Text('Pick from gallery'),
        ),
        ElevatedButton(
          onPressed: _pickImageFromCamera,
          child: const Text('Pick from camera'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.post != null) {
      titleController.text = widget.post!.title;
      contentController.text = widget.post!.content;
      imagePath = widget.post!.imagePath;
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
        _imagePickerButtons(),
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
                postBloc.add(UpdatePostEvent(updatedPost));
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
                postBloc.add(AddPostEvent(newPost));
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
  }
}
