import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/auth/register/register_barrel.dart';
import 'package:gtd/auth/register/register_form.dart';
import 'package:gtd/core/core_blocs/navigator_bloc.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';

class RegisterScreen extends StatelessWidget {
  final UserRepository _userRepository;

  RegisterScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(color: Colors.pink[200]),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: ListView(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => {
                        BlocProvider.of<NavigatorBloc>(context)
                            .add(NavigatorAction.NavigatorActionPop)
                      },
                      child: Icon(Icons.arrow_back_ios, color: Colors.white),
                    )
                  ],
                ),
                Container(
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height / 4)),
                BlocProvider<RegisterBloc>(
                  create: (context) =>
                      RegisterBloc(userRepository: _userRepository),
                  child: RegisterForm(),
                ),
              ],
            ),
          )),
    );
  }
}
