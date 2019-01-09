import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_movies/bloc/authentication_bloc.dart';
import 'package:flutter_movies/bloc/login_bloc.dart';
import 'package:flutter_movies/models/authentication_event.dart';
import 'package:flutter_movies/models/login_event.dart';
import 'package:flutter_movies/models/login_state.dart';

class LoginForm extends StatefulWidget {
  final ValidationBloc validationBloc;
  final AuthenticationBloc authBloc;

    LoginForm({
    Key key,
    @required this.validationBloc,
    @required this.authBloc,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSuccessDispatched = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ValidationEvent, ValidationState>(
      bloc: widget.validationBloc,
      builder: (
          BuildContext context,
          ValidationState loginState,
          ) {
        ValidationState state;

        if (loginState is ValidationFinished) {
          state = loginState;
          if (loginState.isFieldsValid) {
            if (!_isSuccessDispatched) {
              widget.authBloc.dispatch(ValidationSuccess(
                username: _usernameController.text,
                password: _passwordController.text,
              ));
              _isSuccessDispatched = true;
            }
          } else {
            widget.authBloc.dispatch(ValidationNotSuccess());
          }
        }

        return _form(state);
      },
    );
  }

  Widget _form(ValidationFinished validation) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'username',
                  errorText: _obtainErrorText(validation, Fields.USERNAME)
              ),
              controller: _usernameController,
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'password',
                  errorText: _obtainErrorText(validation, Fields.PASSWORD)
              ),
              controller: _passwordController,
              obscureText: true,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: RaisedButton(
                onPressed: _onLoginButtonPressed,
                child: Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onLoginButtonPressed() {
    widget.validationBloc.dispatch(
        LoginButtonPressed(
            fields: {
              Fields.USERNAME: _usernameController.text,
              Fields.PASSWORD: _passwordController.text
            }
        )
    );
  }

  String _obtainErrorText(ValidationFinished validation, String key) {

    final field = validation?.fields?.containsKey(key) == true ? validation?.fields[key] : null;
    return field?.reason;
  }
}