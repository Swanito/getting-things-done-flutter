import 'package:flutter/material.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';

class BasicProcess extends StatelessWidget {
  final GTDElement element;
  final UserRepository userRepository;
  
  final Widget step;

  BasicProcess({@required this.userRepository, @required this.element, @required this.step});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Procesando ${element.summary}',
                style: TextStyle(color: Colors.black)),
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.transparent,
            elevation: 0),
        body: step);
  }
}
