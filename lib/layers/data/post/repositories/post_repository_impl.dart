import 'package:blog_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/entities/post.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/model/post_model.dart';
import '../../../domain/post/repositories/post_repositories.dart';
import '../data_sources/posts_local_data_sources.dart';

class PostRepositoryImpl implements PostRepository {
  final PostLocalDataSource postLocalDataSource;

  PostRepositoryImpl({
    required this.postLocalDataSource,
  });

  @override
  Future<Either<Failure, int>>? createPost(Post post) async {
    PostModel postModel = PostModel(
      title: post.title,
      content: post.content,
      imagePath: post.imagePath,
      isSelected: post.isSelected,
    );
    try {
      int response = await postLocalDataSource.createPost(postModel);
      return Right(response);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Post>>> readPosts() async {
    try {
      List<Post> postList = await postLocalDataSource.readPosts();
      return Right(postList);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? updatePost(Post post) async {
    PostModel postModel = PostModel(
      id: post.id,
      title: post.title,
      content: post.content,
      imagePath: post.imagePath,
      isSelected: post.isSelected,
    );
    try {
      int response = await postLocalDataSource.updatePost(postModel);
      return Right(response);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? deletePost(Post post) async {
    PostModel postModel = PostModel(
      id: post.id,
      title: post.title,
      content: post.content,
      imagePath: post.imagePath,
      isSelected: post.isSelected,
    );

    try {
      int postList = await postLocalDataSource.deletePost(postModel);
      return Right(postList);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Post>>>? findPosts(String searchTerm) async {
    try {
      List<Post> postList = await postLocalDataSource.findPosts(searchTerm);
      return Right(postList);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
