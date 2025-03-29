import 'package:flutter/material.dart';
import '../../presentation/screens/main_screen.dart';
import '../../presentation/screens/all_items_screen.dart';
import '../../presentation/screens/specific_list_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case '/all-items':
        return MaterialPageRoute(builder: (_) => const AllItemsScreen());
      case '/specific-list':
        return MaterialPageRoute(builder: (_) => const SpecificListScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
