import 'package:blog_app/resources/strings_manager.dart';
import 'package:flutter/material.dart';
import '../layers/presentation/post/read_posts/ui/read_posts_page.dart';

class Routes {
  static const String homeRoute = "/";
  static const String onBordingRoute = "/home";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => const ReadPostsPage());

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
          appBar: AppBar(title: const Text(AppStrings.noRouteFound)),
          body: const Center(
            child: Text(AppStrings.noRouteFound),
          )),
    );
  }
}
