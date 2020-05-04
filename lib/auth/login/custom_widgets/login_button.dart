import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback _onPressed;

  LoginButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      color: Colors.white,
      onPressed: _onPressed,
      child: Text('Iniciar Sesión', style: TextStyle(fontSize: 18)),
    );
  }
}
