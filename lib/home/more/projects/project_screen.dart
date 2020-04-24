import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/common/gtd_app_bar.dart';
import 'package:gtd/core/repositories/remote/project_repository.dart';
import 'package:gtd/home/more/projects/project_bloc.dart';
import 'package:gtd/home/more/projects/project_event.dart';
import 'package:gtd/home/more/projects/project_list.dart';
import 'package:gtd/home/more/projects/project_state.dart';

class ProjectScreen extends StatelessWidget {
  final ProjectBloc _projectBloc =
      ProjectBloc(projectRepository: ProjectRepositoryImpl());

  @override
  Widget build(BuildContext context) {
    _projectBloc.add(LoadProjects());

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
              ]),
        )),
      ),
      body: Column(
        children: [
          GTDAppBar(
            title: 'Proyectos',
            canSearch: false,
            factor: BarSizeFactor.Small,
          ),
          BlocConsumer<ProjectBloc, ProjectState>(listener: (context, state) {
            if (state is ProjectUpdated) {
              _showSnackbar(context, 'Proyecto actualizado.', isError: false);
            } else if (state is ProjectDeleted) {
              _showSnackbar(context, 'Proyecto eliminado.', isError: true);
            }
          }, builder: (context, state) {
            if (state is Loading) {
              return _showLoader(context);
            } else if (state is ProjectsSuccessfullyLoaded) {
              return ProjectList(state.projects);
            }
            return _showLoader(context);
          })
        ],
      ),
    );
  }

  Widget _showLoader(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.orange,
        ),
      ),
    );
  }

  _showSnackbar(BuildContext context, String message, {bool isError}) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(message),
              isError ? Icon(Icons.error) : Icon(Icons.check)
            ],
          ),
          backgroundColor: isError ? Colors.red : Colors.green,
        ),
      );
  }
}
