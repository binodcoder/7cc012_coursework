import 'package:dartz/dartz.dart';
import '../../../../core/entities/post.dart';
import '../../../../core/errors/failures.dart';

abstract class PostRepository {
  Future<Either<Failure, List<Post>>>? getPosts();
}
