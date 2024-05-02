import 'package:equatable/equatable.dart';
import '../../../../../core/entities/post.dart';

//These are the set of states.
abstract class ReadPostsState extends Equatable {
  const ReadPostsState();

  @override
  List<Object> get props => [];
}

abstract class PostActionState extends ReadPostsState {}

class PostInitialState extends ReadPostsState {}

class PostLoadingState extends ReadPostsState {}

class PostLoadedSuccessState extends ReadPostsState {
  final bool isSearch;
  final List<Post> postList;
  final List<Post> selectedPosts;
  const PostLoadedSuccessState(this.postList, this.isSearch, this.selectedPosts);
  PostLoadedSuccessState copyWith({List<Post>? postList}) {
    return PostLoadedSuccessState(postList ?? this.postList, isSearch, selectedPosts);
  }
}

class PostErrorState extends PostActionState {
  final String message;
  PostErrorState({required this.message});
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
  final bool isSearch;
  PostSearchIconClickedState(this.isSearch);
}

class PostItemsUpdatedState extends PostActionState {}
