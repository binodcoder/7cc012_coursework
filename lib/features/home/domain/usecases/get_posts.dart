import 'package:my_blog_bloc/core/model/post_model.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../repositories/post_repositories.dart';

class GetPosts implements UseCase<List<PostModel>, NoParams> {
  final PostRepository repository;

  GetPosts(this.repository);

  @override
  Future<Either<Failure, List<PostModel>>?> call(NoParams noParams) async {
    return await repository.getPosts();
  }
}
