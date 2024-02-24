import '../../../../core/db/db_helper.dart';
import '../model/post_model.dart';

abstract class PostLocalDataSource {
  Future<List<PostModel>> getPosts();
}

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final DatabaseHelper dbHelper = DatabaseHelper();
  PostLocalDataSourceImpl();

  @override
  Future<List<PostModel>> getPosts() => _getPostsFromLocal();

  Future<List<PostModel>> _getPostsFromLocal() async {
    List<PostModel> postModelList = await dbHelper.getPosts();
    return postModelList;
  }
}
