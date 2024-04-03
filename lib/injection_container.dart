import 'package:blog_app/layers/domain/post/usecases/find_posts.dart';
import 'package:get_it/get_it.dart';
import 'layers/data/post/data_sources/posts_local_data_sources.dart';
import 'layers/data/post/repositories/post_repository_impl.dart';
import 'layers/domain/post/repositories/post_repositories.dart';
import 'layers/domain/post/usecases/create_post.dart';
import 'layers/domain/post/usecases/delete_post.dart';
import 'layers/domain/post/usecases/read_posts.dart';
import 'layers/domain/post/usecases/update_post.dart';
import 'layers/presentation/post/add_update_post/bloc/create_post_bloc.dart';
import 'layers/presentation/post/read_posts/bloc/read_posts_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => ReadPostsBloc(
        getPosts: sl(),
        updatePost: sl(),
        deletePost: sl(),
        findPosts: sl(),
      ));

  sl.registerFactory(() => CreatePostBloc(
        postPosts: sl(),
        updatePost: sl(),
        getPosts: sl(),
      ));
  sl.registerLazySingleton(() => CreatePost(sl()));
  sl.registerLazySingleton(() => ReadPosts(sl()));
  sl.registerLazySingleton(() => DeletePost(sl()));
  sl.registerLazySingleton(() => UpdatePost(sl()));
  sl.registerLazySingleton(() => FindPosts(sl()));

  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(
      postLocalDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<PostLocalDataSource>(() => PostLocalDataSourceImpl());
}
