
import 'package:excel_manager/services/shared_pref/shared_pref_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {

  ThemeCubit(this._prefs)
      : super(_prefs.isDarkMode ? ThemeMode.dark : ThemeMode.light);
  final SharedPrefsService _prefs;

  void toggleTheme({required bool isDark}) {
    _prefs.setDarkMode(value: isDark);
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
