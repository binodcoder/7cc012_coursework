import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:blog_app/layers/domain/post/usecases/find_posts.dart';
import '../../../../../core/entities/post.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../domain/post/usecases/delete_post.dart';
import '../../../../domain/post/usecases/read_posts.dart';
import '../../../../domain/post/usecases/update_post.dart';
import 'read_posts_event.dart';
import 'read_posts_state.dart';

class ReadPostsBloc extends Bloc<ReadPostsEvent, ReadPostsState> {
  final ReadPosts getPosts;
  final UpdatePost updatePost;
  final DeletePost deletePost;
  final FindPosts findPosts;
  List<Post> selectedPosts = [];
  ReadPostsState get initialState => PostInitialState();
  ReadPostsBloc({
    required this.getPosts,
    required this.updatePost,
    required this.deletePost,
    required this.findPosts,
  }) : super(PostInitialState()) {
    on<PostInitialEvent>(postInitialEvent);
    on<PostEditButtonClickedEvent>(postEditButtonClickedEvent);
    on<PostDeleteButtonClickedEvent>(postDeleteButtonClickedEvent);
    on<PostDeleteAllButtonClickedEvent>(postDeleteAllButtonClickedEvent);
    on<PostSearchIconClickedEvent>(postSearchIconClickedEvent);
    on<PostAddButtonClickedEvent>(postAddButtonClickedEvent);
    on<PostTileLongPressEvent>(postTileLongPressEvent);
  }

  FutureOr<void> postInitialEvent(PostInitialEvent event, Emitter<ReadPostsState> emit) async {
    selectedPosts = [];
    emit(PostLoadingState());
    final postModelList = await getPosts(NoParams());

    postModelList!.fold((failure) {
      // emit(Error(message: _mapFailureToMessage(failure)));
    }, (postList) {
      for (var post in postList) {
        if (post.isSelected == 1) {
          selectedPosts.add(post);
        }
      }
      emit(PostLoadedSuccessState(
        postList,
        false,
        selectedPosts,
      ));
    });
  }

  FutureOr<void> postEditButtonClickedEvent(PostEditButtonClickedEvent event, Emitter<ReadPostsState> emit) {
    emit(PostNavigateToUpdatePageActionState(event.post));
  }

  FutureOr<void> postDeleteButtonClickedEvent(PostDeleteButtonClickedEvent event, Emitter<ReadPostsState> emit) async {
    final result = await deletePost(event.post);

    result!.fold((failure) {
      // emit(Error(message: _mapFailureToMessage(failure)));
    }, (postList) {
      emit(PostItemDeletedActionState());
    });
  }

  FutureOr<void> postDeleteAllButtonClickedEvent(PostDeleteAllButtonClickedEvent event, Emitter<ReadPostsState> emit) async {
    for (var element in selectedPosts) {
      final result = await deletePost(element);

      result!.fold((failure) {
        // emit(Error(message: _mapFailureToMessage(failure)));
      }, (postList) {
        emit(PostItemsDeletedActionState());
      });
    }
  }

  FutureOr<void> postAddButtonClickedEvent(PostAddButtonClickedEvent event, Emitter<ReadPostsState> emit) {
    emit(PostNavigateToAddPostActionState());
  }

  FutureOr<void> postTileLongPressEvent(PostTileLongPressEvent event, Emitter<ReadPostsState> emit) async {
    var updatedPost = event.post;
    if (updatedPost.isSelected == 0) {
      updatedPost.isSelected = 1;
    } else {
      updatedPost.isSelected = 0;
    }

    final result = await updatePost(updatedPost);

    result!.fold((failure) {
      // emit(Error(message: _mapFailureToMessage(failure)));
    }, (post) {
      emit(PostItemsUpdatedState());
    });
  }

  FutureOr<void> postSearchIconClickedEvent(PostSearchIconClickedEvent event, Emitter<ReadPostsState> emit) async {
    if (event.isSearch) {
      emit(PostLoadingState());
      final postModelList = await findPosts(event.value);

      postModelList!.fold((failure) {
        // emit(Error(message: _mapFailureToMessage(failure)));
      }, (postList) {
        emit(PostLoadedSuccessState(postList, true, selectedPosts));
      });
    } else {
      emit(PostLoadingState());
      final postModelList = await getPosts(NoParams());

      postModelList!.fold((failure) {
        // emit(Error(message: _mapFailureToMessage(failure)));
      }, (postList) {
        for (var post in postList) {
          if (post.isSelected == 1) {
            selectedPosts.add(post);
          }
        }
        emit(PostLoadedSuccessState(postList, false, selectedPosts));
      });
    }
  }
}
