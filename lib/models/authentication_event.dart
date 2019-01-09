
import 'package:meta/meta.dart';

abstract class AuthenticationEvent {}

class AppStart extends AuthenticationEvent {}

class ValidationSuccess extends AuthenticationEvent {
  final String username;
  final String password;

  ValidationSuccess({
    @required this.username,
    @required this.password,
  }): super();
}

class ValidationNotSuccess extends AuthenticationEvent {}

class Logout extends AuthenticationEvent {}