import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_blog_bloc/resources/strings_manager.dart';
import 'features/add_post/bloc/post_add_bloc.dart';
import 'features/home/presentation/bloc/post_bloc.dart';
import 'features/home/presentation/ui/post.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostBloc>(
          create: (BuildContext context) => PostBloc(),
        ),
        BlocProvider<PostAddBloc>(
          create: (BuildContext context) => PostAddBloc(),
        ),
      ],
      child: const ScreenUtilInit(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppStrings.titleLabel,
          home: HomeScreen(),
        ),
      ),
    );
  }
}
