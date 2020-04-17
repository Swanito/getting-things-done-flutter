import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/core/core_blocs/navigator_bloc.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/home/elements/element_bloc.dart';
import 'package:gtd/home/procesar/basic/process_screen_template.dart';

class AssigneStepScreen extends StatefulWidget {
  final GTDElement element;
  final UserRepository userRepository;

  AssigneStepScreen({this.element, this.userRepository});

  @override
  _AssigneStepScreenState createState() => _AssigneStepScreenState();
}

class _AssigneStepScreenState extends State<AssigneStepScreen> {

    TextEditingController _asigneeController = TextEditingController();
String _asignee = "";

  void continueFunction({GTDElement element, UserRepository userRepository}) {
    BlocProvider.of<NavigatorBloc>(context).add(GoToCalendarStepScreen(
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
                  'Si no es tu responsabilidad, lo moveremos a la lista En Espera.'),
              TextFormField(
                controller: _asigneeController,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.lightbulb_outline,
                    color: Colors.orange,
                    size: 13,
                  ),
                  labelText: 'Quién tiene que hacerlo?',
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
                  _asignee = _asigneeController.text,
                  print(_asignee)
                })},
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Delegar'),
              onPressed: () {
                      BlocProvider.of<ElementBloc>(context)
                          .add(MoveToWaintingFor(element, _asignee));
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
                    }
            ),
            FlatButton(
              child: Text('Lo haré yo mismo'),
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
        title: 'Es tu responsabilidad hacerlo?',
        lottie: null,
        description: 'Descripcion de tiempo',
        alternativeFunction: alternativeFunction,
        continueFunction: continueFunction,
        userRepository: widget.userRepository,
        elementBeingProcessed: widget.element);
  }
}
