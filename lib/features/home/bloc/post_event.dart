import '../model/post_model.dart';

abstract class PostEvent {}

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
