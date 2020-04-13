import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gtd/core/models/gtd_project.dart';

class CaptureEvent extends Equatable {
 const CaptureEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
  
}

class Capture extends CaptureEvent {
  final String summary;
  final String description;
  final String project;

  const Capture({@required this.summary, @required this.description, @required this.project});

    @override
  List<Object> get props => [summary, description, project];

  @override
  String toString() {
    return 'Element Captured { summary: $summary, description: $description, project: $project }';
  }
}
