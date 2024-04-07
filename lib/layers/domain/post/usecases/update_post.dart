import 'package:dartz/dartz.dart';
import '../../../../core/entities/post.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/post_repositories.dart';

class UpdatePost implements UseCase<int, Post> {
  PostRepository postRepository;

  UpdatePost(this.postRepository);

  @override
  Future<Either<Failure, int>?> call(Post post) async {
    return await postRepository.updatePost(post);
  }
}
