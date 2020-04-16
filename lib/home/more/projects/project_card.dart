import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/core/core_blocs/navigator_bloc.dart';
import 'package:gtd/core/models/gtd_project.dart';
import 'package:gtd/home/elements/element_bloc.dart';
import 'package:gtd/home/more/projects/project_bloc.dart';
import 'package:gtd/home/more/projects/project_event.dart';

class ProjectCard extends StatefulWidget {
  final Project project;
  ProjectCard({this.project});

  @override
  State<StatefulWidget> createState() {
    return ProjectCardState(project: project);
  }
}

class ProjectCardState extends State<ProjectCard> {
  TextEditingController _projectEditController;
  final Project project;
  ProjectBloc _projectBloc;

  @override
  void initState() {
    super.initState();
    _projectBloc = BlocProvider.of<ProjectBloc>(context);
  }

  ProjectCardState({this.project}): assert(project != null);

  @override
  Widget build(BuildContext context) {

    _projectEditController = TextEditingController(text: project.title);
    // _projectEditController = TextEditingController();
    print('Creating card for ' + project.title);
    print('Input Cntroller' + _projectEditController.text);
    return Card(
        child: Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 22.0, left: 22.0),
              child: Text(
                project.title,
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FlatButton(
                      onPressed: () {
                        BlocProvider.of<ProjectBloc>(context)
                            .add(DeleteProject(project));
                      },
                      child: Text('ELIMINAR',
                          style: TextStyle(color: Colors.orange))),
                  FlatButton(
                      onPressed: () => {
                        _showEditPop(context),
                      },
                      child: Text('EDITAR',
                          style: TextStyle(color: Colors.orange))),
                ],
              ),
            )
          ],
        )
      ],
    ));
  }

  void _showEditPop(BuildContext context) {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Nuevo nombre'),
            content: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _projectEditController,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.lightbulb_outline,
                        color: Colors.orange,
                        size: 13,
                      ),
                      labelText: 'Nombre del proyecto',
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
              FlatButton(onPressed: _onProjectEdited, child: Text('Guardar')),
            ],
          );
        },
      );
  }

  void _onProjectEdited() {
    _projectBloc.add(EditProject(
      title: _projectEditController.text,
      id: project.id
    ));
    BlocProvider.of<NavigatorBloc>(context).add(NavigatorActionPop());
  }

  @override
  void dispose() {
    _projectEditController.dispose();
    super.dispose();
  }
}
