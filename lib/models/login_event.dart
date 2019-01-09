import 'package:meta/meta.dart';

abstract class ValidationEvent {}

class LoginButtonPressed extends ValidationEvent {
  final Map<String, String> fields;

  LoginButtonPressed({
    @required this.fields,
  });
}

class InputValid extends ValidationEvent {}