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

class ImageAttached extends CaptureState {
  final Image attachedImage;
  final String  fileName;

  const ImageAttached({@required this.attachedImage, @required this.fileName});

  @override
  // TODO: implement props
  List<Object> get props => [attachedImage, fileName];

  @override
  String toString() => 'ImageAttached: { fileName: $fileName }';    

}