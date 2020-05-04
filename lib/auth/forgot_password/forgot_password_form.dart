import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/auth/forgot_password/custom_widgets/forgot_password_button.dart';
import 'package:gtd/auth/login/login_barrel.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';

class ForgotPasswordForm extends StatefulWidget {
  final UserRepository userRepository;

  ForgotPasswordForm({@required this.userRepository});

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final TextEditingController _emailController = TextEditingController();

  LoginBloc _loginBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty;

  bool isResetButtonEnabled(LoginState state) {
    return state.isEmailValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<LoginBloc, LoginState>(listener: (context, state) {
      if(state.hasSentRecoveryEmail) {
        _showSnackbar(context, 'Te hemos envíado un email de recuperación.', isError: false);
      } else if (state.isFailure) {
        _showSnackbar(context, 'Error enviando el mail', isError: true);
      }
    },child: 
    BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return Form(
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),
                hintStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.white,
                      width: 1.0,
                      style: BorderStyle.solid),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.white),
              autovalidate: true,
              autocorrect: false,
              validator: (_) {
                return !state.isEmailValid ? 'Email no válido.' : null;
              },
            ),
            Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ForgotPasswordButton(
                        onPressed: isResetButtonEnabled(state)
                            ? _onFormSubmitted
                            : null,
                      ),
                    ],
                  ),
                ),
          ],
        ),
      );
    }));
  }

  void _showSnackbar(BuildContext context, String message, {bool isError}) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: isError ? Colors.red : Colors.green,));
  }

  void _onFormSubmitted() {
    _loginBloc.add(ResetPassword(email: _emailController.text));
  }

  void _onEmailChanged() {
    _loginBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

}
