import 'package:dartz/dartz.dart';
import '../../../../../../core/entities/post.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/post_repositories.dart';

class DeletePost implements UseCase<int, Post> {
  PostRepository deletePostRepository;

  DeletePost(this.deletePostRepository);

  @override
  Future<Either<Failure, int>?> call(Post post) async {
    return await deletePostRepository.deletePost(post);
  }
}
