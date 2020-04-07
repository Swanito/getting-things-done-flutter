part of 'element_bloc.dart';

class ElementState extends Equatable {
  const ElementState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadingElements extends ElementState {}

class SucessLoadingElements extends ElementState {
  final List<GTDElement> elements;

  const SucessLoadingElements([this.elements = const []]);

  @override
  List<Object> get props => [elements];

  @override
  String toString() => 'SucessLoadingElements { elements: $elements }';
}

class FailedLoadingElements extends ElementState {}
