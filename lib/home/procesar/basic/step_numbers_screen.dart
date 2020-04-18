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

  TextEditingController _projectController = TextEditingController();
  String _projectTitle;

  void continueFunction({GTDElement element, UserRepository userRepository}) {
    showProjectDialog(element, userRepository);
  }

  Future<void> alternativeFunction(
      {GTDElement element, UserRepository userRepository}) {
    showCreateProjectDialog(element, userRepository);
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
        elementBeingProcessed: widget.element);
  }

  Future<void> showProjectDialog(
      GTDElement element, UserRepository userRepository) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Veamos...'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Quieres añadir el elemento a algún proyecto existente? Si no encontramos el proyecto, lo crearemos.'),
              TextFormField(
                controller: _projectController,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.lightbulb_outline,
                    color: Colors.orange,
                    size: 13,
                  ),
                  labelText: 'A qué proyecto?',
                  labelStyle: TextStyle(color: Colors.orange),
                  hintStyle: TextStyle(color: Colors.orange),
                  enabledBorder: new UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.orange,
                        width: 1.0,
                        style: BorderStyle.solid),
                  ),
                ),
                keyboardType: TextInputType.text,
                autovalidate: true,
                autocorrect: false,
                onChanged: (text) => {setState(() => {
                  _projectTitle = _projectController.text,
                  print(_projectTitle)
                })},
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Añadirlo al proyecto'),
              onPressed: () {
                BlocProvider.of<ElementBloc>(context)
                    .add(AddProjectToElement(element, _projectTitle));
                BlocProvider.of<NavigatorBloc>(context).add(NavigatorActionPop());
                BlocProvider.of<NavigatorBloc>(context).add(GoToTimeStepScreen(
                    elementBeingProcessed: element,
                    userRepository: userRepository));
              },
            ),
            FlatButton(
              child: Text('No, gracias'),
              onPressed: () {
                BlocProvider.of<NavigatorBloc>(context).add(GoToTimeStepScreen(
                    elementBeingProcessed: element,
                    userRepository: userRepository));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showCreateProjectDialog(
      GTDElement element, UserRepository userRepository) {
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
                BlocProvider.of<ProjectBloc>(context)
                    .add(CreateProject(title: element.summary));
                BlocProvider.of<ElementBloc>(context)
                    .add(DeleteElement(element));
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
}
