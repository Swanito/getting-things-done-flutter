import 'package:equatable/equatable.dart';
import 'package:gtd/core/models/gtd_project.dart';

abstract class ProjectEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadProjects extends ProjectEvent {}

class ProjectsLoaded extends ProjectEvent {
  final List<Project> projects;

  ProjectsLoaded(this.projects);

  @override
  // TODO: implement props
  List<Object> get props => [projects];

  @override
  String toString() => 'Projects Loaded: { Projects: $projects }';
}

class CreateProject extends ProjectEvent {
  final String title;

  CreateProject({this.title});

  @override
  // TODO: implement props
  List<Object> get props => [title];

  @override
  String toString() => 'CreateProject: { CreateProject: $title }';
}

class DeleteProject extends ProjectEvent {
  final Project project;

  DeleteProject(this.project);

  @override
  List<Object> get props => [project];

  @override
  String toString() => 'DeleteProject { project: $project }';
}

class EditProject extends ProjectEvent {
  final Project project;
final String title;
final String id;

  EditProject({this.id, this.title, this.project});

  @override
  List<Object> get props => [title, id];

  @override
  String toString() => 'EditProject { project id: $id, project title: $title }';
}