import 'package:excel_manager/application/auth/auth_event.dart';
import 'package:excel_manager/application/auth/auth_state.dart';
import 'package:excel_manager/services/shared_pref/shared_pref_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  AuthBloc(this._prefs) : super(AuthInitial()) {
    on<AuthCheckRequested>((event, emit) {
      final token = _prefs.authToken;
      if (token != null && token.isNotEmpty) {
        debugPrint('AuthBloc: User is authenticated with token: $token');
        emit(AuthAuthenticated(token));
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<AuthLoggedIn>((event, emit) async {
      await _prefs.saveAuthToken(event.token);
      emit(AuthAuthenticated(event.token));
    });

    on<AuthLoggedOut>((event, emit) async {
      await _prefs.clearAuthToken();
      emit(AuthUnauthenticated());
    });
  }
  final SharedPrefsService _prefs;
}
