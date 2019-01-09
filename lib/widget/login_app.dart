import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_movies/bloc/authentication_bloc.dart';
import 'package:flutter_movies/models/authentication_event.dart';
import 'package:flutter_movies/models/authentication_state.dart';
import 'package:flutter_movies/pages/home_page.dart';
import 'package:flutter_movies/pages/login_page.dart';
import 'package:flutter_movies/pages/splash_page.dart';
import 'package:flutter_movies/repo/user_repo.dart';
import 'package:flutter_movies/widget/login_indicator.dart';

class LoginApp extends StatefulWidget {
  @override
  State<LoginApp> createState() => LoginAppState();
}

class LoginAppState extends State<LoginApp> {
  AuthenticationBloc _authenticationBloc;
  final UserRepository _userRepository = UserRepository();

  @override
  void initState() {
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
    _authenticationBloc.dispatch(AppStart());
    super.initState();
  }

  @override
  void dispose() {
    _authenticationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      bloc: _authenticationBloc,
      child: MaterialApp(
        home: BlocBuilder<AuthenticationEvent, AuthenticationState>(
          bloc: _authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            List<Widget> widgets = [];
            if (state is AuthenticationUninitialized) {
              widgets.add(SplashPage());
            }
            if (state is AuthenticationInitialized) {
              if (state.isAuthenticated) {
                widgets.add(HomePage());
              } else {
                widgets.add(LoginPage(
                  userRepository: _userRepository,
                ));
              }
              if (state.isLoading) {
                widgets.add(LoadingIndicator());
              }
            }

            return Stack(
              children: widgets,
            );
          },
        ),
      ),
    );
  }
}