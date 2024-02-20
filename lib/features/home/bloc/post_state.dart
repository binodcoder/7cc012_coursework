import '../model/post_model.dart';

abstract class PostState {}

abstract class PostActionState extends PostState {}

class PostInitialState extends PostState {}

class PostLoadingState extends PostState {}

class PostLoadedSuccessState extends PostState {
  final List<Post> posts;
  PostLoadedSuccessState(this.posts);
  PostLoadedSuccessState copyWith({List<Post>? posts}) {
    return PostLoadedSuccessState(posts ?? this.posts);
  }
}

class PostErrorState extends PostState {}

class PostNavigateToAddPostActionState extends PostActionState {}

class PostNavigateToDetailPageActionState extends PostActionState {
  final Post post;

  PostNavigateToDetailPageActionState(this.post);
}

class PostNavigateToUpdatePageActionState extends PostActionState {}

class PostItemDeletedActionState extends PostActionState {}

class PostItemSelectedActionState extends PostActionState {}

class PostItemsDeletedActionState extends PostActionState {}
