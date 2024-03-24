import 'package:dartz/dartz.dart';
 import '../../../../core/entities/post.dart';
import '../../../../core/errors/failures.dart';

abstract class UpdatePostRepository {
  Future<Either<Failure, int>>? updatePost(Post post);
}
