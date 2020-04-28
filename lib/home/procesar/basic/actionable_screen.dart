import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/core/core_blocs/navigator_bloc.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/home/elements/element_bloc.dart';
import 'package:gtd/home/procesar/basic/process_screen_template.dart';

class ActionableScreen extends StatefulWidget {
  final GTDElement element;
  final UserRepository userRepository;

  ActionableScreen({this.element, this.userRepository});

  @override
  _ActionableScreenState createState() => _ActionableScreenState();
}

class _ActionableScreenState extends State<ActionableScreen> {
  void continueFunction({GTDElement element, UserRepository userRepository}) {
    print('el elemento ${element.summary} es accionable');
    BlocProvider.of<NavigatorBloc>(context).add(GoToProcessStepScreen(
        elementBeingProcessed: element, userRepository: userRepository));
  }

  Future<void> alternativeFunction(
      {GTDElement element, UserRepository userRepository}) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Veamos...'),
          content: Text(
              'Si el item no es accionable te recomendamos moverlo a una de éstas categorías...'),
          actions: <Widget>[
            FlatButton(
              child: Text('Mover a Referencias'),
              onPressed: () {
                BlocProvider.of<ElementBloc>(context)
                    .add(MoveToReference(element));
                BlocProvider.of<NavigatorBloc>(context)
                    .add(NavigatorActionPopAll());
              },
            ),
            FlatButton(
              child: Text('Mover a Papelera'),
              onPressed: () {
                BlocProvider.of<ElementBloc>(context)
                    .add(MoveToDelete(element));
                BlocProvider.of<NavigatorBloc>(context)
                    .add(NavigatorActionPopAll());
              },
            ),
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () {
                BlocProvider.of<NavigatorBloc>(context)
                    .add(NavigatorActionPop());
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProcessScreenTemplate(
        title: 'Es accionable?',
        lottie: 'assets/pro_actionable.json',
        description: 'Los elementos accionables son cosas que se pueden llevar a cabo y tienen un contexto, un tiempo, y requiren tiempo y energía.',
        alternativeFunction: alternativeFunction,
        continueFunction: continueFunction,
        userRepository: widget.userRepository,
        elementBeingProcessed: widget.element);
  }
}
