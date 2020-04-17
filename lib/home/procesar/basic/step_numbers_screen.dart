import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/core/core_blocs/navigator_bloc.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/home/elements/element_bloc.dart';
import 'package:gtd/home/more/projects/project_bloc.dart';
import 'package:gtd/home/more/projects/project_event.dart';
import 'package:gtd/home/procesar/basic/basic_process.dart';
import 'package:gtd/home/procesar/basic/process_screen_template.dart';

class StepNumbersScreen extends StatefulWidget {
  final GTDElement element;
  final UserRepository userRepository;

  StepNumbersScreen({this.element, this.userRepository});

  @override
  _StepNumbersScreenState createState() => _StepNumbersScreenState();
}

class _StepNumbersScreenState extends State<StepNumbersScreen> {

  void continueFunction({GTDElement element, UserRepository userRepository}) {
    print('el elemento ${element.summary} es accionable');
    BlocProvider.of<NavigatorBloc>(context).add(GoToTimeStepScreen(
        elementBeingProcessed: element, userRepository: userRepository));
  }

  Future<void> alternativeFunction({GTDElement element, UserRepository userRepository}) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Veamos...'),
          content: Text(
              'Si no puedes realizarlo en un solo paso, quizá deberías crear un proyecto para llevarlo a cabo.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Crear Proyecto Nuevo'),
              onPressed: () {
                BlocProvider.of<ProjectBloc>(context).add(CreateProject(title: element.summary));
                BlocProvider.of<ElementBloc>(context).add(DeleteElement(element));
                BlocProvider.of<NavigatorBloc>(context)
                    .add(NavigatorActionPop());
                BlocProvider.of<NavigatorBloc>(context)
                    .add(NavigatorActionPop());
                BlocProvider.of<NavigatorBloc>(context)
                    .add(NavigatorActionPop());
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
      title: 'Se puede realizar en un solo paso?',
      lottie: null,
      description: 'Descripcion de accionable',
      alternativeFunction: alternativeFunction,
      continueFunction: continueFunction,
      userRepository: widget.userRepository,
      elementBeingProcessed: widget.element
    );
  }
}
