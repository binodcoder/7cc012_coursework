import 'package:dartz/dartz.dart';
import 'package:my_blog_bloc/core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/entities/post.dart';
import '../../domain/repositories/post_repositories.dart';
import '../data_sources/posts_local_data_sources.dart';
import '../../../../core/model/post_model.dart';

typedef Future<List<PostModel>> _ConcreteOrRandomChooser();

class PostRepositoryImpl implements PostRepository {
  final PostLocalDataSource postLocalDataSource;

  PostRepositoryImpl({
    required this.postLocalDataSource,
  });

  @override
  Future<Either<Failure, List<Post>>> getPosts() async {
    return await _getPosts(() {
      return postLocalDataSource.getPosts();
    });
  }

  Future<Either<Failure, List<Post>>> _getPosts(_ConcreteOrRandomChooser getConcreteOrRandom) async {
    try {
      final remoteTrivia = await getConcreteOrRandom();
      postLocalDataSource.getPosts();
      return Right(remoteTrivia);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
