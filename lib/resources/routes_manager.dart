import 'package:blog_app/layers/presentation/login/ui/login_page.dart';
import 'package:blog_app/layers/presentation/post/add_update_post/ui/create_post_page.dart';
import 'package:blog_app/layers/presentation/post/read_posts/ui/post_details_page.dart';
import 'package:blog_app/resources/strings_manager.dart';
import 'package:flutter/material.dart';
import '../layers/presentation/onboarding/onboarding.dart';
import '../layers/presentation/post/read_posts/ui/read_posts_page.dart';
import '../layers/presentation/splash/splash.dart';

class Routes {
  static const String splashRoute = "/";
  static const String onBordingRoute = "/onboarding";
  static const String loginRoute = "/login";
  static const String readPostRoute = "/read_post";
  static const String postDetailRoute = "/post_detail";
  static const String createPostRoute = "/create_post";
  static const String mainRoute = "/main";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (context) => const SplashView());
      case Routes.onBordingRoute:
        return MaterialPageRoute(builder: (context) => const OnBoardingView());
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (context) => const LoginPage());
      case Routes.readPostRoute:
        return MaterialPageRoute(builder: (context) => const ReadPostsPage());
      case Routes.postDetailRoute:
        return MaterialPageRoute(builder: (context) => const PostDetailsPage());
      case Routes.createPostRoute:
        return MaterialPageRoute(builder: (context) => const CreatePostPage());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.noRouteFound),
          ),
          body: const Center(
            child: Text(AppStrings.noRouteFound),
          )),
    );
  }
}
