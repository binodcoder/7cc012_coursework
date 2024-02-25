import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

abstract class PostPostsRepository {
  Future<Either<Failure, int>>? postPosts();
}
