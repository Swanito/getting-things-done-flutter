import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class NextEvent extends Equatable {
  const NextEvent();

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class HideCompletedElements extends NextEvent {
  final bool shouldBeHidden;

  const HideCompletedElements({@required this.shouldBeHidden});

  @override
  // TODO: implement props
  List<Object> get props => [shouldBeHidden];

  @override
  String toString() {
    // TODO: implement toString
    return '{ HideCompletedElements: { are hidden: $shouldBeHidden } }';
  }
}