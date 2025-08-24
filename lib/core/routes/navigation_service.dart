import 'package:flutter/material.dart';


class NavigationService {
  final GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();
  NavigatorState? get currentState => _navigationKey.currentState;
  String? _currentRoute;
  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  String? get currentRoute => _currentRoute;

  void pop() {

    return currentState!.pop();
  }

  Future<dynamic> navigateTo(String routeName, {Object? arguments}) {

    _currentRoute = routeName;
    return currentState!.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<dynamic> clearLastAndNavigateTo(String routeName, {Object? arguments}) {

    _currentRoute = routeName;
    return currentState!.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<dynamic> removeAllAndNavigateTo(
      String routeName, {
        Object? arguments,
        bool Function(Route<dynamic>)? predicate,
      }) {

    _currentRoute = routeName;
    return currentState!.pushNamedAndRemoveUntil(
      routeName,
      predicate ?? (r) => false,
      arguments: arguments,
    );
  }
}
