import '../../../../core/entities/post.dart';

abstract class PostEvent {}

class PostInitialEvent extends PostEvent {}

class PostEditButtonClickedEvent extends PostEvent {}

class PostDeleteButtonClickedEvent extends PostEvent {
  final Post post;
  PostDeleteButtonClickedEvent(this.post);
}

class PostDeleteAllButtonClickedEvent extends PostEvent {}

class PostSearchIconClickedEvent extends PostEvent {
  final String value;
  bool isSearch = false;
  PostSearchIconClickedEvent(this.value, this.isSearch);
}

class PostAddButtonClickedEvent extends PostEvent {}

class PostTileNavigateEvent extends PostEvent {
  final Post post;
  PostTileNavigateEvent(this.post);
}

class PostTileLongPressEvent extends PostEvent {
  final Post post;
  PostTileLongPressEvent(this.post);
}
