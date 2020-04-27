import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/core/repositories/repository.dart';
import 'package:gtd/home/elements/element_bloc.dart';
import 'package:gtd/home/procesar/advanced/advanced_process_form.dart';
import 'package:mockito/mockito.dart';

class MockElementBloc extends MockBloc<ElementEvent, ElementState>
    implements ElementBloc {}

class MockElementRepository extends Mock implements ElementRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final MockElementRepository _mockElementRepository = MockElementRepository();
  final GTDElement element = GTDElement('Element 1');

  blocTest('element bloc initial status is correct',
      build: () async => ElementBloc(elementRepository: _mockElementRepository),
      skip: 0,
      expect: [LoadingElements()]);

  blocTest(
    'MarkAsCompleted yields ElementCompleted',
    build: () async {
      return ElementBloc(elementRepository: _mockElementRepository);
    },
    act: (bloc) => bloc.add(MarkAsCompleted(element)),
    expect: [ElementCompleted(element)],
  );

  blocTest(
    'Process yields ElementProcessed',
    build: () async {
      return ElementBloc(elementRepository: _mockElementRepository);
    },
    act: (bloc) => bloc.add(Process(element)),
    expect: [ElementProcessed()],
  );

  blocTest(
    'MoveToDelete yields ElementDeleted',
    build: () async {
      return ElementBloc(elementRepository: _mockElementRepository);
    },
    act: (bloc) => bloc.add(MoveToDelete(element)),
    expect: [ElementDeleted()],
  );

  blocTest(
    'MoveToReference yields ElementProcessed',
    build: () async {
      return ElementBloc(elementRepository: _mockElementRepository);
    },
    act: (bloc) => bloc.add(MoveToReference(element)),
    expect: [ElementProcessed()],
  );

  blocTest(
    'MoveToWaintingFor yields ElementProcessed',
    build: () async {
      return ElementBloc(elementRepository: _mockElementRepository);
    },
    act: (bloc) => bloc.add(MoveToWaintingFor(element, 'Jon')),
    expect: [ElementProcessed()],
  );

  blocTest(
    'AddContextToElement yields nothing',
    build: () async {
      return ElementBloc(elementRepository: _mockElementRepository);
    },
    act: (bloc) =>
        bloc.add(AddContextToElement(element, 'Contexto 1, Contexto 2')),
    expect: [],
  );

  blocTest(
    'AddDateToElement yields nothing',
    build: () async {
      return ElementBloc(elementRepository: _mockElementRepository);
    },
    act: (bloc) => bloc.add(AddDateToElement(element, '12-12-1990')),
    expect: [],
  );

  blocTest(
    'AddProjectToElement yields nothing',
    build: () async {
      return ElementBloc(elementRepository: _mockElementRepository);
    },
    act: (bloc) =>
        bloc.add(AddProjectToElement(element, 'Titulo del proyecto')),
    expect: [],
  );

  blocTest(
    'AddDescriptionToElement yields nothing',
    build: () async {
      return ElementBloc(elementRepository: _mockElementRepository);
    },
    act: (bloc) =>
        bloc.add(AddDescriptionToElement(element, 'Descripcion del elemento')),
    expect: [],
  );

  blocTest(
    'AddTitleToElement yields nothing',
    build: () async {
      return ElementBloc(elementRepository: _mockElementRepository);
    },
    act: (bloc) => bloc.add(AddTitleToElement(element, 'Titulo del elemento')),
    expect: [],
  );

  blocTest(
    'AddRecurrencyToElement yields nothing',
    build: () async {
      return ElementBloc(elementRepository: _mockElementRepository);
    },
    act: (bloc) => bloc.add(AddRecurrencyToElement(element, 1, DatePeriod.DAY)),
    expect: [],
  );

  blocTest(
    'AddImageToElement yields nothing',
    build: () async {
      return ElementBloc(elementRepository: _mockElementRepository);
    },
    act: (bloc) => bloc.add(AddImageToElement(
        element: element,
        fileName: 'Titulo',
        imageFile: null,
        takenImage: null)),
    expect: [],
  );
}
