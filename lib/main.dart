import 'package:blog_app/core/db/db_helper.dart';
import 'package:blog_app/core/model/user_model.dart';
import 'package:blog_app/resources/routes_manager.dart';
import 'package:blog_app/resources/strings_manager.dart';
import 'package:blog_app/resources/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'injection_container.dart';
import 'injection_container.dart' as di;
import 'layers/presentation/post/add_update_post/bloc/create_post_bloc.dart';
import 'layers/presentation/post/read_posts/bloc/read_posts_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  register();
  runApp(const MyApp());
}

void register() async {
  await DatabaseHelper.register(UserModel(
    email: "root",
    name: "Binod Bhandari",
    password: "root",
    phone: 9807434858,
    role: "admin",
  ));
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
      child: ScreenUtilInit(
        child: MaterialApp(
          onGenerateRoute: RouteGenerator.getRoute,
          theme: getApplicationTheme(),
          debugShowCheckedModeBanner: false,
          title: AppStrings.titleLabel,
          initialRoute: Routes.splashRoute,
          // home: const ReadPostsPage(),
        ),
      ),
    );
  }
}
