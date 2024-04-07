import 'package:dartz/dartz.dart';
import '../../../../../../core/entities/post.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/post_repositories.dart';

class DeletePost implements UseCase<int, Post> {
  PostRepository postRepository;

  DeletePost(this.postRepository);

  @override
  Future<Either<Failure, int>?> call(Post post) async {
    return await postRepository.deletePost(post);
  }
}
