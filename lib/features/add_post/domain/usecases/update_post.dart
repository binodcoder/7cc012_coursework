import 'package:dartz/dartz.dart';
import 'package:my_blog_bloc/core/errors/failures.dart';
import 'package:my_blog_bloc/features/add_post/domain/repositories/update_post_repository.dart';
import '../../../../core/entities/post.dart';
import '../../../../core/usecases/usecase.dart';

class UpdatePost implements UseCase<int, Post> {
  UpdatePostRepository updatePostRepository;

  UpdatePost(this.updatePostRepository);

  @override
  Future<Either<Failure, int>?> call(Post post) async {
    return await updatePostRepository.updatePost(post);
  }
}
