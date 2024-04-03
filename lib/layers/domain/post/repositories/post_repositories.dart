import 'package:dartz/dartz.dart';
import '../../../../../core/entities/post.dart';
import '../../../../../core/errors/failures.dart';

abstract class PostRepository {
  Future<Either<Failure, List<Post>>>? readPosts();
  Future<Either<Failure, int>>? deletePost(Post post);
  Future<Either<Failure, int>>? createPost(Post post);
  Future<Either<Failure, int>>? updatePost(Post post);
  Future<Either<Failure, List<Post>>>? findPosts(String searchTerm);
}
