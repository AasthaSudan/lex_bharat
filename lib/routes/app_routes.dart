import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/learn/categories_screen.dart';
import '../screens/forms/form_categories_screen.dart';
import '../screens/resources/resources_home_screen.dart';
import '../screens/profile/profile_screen.dart';

class AppRoutes {
  // Route names
  static const String splash = '/';
  static const String home = '/home';
  static const String chat = '/chat';
  static const String learn = '/learn';
  static const String forms = '/forms';
  static const String resources = '/resources';
  static const String profile = '/profile';

  // Generate routes
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case chat:
        return MaterialPageRoute(builder: (_) => const ChatScreen());

      case learn:
        return MaterialPageRoute(builder: (_) => const CategoriesScreen());

      case forms:
        return MaterialPageRoute(builder: (_) => const FormCategoriesScreen());

      case resources:
        return MaterialPageRoute(builder: (_) => const ResourcesHomeScreen());

      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route ${settings.name} not found'),
            ),
          ),
        );
    }
  }
}