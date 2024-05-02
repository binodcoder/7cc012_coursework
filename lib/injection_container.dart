import 'package:blog_app/layers/data/login/datasources/login_local_data_source.dart';
import 'package:blog_app/layers/domain/login/usecases/login.dart';
import 'package:blog_app/layers/domain/post/usecases/find_posts.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'layers/data/login/repositories/login_repositories_impl.dart';
import 'layers/data/post/data_sources/posts_local_data_sources.dart';
import 'layers/data/post/repositories/post_repository_impl.dart';
import 'layers/domain/login/repositories/login_repositories.dart';
import 'layers/domain/post/repositories/post_repositories.dart';
import 'layers/domain/post/usecases/create_post.dart';
import 'layers/domain/post/usecases/delete_post.dart';
import 'layers/domain/post/usecases/read_posts.dart';
import 'layers/domain/post/usecases/update_post.dart';
import 'layers/presentation/login/bloc/login_bloc.dart';
import 'layers/presentation/post/add_update_post/bloc/create_post_bloc.dart';
import 'layers/presentation/post/read_posts/bloc/read_posts_bloc.dart';

/*
It is a powerful dependency injection framework that enables registration and retrieval of dependencies,
improving testability and decoupling components, allowing easy access to services and models.
 */

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => ReadPostsBloc(getPosts: sl(), updatePost: sl(), deletePost: sl(), findPosts: sl()));

  sl.registerFactory(() => CreatePostBloc(postPosts: sl(), updatePost: sl(), getPosts: sl()));

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

  //login
  sl.registerFactory(() => LoginBloc(
        login: sl(),
      ));

  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<LoginLocalDataSource>(() => LoginLocalDataSourceImpl());

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
