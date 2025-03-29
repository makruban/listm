import 'package:flutter/material.dart';
import '../../presentation/screens/main_screen.dart';
import '../../presentation/screens/all_items_screen.dart';
import '../../presentation/screens/specific_list_screen.dart';

// Route configuration
class RouteConfiguration {
  final String location;
  final Map<String, dynamic>? arguments;

  RouteConfiguration({
    required this.location,
    this.arguments,
  });
}

// Router Delegate
class AppRouterDelegate extends RouterDelegate<RouteConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteConfiguration> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  String _currentPath = '/';
  Map<String, dynamic>? _arguments;

  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  RouteConfiguration? get currentConfiguration => RouteConfiguration(
        location: _currentPath,
        arguments: _arguments,
      );

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (_currentPath == '/')
          const MaterialPage(
            key: ValueKey('home'),
            child: MainScreen(),
          )
        else if (_currentPath == '/all-items')
          const MaterialPage(
            key: ValueKey('allItems'),
            child: AllItemsScreen(),
          )
        else if (_currentPath == '/specific-list')
          const MaterialPage(
            key: ValueKey('specificList'),
            child: SpecificListScreen(),
          ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        _currentPath = '/';
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RouteConfiguration configuration) async {
    _currentPath = configuration.location;
    _arguments = configuration.arguments;
    notifyListeners();
  }

  void navigateTo(String path, {Map<String, dynamic>? arguments}) {
    _currentPath = path;
    _arguments = arguments;
    notifyListeners();
  }
}

// Route Information Parser
class AppRouteInformationParser
    extends RouteInformationParser<RouteConfiguration> {
  @override
  Future<RouteConfiguration> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? '/');
    return RouteConfiguration(
      location: uri.path,
      arguments: null,
    );
  }

  @override
  RouteInformation? restoreRouteInformation(RouteConfiguration configuration) {
    return RouteInformation(location: configuration.location);
  }
}
