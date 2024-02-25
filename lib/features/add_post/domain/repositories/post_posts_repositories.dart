import 'package:dartz/dartz.dart';
import 'package:my_blog_bloc/core/model/post_model.dart';
import '../../../../core/errors/failures.dart';

abstract class PostPostsRepository {
  Future<Either<Failure, int>>? postPosts(PostModel postModel);
}
