import '../../../../../core/entities/post.dart';

abstract class CreatePostEvent {}

class PostAddInitialEvent extends CreatePostEvent {}

class PostAddPickFromGalaryButtonPressEvent extends CreatePostEvent {}

class PostAddPickFromCameraButtonPressEvent extends CreatePostEvent {}

class PostAddSaveButtonPressEvent extends CreatePostEvent {
  final Post newPost;
  PostAddSaveButtonPressEvent(this.newPost);
}

class PostAddUpdateButtonPressEvent extends CreatePostEvent {
  final Post updatedPost;
  PostAddUpdateButtonPressEvent(this.updatedPost);
}

class PostAddReadyToUpdateEvent extends CreatePostEvent {
  final Post post;
  PostAddReadyToUpdateEvent(this.post);
}
