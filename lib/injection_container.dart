import 'package:get_it/get_it.dart';
import 'package:my_blog_bloc/features/add_post/data/datasources/update_posts_local_data_sources.dart';
import 'package:my_blog_bloc/features/add_post/data/repositories/update_post_repositories_impl.dart';
import 'package:my_blog_bloc/features/add_post/domain/repositories/update_post_repository.dart';
import 'package:my_blog_bloc/features/add_post/domain/usecases/update_post.dart';
import 'package:my_blog_bloc/features/home/data/data_sources/posts_local_data_sources.dart';
import 'features/add_post/data/datasources/post_posts_local_data_sources.dart';
import 'features/add_post/data/repositories/post_posts_repositories_impl.dart';
import 'features/add_post/domain/repositories/post_posts_repositories.dart';
import 'features/add_post/domain/usecases/post_post.dart';
import 'features/add_post/presentation/bloc/post_add_bloc.dart';
import 'features/home/data/repositories/post_repository_impl.dart';
import 'features/home/domain/repositories/post_repositories.dart';
import 'features/home/domain/usecases/get_posts.dart';
import 'features/home/presentation/bloc/post_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => PostBloc(getPosts: sl(), updatePost: sl()));

  sl.registerLazySingleton(() => GetPosts(sl()));
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(
      postLocalDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<PostLocalDataSource>(() => PostLocalDataSourceImpl());

  sl.registerFactory(() => PostAddBloc(
        postPosts: sl(),
        updatePost: sl(),
        getPosts: sl(),
      ));
  sl.registerLazySingleton(() => PostPosts(sl()));
  sl.registerLazySingleton<PostPostsRepository>(
    () => PostPostsRepositoriesImpl(
      postPostsLocalDataSources: sl(),
    ),
  );
  sl.registerLazySingleton<PostPostsLocalDataSources>(() => PostPostsLocalDataSourcesImpl());

  sl.registerLazySingleton(() => UpdatePost(sl()));
  sl.registerLazySingleton<UpdatePostRepository>(
    () => UpdatePostRepositoriesImpl(
      updatePostLocalDataSources: sl(),
    ),
  );

  sl.registerLazySingleton<UpdatePostLocalDataSources>(
    () => UpdatePostLocalDataSourcesImpl(),
  );
}
