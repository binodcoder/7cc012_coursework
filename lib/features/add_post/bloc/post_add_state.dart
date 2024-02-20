abstract class PostAddState {}

abstract class PostAddActionState extends PostAddState {}

class PostAddInitialState extends PostAddState {}

class AddPostImagePickedFromGalaryState extends PostAddActionState {
  String imagePath;
  AddPostImagePickedFromGalaryState(this.imagePath);
}

class AddPostImagePickedFromCameraState extends PostAddActionState {
  String imagePath;
  AddPostImagePickedFromCameraState(this.imagePath);
}

class AddPostSavedState extends PostAddActionState {}

class AddPostErrorState extends PostAddActionState {}
