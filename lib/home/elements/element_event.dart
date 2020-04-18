part of 'element_bloc.dart';

class ElementEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadElements extends ElementEvent {}

class LoadElement extends ElementEvent {}

class CreateElement extends ElementEvent {
  final GTDElement element;

  CreateElement(this.element);

  @override
  List<Object> get props => [element];

  @override
  String toString() => 'CreateElement { element: $element }';
}

class DeleteElement extends ElementEvent {
  final GTDElement element;

  DeleteElement(this.element);

  @override
  List<Object> get props => [element];

  @override
  String toString() => 'DeleteElement { element: $element }';
}

class UpdateElement extends ElementEvent {
  final GTDElement element;

  UpdateElement(this.element);

  @override
  List<Object> get props => [element];

  @override
  String toString() => 'UpdateElement { element: $element }';
}

class MarkAsCompleted extends ElementEvent {
  final GTDElement element;

  MarkAsCompleted(this.element);

  @override
  List<Object> get props => [element];

  @override
  String toString() => 'MarkAsCompleted { element: $element }';
}

class UnmarkAsCompleted extends ElementEvent {
  final GTDElement element;

  UnmarkAsCompleted(this.element);

  @override
  List<Object> get props => [element];

  @override
  String toString() => 'MarkAsCompleted { element: $element }';
}

class ElementsUpdated extends ElementEvent {
  final List<GTDElement> elements;

  ElementsUpdated(this.elements);

  @override
  List<Object> get props => [elements];

  @override
  String toString() => 'ElementsUpdated { elements: $elements }';
}

class MoveToDelete extends ElementEvent {
  final GTDElement element;

  MoveToDelete(this.element);

  @override
  List<Object> get props => [element];

  @override
  String toString() => 'MoveToDelete { element: $element }';
}

class MoveToReference extends ElementEvent {
  final GTDElement element;

  MoveToReference(this.element);

  @override
  List<Object> get props => [element];

  @override
  String toString() => 'MoveToReference { element: $element }';
}

class MoveToWaintingFor extends ElementEvent {
  final GTDElement element;
  final String asignee;

  MoveToWaintingFor(this.element, this.asignee);

  @override
  List<Object> get props => [element, asignee];

  @override
  String toString() =>
      'MoveToWaintingFor { element: $element, waiting for: $asignee }';
}

class Process extends ElementEvent {
  GTDElement elementToBeProcessed;

  Process(this.elementToBeProcessed);

  @override
  List<Object> get props => [elementToBeProcessed];

  @override
  String toString() => 'Process { Process: $elementToBeProcessed }';
}

class AddContextToElement extends ElementEvent {
  GTDElement elementToBeProcessed;
  String context;

  AddContextToElement(this.elementToBeProcessed, this.context);

  @override
  List<Object> get props => [elementToBeProcessed, context];

  @override
  String toString() =>
      'Process { AddContextToElement: $elementToBeProcessed, context: $context }';
}
class AddDateToElement extends ElementEvent {
  GTDElement elementToBeProcessed;
  String date;

  AddDateToElement(this.elementToBeProcessed, this.date);

  @override
  List<Object> get props => [elementToBeProcessed, date];

  @override
  String toString() =>
      'Process { AddDateToElement: $elementToBeProcessed, date: $date }';
}

class AddProjectToElement extends ElementEvent {
  GTDElement elementToBeProcessed;
  String projectTitle;

  AddProjectToElement(this.elementToBeProcessed, this.projectTitle);

  @override
  List<Object> get props => [elementToBeProcessed, projectTitle];

  @override
  String toString() =>
      'Process { AddProjectToElement: $elementToBeProcessed, projectTitle: $projectTitle }';
}