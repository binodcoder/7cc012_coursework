import '../model/post.dart';

class PostState {
  final List<Post> posts;

  PostState(this.posts);

  PostState copyWith({List<Post>? posts}) {
    return PostState(posts ?? this.posts);
  }
}