import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gtd/core/models/gtd_project.dart';

abstract class ProjectState extends Equatable {
  const ProjectState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class Loading extends ProjectState {}

class ProjectsSuccessfullyLoaded extends ProjectState {
  final List<Project> projects;

  const ProjectsSuccessfullyLoaded([this.projects = const []]);

  @override
  // TODO: implement props
  List<Object> get props => [projects];

  String toString() => 'Loaded: $projects'; 
}

class ProjectUpdated extends ProjectState {}