import 'package:equatable/equatable.dart';

abstract class NextState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class CompletedElementsHidden extends NextState {}

class CompletedElementsShown extends NextState {}

