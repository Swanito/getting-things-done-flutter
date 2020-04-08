part of 'element_bloc.dart';

class ElementEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
  
}

class LoadElements extends ElementEvent {

}

class LoadElement extends ElementEvent {
  
}

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