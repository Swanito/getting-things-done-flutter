import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/core/core_blocs/navigator_bloc.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/home/procesar/basic/actionable_screen.dart';

class BasicProcess extends StatelessWidget {
  GTDElement element;
  UserRepository userRepository;
  
  Widget step;

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
