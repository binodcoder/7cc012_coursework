import 'package:flutter/material.dart';

import '../../../../core/entities/post.dart';

abstract class PostAddEvent {}

class PostAddInitialEvent extends PostAddEvent {}

class PostAddPickFromGalaryButtonPressEvent extends PostAddEvent {
  BuildContext context;

  PostAddPickFromGalaryButtonPressEvent(this.context);
}

class PostAddPickFromCameraButtonPressEvent extends PostAddEvent {}

class PostAddSaveButtonPressEvent extends PostAddEvent {
  final Post newPost;
  PostAddSaveButtonPressEvent(this.newPost);
}

class PostAddUpdateButtonPressEvent extends PostAddEvent {
  final Post updatedPost;
  PostAddUpdateButtonPressEvent(this.updatedPost);
}

class PostAddReadyToUpdateEvent extends PostAddEvent {
  final Post post;
  PostAddReadyToUpdateEvent(this.post);
}
