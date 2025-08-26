import 'package:excel_manager/application/auth/auth_bloc.dart';
import 'package:excel_manager/application/auth/auth_event.dart';
import 'package:excel_manager/application/auth/auth_state.dart';
import 'package:excel_manager/application/theme/theme_cubit.dart';
import 'package:excel_manager/core/config/theme/app_theme.dart';
import 'package:excel_manager/core/di/injector.dart';
import 'package:excel_manager/core/routes/app_routes.dart';
import 'package:excel_manager/core/routes/navigation_service.dart';
import 'package:excel_manager/services/notification/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await initInjector();
  await NotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    final navigatorService = sl<NavigationService>();
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: sl<ThemeCubit>(),
        ),
        BlocProvider.value(
          value: sl<AuthBloc>()..add(AuthCheckRequested()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthUnauthenticated) {
                navigatorService.removeAllAndNavigateTo('/login');
              } else if (state is AuthAuthenticated) {
                navigatorService.removeAllAndNavigateTo('/dashboard');
              }
            },
            child: MaterialApp(
              title: 'Flutter Demo',
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              debugShowCheckedModeBanner: false,
              themeMode: themeMode,
              onGenerateRoute: AppRouter.onGenerateRoute,
              navigatorKey: navigatorService.navigationKey,
            ),
          );
        },
      ),
    );
  }
}

