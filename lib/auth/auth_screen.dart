import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/core/core_blocs/navigator_bloc.dart';
import 'package:gtd/core/styles.dart';
import 'package:lottie/lottie.dart';

class AuthScreen extends StatelessWidget {
  Widget _createAuthMainScreen(BuildContext context, {LottieBuilder lottie, String title, Widget loginButton, Widget registerButton}) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 60.0),
            Center(child: lottie),
            SizedBox(height: 60.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  style: kTitleStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 60.0),
            SizedBox(
              width: double.infinity - 100,
              height: MediaQuery.of(context).size.height / 12,
              child: loginButton,
            ),
            SizedBox(height: 15.0),
            SizedBox(
              width: double.infinity - 100,
              height: MediaQuery.of(context).size.height / 12,
              child: registerButton,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget loginButton = RaisedButton(
      color: Colors.white,
      onPressed: () => {
        BlocProvider.of<NavigatorBloc>(context)
            .add(NavigatorAction.NavigateToLoginEvent),
      },
      child: Text('Iniciar Sesión', style: kButtonLabel),
    );

    final Widget registerButton = RaisedButton(
      color: Colors.white,
      onPressed: () => {
                BlocProvider.of<NavigatorBloc>(context)
            .add(NavigatorAction.NavigateToRegisterEvent),
      },
      child: Text('Registrarse', style: kButtonLabel),
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.purple[600],
        ),
        child: ListView(
          children: <Widget>[
            _createAuthMainScreen(
              context,
              title: 'Empecemos!',
              lottie: Lottie.asset(
                'assets/rocket.json',
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.width / 2,
              ),
              loginButton: loginButton, 
              registerButton: registerButton,
            )
          ],
        ),
      ),
    );
  }
}
