import 'package:excel_manager/presentation/screens/ai/ai_assistant_screen.dart';
import 'package:excel_manager/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:excel_manager/presentation/screens/login/login_screen.dart';
import 'package:excel_manager/presentation/screens/tasks/task_screen.dart';
import 'package:flutter/material.dart';


class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      //case '/': return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/': return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case '/tasks':
        final projectId = settings.arguments as String? ?? '';
        return MaterialPageRoute(builder: (_) => TaskScreen(projectName: projectId));
      default:
        return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Not found'))));
    }
  }
}
