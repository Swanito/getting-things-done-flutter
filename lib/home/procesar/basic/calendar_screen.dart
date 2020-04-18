import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/core/core_blocs/navigator_bloc.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/home/elements/element_bloc.dart';
import 'package:gtd/home/procesar/basic/process_screen_template.dart';

class CalendarStepScreen extends StatefulWidget {
  final GTDElement element;
  final UserRepository userRepository;


  CalendarStepScreen({this.element, this.userRepository});

  @override
  _CalendarStepScreenState createState() => _CalendarStepScreenState();
}

class _CalendarStepScreenState extends State<CalendarStepScreen> {

  TextEditingController _contextController = TextEditingController();
  String _elementContext;

  void continueFunction({GTDElement element, UserRepository userRepository}) {
    BlocProvider.of<NavigatorBloc>(context).add(GoToAsigneeStepScreen(
        elementBeingProcessed: element, userRepository: userRepository));
  }

  Future<void> alternativeFunction(
      {GTDElement element, UserRepository userRepository}) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Veamos...'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                  'Quieres añadir algún contexto? Esto te ayudará a identificar el ámbito de la tarea. Añade uno o más contextos separados por una coma.'),
              TextFormField(
                controller: _contextController,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.lightbulb_outline,
                    color: Colors.orange,
                    size: 13,
                  ),
                  labelText: 'Contextos',
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
                onChanged: (text) => {
                  setState(() =>
                      {_elementContext = _contextController.text, print(_elementContext)})
                },
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Crear contexto'),
              onPressed: () {
                BlocProvider.of<ElementBloc>(context)
                    .add(AddContextToElement(element, _elementContext));
                BlocProvider.of<ElementBloc>(context)
                    .add(Process(element));
                BlocProvider.of<NavigatorBloc>(context)
                    .add(NavigatorActionPop());
                BlocProvider.of<NavigatorBloc>(context)
                    .add(NavigatorActionPop());
                BlocProvider.of<NavigatorBloc>(context)
                    .add(NavigatorActionPop());
                BlocProvider.of<NavigatorBloc>(context)
                    .add(NavigatorActionPop());
                BlocProvider.of<NavigatorBloc>(context)
                    .add(NavigatorActionPop());
                BlocProvider.of<NavigatorBloc>(context)
                    .add(NavigatorActionPop());
              },
            ),
            FlatButton(
              child: Text('No, gracias'),
              onPressed: () {
                BlocProvider.of<ElementBloc>(context)
                    .add(Process(element));
                BlocProvider.of<NavigatorBloc>(context)
                    .add(NavigatorActionPop());
                BlocProvider.of<NavigatorBloc>(context)
                    .add(NavigatorActionPop());
                BlocProvider.of<NavigatorBloc>(context)
                    .add(NavigatorActionPop());
                BlocProvider.of<NavigatorBloc>(context)
                    .add(NavigatorActionPop());
                BlocProvider.of<NavigatorBloc>(context)
                    .add(NavigatorActionPop());
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
        title: 'Tiene fecha límite?',
        lottie: null,
        description: 'Descripcion de tiempo',
        alternativeFunction: alternativeFunction,
        continueFunction: continueFunction,
        userRepository: widget.userRepository,
        elementBeingProcessed: widget.element);
  }
}
