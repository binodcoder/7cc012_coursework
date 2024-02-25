import 'package:my_blog_bloc/core/model/post_model.dart';

abstract class PostState {}

abstract class PostActionState extends PostState {}

class PostInitialState extends PostState {}

class PostLoadingState extends PostState {}

class PostLoadedSuccessState extends PostState {
  final List<PostModel> postModelList;
  PostLoadedSuccessState(this.postModelList);
  PostLoadedSuccessState copyWith({List<PostModel>? postModelList}) {
    return PostLoadedSuccessState(postModelList ?? this.postModelList);
  }
}

class PostErrorState extends PostState {}

class PostNavigateToAddPostActionState extends PostActionState {}

class PostNavigateToDetailPageActionState extends PostActionState {
  final PostModel postModel;

  PostNavigateToDetailPageActionState(this.postModel);
}

class PostNavigateToUpdatePageActionState extends PostActionState {}

class PostItemDeletedActionState extends PostActionState {}

class PostItemSelectedActionState extends PostActionState {}

class PostItemsDeletedActionState extends PostActionState {}
