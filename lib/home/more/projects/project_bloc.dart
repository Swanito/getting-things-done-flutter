import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/core/models/gtd_project.dart';
import 'package:gtd/core/repositories/repository.dart';
import 'package:gtd/home/more/projects/project_event.dart';
import 'package:gtd/home/more/projects/project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  ProjectRepository projectRepository;
  StreamSubscription _projectSubscription;

  ProjectBloc({@required this.projectRepository});

  @override
  // TODO: implement initialState
  get initialState => Loading();

  @override
  Stream<ProjectState> mapEventToState(event) async* {
    if (event is LoadProjects) {
      yield* _mapLoadToState();
    } else if (event is CreateProject) {
      yield* _mapCreateProjectsToState(event);
    } else if (event is ProjectsLoaded) {
      yield* _mapProjectsLoadedToState(event);
    } else if (event is DeleteProject) {
      yield* _mapDeleteProjectToState(event);
    } else if (event is EditProject) {
      yield* _mapEditProjectToState(event);
    }
  }

  Stream<ProjectState> _mapLoadToState() async* {
    _projectSubscription?.cancel();
    _projectSubscription = await projectRepository
        .getProjects().then((value) => 
          value.listen((projects) => add(ProjectsLoaded(projects)))
        );
  }

  Stream<ProjectState> _mapCreateProjectsToState(CreateProject event) async* {
    Project project = Project(event.title);
    projectRepository.createProject(project: project);
    yield Loading();
  }

  Stream<ProjectState> _mapProjectsLoadedToState(ProjectsLoaded event) async* {
    yield ProjectsSuccessfullyLoaded(event.projects);
  }

  Stream<ProjectState> _mapDeleteProjectToState(DeleteProject event) async* {
    projectRepository.deleteProject(event.project);
    yield Loading();
  }

  Stream<ProjectState> _mapEditProjectToState(EditProject event) async* {
    Project project = Project(event.title);
    projectRepository.updateProject(project: project, id: event.id);
    yield Loading();
  }
}
