import 'package:flutter_movies/models/authentication_event.dart';
import 'package:flutter_movies/repo/user_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_movies/bloc/authentication_bloc.dart';
import 'package:flutter_movies/models/authentication_state.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  AuthenticationBloc authenticationBloc;
  MockUserRepository userRepository;

  setUp(() {
    userRepository = MockUserRepository();
    authenticationBloc = AuthenticationBloc(userRepository: userRepository);
  });

  test('initial state is correct', () {
    expect(authenticationBloc.initialState, AuthenticationUninitialized());
  });

  test('dispose does not emit new states', () {
    expectLater(
      authenticationBloc.state,
      emitsInOrder([]),
    );
    authenticationBloc.dispose();
  });

  group('AppStarted', () {
    test('emits [uninitialized, unauthenticated] for invalid token', () {
      final expectedResponse = [
        AuthenticationUninitialized(),
        AuthenticationInitialized.unauthenticated(),
      ];

      when(userRepository.hasToken()).thenAnswer((_) => Future.value(false));

      expectLater(
        authenticationBloc.state,
        emitsInOrder(expectedResponse),
      );

      authenticationBloc.dispatch(AppStart());
    });
  });

//  group('LoggedIn', () {
//    test('emits [uninitialized, loading, authenticated] when token is persisted',   () {
//          final expectedResponse = [
//            AuthenticationUninitialized(),
//            AuthenticationInitialized(isLoading: true, isAuthenticated: false),
//            AuthenticationInitialized.authenticated(),
//          ];
//
//          expectLater(
//            authenticationBloc.state,
//            emitsInOrder(expectedResponse),
//          );
//
//          authenticationBloc.dispatch(ValidationSuccess(
//            token: 'instance.token',
//          ));
//        });
//  });
//
//  group('LoggedOut', () {
//    test('emits [uninitialized, loading, unauthenticated] when token is deleted', () {
//          final expectedResponse = [
//            AuthenticationUninitialized(),
//            AuthenticationInitialized(isLoading: true, isAuthenticated: true),
//            AuthenticationInitialized.unauthenticated(),
//          ];
//
//          expectLater(
//            authenticationBloc.state,
//            emitsInOrder(expectedResponse),
//          );
//
//          authenticationBloc.dispatch(Logout());
//        });
//  });
}
