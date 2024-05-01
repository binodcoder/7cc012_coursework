import '../../../../../core/entities/post.dart';

//These are the set of events.
abstract class ReadPostsEvent {}

class PostInitialEvent extends ReadPostsEvent {}

class PostEditButtonClickedEvent extends ReadPostsEvent {
  final Post post;
  PostEditButtonClickedEvent(this.post);
}

class PostDeleteButtonClickedEvent extends ReadPostsEvent {
  final Post post;
  PostDeleteButtonClickedEvent(this.post);
}

class PostDeleteAllButtonClickedEvent extends ReadPostsEvent {}

class PostSearchIconClickedEvent extends ReadPostsEvent {
  final String value;
  bool isSearch = false;
  PostSearchIconClickedEvent(this.value, this.isSearch);
}

class PostAddButtonClickedEvent extends ReadPostsEvent {}

class PostTileLongPressEvent extends ReadPostsEvent {
  final Post post;
  PostTileLongPressEvent(this.post);
}
