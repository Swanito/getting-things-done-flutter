import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  TextEditingController _dateController = TextEditingController();
  String _elementContext;
  String _elementDate;

  Future<void> continueFunction(
      {GTDElement element, UserRepository userRepository}) {
    return showCalendarDialog(element, userRepository);
  }

  Future<void> alternativeFunction(
      {GTDElement element, UserRepository userRepository}) {
    return showAlternativeDialog(element, userRepository);
  }

  @override
  Widget build(BuildContext context) {
    return ProcessScreenTemplate(
        title: 'Tiene fecha límite?',
        lottie: 'assets/pro_calendar.json',
        description: 'Descripcion de tiempo',
        alternativeFunction: alternativeFunction,
        continueFunction: continueFunction,
        userRepository: widget.userRepository,
        elementBeingProcessed: widget.element);
  }

  Future<void> showAlternativeDialog(
      GTDElement element, UserRepository userRepository) {
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
                  enabledBorder:  UnderlineInputBorder(
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
                  setState(() => {
                        _elementContext = _contextController.text,
                        print(_elementContext)
                      })
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
                BlocProvider.of<ElementBloc>(context).add(Process(element));
                closeScreens();
              },
            ),
            FlatButton(
              child: Text('No, gracias'),
              onPressed: () {
                BlocProvider.of<ElementBloc>(context).add(Process(element));
                closeScreens();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showCalendarDialog(
      GTDElement element, UserRepository userRepository) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Veamos...'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Cual es la fecha de su realización?'),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.lightbulb_outline,
                    color: Colors.orange,
                    size: 13,
                  ),
                  labelText: 'Fecha',
                  labelStyle: TextStyle(color: Colors.orange),
                  hintStyle: TextStyle(color: Colors.orange),
                  enabledBorder:  UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.orange,
                        width: 1.0,
                        style: BorderStyle.solid),
                  ),
                ),
                onTap: () => _selectDate(context),
                keyboardType: TextInputType.text,
                autovalidate: true,
                readOnly: true,
                autocorrect: false,
                onChanged: (text) => {
                  setState(() => {
                        print(_elementDate)
                      })
                },
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Procesar'),
              onPressed: () {
                BlocProvider.of<ElementBloc>(context)
                    .add(AddDateToElement(element, _dateController.text));
                showAlternativeDialog(element, userRepository);
              },
            ),
            FlatButton(
              child: Text('No fijar la fecha.'),
              onPressed: () {
                showAlternativeDialog(element, userRepository);
              },
            ),
          ],
        );
      },
    );
  }

  void closeScreens() {
    BlocProvider.of<NavigatorBloc>(context).add(NavigatorActionPopAll());
  }

  Future<Null> _selectDate(BuildContext context) async {
      DateTime selectedDate = DateTime.now();

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        locale: const Locale('es', 'ES'),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = selectedDate.toLocal().toString().split(' ')[0];
      });
    }
  }
}
