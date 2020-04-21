import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gtd/core/models/gtd_element.dart';

class ProcessEvent extends Equatable {
  const ProcessEvent();

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class ProcessElement extends ProcessEvent {
  final GTDElement element;

  const ProcessElement({@required this.element});

  @override
  // TODO: implement props
  List<Object> get props => [element];

  @override
  String toString() {
    // TODO: implement toString
    return 'ProcessElement { element: $element }';
  }
}