import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/auth/forgot_password/forgot_password_form.dart';
import 'package:gtd/auth/login/login_barrel.dart';
import 'package:gtd/core/core_blocs/navigator_bloc.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final UserRepository _userRepository;

  ForgotPasswordScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: GestureDetector(
                      onTap: () => {
                        BlocProvider.of<NavigatorBloc>(context)
                            .add(NavigatorActionPop())
                      },
                      child: Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: (MediaQuery.of(context).size.height / 10)),
            BlocProvider<LoginBloc>(
              create: (context) =>
                  LoginBloc(userRepository: _userRepository),
              child: Column(
                  children: <Widget>[
                    Text('Recuperar Contraseña', style: TextStyle(color: Colors.white, fontSize: 32), textAlign: TextAlign.left,),
                    ForgotPasswordForm(userRepository: _userRepository),
                  ],
                ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.orange[400],
    );
  }
}
