import 'package:dartz/dartz.dart';
import 'package:my_blog_bloc/core/errors/failures.dart';
import 'package:my_blog_bloc/core/model/post_model.dart';
import 'package:my_blog_bloc/features/add_post/domain/repositories/post_posts_repositories.dart';
import '../../../../core/entities/post.dart';
import '../../../../core/errors/exceptions.dart';
import '../datasources/post_posts_local_data_sources.dart';

class PostPostsRepositoriesImpl implements PostPostsRepository {
  final PostPostsLocalDataSources postPostsLocalDataSources;
  PostPostsRepositoriesImpl({required this.postPostsLocalDataSources});

  @override
  Future<Either<Failure, int>>? postPosts(Post post) async {
    PostModel postModel = PostModel(
      title: post.title,
      content: post.content,
      imagePath: post.imagePath,
      isSelected: post.isSelected,
    );
    try {
      int response = await postPostsLocalDataSources.postPosts(postModel);
      return Right(response);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
