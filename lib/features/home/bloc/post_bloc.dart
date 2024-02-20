import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../db/db_helper.dart';
import '../model/post_model.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Post> selectedPosts = [];
  PostBloc() : super(PostInitialState()) {
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
    List<Post> postList = await dbHelper.getPosts();
    for (var post in postList) {
      if (post.isSelected == 1) {
        selectedPosts.add(post);
      }
    }
    emit(PostLoadedSuccessState(postList));
  }

  FutureOr<void> postEditButtonClickedEvent(PostEditButtonClickedEvent event, Emitter<PostState> emit) {}

  FutureOr<void> postDeleteButtonClickedEvent(PostDeleteButtonClickedEvent event, Emitter<PostState> emit) async {
    await dbHelper.deletePost(event.post.id);
    List<Post> postList = await dbHelper.getPosts();
    emit(PostLoadedSuccessState(postList));
  }

  FutureOr<void> postDeleteAllButtonClickedEvent(PostDeleteAllButtonClickedEvent event, Emitter<PostState> emit) async {
    for (var element in selectedPosts) {
      await dbHelper.deletePost(element.id);
    }
    List<Post> postList = await dbHelper.getPosts();
    emit(PostLoadedSuccessState(postList));
  }

  FutureOr<void> postAddButtonClickedEvent(PostAddButtonClickedEvent event, Emitter<PostState> emit) {
    emit(PostNavigateToAddPostActionState());
  }

  FutureOr<void> postTileNavigateEvent(PostTileNavigateEvent event, Emitter<PostState> emit) {
    emit(PostNavigateToDetailPageActionState(event.post));
  }

  FutureOr<void> postTileLongPressEvent(PostTileLongPressEvent event, Emitter<PostState> emit) async {
    var updatedPost = event.post;
    if (updatedPost.isSelected == 0) {
      updatedPost.isSelected = 1;
      selectedPosts.add(updatedPost);
    } else {
      updatedPost.isSelected = 0;
      selectedPosts.remove(updatedPost);
    }
    await dbHelper.updatePost(updatedPost);
    final List<Post> newPosts = await dbHelper.getPosts();
    emit(PostLoadedSuccessState(newPosts));
  }
}
