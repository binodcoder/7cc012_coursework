import 'package:my_blog_bloc/core/model/post_model.dart';

abstract class PostEvent {}

class PostInitialEvent extends PostEvent {}

class PostEditButtonClickedEvent extends PostEvent {}

class PostDeleteButtonClickedEvent extends PostEvent {
  final PostModel postModel;
  PostDeleteButtonClickedEvent(this.postModel);
}

class PostDeleteAllButtonClickedEvent extends PostEvent {}

class PostAddButtonClickedEvent extends PostEvent {}

class PostTileNavigateEvent extends PostEvent {
  final PostModel postModel;
  PostTileNavigateEvent(this.postModel);
}

class PostTileLongPressEvent extends PostEvent {
  final PostModel postModel;
  PostTileLongPressEvent(this.postModel);
}
