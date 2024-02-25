import 'package:my_blog_bloc/core/model/post_model.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../repositories/post_posts_repositories.dart';

class PostPosts implements UseCase<int, PostModel> {
  final PostPostsRepository postRepository;

  PostPosts(this.postRepository);

  @override
  Future<Either<Failure, int>?> call(PostModel postModel) async {
    return await postRepository.postPosts(postModel);
  }
}
