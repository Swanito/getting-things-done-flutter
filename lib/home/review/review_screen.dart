import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/common/gtd_app_bar.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/home/elements/element_bloc.dart';
import 'package:gtd/home/more/projects/project_bloc.dart';
import 'package:gtd/home/more/projects/project_state.dart';
import 'package:gtd/home/review/review_list.dart';

class ReviewScreen extends StatelessWidget {
  final UserRepository _userRepository;

  ReviewScreen({Key key, UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

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
              ]),
        )),
      ),
      body: Column(
        children: [
          GTDAppBar(title: 'Revisar'),
          MultiBlocListener(
            listeners: [
              BlocListener<ElementBloc, ElementState>(
                listener: (context, state) {
                  if(state is FailedLoadingElements) {
                    _showSnackbar(context, 'Error recuperando los elementos', isError: true);
                  } 
                },
              ),
              BlocListener<ProjectBloc, ProjectState>(
                listener: (context, state) {
                if(state is FailedLoadingProjects) {
                    _showSnackbar(context, 'Error recuperando los proyectos', isError: true);
                  } 
                },
              ),
            ],
            child: BlocBuilder<ElementBloc, ElementState>(builder: (context, elementState) {
              return BlocBuilder<ProjectBloc, ProjectState>(builder: (context, projectState) {
                  if (elementState is SucessLoadingElements && projectState is ProjectsSuccessfullyLoaded) {
                    return ReviewList(elements: elementState.elements, projects: projectState.projects);
                  } else {
                    return _showLoading(context);
                  }
              });
            }),
          )
        ],
      ),
    );
  }

  Widget _showLoading(BuildContext context) {
    return Center(child: Container( child: CircularProgressIndicator()),);
  }

  void _showSnackbar(BuildContext context, String message, {bool isError}) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: isError ? Colors.red : Colors.green,));
  }}
