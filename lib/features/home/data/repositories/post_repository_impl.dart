import 'package:dartz/dartz.dart';
import 'package:my_blog_bloc/core/errors/failures.dart';
import '../../../../core/entities/post.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/repositories/post_repositories.dart';
import '../data_sources/posts_local_data_sources.dart';

class PostRepositoryImpl implements PostRepository {
  final PostLocalDataSource postLocalDataSource;

  PostRepositoryImpl({
    required this.postLocalDataSource,
  });

  @override
  Future<Either<Failure, List<Post>>> getPosts() async {
    try {
      List<Post> postList = await postLocalDataSource.getPosts();
      return Right(postList);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
