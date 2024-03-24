 
import '../../../../core/entities/post.dart';

abstract class PostState {}

abstract class PostActionState extends PostState {}

class PostInitialState extends PostState {}

class PostLoadingState extends PostState {}

class PostLoadedSuccessState extends PostState {
  final List<Post> postList;
  PostLoadedSuccessState(this.postList);
  PostLoadedSuccessState copyWith({List<Post>? postList}) {
    return PostLoadedSuccessState(postList ?? this.postList);
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
