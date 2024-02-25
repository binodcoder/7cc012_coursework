import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/entities/post.dart';

abstract class PostRepository {
  Future<Either<Failure, List<Post>>>? getPosts();
}
