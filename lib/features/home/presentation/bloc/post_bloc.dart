import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:my_blog_bloc/core/usecases/usecase.dart';
import 'package:my_blog_bloc/features/home/domain/usecases/get_posts.dart';
import '../../../../core/db/db_helper.dart';
import '../../data/model/post_model.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPosts getPosts;
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<PostModel> selectedPosts = [];
  PostBloc({required this.getPosts}) : super(PostInitialState()) {
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
    // List<PostModel> postList = await dbHelper.getPosts();
    final postList = await getPosts(NoParams());

    postList!.fold((failure) {
      // emit(Error(message: _mapFailureToMessage(failure)));
    }, (post) {
      emit(PostLoadedSuccessState(post));
    });

    // for (var post in postList) {
    //   if (post.isSelected == 1) {
    //     selectedPosts.add(post);
    //   }
    // }
    // emit(PostLoadedSuccessState(postList));
  }

  FutureOr<void> postEditButtonClickedEvent(PostEditButtonClickedEvent event, Emitter<PostState> emit) {}

  FutureOr<void> postDeleteButtonClickedEvent(PostDeleteButtonClickedEvent event, Emitter<PostState> emit) async {
    await dbHelper.deletePost(event.post.id);
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
    emit(PostNavigateToDetailPageActionState(event.post));
  }

  FutureOr<void> postTileLongPressEvent(PostTileLongPressEvent event, Emitter<PostState> emit) async {
    var updatedPost = event.post;
    if (updatedPost.isSelected == 0) {
      updatedPost.isSelected = 1;
    //  selectedPosts.add(updatedPost);
    } else {
      updatedPost.isSelected = 0;
      selectedPosts.remove(updatedPost);
    }
   // await dbHelper.updatePost(updatedPost);
    final List<PostModel> newPosts = await dbHelper.getPosts();
    emit(PostLoadedSuccessState(newPosts));
  }
}
