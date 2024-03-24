import 'package:dartz/dartz.dart';
import 'package:my_blog_bloc/core/errors/exceptions.dart';
import 'package:my_blog_bloc/core/errors/failures.dart';
import 'package:my_blog_bloc/features/add_post/data/datasources/update_posts_local_data_sources.dart';
import 'package:my_blog_bloc/features/add_post/domain/repositories/update_post_repository.dart';

import '../../../../core/entities/post.dart';
import '../../../../core/model/post_model.dart';

class UpdatePostRepositoriesImpl implements UpdatePostRepository {
  UpdatePostLocalDataSources updatePostLocalDataSources;
  UpdatePostRepositoriesImpl({required this.updatePostLocalDataSources});

  @override
  Future<Either<Failure, int>>? updatePost(Post post) async {
    PostModel postModel = PostModel(
      title: post.title,
      content: post.content,
      imagePath: post.imagePath,
      isSelected: post.isSelected,
    );
    try {
      int response = await updatePostLocalDataSources.updatePost(postModel);
      return Right(response);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
