import '../../../../core/db/db_helper.dart';
import '../../../../core/model/post_model.dart';

abstract class PostLocalDataSource {
  Future<List<PostModel>> getPosts();
}

class PostLocalDataSourceImpl implements PostLocalDataSource {
  PostLocalDataSourceImpl();

  @override
  Future<List<PostModel>> getPosts() => _getPostsFromLocal();

  Future<List<PostModel>> _getPostsFromLocal() async {
    List<PostModel> postModelList = await DatabaseHelper.getPosts();
    return postModelList;
  }
}
