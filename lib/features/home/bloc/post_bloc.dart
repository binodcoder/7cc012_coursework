import 'package:bloc/bloc.dart';
import '../model/post_model.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostState([]));

  List<Post> selectedPosts = [];

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if (event is AddPostEvent) {
      List<Post> updatedPosts = List.from(state.posts)..add(event.post);
      yield state.copyWith(posts: updatedPosts);
    } else if (event is UpdatePostEvent) {
      List<Post> updatedPosts = state.posts.map((post) {
        if (post.id == event.updatedPost.id) {
          return event.updatedPost;
        }
        return post;
      }).toList();
      yield state.copyWith(posts: updatedPosts);
    } else if (event is DeletePostEvent) {
      List<Post> updatedPosts = state.posts.where((post) => post.id != event.postId).toList();
      yield state.copyWith(posts: updatedPosts);
    } else if (event is SelectPostEvent) {
      selectedPosts.add(event.selectedPost);
      List<Post> updatedPosts = state.posts.map((post) {
        if (post.id == event.selectedPost.id) {
          return event.selectedPost;
        }
        return post;
      }).toList();
      yield state.copyWith(posts: updatedPosts);

      // yield state.copyWith(posts: selectedPosts);
    } else if (event is DeSelectPostEvent) {
      selectedPosts.remove(event.selectedPost);
      List<Post> updatedPosts = state.posts.map((post) {
        if (post.id == event.selectedPost.id) {
          return event.selectedPost;
        }
        return post;
      }).toList();
      yield state.copyWith(posts: updatedPosts);
      // yield state.copyWith(posts: selectedPosts);
    } else if (event is DeletePostEvents) {
      //  List<Post>? updatedPosts;
      for (var element in selectedPosts) {
        state.posts.remove(element);
      }
      yield state.copyWith(posts: state.posts);
    }
  }
}
