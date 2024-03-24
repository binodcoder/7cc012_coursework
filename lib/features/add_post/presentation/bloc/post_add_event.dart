import 'package:my_blog_bloc/core/model/post_model.dart';

import '../../../../core/entities/post.dart';

abstract class PostAddEvent {}

class PostAddInitialEvent extends PostAddEvent {}

class PostAddPickFromGalaryButtonPressEvent extends PostAddEvent {}

class PostAddPickFromCameraButtonPressEvent extends PostAddEvent {}

class PostAddSaveButtonPressEvent extends PostAddEvent {
  final PostModel newPost;
  PostAddSaveButtonPressEvent(this.newPost);
}

class PostAddUpdateButtonPressEvent extends PostAddEvent {
  final PostModel updatedPost;
  PostAddUpdateButtonPressEvent(this.updatedPost);
}

class PostAddReadyToUpdateEvent extends PostAddEvent {
  final Post post;
  PostAddReadyToUpdateEvent(this.post);
}
