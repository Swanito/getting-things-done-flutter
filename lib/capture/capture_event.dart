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

class AttachImage extends CaptureEvent {
  final Image takenImage;
  final String fileName;

  const AttachImage({@required this.takenImage, @required this.fileName});

  @override
  // TODO: implement props
  List<Object> get props => [takenImage, fileName];

    @override
  String toString() {
    return 'AttachImage { fileName: $fileName }';
  }
}

class DeleteAttachedImage extends CaptureEvent {
  DeleteAttachedImage();

  @override
  // TODO: implement props
  List<Object> get props => [];

    @override
  String toString() {
    return 'DeleteAttachedImage {  }';
  }
}