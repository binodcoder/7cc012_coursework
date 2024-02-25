import 'package:my_blog_bloc/core/db/db_helper.dart';

abstract class PostPostsLocalDataSources {
  Future<int> postPosts();
}

class PostPostsLocalDataSourcesImpl extends PostPostsLocalDataSources {
  DatabaseHelper databaseHelper = DatabaseHelper();

  PostPostsLocalDataSourcesImpl();
  @override
  Future<int> postPosts() => _postPostsToLocal();

  Future<int> _postPostsToLocal() async {
    //  int response = await databaseHelper.addPosts();
    return 1;
  }
}
