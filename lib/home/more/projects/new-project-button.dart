import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/core/core_blocs/navigator_bloc.dart';
import 'package:gtd/core/core_blocs/navigator_event.dart';
import 'package:gtd/home/more/projects/project_bloc.dart';
import 'package:gtd/home/more/projects/project_event.dart';
import 'package:gtd/home/more/projects/project_state.dart';

class NewProjectButton extends StatefulWidget {
  State<NewProjectButton> createState() => _NewProjectButtonState();
}

class _NewProjectButtonState extends State<NewProjectButton> {
  TextEditingController _projectInputController = TextEditingController();
  ProjectBloc _projectBloc;

  @override
  void initState() {
    super.initState();
    _projectBloc = BlocProvider.of<ProjectBloc>(context);
  }

  _showProjectPopUp(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dale un nombre al proyecto'),
          content: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _projectInputController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.lightbulb_outline,
                      color: Colors.orange,
                      size: 13,
                    ),
                    labelText: 'Nombre del proyecto',
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
                  autofocus: true,
                ),
              ),
            ],
          ),
          actions: [
            FlatButton(
                onPressed: () {
                  BlocProvider.of<NavigatorBloc>(context)
                      .add(NavigatorActionPop());
                },
                child: Text('Cancelar')),
            FlatButton(onPressed: _onProjectCreated, child: Text('Crear')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(builder: (context, state) {
      return FlatButton(
        onPressed: () => {_showProjectPopUp(context)},
        child: Text(
          'Nuevo Proyecto',
          style: TextStyle(
            color: Colors.orange,
          ),
        ),
      );
    });
  }

  void _onProjectCreated() {
    _projectBloc.add(CreateProject(title: _projectInputController.text));
    BlocProvider.of<NavigatorBloc>(context)
        .add(NavigatorActionPop());
  }

  @override
  void dispose() {
    _projectInputController.dispose();
    super.dispose();
  }
}
