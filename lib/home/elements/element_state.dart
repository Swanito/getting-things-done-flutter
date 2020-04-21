part of 'element_bloc.dart';

class ElementState extends Equatable {
  const ElementState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadingElements extends ElementState {}
class ElementProcessed extends ElementState {}
class ElementDeleted extends ElementState {}

class SucessLoadingElements extends ElementState {
  final List<GTDElement> elements;

  const SucessLoadingElements([this.elements = const []]);

  @override
  List<Object> get props => [elements];
}

class FailedLoadingElements extends ElementState {}

class StartingAdvancedProcessing extends ElementState {
  final GTDElement element;

  const StartingAdvancedProcessing([this.element]);

  @override
  List<Object> get props => [element];

  @override
  String toString() => 'StartingAdvancedProcessing { element to be processed: $element }';
}

class StartingBasicProcessing extends ElementState {
    final GTDElement element;

  const StartingBasicProcessing([this.element]);

  @override
  List<Object> get props => [element];

  @override
  String toString() => 'StartingBasicProcessing { element to be processed: $element }';
}