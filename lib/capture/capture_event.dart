import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gtd/core/models/gtd_element.dart';

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
  final File attachedImage;

  const Capture({@required this.summary, @required this.description, @required this.project, @required this.attachedImage});

    @override
  List<Object> get props => [summary, description, project, attachedImage];

  @override
  String toString() {
    return 'Element Captured { summary: $summary, description: $description, project: $project, image: $attachedImage}';
  }
}

class AttachImage extends CaptureEvent {
  final Image takenImage;
  final String fileName;
  final File imageFile;
  
  const AttachImage({@required this.takenImage, @required this.fileName, @required this.imageFile});

  @override
  // TODO: implement props
  List<Object> get props => [takenImage, fileName];

    @override
  String toString() {
    return 'AttachImage { fileName: $fileName }';
  }
}

class DeleteAttachedImage extends CaptureEvent {
  final GTDElement element;

  DeleteAttachedImage(this.element);

  @override
  // TODO: implement props
  List<Object> get props => [element];

    @override
  String toString() {
    return 'DeleteAttachedImage { Deleting image from: ${element.summary} }';
  }
}

class ClearForm extends CaptureEvent {
  ClearForm();

  @override
  // TODO: implement props
  List<Object> get props => [];

    @override
  String toString() {
    return 'ClearForm {  }';
  }
}

class DownloadAttachedImage extends CaptureEvent {
  final GTDElement element;

  DownloadAttachedImage(this.element);

  @override
  // TODO: implement props
  List<Object> get props => [element];

    @override
  String toString() {
    return 'DownloadAttachedImage { Downloading image from: ${element.imageRemotePath} }';
  }
}