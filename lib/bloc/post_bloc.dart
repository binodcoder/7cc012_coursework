import 'package:bloc/bloc.dart';
import 'package:my_blog_bloc/bloc/post_event.dart';
import 'package:my_blog_bloc/bloc/post_state.dart';
import '../model/post_model.dart';

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
    } else if (event is DeletePostEvents) {
      List<Post>? updatedPosts;
      for (var element in selectedPosts) {
        updatedPosts = state.posts.where((post) => post.id != element.id).toList();
      }
      yield state.copyWith(posts: updatedPosts);
    }
  }
}
