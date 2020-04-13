import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/common/gtd_app_bar.dart';
import 'package:gtd/core/repositories/remote/project_repository.dart';
import 'package:gtd/home/more/projects/project_bloc.dart';
import 'package:gtd/home/more/projects/project_event.dart';
import 'package:gtd/home/more/projects/project_list.dart';
import 'package:gtd/home/more/projects/project_state.dart';

class ProjectScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProjectScreenState();
  }
}

class ProjectScreenState extends State<ProjectScreen> {
  ProjectBloc _projectBloc =
      ProjectBloc(projectRepository: ProjectRepositoryImpl());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
            decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.topLeft,
              colors: [
                Colors.orange[600],
                Colors.orange[400],
                Colors.orange[200],
                // Colors.orange[100],
              ]),
        )),
      ),
      body: Column(
        children: [
          GTDAppBar(
            title: 'Proyectos',
            canSearch: true,
            factor: BarSizeFactor.Small,
          ),
          MultiBlocProvider(
            providers: [
              BlocProvider<ProjectBloc>(
                create: (context) {
                  return _projectBloc..add(LoadProjects());
                },
              )
            ],
            child: BlocBuilder<ProjectBloc, ProjectState>(
                builder: (context, state) {
              if (state is Loading) {
                return Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                );
              } else if (state is ProjectsSuccessfullyLoaded) {
                for (var project in state.projects) {
                  print('projects in project screen' + project.title);
                }
                return ProjectList(state.projects);
              } else if (state is ProjectUpdated) {
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Proyecto actualizado!')));
              }
            }),
          )
        ],
      ),
    );
  }
}
