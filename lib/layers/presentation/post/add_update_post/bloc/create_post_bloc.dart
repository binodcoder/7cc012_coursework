import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../domain/post/usecases/create_post.dart';
import '../../../../domain/post/usecases/read_posts.dart';
import '../../../../domain/post/usecases/update_post.dart';
import 'create_post_bloc_event.dart';
import 'create_post_bloc_state.dart';
import 'package:image_cropper/image_cropper.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final CreatePost postPosts;
  final UpdatePost updatePost;
  final ReadPosts getPosts;
  CreatePostBloc({required this.postPosts, required this.updatePost, required this.getPosts}) : super(PostAddInitialState()) {
    on<PostAddInitialEvent>(postAddInitialEvent);
    on<PostAddReadyToUpdateEvent>(postAddReadyToUpdateEvent);
    on<PostAddPickFromGalaryButtonPressEvent>(addPostPickFromGalaryButtonPressEvent);
    on<PostAddPickFromCameraButtonPressEvent>(addPostPickFromCameraButtonPressEvent);
    on<PostAddSaveButtonPressEvent>(addPostSaveButtonPressEvent);
    on<PostAddUpdateButtonPressEvent>(postAddUpdateButtonPressEvent);
  }

  FutureOr<void> addPostPickFromGalaryButtonPressEvent(PostAddPickFromGalaryButtonPressEvent event, Emitter<CreatePostState> emit) async {
    ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);

    if (photo != null) {
      CroppedFile croppedFile = await cropImage(photo);
      File image = File(croppedFile.path);
      Uint8List? uint8list = await getBytesFromImage(image);
      String imagePath = await saveImage(uint8list);
      emit(AddPostImagePickedFromGalaryState(imagePath));
    }
  }

  Future<CroppedFile> cropImage(XFile photo) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: photo.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.lightBlue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    return croppedFile!;
  }

  Future<Uint8List?> getBytesFromImage(File? image) async {
    Uint8List? bytes;
    if (image != null) {
      bytes = await image.readAsBytes();
    }
    return bytes;
  }

  Future<String> saveImage(Uint8List? imageData) async {
    final directory = await getApplicationDocumentsDirectory();
    String imagePath = '${directory.path}/image_${DateTime.now().millisecondsSinceEpoch}.png';
    final File imageFile = File(imagePath);
    await imageFile.writeAsBytes(imageData!);
    return imagePath;
  }

  FutureOr<void> addPostPickFromCameraButtonPressEvent(PostAddPickFromCameraButtonPressEvent event, Emitter<CreatePostState> emit) async {
    ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      CroppedFile croppedFile = await cropImage(photo);
      File image = File(croppedFile.path);
      Uint8List? uint8list = await getBytesFromImage(image);
      String imagePath = await saveImage(uint8list);
      emit(AddPostImagePickedFromCameraState(imagePath));
    }
  }

  FutureOr<void> addPostSaveButtonPressEvent(PostAddSaveButtonPressEvent event, Emitter<CreatePostState> emit) async {
    await postPosts(event.newPost);
    emit(AddPostSavedState());
  }

  FutureOr<void> postAddInitialEvent(PostAddInitialEvent event, Emitter<CreatePostState> emit) {
    emit(PostAddInitialState());
  }

  FutureOr<void> postAddUpdateButtonPressEvent(PostAddUpdateButtonPressEvent event, Emitter<CreatePostState> emit) async {
    await updatePost(event.updatedPost);
    emit(AddPostUpdatedState());
  }

  FutureOr<void> postAddReadyToUpdateEvent(PostAddReadyToUpdateEvent event, Emitter<CreatePostState> emit) {
    emit(PostAddReadyToUpdateState(event.post.imagePath));
  }
}
