import 'package:bloc/bloc.dart';
import 'package:flutter_movies/models/login_event.dart';
import 'package:flutter_movies/models/login_state.dart';
import 'package:flutter_movies/repo/user_repo.dart';
import 'package:meta/meta.dart';

class Fields {
  static const USERNAME = "username";
  static const PASSWORD = "password";
}

class ValidationBloc extends Bloc<ValidationEvent, ValidationState> {
  final UserRepository userRepository;

  ValidationBloc({@required this.userRepository}) : assert(userRepository != null);

  ValidationState get initialState => ValidationInitial();

  @override
  Stream<ValidationState> mapEventToState(
      ValidationState currentState,
      ValidationEvent event,
      ) async* {
    if (event is LoginButtonPressed) {
      yield ValidationLoading();

      final invalidated = _validateFields(event);
      yield ValidationFinished(fields: invalidated);
    }

    if (event is InputValid) {
      yield ValidationInitial();
    }
  }

  Map<String, FieldValidation> _validateFields(LoginButtonPressed event) {
    final invalidated = Map<String, FieldValidation>();
    final username = event.fields[Fields.USERNAME];
    if (username != null) invalidated[Fields.USERNAME] = _validateUsername(username);
    final password = event.fields[Fields.PASSWORD];
    if (password != null) invalidated[Fields.PASSWORD] = _validatePassword(password);
    return invalidated;
  }

  FieldValidation _validateUsername(String username) {
    var isValid = false;
    String reason;
    if (username == null || username.isEmpty) reason = "Username is empty";
    if (username.length < 4) reason = "Username lenght is too short";
    if (username.length > 10) reason = "Username lenght is too long";
    if (reason == null) isValid = true;
    return FieldValidation(isValid: isValid, reason: reason);
  }

  FieldValidation _validatePassword(String password) {
    var isValid = false;
    String reason;
    if (password == null) reason = "Password is empty";
    if (password.length < 4) reason = "Password lenght is too short";
    if (password.length > 10) reason = "Password lenght is too long";
    if (reason == null) isValid = true;
    return FieldValidation(isValid: isValid, reason: reason);
  }
}