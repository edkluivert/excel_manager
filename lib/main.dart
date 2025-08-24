import 'package:excel_manager/core/config/theme/app_theme.dart';
import 'package:excel_manager/core/di/injector.dart';
import 'package:excel_manager/core/routes/app_routes.dart';
import 'package:excel_manager/services/notification/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await initInjector();
  await NotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}

