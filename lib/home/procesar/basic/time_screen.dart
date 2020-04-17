import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/core/core_blocs/navigator_bloc.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/home/elements/element_bloc.dart';
import 'package:gtd/home/procesar/basic/process_screen_template.dart';

class TimeStepScreen extends StatefulWidget {
  final GTDElement element;
  final UserRepository userRepository;

  TimeStepScreen({this.element, this.userRepository});

  @override
  _TimeStepScreenState createState() => _TimeStepScreenState();
}

class _TimeStepScreenState extends State<TimeStepScreen> {
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
          content: Text(
              'Si no te llevaría ni dos minutos hacerlo te recomendamos que lo hagas ya mismo :)'),
          actions: <Widget>[
            FlatButton(
              child: Text('Vale, lo haré'),
              onPressed: () {
                BlocProvider.of<ElementBloc>(context)
                    .add(MarkAsCompleted(element));
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
              child: Text('No tengo tiempo ahora'),
              onPressed: () {
                BlocProvider.of<NavigatorBloc>(context)
                    .add(NavigatorActionPop());
                BlocProvider.of<NavigatorBloc>(context).add(
                    GoToAsigneeStepScreen(
                        elementBeingProcessed: element,
                        userRepository: userRepository));
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
        title: 'Tardarías más de dos minutos en hacerlo?',
        lottie: null,
        description: 'Descripcion de tiempo',
        alternativeFunction: alternativeFunction,
        continueFunction: continueFunction,
        userRepository: widget.userRepository,
        elementBeingProcessed: widget.element);
  }
}
