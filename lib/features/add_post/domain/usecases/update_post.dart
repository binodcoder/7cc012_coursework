import 'package:dartz/dartz.dart';
import 'package:my_blog_bloc/core/errors/failures.dart';
import 'package:my_blog_bloc/core/model/post_model.dart';
import 'package:my_blog_bloc/features/add_post/domain/repositories/update_post_repository.dart';
import '../../../../core/usecases/usecase.dart';

class UpdatePost implements UseCase<int, PostModel> {
  UpdatePostRepository updatePostRepository;

  UpdatePost(this.updatePostRepository);

  @override
  Future<Either<Failure, int>?> call(PostModel postModel) async {
    return await updatePostRepository.updatePost(postModel);
  }
}
