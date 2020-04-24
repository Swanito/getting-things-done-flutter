import 'package:flutter/material.dart';
import 'package:gtd/auth/forgot_password/forgot_password_screen.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';

class ForgotPasswordButton extends StatelessWidget {
  final UserRepository _userRepository;

  ForgotPasswordButton({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        'No recuerdo mi contraseña...', style: TextStyle(color: Colors.white)
        ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return ForgotPasswordScreen(userRepository: _userRepository);
          }),
        );
      },
    );
  }
}
