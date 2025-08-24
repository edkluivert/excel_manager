import 'package:excel_manager/application/theme/theme_cubit.dart';
import 'package:excel_manager/core/di/injector.dart';
import 'package:excel_manager/services/shared_pref/shared_pref_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final projects = ['Work', 'Personal', 'Wellness'];

  final ThemeCubit themeCubit = sl<ThemeCubit>();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return BlocBuilder<ThemeCubit, ThemeMode>(
      bloc: themeCubit,
      builder: (context, state) {
        final isDarkMode = state == ThemeMode.dark;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard'),
            centerTitle: false,
            actions: [
              Row(
                spacing: 10,
                children: [
                  const Text('Dark Mode'),
                  Switch(
                    value: isDarkMode,
                    onChanged: (val) => themeCubit.toggleTheme(isDark: val),
                  ),
                  const SizedBox(width: 12), // spacing
                ],
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return ListTile(
                title: Text(project),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/tasks',
                    arguments: project,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
