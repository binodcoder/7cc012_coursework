import 'package:my_blog_bloc/core/db/db_helper.dart';
import 'package:my_blog_bloc/core/model/post_model.dart';

abstract class UpdatePostLocalDataSources {
  Future<int> updatePost(PostModel postModel);
}

class UpdatePostLocalDataSourcesImpl implements UpdatePostLocalDataSources {
  UpdatePostLocalDataSourcesImpl();
  @override
  Future<int> updatePost(PostModel postModel) => _updatePostToLocal(postModel);

  Future<int> _updatePostToLocal(PostModel postModel) async {
    final int response = await DatabaseHelper.updatePost(postModel);
    return response;
  }
}
