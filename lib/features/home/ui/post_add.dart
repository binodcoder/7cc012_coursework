import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../utility.dart';
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

  // Create an instance of the ImagePicker class
  ImagePicker picker = ImagePicker();

  File? _image;
  String? imgString;

// Define a function to pick an image from the gallery
  Future<void> _pickImageFromGallery() async {
    // Call the pickImage method with the source as ImageSource.gallery
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    // Check if the user selected an image
    if (pickedImage != null) {
      // Update the state with the selected image file
      setState(() {
        _image = File(pickedImage.path);
        _getBytesFromImage();
      });
    }
  }

  // Define a function to pick an image from the camera
  Future<void> _pickImageFromCamera() async {
    // Call the pickImage method with the source as ImageSource.camera
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.camera);

    // Check if the user took a photo
    if (pickedImage != null) {
      // Update the state with the selected image file
      setState(() {
        _image = File(pickedImage.path);
        _getBytesFromImage();
      });
    }
  }

  Uint8List? bytes;

  Future<void> _getBytesFromImage() async {
    // Check if the image file is not null
    if (_image != null) {
      // Call the readAsBytes method to get the bytes as a Uint8List
      bytes = await _image!.readAsBytes();
      imgString = Utility.base64String(bytes!);
      setState(() {});
    }
  }

  Widget _imageDisplay(Uint8List image) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Image.memory(image),
    );
  }

  // Widget _imageDisplay() {
  //   return Container(
  //     width: 100,
  //     height: 100,
  //     decoration: BoxDecoration(
  //       border: Border.all(color: Colors.grey),
  //     ),
  //     child: _image != null ? Image.file(_image!) : Center(child: Text('No image selected')),
  //   );
  // }

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
      bytes = Utility.dataFromBase64String(widget.post!.imageUrl);
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
        bytes == null ? const Text('no image') : _imageDisplay(bytes!),
        ElevatedButton(
          onPressed: () async {
            var title = titleController.text;
            var content = contentController.text;
            var imageUrl = imgString;

            if (title.isNotEmpty && content.isNotEmpty) {
              if (widget.post != null) {
                // Update post to local database
                var updatedPost = Post(
                  widget.post!.id,
                  titleController.text,
                  contentController.text,
                  Utility.base64String(bytes!),
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
                  imageUrl!,
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
