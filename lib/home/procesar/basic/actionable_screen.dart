import 'package:flutter/material.dart';

class BasicProcess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ActionableScreen();
  }
}

class ActionableScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flujo Básico de procesado')),
    );
  }
}
