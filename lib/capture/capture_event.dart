import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CaptureEvent extends Equatable {
 const CaptureEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
  
}

class Capture extends CaptureEvent {
  final String summary;
  final String description;

  const Capture({@required this.summary, @required this.description});

    @override
  List<Object> get props => [summary, description];

  @override
  String toString() {
    return 'Element Captured { summary: $summary, description: $description }';
  }
}