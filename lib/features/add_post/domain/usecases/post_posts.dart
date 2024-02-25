import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../repositories/post_posts_repositories.dart';

class PostPosts implements UseCase<int, NoParams> {
  final PostPostsRepository postRepository;

  PostPosts(this.postRepository);

  @override
  Future<Either<Failure, int>?> call(NoParams noParams) async {
    return await postRepository.postPosts();
  }
}
