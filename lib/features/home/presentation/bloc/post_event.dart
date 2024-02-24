import '../../data/model/post_model.dart';

abstract class PostEvent {}

class PostInitialEvent extends PostEvent {}

class PostEditButtonClickedEvent extends PostEvent {}

class PostDeleteButtonClickedEvent extends PostEvent {
  final PostModel post;
  PostDeleteButtonClickedEvent(this.post);
}

class PostDeleteAllButtonClickedEvent extends PostEvent {}

class PostAddButtonClickedEvent extends PostEvent {}

class PostTileNavigateEvent extends PostEvent {
  final PostModel post;
  PostTileNavigateEvent(this.post);
}

class PostTileLongPressEvent extends PostEvent {
  final PostModel post;
  PostTileLongPressEvent(this.post);
}
