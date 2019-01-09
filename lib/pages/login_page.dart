import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_movies/bloc/authentication_bloc.dart';
import 'package:flutter_movies/bloc/login_bloc.dart';
import 'package:flutter_movies/repo/user_repo.dart';
import 'package:flutter_movies/widget/login_form.dart';

class LoginPage extends StatefulWidget {

  final UserRepository userRepository;

  LoginPage({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  ValidationBloc _loginBloc;

  @override
  void initState() {
    _loginBloc = ValidationBloc(userRepository: widget.userRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: LoginForm(
        authBloc: BlocProvider.of<AuthenticationBloc>(context),
        validationBloc: _loginBloc,
      ),
    );
  }


  // TODO: show snackbar when unable to obtain aunt token
  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }
}