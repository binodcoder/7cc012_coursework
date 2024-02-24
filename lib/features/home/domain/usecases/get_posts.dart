import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../entities/post.dart';
import '../repositories/post_repositories.dart';

class GetPosts implements UseCase<Post, NoParams> {
  final PostRepository repository;

  GetPosts(this.repository);

  @override
  Future<Either<Failure, List<Post>>?> call(NoParams noParams) async {
    return await repository.getPosts();
  }
}
