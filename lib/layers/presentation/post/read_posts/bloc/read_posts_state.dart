import '../../../../../core/entities/post.dart';

abstract class ReadPostsState {}

abstract class PostActionState extends ReadPostsState {}

class PostInitialState extends ReadPostsState {}

class PostLoadingState extends ReadPostsState {}

class PostLoadedSuccessState extends ReadPostsState {
  bool isSearch;
  final List<Post> postList;
  List<Post> selectedPosts;
  PostLoadedSuccessState(this.postList, this.isSearch, this.selectedPosts);
  PostLoadedSuccessState copyWith({List<Post>? postList}) {
    return PostLoadedSuccessState(postList ?? this.postList, isSearch, selectedPosts);
  }
}

class PostErrorState extends ReadPostsState {
  String message;
  PostErrorState(this.message);
}

class PostNavigateToAddPostActionState extends PostActionState {}

class PostNavigateToDetailPageActionState extends PostActionState {
  final Post post;

  PostNavigateToDetailPageActionState(this.post);
}

class PostNavigateToUpdatePageActionState extends PostActionState {
  final Post post;

  PostNavigateToUpdatePageActionState(this.post);
}

class PostItemDeletedActionState extends PostActionState {}

class PostItemSelectedActionState extends PostActionState {}

class PostItemsDeletedActionState extends PostActionState {}

class PostSearchIconClickedState extends PostActionState {
  bool isSearch;
  PostSearchIconClickedState(this.isSearch);
}

class PostItemsUpdatedState extends PostActionState {}
