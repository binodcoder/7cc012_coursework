import '../../../../core/entities/post.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../repositories/post_repositories.dart';

class CreatePost implements UseCase<int, Post> {
  final PostRepository postRepository;

  CreatePost(this.postRepository);

  @override
  Future<Either<Failure, int>?> call(Post post) async {
    return await postRepository.createPost(post);
  }
}
