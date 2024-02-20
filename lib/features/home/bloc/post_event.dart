import '../model/post_model.dart';

abstract class PostEvent {}

class PostInitialEvent extends PostEvent {}

class PostEditButtonClickedEvent extends PostEvent {}

class PostDeleteButtonClickedEvent extends PostEvent {
  final Post post;
  PostDeleteButtonClickedEvent(this.post);
}

class PostDeleteAllButtonClickedEvent extends PostEvent {}

class PostAddButtonClickedEvent extends PostEvent {}

class PostTileNavigateEvent extends PostEvent {
  final Post post;
  PostTileNavigateEvent(this.post);
}

class PostTileLongPressEvent extends PostEvent {
  final Post post;
  PostTileLongPressEvent(this.post);
}

class AddPostEvent extends PostEvent {
  final Post post;

  AddPostEvent(this.post);
}

class UpdatePostEvent extends PostEvent {
  final Post updatedPost;

  UpdatePostEvent(this.updatedPost);
}

class DeletePostEvent extends PostEvent {
  final String postId;

  DeletePostEvent(this.postId);
}

class DeletePostEvents extends PostEvent {
  final List<Post> selectedPosts;

  DeletePostEvents(this.selectedPosts);
}

class SelectPostEvent extends PostEvent {
  final Post selectedPost;

  SelectPostEvent(this.selectedPost);
}

class DeSelectPostEvent extends PostEvent {
  final Post selectedPost;

  DeSelectPostEvent(this.selectedPost);
}
