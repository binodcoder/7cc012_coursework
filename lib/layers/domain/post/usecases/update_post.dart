import 'package:dartz/dartz.dart';
import '../../../../core/entities/post.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/post_repositories.dart';

class UpdatePost implements UseCase<int, Post> {
  PostRepository updatePostRepository;

  UpdatePost(this.updatePostRepository);

  @override
  Future<Either<Failure, int>?> call(Post post) async {
    return await updatePostRepository.updatePost(post);
  }
}
