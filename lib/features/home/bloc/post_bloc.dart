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
    await Future.delayed(const Duration(seconds: 3));
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

// class PostBloc extends Bloc<PostEvent, PostLoadedSuccessState> {
//   PostBloc() : super(PostLoadedSuccessState([]));

//   List<Post> selectedPosts = [];

//   @override
//   Stream<PostLoadedSuccessState> mapEventToState(PostEvent event) async* {
//     if (event is AddPostEvent) {
//       List<Post> updatedPosts = List.from(state.posts)..add(event.post);
//       yield state.copyWith(posts: updatedPosts);
//     } else if (event is UpdatePostEvent) {
//       List<Post> updatedPosts = state.posts.map((post) {
//         if (post.id == event.updatedPost.id) {
//           return event.updatedPost;
//         }
//         return post;
//       }).toList();
//       yield state.copyWith(posts: updatedPosts);
//     } else if (event is DeletePostEvent) {
//       List<Post> updatedPosts = state.posts.where((post) => post.id != event.postId).toList();
//       yield state.copyWith(posts: updatedPosts);
//     } else if (event is SelectPostEvent) {
//       selectedPosts.add(event.selectedPost);
//       List<Post> updatedPosts = state.posts.map((post) {
//         if (post.id == event.selectedPost.id) {
//           return event.selectedPost;
//         }
//         return post;
//       }).toList();
//       yield state.copyWith(posts: updatedPosts);
//     } else if (event is DeSelectPostEvent) {
//       selectedPosts.remove(event.selectedPost);
//       List<Post> updatedPosts = state.posts.map((post) {
//         if (post.id == event.selectedPost.id) {
//           return event.selectedPost;
//         }
//         return post;
//       }).toList();
//       yield state.copyWith(posts: updatedPosts);
//     } else if (event is DeletePostEvents) {
//       for (var element in selectedPosts) {
//         state.posts.remove(element);
//       }
//       yield state.copyWith(posts: state.posts);
//     }
//   }
// }
