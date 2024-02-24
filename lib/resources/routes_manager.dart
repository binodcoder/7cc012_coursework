import 'package:flutter/material.dart';
import 'package:my_blog_bloc/resources/strings_manager.dart';
import 'package:my_blog_bloc/features/home/presentation/ui/post.dart';

class Routes {
  static const String homeRoute = "/";
  static const String onBordingRoute = "/home";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => HomeScreen());

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
