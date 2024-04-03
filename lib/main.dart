import 'package:blog_app/resources/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'injection_container.dart';
import 'injection_container.dart' as di;
import 'layers/presentation/post/add_update_post/bloc/create_post_bloc.dart';
import 'layers/presentation/post/read_posts/bloc/read_posts_bloc.dart';
import 'layers/presentation/post/read_posts/ui/read_posts_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ReadPostsBloc>(
          create: (BuildContext context) => sl<ReadPostsBloc>(),
        ),
        BlocProvider<CreatePostBloc>(
          create: (BuildContext context) => sl<CreatePostBloc>(),
        ),
      ],
      child: const ScreenUtilInit(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppStrings.titleLabel,
          home: ReadPostsPage(),
        ),
      ),
    );
  }
}
