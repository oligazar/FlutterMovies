import 'package:flutter_movies/models/authentication_event.dart';
import 'package:flutter_movies/models/authentication_state.dart';
import 'package:flutter_movies/repo/user_repo.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'dart:async';


class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {

  final UserRepository userRepository;

  AuthenticationBloc({@required this.userRepository})
      : assert(userRepository != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationState currentState,
      AuthenticationEvent event,
      ) async* {
    if (event is AppStart) {
      final bool hasToken = await userRepository.hasToken();

      if (hasToken) {
        yield AuthenticationInitialized.authenticated();
      } else {
        yield AuthenticationInitialized.unauthenticated();
      }
    }

    if (event is ValidationSuccess) {
      try {
        yield AuthenticationInitialized(isAuthenticated: false, isLoading: true);
        final token = await userRepository.authenticate(
          username: event.username,
          password: event.password,
        );
        await userRepository.persistToken(token);
        yield AuthenticationInitialized.authenticated();
      } catch(error) {
        // TODO: show snackbar
        print("Hello");
      }
    }
    if (event is ValidationNotSuccess) {
      yield AuthenticationInitialized.unauthenticated();
    }

    if (event is Logout) {
      yield AuthenticationInitialized(isAuthenticated: true, isLoading: true);
      await userRepository.deleteToken();
      yield AuthenticationInitialized.unauthenticated();
    }
  }
}