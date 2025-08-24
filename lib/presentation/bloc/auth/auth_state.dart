import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthAuthenticated extends AuthState {

  const AuthAuthenticated(this.token);
  final String token;

  @override
  List<Object?> get props => [token];
}

class AuthUnauthenticated extends AuthState {}
