import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CaptureState extends Equatable {

  const CaptureState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class EmptyState extends CaptureState {}

class Captured extends CaptureState {}

class ErrorCapturing extends CaptureState {}

class ErrorDownloadingImage extends CaptureState {}

class ImageAttached extends CaptureState {
  final Image attachedImage;
  final String fileName;
  final File imageFile;

  const ImageAttached({@required this.attachedImage, @required this.fileName, @required this.imageFile});

  @override
  // TODO: implement props
  List<Object> get props => [attachedImage, fileName, imageFile];

  @override
  String toString() => 'ImageAttached: { fileName: $fileName }';    
}

class ImageDownloaded extends CaptureState {
  final Image attachedImage;
  final String fileName;
  final File imageFile;

  const ImageDownloaded({@required this.attachedImage, @required this.fileName, this.imageFile});

  @override
  // TODO: implement props
  List<Object> get props => [attachedImage, fileName, imageFile];

  @override
  String toString() => 'ImageAttached: { fileName: $fileName }';    
}