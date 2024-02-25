import 'package:dartz/dartz.dart';
import 'package:my_blog_bloc/core/errors/failures.dart';
import 'package:my_blog_bloc/features/add_post/domain/repositories/post_posts_repositories.dart';
import '../../../../core/errors/exceptions.dart';
import '../datasources/post_posts_local_data_sources.dart';

typedef Future<int> _ConcreteOrRandomChooser();

class PostPostsRepositoriesImpl implements PostPostsRepository {
  final PostPostsLocalDataSources postPostsLocalDataSources;

  PostPostsRepositoriesImpl({required this.postPostsLocalDataSources});

  @override
  Future<Either<Failure, int>>? postPosts() async {
    return await _postPosts(() => postPostsLocalDataSources.postPosts());
  }

  Future<Either<Failure, int>> _postPosts(_ConcreteOrRandomChooser getConcreteOrRandom) async {
    try {
      final remoteTrivia = await getConcreteOrRandom();
      postPostsLocalDataSources.postPosts();
      return Right(remoteTrivia);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
