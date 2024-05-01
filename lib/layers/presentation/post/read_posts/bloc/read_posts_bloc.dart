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

  /*
  This method initializes a list of selected posts, signals application loading, fetches posts from a data source, and updates
  state based on success or failure. If successful, it filters posts and emits a state, handling errors.
   */

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

/*
This method handles events triggered by a deleted button click in an application, initiating the deletion process by sending
a delete request to the server, processing it using the `fold` function, and emitting an error state if successful.
 */
  FutureOr<void> postDeleteButtonClickedEvent(PostDeleteButtonClickedEvent event, Emitter<ReadPostsState> emit) async {
    final result = await deletePost(event.post);

    result!.fold((failure) {
      // emit(Error(message: _mapFailureToMessage(failure)));
    }, (postList) {
      emit(PostItemDeletedActionState());
    });
  }

  /*
  This method manages events triggered by clicking the delete all button on selected posts in the application. It iterates over each
  post, initiates the deletion process asynchronously, and processes the results using the `fold` function. If successful, it emits a deleted state.
   */
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

  /*
  This method manages long-press events on post tiles in the application, changing the selection state of the post from unselected to selected.
  It sends an update request to the server, emitting a state indicating the update, and emitting an error state if necessary.
   */
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

  /*
  This method handles events triggered by clicking a search icon in a post-related feature of the application.
  If `event.isSearch` is true, it asynchronously fetches posts matching the search query, updates the application state,
  and sets a flag indicating a search operation.
  */

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
