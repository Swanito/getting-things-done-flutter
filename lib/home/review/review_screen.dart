import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/common/gtd_app_bar.dart';
import 'package:gtd/core/repositories/remote/element_repository.dart';
import 'package:gtd/core/repositories/remote/project_repository.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/home/elements/element_bloc.dart';
import 'package:gtd/home/more/projects/project_bloc.dart';
import 'package:gtd/home/more/projects/project_event.dart';
import 'package:gtd/home/more/projects/project_state.dart';

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
                // Colors.orange[100],
              ]),
        )),
      ),
      body: Column(
        children: [
          GTDAppBar(title: 'Revisar'),
          MultiBlocProvider(
              providers: [
                BlocProvider<ElementBloc>(create: (context) {
                  return ElementBloc(
                    elementRepository: ElementRepositoryImpl(),
                  )..add(LoadElements());
                }),
                BlocProvider<ProjectBloc>(
                  create: (context) {
                    return ProjectBloc(
                      projectRepository: ProjectRepositoryImpl(),
                    )..add(LoadProjects());
                  },
                )
              ],
              child: MultiBlocListener(
                listeners: [
                  BlocListener<ElementBloc, ElementState>(
                    listener: (context, state) {

                    },
                  ),
                  BlocListener<ProjectBloc, ProjectState>(
                    listener: (context, state) {

                    },
                  ),
                ],
                child: Container(),
              ))
        ],
      ),
    );
  }
}
