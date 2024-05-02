abstract class CreatePostState {
  final String? imagePath;
  CreatePostState({this.imagePath});
}

abstract class PostAddActionState extends CreatePostState {}

class PostAddInitialState extends CreatePostState {}

class PostAddReadyToUpdateState extends CreatePostState {
  PostAddReadyToUpdateState(imagePath) : super(imagePath: imagePath);
}

class AddPostImagePickedFromGalaryState extends CreatePostState {
  AddPostImagePickedFromGalaryState(imagePath) : super(imagePath: imagePath);
}

class AddPostImagePickedFromCameraState extends CreatePostState {
  AddPostImagePickedFromCameraState(imagePath) : super(imagePath: imagePath);
}

class AddPostSavedState extends PostAddActionState {}

class AddPostLoadingState extends PostAddActionState {}

class AddPostUpdatedState extends PostAddActionState {}

class AddPostErrorState extends PostAddActionState {
  final String message;

  AddPostErrorState({required this.message});
}
