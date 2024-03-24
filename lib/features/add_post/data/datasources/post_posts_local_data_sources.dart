import 'package:my_blog_bloc/core/db/db_helper.dart';
import 'package:my_blog_bloc/core/model/post_model.dart';

abstract class PostPostsLocalDataSources {
  Future<int> postPosts(PostModel postModel);
}

class PostPostsLocalDataSourcesImpl extends PostPostsLocalDataSources {
  PostPostsLocalDataSourcesImpl();
  @override
  Future<int> postPosts(PostModel postModel) => _postPostsToLocal(postModel);

  Future<int> _postPostsToLocal(PostModel postModel) async {
    int response = await DatabaseHelper.insertPost(postModel);
    return response;
  }
}
