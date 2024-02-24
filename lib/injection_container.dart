import 'package:get_it/get_it.dart';
import 'package:my_blog_bloc/features/home/data/data_sources/posts_local_data_sources.dart';
import 'features/home/data/repositories/post_repository_impl.dart';
import 'features/home/domain/repositories/post_repositories.dart';
import 'features/home/domain/usecases/get_posts.dart';
import 'features/home/presentation/bloc/post_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => PostBloc(getPosts: sl()));
  sl.registerLazySingleton(() => GetPosts(sl()));
  sl.registerLazySingleton<PostRepository>(() => PostRepositoryImpl(
        postLocalDataSource: sl(),
      ));
  sl.registerLazySingleton<PostLocalDataSource>(() => PostLocalDataSourceImpl());
}
