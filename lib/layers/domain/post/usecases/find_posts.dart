import '../../../../../../core/entities/post.dart';
import '../../../../../../core/errors/failures.dart';
import '../../../../../../core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import '../repositories/post_repositories.dart';

class FindPosts implements UseCase<List<Post>, String> {
  final PostRepository postRepository;

  FindPosts(this.postRepository);

  @override
  Future<Either<Failure, List<Post>>?> call(String searchTerm) async {
    return await postRepository.findPosts(searchTerm);
  }
}
