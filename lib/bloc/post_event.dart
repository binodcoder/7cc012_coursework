
import '../model/post.dart';

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

