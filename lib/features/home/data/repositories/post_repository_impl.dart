import 'package:dartz/dartz.dart';
import 'package:my_blog_bloc/core/errors/failures.dart';
import 'package:my_blog_bloc/core/model/post_model.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/repositories/post_repositories.dart';
import '../data_sources/posts_local_data_sources.dart';

class PostRepositoryImpl implements PostRepository {
  final PostLocalDataSource postLocalDataSource;

  PostRepositoryImpl({
    required this.postLocalDataSource,
  });

  @override
  Future<Either<Failure, List<PostModel>>> getPosts() async {
    try {
      List<PostModel> postModelList = await postLocalDataSource.getPosts();
      return Right(postModelList);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
