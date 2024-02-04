import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_blog_bloc/resources/strings_manager.dart';
import 'package:my_blog_bloc/ui/post.dart';
import 'bloc/post_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.titleLabel,
        home: HomeScreen(),
      ),
    );
  }
}
