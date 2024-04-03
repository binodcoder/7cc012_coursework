import '../../../../core/db/db_helper.dart';
import '../../../../core/model/post_model.dart';

abstract class PostLocalDataSource {
  Future<List<PostModel>> readPosts();
  Future<int> deletePost(PostModel post);
  Future<int> createPost(PostModel postModel);
  Future<int> updatePost(PostModel postModel);
  Future<List<PostModel>> findPosts(String searchTerm);
}

class PostLocalDataSourceImpl implements PostLocalDataSource {
  PostLocalDataSourceImpl();

  Future<int> _createPostsToLocal(PostModel postModel) async {
    int response = await DatabaseHelper.insertPost(postModel);
    return response;
  }

  Future<List<PostModel>> _readPostsFromLocal() async {
    List<PostModel> postModelList = await DatabaseHelper.getPosts();
    return postModelList;
  }

  Future<int> _updatePostToLocal(PostModel postModel) async {
    final int response = await DatabaseHelper.updatePost(postModel);
    return response;
  }

  Future<int> _deletePostFromLocal(int postId) async {
    int result = await DatabaseHelper.deletePost(postId);
    return result;
  }

  Future<List<PostModel>> _findPostsFromLocal(String searchTerm) async {
    List<PostModel> postModelList = await DatabaseHelper.findPosts(searchTerm);
    return postModelList;
  }

  @override
  Future<int> createPost(PostModel postModel) => _createPostsToLocal(postModel);
  @override
  Future<List<PostModel>> readPosts() => _readPostsFromLocal();

  @override
  Future<int> updatePost(PostModel postModel) => _updatePostToLocal(postModel);
  @override
  Future<int> deletePost(PostModel post) => _deletePostFromLocal(post.id!);

  @override
  Future<List<PostModel>> findPosts(String searchTerm) => _findPostsFromLocal(searchTerm);
}
