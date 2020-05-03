import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/core/core_blocs/navigator_bloc.dart';
import 'package:lottie/lottie.dart';

class AuthScreen extends StatelessWidget {
  Widget _createAuthMainScreen(BuildContext context,
      {LottieBuilder lottie, Widget loginButton, Widget registerButton}) {
    Size size = MediaQuery.of(context).size;

    return Container(
      child: Padding(
        padding: EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: size.height / 12),
            Text(
              'Do Things!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            Text(
              'Empieza a trabajar con GTD hoy mismo.',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: size.height / 12),
            Center(child: lottie),
            SizedBox(height: size.height / 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  loginButton,
                  SizedBox(height: 15),
                  registerButton
                ],
              ),
            ),
            Container(
              width: size.width - 100,
              child: Text(
                'Utilizando el servicio de Do Things aceptas los términos y condiciones del servicio.',
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget loginButton = ButtonTheme(
      minWidth: MediaQuery.of(context).size.width - 100,
        child: RaisedButton(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      color: Colors.orange,
      onPressed: () => {
        BlocProvider.of<NavigatorBloc>(context).add(NavigateToLoginEvent()),
      },
      child: Text('Iniciar Sesión',
          style: TextStyle(color: Colors.white, fontSize: 18)),
    ));

    final Widget registerButton = ButtonTheme(
      minWidth: MediaQuery.of(context).size.width - 100,
        child: RaisedButton(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      color: Colors.orange,
      onPressed: () => {
        BlocProvider.of<NavigatorBloc>(context).add(NavigateToRegisterEvent()),
      },
      child: Text('Crear cuenta',
          style: TextStyle(color: Colors.white, fontSize: 18)),
    ));

    return Scaffold(
      backgroundColor: Colors.orange[200],
      body: _createAuthMainScreen(
        context,
        lottie: Lottie.asset(
          'assets/rocket.json',
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.width / 2,
        ),
        loginButton: loginButton,
        registerButton: registerButton,
      ),
    );
  }
}
