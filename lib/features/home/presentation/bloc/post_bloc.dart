import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:my_blog_bloc/core/usecases/usecase.dart';
import 'package:my_blog_bloc/features/add_post/domain/usecases/update_post.dart';
import 'package:my_blog_bloc/features/home/domain/usecases/get_posts.dart';
import '../../../../core/db/db_helper.dart';
import '../../../../core/entities/post.dart';
import '../../../../core/model/post_model.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPosts getPosts;
  final UpdatePost updatePost;
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Post> selectedPosts = [];
  PostBloc({
    required this.getPosts,
    required this.updatePost,
  }) : super(PostInitialState()) {
    on<PostInitialEvent>(postInitialEvent);
    on<PostEditButtonClickedEvent>(postEditButtonClickedEvent);
    on<PostDeleteButtonClickedEvent>(postDeleteButtonClickedEvent);
    on<PostDeleteAllButtonClickedEvent>(postDeleteAllButtonClickedEvent);
    on<PostAddButtonClickedEvent>(postAddButtonClickedEvent);
    on<PostTileNavigateEvent>(postTileNavigateEvent);
    on<PostTileLongPressEvent>(postTileLongPressEvent);
  }

  FutureOr<void> postInitialEvent(PostInitialEvent event, Emitter<PostState> emit) async {
    emit(PostLoadingState());
    final postModelList = await getPosts(NoParams());

    postModelList!.fold((failure) {
      // emit(Error(message: _mapFailureToMessage(failure)));
    }, (postModelList) {
      for (var post in postModelList) {
        if (post.isSelected == 1) {
          selectedPosts.add(post);
        }
      }
      emit(PostLoadedSuccessState(postModelList));
    });
  }

  FutureOr<void> postEditButtonClickedEvent(PostEditButtonClickedEvent event, Emitter<PostState> emit) {}

  FutureOr<void> postDeleteButtonClickedEvent(PostDeleteButtonClickedEvent event, Emitter<PostState> emit) async {
    await dbHelper.deletePost(event.postModel.id);
    List<PostModel> postList = await dbHelper.getPosts();
    emit(PostLoadedSuccessState(postList));
  }

  FutureOr<void> postDeleteAllButtonClickedEvent(PostDeleteAllButtonClickedEvent event, Emitter<PostState> emit) async {
    for (var element in selectedPosts) {
      await dbHelper.deletePost(element.id);
    }
    List<PostModel> postList = await dbHelper.getPosts();
    emit(PostLoadedSuccessState(postList));
  }

  FutureOr<void> postAddButtonClickedEvent(PostAddButtonClickedEvent event, Emitter<PostState> emit) {
    emit(PostNavigateToAddPostActionState());
  }

  FutureOr<void> postTileNavigateEvent(PostTileNavigateEvent event, Emitter<PostState> emit) {
    emit(PostNavigateToDetailPageActionState(event.postModel));
  }

  FutureOr<void> postTileLongPressEvent(PostTileLongPressEvent event, Emitter<PostState> emit) async {
    var updatedPost = event.postModel;
    if (updatedPost.isSelected == 0) {
      updatedPost.isSelected = 1;
      selectedPosts.add(updatedPost);
    } else {
      updatedPost.isSelected = 0;
      selectedPosts.remove(updatedPost);
    }
    await updatePost(updatedPost);
    final postList = await getPosts(NoParams());
    postList!.fold((failure) {
      // emit(Error(message: _mapFailureToMessage(failure)));
    }, (post) {
      emit(PostLoadedSuccessState(post));
    });
  }
}